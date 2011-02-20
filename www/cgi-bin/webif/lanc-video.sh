#!/usr/bin/webif-page

<?

tools=/www/cgi-bin/webif/tools

. /usr/lib/webif/webif.sh
. $tools/functions.sh

header "Lanc" "Video" "" "" "$SCRIPT_NAME"

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
	uci_set "lanc" "video" "addr" "$FORM_dump_addr"
	uci_set "lanc" "video" "size" "$FORM_dump_size"
	uci_commit lanc

	echo "Video buffer dump of size $FORM_dump_size from addr $FORM_dump_addr" 1>&2
	echo "<div class=\"progress\">Generating video dump, please wait...</div>"

	rm -rf /www/data/video.bin 2>&1 1>/dev/null
	get_from_video $FORM_dump_addr "/www/data/video.bin" $FORM_dump_size
	DOWNLOAD "data/video.bin"

	echo "Video dump completed" 1>&2
fi

if [ "$FORM_upload" ] ; then
	if [ "$FORM_file_name" ] ; then
		echo "<div class=\"progress\">Uploading file $FORM_file_name, please wait...</div>"

		echo "Load map from file [$FORM_file_name] starting from address [$FORM_map]" 1>&2
		put_to_video "$FORM_map" "$FORM_file"
		rm -rf "$FORM_file"

		uci_load lanc
		uci_set "lanc" "video" "map" "$FORM_map"
		uci_commit lanc

		echo "<div class=\"progress\">Upload and push completed.</div>"
	fi
fi

if [ "$FORM_write" ] ; then

        phys_addr=$((0x50000000 + $FORM_waddr))
	echo "Set video word [ctl_addr, phys_addr, word] = [$FORM_waddr, $phys_addr, $FORM_word]" 1>&2

	# devmem2 { address } [ type [ data ] ]
	devmem2 $phys_addr w $FORM_word 2>&1 1>/dev/null

	uci_load lanc
	uci_set "lanc" "video" "waddr" "$FORM_waddr"
	uci_set "lanc" "video" "word" "$FORM_word"
	uci_commit lanc
fi


uci_load lanc
config_get waddr "video" "waddr"
config_get word  "video" "word"
config_get addr  "video" "addr"
config_get size  "video" "size"
config_get map   "video" "map"

#  form 'set video word'

display_form <<EOF
formtag_begin|LANC_ctl|$SCRIPT_NAME
start_form|Set video word
field|@TR<<Address>>
text|waddr|$waddr
field|@TR<<Value>>
text|word|$word
helpitem|Video interface
helptext|HelpText Video interface#Update video memory
string|<br>
submit|write|@TR<<Write>>
end_form
formtag_end
EOF

# form 'upload video map'

display_form <<EOF
formtag_begin|LANC_map|$SCRIPT_NAME
start_form|Video map upload
field|@TR<<Start address>>
text|map|$map
field|@TR<<Video map>>
upload|file
helpitem|Video interface
helptext|HelpText Video interface#Upload and push video dump
string|<br>
submit|upload| @TR<<Upload and push>>
end_form
formtag_end
EOF

# dump video buffer

display_form <<EOF
formtag_begin|LANC_dump|$SCRIPT_NAME
start_form|Dump settings
field|Start address
text|dump_addr|$addr
field|Dump size
text|dump_size|$size
helpitem|Dump video buffer
helptext|HelpText Dump FPGA buffer#Dump the content of video buffer in FPGA encoder
string|<br>
submit|dump_button| @TR<<Dump>>
end_form
formtag_end
EOF

#

footer
?>

<!--
##WEBIF:name:Lanc:510:Video
-->

