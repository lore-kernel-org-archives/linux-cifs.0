Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793746828;
	b=W18qeb7HeFNnHhu1z7m/SCuexQ7Err5PtSOKd5XV7WD3b2iLTiHOzHEZrVdmpwuJUj/1
	 wXHKckueJxKDKiQdFSypLTL/IeryE+x1DSQi2l/0P61wTy2dyRddw7viMNSuzmkqm5t9A
	 Wb4zsIwy/Ww0tmvT8AuQE9c+OGEfeyQBsj/m5DyWiVHiHnP9+7bSjpqT2Ge9mxNcZPUj0
	 eYh2Bw66SXQS++Gdp7nArRjHhpqm4uxNsJHyeA1HWoenHj+VTcVR5ENAt8t7+c0Op1uEC
	 le/uP1Aa5iEoo0+wuy5TtIkg1Nn1ljK36VeIfUma7rl1qgac8b0+/h9DjreqSC204ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793746828;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ka5x2QBuVnEdliailcdW5tRZzsBBtIWXbt9EOdqEAnk=;
	b=SIBvERi+FfZoGr8TcjZc0UJCfnp9CfARoa9HCSsQbUnCf+1HQUergdOg6i7Z1KlYKrtz
	 rsETb5+c2UR5k+Si1Ix9uhB+o0Bzl6qgSEDBVaI8owGAkmMY0ZAZ8YnS+Zlpq/2YwJV8+
	 raY3HYtzBPTKVORGTdllWjdoUmewljz4GiotiZXsZRO2Cajb3CF/uNKdOmhfkljc2y1dv
	 d0tmcufyqVUCZBzKXJu7khBPm0vqeGUcNxGHYCvh7ycZR0/ViseJ+Hu81SUBkg9TRlJ0C
	 uugC4IO0zsltia1g+4BGFldw03qWOkHZkNzV2y7b7bd1qmGrGe5QkeSyDwjLscNTroA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Y6dMDDzd;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE65606A337;
	Tue,  3 Nov 2026 23:00:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BE65606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Y6dMDDzd
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=ka5x2QBuVnEdliailcdW5tRZzsBBtIWXbt9EOdqEAnk=; b=Y6dMDDzdlJo1d0p0Y14VA0C34j
	6r46mHAFjgGos6e7zATaYFqhVxCFhiTyCi+Noe2L1v33zNmVwEzDhzCO2C0k0I6pqgI14J3iftLK3
	P2Fsc8xPAaixRq3TIUwJuCWcsOoWv37H675E1CSQWFfJL48d3Bn0KSPHUvVDvPslFl9aXWJPHnPge
	gBpfGjSi1EWArXKg10cBA/AXpnskb+h4neLyy01S7411iCoolxX2zdwajj/B2yDysTTXaSH738nvb
	iR8kTOFsidiYfcyWIEtOnbEx1LdQvoWfHchINqXp0G9I8FHeqipTMHvn/kRyutFVOP52VLTPYTnfL
	CC4unJNw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xONUO-00000000kP5-3YbA;
	Tue, 03 Nov 2026 20:00:26 -0300
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
Subject: [PATCH v3 16/16] smb: client: fail writeback sends and reopens fast when the server is gone
Date: Tue,  3 Nov 2026 20:00:20 -0300
Message-ID: <20261103230020.1617748-17-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103230020.1617748-1-pc@manguebit.org>
References: <20261103230020.1617748-1-pc@manguebit.org>
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

A writeback whose send or handle reopen finds the server needing
reconnect waits in smb2_reconnect() -> cifs_wait_for_server_reconnect()
for the reconnect to finish - on a hard mount until the server returns or
umount -f.  But umount -f only breaks that wait for a request that entered
it before the abort count was bumped; a send or reopen that enters
afterwards, including the writeback that generic_shutdown_super() ->
sync_filesystem() starts during the unmount itself, snapshots the
already-bumped count and waits forever, hanging the unmount.

Issue writeback sends and reopens without waiting for the reconnect: pass
a nowait flag down to smb2_reconnect() and have it return -EAGAIN from
every point it would otherwise wait in or loop back to
cifs_wait_for_server_reconnect() - the initial need-reconnect check, the
wait itself, a need-reconnect seen after taking the session mutex, and a
failed renegotiation - not just the first.  The subrequest is then
retried from the netfs collector, which backs off and re-checks umount -f
and the retry window before trying again.  Reads, direct writes and every
other command keep waiting as before.

