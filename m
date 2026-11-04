Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827703;
	b=zqTfg9LK2SRcaU8pjQryoayzn8DCJCNjgNhJEuHBF8uIO9+8O8TmCjTazP0k4R3/APKL
	 l06o0Br21GxoGDTQU0AQiLynNobNcGyf7qX6BEWux4MP3mslfSj0cmpT0d6OE2biL0JqZ
	 EecKNaKxl8YbS9nv8SaFc1PAoQpvBRf56xxeDuSoVOureEtPMH0UrEa/2mamRvLRLCdq5
	 BGQ9QujWNEXjjtZlX9mv94OCewzsmIR6doOQX1BUTRYBbR1Uk4UZKMFb9gE1giCYgR6OT
	 71SEhTjjWnDmT3lKkLgPqNWxpQqHPKo6A4gQ8bttJuk0APMy1YN37MSiM0jltuRsCFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827703;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VapSxicrfDhPFY6jhB3EF79WX68ekkVXOTpzL48QDI8=;
	b=u/6m70JSNo0SgeRwAzHpUyYkM8LHHdvqQ6ntam7+03kPJtYkZQkHHHvOMHZ1kEjGAGnQ
	 q8YdvEwLYbj0/WTZkQG9lmvieEN48re9pf8taDh9u5cwyw2yE8whOz+yjpWPr2oD+ly2P
	 iFFksw38i0RpCMB7dwBvoPQFkgj6ncn0KfGA4MSKF7v6agxtEKuuXKlxaJVV5CgLM29ga
	 cwoExryLgPCOnPXK/6FYoDmGLpPCT3QaPMju/rYlUkMpXxGdsmIxCZfmF5Fgpug7BJoh1
	 Pu8YOWjBdqd5HHgzPwnQ5B7VGWzH0fSut/72YGK69zyiamcTfcgoFC4fuOvsNUvPwEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=q+WGy8lL;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124056078002;
	Wed,  4 Nov 2026 21:28:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 124056078002
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=q+WGy8lL
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=VapSxicrfDhPFY6jhB3EF79WX68ekkVXOTpzL48QDI8=; b=q+WGy8lLyUlwMyhdB3+bdxDsCe
	3syd9LTtj+L5Kdttij6wLaY/1R5FD6+eUQkSjwMmFDhZ7VOanMGn/XFmWhei1nrbch/+/qGfjWRhu
	pVr7GPj+2cob5AZGnR8KaVzJHWHSF60/NG8dmCrX7La8RHtTXi/QfE7gN8nm4/ATRyTsZ9vOQqK2k
	V9yWZS8JMrdpsHLqXN/O1LSaaWVZ3aXgHkdFMOnbfzNbOV9A5IA2w2Hzxmq58coTvMXmz3ZtJJw3M
	EPkWZoMEYiETPxfF9VBgzKM7sdka8KyZdLyUQMQ9MVdSSv++N5nCOqN6K8PSgFUmMtiSmqcfAFSt6
	EkQxkCgw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xOiWk-00000000rIi-3gR6;
	Wed, 04 Nov 2026 18:28:16 -0300
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
Subject: [PATCH v4 15/17] smb: client: don't replay handle reopens inside SMB2_open()
Date: Wed,  4 Nov 2026 18:28:08 -0300
Message-ID: <20261104212810.1935575-16-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104212810.1935575-1-pc@manguebit.org>
References: <20261104212810.1935575-1-pc@manguebit.org>
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

cifs_reopen_file_retry() reopens a read's or write's handle with backoff,
per the hard and retrans mount options, giving up on umount -f.  It calls
cifs_reopen_file() -> SMB2_open(), which replays replayable errors on its
own, also per hard and retrans.  So each reopen is retried at both
layers: up to (retrans + 1)^2 opens on a soft mount, and, on a hard
mount, forever inside SMB2_open() without ever returning to
cifs_reopen_file_retry() to notice umount -f - a worker doing writeback
then can't be stopped.

Have cifs_reopen_file_retry() tell SMB2_open() not to replay, so these
reopens are bounded and stopped only by cifs_reopen_file_retry().  Other
callers of cifs_reopen_file() keep SMB2_open()'s replay; SMB1 opens are
unchanged.

Since SMB2_open() no longer runs its own replay loop for these reopens,
carry the replay state from cifs_reopen_file_retry() into it so that a
retried durable reopen still reuses the create GUID and sets
SMB2_FLAGS_REPLAY_OPERATION.  Otherwise each retry would open with a
fresh GUID and no replay flag, and could leak a persistent handle on the
server if an earlier attempt was processed before a disconnect.

