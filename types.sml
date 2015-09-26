fun date_diff d1 d2 =
    LargeInt.toInt (LargeInt.div ((Time.toSeconds (Date.toTime d1)) -
     (Time.toSeconds (Date.toTime d2)), LargeInt.fromInt 60))

type period = { start : Date.date,
                finish : Date.date } (* Invariant: start < end *)

fun le (d1, d2) = Time.<= (Date.toTime d1, Date.toTime d2)
fun lt (d1, d2) = Time.< (Date.toTime d1, Date.toTime d2)

fun length ({start, finish} : period) = date_diff finish start

fun sort_by_start l =
            case l of
                [] => []
              | [h] => [h]
              | {start = hstart, finish = hfinish}::t =>
                let val (l1, l2) = List.partition
                                       (fn {start, finish} => le (start, hstart)) t
                in
                    (sort_by_start l1)@[{start = hstart, finish = hfinish}]
                    @(sort_by_start l2)
                end

signature CONFLICT =
sig

datatype conflict_type = Hard | Ifneedbe of int | Soft of int

type conflict = { time : period,
                  pri : conflict_type,
                  actor_name : string }

type conflicts

val insert_conflict : conflict * conflicts -> conflicts

val conflicts_from_list : conflict list -> conflicts

val find_conflict : conflicts -> Time.time -> conflict option

type available

val intersect_with_conflicts : available -> conflicts -> available

val intersect_with_conflict : available -> conflict -> available

val filter_conflicts : (conflict -> bool) -> conflicts -> conflicts

val to_list : available -> period list

val from_period_list : period list -> available

val available_times : available -> int

val filter_available : (period -> bool) -> available -> available

val carve : int -> available -> available

end

structure Conflict :> CONFLICT =
struct

datatype conflict_type = Hard | Ifneedbe of int | Soft of int

type conflict = { time : period,
                  pri : conflict_type,
                  actor_name : string }

type conflicts = (Time.time * conflict) list
(* Invariant: sorted by start time *)

fun insert_conflict ((c, cl) : conflict * conflicts) =
    let val t = Date.toTime (#start (#time c))
        fun insert_conflict_int cl =
            case cl of
                [] => [(t, c)]
              | (th, ch)::clt => if Time.< (t, th) then
                                     (t, c)::(th, ch)::clt
                                 else
                                     (th, ch)::(insert_conflict_int clt)
    in
        insert_conflict_int cl
    end

fun conflicts_from_list (l : conflict list) =
    List.foldl insert_conflict [] l

fun find_conflict cl t =
    case cl of
        [] => NONE
      | (th, ch)::clt =>
        if Time.< (th, t) then SOME ch else
        find_conflict clt t

type available = period list
(* Invariant: sorted by time, non-overlapping *)

fun intersect_with_conflicts (al: available) (cl : conflicts) : available =
    case (al, cl) of
        (_, []) => al
      | ([], _) => []
      | ({start, finish}::alt,
         (_, {time = {start = cstart, finish = cfinish}, pri = pri,
              actor_name = actor_name, ...})::clt) =>
        if le (cstart, start) then
            if le (cfinish, start) then
                 intersect_with_conflicts al clt
            else if le (finish, cfinish) then
                intersect_with_conflicts alt cl
            else
                intersect_with_conflicts
                    ({start = cfinish, finish = finish}::alt)
                    clt
        else
            if le (finish, cstart) then
                {start = start, finish = finish}::
                (intersect_with_conflicts alt cl)
            else
                if lt (cfinish, finish) then
                    {start = start, finish = cstart}::
                    (intersect_with_conflicts
                         ({start = cfinish, finish = finish}::alt)
                         clt)
                else
                    {start = start, finish = cstart}::
                    (intersect_with_conflicts alt cl)

fun intersect_with_conflict (al: available) (c: conflict) =
    intersect_with_conflicts al [(Date.toTime (#start (#time c)), c)]

fun filter_conflicts (filter_to_use : conflict -> bool) (cs: conflicts) =
    List.filter (fn (_, c) => filter_to_use c) cs

fun to_list al = al

fun from_period_list pl =
    let val spl = sort_by_start pl
        fun from_sorted_list l =
            case l of
                [] => []
              | [h] => [h]
              | {start = start1, finish = finish1}::
                {start = start2, finish = finish2}::t =>
                if lt (finish1, start2) then
                    {start = start1, finish = finish1}::
                    (from_sorted_list ({start = start2, finish = finish2}::t))
                else
                    from_sorted_list ({start = start1, finish = finish2}::t)
    in
        from_sorted_list spl
    end

fun available_times al = List.length al

val filter_available = List.filter

fun carve n al =
    let val minutes = Time.fromSeconds (LargeInt.fromInt (n * 60))
    in
    case al of
      [] => []
     | {start, finish}::t =>
       let (* val _ = print ("carve : " ^ (Int.toString
                                            (length {start = start, finish = finish}))
                                           ^ "\n") *)
       in
       if length {start = start, finish = finish} = n then
           {start = start, finish = finish}::(carve n t)
       else
       if length {start = start, finish = finish} > n then
           let val newfinish =
               Date.fromTimeLocal (Time.+ (Date.toTime start, minutes))
           in
               {start = start, finish = newfinish}::
               (carve n ({start = newfinish, finish = finish}::t))
           end
       else
           carve n t
    end
    end

end

open Conflict

type actor = { name : string,
               conflicts : conflicts }
type rehearsal = { actors : actor list,
                   length : int, (* minutes *)
                   short_desc : string,
                   long_desc : string }

fun same_actor (a1: actor) (a2: actor) =
    case String.compare (#name a1, #name a2) of
        EQUAL => true
      | _ => false

fun actors_overlap (r1: rehearsal) (r2: rehearsal) =
    let fun mem l x =
            case List.find (same_actor x) l of
                NONE => false
              | SOME _ => true
    in
        List.foldl (fn (a, b) => a orelse b)
                   false (List.map (mem (#actors r2)) (#actors r1))
    end
