From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: xfstests integration
Date: Mon, 5 Aug 2013 11:53:17 -0500
Message-ID: <CAH2r5mv_z=_P0R=uMfrSuwLoUU+OHyf8bmHnuwRuLsN0a8XF-A@mail.gmail.com>
References: <20130805165918.2e3ac36e@f163.suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b2e12112347dd04e33625fd
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130805165918.2e3ac36e-c9q3rVCHQSqoYr4blSSd5g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--047d7b2e12112347dd04e33625fd
Content-Type: text/plain; charset=ISO-8859-1

I couldn't find much - but I did see this small patch which I had put
together quickly so they could run against cifs

diff --git a/common b/common
index 0723224..b2334f8 100644
--- a/common
+++ b/common
@@ -126,6 +126,7 @@ check options
     -xfs                test XFS (default)
     -udf                test UDF
     -nfs                test NFS
+    -cifs               test CIFS
     -l			line mode diff
     -xdiff		graphical mode diff
     -udiff		show unified diff (default)
@@ -158,6 +159,11 @@ testlist options
 	    xpand=false
 	    ;;

+	-cifs)	# -cifs ... set FSTYP to cifs
+	    FSTYP=cifs
+	    xpand=false
+	    ;;
+
 	-g)	# -g group ... pick from group file
 	    group=true
 	    xpand=false
@@ -311,4 +317,6 @@ case "$FSTYP" in
 	 ;;
     nfs)
 	 ;;
+    cifs)
+	 ;;
 esac
diff --git a/common.config b/common.config
index 7bed1c5..1e37840 100644
--- a/common.config
+++ b/common.config
@@ -188,6 +188,7 @@ case "$HOSTOS" in
         export BTRFS_UTIL_PROG="`set_prog_path btrfs`"
         export XFS_FSR_PROG="`set_prog_path xfs_fsr`"
         export MKFS_NFS_PROG="false"
+	export MKFS_CIFS_PROG="false"
         ;;
 esac

@@ -221,7 +222,7 @@ fi

 echo $TEST_DEV | grep -q ":" > /dev/null 2>&1
 if [ ! -b "$TEST_DEV" -a "$?" != "0" ]; then
-    echo "common.config: Error: \$TEST_DEV ($TEST_DEV) is not a block
device or a NFS filesystem"
+    echo "common.config: Error: \$TEST_DEV ($TEST_DEV) is not a block
device or an NFS or CIFS filesystem"
     exit 1
 fi

@@ -243,7 +244,7 @@ fi

 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
 if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]; then
-    echo "common.config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) is not a
block device or a NFS filesystem"
+    echo "common.config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) is not a
block device or an NFS or CIFS filesystem"
     exit 1
 fi

diff --git a/common.rc b/common.rc
index 602513a..7ae2f7a 100644
--- a/common.rc
+++ b/common.rc
@@ -85,6 +85,10 @@ _mount_opts()
     nfs)
 	export MOUNT_OPTIONS=$NFS_MOUNT_OPTIONS
 	;;
+    cifs)
+	export MOUNT_OPTIONS=$CIFS_MOUNT_OPTIONS
+	;;
+
     ext2|ext3|ext4|ext4dev)
 	# acls & xattrs aren't turned on by default on ext$FOO
 	export MOUNT_OPTIONS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
@@ -116,6 +120,9 @@ _mkfs_opts()
     nfs)
 	export MKFS_OPTIONS=$NFS_MKFS_OPTIONS
 	;;
+    cifs)
+	export MKFS_OPTIONS=$CIFS_MKFS_OPTIONS
+	;;
     reiserfs)
 	export MKFS_OPTIONS="$REISERFS_MKFS_OPTIONS -q"
 	;;
@@ -327,6 +334,9 @@ _scratch_mkfs()
     nfs*)
 	# do nothing for nfs
 	;;
+    cifs)
+	# do nothing for cifs
+	;;
     udf)
         $MKFS_UDF_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
 	;;
@@ -736,6 +746,13 @@ _require_scratch()
 		     _notrun "this test requires a valid \$SCRATCH_DEV"
 		 fi
 		 ;;
+	cifs)
+		 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
+		 if [ -z "$SCRATCH_DEV" -o "$?" != "0" ]
+		 then
+		     _notrun "this test requires a valid \$SCRATCH_DEV"
+		 fi
+		 ;;
 	*)
 		 if [ -z "$SCRATCH_DEV" -o "`_is_block_dev $SCRATCH_DEV`" = "" ]
 		 then
@@ -1394,6 +1411,9 @@ _check_test_fs()
     nfs)
 	# no way to check consistency for nfs
 	;;
