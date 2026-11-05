Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793918743;
	b=EodH8dO0xWcYoC9t+SRoD2RqZuSxpfjMBFBIG4vt1usAuVtsuRhdi+QswQVYFHPcOxJG
	 /jpJyC4iE17t/kyvUdXK6AHjR/Xidytm8XBGPxjAEHOzEKoThPaVlV5j95vAuzNznfdaG
	 Hs5JDswxEoX4Gp+Ym2W36L67rj3GSfzKnlUcM/WoMMdYtNdEi94YHE4xL+hPdhGbFUt5v
	 kAuOro+8GACulGY+hvZc1hp88xWMy6gI+8tQ1/ycZ4aqbTa27/9d6O5Eti62UsHsv3Lp6
	 Tn0KF36DobsDUwQ86GXjy65hodt+kiD5+cBxw4Krc91LSDYYcN2OFygkJJHRrJK7BQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793918743;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1faRywtJCP+JRJGU9PHed7i5GyJR6frSTS25rp7+G2A=;
	b=Ayj4RBRggZHwph+JSD7YY+GbCgfPqZ5Doh6JE/uJ039TXneJErac3rbVwLkIQDhmGBvJ
	 KLZ6YyWtxLXv0Iek80rD5WqPxtpCyufa5lVAb2UTMu8CJFg3dxGGU7idS0CxV8W76v2yk
	 553YXdXBZEedO7+wpYR2MHjtyPEMi0Z/nw4ddsFFEbofZO29wwKJdrSmtn47h5cECx5eH
	 zlRT+2Au1g57JQHHN+UuXa2tgbfOdaaWKTMrv8vdGKHtc3H081cHgbP44T86mkU3DgmB2
	 jj4ze2t78pGfDq17f8k0tuDInCfsH7KPU6DwaS3q4Kb8MTjDgs/NnNR/Nq5PXfDwdzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=51npf4SK;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB56606A331;
	Thu,  5 Nov 2026 22:45:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FB56606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=51npf4SK
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=1faRywtJCP+JRJGU9PHed7i5GyJR6frSTS25rp7+G2A=; b=51npf4SKRzylcsCCMNZYXPhWK3
	VGy13J4LdO0k1raoFtkdgYr427FDMBQwtQU4kB5innqWzZdQmUB1wySE8V9el0xdjte3npUv9NiFF
	98/ISendM6LCwxmktJI7RmwA2yWe9mizPmcrq35OQbrMwCaXT1OAGf5XqAiZcfDSJJFgrXB/YIuqK
	nQUofmj0UQMe2MBsIgVduS9aaa25kG6GIUtq9M4TGwCwkw/AFbK7FAS1Y7l2WQaFHfvcDDv9pen0p
	geq5gQrC45mWmjmTvkYHVkXn4rM0J6IUtgv0CrWrER9Nrgl1yLJihuufScC0Cwgv7QffsIWgEs83g
	u5vEvzpg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xP6D5-00000000ymb-1TrF;
	Thu, 05 Nov 2026 19:45:32 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Christian Brauner <brauner@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v5 01/17] smb: client: don't write back through O_DIRECT handles
Date: Thu,  5 Nov 2026 19:45:15 -0300
Message-ID: <20261105224531.2316211-2-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105224531.2316211-1-pc@manguebit.org>
References: <20261105224531.2316211-1-pc@manguebit.org>
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

Writeback uses the first writable handle of the inode, which may have
been opened with O_DIRECT.  Such handles are opened with
FILE_NO_INTERMEDIATE_BUFFERING, for which Windows rejects any unaligned
I/O with STATUS_INVALID_PARAMETER.  Writeback of partly dirty pages and
of the unaligned tail of a file through one of them fails, so netfs ends
it with the folios clean and the data never reaches the server.

xfstests generic/051, where fsstress mixes both kinds of opens, loses
about 1% of its writes this way:

  smb3_write_err: ... offset=0xde90d7 len=0xbd0b rc=-22

All the rejected writes in a network capture were unaligned writes on a
no-buffering handle; none of the aligned ones, and none of the unaligned
ones on regular handles, were.

Prefer a handle that was not opened with O_DIRECT, and use one that was
only if there is no other.

Fixes: 1013e760d10e ("SMB3: Don't ignore O_SYNC/O_DSYNC and O_DIRECT flags")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/file.c     | 15 ++++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index d3ca688b6aba..dbf980fcf05b 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1891,6 +1891,7 @@ enum cifs_find_flags {
 	FIND_WITH_DELETE	= (1U << 1),
 	FIND_NO_PENDING_DELETE	= (1U << 2),
 	FIND_OPEN_FLAGS		= (1U << 3),
+	FIND_NO_DIRECT		= (1U << 4),
 };
 
 #define   MID_FREE 0
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 0767eb5f4687..aa2d09dac44c 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -255,9 +255,15 @@ static void cifs_begin_writeback(struct netfs_io_request *wreq)
 	struct cifs_io_request *req = container_of(wreq, struct cifs_io_request, rreq);
 	int ret;
 
-	ret = cifs_get_writable_file(CIFS_I(wreq->inode), FIND_ANY, &req->cfile);
+	ret = cifs_get_writable_file(CIFS_I(wreq->inode), FIND_NO_DIRECT,
+				     &req->cfile);
 	if (ret) {
-		cifs_dbg(VFS, "No writable handle in writepages ret=%d\n", ret);
+		ret = cifs_get_writable_file(CIFS_I(wreq->inode), FIND_ANY,
+					     &req->cfile);
+	}
+	if (ret) {
+		cifs_dbg(VFS, "%s: couldn't find writable handle: %d\n",
+			 __func__, ret);
 		return;
 	}
 
@@ -2722,7 +2728,7 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 	}
 
 	if (test_bit(CIFS_INO_TMPFILE, &cifs_inode->flags))
-		find_flags = FIND_ANY;
+		find_flags &= FIND_NO_DIRECT;
 
 	cifs_sb = CIFS_SB(cifs_inode);
 
@@ -2752,6 +2758,9 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 		    !open_flags_match(cifs_inode, open_flags,
 				      open_file->f_flags))
 			continue;
+		if ((find_flags & FIND_NO_DIRECT) &&
+		    (open_file->f_flags & O_DIRECT))
+			continue;
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
 			if (!open_file->invalidHandle) {
 				/* found a good writable file */
-- 
2.56.0

