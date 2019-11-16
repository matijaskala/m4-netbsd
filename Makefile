MAIN_SRCS=	parser.c tokenizer.c eval.c expr.c look.c main.c misc.c gnum4.c trace.c
OHASH_SRCS=	ohash_create_entry.c ohash_delete.c ohash_do.c ohash_entries.c \
	ohash_enum.c ohash_init.c ohash_interval.c \
	ohash_lookup_interval.c ohash_lookup_memory.c ohash_qlookup.c \
	ohash_qlookupi.c
SRCS=$(MAIN_SRCS) $(OHASH_SRCS:%=lib/%)

all: m4

m4: $(SRCS:%.c=%.o)
	$(CC) -o $@ $^ $(shell pkg-config --libs libbsd-overlay) -lfl $(LDFLAGS)

%.o: %.c
	$(CC) -c -o $@ $< $(shell pkg-config --cflags libbsd-overlay) -Ilib $(CFLAGS)

tokenizer.o: parser.c

install: all
	install -d $(DESTDIR)/usr/bin
	install m4 $(DESTDIR)/usr/bin
	install -d $(DESTDIR)/usr/share/man/man1
	install -m644 m4.1 $(DESTDIR)/usr/share/man/man1

clean:
	$(RM) m4 parser.c parser.h tokenizer.c
	$(RM) $(SRCS:%.c=%.o)

parser.c: parser.y
	yacc -b parser -d parser.y
	mv parser.tab.c parser.c
	mv parser.tab.h parser.h

tokenizer.c: tokenizer.l
	lex -t $< > $@
