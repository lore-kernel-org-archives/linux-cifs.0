Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698165;
	b=SBs77o/PdsbibZ7H/UkioX4Dn9MlLDGHB9FBB7VMSxwUsOB3Wdr0d07gr4ZfLplwEpG/
	 brsRPi3GK/gNuGuBzXhrT5yC0aCeRDCEB7wSNiw1jljCeF5A7ybzrsp44AeEb/+r5GaIz
	 b2xQ6GxWJBHb4qnqyEscHXjqCBgjBmZeuuIbLTWBAKHpIxLhg9IF2dUmZfrkXiJevIlTB
	 wmPSqDgwCCJXRfdfdOgkFQnLv5/o7Hy+4LFIFUFbyHD/tk7GcIhdAatI6fcBB4NbiiokA
	 ezjc9f2N+F7nv8hKvq8Ld8vZXZc1ZH4CrCyYgO5lhCHNgTV/8yVG+CQrns+7vMbXfrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698165;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=F2+4Yzh+dcpVAnl+hKWRshMrg70cWm8d6zxfSczxXVA=;
	b=FrE5XFFv6XahdksMhuFSLvv9PZXG6QRD6ez06MU+Z3B0S/Jmmxifbduo9cIUhgeiyrAx
	 pQtsj7NivlcMeOd1KYM+XKZmoOBIKNuL9KD5Fd+iB6z3wZLPbaVe5JfrMlw1XMQXZ/wGC
	 u0PjEIXIzJ3nBzk02k7Q2KNgsuJqw0tJu3Rungx452qO3AiOaq15hDtZ/vcx1tJ7Dor7J
	 mdIaSV31Rn0y5Z3lWrfZELc2ul1KqPqhKPJ4+z4B36BXMoaUN9wcWtns7+9sw7f8UNGyf
	 co+dSW/+QKvo6PL1tPoq5x+LeRO7qhcnMDYSDhVJu4p0nV4vBmmRpc3QCbGhltaEGrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LLMh0wcx;
	arc=none smtp.remote-ip=115.124.30.110
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A963606A327;
	Tue,  3 Nov 2026 09:29:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A963606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LLMh0wcx
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793698160; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=F2+4Yzh+dcpVAnl+hKWRshMrg70cWm8d6zxfSczxXVA=;
	b=LLMh0wcx3PbZ2/WfHRU3Sxhz1s9n2U7dOx47j3DtyMbWaiO1Dvo21u2oU4uf+qZkI4X5Qbvig806larIv2cUQG1ZL9jmvZ8wIZsM7hC9xBNyBD3/YvX6Yv6Enn+1/dOUlc6l2na3O2KH17PYDE3h0p9ekk+Ik8GzYa53Vrvtchk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XE2Mcek_1793698158;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE2Mcek_1793698158 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Nov 2026 17:29:19 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Cc: Steve French <stfrench@microsoft.com>,
	stable@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH 6.6.y RESEND] smb: client: base punch-hole EOF decision on server_eof
Date: Tue,  3 Nov 2026 17:29:18 +0800
Message-Id: <20261103092918.2363406-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
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
that has already been written out.  Take inode->i_lock for the read and
the update, as server_eof is documented to require, and only ever
advance it, matching cifs_update_eof(): background writeback of folios
outside the punched range is excluded by neither i_rwsem nor the
invalidate lock, and can publish a larger EOF while SMB2_set_eof() is in
flight.

Mainline does not need this change.  cifs_alloc_inode() zeroes
_remote_i_size there, cifs_fattr_to_inode() refreshes it, and the
writeback path advances it through netfs_resize_file(), so the value
cannot be stale after the flush.

Fixes: 288d398df80c ("cifs: Fix FALLOC_FL_PUNCH_HOLE support")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/smb/client/smb2ops.c | 39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 21a2b265ae7c4..2826a60f0d8ab 100644
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
@@ -3392,20 +3392,41 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
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
+	server_eof = CIFS_I(inode)->server_eof;
+	spin_unlock(&inode->i_lock);
+
+	if (end > server_eof && i_size > server_eof) {
 		unsigned long long extend_to = umin(end, i_size);
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, extend_to);
-		if (rc >= 0)
+		if (rc >= 0) {
+			/*
+			 * Writeback of folios outside the punched range may have
+			 * published a larger EOF while the request was in flight,
+			 * so only ever advance, as cifs_update_eof() does.
+			 */
+			spin_lock(&inode->i_lock);
+			if (extend_to > CIFS_I(inode)->server_eof)
+				CIFS_I(inode)->server_eof = extend_to;
 			netfs_inode(inode)->remote_i_size = extend_to;
+			spin_unlock(&inode->i_lock);
+		}
 	}
 
 unlock:
-- 
2.39.3

