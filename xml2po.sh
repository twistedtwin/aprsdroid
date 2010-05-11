#!/bin/bash

TRAN=translations
RES=res/values
POT=$TRAN/aprsdroid.pot
PO=translations/aprsdroid/aprsdroid-

translate_xml2pot() {
	if [ -f $POT ] ; then
		xml2po -a -u $POT $RES/strings.xml
	else
		xml2po -a -o $POT $RES/strings.xml
	fi
}

translate_po2xml() {
	for po in $PO*.po; do
		lang=${po##$PO}
		lang=${lang%%.po}
		echo $lang:
		dir=$RES-$lang
		mkdir -p $dir
		xml2po -a -l $lang -p $po $RES/strings.xml > $dir/strings.xml
	done
	{
		cat <<EOF
<?xml version="1.0" encoding="utf-8"?>
<!-- AUTOGENERATED BY xml2po.sh! DO NOT CHANGE MANUALLY! -->
<!-- APRSdroid translators. Autogenerated by xml2po.sh -->
<resources>
<string name="translation_credits">\\n
$(cat translations/aprsdroid/aprsdroid-*.po | awk -F ': | <' '/Last-Translator:/ { print $2 "\\n"; }')
</string>
</resources>
EOF
	} > res/values/translators.xml
}


if [ "$1" = "xml2pot" ]; then
	translate_xml2pot
else
	translate_po2xml
fi
