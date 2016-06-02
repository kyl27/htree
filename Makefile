CC = ghc
CFLAGS = -O2

all: htree tree

htree: htree.hs
	$(CC) $(CFLAGS) -o htree htree.hs
	strip htree

tree: tree.hs
	$(CC) $(CFLAGS) -o tree tree.hs
	strip tree

clean:
	rm -rf tree htree *.o *.hi
