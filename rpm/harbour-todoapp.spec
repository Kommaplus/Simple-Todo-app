Name:           harbour-todoapp
Version:        0.2
Release:        1
BuildArch:      noarch
Summary:        Simple todo app for Sailfish OS
License:        MIT
URL:            https://github.com/Kommaplus/Simple-Todo-app
Source0:        harbour-todoapp-0.2.tar.gz

%description
A simple and friendly todo app for Sailfish OS, built with pure QML and
Sailfish Silica. Keeps lists of todos with deadlines in a local database.

%prep
%setup -q

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/usr/share/harbour-todoapp/qml
mkdir -p %{buildroot}/usr/share/applications
mkdir -p %{buildroot}/usr/share/icons/hicolor/86x86/apps
mkdir -p %{buildroot}/usr/share/icons/hicolor/108x108/apps
mkdir -p %{buildroot}/usr/share/icons/hicolor/128x128/apps
mkdir -p %{buildroot}/usr/share/icons/hicolor/172x172/apps

install -m 644 qml/TodoMain.qml qml/FirstPage.qml qml/SecondPage.qml \
    qml/MyButton.qml qml/PunktDialog.qml qml/TodoCover.qml \
    %{buildroot}/usr/share/harbour-todoapp/qml/
mv %{buildroot}/usr/share/harbour-todoapp/qml/TodoMain.qml %{buildroot}/usr/share/harbour-todoapp/qml/harbour-todoapp.qml
install -m 644 icons/harbour-todoapp-86.png %{buildroot}/usr/share/harbour-todoapp/harbour-todoapp.png
install -m 644 icons/harbour-todoapp-86.png %{buildroot}/usr/share/icons/hicolor/86x86/apps/harbour-todoapp.png
install -m 644 icons/harbour-todoapp-108.png %{buildroot}/usr/share/icons/hicolor/108x108/apps/harbour-todoapp.png
install -m 644 icons/harbour-todoapp-128.png %{buildroot}/usr/share/icons/hicolor/128x128/apps/harbour-todoapp.png
install -m 644 icons/harbour-todoapp-172.png %{buildroot}/usr/share/icons/hicolor/172x172/apps/harbour-todoapp.png
install -m 644 harbour-todoapp.desktop %{buildroot}/usr/share/applications/harbour-todoapp.desktop

%files
%defattr(-,root,root,-)
/usr/share/harbour-todoapp/qml/harbour-todoapp.qml
/usr/share/harbour-todoapp/qml/FirstPage.qml
/usr/share/harbour-todoapp/qml/SecondPage.qml
/usr/share/harbour-todoapp/qml/MyButton.qml
/usr/share/harbour-todoapp/qml/PunktDialog.qml
/usr/share/harbour-todoapp/qml/TodoCover.qml
/usr/share/harbour-todoapp/harbour-todoapp.png
/usr/share/icons/hicolor/86x86/apps/harbour-todoapp.png
/usr/share/icons/hicolor/108x108/apps/harbour-todoapp.png
/usr/share/icons/hicolor/128x128/apps/harbour-todoapp.png
/usr/share/icons/hicolor/172x172/apps/harbour-todoapp.png
/usr/share/applications/harbour-todoapp.desktop

%changelog
* Sun Nov 15 2026 Peter Laustsen <Kommaplus@users.noreply.github.com> - 0.2-1
- Harbour-ready release: sandboxed, sailfish-qml launcher, full icon set.
* Sun Nov 15 2026 Peter Laustsen <Kommaplus@users.noreply.github.com> - 0.1-2
- Launch via sailfish-qml with the silica booster.
* Sat Nov 14 2026 Peter Laustsen <Kommaplus@users.noreply.github.com> - 0.1-1
- Initial RPM package of the Todo app.
