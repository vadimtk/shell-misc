BUILDDIR=$1
rm -fr $1-build
mkdir -p $1-build
cd $1-build
cmake -DBUILD_CONFIG=mysql_release -DDOWNLOAD_BOOST=1 -DWITH_BOOST=../libboost -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=../$1-install ../$1
