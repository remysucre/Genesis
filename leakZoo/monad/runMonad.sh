ghc MonadThunk.hs --make -O0 -rtsopts;
./MonadThunk +RTS -h;
hp2ps MonadThunk.hp;
gnome-open MonadThunk.ps;