Fixes: 69c3c023af25 ("cifs: Implement netfslib hooks")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/file.c     | 24 ++++++++++++++++++------
 fs/smb/client/smb2pdu.c  |  8 +++++---
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index ca29974a2cd9..65f7a08eb751 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1408,6 +1408,7 @@ struct cifs_open_parms {
 	umode_t mode;
 	bool reconnect:1;
 	bool replay:1; /* indicates that this open is for a replay */
+	bool no_replay:1; /* don't replay this open internally */
 	struct kvec *ea_cctx;
 	__le32 lease_flags;
 };
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 9e14c764fb61..724523c0cb4a 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -37,7 +37,12 @@
 #include "cached_dir.h"
 #include <trace/events/netfs.h>
 
-static int cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush);
+/* flags for cifs_reopen_file() */
+#define CIFS_REOPEN_BOUND	BIT(0)	/* caller bounds the retries */
+#define CIFS_REOPEN_REPLAY	BIT(1)	/* replay: reuse GUID + REPLAY op */
+
+static int cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush,
+			    unsigned int flags);
 
 bool cifs_io_stopped(struct cifs_io_subrequest *subreq)
 {
@@ -164,12 +169,16 @@ static int cifs_reopen_file_retry(struct cifsFileInfo *cfile, bool can_flush,
 	int rc;
 
 	for (;;) {
+		unsigned int flags = CIFS_REOPEN_BOUND;
+
 		if ((retrying && cifs_io_stopped(subreq)) ||
 		    cifs_io_aborted(subreq))
 			return -EIO;
-		retrying = true;
+		if (retrying)
+			flags |= CIFS_REOPEN_REPLAY;
 		reconnects = cifs_ses_reconnects(ses);
-		rc = cifs_reopen_file(cfile, can_flush);
+		rc = cifs_reopen_file(cfile, can_flush, flags);
+		retrying = true;
 		if (!rc || is_interrupt_error(rc) ||
 		    cifs_writeback_dying(&subreq->subreq))
 			return rc;
@@ -1544,7 +1553,7 @@ cifs_relock_file(struct cifsFileInfo *cfile)
 }
 
 static int
-cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
+cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush, unsigned int flags)
 {
 	int rc = -EACCES;
 	unsigned int xid;
@@ -1645,6 +1654,8 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 		.path = full_path,
 		.fid = &cfile->fid,
 		.reconnect = true,
+		.no_replay = !!(flags & CIFS_REOPEN_BOUND),
+		.replay = !!(flags & CIFS_REOPEN_REPLAY),
 	};
 
 	/*
@@ -1841,7 +1852,8 @@ cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 	spin_unlock(&tcon->open_file_lock);
 
 	list_for_each_entry_safe(open_file, tmp, &tmp_list, rlist) {
-		if (cifs_reopen_file(open_file, false /* do not flush */))
+		/* do not flush */
+		if (cifs_reopen_file(open_file, false, 0))
 			tcon->need_reopen_files = true;
 		list_del_init(&open_file->rlist);
 		cifsFileInfo_put(open_file);
@@ -3071,7 +3083,7 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 			*ret_file = inv_file;
 			return 0;
 		}
-		rc = cifs_reopen_file(inv_file, false);
+		rc = cifs_reopen_file(inv_file, false, 0);
 		if (!rc) {
 			*ret_file = inv_file;
 			return 0;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 33f8d0638a54..7240910f60f1 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3339,7 +3339,9 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
-	oparms->replay = !!(retries);
+	/* with no_replay the outer retry loop owns oparms->replay */
+	if (!oparms->no_replay)
+		oparms->replay = !!(retries);
 
 	cifs_dbg(FYI, "create/open\n");
 	if (!ses || !server)
@@ -3361,7 +3363,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	trace_smb3_open_enter(xid, tcon->tid, tcon->ses->Suid, oparms->path,
 		oparms->create_options, oparms->desired_access);
 
-	if (retries) {
+	if (oparms->replay) {
 		/* Back-off before retry */
 		if (cur_sleep)
 			msleep(cur_sleep);
@@ -3428,7 +3430,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	SMB2_open_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
 
-	if (is_replayable_error(rc) &&
+	if (!oparms->no_replay && is_replayable_error(rc) &&
 	    smb2_should_replay(tcon, &retries, &cur_sleep))
 		goto replay_again;
 
-- 
2.56.0

