Name:           todoapp
Version:        0.1
Release:        2
BuildArch:      noarch
Summary:        Simple todo app for Sailfish OS
License:        MIT
URL:            https://github.com/Kommaplus/Simple-Todo-app
Source0:        todoapp-0.1.tar.gz
Requires:       libsailfishapp-launcher

%description
A simple and friendly todo app for Sailfish OS, built with pure QML and
Sailfish Silica. Keeps lists of todos with deadlines in a local database.

%prep
%setup -q

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/usr/share/todoapp/qml
mkdir -p %{buildroot}/usr/share/applications
mkdir -p %{buildroot}/usr/share/icons/hicolor/86x86/apps

install -m 644 qml/TodoMain.qml qml/FirstPage.qml qml/SecondPage.qml \
    qml/MyButton.qml qml/PunktDialog.qml qml/TodoCover.qml \
    %{buildroot}/usr/share/todoapp/qml/
mv %{buildroot}/usr/share/todoapp/qml/TodoMain.qml %{buildroot}/usr/share/todoapp/qml/todoapp.qml
install -m 644 todoapp.png %{buildroot}/usr/share/todoapp/todoapp.png
install -m 644 todoapp.png %{buildroot}/usr/share/icons/hicolor/86x86/apps/todoapp.png
install -m 644 todoapp.desktop %{buildroot}/usr/share/applications/todoapp.desktop

%files
%defattr(-,root,root,-)
/usr/share/todoapp/qml/todoapp.qml
/usr/share/todoapp/qml/FirstPage.qml
/usr/share/todoapp/qml/SecondPage.qml
/usr/share/todoapp/qml/MyButton.qml
/usr/share/todoapp/qml/PunktDialog.qml
/usr/share/todoapp/qml/TodoCover.qml
/usr/share/todoapp/todoapp.png
/usr/share/applications/todoapp.desktop
/usr/share/icons/hicolor/86x86/apps/todoapp.png

%changelog
* Sun Nov 15 2026 Peter Laustsen <Kommaplus@users.noreply.github.com> - 0.1-2
- Launch via sailfish-qml with the silica booster for proper launcher integration.
* Sat Nov 14 2026 Peter Laustsen <Kommaplus@users.noreply.github.com> - 0.1-1
- Initial RPM package of the Todo app.
