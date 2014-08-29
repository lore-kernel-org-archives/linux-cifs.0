From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 2/3] common: add cifs support
Date: Fri, 29 Aug 2014 23:42:19 +0400
Message-ID: <1409341340-27031-3-git-send-email-pshilovsky@samba.org>
References: <1409341340-27031-1-git-send-email-pshilovsky@samba.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409341340-27031-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pass -cifs argument from the command line to enable cifs testing
for $TEST_DEV. Also mention CIFS and missed UDF in README.

Reviewed-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 README        |  5 +++--
 check         |  2 ++
 common/config | 31 +++++++++++++++++++++++++++----
 common/rc     | 26 ++++++++++++++++++++++++++
 4 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/README b/README
index b299c8f..8a362bd 100644
--- a/README
+++ b/README
@@ -91,14 +91,15 @@ Running tests:
     - By default the tests suite will run xfs tests:
     - ./check '*/001' '*/002' '*/003'
     - ./check '*/06?'
-    - You can explicitly specify NFS, otherwise the filesystem type will be
-      autodetected from $TEST_DEV:
+    - You can explicitly specify NFS/CIFS/UDF, otherwise the filesystem type will
+      be autodetected from $TEST_DEV:
       ./check -nfs [test(s)]
     - Groups of tests maybe ran by: ./check -g [group(s)]
       See the 'group' file for details on groups
     - for udf tests: ./check -udf [test(s)]
       Running all the udf tests: ./check -udf -g udf
     - for running nfs tests: ./check -nfs [test(s)]
+    - for running cifs/smb3 tests: ./check -cifs [test(s)]
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
index 10cc6fe..fc21b37 100644
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
 
@@ -238,6 +240,9 @@ _mount_opts()
 	nfs)
 		export MOUNT_OPTIONS=$NFS_MOUNT_OPTIONS
 		;;
+	cifs)
+		export MOUNT_OPTIONS=$CIFS_MOUNT_OPTIONS
+		;;
 	ext2|ext3|ext4|ext4dev)
 		# acls & xattrs aren't turned on by default on ext$FOO
 		export MOUNT_OPTIONS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
@@ -259,6 +264,17 @@ _mount_opts()
 	esac
 }
 
+_test_mount_opts()
+{
+	case $FSTYP in
+	cifs)
+		export TEST_FS_MOUNT_OPTS=$CIFS_MOUNT_OPTIONS
+		;;
+	*)
+		;;
+	esac
+}
+
 _mkfs_opts()
 {
 	case $FSTYP in
@@ -273,6 +289,9 @@ _mkfs_opts()
 	nfs)
 		export MKFS_OPTIONS=$NFS_MKFS_OPTIONS
 		;;
+	cifs)
+		export MKFS_OPTIONS=$CIFS_MKFS_OPTIONS
+		;;
 	reiserfs)
 		export MKFS_OPTIONS="$REISERFS_MKFS_OPTIONS -q"
 		;;
