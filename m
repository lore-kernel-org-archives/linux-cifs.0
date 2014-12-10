From: David Disseldorp <ddiss@suse.de>
Subject: [PATCH 1/2] common: rename _require_btrfs_cloner to _require_cloner
Date: Wed, 10 Dec 2014 01:14:44 +0100
Message-ID: <1418170485-3732-1-git-send-email-ddiss@suse.de>
Cc: linux-cifs@vger.kernel.org, David Disseldorp <ddiss@suse.de>
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

src/cloner.c is no longer Btrfs specific, so use a generic name.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 common/rc       | 2 +-
 tests/btrfs/035 | 2 +-
 tests/btrfs/052 | 2 +-
 tests/btrfs/055 | 2 +-
 tests/btrfs/056 | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/common/rc b/common/rc
index d5e3aff..ea80c77 100644
--- a/common/rc
+++ b/common/rc
@@ -2367,7 +2367,7 @@ _require_fssum()
 	[ -x $FSSUM_PROG ] || _notrun "fssum not built"
 }
 
-_require_btrfs_cloner()
+_require_cloner()
 {
 	CLONER_PROG=$here/src/cloner
 	[ -x $CLONER_PROG ] || \
diff --git a/tests/btrfs/035 b/tests/btrfs/035
index dd303af..35ddfce 100755
--- a/tests/btrfs/035
+++ b/tests/btrfs/035
@@ -45,7 +45,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
-_require_btrfs_cloner
+_require_cloner
 
 _scratch_mkfs > /dev/null 2>&1
 _scratch_mount
diff --git a/tests/btrfs/052 b/tests/btrfs/052
index 671034e..c75193d 100755
--- a/tests/btrfs/052
+++ b/tests/btrfs/052
@@ -44,7 +44,7 @@ _cleanup()
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
-_require_btrfs_cloner
+_require_cloner
 _need_to_be_root
 
 rm -f $seqres.full
diff --git a/tests/btrfs/055 b/tests/btrfs/055
index 10c6040..c0dd9ed 100755
--- a/tests/btrfs/055
+++ b/tests/btrfs/055
@@ -48,7 +48,7 @@ _cleanup()
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
-_require_btrfs_cloner
+_require_cloner
 _require_btrfs_fs_feature "no_holes"
 _require_btrfs_mkfs_feature "no-holes"
 _need_to_be_root
diff --git a/tests/btrfs/056 b/tests/btrfs/056
index 9ecfeb8..9e9d92b 100755
--- a/tests/btrfs/056
+++ b/tests/btrfs/056
@@ -52,7 +52,7 @@ _cleanup()
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
-_require_btrfs_cloner
+_require_cloner
 _require_btrfs_fs_feature "no_holes"
 _require_btrfs_mkfs_feature "no-holes"
 _require_dm_flakey
-- 
2.1.2

