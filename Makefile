TEMPLATE = template.html

%.html: %.md
	markdown2 -x toc -x wiki-tables -x fenced-code-blocks $< >$@ || rm -f $@

all: gitworkshop-styled.html

gitworkshop-styled.html: gitworkshop.html toc.html template.html
	apply-template -v content=@$< \
		-v toc=@toc.html \
		-v title="Git Workshop" $(TEMPLATE) > $@ || rm -f $@

toc.html: gitworkshop.html
	python gentoc.py -m1 < $< > $@ || rm -f $@

clean:
	rm -f gitworkshop.html gitworkshop-styled.html
