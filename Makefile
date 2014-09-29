TEMPLATE = template.html

%.html: %.md
	markdown2 -x toc -x wiki-tables -x fenced-code-blocks $< >$@ || rm -f $@

all: index.html

index.html: gitworkshop.html toc.html template.html
	bin/apply-template -v content=@$< \
		-v toc=@toc.html \
		-v title="Git Workshop" $(TEMPLATE) > $@ || rm -f $@

toc.html: gitworkshop.html
	bin/gentoc -m2 < $< > $@ || rm -f $@

clean:
	rm -f gitworkshop.html gitworkshop-styled.html toc.html index.html
