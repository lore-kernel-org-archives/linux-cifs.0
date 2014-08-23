From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/2] common: add cifs support
Date: Sat, 23 Aug 2014 12:16:02 +0400
Message-ID: <1408781763-30127-2-git-send-email-pshilovsky@samba.org>
References: <1408781763-30127-1-git-send-email-pshilovsky@samba.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408781763-30127-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pass -cifs argument from command line to enable cifs testing.

Reviewed-by: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 README            |  5 +++--
 check             |  2 ++
 common/config     | 17 +++++++++++++----
 common/rc         | 33 +++++++++++++++++++++++++++++++++
 tests/generic/013 |  7 ++++++-
 5 files changed, 57 insertions(+), 7 deletions(-)

diff --git a/README b/README
index b299c8f..51d0a03 100644
--- a/README
+++ b/README
@@ -91,14 +91,15 @@ Running tests:
     - By default the tests suite will run xfs tests:
     - ./check '*/001' '*/002' '*/003'
     - ./check '*/06?'
-    - You can explicitly specify NFS, otherwise the filesystem type will be
-      autodetected from $TEST_DEV:
+    - You can explicitly specify NFS or CIFS, otherwise the filesystem type will
+      be autodetected from $TEST_DEV:
       ./check -nfs [test(s)]
     - Groups of tests maybe ran by: ./check -g [group(s)]
       See the 'group' file for details on groups
     - for udf tests: ./check -udf [test(s)]
       Running all the udf tests: ./check -udf -g udf
     - for running nfs tests: ./check -nfs [test(s)]
+    - for running cifs tests: ./check -cifs [test(s)]
     - To randomize test order: ./check -r [test(s)]
 
     
diff --git a/check b/check
index 77c6559..42a1ac2 100755
--- a/check
+++ b/check
@@ -68,6 +68,7 @@ usage()
 
 check options
     -nfs                test NFS
+    -cifs               test CIFS
     -tmpfs              test TMPFS
     -l			line mode diff
     -udiff		show unified diff (default)
@@ -205,6 +206,7 @@ while [ $# -gt 0 ]; do
 	-\? | -h | --help) usage ;;
 
 	-nfs)	FSTYP=nfs ;;
+	-cifs)	FSTYP=cifs ;;
 	-tmpfs)	FSTYP=tmpfs ;;
 
 	-g)	group=$2 ; shift ;
diff --git a/common/config b/common/config
index 10cc6fe..045a3e4 100644
--- a/common/config
+++ b/common/config
@@ -206,6 +206,7 @@ case "$HOSTOS" in
         export MKFS_UDF_PROG="`set_prog_path mkfs_udf`"
         export XFS_FSR_PROG="`set_prog_path /usr/etc/fsr_xfs`"
         export MKFS_NFS_PROG="false"
+        export MKFS_CIFS_PROG="false"
         ;;
     Linux)
         export MKFS_XFS_PROG="`set_prog_path mkfs.xfs`"
@@ -215,6 +216,7 @@ case "$HOSTOS" in
         export BTRFS_SHOW_SUPER_PROG="`set_prog_path btrfs-show-super`"
         export XFS_FSR_PROG="`set_prog_path xfs_fsr`"
         export MKFS_NFS_PROG="false"
+        export MKFS_CIFS_PROG="false"
         ;;
 esac
 
@@ -228,6 +230,7 @@ fi
 
 _mount_opts()
 {
+
 	case $FSTYP in
 	xfs)
 		export MOUNT_OPTIONS=$XFS_MOUNT_OPTIONS
@@ -238,6 +241,9 @@ _mount_opts()
 	nfs)
 		export MOUNT_OPTIONS=$NFS_MOUNT_OPTIONS
 		;;
+	cifs)
+		export MOUNT_OPTIONS=$CIFS_MOUNT_OPTIONS
+		;;
 	ext2|ext3|ext4|ext4dev)
 		# acls & xattrs aren't turned on by default on ext$FOO
 		export MOUNT_OPTIONS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
@@ -273,6 +279,9 @@ _mkfs_opts()
 	nfs)
 		export MKFS_OPTIONS=$NFS_MKFS_OPTIONS
 		;;
+	cifs)
+		export MKFS_OPTIONS=$CIFS_MKFS_OPTIONS
+		;;
 	reiserfs)
 		export MKFS_OPTIONS="$REISERFS_MKFS_OPTIONS -q"
 		;;
