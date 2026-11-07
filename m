Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794071590;
	b=DqdGIDT8h7Zdh3YXP9SjnxCUqCRr29ku+NdnlX4gqLL1vBalRmnw9erQzJSvEg6JAqQS
	 g1uxFHwRguXLYjbgi5QyeQe670tjEb8YjClH5VrC9YdjR2k4j1oXw2L9kmmImABvWpb/E
	 /oZ5AGd0JYh6WoR8xNHl6HYRuu2JJ2btNZJpM/bm9Areq9g8DMx9gke2fokyChD1tO+oD
	 jB3ddNwnf8QzuVWiLwIpF8WNQatHr97rplwEbjwLGTJIwOnn2aXqviKW9B0Y0FZJMNtdd
	 YnIfbvTPEFE6oV26USvXGzF1VU6p29BxphMJvTAO8HSIYk83qS1SPKt+uBVD0SR/9Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794071590;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1faRywtJCP+JRJGU9PHed7i5GyJR6frSTS25rp7+G2A=;
	b=gWvBIk7gvCD1McXJh407KjbEXkgk9chfHtBKGf7sxCMl0kE71wAgHa7k5FF97/5FoeN9
	 8ChXORsDERhHzfHgq8QbevUaSajeqv2hZV/O19pASwwif9E5+RPCQ9aQMtzZBUuJHTDzY
	 kL7Yn4g3AqY81edGppWDLpE5ULlCDmz5pvrXjYryIKMgbh8TsmmTn0mFkDUkhtFwT+f79
	 SvqZJ85ZBC+QNyf05AqBJO+KHVWd1No/saGSCf96Z23mRZcm0Ul3Y0+Junkk5yTbO4pxE
	 SPk0YGq0goJ07kxOHhG4N+GYL7Yjgh+4FEAQtHcWf1Vwcwuztm75TfozQbHw3VhOlnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="GjN/8jO+";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C014D606A32F;
	Sat,  7 Nov 2026 17:13:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C014D606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=GjN/8jO+
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=1faRywtJCP+JRJGU9PHed7i5GyJR6frSTS25rp7+G2A=; b=GjN/8jO+Nbnvx+c3udjaCtLEmW
	tmhxcXNDwzWo3w73FzESPTDCgLXXiu9vxi81/eOburi+qhkB9huF5Tn7go6qxKfO1ffOaOGKiOwin
	taMRxfs1DxrtrHe/zV7y9i2rMYmzKfzbZF5vQLvJh25RIjXp4cYZoKc0DMy1Ngsg65SdyiEe7GpU7
	GqNfgLrC9nRrZJIV/lkULY20su1ywtxX7KwvBrXL3evXdeUhh5DCJ0mU0awhjPiGY4Qxqw9++BuW0
	a8vaikx+fXMVnKPz0vFvt++vxbpRWQMCYRFG4o9v9OT0xWzLNKSeto3YIvUYTogQQ2KTX3xi6F9VX
	HJhs9Nvw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPjyS-000000017f0-3iCa;
	Sat, 07 Nov 2026 14:13:06 -0300
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
Subject: [PATCH v9 01/19] smb: client: don't write back through O_DIRECT handles
Date: Sat,  7 Nov 2026 14:12:47 -0300
Message-ID: <20261107171305.2847361-2-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107171305.2847361-1-pc@manguebit.org>
References: <20261107171305.2847361-1-pc@manguebit.org>
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

