%global debug_package %{nil}
Autoreq: 0

Name:          apache-log4j-extras
Version:       %{_VERSION}
Release:       %{_BUILD_NUMBER}%{?dist}
Summary:       Apache Extras Companion for Apache log4j

License:       Proprietary
URL:           https://github.com/Guavus/log4j-extras.git
Source0:       %{name}-%{version}-bin.tar.gz 
Requires:      jdk >= 2000:1.8.0_111

%description
Apache Extras Companion for Apache log4j is a collection of appenders, 
filters, layouts, and receivers for Apache log4j 1.2

%prep

%setup -q

%build

%install
install -d %{buildroot}%{_javalibdir}/%{name} -m 0755
cp %{_builddir}/%{name}-%{version}/*.jar  %{buildroot}%{_javalibdir}/%{name}/

%post
ln -s -f %{_javalibdir}/%{name}/%{name}-%{version}.jar %{_javalibdir}/%{name}/%{name}.jar

%postun
case "$1" in
  0)
    %{__rm} -f %{_javalibdir}/%{name}/%{name}.jar
  ;;
    :
  1)
esac
 
%files
%{_javalibdir}/apache-log4j-extras