@@ -408,9 +417,9 @@ get_next_config() {
 		exit 1
 	fi
 
-	echo $TEST_DEV | grep -q ":" > /dev/null 2>&1
+	echo $TEST_DEV | grep -qE ":|//" > /dev/null 2>&1
 	if [ ! -b "$TEST_DEV" -a "$?" != "0" ]; then
-		echo "common/config: Error: \$TEST_DEV ($TEST_DEV) is not a block device or a NFS filesystem"
+		echo "common/config: Error: \$TEST_DEV ($TEST_DEV) is not a block device or a NFS or CIFS filesystem"
 		exit 1
 	fi
 
@@ -431,9 +440,9 @@ get_next_config() {
 		export SCRATCH_DEV_NOT_SET=true
 	fi
 
-	echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
+	echo $SCRATCH_DEV | grep -qE ":|//" > /dev/null 2>&1
 	if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]; then
-		echo "common/config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) is not a block device or a NFS filesystem"
+		echo "common/config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) is not a block device or a NFS or CIFS filesystem"
 		exit 1
 	fi
 
diff --git a/common/rc b/common/rc
index 16da898..dbc99ee 100644
--- a/common/rc
+++ b/common/rc
@@ -107,6 +107,8 @@ case "$FSTYP" in
 	 ;;
     nfs)
 	 ;;
+    cifs)
+	 ;;
 esac
 
 # make sure we have a standard umask
@@ -148,6 +150,11 @@ _test_options()
     type=$1
     TEST_OPTIONS=""
 
+    if [ "$FSTYP" = "cifs" ]; then
+        TEST_OPTIONS="$MOUNT_OPTIONS"
+        return
+    fi
+
     if [ "$FSTYP" != "xfs" ]; then
         return
     fi
@@ -497,6 +504,9 @@ _test_mkfs()
     nfs*)
 	# do nothing for nfs
 	;;
+    cifs)
+	# do nothing for cifs
+	;;
     udf)
         $MKFS_UDF_PROG $MKFS_OPTIONS $* $TEST_DEV > /dev/null
 	;;
@@ -518,6 +528,9 @@ _scratch_mkfs()
     nfs*)
 	# do nothing for nfs
 	;;
+    cifs)
+	# do nothing for cifs
+	;;
     udf)
         $MKFS_UDF_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
 	;;
@@ -967,6 +980,9 @@ _require_scratch()
 	nfs*)
                  _notrun "requires a scratch device"
 		 ;;
+	cifs)
+		_notrun "requires a scratch device"
+		;;
 	tmpfs)
 		if [ -z "$SCRATCH_DEV" -o ! -d "$SCRATCH_MNT" ];
 		then
@@ -1016,6 +1032,17 @@ _require_test()
 	nfs*)
                  _notrun "requires a test device"
 		 ;;
+	cifs)
+		echo $TEST_DEV | grep -q "//" > /dev/null 2>&1
+		if [ -z "$TEST_DEV" -o "$?" != "0" ];
+		then
+			_notrun "this test requires a valid \$TEST_DEV"
+		fi
+		if [ ! -d "$TEST_DIR" ];
+		then
+		     _notrun "this test requires a valid \$TEST_DIR"
+		fi
+		;;
 	tmpfs)
 		if [ -z "$TEST_DEV" -o ! -d "$TEST_DIR" ];
 		then
@@ -1806,6 +1833,9 @@ _check_test_fs()
     nfs)
 	# no way to check consistency for nfs
 	;;
+    cifs)
+	# no way to check consistency for cifs
+	;;
     udf)
 	# do nothing for now
 	;;
@@ -1844,6 +1874,9 @@ _check_scratch_fs()
     nfs*)
 	# Don't know how to check an NFS filesystem, yet.
 	;;
+    cifs)
+	# Don't know how to check a CIFS filesystem, yet.
+	;;
     btrfs)
 	_check_btrfs_filesystem $device
 	;;
diff --git a/tests/generic/013 b/tests/generic/013
index 93d9904..ae57c67 100755
--- a/tests/generic/013
+++ b/tests/generic/013
@@ -35,7 +35,12 @@ _cleanup()
 {
     cd /
     # we might get here with a RO FS
-    mount -o remount,rw $TEST_DEV >/dev/null 2>&1
+    REMOUNT_OPTIONS="remount,rw"
+    if [ "$FSTYP" = "cifs" ];
+    then
+        REMOUNT_OPTIONS="$REMOUNT_OPTIONS,$MOUNT_OPTIONS"
+    fi
+    mount -o $REMOUNT_OPTIONS $TEST_DEV >/dev/null 2>&1
     # now remove fsstress directory.
     # N.B. rm(1) on IRIX can find problems when building up a long pathname
     # such that what it has is greater the 1024 chars and will
-- 
1.9.1