@@ -366,6 +385,7 @@ get_next_config() {
 
 	local OLD_FSTYP=$FSTYP
 	local OLD_MOUNT_OPTIONS=$MOUNT_OPTIONS
+	local OLD_TEST_FS_MOUNT_OPTS=$TEST_FS_MOUNT_OPTS
 	local OLD_MKFS_OPTIONS=$MKFS_OPTIONS
 	local OLD_FSCK_OPTIONS=$FSCK_OPTIONS
 
@@ -382,10 +402,12 @@ get_next_config() {
 
 	if [ ! -z "$OLD_FSTYP" ] && [ $OLD_FSTYP != $FSTYP ]; then
 		[ -z "$MOUNT_OPTIONS" ] && _mount_opts
+		[ -z "$TEST_FS_MOUNT_OPTS" ] && _test_mount_opts
 		[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
 		[ -z "$FSCK_OPTIONS" ] && _fsck_opts
 	else
 		[ -z "$MOUNT_OPTIONS" ] && export MOUNT_OPTIONS=$OLD_MOUNT_OPTIONS
+		[ -z "$TEST_FS_MOUNT_OPTS" ] && export TEST_FS_MOUNT_OPTS=$OLD_TEST_FS_MOUNT_OPTS
 		[ -z "$MKFS_OPTIONS" ] && export MKFS_OPTIONS=$OLD_MKFS_OPTIONS
 		[ -z "$FSCK_OPTIONS" ] && export FSCK_OPTIONS=$OLD_FSCK_OPTIONS
 	fi
@@ -408,9 +430,9 @@ get_next_config() {
 		exit 1
 	fi
 
-	echo $TEST_DEV | grep -q ":" > /dev/null 2>&1
+	echo $TEST_DEV | grep -qE ":|//" > /dev/null 2>&1
 	if [ ! -b "$TEST_DEV" -a "$?" != "0" ]; then
-		echo "common/config: Error: \$TEST_DEV ($TEST_DEV) is not a block device or a NFS filesystem"
+		echo "common/config: Error: \$TEST_DEV ($TEST_DEV) is not a block device or a network filesystem"
 		exit 1
 	fi
 
@@ -431,9 +453,9 @@ get_next_config() {
 		export SCRATCH_DEV_NOT_SET=true
 	fi
 
-	echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
+	echo $SCRATCH_DEV | grep -qE ":|//" > /dev/null 2>&1
 	if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]; then
-		echo "common/config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) is not a block device or a NFS filesystem"
+		echo "common/config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) is not a block device or a network filesystem"
 		exit 1
 	fi
 
@@ -457,6 +479,7 @@ if [ -z "$CONFIG_INCLUDED" ]; then
 	FSTYP=${FSTYP:=xfs}
 	export FSTYP
 	[ -z "$MOUNT_OPTIONS" ] && _mount_opts
+	[ -z "$TEST_FS_MOUNT_OPTS" ] && _test_mount_opts
 	[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
 	[ -z "$FSCK_OPTIONS" ] && _fsck_opts
 fi
diff --git a/common/rc b/common/rc
index d9c9995..8b427fc 100644
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
@@ -503,6 +505,9 @@ _test_mkfs()
     nfs*)
 	# do nothing for nfs
 	;;
+    cifs)
+	# do nothing for cifs
+	;;
     udf)
         $MKFS_UDF_PROG $MKFS_OPTIONS $* $TEST_DEV > /dev/null
 	;;
@@ -524,6 +529,9 @@ _scratch_mkfs()
     nfs*)
 	# do nothing for nfs
 	;;
+    cifs)
+	# do nothing for cifs
+	;;
     udf)
         $MKFS_UDF_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
 	;;
@@ -973,6 +981,9 @@ _require_scratch()
 	nfs*)
                  _notrun "requires a scratch device"
 		 ;;
+	cifs)
+		_notrun "requires a scratch device"
+		;;
 	tmpfs)
 		if [ -z "$SCRATCH_DEV" -o ! -d "$SCRATCH_MNT" ];
 		then
@@ -1022,6 +1033,15 @@ _require_test()
 	nfs*)
                  _notrun "requires a test device"
 		 ;;
+	cifs)
+		echo $TEST_DEV | grep -q "//" > /dev/null 2>&1
+		if [ -z "$TEST_DEV" -o "$?" != "0" ]; then
+			_notrun "this test requires a valid \$TEST_DEV"
+		fi
+		if [ ! -d "$TEST_DIR" ]; then
+		     _notrun "this test requires a valid \$TEST_DIR"
+		fi
+		;;
 	tmpfs)
 		if [ -z "$TEST_DEV" -o ! -d "$TEST_DIR" ];
 		then
@@ -1812,6 +1832,9 @@ _check_test_fs()
     nfs)
 	# no way to check consistency for nfs
 	;;
+    cifs)
+	# no way to check consistency for cifs
+	;;
     udf)
 	# do nothing for now
 	;;
@@ -1850,6 +1873,9 @@ _check_scratch_fs()
     nfs*)
 	# Don't know how to check an NFS filesystem, yet.
 	;;
+    cifs)
+	# Don't know how to check a CIFS filesystem, yet.
+	;;
     btrfs)
 	_check_btrfs_filesystem $device
 	;;
-- 
1.9.1
