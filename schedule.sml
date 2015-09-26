open Conflict

fun available_for_rehearsal (a: available)
                            (reh : rehearsal)
                            (other_rehs : (rehearsal * period) list)
                            (filter_to_use : conflict -> bool) =
    let val a' = List.foldl
                     (fn ({conflicts, ...}, a) =>
                         intersect_with_conflicts
                             a
                             (filter_conflicts filter_to_use conflicts))
                     a (#actors reh)
        val a'' = List.foldl (fn ((r, p), a) =>
                                 if actors_overlap r reh then
                                     intersect_with_conflict a
                                         {time = p, pri = Hard,
                                          actor_name = ""}
                                 else a)
                             a' other_rehs
        val a''' = carve (#length reh) a''
(*        val a''' = filter_available
                       (fn p => length p > #length reh) a'' *)
    in
        a'''
    end

exception Impossible

type state = {to_schedule : rehearsal list,
              already_scheduled : (rehearsal * period) list}

fun score {to_schedule, already_scheduled} =
    let fun needed actor (reh: rehearsal) =
            List.exists (same_actor actor) (#actors reh)
        fun week date =
            let val diff = Time.toSeconds (Date.toTime date) -
                           Time.toSeconds (Date.toTime rehearsals_start)
            in
                Int.div (LargeInt.toInt (diff),
                         60 * 60 * 24 * 7)
            end
        fun mins_per_week actor =
            List.foldl
                (fn ((r, p), v) =>
                    let val w = week (#start p)
                        val n = Vector.sub (v, w)
                    in
                        Vector.update (v, w, n + (#length r))
                    end)
                (Vector.tabulate (rehearsal_weeks, (fn _ => 0)))
                already_scheduled
        fun max_mins_per_week actor =
            Vector.foldl Int.max 0 (mins_per_week actor)
        val mins_per_week_score =
            List.foldl op- 0 (List.map max_mins_per_week actors)
        fun day date =
            let val diff = Time.toSeconds (Date.toTime date) -
                           Time.toSeconds (Date.toTime rehearsals_start)
            in
                Int.div (LargeInt.toInt (diff),
                         60 * 60 * 24)
            end
        fun mins_per_day actor =
            List.foldl
                (fn ((r, p), v) =>
                    let val w = day (#start p)
                        val n = Vector.sub (v, w)
                    in
                        Vector.update (v, w, n + (#length r))
                    end)
                (Vector.tabulate (rehearsal_days, (fn _ => 0)))
                already_scheduled
        fun max_mins_per_day actor =
            Vector.foldl Int.max 0 (mins_per_day actor)
        val mins_per_day_score =
            List.foldl op- 0 (List.map max_mins_per_day actors)
        fun gaps_for_actor actor =
            let val rehs = List.map (fn (_, p) => p)
                                    (List.filter
                                         (fn (r, p) => needed actor r)
                                         already_scheduled)
                val srehs = sort_by_start rehs
                fun tot_gaps l =
                    case l of
                        [] => 0
                      | [p] => 0
                      | {start = start1, finish = finish1}::
                        {start = start2, finish = finish2}::t =>
                        let val gap =
                                LargeInt.toInt
                                    (Time.toSeconds (Date.toTime start2) -
                                     Time.toSeconds (Date.toTime finish1))
                            val restgaps = tot_gaps
                                              ({start = start2, finish = finish2}::t)
                        in
                            if gap > 5 * 60 * 60 then restgaps
                            else gap + restgaps
                        end
            in
                Int.div (tot_gaps srehs, 5)
            end
        val gap_score =
            List.foldl op- 0 (List.map gaps_for_actor actors)
    in
        mins_per_week_score + mins_per_day_score + gap_score +
        (List.length already_scheduled * 240 * (List.length actors))
    end

fun best_time (r: rehearsal) (ps: period list) ({to_schedule, already_scheduled}) =
    List.foldl
        (fn (p, c) =>
            let val news = score {to_schedule = to_schedule,
                                  already_scheduled = (r, p)::already_scheduled}
            in
                case c of
                    NONE => SOME (p, news, [])
                  | SOME (maxp, maxs, rest) =>
                    if news > maxs then SOME (p, news, maxp::rest)
                    else SOME (maxp, maxs, p::rest)
            end)
        NONE
        ps

fun schedule (s as {to_schedule, already_scheduled} : state)
             (rehearsal_period : available)
             (filter_to_use : conflict -> bool)
    : state
    =
    let val avs =
            List.map (fn r => (r, available_for_rehearsal
                                      rehearsal_period
                                      r
                                      already_scheduled
                                      filter_to_use))
                     to_schedule
        val (rest, imp) = List.partition (fn (_, a) => available_times a > 0) avs
        val to_schedule' = List.map (#1) rest
        val imp = List.map (#1) imp
        val _  = print ("Impossible: " ^ (Int.toString (List.length imp)) ^
                        "\n")
        val s' = {to_schedule = to_schedule',
                  already_scheduled = already_scheduled}
        fun addback {to_schedule, already_scheduled} =
            {to_schedule = imp @ to_schedule,
             already_scheduled = already_scheduled}
        fun schedule_int (s as {to_schedule, already_scheduled})
                         best_s
                         best_score
            =
    case to_schedule of
        [] => if score s > best_score then s else best_s
      | _ =>
        let (*val _ = print ((Int.toString (List.length already_scheduled)) ^ "\n") *)
            val avs =
                List.map (fn r => (r, available_for_rehearsal
                                          rehearsal_period
                                          r
                                          already_scheduled
                                          filter_to_use))
                         to_schedule
            fun most_constrained (ps, mc, l, r) =
                case l of
                    [] => (mc, r)
                  | (reh, h)::t =>
                    if (available_times h) = 0 then
                        (NONE, r)
                    else if (available_times h) < ps then
                        case mc of
                            NONE =>
                            most_constrained
                                (available_times h, SOME (reh, h), t, r)
                          | SOME mcs =>
                            most_constrained
                                (available_times h, SOME (reh, h), t, mcs::r)
                    else
                        most_constrained (ps, mc, t, (reh, h)::r)
            val maxint = case Int.maxInt of
                             NONE => 100000
                           | SOME n => n
            val (mc, r) =  most_constrained (maxint, NONE, avs, [])
            fun descend mcr l best_s best_score n =
                if n = 3 then
                    if score s > best_score then s else best_s
                else
                case best_time mcr l s of
                    NONE =>
                    if score s > best_score then s else best_s
                  | SOME (h, _, t) =>
                    let val s =
                            schedule_int
                                {to_schedule = List.map (fn v => #1 v) r,
                                 already_scheduled =
                                 ((mcr, h)::already_scheduled)}
                                best_s best_score
                    in
                        if score s > best_score
                        then descend mcr t s (score s) (n + 1)
                        else descend mcr t best_s best_score (n + 1)
                    end
        in
            case mc of
                NONE =>
                if score s > best_score then s else best_s
              | SOME (mcr, mcav) => descend mcr (to_list mcav) best_s best_score 0
        end
    in
        addback (schedule_int s' s' (score s'))
    end
