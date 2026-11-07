Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794071594;
	b=xnhU3mn3Ck/4uMuoTCo8qNKzlrR+1eJLP+NpCwCdmOjz0DM8QPf4amc7V+KcP2UlNLdR
	 8pi594DZqgt/8s/EyfRIA3Qh00DwfYaNPdH5C2PcJtYVMLWr6kuNmlRyQeW5Sp8ICyEAr
	 LzoZMAxor0rRr4lIfUwON3cJEZw1D9XQASUp+2b5pokwR8T6c0Q8EMWsYsxrTj8eBiONK
	 sn+HgfswydBqY1znZ44kqYo3ORRsTOckfbLK/xuqupe1y5TDKakGW2Oc+xUtawuVGJAz4
	 hRwRI7rU1DASTyDlgRK9FxIgtMHCndoBTglvE36L3yk8ySzb5akvvZZJ7uQLZv0UDfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794071594;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XKQ3juA/LGegYqN8OXnW9pmXqk0JtD0wYO0wrNDiOvU=;
	b=rvHEqOn9ahxuBow/iSSnI4syf674P9XCFncJ+JeNSyRsAwT0Bae0qGDgx9ax6+qNKRME
	 85IVX11kxyLNADny19YIgc0UwPRk6w/U14N8oyQuHpCAjdFZV0zP5ERSJFBqTVCfIm2OS
	 Nved4pMvdd/f8octpHHkrHb/x1kDDcQnn5c9wz6pztfWrF/FkqIF7kC9mdc16JhnDqZbH
	 N2Mz0WosQn9O+cuyHFF8Q8CUepuAp1M+0Iy7wG342TXiP2y52A9VemGXrOz9hSxhJhMaP
	 xuzFFZcpZeA7nHz32XxxmwSUNiMwn+jTC9085JMWryKYNmeR5+5YagsTuPKgwtm8VIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=gsBJsofa;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D55606EE96;
	Sat,  7 Nov 2026 17:13:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3D55606EE96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=gsBJsofa
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=XKQ3juA/LGegYqN8OXnW9pmXqk0JtD0wYO0wrNDiOvU=; b=gsBJsofaDHvql+Zh8kpKHBK88x
	TuC1NdQoexT1Zqn3Hr12Olj0u5THC8s2VzlK6jhXSDWwBh/Jcn2xc+gGSsnMCj+N6CY6uhnl5oEAb
	e2s0Xlu5TY0h6T70c61UWw2+BZeieSbgb7qaX3xmqW1a74DJ4HJknv9WHPzwUqeq1C3irUEL02oBL
	b5Xci2ftqQs233L/TdtJfP9GfXLuRoYdqIwI4xY+Hc04X82wteVGY5d31zK6aadKet/b4yhTn4lYD
	TNOVTYZOUKfr7oQLD5eRWLO+pjA6mbKwwDxcpOMVAycHAgZfO4l+6E7OaryTsydpSYNM5WCvzoR/s
	YAEyb4hw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPjyY-000000017i9-1ARM;
	Sat, 07 Nov 2026 14:13:11 -0300
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
Subject: [PATCH v9 17/19] smb: client: don't replay handle reopens inside SMB2_open()
Date: Sat,  7 Nov 2026 14:13:03 -0300
Message-ID: <20261107171305.2847361-18-pc@manguebit.org>
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
its last create, with the same GUID and access and keeping its access
fallbacks, if that create may have been processed, or it leaks or loses
a handle.  Track both on the open
file under fh_mutex, so concurrent reopens agree: replay only after a
create that SMB2_open() built and that failed with no answer from the
server, and leave the state alone after an attempt that was interrupted
or never built.

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
 fs/smb/client/cifsglob.h |  5 +++++
 fs/smb/client/file.c     | 45 ++++++++++++++++++++++++++++++----------
 fs/smb/client/smb2file.c | 18 +++++++++++-----
 fs/smb/client/smb2pdu.c  | 37 +++++++++++++++++++++++++++++----
 4 files changed, 85 insertions(+), 20 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 78ab6abe5297..00a75bba42b0 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1410,6 +1410,8 @@ struct cifs_open_parms {
 	umode_t mode;
 	bool reconnect:1;
 	bool replay:1; /* indicates that this open is for a replay */
+	bool no_replay:1; /* don't replay this open internally */
+	bool pending:1; /* in/out: last built create had no answer */
 	struct kvec *ea_cctx;
 	__le32 lease_flags;
 };
