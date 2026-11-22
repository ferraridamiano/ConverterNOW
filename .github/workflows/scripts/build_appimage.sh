#!/bin/bash

# This script needs to be called once the flutter linux app build is finished

arch=$(ls build/linux)
arch_label=""
if [ "$arch" == "x64" ]; then
    arch_label="x86_64"
else
    arch_label="aarch64"
fi
appimagetool="appimagetool-$arch_label.AppImage"
wget "https://github.com/AppImage/appimagetool/releases/latest/download/$appimagetool"
chmod +x "$appimagetool"
mkdir ConverterNOW.AppDir
cp -r build/linux/$arch/release/bundle/* ConverterNOW.AppDir
# appimagetool creates .DirIcon from the <Icon>.png file in the AppDir root
cp assets/logo.png ConverterNOW.AppDir/logo.png
echo -e '#!/bin/sh\ncd "$(dirname "$0")"\nexec ./converternow' > ConverterNOW.AppDir/AppRun
chmod +x ConverterNOW.AppDir/AppRun
cp linux/io.github.ferraridamiano.ConverterNOW.desktop ConverterNOW.AppDir
desktop-file-edit --set-icon="logo" --set-key="Exec" --set-value="converternow %u" ConverterNOW.AppDir/io.github.ferraridamiano.ConverterNOW.desktop
# Standard freedesktop layout, needed for desktop integration and AppStream validation
mkdir -p ConverterNOW.AppDir/usr/share/applications \
         ConverterNOW.AppDir/usr/share/icons/hicolor/512x512/apps \
         ConverterNOW.AppDir/usr/share/metainfo
cp ConverterNOW.AppDir/io.github.ferraridamiano.ConverterNOW.desktop ConverterNOW.AppDir/usr/share/applications/
cp assets/logo.png ConverterNOW.AppDir/usr/share/icons/hicolor/512x512/apps/
# appstreamcli 0.15.2 (Ubuntu 22.04) does not know the "vcs-browser" URL type and
# would fail validation; keep it in the source metainfo (used by Flathub) but not
# in the AppImage copy.
sed '/<url type="vcs-browser">/d' linux/io.github.ferraridamiano.ConverterNOW.metainfo.xml > ConverterNOW.AppDir/usr/share/metainfo/io.github.ferraridamiano.ConverterNOW.appdata.xml
APPIMAGETOOL_APP_NAME=converternow ./"$appimagetool" ConverterNOW.AppDir
rm -r ConverterNOW.AppDir "$appimagetool"