+    cifs)
+	# no way to check consistency for cifs
+	;;
     udf)
 	# do nothing for now
 	;;
@@ -1426,6 +1446,9 @@ _check_scratch_fs()
     nfs*)
 	# Don't know how to check an NFS filesystem, yet.
 	;;
+    cifs)
+	# Don't know how to check an CIFS filesystem, yet.
+	;;
     btrfs)
 	_check_btrfs_filesystem $SCRATCH_DEV
 	;;
@@ -1517,6 +1540,32 @@ _setup_nfs_scratchdir()
     testdir=$SCRATCH_MNT
 }

+_setup_cifs_scratchdir()
+{
+    [ "$FSTYP" != "cifs" ] \
+	&& _fail "setup_cifs_testdir: \$FSTYP is not cifs"
+    [ -z "$SCRATCH_DEV" ] \
+	&& _notrun "this test requires a valid host fs for \$SCRATCH_DEV"
+    [ -z "$SCRATCH_MNT" ] \
+	&& _notrun "this test requires a valid \$SCRATCH_MNT"
+
+    # mounted?
+    if _mount | grep -q $SCRATCH_DEV
+    then
+        # if it's mounted, make sure its on $SCRATCH_MNT
+        if ! _mount | grep $SCRATCH_DEV | grep -q $SCRATCH_MNT
+        then
+            _fail "\$SCRATCH_DEV is mounted but not on \$SCRATCH_MNT
- aborting"
+        fi
+    	$UMOUNT_PROG $SCRATCH_DEV
+    fi
+
+    _scratch_mkfs
+    _scratch_mount
+
+    testdir=$SCRATCH_MNT
+}
+
 #
 # Warning for UDF and NFS:
 # this function calls _setup_udf_scratchdir and _setup_udf_scratchdir
@@ -1535,6 +1584,9 @@ _setup_testdir()
     nfs*)
 	_setup_nfs_scratchdir
 	;;
+    cifs)
+	_setup_cifs_scratchdir
+	;;
     *)
 	testdir=$TEST_DIR
 	;;
@@ -1552,6 +1604,10 @@ _cleanup_testdir()
 	# umount testdir as it is $SCRATCH_MNT which could be used by xfs next
 	[ -n "$testdir" ] && $UMOUNT_PROG $testdir
 	;;
+    cifs)
+	# umount testdir as it is $SCRATCH_MNT which could be used by xfs next
+	[ -n "$testdir" ] && $UMOUNT_PROG $testdir
+	;;
     *)
 	# do nothing, testdir is $TEST_DIR
 	:

On Mon, Aug 5, 2013 at 9:59 AM, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org> wrote:
> Hi Steve,
>
> At SambaXP this year you mentioned that you had done some preliminary
> work towards using the xfstests suite alongside cifs.ko. Do you happen
> to still have the git repo lying around somewhere?
>
> Cheers, David



-- 
Thanks,

Steve

--047d7b2e12112347dd04e33625fd
Content-Type: application/octet-stream; name="xfstest.patch"
Content-Disposition: attachment; filename="xfstest.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hjzx31d90

