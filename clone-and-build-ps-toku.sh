git clone -b 5.6 git@github.com:percona/percona-server percona-server-5.6
git clone git@github.com:tokutek/tokudb-engine
ln -s ../../tokudb-engine/storage/tokudb percona-server-5.6/storage
git clone git@github.com:tokutek/ft-index
ln -s ../../../ft-index tokudb-engine/storage/tokudb
mkdir percona-server-5.6-build
mkdir percona-server-5.6-install
cd percona-server-5.6-build
#cmake ..
#make install
