Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79EF34AB01
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 02:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782182945; cv=none; b=GOYbfpoP6nWObBso0cX2Bl9S5iASra+mfrbvdUTp/Wt/5DkfO17tqj5dDHXg/XiGx5pMp6FUXtkoDZU7hGEXJ1AaYzpAXu1ncIuf9rtSM9wLHIRPQcbmfdqthhi+Zws4/+WrnqJXIOtNdFy1kcobQGyQFQNx6PZVOAQbgAel/cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782182945; c=relaxed/simple;
	bh=9Dfcfex7pEJjtnpQNkxbS3geZwDI8SXHGA6QLlJmkVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hz2bNq2KweX8g4WwFaEoDwtvs3xjNOl94pQToG/Axfg6aNJRxq/nGfFuTc9nklebhB9rfymzAs8GKlq5jcKvugRm5YzpzlrWbd9uvq5JWTaewrXOPzOZwdUScDX/WuSmvoODRAAvU7jfy/3NFzR4RqfC9BNfleRmdF3b15N+wTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hPb/i1fh; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hPb/i1fh"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782182942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LkjhVnm+eG1xWgbeJMa1V/iclgZj5c3ikegvFwJ50s8=;
	b=hPb/i1fhpRkciZWs0VsJCcxXIt05BG1nLo9Rj4DHf2t3XkM6/WCcZ3p3y5oK7LUI1oZLGA
	vGL1imwisY0vBrGt1IoZ6v76ry3EJGFTujBMxS1VKSscYf5T62fZWt44U7mmgloWjCUlvc
	S2rmlI9g2+e0qLCYxryylBEPs5ohSHA=
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
	metze@samba.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH 7/7] smb/client: emulate small fallocate ranges at EOF
Date: Tue, 23 Jun 2026 10:46:19 +0800
Message-ID: <20260623024619.1360127-8-huiwen.he@linux.dev>
In-Reply-To: <20260623024619.1360127-1-huiwen.he@linux.dev>
References: <20260623024619.1360127-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

smb3_simple_falloc() now returns -EOPNOTSUPP for mode 0 requests that
start at EOF of a non-empty file because FILE_ALLOCATION_INFORMATION
cannot allocate an arbitrary byte range.

However, one small case can be handled safely: a range that starts exactly
at the current EOF. For example:

        xfs_io -f -c "pwrite 0 1m" file
        xfs_io -c "falloc 1m 4k" file

This does not create an intervening hole or overwrite existing data. Write
zeroes to the requested range so that it is allocated and EOF is extended
by the write. Limit this zero-write emulation to 1 MiB to keep the cost
bounded.

This allows small EOF-adjacent fallocate requests to succeed. After the
write, update the local file size and refresh i_blocks from the
server-reported AllocationSize. Larger ranges remain unsupported.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 4cab652d9696..2922373ab478 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3696,6 +3696,43 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		if (rc)
 			goto out;
 
+		/*
+		 * A small range immediately after EOF can be allocated by
+		 * writing zeroes without creating an intervening hole.
+		 */
+		if (off == old_eof && old_eof != 0) {
+			if (len > 1024 * 1024) {
+				rc = -EOPNOTSUPP;
+				goto out;
+			}
+
+			rc = smb3_simple_fallocate_range(xid, tcon, cfile,
+							 off, len);
+			if (rc) {
+				spin_lock(&inode->i_lock);
+				cifsi->time = 0;
+				spin_unlock(&inode->i_lock);
+				goto out;
+			}
+
+			new_eof = off + len;
+			netfs_resize_file(&cifsi->netfs, new_eof, true);
+			cifs_setsize(inode, new_eof);
+
+			qrc = SMB2_query_info(xid, tcon,
+					      cfile->fid.persistent_fid,
+					      cfile->fid.volatile_fid, &file_inf);
+			spin_lock(&inode->i_lock);
+			if (qrc == 0) {
+				asize = le64_to_cpu(file_inf.AllocationSize);
+				inode->i_blocks = CIFS_INO_BLOCKS(asize);
+			} else {
+				cifsi->time = 0;
+			}
+			spin_unlock(&inode->i_lock);
+			goto out;
+		}
+
 		/*
 		 * FILE_ALLOCATION_INFORMATION sets the file allocation size. It
 		 * cannot allocate an arbitrary byte range. Use it only when
-- 
2.43.0

