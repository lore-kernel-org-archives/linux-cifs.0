Received: from mta1.migadu.com (out-22.mta1.migadu.com [95.215.58.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB6E47D47D
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 13:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786627338; cv=none; b=PAbHVpHeAT5H2pPsRgtteIHtMfnFtJvxHP+lwFYMjXtt/pUhNELgIcs460OVuBrWfhpZEdtwZhgQ3Lq5Q+g8rcfMh174d33L2NMvoNq9pIHMKypW3Bf17A6QIp3L7+8Bf2uipHFsqGlE9CUTbP/PlL3XsgjdiMWfI1mlmiqNoo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786627338; c=relaxed/simple;
	bh=J4NWDUin+MDtsveQ5yWXGIPXWWQKy2Q1hRzK2WDSQyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ou8vmknY97WHqhVwke3of+vxm00GjhvIxtPcYryKnTf2l86x4q8LxlIIfLbKlnkZRlqNTPt01c60zfVAT/Uuh9MCWXaDGTV+Ctk10HAW/Ay7BcPcBiuthY0nLjuhTWQSoBcmT01RfZrFML+26a00dFgO8fkfc04TtNN7aGRgn+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PcRKO+bN; arc=none smtp.client-ip=95.215.58.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PcRKO+bN"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=J4NWDUin+MDtsveQ5yWXGIPXWWQKy2Q1hRzK2WDSQyQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786627333; v=1; x=1787232133;
 b=PcRKO+bNYFj7TyL1pWxGJlkouKUBT8+swl+bGc/932glAcIDch6eGlBGjtTOiF0STD1rcAzc
 7MmkSnoFH3QgnYFJhPZFRlWLzWXKEPQDJ3P8KlqkCsRqtIaZMaUcf/PYfVfI+kY2c38X3Z07I3o
 AxsYdizoY5Fdi4CgoqKOtrVk=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from localhost.localdomain (2408:8352:470:9d9:8475:703:1f32:b67e)
	by smtp.migadu.com with ESMTPS id 9f332baff04ecb9a;
	Thu, 13 Aug 2026 13:22:13 +0000
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
Subject: [PATCH 2/2] smb/client: mark file sparse before emulating insert range
Date: Thu, 13 Aug 2026 21:21:36 +0800
Message-ID: <20260813132136.366532-3-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813132136.366532-1-huiwen.he@linux.dev>
References: <20260813132136.366532-1-huiwen.he@linux.dev>
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

Try to mark the file sparse before starting the emulation. As with
existing file extension paths, ignore SET_SPARSE errors and continue
with the existing zero-filled behavior.

Tested with xfstests generic/064 against Samba and ksmbd.

Fixes: 7fe6fe95b936 ("cifs: add FALLOC_FL_INSERT_RANGE support")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index bc7dda6d825a..430b6a1a2d92 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4006,6 +4006,12 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 
 	count = old_eof - off;
 
+	/*
+	 * SET_ZERO_DATA creates a hole only in a sparse file. Try to mark the file
+	 * sparse, but continue the emulation regardless of the result.
+	 */
+	smb2_set_sparse(xid, tcon, cfile, inode, true);
+
 	filemap_invalidate_lock(inode->i_mapping);
 	rc = filemap_write_and_wait_range(inode->i_mapping, off, new_eof - 1);
 	if (rc < 0)
-- 
2.43.0

