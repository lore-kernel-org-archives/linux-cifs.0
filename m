Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30B3192B62;
	Sun, 22 Dec 2024 16:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734885098; cv=none; b=dgfGEFr28SodvJkoUVe020ATJvVteFXvvavtvSSMpOWmTeJeNQvdtoesC0MIL/KH2diyOTmbKBMNXdnLMhlaWzNFsJjTV6cr12JHhQfWNaimYLDit1kPKhOdiMrpTnxQFYhNB18m3JmSqgjEMbSM53y1hOhLQRneS7+aXt8Dr6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734885098; c=relaxed/simple;
	bh=kCnrqYnrhXWoZnzA9iIB4hqNpNg9Ig0gbeOajZtaOkI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y8tInnYI6LbmS2qMUz7mEFx8rE/xvP4tmpHNjLhK1adhgPO3Ot8OBBI5kWYl8vZJQZSeCKZQVcHgPR23Yp24IpKSPS560Kw8cLd8+BleIyrgdA0a2m4BDyVzLSwSjVTKEyGWD/8lP2FlruuzJT6DdJA3jciCTziWy4QEDLnS7Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lboOst4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lboOst4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1FEC4CED3;
	Sun, 22 Dec 2024 16:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734885098;
	bh=kCnrqYnrhXWoZnzA9iIB4hqNpNg9Ig0gbeOajZtaOkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lboOst4/B9dHFIu83MRV6lfnPQ3M4QofV0kUPmoFxD0ZGj+oDpdBitYXWZuC2p/ku
	 G3Uop7daby6NGiFyrvZB4FURSQOH8fJKz6eq07LftAVBKiPBThRbq835gCWxASZI/z
	 fZVbqyZk/1LzYLefPqk6lT+j4ICueet1mDgQD3IgTQ9pklExEtsTVacN0gyL8zuonL
	 UShUPybQtNFn1kk05NjwWQUMN4gEzEoKX+nREZUbcaOOL65pKhSMGP/LeNyyfP0LJj
	 e2dTHnY6RqXIzSL4U38l+4hVqnrRh8l7eFrOshksc3c9NGFf6A6TZ2rE2TPZQsFQLC
	 o5fOb/zSRT4CQ==
Received: by pali.im (Postfix)
	id 86313EEC; Sun, 22 Dec 2024 17:31:27 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] cifs: Improve handling of NetBIOS packets