@@ -1462,6 +1464,9 @@ struct cifsFileInfo {
 	spinlock_t file_info_lock; /* protects four flag/count fields above */
 	struct mutex fh_mutex; /* prevents reopen race after dead ses*/
 	unsigned int reopens;
+	bool reopen_fresh; /* durable handle gone: reopen opens afresh */
+	bool reopen_replay; /* reopen replays its last create */
+	int reopen_access; /* desired access of that create */
 	struct cifs_search_info srch_inf;
 	struct work_struct oplock_break; /* work for oplock breaks */
 	struct work_struct put; /* work for the final part of _put */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 7b8e1abd9b92..a9a47a45245b 100644
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
@@ -1563,7 +1567,7 @@ static bool reopen_aborted(struct cifs_tcon *tcon, int aborts)
 }
 
 static int
-cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
+cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush, unsigned int flags)
 {
 	int rc = -EACCES;
 	unsigned int xid;
@@ -1581,6 +1585,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	struct cifs_open_parms oparms;
 	int rdwr_for_fscache = 0;
 	int aborts;
+	bool fresh;
 
 	tcon = tlink_tcon(cfile->tlink);
 	aborts = atomic_read(&tcon->umount_aborts);
@@ -1654,6 +1659,10 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	if (cifs_fscache_enabled(inode) && (cfile->f_flags & O_ACCMODE) == O_WRONLY)
 		rdwr_for_fscache = 1;
 
+	if (cfile->reopen_replay && rdwr_for_fscache == 1 &&
+	    !(cfile->reopen_access & GENERIC_READ))
+		rdwr_for_fscache = 2;
+
 	desired_access = cifs_convert_flags(cfile->f_flags, rdwr_for_fscache);
 	create_options |= cifs_open_create_options(cfile->f_flags,
 						   create_options);
@@ -1662,15 +1671,20 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 		server->ops->get_lease_key(inode, &cfile->fid);
 
 retry_open:
+	fresh = cfile->reopen_fresh;
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
 		.cifs_sb = cifs_sb,
-		.desired_access = desired_access,
+		.desired_access = cfile->reopen_replay ?
+				  cfile->reopen_access : desired_access,
 		.create_options = cifs_create_options(cifs_sb, create_options),
 		.disposition = disposition,
 		.path = full_path,
 		.fid = &cfile->fid,
-		.reconnect = true,
+		.reconnect = !fresh,
+		.replay = cfile->reopen_replay,
+		.pending = cfile->reopen_replay,
+		.no_replay = !!(flags & CIFS_REOPEN_BOUND),
 	};
 
 	/*
@@ -1684,16 +1698,24 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 		rc = -EHOSTDOWN;
 	else
 		rc = server->ops->open(xid, &oparms, &oplock, NULL);
-	if (rc == -ENOENT && oparms.reconnect == false) {
+	if (rc == -ENOENT && !fresh && !oparms.reconnect && !oparms.pending) {
 		/* durable handle timeout is expired - open the file again */
+		fresh = true;
+		oparms.desired_access = desired_access;
+		oparms.replay = false;
 		if (reopen_aborted(tcon, aborts))
 			rc = -EHOSTDOWN;
 		else
 			rc = server->ops->open(xid, &oparms, &oplock, NULL);
-		/* indicate that we need to relock the file */
+	}
+	cfile->reopen_fresh = rc && fresh;
+	cfile->reopen_replay = rc && oparms.pending;
+	if (cfile->reopen_replay)
+		cfile->reopen_access = oparms.desired_access;
+	/* indicate that we need to relock the file */
+	if (fresh)
 		oparms.reconnect = true;
