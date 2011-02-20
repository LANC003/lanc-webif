#!/usr/bin/webif-page

<?

tools=/www/cgi-bin/webif/tools

. /usr/lib/webif/webif.sh
. $tools/functions.sh 

header_inject_head=$(cat <<EOF
<style type="text/css">
<!--
#logarea pre {
	margin: 0.2em auto 1em auto;
	padding: 3px;
	width: 70%;
	margin: auto;
	height: 450px;
	overflow: scroll;
	border: 1px solid;
}
// -->
</style>

EOF
)

header "Network" "Info"

# print fpga registers

cat <<EOLH
	<div class="settings">
	<h3><strong>Network configuration</strong></h3>
	<div id="logarea">
	<pre>
EOLH

uci_load network

for interface in `config_foreach echo` ; do
	ifconfig $interface
done		

route -n

echo " </pre>"
echo "</div>"
echo "<div class=\"clearfix\">&nbsp;</div></div>"

# control forms

lanc_control="$lanc_control
formtag_begin|network_configuration|$SCRIPT_NAME
start_form|Refresh data
submit|refresh_button|Refresh
end_form
formtag_end"

display_form <<EOF_FORMS
$lanc_control
EOF_FORMS

footer
?>

<!--
##WEBIF:name:Network:095:Info
-->

