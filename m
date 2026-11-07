Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794024603;
	b=x2VSuSC6luYPVafpEu1m39xS0JgqArz4HlWRrzAgyoLjtYm6+WjOSrLRG8VEHKEmc/GS
	 hZd/uXy3ruQK9ozNlbwhrw1MVKcRkGU24lWgeKtgXgqveyk4ydI8gtP1qVYQFc30aHRVb
	 /jpt9yjoEXjhgCY76TrMxYttThuW3+FxKWssEwIa0FXswIpCBCy652dPGUWyHfckJbIiq
	 WnbFKpK07asf37QsVVRsXRUhUO6bmihraU1OQhWEtfDvloPQcn4m6KOL5DI1hVYWBdEBX
	 o4tRDHuC/E2Nr/nERneK2QvwJ0Hq6r9NvvGDQRZtKDlls3iMdcM2tbQFZDa6e7PxEGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794024603;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5ix3ncGC6XxOL1C54SKvCDIqL28OmH9FLsnrVM6k+9Q=;
	b=jUr4r6L9E1+3CWReVlic//gbJP9RszloUweuQtGtGHwfIsH7P8Vy9Bd4JahOVWr6kokB
	 e79jCyUMndbaDGUGbVZ4j3oR3/JHZXihSp271qYH3SshL9wIAxbcFYBnTaiYaS6wJ0Jxl
	 3NoorqAXxgUMjzK9rSfGYGdEiSppI02JtSWRh1tQiw/m8ScPNEjPc5KvQgzr7iSMRC4ae
	 MTpv0aS2oAe7uQsmK0e/MqjY+eDX8ol8s1CJb5kaovFjJOh2AjH2Vly3x4BPGuPbUd3Mb
	 xQp86GV8T6gSqem6En/hfkZmrUi/wYAQSERZn0GnVCQ4NWcl8suDQljFKYpRPVyhLPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=sAgmD7cv;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD1D606D809;
	Sat,  7 Nov 2026 04:09:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CD1D606D809
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=sAgmD7cv
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=5ix3ncGC6XxOL1C54SKvCDIqL28OmH9FLsnrVM6k+9Q=; b=sAgmD7cvSr3ybBmLADod4pIFQ8
	7iSgVkc0j+Zb8wWc97xNvfgL2AYr+A4N+7cPlhxB57R9vbgp0e+6NtX288Ukl8UpC6up0j0fd3rlK
	rMoTDxdbWddmK+EYMaVXbFDcC7DyRumEV6+b5wVhoz7DlqXJM9HTfDDXJK6/WBtsS3mXdCT6KmkSI
	bE8aPEQ8QeheyYui+CuIXofp7WczVWsHwwslixVvh4TP9vtLNPgLdHOh/ErxDZGFKMXFI4S0rk1cg
	O4VKe97YRfUGK+UXYMcOSNm03tDFFTqOuHZMAAWPTwJlNiosfaIyEV8T/FOmjCmDwBz1OwHS9n5is
	evXSgByw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPXkP-000000015OX-3fXh;
	Sat, 07 Nov 2026 01:09:47 -0300
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
Subject: [PATCH v8 17/19] smb: client: don't replay handle reopens inside SMB2_open()
Date: Sat,  7 Nov 2026 01:09:38 -0300
Message-ID: <20261107040940.2692656-18-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107040940.2692656-1-pc@manguebit.org>
References: <20261107040940.2692656-1-pc@manguebit.org>
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
 fs/smb/client/file.c     | 42 +++++++++++++++++++++++++++++++---------
 fs/smb/client/smb2file.c | 15 ++++++++++----
 fs/smb/client/smb2pdu.c  | 29 ++++++++++++++++++++++++---
 4 files changed, 75 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index fe64abdfd740..8e5495c172c6 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1409,6 +1409,8 @@ struct cifs_open_parms {
 	umode_t mode;
 	bool reconnect:1;
 	bool replay:1; /* indicates that this open is for a replay */
+	bool no_replay:1; /* don't replay this open internally */
+	bool pending:1; /* in/out: last built create had no answer */
 	struct kvec *ea_cctx;
 	__le32 lease_flags;
 };
