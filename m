Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC1E1D416C
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 02:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782267466; cv=none; b=f6FIlsTT8qrHSmWBADYhaPyeuYTCjuRpjHUz0/SJxgIZN+UQPY028lq38kzF5eOx+/iQ71btwb4W5z5nEru3bxMBdm3VLPdemizk3O+mLBJfvZN7BeqTHi/8vk9YhT14WVaLwlvNWCDU+99TcTAoVVmu+yqL86EwrQ1rpSAg41g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782267466; c=relaxed/simple;
	bh=idb+TFntUz4YM6Oh+pp8JE3oiCbKDbwZHgnuIcsu+ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emKyD+2tLNCQC3AgiBeQgHc+v+1N44uq0nk+dAg4EH467KHU+gojx5TyL6LDZcqBo1bN6oIz3ICzrmZN1c0pqfr8wUKHhxjxh+kwqHGJnmyN+b7O8biqM8hFA/gR3snwKNjzG78oNMnel8cogKBJ44Gggfu2xwYBj0HoCh2tMms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oTogNgkV; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oTogNgkV"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782267463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FBzo/dCxswFmDSkMuWDPvdJZ0M4ZW1B+iafpntFjf1M=;
	b=oTogNgkVpaGbbMgtFsdwl1iePMceAxTRfVXAzc1r2K929mLDPYqB19QsyhlAkXpiks4PTr
	qe4WHaTCU1qOhyCmvVQ3vCV9LMlWzuK9j8vAaGYj38zcNvl7lzkBYz7vMioRTY0mc5/JxU
	7r/lorxUADCndJkY9TvPjzU2uI+Xgz0=
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
Subject: [PATCH v2 9/9] smb/client: emulate small sparse fallocate ranges at EOF
Date: Wed, 24 Jun 2026 10:15:50 +0800
Message-ID: <20260624021550.1548952-10-huiwen.he@linux.dev>
In-Reply-To: <20260624021550.1548952-1-huiwen.he@linux.dev>
References: <20260624021550.1548952-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

smb3_simple_falloc() returns -EOPNOTSUPP for mode 0 requests that start
at EOF of a non-empty sparse file because FILE_ALLOCATION_INFORMATION
cannot allocate an arbitrary byte range.

However, one small case can be handled safely: a range that starts exactly
at the current EOF. For example:

        xfs_io -f -c "pwrite 0 1m" file
        xfs_io -c "falloc 1m 4k" file

Writing zeroes to this range does not create an intervening hole or
overwrite existing data. It allocates the requested range and extends EOF
without changing other sparse regions. Limit this emulation to 1 MiB to
keep the network and server I/O cost bounded.

This allows small EOF-adjacent fallocate requests on sparse files to
succeed. After the write, update the local file size and refresh i_blocks
from the server-reported AllocationSize. Larger ranges remain
unsupported.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e0815805caca..b6d5771a7c54 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3707,6 +3707,44 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		if (rc)
 			goto out;
 
+		/*
+		 * A small range immediately after EOF can be allocated by
+		 * writing zeroes without creating an intervening hole.
+		 */
+		if (off == old_eof && old_eof != 0 &&
+		    (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)) {
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
 		 * FILE_ALLOCATION_INFORMATION sets the allocation size for the whole
 		 * file and cannot allocate an arbitrary byte range. Use it only for
-- 
2.43.0