Fixes: 3ee1a1fc3981 ("cifs: Cut over to using netfslib")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsglob.h  |  1 +
 fs/smb/client/cifsproto.h |  3 ++-
 fs/smb/client/cifssmb.c   |  2 +-
 fs/smb/client/file.c      | 12 +++++----
 fs/smb/client/misc.c      |  7 +++++-
 fs/smb/client/smb2pdu.c   | 52 ++++++++++++++++++++++++++++++++-------
 6 files changed, 60 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index cfdb230beadc..755c87367e21 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1409,6 +1409,7 @@ struct cifs_open_parms {
 	bool reconnect:1;
 	bool replay:1; /* indicates that this open is for a replay */
 	bool no_replay:1; /* don't replay this open internally */
+	bool no_reconnect_wait:1; /* fail fast, don't wait for reconnect */
 	struct kvec *ea_cctx;
 	__le32 lease_flags;
 };
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 8b7914dd13af..935fb31912ac 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -443,7 +443,8 @@ static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
 }
 
 int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server,
-				   struct cifs_tcon *tcon, int aborts);
+				   struct cifs_tcon *tcon, int aborts,
+				   bool nowait);
 
 static inline void cifs_put_smb_ses(struct cifs_ses *ses)
 {
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 712086eb3d1f..68f05a52605f 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -105,7 +105,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	spin_unlock(&tcon->tc_lock);
 
 again:
-	rc = cifs_wait_for_server_reconnect(server, tcon, aborts);
+	rc = cifs_wait_for_server_reconnect(server, tcon, aborts, false);
 	if (rc)
 		return rc;
 
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 52c306de11b8..b260c70ea941 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -38,7 +38,7 @@
 #include <trace/events/netfs.h>
 
 static int cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush,
-			    bool no_replay);
+			    bool no_replay, bool nowait);
 
 bool cifs_io_stopped(struct cifs_io_subrequest *subreq)
 {
@@ -170,7 +170,7 @@ static int cifs_reopen_file_retry(struct cifsFileInfo *cfile, bool can_flush,
 			return -EIO;
 		retrying = true;
 		reconnects = cifs_ses_reconnects(ses);
-		rc = cifs_reopen_file(cfile, can_flush, true);
+		rc = cifs_reopen_file(cfile, can_flush, true, writeback);
 		if (!rc || is_interrupt_error(rc) ||
 		    cifs_writeback_dying(&subreq->subreq))
 			return rc;
@@ -1533,7 +1533,8 @@ cifs_relock_file(struct cifsFileInfo *cfile)
 }
 
 static int
-cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush, bool no_replay)
+cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush, bool no_replay,
+		 bool nowait)
 {
 	int rc = -EACCES;
 	unsigned int xid;
@@ -1635,6 +1636,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush, bool no_replay)
 		.fid = &cfile->fid,
 		.reconnect = true,
 		.no_replay = no_replay,
+		.no_reconnect_wait = nowait,
 	};
 
 	/*
@@ -1831,7 +1833,7 @@ cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 
 	list_for_each_entry_safe(open_file, tmp, &tmp_list, rlist) {
 		/* do not flush */
-		if (cifs_reopen_file(open_file, false, false))
+		if (cifs_reopen_file(open_file, false, false, false))
 			tcon->need_reopen_files = true;
 		list_del_init(&open_file->rlist);
 		cifsFileInfo_put(open_file);
@@ -3066,7 +3068,7 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 			*ret_file = inv_file;
 			return 0;
 		}
-		rc = cifs_reopen_file(inv_file, false, false);
+		rc = cifs_reopen_file(inv_file, false, false, false);
 		if (!rc) {
 			*ret_file = inv_file;
 			return 0;
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 13eb067ad88a..4a3ecf5c80f7 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1081,7 +1081,8 @@ static bool reco_wait_done(struct TCP_Server_Info *server,
 }
 
 int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server,
-				   struct cifs_tcon *tcon, int aborts)
+				   struct cifs_tcon *tcon, int aborts,
+				   bool nowait)
 {
 	int timeout = 10;
 	int rc;
@@ -1091,6 +1092,10 @@ int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server,
 		spin_unlock(&server->srv_lock);
 		return 0;
 	}