@@ -1461,6 +1463,9 @@ struct cifsFileInfo {
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
index 904df549a884..ff950f11de22 100644
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
@@ -1570,6 +1574,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	int create_options = CREATE_NOT_DIR;
 	struct cifs_open_parms oparms;
 	int rdwr_for_fscache = 0;
+	bool fresh;
 
 	xid = get_xid();
 	mutex_lock(&cfile->fh_mutex);
@@ -1640,11 +1645,17 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	desired_access = cifs_convert_flags(cfile->f_flags, rdwr_for_fscache);
 	create_options |= cifs_open_create_options(cfile->f_flags,
 						   create_options);
+	if (cfile->reopen_replay) {
+		desired_access = cfile->reopen_access;
+		if (rdwr_for_fscache == 1 && !(desired_access & GENERIC_READ))
+			rdwr_for_fscache = 2;
+	}
 
 	if (server->ops->get_lease_key)
 		server->ops->get_lease_key(inode, &cfile->fid);
 
 retry_open:
+	fresh = cfile->reopen_fresh;
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
 		.cifs_sb = cifs_sb,
@@ -1653,7 +1664,10 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
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
@@ -1664,12 +1678,21 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	 * not dirty locally we could do this.
 	 */
 	rc = server->ops->open(xid, &oparms, &oplock, NULL);
-	if (rc == -ENOENT && oparms.reconnect == false) {
+	if (rc == -ENOENT && !fresh && !oparms.reconnect) {
 		/* durable handle timeout is expired - open the file again */
+		fresh = true;
+		oparms.desired_access = desired_access;
+		oparms.replay = false;
+		oparms.pending = false;
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
 	if (rc == -EACCES && rdwr_for_fscache == 1) {
 		desired_access = cifs_convert_flags(cfile->f_flags, 0);
 		rdwr_for_fscache = 2;
@@ -1850,7 +1873,8 @@ cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 	spin_unlock(&tcon->open_file_lock);
 
 	list_for_each_entry_safe(open_file, tmp, &tmp_list, rlist) {
-		if (cifs_reopen_file(open_file, false /* do not flush */))
+		/* do not flush */
+		if (cifs_reopen_file(open_file, false, 0))
 			tcon->need_reopen_files = true;
 		list_del_init(&open_file->rlist);
 		cifsFileInfo_put(open_file);
@@ -3080,7 +3104,7 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 			*ret_file = inv_file;
 			return 0;
 		}
-		rc = cifs_reopen_file(inv_file, false);
+		rc = cifs_reopen_file(inv_file, false, 0);
 		if (!rc) {
 			*ret_file = inv_file;
 			return 0;
diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index fb2fccbe8667..d46a0b198a19 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -175,6 +175,7 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 	struct cifs_fid *fid = oparms->fid;
 	struct network_resiliency_req nr_ioctl_req;
 	bool retry_without_read_attributes = false;
+	bool reconnect = oparms->reconnect;
 
 	smb2_path = cifs_convert_path_to_utf16(oparms->path, oparms->cifs_sb);
 	if (smb2_path == NULL)
@@ -186,13 +187,17 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
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
 
@@ -203,6 +208,8 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 		memset(&err_iov, 0, sizeof(err_iov));
 		err_buftype = CIFS_NO_BUFFER;
 		oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
+		oparms->reconnect = reconnect;
+		oparms->replay = false;
 		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data, NULL, &err_iov,
 			       &err_buftype);
 	}
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index b603e937d1a8..c18912693895 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3332,14 +3332,25 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	int flags = 0;
 	int retries = 0, cur_sleep = 0;
 	struct smb2_file_all_info *file_info = buf ? &buf->fi : NULL;
+	bool reconnect = oparms->reconnect;
+	bool replay = oparms->replay;
+	bool built = false;
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
+		oparms->replay = replay || built;
 
 	cifs_dbg(FYI, "create/open\n");
 	if (!ses || !server)
@@ -3357,11 +3368,13 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 			    &rqst, oplock, oparms, path);
 	if (rc)
 		goto creat_exit;
+	built = true;
+	sent = true;
 
 	trace_smb3_open_enter(xid, tcon->tid, tcon->ses->Suid, oparms->path,
 		oparms->create_options, oparms->desired_access);
 
-	if (retries) {
+	if (oparms->replay) {
 		/* Back-off before retry */
 		if (cur_sleep)
 			msleep(cur_sleep);
@@ -3372,6 +3385,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 			    &rqst, &resp_buftype, flags,
 			    &rsp_iov);
 	rsp = (struct smb2_create_rsp *)rsp_iov.iov_base;
+	answered = rsp;
 
 	if (rc != 0) {
 		cifs_stats_fail_inc(tcon, SMB2_CREATE_HE);
@@ -3428,10 +3442,19 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	SMB2_open_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
 
-	if (is_replayable_error(rc) &&
+	if (sent) {
+		if (!rc || answered)
+			oparms->pending = false;
+		else if (!is_interrupt_error(rc))
+			oparms->pending = true;
+	}
+
+	if (!oparms->no_replay && is_replayable_error(rc) &&
 	    smb2_should_replay(tcon, &retries, &cur_sleep))
 		goto replay_again;
 
+	if (!oparms->no_replay)
+		oparms->replay = replay;
 	return rc;
 }
 
-- 
2.56.0

