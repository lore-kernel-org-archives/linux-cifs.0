Received: from mta1.migadu.com (out-239.mta1.migadu.com [95.215.58.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0347D1DA60D
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 15:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787065266; cv=none; b=cUiMdcp/4OAgehL+jtnzHAndu/N9YewIbz8pHYqoh4Oyg+vhtirIlzc2fYkzJAvRNutHx3be5MS98RKLZQUilFg68t4a6r3A6hmMJgBRuvPQpxnyeO0KmDwxl/gdfLaRgrK+tNFtfrVDvffOemAJr3ML4m0YQD/x+pg6BaMcaTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787065266; c=relaxed/simple;
	bh=SsjcQQy4eSRUkdyBohNzTeXFFMG6LcsXxfeNePRP8kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sstOE//Yc0wlcdsU6RTtwKUL6OH0RmTgUi466MHvUhWl6B4D8GiPEV8C9b6CRdSCGX5uI6MS8QmC8rC/nqMyKX2URzAASLR7Pi5QmzV6U9wDbdld3mYcZ4n0NcY09rg7fSrNX+kmi0kjS0PApKDvg6b/e4xefxSEuanPGdJVLog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=FP+D6tkT; arc=none smtp.client-ip=95.215.58.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="FP+D6tkT"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=SsjcQQy4eSRUkdyBohNzTeXFFMG6LcsXxfeNePRP8kQ=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787065258; v=1; x=1787670058;
 b=FP+D6tkTyVLik7BduzTToYgX8x7pJtcZsfAd2JRE9N12+9vVtwwmF6Opnhl5DHe3m4VeY3/d
 hRMf1OmAuLHI/2/R3/tRAp0wkCuY9XS/RhDsNL9fDiZI1n7Gcv/eXLBc1p/C5Jw0a/q3RTUTyp0
 jEhpRY/5Wz2vxKd6SE0UXyCWP1J+i2/jUR1FSrj9H0EkfStVWXRnDmDmYdBiHs2hTKmiscHvyGq
 rp5HZkkNjA99Cm0su4r5F7uDHN838T1VHbclnwhCOVUyVRVeU7p48vuAh+wqMjwLX7dWlf/K0VB
 G6j3Q2+sLWVNxGy4sjBITaYZHr28ab6eK8jIuXlW2A/2A==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from workspace-fedora (116.128.244.171)
	by smtp.migadu.com with ESMTPS id b993c49be614ead3;
	Tue, 18 Aug 2026 15:00:48 +0000
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	zlang@kernel.org
Cc: linux-cifs@vger.kernel.org,
	fstests@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [RFC PATCH xfstests] cifs: new test to check directory rename with an nonposix open child
Date: Tue, 18 Aug 2026 15:00:21 +0000
Message-ID: <20260818150021.512616-1-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Add a test to verify that renaming a directory fails with EACCES
while a file in it is held open without a POSIX create context.

Link: https://lore.kernel.org/linux-cifs/20260802170757.220862-3-chenxiaosong@chenxiaosong.com/
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 tests/cifs/002     | 76 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/cifs/002.out |  2 ++
 2 files changed, 78 insertions(+)
 create mode 100755 tests/cifs/002
 create mode 100644 tests/cifs/002.out

diff --git a/tests/cifs/002 b/tests/cifs/002
new file mode 100755
index 00000000..aa011fdf
--- /dev/null
+++ b/tests/cifs/002
@@ -0,0 +1,76 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2026 KylinSoft Co., Ltd. All rights reserved.
+# Author(s): ChenXiaoSong <chenxiaosong@kylinos.cn>
+#
+# FS QA Test No. 002
+#
+# Regression test for a ksmbd bug where a directory could be renamed while a
+# file in it was held open without a POSIX create context.
+#
+. ./common/preamble
+_begin_fstest auto quick rename
+
+_require_scratch
+_require_test_program "rename"
+
+# TODO: This patch has not been merged into mainline yet.
+# https://lore.kernel.org/linux-cifs/20260802170757.220862-3-chenxiaosong@chenxiaosong.com/
+# _fixed_by_kernel_commit xxxxxxxx \
+# 	"smb/server: fix posix state check for directory rename"
+
+testdir=$SCRATCH_MNT/test-$seq
+srcdir=$testdir/dir1
+dstdir=$testdir/dir2
+
+_cleanup()
+{
+	exec 73<&-
+	rm -rf "$testdir"
+	rm -f $tmp.*
+}
+
+# SMB3.1.1 is needed to negotiate POSIX extensions with the server.  Disable
+# POSIX create contexts explicitly so that the opens below use normal SMB
+# handles, regardless of the mount options in the test configuration.
+_try_scratch_mount -o vers=3.1.1,noposix >> $seqres.full 2>&1 || \
+	_notrun "mounting the scratch share with vers=3.1.1,noposix failed"
+
+# Make sure a conflicting option from the test configuration did not win.  The
+# CIFS client reports the noposix alias as nounix in /proc/mounts.
+_fs_options "$SCRATCH_DEV" | grep -Eq '(^|,)nounix(,|$)' || \
+	_notrun "the scratch share was not mounted with POSIX extensions disabled"
+
+rm -rf "$testdir"
+mkdir -p "$testdir/control" "$srcdir" || \
+	_fail "failed to create test directories"
+
+# Verify that ordinary directory renames are permitted on this share, so an
+# EACCES result below cannot be caused by a read-only share or its permissions.
+$here/src/rename "$testdir/control" "$testdir/control-renamed" \
+	>> $seqres.full 2>&1 || _fail "ordinary directory rename failed"
+
+touch "$srcdir/file" || _fail "failed to create child file"
+
+# Keep a normal SMB handle open for a child of the directory.  Renaming the
+# directory must be rejected with EACCES until that handle is closed.
+exec 73< "$srcdir/file" || _fail "failed to open child file"
+
+$here/src/rename "$srcdir" "$dstdir" > $tmp.rename 2>&1
+ret=$?
+cat $tmp.rename >> $seqres.full
+if [ $ret -eq 0 ]; then
+	_fail "directory rename with an open child unexpectedly succeeded"
+fi
+
+if ! grep -qx 'rename: Permission denied' $tmp.rename; then
+	cat $tmp.rename >> $seqres.full
+	_fail "directory rename failed with an unexpected error"
+fi
+
+exec 73<&-
+
+echo "Silence is golden"
+
+status=0
+exit
diff --git a/tests/cifs/002.out b/tests/cifs/002.out
new file mode 100644
index 00000000..61705c7c
--- /dev/null
+++ b/tests/cifs/002.out
@@ -0,0 +1,2 @@
+QA output created by 002
+Silence is golden
-- 
2.53.0

