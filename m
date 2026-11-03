Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793728988;
	b=p3dW16/rhpjB9vBRQXQkZ0yeln0eBvESRs9Aviepcg3BdPUfo5MW6PJiIvVbEqIQbKA8
	 gPXipZa07GDWSyczwqOXSKngjzUt299T2HQyQImINQlOTBoAsWhg6C8ZE/mD2rKHfK9WH
	 6NTGYnITNP1PGEMbrVE46Opas7I8l0qTvqV//+nOIAhANAaoNFqmnnBPMJORjjoDL2dgQ
	 TQgP2pnIepVpPAhf8Kk77FzI+lvACNCZh8TMu9SAGsLo7fF686lcrxTNUXB47aSKmIIFt
	 1N5n0ghiEiyHmJUAccs/jRD4eDMd5zYMRSkHqOdC+7UVlSgWr198hXHjd4xPSZYAwEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793728988;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SvtB7TEnajP2r58dKou9XtCVJ0BIUD+tuyN9AML2RcU=;
	b=tVQV5OTs7+Up3f4+MdoIHGalufdfYwOEf6dTuPKgXeA56nM8/mWvDF/UGR6myeBDHeF/
	 APQ8pxewQY5k0QsWcZwSjwx607IXMQZsKCxuDFM5CAFmNd5rJ4XvEL0rbQskuxY8h5k36
	 xQLGd2vwwx5n0onQo8IE/ld+dgdGUHpxU6fRw0ks/UVYOT6LcEtrOBsAY92jtNtkeGTjI
	 oKGyrtai6Zsb4S9h9WRNxRPppIDpY6TXRyQwh4/9XCXirIy3yIYeO/EKfILVYC5Ct9QRB
	 CNGFtZHMapnhKp7qh2qZaT6u/WJ1AASl/Ir2ZkEcA1BN6RwLjdPnQ7VH+6lHs4icK1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=OcuLvjQH;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50322606D82C;
	Tue,  3 Nov 2026 18:03:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50322606D82C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=OcuLvjQH
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=SvtB7TEnajP2r58dKou9XtCVJ0BIUD+tuyN9AML2RcU=; b=OcuLvjQHzgTZfF3aESf1cZmAeY
	b6YRVDrg31Emqc0lhtIT0hbuZgG9zs+YMK67TaMYQXFvuch4WY9FRnvqKOSUXIocQNiv3KJriVG5r
	khC93ukxNbGvqpKnnxbF+MxH6wWxbwfR2vIz0u7kT7mt3kvmvvOo3Lto2vTT0su7aQH6xlZe9Q9iP
	Ijzi+FnkSU6DH3xowXkMgsucEKkwn9yXbjE63JuSPWfB5iTZtuyPJKuWfdRH2QRlwDUl7jzc/TN8g
	LOUDulYD/BApu7qP/DWMpbhOnzM2AUsGZYKf/2ndRjktlMovQIRMfKwtkncX2jSYf+4tcTPZ8K5lF
	Ld1WglVQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xOIqa-00000000iwY-1DR7;
	Tue, 03 Nov 2026 15:03:01 -0300
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
Subject: [PATCH v2 16/16] smb: client: fail writeback sends and reopens fast when the server is gone
Date: Tue,  3 Nov 2026 15:02:55 -0300
Message-ID: <20261103180255.1482516-17-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103180255.1482516-1-pc@manguebit.org>
References: <20261103180255.1482516-1-pc@manguebit.org>
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

Issue writeback sends and reopens without waiting for the reconnect:
return -EAGAIN so the subrequest is retried from the netfs collector,
which backs off and re-checks umount -f and the retry window before
trying again.  Reads, direct writes and every other command keep waiting
as before.

Fixes: 3ee1a1fc3981 ("cifs: Cut over to using netfslib")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/file.c     | 12 ++++++-----
 fs/smb/client/smb2pdu.c  | 46 +++++++++++++++++++++++++++++++++-------
 3 files changed, 46 insertions(+), 13 deletions(-)

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
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 81988fdd29aa..53c43ead96bd 100644
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
 		if (!rc || is_interrupt_error(rc))
 			return rc;
 		if (!is_replayable_error(rc) &&
@@ -1521,7 +1521,8 @@ cifs_relock_file(struct cifsFileInfo *cfile)
 }
 
 static int
-cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush, bool no_replay)
+cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush, bool no_replay,
+		 bool nowait)
 {
 	int rc = -EACCES;
 	unsigned int xid;
@@ -1623,6 +1624,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush, bool no_replay)
 		.fid = &cfile->fid,
 		.reconnect = true,
 		.no_replay = no_replay,
+		.no_reconnect_wait = nowait,
 	};
 
 	/*
@@ -1819,7 +1821,7 @@ cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 
 	list_for_each_entry_safe(open_file, tmp, &tmp_list, rlist) {
 		/* do not flush */
-		if (cifs_reopen_file(open_file, false, false))
+		if (cifs_reopen_file(open_file, false, false, false))
 			tcon->need_reopen_files = true;
 		list_del_init(&open_file->rlist);
 		cifsFileInfo_put(open_file);
@@ -3051,7 +3053,7 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 			*ret_file = inv_file;
 			return 0;
 		}
-		rc = cifs_reopen_file(inv_file, false, false);
+		rc = cifs_reopen_file(inv_file, false, false, false);
 		if (!rc) {
 			*ret_file = inv_file;
 			return 0;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index c9380aedc1fd..718c367ba5ef 100644
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
@@ -592,7 +597,22 @@ static int smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
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
 
@@ -3147,8 +3167,12 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
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
 
@@ -4357,7 +4381,8 @@ void smb2_reconnect_server(struct work_struct *work)
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist) {
-		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true);
+		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true,
+				    false);
 		if (!rc) {
 			cifs_renegotiate_iosize(server, tcon);
 			cifs_reopen_persistent_handles(tcon);
@@ -4389,7 +4414,8 @@ void smb2_reconnect_server(struct work_struct *work)
 	/* now reconnect sessions for necessary channels */
 	list_for_each_entry_safe(ses, ses2, &tmp_ses_list, rlist) {
 		tcon->ses = ses;
-		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true);
+		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true,
+				    false);
 		if (rc)
 			resched = true;
 		list_del_init(&ses->rlist);
@@ -5206,8 +5232,12 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
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

