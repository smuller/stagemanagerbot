open Conflict
open Util

val rehearsals = rehearsals_from_file actors (data_path ^ "to_schedule.txt")
             handle ParseFile s =>
                    (print s; OS.Process.exit OS.Process.failure)
val alr_s = scheduled_from_file actors (data_path ^ "rehearsals.txt")
             handle ParseFile s =>
                    (print s; OS.Process.exit OS.Process.failure)

fun only_hard c =
    case #pri c of
        Hard => true | _ => false
fun hard_or_ifneedbe c =
    case #pri c of
        Soft _ => false | _ => true
val policies : ((conflict -> bool) * available) list =
    [(fn _ => true, pref_available),
     (* (fn _ => true, reh_available), *)
     (hard_or_ifneedbe, pref_available),
     (hard_or_ifneedbe, reh_available),
     (only_hard, reh_available)]

fun do_the_schedule to_s alr_s policies =
    case policies of
        [] => (alr_s, to_s)
      | (f, a)::t =>
        case schedule {to_schedule = to_s, already_scheduled = alr_s} a f of
            {already_scheduled = rs, to_schedule = []} => (rs, [])
          | {already_scheduled = rs, to_schedule = not_s} =>
            (print ("Scheduled: " ^ (Int.toString (List.length rs)) ^ "\n");
             do_the_schedule not_s rs t)

val (rs, not_s) = do_the_schedule rehearsals alr_s policies

val _ = append_rehearsals rs (data_path ^ "rehearsals.txt")
val _ = print ("Rehearsals not scheduled:\n" ^
               (List.foldl (fn (r, s) => (#short_desc r) ^ "\n" ^ s)
                            "" not_s))
