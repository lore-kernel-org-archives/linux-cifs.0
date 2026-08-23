Received: from mta1.migadu.com (out-135.mta1.migadu.com [95.215.58.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECB4278161
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 15:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787497907; cv=none; b=hPFUaDIwJWHIE1qyxsz2KfYEuN2NCr48Pn2NjxktQ7Fiyq9oH/z9394hZch8dTUxm8B5ybOUOTeDAWnVQbsE+oWGA8SXjh1B6Q3GR7/OBKagfArTuq+Sotei0qreaxSTCeDgAo6Clv3bHlORZsEHIHm9CvLjZw7rTWs3ZiAjqCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787497907; c=relaxed/simple;
	bh=W/EbRCfv7jD8jeoY5r13tu60l1QsAOl/kuZTqqbpwkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Otv93JSa3E014TcvPj2UGT/XdIdW/mzTfwr6TAA+EgwsZHMWWbUYBiispzwZE4jad/EEarMdY1q99R7yhqMJxbPmTfME9+y+Ci+dBx5D2LaM+1YkUr5XxwtTswZ0cofIW0cKY+vXRViCej1Y23+8SDYKzmQ6cL+nGzsFpEKGJ9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UghsrqZU; arc=none smtp.client-ip=95.215.58.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UghsrqZU"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=W/EbRCfv7jD8jeoY5r13tu60l1QsAOl/kuZTqqbpwkw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787497903; v=1; x=1788102703;
 b=UghsrqZUoV9aJTnkF9Ib3xL3hotKfRiRPHRKvpjN+5OJDZK68D6w/NvRfFBXwYTjD6BiAPwB
 isTG3q0fzWi5ShsSBcZh7mJyDRGg3tyNa0gaOyG4drAxlDJmM3oEm7kdbDlkFIg4HWcyS7ovEDr
 wYcWFn/wFTa5adDsUqXmYg10=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from localhost.localdomain (2408:8352:470:269e:918b:d2e0:eaa5:de79)
	by smtp.migadu.com with ESMTPS id b4dd3bf803d0d3f3;
	Sun, 23 Aug 2026 15:11:43 +0000
X-Mizu-Trace-ID: b4dd3bf803d0d3f3
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
Subject: [PATCH v3 3/7] smb/client: mark file sparse before emulating insert range
Date: Sun, 23 Aug 2026 23:10:49 +0800
Message-ID: <20260823151053.935889-4-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260823151053.935889-1-huiwen.he@linux.dev>
References: <20260823151053.935889-1-huiwen.he@linux.dev>
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

