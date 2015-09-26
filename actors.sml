open Date
val weekly = weekly rehearsals_start rehearsals_end
val mweekly = mweekly rehearsals_start rehearsals_end
val oneoff = oneoff 2015
val allday = allday 2015
val multday = multday 2015

val ifneedbe = Ifneedbe 0
val soft = Soft 0

val actors =
    [
      let val name = "Kelly"
          val weekly = weekly name
          val mweekly = mweekly name
          val oneoff = oneoff name
          val allday = allday name
          val multday = multday name
      in
          {name = name,
           conflicts =
           conflicts_from_list
               ((mweekly [Wed, Thu] (15, 0) (16, 0) Hard) @
                (weekly Tue (12, 0) (14, 0) ifneedbe) @
                (weekly Thu (12, 0) (13, 0) ifneedbe) @
                (mweekly [Mon, Tue, Wed, Thu, Fri] (9, 0) (11, 0) soft) @
                (mweekly [Mon, Tue, Wed, Thu, Fri] (20, 0) (22, 0) soft) @
                (weekly Wed (9, 0) (15, 0) soft) @
                (oneoff Sep 26 (18, 0) (21, 0) Hard) @
                (oneoff Oct 7 (17, 0) (22, 0) Hard) @
                (multday Oct 8 14 Hard) @
                (oneoff Oct 19 (17, 0) (22, 0) Hard) @
                (oneoff Oct 28 (13, 0) (15, 0) Hard) @
                (oneoff Nov 4 (13, 30) (14, 30) Hard) @
                (oneoff Nov 10 (12, 0) (14, 0) Hard))
          }
      end
    ,
      let val name = "Wenxin"
          val weekly = weekly name
          val mweekly = mweekly name
          val oneoff = oneoff name
          val allday = allday name
          val multday = multday name
      in
          {name = name,
           conflicts =
           conflicts_from_list
               ((mweekly [Wed, Tue, Wed, Thu] (9, 0) (12, 0) Hard) @
                (mweekly [Mon, Wed] (15, 30) (19, 0) Hard) @
                (mweekly [Tue, Thu] (13, 30) (15, 0) Hard) @
                (weekly Fri (12, 0) (15, 0) Hard) @
                (mweekly [Tue, Thu, Fri] (15, 0) (17, 30) ifneedbe) @
                (weekly Sun (18, 0) (22, 0) ifneedbe) @
                (weekly Mon (9, 0) (22, 0) soft) @
                (weekly Sun (13, 0) (22, 0) soft))
          }
      end
    ,
      let val name = "Ram"
          val weekly = weekly name
          val mweekly = mweekly name
          val oneoff = oneoff name
          val allday = allday name
          val multday = multday name
      in
          {name = name,
           conflicts =
           conflicts_from_list
               ((mweekly [Tue, Thu] (12, 0) (13, 30) Hard) @
                (mweekly [Tue, Wed, Thu] (15, 0) (16, 0) Hard) @
                (weekly Fri (11, 0) (12, 0) Hard) @
                (weekly Fri (13, 0) (14, 0) Hard) @
                (weekly Tue (17, 30) (19, 30) ifneedbe) @
                (oneoff Oct 21 (18, 30) (22, 0) Hard))
          }
      end
    ,
      let val name = "Karin"
          val weekly = weekly name
          val mweekly = mweekly name
          val oneoff = oneoff name
          val allday = allday name
          val multday = multday name
      in
          {name = name,
           conflicts =
           conflicts_from_list
               ((weekly Sun (13, 0) (14, 0) Hard) @
                (weekly Mon (12, 0) (13, 0) Hard) @
                (weekly Thu (21, 30) (22, 0) Hard) @
                (weekly Sat (19, 30) (21, 0) Hard) @
                (mweekly [Mon, Tue, Wed, Thu, Fri, Sat, Sun]
                         (9, 0) (12, 0) soft) @
                (mweekly [Mon, Tue, Wed, Thu, Fri] (12, 0) (20, 30) soft) @
                (weekly Sun (12, 0) (22, 0) soft))
          }
      end
    ,
      let val name = "Danny"
          val weekly = weekly name
          val mweekly = mweekly name
          val oneoff = oneoff name
          val allday = allday name
          val multday = multday name
      in
          {name = name,
           conflicts =
           conflicts_from_list
               ((weekly Tue (15, 0) (18, 0) Hard) @
                (weekly Sun (19, 30) (22, 0) Hard) @
                (mweekly [Tue, Thu] (18, 30) (20, 30) ifneedbe) @
                (weekly Fri (19, 30) (22, 0) ifneedbe) @
                (weekly Sat (10, 0) (12, 0) ifneedbe) @
                (weekly Sat (20, 30) (21, 30) ifneedbe) @
                (oneoff Sep 27 (11, 0) (15, 0) Hard) @
                (oneoff Oct 2 (9, 0) (11, 0) Hard) @
                (oneoff Oct 2 (14, 30) (15, 30) Hard) @
                (oneoff Oct 2 (18, 30) (22, 0) Hard) @
                (allday Oct 3 Hard) @
                (oneoff Oct 4 (11, 0) (15, 0) Hard) @
                (oneoff Oct 6 (18, 0) (22, 0) Hard) @
                (oneoff Oct 8 (15, 0) (16, 30) Hard))
          }
      end
    ,
      let val name = "Deby"
          val weekly = weekly name
          val mweekly = mweekly name
          val oneoff = oneoff name
          val allday = allday name
          val multday = multday name
      in
          {name = name,
           conflicts =
           conflicts_from_list
               ((mweekly [Mon, Tue, Thu] (9, 30) (10, 0) Hard) @
                (weekly Mon (15, 30) (17, 0) Hard) @
                (weekly Wed (9, 0) (11, 30) Hard) @
                (weekly Fri (10, 30) (12, 0) Hard) @
                (weekly Wed (18, 30) (20, 0) ifneedbe) @
                (weekly Thu (18, 30) (21, 0) ifneedbe) @
                (mweekly [Mon, Tue, Wed, Thu, Fri, Sat, Sun]
                         (20, 30) (22, 0) soft) @
                (oneoff Sep 24 (11, 30) (13, 30) Hard) @
                (oneoff Sep 24 (16, 0) (18, 0) Hard) @
                (oneoff Oct 6 (18, 0) (21, 0) Hard) @
                (multday Oct 9 11 Hard) @
                (multday Oct 25 30 Hard) @
                (oneoff Nov 3 (12, 0) (14, 0) Hard))
          }
      end
    ,
      let val name = "Stefan"
          val weekly = weekly name
          val mweekly = mweekly name
          val oneoff = oneoff name
          val allday = allday name
          val multday = multday name
      in
          {name = name,
           conflicts =
           conflicts_from_list
               ((weekly Mon (14, 0) (15, 0) Hard) @
                (mweekly [Tue, Wed] (15, 0) (16, 0) Hard) @
                (weekly Thu (10, 0) (12, 0) Hard) @
                (weekly Fri (13, 0) (15, 0) Hard) @
                (weekly Tue (17, 30) (19, 30) ifneedbe) @
                (oneoff Sep 27 (9, 0) (12, 0) Hard) @
                (oneoff Oct 6 (18, 0) (22, 0) Hard) @
                (oneoff Oct 16 (20, 0) (22, 0) Hard) @
                (multday Oct 29 31 Hard) @
                (multday Oct 24 25 soft))
          }
      end
    ,
      let val name = "Amy"
          val weekly = weekly name
          val mweekly = mweekly name
          val oneoff = oneoff name
          val allday = allday name
          val multday = multday name
      in
          {name = name,
           conflicts =
           conflicts_from_list
               ((weekly Mon (9, 0) (10, 30) Hard) @
                (mweekly [Mon, Wed] (10, 30) (12, 0) Hard) @
                (mweekly [Tue, Thu] (13, 30) (15, 30) Hard) @
                (mweekly [Mon, Tue] (12, 0) (13, 0) Hard) @
                (weekly Wed (12, 0) (13, 30) Hard) @
                (weekly Fri (9, 30) (12, 0) Hard) @
                (weekly Fri (14, 0) (14, 30) Hard) @
                (weekly Wed (19, 0) (20, 0) Hard) @
                (weekly Sun (10, 30) (13, 30) Hard) @
                (weekly Thu (20, 30) (22, 0) ifneedbe) @
                (weekly Sat (11, 0) (14, 0) ifneedbe) @
                (multday Sep 25 27 Hard) @
                (multday Oct 3 4 Hard) @
                (multday Oct 16 18 Hard) @
                (multday Oct 30 31 Hard) @ (allday Nov 1 Hard))
          }
      end
    ,
      let val name = "Kristy"
          val weekly = weekly name
          val mweekly = mweekly name
          val oneoff = oneoff name
          val allday = allday name
          val multday = multday name
      in
          {name = name,
           conflicts =
           conflicts_from_list
               ((mweekly [Mon, Fri] (9, 0) (12, 0) Hard) @
                (mweekly [Mon, Fri] (15, 30) (16, 30) Hard) @
                (weekly Tue (10, 0) (14, 0) Hard) @
                (weekly Wed (10, 0) (13, 0) Hard) @
                (mweekly [Mon, Wed] (19, 0) (22, 0) ifneedbe) @
                (weekly Thu (18, 30) (22, 0) ifneedbe) @
                (mweekly [Mon, Tue, Wed, Thu, Sun] (20, 0) (22, 0) soft) @
                (mweekly [Mon, Tue, Wed, Thu, Fri] (9, 0) (17, 0) soft) @
                (weekly Thu (17, 0) (22, 0) soft) @
                (oneoff Sep 30 (16, 0) (18, 0) Hard) @
                (oneoff Oct 6 (18, 0) (22, 0) Hard) @
                (multday Oct 8 10 Hard) @
                (oneoff Oct 13 (16, 0) (18, 0) Hard) @
                (oneoff Oct 16 (17, 30) (22, 0) Hard) @
                (oneoff Oct 22 (12, 0) (14, 0) Hard) @
                (oneoff Oct 24 (16, 0) (19, 0) Hard) @
                (oneoff Oct 25 (12, 0) (16, 0) Hard) @
                (allday Oct 31 Hard) @ (multday Nov 1 5 Hard))
          }
      end
    ,
      let val name = "Judy"
          val weekly = weekly name
          val mweekly = mweekly name
          val oneoff = oneoff name
          val allday = allday name
          val multday = multday name
      in
          {name = name,
           conflicts =
           conflicts_from_list
               ((mweekly [Mon, Wed] (15, 0) (16, 30) Hard) @
                (mweekly [Tue, Thu] (10, 30) (12, 30) Hard) @
                (weekly Tue (13, 30) (14, 30) Hard) @
                (weekly Tue (16, 0) (17, 0) Hard) @
                (weekly Thu (13, 0) (13, 30) Hard) @
                (weekly Fri (10, 0) (14, 0) Hard) @
                (mweekly [Mon, Wed, Fri] (17, 0) (20, 0) ifneedbe) @
                (weekly Thu (9, 0) (10, 0) ifneedbe) @
                (weekly Wed (9, 0) (12, 0) soft) @
                (multday Oct 2 4 Hard) @
                (multday Oct 16 19 Hard) @
                (allday Oct 31 Hard))
          }
      end
    ,
      let val name = "Yang"
          val weekly = weekly name
          val mweekly = mweekly name
          val oneoff = oneoff name
          val allday = allday name
          val multday = multday name
      in
          {name = name,
           conflicts =
           conflicts_from_list
               ((mweekly [Mon, Wed] (11, 30) (15, 30) Hard) @
                (weekly Thu (17, 30) (19, 0) Hard) @
                (weekly Tue (9, 0) (11, 30) ifneedbe) @
                (weekly Tue (14, 30) (16, 0) ifneedbe) @
                (oneoff Sep 28 (10, 0) (14, 0) Hard) @
                (oneoff Sep 29 (18, 30) (21, 0) Hard) @
                (oneoff Oct 3 (16, 0) (19, 0) Hard) @
                (oneoff Oct 10 (16, 0) (22, 0) Hard) @
                (oneoff Oct 11 (19, 30) (21, 0) Hard) @
                (oneoff Oct 18 (19, 0) (22, 0) Hard) @
                (oneoff Oct 26 (19, 0) (22, 0) Hard) @
                (oneoff Nov 8 (17, 0) (22, 0) Hard))
          }
      end
    ,
      let val name = "Akash"
          val weekly = weekly name
          val mweekly = mweekly name
          val oneoff = oneoff name
          val allday = allday name
          val multday = multday name
      in
          {name = name,
           conflicts =
           conflicts_from_list
               ((weekly Mon (9, 0) (18, 0) Hard) @
                (mweekly [Tue, Wed] (10, 0) (17, 30) Hard) @
                (weekly Tue (19, 0) (20, 0) Hard) @
                (weekly Thu (11, 0) (18, 0) Hard) @
                (weekly Fri (11, 0) (20, 0) Hard) @
                (weekly Sat (13, 30) (15, 0) Hard) @
                (mweekly [Mon, Fri] (20, 0) (22, 0) ifneedbe))
          }
      end
    ,
      let val name = "Darya"
          val weekly = weekly name
          val mweekly = mweekly name
          val oneoff = oneoff name
          val allday = allday name
          val multday = multday name
      in
          {name = name,
           conflicts =
           conflicts_from_list
               ((mweekly [Mon, Tue, Wed, Thu, Fri] (9, 0) (17, 0) Hard) @
                (weekly Fri (19, 0) (22, 0) soft) @
                (oneoff Sep 26 (15, 0) (22, 0) Hard) @
                (oneoff Sep 27 (17, 0) (22, 0) Hard) @
                (oneoff Sep 28 (17, 0) (19, 0) Hard) @
                (oneoff Oct 6 (17, 30) (19, 30) Hard) @
                (multday Oct 23 30 Hard))
          }
      end
    ,
      let val name = "Wei"
          val weekly = weekly name
          val mweekly = mweekly name
          val oneoff = oneoff name
          val allday = allday name
          val multday = multday name
      in
          {name = name,
           conflicts =
           conflicts_from_list
               ((mweekly [Mon, Tue, Wed, Thu, Fri, Sat, Sun]
                         (20, 0) (22, 0) soft) @
                (multday Oct 10 13 Hard))
          }
      end
    ,
      let val name = "Sol"
          val weekly = weekly name
          val mweekly = mweekly name
          val oneoff = oneoff name
          val allday = allday name
          val multday = multday name
      in
          {name = name,
           conflicts =
           conflicts_from_list
               ((weekly Mon (13, 0) (15, 0) Hard) @
                (mweekly [Mon, Wed, Fri] (15, 0) (16, 30) Hard) @
                (mweekly [Tue, Thu] (10, 30) (12, 0) Hard) @
                (mweekly [Wed, Fri] (12, 0) (13, 0) Hard) @
                (weekly Thu (17, 0) (22, 0) Hard) @
                (mweekly [Mon, Tue, Thu] (12, 0) (13, 0) ifneedbe) @
                (mweekly [Mon, Wed] (16, 30) (17, 0) ifneedbe) @
                (weekly Tue (16, 0) (17, 0) ifneedbe) @
                (weekly Wed (20, 0) (21, 0) ifneedbe) @
                (weekly Fri (16, 30) (17, 30) ifneedbe) @
                (multday Oct 2 7 Hard) @
                (oneoff Oct 13 (17, 0) (19, 0) Hard) @
                (oneoff Oct 14 (16, 30) (19, 0) Hard) @
                (multday Oct 23 24 Hard) @
                (multday Oct 26 28 Hard))
          }
      end
    ,
      let val name = "Yuzi"
          val weekly = weekly name
          val mweekly = mweekly name
          val oneoff = oneoff name
          val allday = allday name
          val multday = multday name
      in
          {name = name,
           conflicts =
           conflicts_from_list
               ((weekly Tue (16, 30) (17, 30) Hard) @
                (mweekly [Tue, Thu] (15, 0) (16, 30) Hard) @
                (multday Sep 24 30 Hard) @ (multday Oct 1 5 Hard) @
                (oneoff Oct 6 (18, 0) (21, 0) Hard) @
                (oneoff Oct 17 (18, 0) (21, 0) Hard) @
                (allday Oct 23 Hard) @
                (oneoff Oct 24 (9, 0) (13, 0) Hard))
          }
      end
    ]
