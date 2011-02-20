#!/usr/bin/webif-page

<?

tools=/www/cgi-bin/webif/tools

. /usr/lib/webif/webif.sh
. $tools/functions.sh

header "Lanc" "Control" "" "" "$SCRIPT_NAME"

#

DOWNLOAD()
{
cat <<EOF
@TR<<confman_noauto_click#If downloading does not start automatically, click here>> ...
<a href="/$1">$1</a><br /><br />
<script language="JavaScript" type="text/javascript">
	setTimeout('top.location.href=\"/$1\"',"300")
</script>
EOF
}

if [ "$FORM_dump_button" ] ; then

	echo "Dump [addr, size] = [$FORM_dump_addr, $FORM_dump_size]" 1>&2

	uci_load lanc
	uci_set "lanc" "control" "addr" "$FORM_dump_addr"
	uci_set "lanc" "control" "size" "$FORM_dump_size"
	uci_commit lanc

	echo "Control buffer dump of size $FORM_dump_size from addr $FORM_dump_addr" 1>&2
	echo "<div class=\"progress\">Generating control dump, please wait...</div>"

	rm -rf /www/data/control.bin 2>&1 1>/dev/null
	get_from_control $FORM_dump_addr "/www/data/control.bin" $FORM_dump_size
	DOWNLOAD "data/control.bin"

	echo "Video dump completed" 1>&2
fi

if [ "$FORM_upload" ] ; then
	if [ "$FORM_file_name" ] ; then
		echo "<div class=\"progress\">Uploading file $FORM_file_name, please wait...</div>"

		echo "Load map from file [$FORM_file_name] starting from address [$FORM_map]" 1>&2
		put_to_control "$FORM_map" "$FORM_file"
		rm -rf "$FORM_file"

		uci_load lanc
		uci_set "lanc" "control" "map" "$FORM_map"
		uci_commit lanc

		echo "<div class=\"progress\">Upload and push completed.</div>"
	fi
fi

if [ "$FORM_write" ] ; then

        phys_addr=$((0x60000000 + $FORM_waddr))
	echo "Set control word [ctl_addr, phys_addr, word] = [$FORM_waddr, $phys_addr, $FORM_word]" 1>&2

	# devmem2 { address } [ type [ data ] ]
	devmem2 $phys_addr w $FORM_word 2>&1 1>/dev/null

	uci_load lanc
	uci_set "lanc" "control" "waddr" "$FORM_waddr"
	uci_set "lanc" "control" "word" "$FORM_word"
	uci_commit lanc
fi

uci_load lanc

config_get waddr "control" "waddr"
config_get word  "control" "word"
config_get addr  "control" "addr"
config_get size  "control" "size"
config_get map   "control" "map"

#

display_form <<EOF
formtag_begin|LANC_ctl|$SCRIPT_NAME
start_form|Set control word
field|@TR<<Address>>
text|waddr|$waddr
field|@TR<<Value>>
text|word|$word
helpitem|Control interface
helptext|HelpText Control interface#Update control register
string|<br>
submit|write|@TR<<Write>>
end_form
formtag_end
EOF

#

display_form <<EOF
formtag_begin|LANC_upload|$SCRIPT_NAME
start_form|Control map upload
field|@TR<<Start address>>
text|map|$map
field|@TR<<Control map>>
upload|file
helpitem|Control interface
helptext|HelpText Control interface#Upload and push control register map
string|<br>
submit|upload| @TR<<Upload and push>>
end_form
formtag_end
EOF

#

display_form <<EOF
formtag_begin|LANC_dump|$SCRIPT_NAME
start_form|Dump settings
field|Start address
text|dump_addr|$addr
field|Dump size
text|dump_size|$size
helpitem|Dump control buffer
helptext|HelpText Dump FPGA buffer#Dump the content of control buffer in FPGA encoder
string|<br>
submit|dump_button| @TR<<Dump>>
end_form
formtag_end
EOF

#

footer
?>

<!--
##WEBIF:name:Lanc:520:Control
-->

