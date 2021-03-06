#!/bin/tclsh
set    red "#FF0000"
set  green "#00FF00"
set yellow "#FFF000"
set   blue "#00EAFF" 
set  white "#FFFFFF" 
puts {{"version":1}
[
[]}
proc wifi {} {
    set hostname [exec hostname]
    if {$hostname=="R730"} {set con "wlp2s0"} else {set con "wlp3s0"}
    set wifi [exec iwconfig $con | sed -ne /Point/p | awk {{print $6}}]
    if {[string match *Not-Associated* $wifi] } {
        set stdout {{"name":"wifi","full_text":"WIFI","color": "$::red"}} 
    } else { 
        set stdout {{"name":"wifi","full_text":"WIFI","color": "$::green"}}
    }
    set stdout [subst -nocommands $stdout]
    puts -nonewline $stdout
}
proc hour {} {
    set hour [clock format [clock sec] -format %H:%M] 
    set stdout {{"name":"hour","full_text":"$hour"}} 
    set stdout [subst -nocommands $stdout]
    puts -nonewline $stdout
}
proc date {} {
    set date [clock format [clock sec] -format {%a}]
    set date [string toupper $date]
    set date_number [clock format [clock sec] -format {%e}]
    set suffix [en_ordinal $date_number]
    if {[string range $date_number 0 0]!=" "} {set date "$date "}
    set stdout {{"name":"date","full_text":"$date$suffix","color": "$::white"}} 
    set stdout [subst -nocommands $stdout]
    puts -nonewline $stdout
}
proc en_ordinal n {
    set suffix th
    if {($n%100)<10 || ($n%100)>20} {
        switch -- [expr abs($n)%10] {
            1 {set suffix st}
            2 {set suffix nd}
            3 {set suffix rd}
        }
    }
    append n $suffix
} 
proc battery {} {
    set battery [exec acpi]
    set percentage [exec acpi | awk {{print $4}} | sed {s/%,//}]
    if {[string match *Discharging* $battery]} {
    if {$percentage >= 20} {set color "$::yellow"}
    if {$percentage <  20} {set color "$::red"}
    regsub -all "," $battery "" battery 
    set charge [lindex $battery 3]
    set remain [lindex $battery 4]
    set stdout {{"name":"battery","full_text":"$charge $remain","color": "$color"}} 
   } else { set stdout {{"name":"battery","full_text":"D=","color": "$::green"}} 
}
    set stdout [subst -nocommands $stdout]
    puts -nonewline $stdout
}
proc volume {} {
    set vol [exec amixer sget Master | awk {-F[][]} {/dB/ { print $2 }} | head -1]
    regsub -all "%" $vol "&#9836;" vol 
    set stdout {{"name":"volume","full_text":"$vol","color":"$::blue"}} 
    set stdout [subst -nocommands $stdout]
    puts -nonewline $stdout
}
proc cpu_load {} {
    set cpu_load [exec sar 1 1 | sed -n {4p} | awk {{print $8}}]
    set cpu_load [expr 100-$cpu_load]
    set cpu_load [format "%.2f" $cpu_load]
    if {$cpu_load <= 59.99} {set color "$::green"}
    if {$cpu_load >= 60 && $cpu_load <= 79.99} {set color "$::yellow"}
    if {$cpu_load >= 80} {set color "$::red"}
 set stdout {{"name":"cpu_load","full_text":"$cpu_load","color":"$color"}} 
    set stdout [subst -nocommands $stdout]
    puts -nonewline $stdout
}

proc cpu_temp {} {
    set cpu_temp [exec sensors | grep Core | sed -n  {2p} | awk {{print $3}} | cut -c2-3]
    if {$cpu_temp <= 64} {set color "$::green"}
    if {$cpu_temp >= 65 && $cpu_temp <= 74} {set color "$::yellow"}
    if {$cpu_temp >= 75} {set color "$::red"}
    set stdout {{"name":"cpu_temp","full_text":"$cpu_temp�C","color":"$color"}} 
    set stdout [subst -nocommands $stdout]
    puts -nonewline $stdout
}
set ::backup ""

while 1 {
    set begin ",\["
    set end "]"
              puts -nonewline $begin
    cpu_load; puts -nonewline ","
    cpu_temp; puts -nonewline ","
    battery;  puts -nonewline ","
    wifi;     puts -nonewline ","
    date;     puts -nonewline ","
    hour;     puts $end
after 1000
}
