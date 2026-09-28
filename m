Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D35B2E62AC
	for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 15:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790607863; cv=none; b=SsMUfyUNM7XiNrZe2TE26hxxgYFJNybp2K7yBTeSO7CejivmImdnEndlFk1nf+KXJhFfm1uXKV/8hrQy4AftG8Du7UICaVU8svYntCkxKVxpYzo42SsmReZ0DSWZKiEMU2Z92TUBD8RXIGp8nxpdEobxTDbei0GnFZR16yDeSRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790607863; c=relaxed/simple;
	bh=pVaFvYdPcoIYlx4FxMlGVpJtEOdEGeeuQZgKyX4VlIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpu/DkkhOyG2wNa9nGB8FQApR7dZRo5v9oBzuObzuOliw4n+BaNNc+bUKa3YIZYAWF0VJjCQCJq66DVmi1ALKPSFR4+xqt/ff2AK8v+qaJazucOijJR/tLShsZNs9XqmtpvmtsudEiLNrCWeborM4gBQwokQtpeYjAsj02w7DQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kKi/WzK6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=i4NLru72; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KngvDGEP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=d0tSjA8g; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kKi/WzK6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="i4NLru72";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KngvDGEP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="d0tSjA8g"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EEF8021D5F;
	Mon, 28 Sep 2026 15:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790607856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7CZ1FrOgOFHn4NZ4RzjKB7kK1poJoI3w0C8EEqm0wps=;
	b=kKi/WzK6PdVP2fFwrhKBsY0BG9W3so0uQ6qy0X1thG8NOq1tsL+I+zFi+IYwCq6b60DUw7
	/z6Dj/zlzX6ivKzrKahwHCzOm0OMJ+Ia6z3frT0ZbHgt6jAJ6X+EiXOi91zYX03RbXTy7i
	25jAqh8gGLf9UizWa04l+6hC+T/P65c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790607856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7CZ1FrOgOFHn4NZ4RzjKB7kK1poJoI3w0C8EEqm0wps=;
	b=i4NLru72aOFrChqGuhlWvoEpTS/zmy8IgATbvuA41x34F21gWWBGysEgthMlPxLUMWlW2f
	+QWS0NM6+uupgxDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KngvDGEP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=d0tSjA8g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790607851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7CZ1FrOgOFHn4NZ4RzjKB7kK1poJoI3w0C8EEqm0wps=;
	b=KngvDGEPLpi2DtrtfG1OvyfBjsbP2D8TBfcqLbstOjCKbWcMIoFRqc45Mpy5P0ujtex5lw
	rgI3M0P+dutN7FMK/uLg6Jn9ZOjzRw4sGdXYQsZf63Chx3nEL2rFC/Bdicj4FQiESbwQMb
	p/v8PR8wGc+sCPO1IrzLpuS+4mdfMqQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790607851;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7CZ1FrOgOFHn4NZ4RzjKB7kK1poJoI3w0C8EEqm0wps=;
	b=d0tSjA8gChRZNYh41HoNIkxiKerxp4nPDAUzJlSaTfXdoZSQlJvVPOEZ//wIf6Ulb80ux7
	mK+29XNTXIYt4hDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5CAB913418;
	Mon, 28 Sep 2026 15:04:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KxiiN+qBumpYIwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 28 Sep 2026 15:04:11 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH v2 1/2] smb: client: fast fail sends if need to reconnect
Date: Mon, 28 Sep 2026 12:03:54 -0300
Message-ID: <20260928150355.850472-2-ematsumiya@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928150355.850472-1-ematsumiya@suse.de>
References: <20260928150355.850472-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: EEF8021D5F
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[manguebit.org,kernel.org,gmail.com,microsoft.com,talpey.com,suse.com,suse.de];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

smb_send_kvec() keeps retrying when server needs to reconnect, which
makes no sense as cifs_reconnect() will never run in parallel (because
both need server mutex).
IOW, retrying will never succeed, but only delay reconnects further.

Bail out early from smb_send_kvec() when need to reconnect.

