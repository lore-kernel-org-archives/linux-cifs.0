From: Pavel Shilovsky <pshilovsky@samba.org>
Subject: [PATCH v3 3/3] cifs: skip tests that need POSIX support for nounix mounts
Date: Fri, 29 Aug 2014 23:42:20 +0400
Message-ID: <1409341340-27031-4-git-send-email-pshilovsky@samba.org>
References: <1409341340-27031-1-git-send-email-pshilovsky@samba.org>
Cc: linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@samba.org, David Disseldorp <ddiss@suse.de>,
	Steve French <smfrench@gmail.com>
To: fstests@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1409341340-27031-1-git-send-email-pshilovsky@samba.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

CIFS/SMB protocol without POSIX extensions doesn't support operations
with symbolic links and advisory byte-range locks from the same process.
Add checks these features and use them in generic tests that require
such operations.

Reviewed-by: Steve French <smfrench@gmail.com>
Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
---
 common/rc         | 23 +++++++++++++++++++++++
 tests/generic/005 |  8 ++------
 tests/generic/023 |  1 +
 tests/generic/024 |  1 +
 tests/generic/025 |  1 +
 tests/generic/131 |  1 +
 6 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/common/rc b/common/rc
index 8b427fc..e1b3098 100644
--- a/common/rc
+++ b/common/rc
@@ -2374,6 +2374,29 @@ _require_btrfs_fs_feature()
 		_notrun "Feature $feat not supported by the available btrfs version"
 }
 
+_require_test_symlinks()
+{
+	# IRIX UDF does not support symlinks
+	[ "$HOSTOS" = "IRIX" -a "$FSTYP" = 'udf' ] && \
+		_notrun "Require symlinks support"
+	target=`mktemp -p $TEST_DIR`
+	link=`mktemp -p $TEST_DIR -u`
+	ln -s `basename $target` $link
+	if [ "$?" -ne 0 ]; then
+		rm -f $target
+		_notrun "Require symlinks support"
+	fi
+	rm -f $target $link
+}
+
+_require_test_fcntl_advisory_locks()
+{
+	[ "$FSTYP" != "cifs" ] && return 0
+	cat /proc/mounts | grep $TEST_DEV | grep cifs | grep -q "nobrl" && return 0
+	cat /proc/mounts | grep $TEST_DEV | grep cifs | grep -qE "nounix|forcemand" && \
+		_notrun "Require fcntl advisory locks support"
+}
+
 _get_total_inode()
 {
 	if [ -z "$1" ]; then
diff --git a/tests/generic/005 b/tests/generic/005
index d78e43f..70f6073 100755
--- a/tests/generic/005
+++ b/tests/generic/005
@@ -67,13 +67,9 @@ _touch()
 # real QA test starts here
 _supported_fs generic
 _require_test
+_require_test_symlinks
 
-# IRIX UDF does not support symlinks
-if [ $FSTYP == 'udf' ]; then
-    _supported_os Linux
-else
-    _supported_os Linux IRIX
-fi
+_supported_os Linux IRIX
 
 cd $TEST_DIR
 
diff --git a/tests/generic/023 b/tests/generic/023
index 114485c..1062b5b 100755
--- a/tests/generic/023
+++ b/tests/generic/023
@@ -45,6 +45,7 @@ _supported_os Linux
 
 _require_test
 _requires_renameat2
+_require_test_symlinks
 
 # real QA test starts here
 
diff --git a/tests/generic/024 b/tests/generic/024
index 8945191..bcc246e 100755
--- a/tests/generic/024
+++ b/tests/generic/024
@@ -45,6 +45,7 @@ _supported_os Linux
 
 _require_test
 _requires_renameat2
+_require_test_symlinks
 
 rename_dir=$TEST_DIR/$$
 mkdir $rename_dir
diff --git a/tests/generic/025 b/tests/generic/025
index 6b6c8ab..da295a3 100755
--- a/tests/generic/025
+++ b/tests/generic/025
@@ -45,6 +45,7 @@ _supported_os Linux
 
 _require_test
 _requires_renameat2
+_require_test_symlinks
 
 rename_dir=$TEST_DIR/$$
 mkdir $rename_dir
diff --git a/tests/generic/131 b/tests/generic/131
index b4e3ff0..3bcb0d1 100755
--- a/tests/generic/131
+++ b/tests/generic/131
@@ -45,6 +45,7 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 _require_test
+_require_test_fcntl_advisory_locks
 
 TESTFILE=$TEST_DIR/lock_file
 
-- 
1.9.1

