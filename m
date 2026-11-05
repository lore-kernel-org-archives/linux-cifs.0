Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793918744;
	b=O8gMNAn4WhJZQghPj+yHJO/ybOFdjPbYLj4oz3K1CSSWVoXbhy/AqB0jhsM/YBaAd94w
	 kqZDy6kgFvAbtorjN32FqBy/f4gGasmQm9hEfIsde9XWqRpDh1DQxUzhaTb8bh0u1ulYW
	 Q6+qosxePQ67j2jPDac+JyVKP4rWsL7uE6c1Rf5a9UCbg86Qe4nmyxScLgQMYFKbNnDfi
	 1lUhjJ+IjXGmRCwWoOnR45ewq6yRMHuJs9H5ZEbMO8oTOCetQQC/57ORMBfchTGVkGbEh
	 D/wvbg5LC5FbxOYEWQPOQiowYCw+26v3mdWgp2HcMJ6Q5O4PVeaItxyBtBgGBPOBf+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793918744;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=yGGriidRwRffEP9PVca7/4++D1BWGG2OcXgVUgJobbo=;
	b=4a0wYSaTeDB60/70fi1PnTD7nRkUJloMt5ktlIq8IWUgsWgRMH28XF+vTi0iD9LhFFP5
	 Vna4TpMGul3fHfPX6zIoPpXXXAjtZzAP57p52CMPdBg6CI5htjsiZxOAl1q3tCpKm1ar7
	 F7kLszIQ8E6HkBQoXby9BHdWKrU/c2FQPggVWNMmQUBiZHfPxiMO0q3vWSq+hZ0PqxCC3
	 kPDp+i0Rc9YOkC4C0tRcXlBS8Sq/pifon/Y5UHzSA4DAgnYD5CitZuDJNPA/9TgJLQa3v
	 /+hrq9zDF0Nk4lJyQPtdl90p4Lmglownud1ipDoH4XCeYUyy4P5c2JVzR0qAuHEAkFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=JwRRSEyv;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E24D606D828;
	Thu,  5 Nov 2026 22:45:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E24D606D828
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=JwRRSEyv
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=yGGriidRwRffEP9PVca7/4++D1BWGG2OcXgVUgJobbo=; b=JwRRSEyvibpHTOCGa/peLXV49E
	sAAsDlTdUuVCxy1gZoXEGW3Vq9dsTD5JWvwFDW82YCEqBqd0QXSuW0jjWERSvVtMfNx7CyX8uYIuC
	3qX1jfm9ow/ip/vNWKZefMo4ppcM3edGhkCcTOAHfjVKQ3NsQCJaVvMLSQDh6Jqc/DZXTUmiu9OPV
	p5zuCCfgoxpE0iDsh80Bfk+Al97FzfVqoSJark2SXatNcJCqFTutW0b6qVk0W2SpVZ89pcpa3Kfey
	Ppd365qQq4nz+uoyxZQ8/biUFVRJHtRveGQVhCcNWJncvSghCHG5Nm0AaWf718RLFylqSTVWavLlq
	9Oh0cOlg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xP6DA-00000000ypM-0VOQ;
	Thu, 05 Nov 2026 19:45:37 -0300
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
Subject: [PATCH v5 15/17] smb: client: don't replay handle reopens inside SMB2_open()
Date: Thu,  5 Nov 2026 19:45:29 -0300
Message-ID: <20261105224531.2316211-16-pc@manguebit.org>
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
the file afresh.  Without SMB2_open()'s loop, a retry must replay that
fresh open when its outcome is unknown, or it leaks a persistent handle
or sends a reconnect the server rejects.  Track this on the open file
under fh_mutex, so concurrent reopens agree.

SMB2_open()'s own loop and smb2_open_file()'s retry without
FILE_READ_ATTRIBUTES retried a failed durable reconnect as a fresh open
with a stale GUID; have both reissue the same create, and don't leave
SMB2_open()'s own replay state behind for the caller's next create.

