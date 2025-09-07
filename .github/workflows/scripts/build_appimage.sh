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
cp assets/app_icons/logo.svg ConverterNOW.AppDir
echo -e '#!/bin/sh\ncd "$(dirname "$0")"\nexec ./converternow' > ConverterNOW.AppDir/AppRun
chmod +x ConverterNOW.AppDir/AppRun
cp linux/io.github.ferraridamiano.ConverterNOW.desktop ConverterNOW.AppDir
desktop-file-edit --set-icon="logo" --set-key="Exec" --set-value="converternow %u" ConverterNOW.AppDir/io.github.ferraridamiano.ConverterNOW.desktop
APPIMAGETOOL_APP_NAME=converternow ./"$appimagetool" ConverterNOW.AppDir
rm -r ConverterNOW.AppDir "$appimagetool"