+	if (nowait) {
+		spin_unlock(&server->srv_lock);
+		return -EAGAIN;
+	}
 	timeout *= server->nr_targets;
 	spin_unlock(&server->srv_lock);
 
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index c9380aedc1fd..cc81ef79a8e4 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -248,7 +248,8 @@ int smb3_update_ses_channels(struct cifs_ses *ses, struct TCP_Server_Info *serve
 
 static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
-	       struct TCP_Server_Info *server, bool from_reconnect)
+	       struct TCP_Server_Info *server, bool from_reconnect,
+	       bool nowait)
 {
 	struct cifs_ses *ses;
 	int aborts;
@@ -311,6 +312,10 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 			spin_unlock(&server->srv_lock);
 			return -EAGAIN;
 		}
+		if (nowait) {
+			spin_unlock(&server->srv_lock);
+			return -EAGAIN;
+		}
 	}
 
 	/* if server is marked for termination, cifsd will cleanup */
@@ -321,7 +326,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	spin_unlock(&server->srv_lock);
 
 again:
-	rc = cifs_wait_for_server_reconnect(server, tcon, aborts);
+	rc = cifs_wait_for_server_reconnect(server, tcon, aborts, nowait);
 	if (rc)
 		return rc;
 
@@ -349,6 +354,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	case CifsNeedReconnect:
 		spin_unlock(&server->srv_lock);
 		mutex_unlock(&ses->session_mutex);
+		if (nowait)
+			return -EAGAIN;
 		if (!cifs_tcon_retry(tcon, aborts))
 			return -EHOSTDOWN;
 		goto again;
@@ -380,6 +387,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	rc = cifs_negotiate_protocol(0, ses, server);
 	if (rc) {
 		mutex_unlock(&ses->session_mutex);
+		if (nowait)
+			return -EAGAIN;
 		if (!cifs_tcon_retry(tcon, aborts))
 			return -EHOSTDOWN;
 		goto again;
@@ -592,7 +601,22 @@ static int smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
 {
 	int rc;
 
-	rc = smb2_reconnect(smb2_command, tcon, server, false);
+	rc = smb2_reconnect(smb2_command, tcon, server, false, false);
+	if (rc)
+		return rc;
+
+	return __smb2_plain_req_init(smb2_command, tcon, server, request_buf,
+				     total_len);
+}
+
+/* As smb2_plain_req_init(), but fail fast instead of waiting for reconnect. */
+static int smb2_io_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
+			    struct TCP_Server_Info *server,
+			    void **request_buf, unsigned int *total_len)
+{
+	int rc;
+
+	rc = smb2_reconnect(smb2_command, tcon, server, false, true);
 	if (rc)
 		return rc;
 
@@ -3147,8 +3171,12 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	__le16 *copy_path;
 	int rc;
 
-	rc = smb2_plain_req_init(SMB2_CREATE, tcon, server,
-				 (void **) &req, &total_len);
+	if (oparms->no_reconnect_wait)
+		rc = smb2_io_req_init(SMB2_CREATE, tcon, server,
+				      (void **) &req, &total_len);
+	else
+		rc = smb2_plain_req_init(SMB2_CREATE, tcon, server,
+					 (void **) &req, &total_len);
 	if (rc)
 		return rc;
 
@@ -4357,7 +4385,8 @@ void smb2_reconnect_server(struct work_struct *work)
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist) {
-		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true);
+		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true,
+				    false);
 		if (!rc) {
 			cifs_renegotiate_iosize(server, tcon);
 			cifs_reopen_persistent_handles(tcon);
@@ -4389,7 +4418,8 @@ void smb2_reconnect_server(struct work_struct *work)
 	/* now reconnect sessions for necessary channels */
 	list_for_each_entry_safe(ses, ses2, &tmp_ses_list, rlist) {
 		tcon->ses = ses;
-		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true);
+		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true,
+				    false);
 		if (rc)
 			resched = true;
 		list_del_init(&ses->rlist);
@@ -5206,8 +5236,12 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 	};
 	io_parms = &_io_parms;
 
-	rc = smb2_plain_req_init(SMB2_WRITE, tcon, server,
-				 (void **) &req, &total_len);
+	if (wdata->subreq.rreq->origin == NETFS_WRITEBACK)
+		rc = smb2_io_req_init(SMB2_WRITE, tcon, server,
+				      (void **) &req, &total_len);
+	else
+		rc = smb2_plain_req_init(SMB2_WRITE, tcon, server,
+					 (void **) &req, &total_len);
 	if (rc)
 		goto out;
 
-- 
2.56.0

