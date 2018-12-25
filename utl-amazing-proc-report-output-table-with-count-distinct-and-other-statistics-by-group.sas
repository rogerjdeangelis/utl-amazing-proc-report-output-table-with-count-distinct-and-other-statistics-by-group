Amazing proc report output table with count distinct and other statistics by group

github
https://tinyurl.com/yb5q3k6q
https://github.com/rogerjdeangelis/utl-amazing-proc-report-output-table-with-count-distinct-and-other-statistics-by-group

inspired by
https://tinyurl.com/yamvpkxl
https://communities.sas.com/t5/SAS-Programming/Crosstabulate-distinct-frequencies-and-totals-of-binary/m-p/523026

I don't believe you can create an output table with count distinct and arbitrary statistics by
group with any outer single SAS procedure.

Not sure I recommend this but it is does demostrate the power of proc report,
I just wish report would honor ods output column names when using across.

note SQL does not directly support the first quatile, Q1, among other statistics.


INPUT
=====

 WORK.HAVE total obs=18


                     RULES
                   | =====
 REGION     AGES   |
                   |
   E         12    |
   E         12    |
   E         12    |
   E         14    |           First Quartile     Count Distinct
   E         14    | REGION    of age                 Age*
   E         17    |
   E         18    |   E           12              4    ie (12,14,17,18)
                   |

   N         12    |
   N         12    |
   N         16    |
   N         18    |
   N         17    |
   N         25    |
   S         12    |
   S         12    |
   S         13    |
   S         12    |
   W         27    |

Quartile of all the individual age values


EXAMPLE OUTPUT
--------------

WORK.WANT total obs=4

  REGION      Q1      COUNT_DISTINCT_AGES

    E         12         4
    N         12         5
    S         12         2
    W         27         1

It is interesting that the output datset has mnore useful information that the report.
Just remove the drop and where clause.
inspired by
https://communities.sas.com/t5/SAS-Programming/Crosstabulate-distinct-frequencies-and-totals-of-binary/m-p/523026


PROCESS
========

proc report data = have nowd out=want /*(drop=age where=(upcase(_break_)='REGION'))*/;

   column  region age age=q1 count_distinct_ages;

   define region / group;
   define q1 / q1;
   define age /  group ;
   define count_distinct_ages /computed;

   compute before;
     count=-1;
   endcomp;

   compute after region;
     count=-1;
   endcomp;

   compute count_distinct_ages;
   count= count + 1 ;
   count_distinct_ages=count;
   endcomp;

run;quit;


Here is the additiona info in the want table before subset

WANT total obs=17

                                COUNT_
                         DISTINCT_
  REGION    AGE    Q1       AGES      _BREAK_

              .    12        .        _RBREAK_
    E        12    12        0
    E        14    14        1
    E        17    17        2
    E        18    18        3
    E         .    12        4        REGION
    N        12    12        0
    N        16    16        1
    N        17    17        2
    N        18    18        3
    N        25    25        4
    N         .    12        5        REGION
    S        12    12        0
    S        13    13        1
    S         .    12        2        REGION
    W        27    27        0
    W         .    27        1        REGION


OUTPUT
=======

 WORK.WANT total obs=4

  REGION      Q1      COUNT_DISTINCT_AGES

    E         12         4
    N         12         5
    S         12         2
    W         27         1

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

data have ;
input Region $ Age;
cards4;
E 12
E 12
E 12
E 14
E 14
E 17
E 18
N 12
N 12
N 16
N 18
N 17
N 25
S 12
S 12
S 13
S 12
W 27
;;;;
run;quit;

