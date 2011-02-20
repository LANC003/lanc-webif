#!/usr/bin/webif-page

<?
echo ""
echo -e "\r"`date -u`
if [ "$FORM_if" ]; then
	grep "${FORM_if}:" /proc/net/dev
else
	head -n 1 /proc/stat
fi

?>

