Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632538;
	b=kjyYW7COMbdSjjlTtBsUlZ3lEJDVQtqjMn5OuTeCCNxvo76gqndPKBHTbp59JrGCTwOI
	 /OrS5YRP9gnK4LJJfSbMxey2WSQXsdrghR2njmtR+5foTsDbuyk5XMHc1o9dM46D0AVjW
	 +dnrNLU6rl3nqP5kUC/rZB4ByjX5HbGSyN1nYtLGpbJW3ZKoNkRj8AF1/rV5xniWPQ1Pq
	 TtvRsozYZnxR1Lfj4VHHThpuAaF4lOsWNUj3+fMmDcPgQW9EPU8fHbp1jNeS/5BJtzZ5Z
	 yF0ZJTt+qmzgGg+SADz6buqGXigZobFV8OurMFZRMaCKc78Uz9IxIfdcMiD2ffurhAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632538;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lnBFlxzi6hrvmbObdd7uyK2F9E47eK/UE/E4PH8aRP0=;
	b=mJEtjnoLAtZF8o4i8zRClyTLDvR7GD1i+/21GOwo/j2qbAKiESSaU8S9effB+tUaqstl
	 Uq24Lbtf/jdpKjx+hfWjXIUw9Yi0JTAsOhPK14LL+pBgQL6U/QO2SDSvt8vI5PeO+UOjV
	 WOLabMNIls05gwUkkJbPdotEJ0qkGbqtl76ITtdD6FzmLckJnLjpL6ke1oxvTyIC3m0mH
	 rHK6qM4SpgLBn7VZp3Bkxd3coUkm+FPqS4L2hvBKBya0XRG3ScL6js6PDnpCKGQnT9ACD
	 6Z/xdzP1Mf3xi7JgAzEy5W+4Le6DtCLMp1AqM6t75+Idk4LoTnowsZjbIEqrv3S/bkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="JuQpn7/N";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FF2606A32D;
	Mon,  2 Nov 2026 15:15:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07FF2606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=JuQpn7/N
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=lnBFlxzi6hrvmbObdd7uyK2F9E47eK/UE/E4PH8aRP0=; b=JuQpn7/NwyuM3omOlLGr/UoI+3
	wcoadUi233vpvratJi/VRpwAzeX4mYCzoaoe2550WAItk5O1scgiQrvSqzW6K3+zXxBqiWHOcN5g2
	8xd0/P+Ph9QLvAGT0+/yz6ZC5XP0Qc9l5zf1SIXGPhmfcCA5JPtVvkQEM9O606aeCIhtaUDXhwyzL
	Et7nGqCyl+41Bt3XeoHjHRSosiLPZy0T6DDgiA+Iuj24AFq/SC1u8oN2kT3Cdoyb6K3QtUfpjcPN5
	OiTLi2FrWtert+GNS24ariBZUxqR7PHvJXB8FWig0cOzg482ndmkfOwV9dSS5fQAUeYX7ld227CIN
	5W4NHbmQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xNtkv-00000000aTN-3jUq;
	Mon, 02 Nov 2026 12:15:31 -0300
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
Subject: [PATCH 15/15] smb: client: let umount -f stop waiting for reconnects on hard mounts
Date: Mon,  2 Nov 2026 12:15:25 -0300
Message-ID: <20261102151525.925058-16-pc@manguebit.org>
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

Requests waiting in smb2_reconnect() or cifs_reconnect_tcon() for a
reconnect wait for as long as it takes on hard mounts.  With the server
gone, writeback stuck there keeps umount -f hanging in sync_filesystem()
while it waits for that writeback, even though retries of reads and
writes started before it now give up.

Count umount -f attempts per tcon and stop waiting for reconnects, as on
soft mounts, once one is made after the request started waiting, waking
up such requests on all channels right away.  As before, umount -f
leaves tcons shared with other mounts alone, and requests started after
it are unaffected.

Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsfs.c    | 19 ++++++++++++++++---
 fs/smb/client/cifsglob.h  |  6 ++++++
 fs/smb/client/cifsproto.h |  3 ++-
 fs/smb/client/cifssmb.c   |  9 ++++++---
 fs/smb/client/misc.c      | 16 +++++++++++++---
 fs/smb/client/smb2pdu.c   |  9 ++++++---
 6 files changed, 49 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index c90fb0cc0f0e..92355b9d4a83 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -828,6 +828,19 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	return 0;
 }
 
+static void wake_ses_waiters(struct cifs_ses *ses)
+{
+	guard(spinlock)(&ses->chan_lock);
+	for (size_t i = 0; i < ses->chan_count; i++) {
+		struct TCP_Server_Info *server = ses->chans[i].server;
+
+		if (!server)
+			continue;
+		wake_up_all(&server->request_q);
+		wake_up_all(&server->response_q);
+	}
+}
+
 static void cifs_umount_begin(struct super_block *sb)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
@@ -858,13 +871,13 @@ static void cifs_umount_begin(struct super_block *sb)
 	spin_unlock(&tcon->tc_lock);
 	spin_unlock(&cifs_tcp_ses_lock);
 
