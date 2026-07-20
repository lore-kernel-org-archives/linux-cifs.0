Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891D9407CC5
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 16:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784565385; cv=none; b=Dj1RCpnznNKkzH2rAyHTBDUJMVS1e/uAWUJrbnkP7MceMxk7xsmT7tWMLjQxRySTJhcM2WNxYOhYJzM7iKHuetZlLATB0GWtpVhTrAXNxPYvdiVGvoUcD2N4iHKLRLFE3lGWaytTBjlU2GK03i5RZO/X985/VfdHpG46n18dPKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784565385; c=relaxed/simple;
	bh=8L4GmUs9b5mB0Ko0900E38twdOYPWnxWBr4hCBGuy3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgtOHYXb4WxVGYt5QyEQvBuY7HL0kbF1rxvAvfd/Ex/RRUMUxKv7q22D+IrlXlG+Guyy7w9EC26/CyZw9/qehE3rW89W2raSuYziuI2Bnhb75s05+CQ4X5S2abnRpF07DfcHwXkkJVM9576OXhPnLZvIzuDyVJ/B1GrrZFYbRqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Z43qHAmC; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Z43qHAmC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784565379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BFD3DRsLOyPAHyvLun2YgU5mtFFWrTwLfhCRofhghv4=;
	b=Z43qHAmCejS8b6V/sifDJCzBBRqmu0CjOldgUV1w/dD5Im0E6ehlKrJjSLMU/uSOGONSD/
	jdB589ijvLPFX65by02Q6AjCha95wlZS0Q73PlLyKzQ1muo1ePdfszwf8cPqui7gn5uieg
	nYtl2KJ2+SG8WqpfW+H2ff0BV22Cw9I9ayR6en77cD1jOugJG/T4I8GQS4ofpDuFDgKnBX
	j2vVLj+5Qd72yn9QSJnKYgUBNWfSbUd53UBmdoAuQ6Uu0gkzHQao+S5eZa4eocf76+DKXB
	t08qEyJmLxnSEhwqRZ3uyKnULQkglrv/SFdYCGYNPgEmrWUWRLsFuS/9rVebUg==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	zlang@kernel.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 xfstests 2/3] generic/002: clean up the test
Date: Mon, 20 Jul 2026 16:35:01 +0000
Message-ID: <20260720163502.732454-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260720163502.732454-1-chenxiaosong@chenxiaosong.com>
References: <20260720163502.732454-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Add the hardlink group and use shorter loops. Use _exit() and change
the success text to "Silence is golden".

Suggested-by: Zorro Lang <zlang@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 tests/generic/002     | 16 ++++++----------
 tests/generic/002.out |  2 +-
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/tests/generic/002 b/tests/generic/002
index 6df57a7a..9b210705 100755
--- a/tests/generic/002
+++ b/tests/generic/002
@@ -2,12 +2,12 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
 #
-# FS QA Test No. 002
+# FS QA Test 002
 #
 # simple inode link count test for a regular file
 #
 . ./common/preamble
-_begin_fstest metadata udf auto quick
+_begin_fstest metadata udf auto quick hardlink
 
 # Import common functions.
 . ./common/filter
@@ -17,14 +17,11 @@ status=0	# success is the default!
 _require_test
 _require_hardlinks
 
-echo "Silence is goodness ..."
-
 # ensure target directory exists
 mkdir `dirname $TEST_DIR/tmp` 2>/dev/null
 
 touch $TEST_DIR/tmp.1
-for l in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
-do
+for ((l = 2; l <= 20; l++)); do
     ln $TEST_DIR/tmp.1 $TEST_DIR/tmp.$l
     x=`$here/src/lstat64 $TEST_DIR/tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
     if [ "$l" -ne $x ]
@@ -35,8 +32,7 @@ do
     fi
 done
 
-for l in 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1
-do
+for ((l = 20; l >= 1; l--)); do
     x=`$here/src/lstat64 $TEST_DIR/tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
     if [ "$l" -ne $x ]
     then
@@ -47,5 +43,5 @@ do
     rm -f $TEST_DIR/tmp.$l
 done
 
-# success, all done
-exit
+echo "Silence is golden"
+exit $status
diff --git a/tests/generic/002.out b/tests/generic/002.out
index 11426b54..61705c7c 100644
--- a/tests/generic/002.out
+++ b/tests/generic/002.out
@@ -1,2 +1,2 @@
 QA output created by 002
-Silence is goodness ...
+Silence is golden
-- 
2.43.0

