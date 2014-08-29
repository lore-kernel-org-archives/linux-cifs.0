From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 1/3] generic/013: encapsulate remount during cleanup
Date: Fri, 29 Aug 2014 23:42:18 +0400
Message-ID: <1409341340-27031-2-git-send-email-pshilovsky@samba.org>
References: <1409341340-27031-1-git-send-email-pshilovsky@samba.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409341340-27031-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The existing code calls remount for $TEST_DEV with constantly defined
mount options. This can fail if a user specifies different mount options.
Fix this by using new _test_remount() call that remounts $TEST_DEV.

Reviewed-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 common/rc         | 6 ++++++
 tests/generic/013 | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index 16da898..d9c9995 100644
--- a/common/rc
+++ b/common/rc
@@ -218,6 +218,12 @@ _test_mount()
     _mount -t $FSTYP $TEST_OPTIONS $TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS $* $TEST_DEV $TEST_DIR
 }
 
+_test_remount()
+{
+    $UMOUNT_PROG $TEST_DEV
+    _test_mount
+}
+
 _scratch_mkfs_options()
 {
     _scratch_options mkfs
diff --git a/tests/generic/013 b/tests/generic/013
index 93d9904..534c9f0 100755
--- a/tests/generic/013
+++ b/tests/generic/013
@@ -35,7 +35,7 @@ _cleanup()
 {
     cd /
     # we might get here with a RO FS
-    mount -o remount,rw $TEST_DEV >/dev/null 2>&1
+    _test_remount
     # now remove fsstress directory.
     # N.B. rm(1) on IRIX can find problems when building up a long pathname
     # such that what it has is greater the 1024 chars and will
-- 
1.9.1
