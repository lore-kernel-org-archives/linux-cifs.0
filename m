Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.119
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793780774;
	b=Le2wNYBdujbTJi1UKaoQ207tkac/OpudAdJrnemYObyfCTzCJCAqjUS7RPolNhYUfTBW
	 ZgegeFieh59GPo1EgoC7ChXcIIry1IM6oCShUATtYQy0ihr9dgg1rh4yGhpN5pE+A/+5j
	 Ug0Vr/wLVWpWSCOMt0bYy5dq7QT8hGjcVwH8pDfz2vVT/i6fu8q0tPj2dDVws7xS8xjpI
	 w9pTBv6JWUh2UhOjDX1nCjIknNA7TfaLEs9GYYF4TDtWSEXtEKxwj7nfL/J3jugTL9q9I
	 WPGSCSSQ7PXKMB92IYe1fYOASw4kFWrMhQ39j6C6wQqsKTAYEkfjllsoZKMjK4aRvLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793780774;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RUoNRwuRK2U7ML+NwwoRg+GWv/RIjHN0PfoN4RGRRaA=;
	b=MjkPyXCQx6/mL5XiEU5NXzk74zbhNoe+ZL8cSGfQuQZ+U14khGsUJNqc+yx/AWlxd3jc
	 Wz7GkG680xHj/L7nE3dUNQ7QXV7ht1Bna1HWaDY9/rc6iCJKQkQTNZ6O38xBnf04nV5Uv
	 Axa9VXAxBT0htPKEEia0Kn+TlHrN+h55qm4thRkm/gdOW2LgUtcX8qvig5iauL06ERe/F
	 kez2Kl+f13UfvsotvG/J3jjojYz4drhVXm3HyHiyBRBCAWEl4Z6v9aAl2lqp3VZvfSOzd
	 e78OQWAHfQnNJexA4/fhA/sle0IWoDxnbdSzyaozqkBqOlohLcDXCFyRh6sphZVq7xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=DFgRmZxD;
	arc=none smtp.remote-ip=115.124.30.119
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0FB606A329;
	Wed,  4 Nov 2026 08:26:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C0FB606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=DFgRmZxD
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793780766; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=RUoNRwuRK2U7ML+NwwoRg+GWv/RIjHN0PfoN4RGRRaA=;
	b=DFgRmZxDheiFkOBdzyHwAKk9gWXeiyv+LqNmOhusDcPMkt9IsDOZ1zbhzu/yanrNjpBHgJjejKR2jVReLQ+0aEJ7dzWYOEuEBFUvyfnsD/Yq19+0I9+Rc3nt6m9HSPLpDzCJuEXPUXJTwuB6nlwVMcBQ/Q512wSrgKEuuYIbEL8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE5A0yX_1793780765;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE5A0yX_1793780765 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Nov 2026 16:26:05 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Cc: Steve French <stfrench@microsoft.com>,
	stable@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 6.6.y v2] smb: client: base punch-hole EOF decision on server_eof
Date: Wed,  4 Nov 2026 16:25:35 +0800
Message-Id: <20261104082535.404128-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261103092918.2363406-1-joseph.qi@linux.alibaba.com>
References: <20261103092918.2363406-1-joseph.qi@linux.alibaba.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb3_punch_hole() decides whether to move the server EOF marker by
comparing against netfs_inode(inode)->remote_i_size.  Nothing on this
base keeps that field up to date: netfs_inode_init() has no caller under
fs/smb/, so remote_i_size is never even initialized, and the only writes
to it are netfs_resize_file() from the clone and copy_file_range paths
and this function itself.  The writeback path tracks the server size in
cifsi->server_eof through cifs_update_eof() instead, and
cifs_fattr_to_inode() refreshes only server_eof as well.

Reading remote_i_size therefore compares the punch against whatever the
slab object last held.  With it at zero, punching the first 4k of a clean
8k file passes "end > remote_i_size && i_size > remote_i_size", issues
SMB2_set_eof(4096) and truncates the server file in half, with nothing
dirty left to write the tail back.

