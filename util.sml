open Conflict

structure Util =
struct
fun range f t =
    if f > t then []
    else f::(range (f + 1) t)

fun period_of_day year month (start_h, start_m) (end_h, end_m) day =
    {start = Date.date {year = year,
                        month = month,
                        day = day,
                        hour = start_h,
                        minute = start_m,
                        second = 0,
                        offset = NONE},
     finish = Date.date {year = year,
                         month = month,
                         day = day,
                         hour = end_h,
                         minute = end_m,
                         second = 0,
                         offset = NONE}}

fun dplus d1 d2 =
    Date.fromTimeLocal (Time.+ (Date.toTime d1, Date.toTime d2))
fun dplust d t =
    Date.fromTimeLocal (Time.+ (Date.toTime d, t))
val second = Time.fromSeconds (LargeInt.fromInt 1)
val minute = Time.fromSeconds (LargeInt.fromInt 60)
val hour = Time.fromSeconds (LargeInt.fromInt (60 * 60))
val day = Time.fromSeconds (LargeInt.fromInt (60 * 60 * 24))
val week = Time.fromSeconds (LargeInt.fromInt (60 * 60 * 24 * 7))

fun weekly start finish actor wd (starth, startm) (endh, endm) pri =
    if lt (finish, start) then []
    else if Date.weekDay start = wd then
        {time = {start = Date.date {year = Date.year start,
                                    month = Date.month start,
                                    day = Date.day start,
                                    hour = starth,
                                    minute = startm,
                                    second = 0,
                                    offset = NONE},
                 finish = Date.date {year = Date.year start,
                                     month = Date.month start,
                                     day = Date.day start,
                                     hour = endh,
                                     minute = endm,
                                     second = 0,
                                     offset = NONE}},
         pri = pri, actor_name = actor}
        ::(weekly (dplust start week) finish actor wd
                             (starth, startm) (endh, endm) pri)
    else
        weekly (dplust start day) finish actor wd
               (starth, startm) (endh, endm) pri
fun mweekly start finish actor wds s e pri =
    List.concat (List.map (fn wd => weekly start finish actor wd
                                            s e pri)
                          wds)
fun oneoff year actor month day (starth, startm) (endh, endm) pri =
    [{time = {start = Date.date {year = year, month = month, day = day,
              hour = starth, minute = startm, second = 0, offset = NONE},
             finish = Date.date {year = year, month = month, day = day,
                       hour = endh, minute = endm, second = 0, offset = NONE}},
     pri = pri,
     actor_name = actor}]
fun allday year actor month day pri =
    oneoff year actor month day (0, 0) (23, 59) pri
fun multday year actor month sday eday pri =
    [{time = {start = Date.date {year = year, month = month, day = sday,
              hour = 0, minute = 0, second = 0, offset = NONE},
             finish = Date.date {year = year, month = month, day = eday,
                       hour = 23, minute = 59, second = 59, offset = NONE}},
     pri = pri,
     actor_name = actor}]


fun lines s =
    let fun islb c =
            (c = #"\r") orelse (c = #"\n")
        in String.tokens islb s
    end

fun tabs s =
    String.tokens (fn c => c = #",") s

exception ParseFile of string

fun period_from_strings (s, e) =
    (case (Date.fromString s, Date.fromString e) of
         (SOME s', SOME e') => {start = s', finish = e'}
       | _ => raise (ParseFile "Dates"))


fun actors_from_file data_path file =
    let val ls = lines (StringUtil.readfile file)
        fun actor_from_file file =
            let val ls = lines (StringUtil.readfile (data_path ^ file ^ ".txt"))
                fun conflict_from_line l =
                    case tabs l of
                        s::e::t::[] =>
                        { time = period_from_strings (s, e),
                          pri = (if t = "0" then Hard
                                 else if t = "1" then Ifneedbe 0
                                 else Soft 0),
                          actor_name = file }
                      | _ =>
                        (print ((Int.toString (List.length (tabs l))) ^ "tabs\n");
                         raise (ParseFile ("Conflict for " ^ file)))
                val cs = List.map conflict_from_line ls
            in
                { name = file, conflicts = conflicts_from_list cs }
            end
    in
        List.map actor_from_file ls
    end

fun rehearsals_from_file (actors : actor list) file =
    let val ls = lines (StringUtil.readfile (file))
        fun actor_from_name n =
            case List.filter (fn {name, ...} => name = n) actors of
                [a] => a
              | _ => raise (ParseFile ("Finding actor " ^ n ^ "\n"))
        fun reh_from_line l =
            case tabs l of
                l::sd::ld::actors =>
                (case Int.fromString l of
                     SOME l' =>
                     { actors = List.map actor_from_name actors,
                       length = l',
                       short_desc = sd,
                       long_desc = ld }
                   | NONE => raise (ParseFile "Non-integer length"))
              | _ => raise (ParseFile "Ill-formatted rehearsal")
    in
        List.map reh_from_line ls
    end

fun scheduled_from_file (actors : actor list) file =
    let val ls = lines (StringUtil.readfile (file))
        fun actor_from_name n =
            case List.filter (fn {name, ...} => name = n) actors of
                [a] => a
              | _ => raise (ParseFile ("Finding actor " ^ n ^ "\n"))
        fun reh_from_line l =
            case tabs l of
                s::f::l::sd::ld::actors =>
                (case Int.fromString l of
                     SOME l' =>
                     ({ actors = List.map actor_from_name actors,
                        length = l',
                        short_desc = sd,
                        long_desc = ld },
                      period_from_strings (s, f))
                   | NONE => raise (ParseFile "Non-integer length"))
              | _ => raise (ParseFile "Ill-formatted rehearsal")
    in
        List.map reh_from_line ls
    end
end

fun append_rehearsals rs file =
    let fun reh_to_line ((r, p) : rehearsal * period) =
            (Date.toString (#start p)) ^ "," ^
            (Date.toString (#finish p)) ^ "," ^
            (Int.toString (#length r)) ^ "," ^
            (#short_desc r) ^ "," ^ (#long_desc r) ^ "," ^
            (String.concatWith "," (List.map (fn v => #name v) (#actors r))) ^
            "\n"
        (*val contents = StringUtil.readfile file *)
        val newcontents =
            List.foldl (fn ((r, p), s) => (reh_to_line (r, p)) ^ s) "\n" rs
    in
        StringUtil.writefile (file) (newcontents)
    end
