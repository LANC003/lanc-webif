#!/usr/bin/webif-page

<?

tools=/www/cgi-bin/webif/tools

. /usr/lib/webif/webif.sh
. $tools/functions.sh

header "Lanc" "Timings" "" "" "$SCRIPT_NAME"

#

if [ "$FORM_modify" ] ; then

	smc_timing "smc_setup" $FORM_setup
	smc_timing "smc_pulse" $FORM_pulse
	smc_timing "smc_cycle" $FORM_cycle
	smc_timing "smc_mode"  $FORM_mode

	echo "Timing change completed" 1>&2
fi

setup=$( smc_timing "smc_setup" )
pulse=$( smc_timing "smc_pulse" )
cycle=$( smc_timing "smc_cycle" )
mode=$( smc_timing  "smc_mode" )

#  form 'set video word'

display_form <<EOF
formtag_begin|LANC_timing|$SCRIPT_NAME
start_form|Change video SMC timings
field|@TR<<Setup>>
text|setup|$setup
field|@TR<<Pulse>>
text|pulse|$pulse
field|@TR<<Cycle>>
text|cycle|$cycle
field|@TR<<Mode>>
text|mode|$mode
helpitem|Video SMC timings
helptext|HelpText Video interface#Modify SMC settings for vido buffer
string|<br>
submit|modify|@TR<<Modify>>
end_form
formtag_end
EOF

#

footer
?>

<!--
##WEBIF:name:Lanc:530:Timings
-->

