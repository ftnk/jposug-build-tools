
-include common.mak
-include target.mak

BUILDLIST=build.list.`uname -v`

predepend::
	rm -f $(TARGETMAK)
	if [ -z $${PKGBUILD_IPS_REPO} ];then \
		echo REPOSITRY=localhost >> $(TARGETMAK);\
	else \
		echo REPOSITRY=$${PKGBUILD_IPS_REPO} >> $(TARGETMAK);\
	fi
	printf "TARGET=">> $(TARGETMAK)
	cat $(BUILDLIST) | sed 's/^#.*//g;s/\.spec$$/.proto/g;' |xargs >> $(TARGETMAK)
	echo 'all : $$(TARGET)' >> $(TARGETMAK)

depend:: predepend
	../bin/spec_depend.rb $(BUILDLIST) >> $(TARGETMAK)
	../bin/spec2ipsname.rb > spec2ipsname.list

preinstall::
	sudo pkg install -v $(PRE_INSTALL)

clean::
	rm -f $(TARGET) $(TARGETMAK) $(patsubst %.info,%.proto,$(TARGET))

publish:: 
	sudo $(PUBLISH_REPOSITORY) publish /var/pkglocal rpool/pkg

release:: 
	sudo $(PUBLISH_REPOSITORY) release /var/pkgrelease/root rpool/pkg

