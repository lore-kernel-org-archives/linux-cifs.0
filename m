Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793979439;
	b=ScqvO0xg8Xh0QEarKaN4QW8HC6dPL5lryVGeN4z3t7UBaUHgkJ4tj9ge8JSgTXZeri5Z
	 aW1Tm7mWLRVycBj8fIy98p/dj8He3wxUqwJQz3AclxlI9rUw5SCvEBc04tcGzNNTlObOv
	 mbNla999Y7T+d5v00ijB2ojpXtPIbKKIlXguNp7OUCPEOc7y818cxIyohIS5Eduwz5Fzp
	 K/aKdqQwmHH7U6Pt9PK3kIWcgtitygsOmW7GNHlgelj+waMW4iAgt3a6tR8NcWlaj1DBb
	 7pkMc3/8ekWfKuTG8/Ktbs7zpIJ51Vp356jMZ1NtblvDKjkpzedZ4yt/ngjAhlMtI0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979439;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BuEldx5ma/2Aee6zSowSnmFJKuPpLSEuD3YgQNYfqWc=;
	b=ltMM2G+CcYvbYOnxhol6QOXbdTNtNBiRkgbiDmu5fuwxUowVjMXsH75xwBRvjP2zM2aK
	 CaF7ksKq0wKHO6MQ23REwW1w/BodmdshD13n9wGn8+0SU4nXGrS8yu0PKGvo4u51NDwhf
	 LdQynYJGEC7mpueaIcPAusBjs0rFA0NZbDwccekDCIkuyeiWCEegAcXLCzsa4AS2vbDmd
	 SK+Qr/AfEDoZlUI4AB/6o/ysIvCnaXOcdTSL0CjU0Zkmv3WLz9q/Clg4OtAubmCkmO/Ez
	 86uNl5oA947jQRvVNryb8mMGHUnKrrF38ZVhrEfxdcEqMHYwlbv6fxlwWWhZl0QMqaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=MOPTDG4b;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84362606D806;
	Fri,  6 Nov 2026 15:37:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84362606D806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=MOPTDG4b
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=BuEldx5ma/2Aee6zSowSnmFJKuPpLSEuD3YgQNYfqWc=; b=MOPTDG4biYIBQEtSK4wtLya0ew
	w9uNil2MQb4ikQFf8tf7iTYR8bMD1fRa/2z/tHnLo4VZT1v4Qttg92N/dyboIy6vSckDgUbiJ+Lri
	bMpa5v1J5djD+eFO43kF6uBYoJZvUdD1crvE/x2n9KXQgNmL18Da+dVFzWV3bK3VuYprOP9PJA6TQ
	vrW6GAwJADheJfm84XDX1mH2Q3c2iNm+1G7PXuMAoYEDVvDP3XXNsoCow/T0lobBF9MT75mbN+YCs
	3wSQ+YxosueyfonWTQeMkK7BaG7y8TVIOWQKjMUZZdnrzRkVBOFLv3hAGeAjMU49scVtseXlZb+i3
	yuA6uuAw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPM0B-000000012b0-3h3P;
	Fri, 06 Nov 2026 12:37:17 -0300
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
Subject: [PATCH v6 16/18] smb: client: don't replay handle reopens inside SMB2_open()
Date: Fri,  6 Nov 2026 12:37:08 -0300
Message-ID: <20261106153710.2498773-17-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261106153710.2498773-1-pc@manguebit.org>
References: <20261106153710.2498773-1-pc@manguebit.org>
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

A reopen reconnects the durable handle or, if the server lost it, opens
the file afresh.  Without SMB2_open()'s loop, a retry must open afresh
again rather than reconnect, which the server would reject, and replay
that fresh open with its GUID, or it leaks a persistent handle.  Track
both on the open file under fh_mutex, so concurrent reopens agree, but
don't replay an open that was never built, nor one that was interrupted,
whose handle the cancelled-open path closes.

