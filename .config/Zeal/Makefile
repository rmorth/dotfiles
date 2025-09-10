# ~/place/where/you/cloned/Yanpas/mandocset/Makefile
MANPAGES = /usr/share/man
DOCSETSDIR = $(HOME)/.local/share/Zeal/Zeal/docsets
DOCSETNAME = Man_pages
# if not supplied, defaults to first word of DOCSETNAME, split on underscores
#SHORTCUT = man
ICON = etc/tux.png
ICON2X = $(ICON:.png=@2x.png)
MAYBEDO = $(if $(DRYRUN),echo)

docset: $(DOCSETNAME).docset/Contents/Info.plist

install: $(DOCSETSDIR)/$(DOCSETNAME).docset/Contents/Info.plist

clean:
	$(MAYBEDO) rm -rf $(DOCSETNAME).docset

reallyclean: clean
	$(MAYBEDO) rm -rf $(DOCSETSDIR)/$(DOCSETNAME).docset

$(DOCSETNAME).docset/Contents/Info.plist:
	$(MAYBEDO) python3 mandocset.py -o $(DOCSETNAME) -i $(ICON) -I $(ICON2X) -p $(MANPAGES)
ifneq ($(SHORTCUT),)
	$(MAYBEDO) sed -i "/DocSetPlatformFamily/{N;s^<string>.*</string>^<string>$(SHORTCUT)</string>^;}" $@
endif

# use 'cp -r' here if you don't have 'rsync' installed
$(DOCSETSDIR)/$(DOCSETNAME).docset/Contents/Info.plist: $(DOCSETNAME).docset/Contents/Info.plist
	$(MAYBEDO) rsync -av --delete $(DOCSETNAME).docset $(DOCSETSDIR)	
