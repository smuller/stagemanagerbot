open Conflict
open Util

(* Constants *)
val data_path = "data/"
val everyday_start = (10, 0)
val everyday_end = (22, 0)
val pref_start = (17, 0)
val pref_end = (21, 0)

val pref_periods =
    (List.map (period_of_day 2015 Date.Sep pref_start pref_end)
              (range 28 30)) @
    (List.map (period_of_day 2015 Date.Oct pref_start pref_end)
              (range 1 4))

val reh_periods =
    (List.map (period_of_day 2015 Date.Sep everyday_start everyday_end)
              (range 28 30)) @
    (List.map (period_of_day 2015 Date.Oct everyday_start everyday_end)
              (range 1 4))
(*
val reh_periods =
  (List.map (period_of_day 2015 Date.Sep (10, 0) (18, 0))
            (range 9 12))
*)
val reh_available = from_period_list reh_periods
val pref_available = from_period_list pref_periods
val rehearsals_start = Date.date {year = 2015,
                                  month = Date.Sep,
                                  day = 28,
                                  hour = 10,
                                  minute = 0,
                                  second = 0,
                                  offset = NONE}
val rehearsals_end = Date.date {year = 2015,
                                month = Date.Oct,
                                day = 4,
                                hour = 23,
                                minute = 0,
                                second = 0,
                                offset = NONE}

val rehearsal_weeks = 2
val rehearsal_days = 7

(*
val actors = actors_from_file data_path (data_path ^ "actors.txt")
             handle ParseFile s =>
                    (print s; OS.Process.exit OS.Process.failure)
*)