+	atomic_inc(&tcon->umount_aborts);
 	if (tcon->ses && tcon->ses->server) {
 		cifs_dbg(FYI, "wake up tasks now - umount begin not complete\n");
-		wake_up_all(&tcon->ses->server->request_q);
-		wake_up_all(&tcon->ses->server->response_q);
+		wake_ses_waiters(tcon->ses);
 		msleep(1); /* yield */
 		/* we have to kick the requests once more */
-		wake_up_all(&tcon->ses->server->response_q);
+		wake_ses_waiters(tcon->ses);
 		msleep(1);
 	}
 
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 0c27773e0838..60ead147f042 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1196,6 +1196,7 @@ struct cifs_tcon {
 	struct list_head tcon_list;
 	int debug_id;		/* Debugging for tracing */
 	int tc_count;
+	atomic_t umount_aborts;	/* nr of umount -f attempts */
 	struct list_head rlist; /* reconnect list */
 	spinlock_t tc_lock;  /* protect anything here that is not protected */
 	atomic_t num_local_opens;  /* num of all opens including disconnected */
@@ -2382,6 +2383,11 @@ static inline void cifs_reset_oplock(struct cifsInodeInfo *cinode)
 		WRITE_ONCE(cinode->oplock, 0);
 }
 
+static inline bool cifs_tcon_retry(struct cifs_tcon *tcon, int aborts)
+{
+	return tcon->retry && atomic_read(&tcon->umount_aborts) == aborts;
+}
+
 static inline bool cifs_forced_shutdown(const struct cifs_sb_info *sbi)
 {
 	return cifs_sb_flags(sbi) & CIFS_MOUNT_SHUTDOWN;
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index a37eee2ca54b..8b7914dd13af 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -442,7 +442,8 @@ static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
 		return options;
 }
 
-int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry);
+int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server,
+				   struct cifs_tcon *tcon, int aborts);
 
 static inline void cifs_put_smb_ses(struct cifs_ses *ses)
 {
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index fcf97b3d6bea..712086eb3d1f 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -73,6 +73,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 {
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
+	int aborts;
 	int rc;
 
 	/*
@@ -83,6 +84,8 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	if (!tcon)
 		return 0;
 
+	aborts = atomic_read(&tcon->umount_aborts);
+
 	ses = tcon->ses;
 	server = ses->server;
 
@@ -102,7 +105,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	spin_unlock(&tcon->tc_lock);
 
 again:
-	rc = cifs_wait_for_server_reconnect(server, tcon->retry);
+	rc = cifs_wait_for_server_reconnect(server, tcon, aborts);
 	if (rc)
 		return rc;
 
@@ -127,7 +130,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	case CifsNeedReconnect:
 		spin_unlock(&server->srv_lock);
 		mutex_unlock(&ses->session_mutex);
-		if (!tcon->retry)
+		if (!cifs_tcon_retry(tcon, aborts))
 			return -EHOSTDOWN;
 		goto again;
 	default:
@@ -159,7 +162,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	rc = cifs_negotiate_protocol(0, ses, server);
 	if (rc) {
 		mutex_unlock(&ses->session_mutex);
-		if (!tcon->retry)
+		if (!cifs_tcon_retry(tcon, aborts))
 			return -EHOSTDOWN;
 		goto again;
 	}
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index ec28f102ea08..13eb067ad88a 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1073,7 +1073,15 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
 }
 #endif
 
-int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
+static bool reco_wait_done(struct TCP_Server_Info *server,
+			   struct cifs_tcon *tcon, int aborts)
+{
+	return server->tcpStatus != CifsNeedReconnect ||
+		atomic_read(&tcon->umount_aborts) != aborts;
+}
+
+int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server,
+				   struct cifs_tcon *tcon, int aborts)
 {
 	int timeout = 10;
 	int rc;
@@ -1096,7 +1104,9 @@ int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
 	 */
 	do {
 		rc = wait_event_interruptible_timeout(server->response_q,
-						      (server->tcpStatus != CifsNeedReconnect),
+						      reco_wait_done(server,
+								     tcon,
+								     aborts),
 						      timeout * HZ);
 		if (rc < 0) {
 			cifs_dbg(FYI, "%s: aborting reconnect due to received signal\n",
@@ -1111,7 +1121,7 @@ int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
 			return 0;
 		}
 		spin_unlock(&server->srv_lock);
-	} while (retry);
+	} while (cifs_tcon_retry(tcon, aborts));
 
 	cifs_dbg(FYI, "%s: gave up waiting on reconnect\n", __func__);
 	return -EHOSTDOWN;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 29e60f827c84..33f8d0638a54 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -251,6 +251,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	       struct TCP_Server_Info *server, bool from_reconnect)
 {
 	struct cifs_ses *ses;
+	int aborts;
 	int xid;
 	int rc = 0;
 
@@ -262,6 +263,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	if (tcon == NULL)
 		return 0;
 
+	aborts = atomic_read(&tcon->umount_aborts);
+
 	if (smb2_command == SMB2_TREE_CONNECT)
 		return 0;
 
@@ -318,7 +321,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	spin_unlock(&server->srv_lock);
 
 again:
-	rc = cifs_wait_for_server_reconnect(server, tcon->retry);
+	rc = cifs_wait_for_server_reconnect(server, tcon, aborts);
 	if (rc)
 		return rc;
 
@@ -346,7 +349,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	case CifsNeedReconnect:
 		spin_unlock(&server->srv_lock);
 		mutex_unlock(&ses->session_mutex);
-		if (!tcon->retry)
+		if (!cifs_tcon_retry(tcon, aborts))
 			return -EHOSTDOWN;
 		goto again;
 	default:
@@ -377,7 +380,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	rc = cifs_negotiate_protocol(0, ses, server);
 	if (rc) {
 		mutex_unlock(&ses->session_mutex);
-		if (!tcon->retry)
+		if (!cifs_tcon_retry(tcon, aborts))
 			return -EHOSTDOWN;
 		goto again;
 	}
-- 
2.56.0

