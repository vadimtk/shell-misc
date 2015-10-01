export PSMSRC=`pwd`
export INSTALLDIR=$PSMSRC/install
cd $PSMSRC/src/third_party/PerconaFT; cmake . -DCMAKE_BUILD_TYPE=Release -DUSE_VALGRIND=OFF -DTOKU_DEBUG_PARANOID=OFF -DBUILD_TESTING=OFF -DCMAKE_INSTALL_PREFIX=/ -DJEMALLOC_SOURCE_DIR=$PSMSRC/src/third_party/jemalloc; \
        make -j4; \
        make install DESTDIR=$INSTALLDIR
        
scons  mongod mongos mongo -j4  --release --opt=on --rocksdb  CPPPATH=$PWD/install/include LIBPATH=$PWD/install/lib --allocator=jemalloc --PerconaFT
