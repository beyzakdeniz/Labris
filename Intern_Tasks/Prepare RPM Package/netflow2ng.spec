Name:           netflow2ng
Version:        0.0.4
Release:        1%{?dist}
Summary:        NetFlow v9 collector for ntopng

License:        MIT
URL:            https://github.com/synfinatic/%{name}
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  git 
BuildRequires:  make
BuildRequires:  rpm
BuildRequires:  golang
BuildRequires:  gcc 
BuildRequires:  pkgconfig 
BuildRequires:  zeromq-devel
BuildRequires:  epel-release
Requires:       bash
Requires:       zeromq


%description
NetFlow/sFlow analysis console that caters to various use cases, available for free or commercially.


%prep
%setup -q


%build
make %{?_smp_mflags}


%install
make
mkdir -p %{buildroot}/%{_bindir}
cp dist/netflow2ng-0.0.4 netflow2ng
install -m 0755 netflow2ng %{buildroot}/%{_bindir}


%files
%{_bindir}/%{name}


%changelog
* Wed Jan 24 2024 root
- First netflow2ng package