-	}
-	if (rc == -EACCES && rdwr_for_fscache == 1) {
+	if (rc == -EACCES && rdwr_for_fscache == 1 && !oparms.pending) {
 		desired_access = cifs_convert_flags(cfile->f_flags, 0);
 		rdwr_for_fscache = 2;
 		goto retry_open;
@@ -1873,7 +1895,8 @@ cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 	spin_unlock(&tcon->open_file_lock);
 
 	list_for_each_entry_safe(open_file, tmp, &tmp_list, rlist) {
-		if (cifs_reopen_file(open_file, false /* do not flush */))
+		/* do not flush */
+		if (cifs_reopen_file(open_file, false, 0))
 			tcon->need_reopen_files = true;
 		list_del_init(&open_file->rlist);
 		cifsFileInfo_put(open_file);
@@ -3103,7 +3126,7 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 			*ret_file = inv_file;
 			return 0;
 		}
-		rc = cifs_reopen_file(inv_file, false);
+		rc = cifs_reopen_file(inv_file, false, 0);
 		if (!rc) {
 			*ret_file = inv_file;
 			return 0;
diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index fb2fccbe8667..764cfd894ad0 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -175,6 +175,7 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 	struct cifs_fid *fid = oparms->fid;
 	struct network_resiliency_req nr_ioctl_req;
 	bool retry_without_read_attributes = false;
+	bool reconnect = oparms->reconnect;
 
 	smb2_path = cifs_convert_path_to_utf16(oparms->path, oparms->cifs_sb);
 	if (smb2_path == NULL)
@@ -186,23 +187,30 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 	 * FILE_READ_ATTRIBUTES when not needed and prevent calling code path
 	 * for retry_without_read_attributes.
 	 */
-	if (!(oparms->desired_access & FILE_READ_ATTRIBUTES) &&
-	    !(oparms->desired_access & GENERIC_READ) &&
+	if (!(oparms->desired_access & GENERIC_READ) &&
 	    !(oparms->desired_access & GENERIC_EXECUTE) &&
 	    !(oparms->desired_access & GENERIC_ALL) &&
 	    !(oparms->desired_access & MAXIMUM_ALLOWED)) {
-		oparms->desired_access |= FILE_READ_ATTRIBUTES;
-		retry_without_read_attributes = true;
+		if (oparms->replay) {
+			retry_without_read_attributes =
+				oparms->desired_access & FILE_READ_ATTRIBUTES;
+		} else if (!(oparms->desired_access & FILE_READ_ATTRIBUTES)) {
+			oparms->desired_access |= FILE_READ_ATTRIBUTES;
+			retry_without_read_attributes = true;
+		}
 	}
 	smb2_oplock = SMB2_OPLOCK_LEVEL_BATCH;
 
 	rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data, NULL, &err_iov,
 		       &err_buftype);
-	if (rc == -EACCES && retry_without_read_attributes) {
+	if (rc == -EACCES && retry_without_read_attributes &&
+	    !oparms->pending) {
 		free_rsp_buf(err_buftype, err_iov.iov_base);
 		memset(&err_iov, 0, sizeof(err_iov));
 		err_buftype = CIFS_NO_BUFFER;
 		oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
+		oparms->reconnect = reconnect;
+		oparms->replay = false;
 		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data, NULL, &err_iov,
 			       &err_buftype);
 	}
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index b603e937d1a8..d86ec1c75fbb 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3332,14 +3332,25 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	int flags = 0;
 	int retries = 0, cur_sleep = 0;
 	struct smb2_file_all_info *file_info = buf ? &buf->fi : NULL;
+	bool reconnect = oparms->reconnect;
+	bool replay = oparms->replay;
+	bool unanswered = replay;
+	bool answered;
+	bool sent;
 
 replay_again:
 	/* reinitialize for possible replay */
+	answered = false;
+	sent = false;
 	resp_buftype = CIFS_NO_BUFFER;
 	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
-	oparms->replay = !!(retries);
+	/* reissue the same create: a durable reconnect clears ->reconnect */
+	oparms->reconnect = reconnect;
+	/* with no_replay the caller owns oparms->replay */
+	if (!oparms->no_replay)
+		oparms->replay = unanswered;
 
 	cifs_dbg(FYI, "create/open\n");
 	if (!ses || !server)
@@ -3357,11 +3368,12 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 			    &rqst, oplock, oparms, path);
 	if (rc)
 		goto creat_exit;
+	sent = true;
 
 	trace_smb3_open_enter(xid, tcon->tid, tcon->ses->Suid, oparms->path,
 		oparms->create_options, oparms->desired_access);
 
-	if (retries) {
+	if (oparms->replay) {
 		/* Back-off before retry */
 		if (cur_sleep)
 			msleep(cur_sleep);
@@ -3372,6 +3384,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 			    &rqst, &resp_buftype, flags,
 			    &rsp_iov);
 	rsp = (struct smb2_create_rsp *)rsp_iov.iov_base;
+	answered = rsp;
 
 	if (rc != 0) {
 		cifs_stats_fail_inc(tcon, SMB2_CREATE_HE);
@@ -3428,10 +3441,26 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	SMB2_open_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
 
-	if (is_replayable_error(rc) &&
-	    smb2_should_replay(tcon, &retries, &cur_sleep))
+	if (sent) {
+		if (!rc || answered)
+			unanswered = false;
+		else if (!is_interrupt_error(rc))
+			unanswered = true;
+		oparms->pending = unanswered;
+	}
+
+	if (!oparms->no_replay && is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep)) {
+		if (err_iov && answered && !rsp) {
+			free_rsp_buf(*buftype, err_iov->iov_base);
+			*err_iov = (struct kvec){};
+			*buftype = CIFS_NO_BUFFER;
+		}
 		goto replay_again;
+	}
 
+	if (!oparms->no_replay)
+		oparms->replay = replay;
 	return rc;
 }
 
-- 
2.56.0