ZGlmZiAtLWdpdCBhL2NvbW1vbiBiL2NvbW1vbgppbmRleCAwNzIzMjI0Li5iMjMzNGY4IDEwMDY0
NAotLS0gYS9jb21tb24KKysrIGIvY29tbW9uCkBAIC0xMjYsNiArMTI2LDcgQEAgY2hlY2sgb3B0
aW9ucwogICAgIC14ZnMgICAgICAgICAgICAgICAgdGVzdCBYRlMgKGRlZmF1bHQpCiAgICAgLXVk
ZiAgICAgICAgICAgICAgICB0ZXN0IFVERgogICAgIC1uZnMgICAgICAgICAgICAgICAgdGVzdCBO
RlMKKyAgICAtY2lmcyAgICAgICAgICAgICAgIHRlc3QgQ0lGUwogICAgIC1sCQkJbGluZSBtb2Rl
IGRpZmYKICAgICAteGRpZmYJCWdyYXBoaWNhbCBtb2RlIGRpZmYKICAgICAtdWRpZmYJCXNob3cg
dW5pZmllZCBkaWZmIChkZWZhdWx0KQpAQCAtMTU4LDYgKzE1OSwxMSBAQCB0ZXN0bGlzdCBvcHRp
b25zCiAJICAgIHhwYW5kPWZhbHNlCiAJICAgIDs7CiAKKwktY2lmcykJIyAtY2lmcyAuLi4gc2V0
IEZTVFlQIHRvIGNpZnMKKwkgICAgRlNUWVA9Y2lmcworCSAgICB4cGFuZD1mYWxzZQorCSAgICA7
OworCiAJLWcpCSMgLWcgZ3JvdXAgLi4uIHBpY2sgZnJvbSBncm91cCBmaWxlCiAJICAgIGdyb3Vw
PXRydWUKIAkgICAgeHBhbmQ9ZmFsc2UKQEAgLTMxMSw0ICszMTcsNiBAQCBjYXNlICIkRlNUWVAi
IGluCiAJIDs7CiAgICAgbmZzKQogCSA7OworICAgIGNpZnMpCisJIDs7CiBlc2FjCmRpZmYgLS1n
aXQgYS9jb21tb24uY29uZmlnIGIvY29tbW9uLmNvbmZpZwppbmRleCA3YmVkMWM1Li4xZTM3ODQw
IDEwMDY0NAotLS0gYS9jb21tb24uY29uZmlnCisrKyBiL2NvbW1vbi5jb25maWcKQEAgLTE4OCw2
ICsxODgsNyBAQCBjYXNlICIkSE9TVE9TIiBpbgogICAgICAgICBleHBvcnQgQlRSRlNfVVRJTF9Q
Uk9HPSJgc2V0X3Byb2dfcGF0aCBidHJmc2AiCiAgICAgICAgIGV4cG9ydCBYRlNfRlNSX1BST0c9
ImBzZXRfcHJvZ19wYXRoIHhmc19mc3JgIgogICAgICAgICBleHBvcnQgTUtGU19ORlNfUFJPRz0i
ZmFsc2UiCisJZXhwb3J0IE1LRlNfQ0lGU19QUk9HPSJmYWxzZSIKICAgICAgICAgOzsKIGVzYWMK
IApAQCAtMjIxLDcgKzIyMiw3IEBAIGZpCiAKIGVjaG8gJFRFU1RfREVWIHwgZ3JlcCAtcSAiOiIg
PiAvZGV2L251bGwgMj4mMQogaWYgWyAhIC1iICIkVEVTVF9ERVYiIC1hICIkPyIgIT0gIjAiIF07
IHRoZW4KLSAgICBlY2hvICJjb21tb24uY29uZmlnOiBFcnJvcjogXCRURVNUX0RFViAoJFRFU1Rf
REVWKSBpcyBub3QgYSBibG9jayBkZXZpY2Ugb3IgYSBORlMgZmlsZXN5c3RlbSIKKyAgICBlY2hv
ICJjb21tb24uY29uZmlnOiBFcnJvcjogXCRURVNUX0RFViAoJFRFU1RfREVWKSBpcyBub3QgYSBi
bG9jayBkZXZpY2Ugb3IgYW4gTkZTIG9yIENJRlMgZmlsZXN5c3RlbSIKICAgICBleGl0IDEKIGZp
CiAKQEAgLTI0Myw3ICsyNDQsNyBAQCBmaQogCiBlY2hvICRTQ1JBVENIX0RFViB8IGdyZXAgLXEg
IjoiID4gL2Rldi9udWxsIDI+JjEKIGlmIFsgISAteiAiJFNDUkFUQ0hfREVWIiAtYSAhIC1iICIk
U0NSQVRDSF9ERVYiIC1hICIkPyIgIT0gIjAiIF07IHRoZW4KLSAgICBlY2hvICJjb21tb24uY29u
ZmlnOiBFcnJvcjogXCRTQ1JBVENIX0RFViAoJFNDUkFUQ0hfREVWKSBpcyBub3QgYSBibG9jayBk
ZXZpY2Ugb3IgYSBORlMgZmlsZXN5c3RlbSIKKyAgICBlY2hvICJjb21tb24uY29uZmlnOiBFcnJv
cjogXCRTQ1JBVENIX0RFViAoJFNDUkFUQ0hfREVWKSBpcyBub3QgYSBibG9jayBkZXZpY2Ugb3Ig
YW4gTkZTIG9yIENJRlMgZmlsZXN5c3RlbSIKICAgICBleGl0IDEKIGZpCiAKZGlmZiAtLWdpdCBh
L2NvbW1vbi5yYyBiL2NvbW1vbi5yYwppbmRleCA2MDI1MTNhLi43YWUyZjdhIDEwMDY0NAotLS0g
YS9jb21tb24ucmMKKysrIGIvY29tbW9uLnJjCkBAIC04NSw2ICs4NSwxMCBAQCBfbW91bnRfb3B0
cygpCiAgICAgbmZzKQogCWV4cG9ydCBNT1VOVF9PUFRJT05TPSRORlNfTU9VTlRfT1BUSU9OUwog
CTs7CisgICAgY2lmcykKKwlleHBvcnQgTU9VTlRfT1BUSU9OUz0kQ0lGU19NT1VOVF9PUFRJT05T
CisJOzsKKwogICAgIGV4dDJ8ZXh0M3xleHQ0fGV4dDRkZXYpCiAJIyBhY2xzICYgeGF0dHJzIGFy
ZW4ndCB0dXJuZWQgb24gYnkgZGVmYXVsdCBvbiBleHQkRk9PCiAJZXhwb3J0IE1PVU5UX09QVElP
TlM9Ii1vIGFjbCx1c2VyX3hhdHRyICRFWFRfTU9VTlRfT1BUSU9OUyIKQEAgLTExNiw2ICsxMjAs
OSBAQCBfbWtmc19vcHRzKCkKICAgICBuZnMpCiAJZXhwb3J0IE1LRlNfT1BUSU9OUz0kTkZTX01L
RlNfT1BUSU9OUwogCTs7CisgICAgY2lmcykKKwlleHBvcnQgTUtGU19PUFRJT05TPSRDSUZTX01L
RlNfT1BUSU9OUworCTs7CiAgICAgcmVpc2VyZnMpCiAJZXhwb3J0IE1LRlNfT1BUSU9OUz0iJFJF
SVNFUkZTX01LRlNfT1BUSU9OUyAtcSIKIAk7OwpAQCAtMzI3LDYgKzMzNCw5IEBAIF9zY3JhdGNo
X21rZnMoKQogICAgIG5mcyopCiAJIyBkbyBub3RoaW5nIGZvciBuZnMKIAk7OworICAgIGNpZnMp
CisJIyBkbyBub3RoaW5nIGZvciBjaWZzCisJOzsKICAgICB1ZGYpCiAgICAgICAgICRNS0ZTX1VE
Rl9QUk9HICRNS0ZTX09QVElPTlMgJCogJFNDUkFUQ0hfREVWID4gL2Rldi9udWxsCiAJOzsKQEAg
LTczNiw2ICs3NDYsMTMgQEAgX3JlcXVpcmVfc2NyYXRjaCgpCiAJCSAgICAgX25vdHJ1biAidGhp
cyB0ZXN0IHJlcXVpcmVzIGEgdmFsaWQgXCRTQ1JBVENIX0RFViIKIAkJIGZpCiAJCSA7OworCWNp
ZnMpCisJCSBlY2hvICRTQ1JBVENIX0RFViB8IGdyZXAgLXEgIjoiID4gL2Rldi9udWxsIDI+JjEK
KwkJIGlmIFsgLXogIiRTQ1JBVENIX0RFViIgLW8gIiQ/IiAhPSAiMCIgXQorCQkgdGhlbgorCQkg
ICAgIF9ub3RydW4gInRoaXMgdGVzdCByZXF1aXJlcyBhIHZhbGlkIFwkU0NSQVRDSF9ERVYiCisJ
CSBmaQorCQkgOzsKIAkqKQogCQkgaWYgWyAteiAiJFNDUkFUQ0hfREVWIiAtbyAiYF9pc19ibG9j
a19kZXYgJFNDUkFUQ0hfREVWYCIgPSAiIiBdCiAJCSB0aGVuCkBAIC0xMzk0LDYgKzE0MTEsOSBA
QCBfY2hlY2tfdGVzdF9mcygpCiAgICAgbmZzKQogCSMgbm8gd2F5IHRvIGNoZWNrIGNvbnNpc3Rl
bmN5IGZvciBuZnMKIAk7OworICAgIGNpZnMpCisJIyBubyB3YXkgdG8gY2hlY2sgY29uc2lzdGVu
Y3kgZm9yIGNpZnMKKwk7OwogICAgIHVkZikKIAkjIGRvIG5vdGhpbmcgZm9yIG5vdwogCTs7CkBA
IC0xNDI2LDYgKzE0NDYsOSBAQCBfY2hlY2tfc2NyYXRjaF9mcygpCiAgICAgbmZzKikKIAkjIERv
bid0IGtub3cgaG93IHRvIGNoZWNrIGFuIE5GUyBmaWxlc3lzdGVtLCB5ZXQuCiAJOzsKKyAgICBj
aWZzKQorCSMgRG9uJ3Qga25vdyBob3cgdG8gY2hlY2sgYW4gQ0lGUyBmaWxlc3lzdGVtLCB5ZXQu
CisJOzsKICAgICBidHJmcykKIAlfY2hlY2tfYnRyZnNfZmlsZXN5c3RlbSAkU0NSQVRDSF9ERVYK
IAk7OwpAQCAtMTUxNyw2ICsxNTQwLDMyIEBAIF9zZXR1cF9uZnNfc2NyYXRjaGRpcigpCiAgICAg
dGVzdGRpcj0kU0NSQVRDSF9NTlQKIH0KIAorX3NldHVwX2NpZnNfc2NyYXRjaGRpcigpCit7Cisg
ICAgWyAiJEZTVFlQIiAhPSAiY2lmcyIgXSBcCisJJiYgX2ZhaWwgInNldHVwX2NpZnNfdGVzdGRp
cjogXCRGU1RZUCBpcyBub3QgY2lmcyIKKyAgICBbIC16ICIkU0NSQVRDSF9ERVYiIF0gXAorCSYm
IF9ub3RydW4gInRoaXMgdGVzdCByZXF1aXJlcyBhIHZhbGlkIGhvc3QgZnMgZm9yIFwkU0NSQVRD
SF9ERVYiCisgICAgWyAteiAiJFNDUkFUQ0hfTU5UIiBdIFwKKwkmJiBfbm90cnVuICJ0aGlzIHRl
c3QgcmVxdWlyZXMgYSB2YWxpZCBcJFNDUkFUQ0hfTU5UIgorCisgICAgIyBtb3VudGVkPworICAg
IGlmIF9tb3VudCB8IGdyZXAgLXEgJFNDUkFUQ0hfREVWCisgICAgdGhlbgorICAgICAgICAjIGlm
IGl0J3MgbW91bnRlZCwgbWFrZSBzdXJlIGl0cyBvbiAkU0NSQVRDSF9NTlQKKyAgICAgICAgaWYg
ISBfbW91bnQgfCBncmVwICRTQ1JBVENIX0RFViB8IGdyZXAgLXEgJFNDUkFUQ0hfTU5UCisgICAg
ICAgIHRoZW4KKyAgICAgICAgICAgIF9mYWlsICJcJFNDUkFUQ0hfREVWIGlzIG1vdW50ZWQgYnV0
IG5vdCBvbiBcJFNDUkFUQ0hfTU5UIC0gYWJvcnRpbmciCisgICAgICAgIGZpCisgICAgCSRVTU9V
TlRfUFJPRyAkU0NSQVRDSF9ERVYKKyAgICBmaQorCisgICAgX3NjcmF0Y2hfbWtmcworICAgIF9z
Y3JhdGNoX21vdW50CisKKyAgICB0ZXN0ZGlyPSRTQ1JBVENIX01OVAorfQorCiAjCiAjIFdhcm5p
bmcgZm9yIFVERiBhbmQgTkZTOgogIyB0aGlzIGZ1bmN0aW9uIGNhbGxzIF9zZXR1cF91ZGZfc2Ny
YXRjaGRpciBhbmQgX3NldHVwX3VkZl9zY3JhdGNoZGlyCkBAIC0xNTM1LDYgKzE1ODQsOSBAQCBf
c2V0dXBfdGVzdGRpcigpCiAgICAgbmZzKikKIAlfc2V0dXBfbmZzX3NjcmF0Y2hkaXIKIAk7Owor
ICAgIGNpZnMpCisJX3NldHVwX2NpZnNfc2NyYXRjaGRpcgorCTs7CiAgICAgKikKIAl0ZXN0ZGly
PSRURVNUX0RJUgogCTs7CkBAIC0xNTUyLDYgKzE2MDQsMTAgQEAgX2NsZWFudXBfdGVzdGRpcigp
CiAJIyB1bW91bnQgdGVzdGRpciBhcyBpdCBpcyAkU0NSQVRDSF9NTlQgd2hpY2ggY291bGQgYmUg
dXNlZCBieSB4ZnMgbmV4dAogCVsgLW4gIiR0ZXN0ZGlyIiBdICYmICRVTU9VTlRfUFJPRyAkdGVz
dGRpcgogCTs7CisgICAgY2lmcykKKwkjIHVtb3VudCB0ZXN0ZGlyIGFzIGl0IGlzICRTQ1JBVENI
X01OVCB3aGljaCBjb3VsZCBiZSB1c2VkIGJ5IHhmcyBuZXh0CisJWyAtbiAiJHRlc3RkaXIiIF0g
JiYgJFVNT1VOVF9QUk9HICR0ZXN0ZGlyCisJOzsKICAgICAqKQogCSMgZG8gbm90aGluZywgdGVz
dGRpciBpcyAkVEVTVF9ESVIKIAk6Cg==
--047d7b2e12112347dd04e33625fd--
