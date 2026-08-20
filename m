Received: from mta0.migadu.com (out-102.mta0.migadu.com [91.218.175.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5463A2857CC
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 07:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787210173; cv=none; b=ShvVEpYeoXOoIHsEKlSGffv3dVlaJG08B0mWzq5vGaZbp4WytzDt0CPuBMfAsrUY9ELesu8eaHm3lXym2rnf852aNX0if05VfMe200JeJ/LlMuwjxPttqLq7QLFOSkbotqD1kalTMjVxp2G402zz9I4yPHk6oe7Sr84mN5kvTM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787210173; c=relaxed/simple;
	bh=W/EbRCfv7jD8jeoY5r13tu60l1QsAOl/kuZTqqbpwkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvDkqdT4NHk9COnvvUDqaQg9xQv7QFlPH5RiWhijtylGZghukbxarnzQa7xzOYMnijU7mOKIllq8BB/6dzUPTtjWrQvW+WMpTCbgKFHo3BNY2aC9yffXh7ReugXflqt/feC3mdwgk9gLa5Hmc6gcPvkjRSBqUbCeMfEwUWtdVfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lSwXnybB; arc=none smtp.client-ip=91.218.175.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lSwXnybB"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=W/EbRCfv7jD8jeoY5r13tu60l1QsAOl/kuZTqqbpwkw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787210170; v=1; x=1787814970;
 b=lSwXnybBnWF3rNBUN+5Koam0W09xp0g0G1y73wf4if+cu85XuCkiR6L62X08d11NXDBXqsI3
 degvcLJ6VxB1EdhJSiDmahPE059BcL7pFTgEUxxocW4lsn44JQal/WzECUjP4BO1C9qKeYAEK0g
 0i00tNOuBBLODgR3HYDRV1Fo=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from harry-WUJIE-Series.. (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 12d1b3b2427453cf;
	Thu, 20 Aug 2026 07:16:10 +0000
X-Mizu-Trace-ID: 12d1b3b2427453cf
X-Migadu-Flow: FLOW_OUT
From: Huiwen He <huiwen.he@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v2 3/6] smb/client: mark file sparse before emulating insert range
Date: Thu, 20 Aug 2026 15:15:23 +0800
Message-ID: <20260820071526.826926-4-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260820071526.826926-1-huiwen.he@linux.dev>
References: <20260820071526.826926-1-huiwen.he@linux.dev>
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

Tested with xfstests generic/064 against Samba and ksmbd.

Fixes: 7fe6fe95b936 ("cifs: add FALLOC_FL_INSERT_RANGE support")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
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