SMB2_open()'s own loop retried a failed durable reconnect as a fresh open
with a stale GUID, and smb2_open_file()'s retry without
FILE_READ_ATTRIBUTES as a fresh open, skipping the relock; have both
reissue the same create, only replay a create that was built, and don't
leave SMB2_open()'s own replay state behind for the caller's next create.

Fixes: 69c3c023af25 ("cifs: Implement netfslib hooks")
Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Fixes: 79520587fe42 ("cifs: update the same create_guid on replay")
Fixes: e255612b5ed9 ("cifs: Add fallback for SMB2 CREATE without FILE_READ_ATTRIBUTES")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsglob.h |  3 +++
 fs/smb/client/file.c     | 32 +++++++++++++++++++++++++-------
 fs/smb/client/smb2file.c |  2 ++
 fs/smb/client/smb2pdu.c  | 16 +++++++++++++---
 4 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index fe64abdfd740..27044570fb1d 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1409,6 +1409,7 @@ struct cifs_open_parms {
 	umode_t mode;
 	bool reconnect:1;
 	bool replay:1; /* indicates that this open is for a replay */
+	bool no_replay:1; /* don't replay this open internally */
 	struct kvec *ea_cctx;
 	__le32 lease_flags;
 };
@@ -1461,6 +1462,8 @@ struct cifsFileInfo {
 	spinlock_t file_info_lock; /* protects four flag/count fields above */
 	struct mutex fh_mutex; /* prevents reopen race after dead ses*/
 	unsigned int reopens;
+	bool reopen_fresh; /* durable handle gone: reopen opens afresh */
+	bool reopen_replay; /* ... replaying the last such open */
 	struct cifs_search_info srch_inf;
 	struct work_struct oplock_break; /* work for oplock breaks */
 	struct work_struct put; /* work for the final part of _put */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 1b5daf3c0772..c30777b74239 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -37,7 +37,11 @@
 #include "cached_dir.h"
 #include <trace/events/netfs.h>
 
-static int cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush);
+/* flags for cifs_reopen_file() */
+#define CIFS_REOPEN_BOUND	BIT(0)	/* caller bounds the retries */
+
+static int cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush,
+			    unsigned int flags);
 
 bool cifs_io_stopped(struct cifs_io_subrequest *subreq)
 {
@@ -176,7 +180,7 @@ static int cifs_reopen_file_retry(struct cifsFileInfo *cfile, bool can_flush,
 			return -EIO;
 		retrying = true;
 		reconnects = cifs_ses_reconnects(ses);
-		rc = cifs_reopen_file(cfile, can_flush);
+		rc = cifs_reopen_file(cfile, can_flush, CIFS_REOPEN_BOUND);
 		if (!rc || is_interrupt_error(rc) ||
 		    cifs_writeback_dying(&subreq->subreq))
 			return rc;
@@ -1553,7 +1557,7 @@ cifs_relock_file(struct cifsFileInfo *cfile)
 }
 
 static int
-cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
+cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush, unsigned int flags)
 {
 	int rc = -EACCES;
 	unsigned int xid;
@@ -1570,6 +1574,8 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	int create_options = CREATE_NOT_DIR;
 	struct cifs_open_parms oparms;
 	int rdwr_for_fscache = 0;
+	u8 guid[SMB2_CREATE_GUID_SIZE];
+	bool fresh;
 
 	xid = get_xid();
 	mutex_lock(&cfile->fh_mutex);
@@ -1645,6 +1651,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 		server->ops->get_lease_key(inode, &cfile->fid);
 
 retry_open:
+	fresh = cfile->reopen_fresh;
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
 		.cifs_sb = cifs_sb,
@@ -1653,8 +1660,11 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 		.disposition = disposition,
 		.path = full_path,
 		.fid = &cfile->fid,
-		.reconnect = true,
+		.reconnect = !fresh,
+		.replay = fresh && cfile->reopen_replay,
+		.no_replay = !!(flags & CIFS_REOPEN_BOUND),
 	};
