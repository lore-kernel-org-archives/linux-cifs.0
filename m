Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632537;
	b=v+u1fBrfXOSw04OrEZXQQJbEMhavsyVNvB9MV4F2dzjuXeAfz5XDWqbGiX+w2vnNuI9g
	 v0H23c3AoQjKkEdQm7YNvwb4wiGv+qrcuKMUVuE3IOxdJEV3i3BSsdYwV57nL3pbetiKl
	 /1AIyhiQVMbxMJJh0w0f/JiIvgM6AGHSUHUhYeom3D95G2bQj0g5YVXgzY+d0+djZ7qKf
	 WRuAI9qzocIsBP9R6H9vqx0ALMk0CkEGRRMD8A/oEBNe9B+cmFXYo3UBOl/We3AzL8a0R
	 RfCvuJ6KpQwWsuh7BApyPqdbZl6Kl9GSZOBkjqapMRWUwuAUYHZOwjvqNv8sgxRIuVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632537;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1faRywtJCP+JRJGU9PHed7i5GyJR6frSTS25rp7+G2A=;
	b=qJCvVQaUncnTCHuv9NhfGtKVV2eu7e/i/lYmrm/I3hoRgee3lkWFgdKylX/Cm3xeuZuC
	 EgI9A/B4HDVce22uC+z751qyj9S2WRDxSprv8RL57OWHU9XBiW2iyStl5dqQBO3npqC+4
	 ZkTdknrjorPimxpxsjGYztYZ0H2VjjNc/DaMTW2pBW/Z0/t9BQ0TLbZmnQsAF5TQ2i2zo
	 LTzHuBzGfDWOJ1lz2xPTOu/6TahxVDPPZXJahstD10VZ51hzl2V0GSRupmtR5PlgNxzDy
	 cDattz5R5YAM2cJR/U2xhUbSt4oQjzgTkK+W3S+R2IR7YE9A8tKhLVPhjLz0+BfERjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="N0M/13/t";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030B960B57DD;
	Mon,  2 Nov 2026 15:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 030B960B57DD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=N0M/13/t
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=1faRywtJCP+JRJGU9PHed7i5GyJR6frSTS25rp7+G2A=; b=N0M/13/toZveVJ54rE+7QnPXku
	MPuHuqMRUfpxwMgppGvHEmJFKRWYdkXXC4Vnoay3B4a0xfo05Oqv/txw+HJd/xttv93+SD0Ole0Ln
	k3Ds+DmDddjTWMA8ksASoN3S6LsvFtAi5/K5nXxxkdIfKMEx5yx097Cg/SyIahw04UZl2ojJ3PG5W
	4qvCkY059VN4HFddhLsOmkcxd1+dwdMDj4eoamoiHgWfm6/2N9JuHtW+smC4dASMcMGBSVwvx9i3R
	mFtLFVvyhxVahO35AASeKv0DgXaG1m8JFRWD85r4Z0WzLctAyRrJRtv7NXKMTVi/fsRZ5oVwcieMi
	ccmSEB9A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xNtkr-00000000aQY-0NwB;
	Mon, 02 Nov 2026 12:15:26 -0300
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
Subject: [PATCH 01/15] smb: client: don't write back through O_DIRECT handles
Date: Mon,  2 Nov 2026 12:15:11 -0300
Message-ID: <20261102151525.925058-2-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102151525.925058-1-pc@manguebit.org>
References: <20261102151525.925058-1-pc@manguebit.org>
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

