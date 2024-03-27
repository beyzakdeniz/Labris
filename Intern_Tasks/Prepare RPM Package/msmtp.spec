Name:		msmtp
Version:	1.8.25
Release:	1%{?dist}
Summary:	Msmtp is an SMTP client 

License:	GPLv3+
URL:		https://marlam.de/%{name}/
Source0:	%{name}-%{version}.tar.xz

BuildRequires:  make
BuildRequires:  gcc

%description
In the default mode,
it transmits a mail to an SMTP server which takes care of further delivery.

%prep
%setup -q


%build
%configure
make %{?_smp_mflags}


%install
make
mkdir -p %{buildroot}/%{_bindir}
cp ~/rpmbuild/BUILD/msmtp-1.8.25/src/msmtp msmtp
install -m 0755 msmtp %{buildroot}/%{_bindir}


%files
%{_bindir}/%{name}


%changelog
* Fri Jan 26 2024 root - 1.8.25-1
-