Fixes: 69c3c023af25 ("cifs: Implement netfslib hooks")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsglob.h |  2 ++
 fs/smb/client/file.c     | 28 +++++++++++++++++++++-------
 fs/smb/client/smb2file.c |  2 ++
 fs/smb/client/smb2pdu.c  | 14 +++++++++++---
 4 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index fe64abdfd740..edc5a6ad03c6 100644
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
@@ -1461,6 +1462,7 @@ struct cifsFileInfo {
 	spinlock_t file_info_lock; /* protects four flag/count fields above */
 	struct mutex fh_mutex; /* prevents reopen race after dead ses*/
 	unsigned int reopens;
+	bool reopen_replay; /* reopen replays its last fresh open */
 	struct cifs_search_info srch_inf;
 	struct work_struct oplock_break; /* work for oplock breaks */
 	struct work_struct put; /* work for the final part of _put */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 39969cc7ec2f..d318f8202e2c 100644
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
@@ -173,7 +177,7 @@ static int cifs_reopen_file_retry(struct cifsFileInfo *cfile, bool can_flush,
 			return -EIO;
 		retrying = true;
 		reconnects = cifs_ses_reconnects(ses);
-		rc = cifs_reopen_file(cfile, can_flush);
+		rc = cifs_reopen_file(cfile, can_flush, CIFS_REOPEN_BOUND);
 		if (!rc || is_interrupt_error(rc) ||
 		    cifs_writeback_dying(&subreq->subreq))
 			return rc;
@@ -1549,7 +1553,7 @@ cifs_relock_file(struct cifsFileInfo *cfile)
 }
 
 static int
-cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
+cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush, unsigned int flags)
 {
 	int rc = -EACCES;
 	unsigned int xid;
@@ -1566,6 +1570,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	int create_options = CREATE_NOT_DIR;
 	struct cifs_open_parms oparms;
 	int rdwr_for_fscache = 0;
+	bool fresh;
 
 	xid = get_xid();
 	mutex_lock(&cfile->fh_mutex);
@@ -1641,6 +1646,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 		server->ops->get_lease_key(inode, &cfile->fid);
 
 retry_open:
+	fresh = cfile->reopen_replay;
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
 		.cifs_sb = cifs_sb,
@@ -1649,7 +1655,9 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 		.disposition = disposition,
 		.path = full_path,
 		.fid = &cfile->fid,
-		.reconnect = true,
+		.reconnect = !fresh,
+		.replay = fresh,
+		.no_replay = !!(flags & CIFS_REOPEN_BOUND),
 	};
 
 	/*
@@ -1660,9 +1668,14 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
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
+		cfile->reopen_replay = is_replayable_error(rc) ||
+				       is_interrupt_error(rc);
 		/* indicate that we need to relock the file */
 		oparms.reconnect = true;
 	}
@@ -1846,7 +1859,8 @@ cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 	spin_unlock(&tcon->open_file_lock);
 
 	list_for_each_entry_safe(open_file, tmp, &tmp_list, rlist) {
-		if (cifs_reopen_file(open_file, false /* do not flush */))
+		/* do not flush */
+		if (cifs_reopen_file(open_file, false, 0))
 			tcon->need_reopen_files = true;
 		list_del_init(&open_file->rlist);
 		cifsFileInfo_put(open_file);
@@ -3076,7 +3090,7 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
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
index e44ede13098b..6eefe91a0c9a 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3332,6 +3332,8 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	int flags = 0;
 	int retries = 0, cur_sleep = 0;
 	struct smb2_file_all_info *file_info = buf ? &buf->fi : NULL;
+	bool reconnect = oparms->reconnect;
+	bool replay = oparms->replay;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -3339,7 +3341,11 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
-	oparms->replay = !!(retries);
+	/* reissue the same create: a durable reconnect clears ->reconnect */
+	oparms->reconnect = reconnect;
+	/* with no_replay the caller owns oparms->replay */
+	if (!oparms->no_replay)
+		oparms->replay = replay || retries;
 
 	cifs_dbg(FYI, "create/open\n");
 	if (!ses || !server)
@@ -3361,7 +3367,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	trace_smb3_open_enter(xid, tcon->tid, tcon->ses->Suid, oparms->path,
 		oparms->create_options, oparms->desired_access);
 
-	if (retries) {
+	if (oparms->replay) {
 		/* Back-off before retry */
 		if (cur_sleep)
 			msleep(cur_sleep);
@@ -3428,10 +3434,12 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
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

