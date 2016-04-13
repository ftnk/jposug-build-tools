#
# common.mak
#

SPECBUILD=../bin/specbuild.sh 
TARGETMAK=target.mak
SPECDEPEND=../bin/spec_depend.rb
SPECDEPEND_ACCURATELY=../bin/spec_depend_spectool.pl
SPECDEPENDINSTALL=../bin/spec_depend_install.pl
CHECK_INSTALL=../bin/check_install.sh
PKGSEND_MANIFEST=../bin/pkgsend_manifest.sh
INSTALL_SPEC=../bin/install_spec.rb
PUBLISH_REPOSITORY=../bin/publish_repository.sh
CAT_PROTO=../bin/cat_proto.rb

.SUFFIXES : .spec .proto

.spec.proto :
	$(SPECBUILD) $<
	# cat ~/packages/PKGMAPS/proto/`$(GET_NAME) $<`.proto > $@
	$(CAT_PROTO) $< > $@
	$(INSTALL_SPEC) $@