+	memcpy(guid, cfile->fid.create_guid, sizeof(guid));
 
 	/*
 	 * Can not refresh inode by passing in file_info buf to be returned by
@@ -1664,9 +1674,16 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	 * not dirty locally we could do this.
 	 */
 	rc = server->ops->open(xid, &oparms, &oplock, NULL);
-	if (rc == -ENOENT && oparms.reconnect == false) {
+	if (rc == -ENOENT && !fresh && !oparms.reconnect) {
 		/* durable handle timeout is expired - open the file again */
+		fresh = true;
 		rc = server->ops->open(xid, &oparms, &oplock, NULL);
+	}
+	if (fresh) {
+		cfile->reopen_fresh = rc;
+		cfile->reopen_replay = rc && !is_interrupt_error(rc) &&
+			(oparms.replay ||
+			 memcmp(guid, cfile->fid.create_guid, sizeof(guid)));
 		/* indicate that we need to relock the file */
 		oparms.reconnect = true;
 	}
@@ -1850,7 +1867,8 @@ cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 	spin_unlock(&tcon->open_file_lock);
 
 	list_for_each_entry_safe(open_file, tmp, &tmp_list, rlist) {
-		if (cifs_reopen_file(open_file, false /* do not flush */))
+		/* do not flush */
+		if (cifs_reopen_file(open_file, false, 0))
 			tcon->need_reopen_files = true;
 		list_del_init(&open_file->rlist);
 		cifsFileInfo_put(open_file);
@@ -3080,7 +3098,7 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 			*ret_file = inv_file;
 			return 0;
 		}
-		rc = cifs_reopen_file(inv_file, false);
+		rc = cifs_reopen_file(inv_file, false, 0);
 		if (!rc) {
 			*ret_file = inv_file;
 			return 0;
diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index fb2fccbe8667..54f1ed305cba 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -175,6 +175,7 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 	struct cifs_fid *fid = oparms->fid;
 	struct network_resiliency_req nr_ioctl_req;
 	bool retry_without_read_attributes = false;
+	bool reconnect = oparms->reconnect;
 
 	smb2_path = cifs_convert_path_to_utf16(oparms->path, oparms->cifs_sb);
 	if (smb2_path == NULL)
@@ -203,6 +204,7 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 		memset(&err_iov, 0, sizeof(err_iov));
 		err_buftype = CIFS_NO_BUFFER;
 		oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
+		oparms->reconnect = reconnect;
 		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data, NULL, &err_iov,
 			       &err_buftype);
 	}
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index e44ede13098b..81ada35cb2ec 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3332,6 +3332,9 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	int flags = 0;
 	int retries = 0, cur_sleep = 0;
 	struct smb2_file_all_info *file_info = buf ? &buf->fi : NULL;
+	bool reconnect = oparms->reconnect;
+	bool replay = oparms->replay;
+	bool built = false;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -3339,7 +3342,11 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
-	oparms->replay = !!(retries);
+	/* reissue the same create: a durable reconnect clears ->reconnect */
+	oparms->reconnect = reconnect;
+	/* with no_replay the caller owns oparms->replay */
+	if (!oparms->no_replay)
+		oparms->replay = replay || built;
 
 	cifs_dbg(FYI, "create/open\n");
 	if (!ses || !server)
@@ -3357,11 +3364,12 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 			    &rqst, oplock, oparms, path);
 	if (rc)
 		goto creat_exit;
+	built = true;
 
 	trace_smb3_open_enter(xid, tcon->tid, tcon->ses->Suid, oparms->path,
 		oparms->create_options, oparms->desired_access);
 
-	if (retries) {
+	if (oparms->replay) {
 		/* Back-off before retry */
 		if (cur_sleep)
 			msleep(cur_sleep);
@@ -3428,10 +3436,12 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	SMB2_open_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
 
-	if (is_replayable_error(rc) &&
+	if (!oparms->no_replay && is_replayable_error(rc) &&
 	    smb2_should_replay(tcon, &retries, &cur_sleep))
 		goto replay_again;
 
+	if (!oparms->no_replay)
+		oparms->replay = replay;
 	return rc;
 }
 
-- 
2.56.0

