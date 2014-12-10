From: David Disseldorp <ddiss@suse.de>
Subject: [PATCH 2/2] cifs: add server-side copy sanity test
Date: Wed, 10 Dec 2014 01:14:45 +0100
Message-ID: <1418170485-3732-2-git-send-email-ddiss@suse.de>
References: <1418170485-3732-1-git-send-email-ddiss@suse.de>
Cc: linux-cifs@vger.kernel.org, David Disseldorp <ddiss@suse.de>
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1418170485-3732-1-git-send-email-ddiss@suse.de>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

This test uses the cloner binary to issue CIFS_IOC_COPYCHUNK_FILE
server-side copy requests.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 tests/cifs/001     | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/cifs/001.out | 21 +++++++++++++++++
 tests/cifs/group   |  6 +++++
 3 files changed, 96 insertions(+)
 create mode 100755 tests/cifs/001
 create mode 100644 tests/cifs/001.out
 create mode 100644 tests/cifs/group

diff --git a/tests/cifs/001 b/tests/cifs/001
new file mode 100755
index 0000000..57ce728
--- /dev/null
+++ b/tests/cifs/001
@@ -0,0 +1,69 @@
+#!/bin/bash
+# FS QA Test No. cifs/001
+#
+# Sanity test for server-side copies initiated via CIFS_IOC_COPYCHUNK_FILE
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2014 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+	rm -f $tmp.*
+	rm -rf $TEST_DIR/$$
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs cifs
+_supported_os Linux
+_require_cloner
+_require_test
+
+mkdir -p $TEST_DIR/$$/src || _fail "failed to create clone src dir"
+mkdir -p $TEST_DIR/$$/dest || _fail "failed to create clone dest dir"
+
+# populate 10 files, 1K-10K in size
+for i in `seq 1 10`; do
+	len=$(($i * 1024))
+	$XFS_IO_PROG -f -c "pwrite -S $i 0 $len" $TEST_DIR/$$/src/${i} \
+		| _filter_xfs_io
+done
+sync
+
+# clone each, then compare both versions
+for i in `seq 1 10`; do
+	$CLONER_PROG $TEST_DIR/$$/src/${i} $TEST_DIR/$$/dest/${i}
+	diff $TEST_DIR/$$/src/${i} $TEST_DIR/$$/dest/${i}
+done
+
+status=0
+exit
diff --git a/tests/cifs/001.out b/tests/cifs/001.out
new file mode 100644
index 0000000..54e2bbe
--- /dev/null
+++ b/tests/cifs/001.out
@@ -0,0 +1,21 @@
+QA output created by 001
+wrote 1024/1024 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 3072/3072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 5120/5120 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6144/6144 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 7168/7168 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 9216/9216 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 10240/10240 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/cifs/group b/tests/cifs/group
new file mode 100644
index 0000000..6d07b1c
--- /dev/null
+++ b/tests/cifs/group
@@ -0,0 +1,6 @@
+# QA groups control file
+# Defines test groups and nominal group owners
+# - do not start group names with a digit
+# - comment line before each group is "new" description
+#
+001 auto quick
-- 
2.1.2