Date: Sun, 22 Dec 2024 17:30:48 +0100
Message-Id: <20241222163050.24359-5-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222163050.24359-1-pali@kernel.org>
References: <20241222163050.24359-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Now all NetBIOS session logic is handled in ip_rfc1001_connect() function,
so cleanup is_smb_response() function which contains generic handling of
incoming SMB packets. Note that function is_smb_response() is not used
directly or indirectly (e.g. over cifs_demultiplex_thread() by
ip_rfc1001_connect() function.

Except the Negative Session Response and the Session Keep Alive packet, the
cifs_demultiplex_thread() should not receive any NetBIOS session packets.
And Session Keep Alive packet may be received only when the NetBIOS session
was established by ip_rfc1001_connect() function. So treat any such packet
as error and schedule reconnect.

Negative Session Response packet is returned from Windows SMB server (from
Windows 98 and also from Windows Server 2022) if client sent over port 139
SMB negotiate request without previously establishing a NetBIOS session.
The common scenario is that Negative Session Response packet is returned
for the SMB negotiate packet, which is the first one which SMB client
sends (if it is not establishing a NetBIOS session).

Note that server port 139 may be forwarded and mapped between virtual
machines to different number. And Linux SMB client do not call function
ip_rfc1001_connect() when prot is not 139. So nowadays when using port
mapping or port forwarding between VMs, it is not so uncommon to see this
error.

Currently the logic on Negative Session Response packet changes server port
to 445 and force reconnection. But this logic does not work when using
non-standard port numbers and also does not help if the server on specified
port is requiring establishing a NetBIOS session.

Fix this Negative Session Response logic and instead of changing server
port (on which server does not have to listen), force reconnection with
establishing a NetBIOS session.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h  |   3 +
 fs/smb/client/connect.c   | 140 +++++++++++++++++++++++++++++++++-----
 fs/smb/client/transport.c |   3 +
 3 files changed, 128 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index bea4b8a8b30e..b56fca6dd195 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -717,6 +717,7 @@ struct TCP_Server_Info {
 	__u64 conn_id; /* connection identifier (useful for debugging) */
 	int srv_count; /* reference counter */
 	int rfc1001_sessinit; /* whether to estasblish netbios session */
+	bool with_rfc1001; /* if netbios session is used */
 	/* 15 character server name + 0x20 16th byte indicating type = srv */
 	char server_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
 	struct smb_version_operations	*ops;
@@ -1728,6 +1729,7 @@ struct mid_q_entry {
 	void *resp_buf;		/* pointer to received SMB header */
 	unsigned int resp_buf_size;
 	int mid_state;	/* wish this were enum but can not pass to wait_event */
+	int mid_rc;		/* rc for MID_RC */
 	unsigned int mid_flags;
 	__le16 command;		/* smb command code */
 	unsigned int optype;	/* operation type */
@@ -1890,6 +1892,7 @@ static inline bool is_replayable_error(int error)
 #define   MID_RESPONSE_MALFORMED 0x10
 #define   MID_SHUTDOWN		 0x20
 #define   MID_RESPONSE_READY 0x40 /* ready for other process handle the rsp */
+#define   MID_RC             0x80 /* mid_rc contains custom rc */
 
 /* Flags */
 #define   MID_WAIT_CANCELLED	 1 /* Cancelled while waiting for response */
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index ac2e5e1d23b1..9a76cdf71086 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -386,7 +386,7 @@ static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num
  *
  */
 static int __cifs_reconnect(struct TCP_Server_Info *server,
-			    bool mark_smb_session)
+			    bool mark_smb_session, bool once)
 {
 	int rc = 0;
 
@@ -414,6 +414,9 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
 		if (rc) {
 			cifs_server_unlock(server);
 			cifs_dbg(FYI, "%s: reconnect error %d\n", __func__, rc);
+			/* If was asked to reconnect only once, do not try it more times */
+			if (once)
+				break;
 			msleep(3000);
 		} else {
 			atomic_inc(&tcpSesReconnectCount);
@@ -573,24 +576,38 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
 	return rc;
 }
 
-int cifs_reconnect(struct TCP_Server_Info *server, bool mark_smb_session)
+static int
+_cifs_reconnect(struct TCP_Server_Info *server, bool mark_smb_session, bool once)
 {
 	mutex_lock(&server->refpath_lock);
 	if (!server->leaf_fullpath) {
 		mutex_unlock(&server->refpath_lock);
-		return __cifs_reconnect(server, mark_smb_session);
+		return __cifs_reconnect(server, mark_smb_session, once);
 	}
 	mutex_unlock(&server->refpath_lock);
 
 	return reconnect_dfs_server(server);
 }
 #else
-int cifs_reconnect(struct TCP_Server_Info *server, bool mark_smb_session)
+static int
+_cifs_reconnect(struct TCP_Server_Info *server, bool mark_smb_session, bool once)
 {
-	return __cifs_reconnect(server, mark_smb_session);
+	return __cifs_reconnect(server, mark_smb_session, once);
 }
 #endif
 
+int
+cifs_reconnect(struct TCP_Server_Info *server, bool mark_smb_session)
+{
+	return _cifs_reconnect(server, mark_smb_session, false);
+}
+
+static int
+cifs_reconnect_once(struct TCP_Server_Info *server)
+{
+	return _cifs_reconnect(server, true, true);
+}
+
 static void
 cifs_echo_request(struct work_struct *work)
 {
@@ -817,26 +834,110 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 		/* Regular SMB response */
 		return true;
 	case RFC1002_SESSION_KEEP_ALIVE:
+		/*
+		 * RFC 1002 session keep alive can sent by the server only when
+		 * we established a RFC 1002 session. But Samba servers send
+		 * RFC 1002 session keep alive also over port 445 on which
+		 * RFC 1002 session is not established.
+		 */
 		cifs_dbg(FYI, "RFC 1002 session keep alive\n");
 		break;
 	case RFC1002_POSITIVE_SESSION_RESPONSE:
-		cifs_dbg(FYI, "RFC 1002 positive session response\n");
+		/*
+		 * RFC 1002 positive session response cannot be returned
+		 * for SMB request. RFC 1002 session response is handled
+		 * exclusively in ip_rfc1001_connect() function.
+		 */
+		cifs_server_dbg(VFS, "RFC 1002 positive session response (unexpected)\n");
+		cifs_reconnect(server, true);
 		break;
 	case RFC1002_NEGATIVE_SESSION_RESPONSE:
 		/*
 		 * We get this from Windows 98 instead of an error on
-		 * SMB negprot response.
-		 */
-		cifs_dbg(FYI, "RFC 1002 negative session response\n");
-		/* give server a second to clean up */
-		msleep(1000);
-		/*
-		 * Always try 445 first on reconnect since we get NACK
-		 * on some if we ever connected to port 139 (the NACK
-		 * is since we do not begin with RFC1001 session
-		 * initialize frame).
+		 * SMB negprot response, when we have not established
+		 * RFC 1002 session (which means ip_rfc1001_connect()
+		 * was skipped). Note that same still happens with
+		 * Windows Server 2022 when connecting via port 139.
+		 * So for this case when mount option -o nonbsessinit
+		 * was not specified, try to reconnect with establishing
+		 * RFC 1002 session. If new socket establishment with
+		 * RFC 1002 session was successful then return to the
+		 * mid's caller -EAGAIN, so it can retry the request.
 		 */
-		cifs_set_port((struct sockaddr *)&server->dstaddr, CIFS_PORT);
+		if (!cifs_rdma_enabled(server) &&
+		    server->tcpStatus == CifsInNegotiate &&
+		    !server->with_rfc1001 &&
+		    server->rfc1001_sessinit != 0) {
+			int rc, mid_rc;
+			struct mid_q_entry *mid, *nmid;
+			LIST_HEAD(dispose_list);
+
+			cifs_dbg(FYI, "RFC 1002 negative session response during SMB Negotiate, retrying with NetBIOS session\n");
+
+			/*
+			 * Before reconnect, delete all pending mids for this
+			 * server, so reconnect would not signal connection
+			 * aborted error to mid's callbacks. Note that for this
+			 * server there should be exactly one pending mid
+			 * corresponding to SMB1/SMB2 Negotiate packet.
+			 */
+			spin_lock(&server->mid_lock);
+			list_for_each_entry_safe(mid, nmid, &server->pending_mid_q, qhead) {
+				kref_get(&mid->refcount);
+				list_move(&mid->qhead, &dispose_list);
+				mid->mid_flags |= MID_DELETED;
+			}
+			spin_unlock(&server->mid_lock);
+
+			/* Now try to reconnect once with NetBIOS session. */
+			server->with_rfc1001 = true;
+			rc = cifs_reconnect_once(server);
+
+			/*
+			 * If reconnect was successful then indicate -EAGAIN
+			 * to mid's caller. If reconnect failed with -EAGAIN
+			 * then mask it as -EHOSTDOWN, so mid's caller would
+			 * know that it failed.
+			 */
+			if (rc == 0)
+				mid_rc = -EAGAIN;
+			else if (rc == -EAGAIN)
+				mid_rc = -EHOSTDOWN;
+			else
+				mid_rc = rc;
+
+			/*
+			 * After reconnect (either successful or unsuccessful)
+			 * deliver reconnect status to mid's caller via mid's
+			 * callback. Use MID_RC state which indicates that the
+			 * return code should be read from mid_rc member.
+			 */
+			list_for_each_entry_safe(mid, nmid, &dispose_list, qhead) {
+				list_del_init(&mid->qhead);
+				mid->mid_rc = mid_rc;
+				mid->mid_state = MID_RC;
+				mid->callback(mid);
+				release_mid(mid);
+			}
+
+			/*
+			 * If reconnect failed then wait two seconds. In most
+			 * cases we were been called from the mount context and
+			 * delivered failure to mid's callback will stop this
+			 * receiver task thread and fails the mount process.
+			 * So wait two seconds to prevent another reconnect
+			 * in this task thread, which would be useless as the
+			 * mount context will fail at all.
+			 */
+			if (rc != 0)
+				msleep(2000);
+		} else {
+			cifs_server_dbg(VFS, "RFC 1002 negative session response (unexpected)\n");
+			cifs_reconnect(server, true);
+		}
+		break;
+	case RFC1002_RETARGET_SESSION_RESPONSE:
+		cifs_server_dbg(VFS, "RFC 1002 retarget session response (unexpected)\n");
 		cifs_reconnect(server, true);
 		break;
 	default:
@@ -1739,6 +1840,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	memcpy(tcp_ses->server_RFC1001_name,
 		ctx->target_rfc1001_name, RFC1001_NAME_LEN_WITH_NULL);
 	tcp_ses->rfc1001_sessinit = ctx->rfc1001_sessinit;
+	tcp_ses->with_rfc1001 = false;
 	tcp_ses->session_estab = false;
 	tcp_ses->sequence_number = 0;
 	tcp_ses->channel_sequence_num = 0; /* only tracked for primary channel */
@@ -3242,6 +3344,7 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
 		return -EIO;
 	}
 
+	server->with_rfc1001 = true;
 	return 0;
 }
 
@@ -3355,7 +3458,8 @@ generic_ip_connect(struct TCP_Server_Info *server)
 	 * server port (139) and it was not explicitly disabled by mount option
 	 * -o nonbsessinit.
 	 */
-	if (server->rfc1001_sessinit == 1 ||
+	if (server->with_rfc1001 ||
+	    server->rfc1001_sessinit == 1 ||
 	    (server->rfc1001_sessinit == -1 && sport == htons(RFC1001_PORT)))
 		rc = ip_rfc1001_connect(server);
 
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 03434dbe9374..266af17aa7d9 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -894,6 +894,9 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 	case MID_SHUTDOWN:
 		rc = -EHOSTDOWN;
 		break;
+	case MID_RC:
+		rc = mid->mid_rc;
+		break;
 	default:
 		if (!(mid->mid_flags & MID_DELETED)) {
 			list_del_init(&mid->qhead);
-- 
2.20.1

