Received: from mta1.migadu.com (out-252.mta1.migadu.com [95.215.58.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFCC54781
	for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 07:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787901666; cv=none; b=R2MeofqMNhdI7Zdkv4ctS7wLJvGHurAqNxZAjG8PJdIvQ5TofTNs76tI0OhUpw+EoY04oCs22+o26eRgNrlADlwkggNikegffbsXzaBwEN9uiMnrKC2RgOmYn+UueBmIH/GGwUt/0StDiEi909hgUZ+92WvpkEoqUISovpwvMxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787901666; c=relaxed/simple;
	bh=OHWF10xI0Gks0mAimZaCbMgUX3l2h6PgsP2QTg4tZsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5qmazslj4PdjCBz819b7xKDlf4eBDWj2AYZmLY1lWx/kXW9+Z2dKA01zkb0HFqx8i2Hhx4FFPjDXNJgfPQ9Fii5/cfWMVSCF3SYoM18Tl6PMk+ua/V0mAT9FgRIiOGrpmzPVc7rAh7P+8Ii/mb8GUV1POu609y5M9Xj7uItyoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DLQQldv5; arc=none smtp.client-ip=95.215.58.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DLQQldv5"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OHWF10xI0Gks0mAimZaCbMgUX3l2h6PgsP2QTg4tZsI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787901663; v=1; x=1788506463;
 b=DLQQldv5NrBDnzYOlN0XfH1P4DuOBDuoeOXy0wnjYcA1Up/6Wmw4Vr9BPV+e0Z4XXULbBwnp
 MqTuoOtto6LFlaP5YB+IbkRFTxVxsU/wPX6qoas10O4rh3szyWYnGuzT7r42fyODdVrAwRMk6ar
 xiaBRBdaD5wQGePOTZYaB7p4=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 28bfd6b8ec3a8382;
	Fri, 28 Aug 2026 07:21:03 +0000
X-Mizu-Trace-ID: 28bfd6b8ec3a8382
X-Migadu-Flow: FLOW_OUT
From: Huiwen He <huiwen.he@linux.dev>
To: linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v4 3/7] smb/client: mark file sparse before emulating insert range
Date: Fri, 28 Aug 2026 15:19:31 +0800
Message-ID: <20260828071935.552165-4-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260828071935.552165-1-huiwen.he@linux.dev>
References: <20260828071935.552165-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Huiwen He <hehuiwen@kylinos.cn>

The SMB client emulates FALLOC_FL_INSERT_RANGE with SET_EOF, COPYCHUNK
and SET_ZERO_DATA.

SET_ZERO_DATA creates a hole only when the file is sparse. On a
non-sparse file, it clears the inserted range but leaves its blocks
allocated, causing the extent count check in xfstests generic/064 to
fail.

Fix this by marking the file sparse before modifying it.

This patch produces the expected sparse extents in xfstests generic/064
only when the server-reported block size is compatible with the server's
deallocation granularity.

For ksmbd, the reported block size follows the backing filesystem,
and the test passes. For Samba, the test passes with a block size
matching the backend granularity, for example, 4 KiB on Btrfs, but not
with the default 1 KiB value. For Windows Server 2022, 4 KiB inserts do
not generate holes, while aligned inserts of 64 KiB or larger do.

Fixes: 7fe6fe95b936 ("cifs: add FALLOC_FL_INSERT_RANGE support")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/smb2ops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index f823f9bc90eb..1eff607a1e74 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4013,6 +4013,11 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 
 	count = old_eof - off;
 
+	/* SET_ZERO_DATA creates a hole only in a sparse file. */
+	rc = smb2_set_sparse(xid, tcon, cfile, inode, true);
+	if (rc)
+		goto out;
+
 	filemap_invalidate_lock(inode->i_mapping);
 	rc = filemap_write_and_wait_range(inode->i_mapping, off, new_eof - 1);
 	if (rc < 0)
-- 
2.43.0