The flush added by commit 216e46958605 ("smb/client: flush dirty data
before punching a hole") makes a second variant reachable.  It writes
out and cleans any page straddling the end of the punched range,
including the valid data in it beyond the hole, and advances server_eof
but not remote_i_size.  When the punch end lies beyond that stale value,
SMB2_set_eof() shrinks the server to the end of the hole and discards
what the flush just wrote out.  The page is clean, so a later fsync or
close will not write it again and the data is silently lost.

Base the decision on CIFS_I(inode)->server_eof and keep both size fields
in sync when the marker moves, so the server is never shrunk below data
that has already been written out.

The cached server_eof can in turn lag the server.  Writeback of
already-dirty folios beyond the punched range is excluded by neither
i_rwsem nor the invalidate lock (cifs_writepages() takes neither), so it
can complete while the decision or the SMB2_set_eof() request based on
it is in flight, extending the server EOF beyond the value the request
carries; the request then shrinks the server below data that writeback
has just committed, and the local marker is left ahead of the server.
When the marker needs to move, flush the whole file and re-read
server_eof before deciding: writeback completions publish server_eof
before ending folio writeback, so once filemap_write_and_wait() returns,
the cached value reflects everything written out and no dirty folio
remains that could race with the request.  Take inode->i_lock for the
reads and the update, as server_eof is documented to require, and only
ever advance it, matching cifs_update_eof(): folios dirtied through an
mmap can still be written back while the request is in flight.

Mainline does not need this change.  cifs_alloc_inode() zeroes
_remote_i_size there, cifs_fattr_to_inode() refreshes it, and the
writeback path advances it through netfs_resize_file(), so the value
cannot be stale after the flush.

Fixes: 288d398df80c ("cifs: Fix FALLOC_FL_PUNCH_HOLE support")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/smb/client/smb2ops.c | 75 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 62 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 21a2b265ae7c4..df3499c8a2249 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3346,7 +3346,7 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 	struct inode *inode = file_inode(file);
 	struct cifsFileInfo *cfile = file->private_data;
 	struct file_zero_data_information fsctl_buf;
-	unsigned long long end = offset + len, i_size, remote_i_size;
+	unsigned long long end = offset + len, i_size, server_eof;
 	long rc;
 	unsigned int xid;
 	__u8 set_sparse = 1;
@@ -3392,20 +3392,69 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 	if (rc)
 		goto unlock;
 
-	/* If there's dirty data in the buffer that would extend the EOF if it
-	 * were written, then we need to move the EOF marker over to the lower
-	 * of the high end of the hole and the proposed EOF.  The problem is
-	 * that we locally hole-punch the tail of the dirty data, the proposed
-	 * EOF update will end up in the wrong place.
+	/*
+	 * If the tail of the file beyond the hole has not been written out
+	 * yet, the server EOF marker is still below both the end of the hole
+	 * and i_size.  Move it up to the lower of the two: when that is
+	 * i_size the file is already at its final size, otherwise the
+	 * remaining dirty tail is written later and extends it the rest of
+	 * the way.
+	 *
+	 * Decide on server_eof rather than the netfs remote_i_size, which
+	 * nothing here keeps up to date: the flush above advances only
+	 * server_eof, through cifs_update_eof(), so comparing against
+	 * remote_i_size would shrink the server below data that was just
+	 * written out.
 	 */
+	spin_lock(&inode->i_lock);
 	i_size = i_size_read(inode);
-	remote_i_size = netfs_inode(inode)->remote_i_size;
-	if (end > remote_i_size && i_size > remote_i_size) {
-		unsigned long long extend_to = umin(end, i_size);
-		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
-				  cfile->fid.volatile_fid, cfile->pid, extend_to);
-		if (rc >= 0)
-			netfs_inode(inode)->remote_i_size = extend_to;
+	server_eof = CIFS_I(inode)->server_eof;
+	spin_unlock(&inode->i_lock);
+
+	if (end > server_eof && i_size > server_eof) {
+		/*
+		 * The cached server_eof may still lag the server: writeback
+		 * of already-dirty folios beyond the punched range takes
+		 * neither i_rwsem nor the invalidate lock (see
+		 * cifs_writepages()), so it can extend the server EOF while
+		 * the decision or the request below is in flight, and the
+		 * request would then shrink the server below data that
+		 * writeback has just committed.  Flush the whole file and
+		 * re-read before deciding: writeback completions publish
+		 * server_eof before ending folio writeback, so once the
+		 * flush has returned the cached value reflects everything
+		 * that was written out, and no dirty folio is left that
+		 * could race with the request.
+		 */
+		rc = filemap_write_and_wait(inode->i_mapping);
+		if (rc < 0)
+			goto unlock;
+
+		spin_lock(&inode->i_lock);
+		i_size = i_size_read(inode);
+		server_eof = CIFS_I(inode)->server_eof;
+		spin_unlock(&inode->i_lock);
+
+		if (end > server_eof && i_size > server_eof) {
+			unsigned long long extend_to = umin(end, i_size);
+
+			rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
+					  cfile->fid.volatile_fid, cfile->pid,
+					  extend_to);
+			if (rc >= 0) {
+				/*
+				 * Folios dirtied through an mmap while the
+				 * request was in flight can still be written
+				 * back and publish a larger EOF, so only ever
+				 * advance, as cifs_update_eof() does.
+				 */
+				spin_lock(&inode->i_lock);
+				if (extend_to > CIFS_I(inode)->server_eof)
+					CIFS_I(inode)->server_eof = extend_to;
+				netfs_inode(inode)->remote_i_size = extend_to;
+				spin_unlock(&inode->i_lock);
+			}
+		}
 	}
 
 unlock:
-- 
2.39.3