Also shutdown socket queues when CifsNeedReconnect is first set, so any
sends/receives fails immediately (don't wait for socket to timeout).

Consequential change:
To shutdown the socket, we need to hold server mutex. Since not all
callers hold it when calling cifs_signal_cifsd_for_reconnect(), we
need to keep track of the owner task, so we can lock it as needed.

Add TCP_Server_Info::mutex_owner for that.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
v1 -> v2 (fix issues detected by sashiko):
- move kernel_sock_shutdown() call out of cifs_tcp_ses_lock
- use server mutex to check/shutdown socket


 fs/smb/client/cifsglob.h  |  3 +++
 fs/smb/client/connect.c   | 54 +++++++++++++++++++++++++++++++--------
 fs/smb/client/transport.c |  8 ++++++
 3 files changed, 55 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 79e4e84f8985..d279b5c92a08 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -711,6 +711,7 @@ struct TCP_Server_Info {
 	spinlock_t req_lock;  /* protect the two values above */
 	struct mutex _srv_mutex;
 	unsigned int nofs_flag;
+	struct task_struct *mutex_owner;
 	struct task_struct *tsk;
 	char server_GUID[16];
 	__u16 sec_mode;
@@ -847,12 +848,14 @@ static inline void cifs_server_lock(struct TCP_Server_Info *server)
 
 	mutex_lock(&server->_srv_mutex);
 	server->nofs_flag = nofs_flag;
+	server->mutex_owner = current;
 }
 
 static inline void cifs_server_unlock(struct TCP_Server_Info *server)
 {
 	unsigned int nofs_flag = server->nofs_flag;
 
+	server->mutex_owner = NULL;
 	mutex_unlock(&server->_srv_mutex);
 	memalloc_nofs_restore(nofs_flag);
 }
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 28e1ddeb6182..4cc433308c96 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -127,13 +127,42 @@ void smb2_query_server_interfaces(struct work_struct *work)
 			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
 }
 
-#define set_need_reco(server) \
-do { \
-	spin_lock(&server->srv_lock); \
-	if (server->tcpStatus != CifsExiting) \
-		server->tcpStatus = CifsNeedReconnect; \
-	spin_unlock(&server->srv_lock); \
-} while (0)
+static inline bool __set_need_reco(struct TCP_Server_Info *server)
+{
+	bool need_reco = false;
+
+	spin_lock(&server->srv_lock);
+	if (server->tcpStatus != CifsExiting) {
+		need_reco = (server->tcpStatus != CifsNeedReconnect);
+		server->tcpStatus = CifsNeedReconnect;
+	}
+	spin_unlock(&server->srv_lock);
+
+	return need_reco;
+}
+
+static inline void kill_socket_queues(struct TCP_Server_Info *server)
+{
+	bool locked = false;
+
+	if (server->mutex_owner != current) {
+		cifs_server_lock(server);
+		locked = true;
+	}
+
+	if (server->ssocket)
+		/* Don't release it yet! */
+		kernel_sock_shutdown(server->ssocket, SHUT_RDWR);
+
+	if (locked)
+		cifs_server_unlock(server);
+}
+
+static inline void set_need_reco(struct TCP_Server_Info *server)
+{
+	if (__set_need_reco(server))
+		kill_socket_queues(server);
+}
 
 /*
  * Update the tcpStatus for the server.
@@ -151,6 +180,7 @@ cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 	struct TCP_Server_Info *nserver;
 	struct cifs_ses *ses;
 	LIST_HEAD(reco);
+	bool shutdown;
 	int i;
 
 	/* if we need to signal just this channel */
@@ -162,7 +192,7 @@ cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 	if (SERVER_IS_CHAN(server))
 		server = server->primary_server;
 	scoped_guard(spinlock, &cifs_tcp_ses_lock) {
-		set_need_reco(server);
+		shutdown = __set_need_reco(server);
 		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
 			spin_lock(&ses->ses_lock);
 			if (ses->ses_status == SES_EXITING) {
@@ -184,6 +214,9 @@ cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 		}
 	}
 
+	if (shutdown)
+		kill_socket_queues(server);
+
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry_safe(server, nserver, &reco, rlist) {
 		list_del_init(&server->rlist);
@@ -365,9 +398,10 @@ static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num
 	cifs_dbg(FYI, "Mark tcp session as need reconnect\n");
 	trace_smb3_reconnect(server->current_mid, server->conn_id,
 			     server->hostname);
-	server->tcpStatus = CifsNeedReconnect;
-
 	spin_unlock(&server->srv_lock);
+
+	set_need_reco(server);
+
 	return true;
 }
 
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 6e21b5f8754a..c6e0ee6d0ef4 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -180,6 +180,10 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 		 */
 		rc = sock_sendmsg(ssocket, smb_msg);
 		if (rc == -EAGAIN || unlikely(rc == -EINTR && task_work_pending(current))) {
+			/* Don't retry if need to reconnect */
+			if (unlikely(server->tcpStatus == CifsNeedReconnect))
+				return -ECONNRESET;
+
 			retries++;
 			if (retries >= 14 ||
 			    (!server->noblocksnd && (retries > 2))) {
@@ -191,6 +195,10 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 			continue;
 		}
 
+		/* Blame the need to reconnect for any non-interrupt error */
+		if (unlikely(server->tcpStatus == CifsNeedReconnect && !is_interrupt_error(rc)))
+			rc = -ECONNRESET;
+
 		if (rc < 0)
 			return rc;
 
-- 
2.55.0

