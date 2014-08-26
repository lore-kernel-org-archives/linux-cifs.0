From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 3/3] cifs: skip tests that need POSIX support for nounix mounts
Date: Wed, 27 Aug 2014 00:28:38 +0400
Message-ID: <1409084918-17764-4-git-send-email-pshilovsky@samba.org>
References: <1409084918-17764-1-git-send-email-pshilovsky@samba.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409084918-17764-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

CIFS/SMB protocol without POSIX extensions doesn't support operations
with symbolic links and advisory byte-range locks from the same process.
Add a check for nounix mounts and use it in generic tests that
require such operations.

Reviewed-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 common/rc         | 7 +++++++
 tests/generic/005 | 1 +
 tests/generic/023 | 1 +
 tests/generic/024 | 1 +
 tests/generic/025 | 1 +
 tests/generic/131 | 1 +
 6 files changed, 12 insertions(+)

diff --git a/common/rc b/common/rc
index 8b427fc..191f7ff 100644
--- a/common/rc
+++ b/common/rc
@@ -2374,6 +2374,13 @@ _require_btrfs_fs_feature()
 		_notrun "Feature $feat not supported by the available btrfs version"
 }
 
+_require_test_posix_ext()
+{
+	[ "$FSTYP" != "cifs" ] && return 0
+	cat /proc/mounts | grep $TEST_DEV | grep cifs | grep -q nounix && \
+		_notrun "Require POSIX extensions enabled"
+}
+
 _get_total_inode()
 {
 	if [ -z "$1" ]; then
diff --git a/tests/generic/005 b/tests/generic/005
index d78e43f..0c2b51f 100755
--- a/tests/generic/005
+++ b/tests/generic/005
@@ -67,6 +67,7 @@ _touch()
 # real QA test starts here
 _supported_fs generic
 _require_test
+_require_test_posix_ext
 
 # IRIX UDF does not support symlinks
 if [ $FSTYP == 'udf' ]; then
diff --git a/tests/generic/023 b/tests/generic/023
index 114485c..91b8a37 100755
--- a/tests/generic/023
+++ b/tests/generic/023
@@ -45,6 +45,7 @@ _supported_os Linux
 
 _require_test
 _requires_renameat2
+_require_test_posix_ext
 
 # real QA test starts here
 
diff --git a/tests/generic/024 b/tests/generic/024
index 8945191..1248e78 100755
--- a/tests/generic/024
+++ b/tests/generic/024
@@ -45,6 +45,7 @@ _supported_os Linux
 
 _require_test
 _requires_renameat2
+_require_test_posix_ext
 
 rename_dir=$TEST_DIR/$$
 mkdir $rename_dir
diff --git a/tests/generic/025 b/tests/generic/025
index 6b6c8ab..d06136c 100755
--- a/tests/generic/025
+++ b/tests/generic/025
@@ -45,6 +45,7 @@ _supported_os Linux
 
 _require_test
 _requires_renameat2
+_require_test_posix_ext
 
 rename_dir=$TEST_DIR/$$
 mkdir $rename_dir
diff --git a/tests/generic/131 b/tests/generic/131
index b4e3ff0..9736963 100755
--- a/tests/generic/131
+++ b/tests/generic/131
@@ -45,6 +45,7 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 _require_test
+_require_test_posix_ext
 
 TESTFILE=$TEST_DIR/lock_file
 
-- 
1.9.1
