Name:           poseidon-ui
Version:        3.0.1 
Release:        el5
Summary:        Poseidon Monitoring UI
BuildArch:	x86_64
Group:          Application/Internet
License:        GPL
URL:            https://github.com/lanusau/poseidon-ui
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildRequires: ruby-devel rubygem-bundler oracle-instantclient11.2-devel
BuildRequires: postgresql84-devel MySQL-devel libxml2-devel readline-devel libyaml-devel
BuildRequires: gcc-c++ curl-devel
BuildRequires: MySQL-devel >= 5.5.24
Requires: ruby-libs >= 1.9.3
Requires: rubygems >= 1.9.3
Requires: rubygem-rake >= 1.9.3
Requires: rubygem-bundler >= 1.2.1
Requires: rubygem-passenger >= 1.9.3
Requires: rubygem-minitest >= 1.9.3
Requires: oracle-instantclient11.2-basic
Requires: curl >= 7.5.5
Requires: MySQL-shared >= 5.5.24
Requires: postgresql84-libs >= 8.4.13
Requires: openssl >= 0.9.8

# Turn off automatic dependency checking
AutoReqProv: no

# What repository to pull the actual code from
%define git_repo https://github.com/lanusau/poseidon_ui.git
%define git_project poseidon_ui

#
# DIRS
# - Trying to follow Linux file system hierarchy
#
%define rails_home /usr/local/railsapps
%define appdir %{rails_home}/%{name}
%define menudir %{rails_home}/menu
%define logdir /var/log/railsapps/%{name}
%define configdir /etc/railsapps/%{name}
%define cachedir /var/cache/railsapps/%{name}

%description
Poseidon Monitoring UI

%build
rm -rf ./%{git_project}
git clone %{git_repo}
pushd %{git_project}
# Assume releases are on master branch
git checkout master

# Install all required gems into ./vendor/bundle using the handy bundle commmand
LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib
export LD_LIBRARY_PATH
bundle install --deployment --without test development
	
# Compile assets, this only has to be done once AFAIK, so in the RPM is fine
rm -rf ./public/assets/*
bundle exec rake assets:precompile

# Remove gems that are only used for assets
bundle install --deployment --without test development assets --clean

popd

%install
# Create all the defined directories
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT/%{appdir}
install -d $RPM_BUILD_ROOT/%{logdir}
install -d $RPM_BUILD_ROOT/%{configdir}
install -d $RPM_BUILD_ROOT/%{menudir}
install -d $RPM_BUILD_ROOT/%{cachedir}


# Start moving files into the proper place in the build root
pushd %{git_project}

cp config.ru Gemfile Gemfile.lock Rakefile README.md $RPM_BUILD_ROOT/%{appdir}
cp -r app $RPM_BUILD_ROOT/%{appdir}
cp -r config $RPM_BUILD_ROOT/%{appdir}
cp -r db $RPM_BUILD_ROOT/%{appdir}
cp -r extras $RPM_BUILD_ROOT/%{appdir}
cp -r public $RPM_BUILD_ROOT/%{appdir}
cp -r script $RPM_BUILD_ROOT/%{appdir}
cp -r test $RPM_BUILD_ROOT/%{appdir}
cp -r vendor $RPM_BUILD_ROOT/%{appdir}
cp -r .bundle $RPM_BUILD_ROOT/%{appdir}

# Config

touch $RPM_BUILD_ROOT/%{configdir}/database.yml
ln -s %{configdir}/database.yml $RPM_BUILD_ROOT/%{appdir}/config/database.yml

# tmp/cache

ln -s %{cachedir} $RPM_BUILD_ROOT/%{appdir}/tmp

# log

ln -s %{logdir} $RPM_BUILD_ROOT/%{appdir}/log

# Menu
mv $RPM_BUILD_ROOT/%{appdir}/config/menu/*.yml $RPM_BUILD_ROOT/%{menudir}/.
rm -r  $RPM_BUILD_ROOT/%{appdir}/config/menu
ln -s %{menudir}  $RPM_BUILD_ROOT/%{appdir}/config/menu

# Module for Passenger
ln -s %{appdir}/public $RPM_BUILD_ROOT/%{rails_home}/monitoring
	
popd

%clean
#rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%{appdir}
%{menudir}
%{rails_home}/monitoring
%config %{configdir}/database.yml
# passenger runs as nobody apparently and then http as apache, and I'm not sure which
# needs which...so for now do nobody:apache...wonder if it should be set to run as apache?
%attr(770,nobody,apache) %{logdir}
%attr(770,nobody,apache) %{cachedir}
