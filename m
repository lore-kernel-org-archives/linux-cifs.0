Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7575923394A
	for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 17:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790701456; cv=none; b=nZjxjG3aH7c09NW/K5LiQ+YDcSm0OuoZaCm6bJXDGL/q821OC+Tt1j23uiEGNpRTBePdqWJU7NJU4gnuEwBme15yeJ+do1+pwUY/541gNM1Pzyj4qyN033kWZ8pxnh9okFlKlW7FA5yCcpzl7sKrpfxtW+/FjKVqelsKP+/dm1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790701456; c=relaxed/simple;
	bh=vey49p4bSUVQvZUtkwa/9CLWyq2qXDJL+5sqHlmgf0I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gb3nbw5HHvcGmSMbmKpz69ylki/gCdih8CQkG/aW3yVqyCw9Li7byv3THb0kus4Pp/gRRMUjvawYImk0tyfxVa6kNTRM8QHj9NIzR8sIxmc6v3Q65PSoTXjGtF9JFpSEAl2vON26jdZOVWePoFOHr2mDQDJebMksxdmNvUKGse4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZEocSyCY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JnmEQBaz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g4Rs3b6e; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vgJhb4mY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZEocSyCY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JnmEQBaz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g4Rs3b6e";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vgJhb4mY"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AF2FB21D5C;
	Tue, 29 Sep 2026 17:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790701447; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=vP19ikey4TPnipyaX04mHvjM+G/EY/7ioThtw74+zsU=;
	b=ZEocSyCYqKD1ji7ewqTZ51tQKsaHIQHiGl3tZ02rHJJDPX6TUCg1bifXYrqJAIbVn0leg+
	CHZG0fmxbRQtvM5S5JG2sDKsl/ek9SRPL1V3GNzcXbE4vwiJfxp8L3sUK52udqse2Kfgjs
	iZbTiQqwILFOh9ATCy4YTIbGN9jz2Ug=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790701447;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=vP19ikey4TPnipyaX04mHvjM+G/EY/7ioThtw74+zsU=;
	b=JnmEQBaz+Z8SrMNNH1RUCEdjGfC/2CG1+yXOiZbJrMJHrXrkMBMpQWamdV7h7n/lWHMF1l
	JjFjcrc3atT4NaAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=g4Rs3b6e;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vgJhb4mY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790701443; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=vP19ikey4TPnipyaX04mHvjM+G/EY/7ioThtw74+zsU=;
	b=g4Rs3b6eLLrEWstPY/yM3r72B9B3hwAKVF9tIWyJ43ygveOiVF77WBKjRVa3lkEAszk5Uc
	5N26FOMnXnfuWdG8hHZuVIsvXrpK0yAZEVRQ62nS2jA+7Jw0KU02zgtOX9hUOUmZ4unn9o
	0LBxTKlLG4eE7rQhfGD3eFIo7NJmShw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790701443;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=vP19ikey4TPnipyaX04mHvjM+G/EY/7ioThtw74+zsU=;
	b=vgJhb4mYhaGIX9xHXBxuToYUIU6Lv/6TPX310atGe2NoXNEHIUZRi5dIEU4xwxAUavSX/M
	0Q/6Rma2yhmA16Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 161AE133F1;
	Tue, 29 Sep 2026 17:04:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Zzi9JoLvu2pMCAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 29 Sep 2026 17:04:02 +0000
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
Subject: [PATCH v3 1/2] smb: client: fast fail sends if need to reconnect
Date: Tue, 29 Sep 2026 14:03:57 -0300
Message-ID: <20260929170358.270612-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_TWO(0.00)[2];
	FREEMAIL_CC(0.00)[manguebit.org,kernel.org,gmail.com,microsoft.com,talpey.com,suse.com,suse.de];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email,suse.de:mid];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email,suse.de:mid];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: AF2FB21D5C
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

smb_send_kvec() keeps retrying when server needs to reconnect, which
makes no sense as cifs_reconnect() will never run in parallel (because
both need server mutex).
IOW, retrying will never succeed, but only delay reconnects further.

Bail out early from smb_send_kvec() when need to reconnect.

Also shutdown socket queues when CifsNeedReconnect is first detected,
so any sends/receives fails immediately (and don't wait for socket to
timeout).

Add TCP_Server_Info::need_sock_shutdown to ensure socket is shutdown
only once.

kernel_sock_shutdown() will be called from whichever task detects it
first;  cifsd (cifs_tcp_ses_needs_reconnect()), or sending tasks,
through cifs_call_async() or compound_send_recv().

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
v2 -> v3 (patch refactor, change strategy but keep concept):
- remove TCP_Server_Info::mutex_owner (covers sashiko report)
- shutdown socket directly from sender functions (when need to reconnect)
- bail out from smb_send_kvec() when need to reconnect only if rc <= 0
  (from sasiko report)

v1 -> v2 (fix issues detected by sashiko):
- move kernel_sock_shutdown() call out of cifs_tcp_ses_lock
- use server mutex to check/shutdown socket


 fs/smb/client/cifsglob.h  |  1 +
 fs/smb/client/connect.c   | 22 +++++++++++++++++++---
 fs/smb/client/transport.c | 30 ++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 79e4e84f8985..e49140d5c4a4 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -802,6 +802,7 @@ struct TCP_Server_Info {
 	bool	posix_ext_supported;
 	struct delayed_work reconnect; /* reconnect workqueue job */
 	struct mutex reconnect_mutex; /* prevent simultaneous reconnects */
+	bool need_sock_shutdown; /* true when CifsNeedReconnect was first set by non-cifsd task */
 	unsigned long echo_interval;
 
 	/*
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 28e1ddeb6182..733d50b042fd 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -126,12 +126,14 @@ void smb2_query_server_interfaces(struct work_struct *work)
 	queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
 			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
 }
-
 #define set_need_reco(server) \
 do { \
 	spin_lock(&server->srv_lock); \
-	if (server->tcpStatus != CifsExiting) \
+	if (server->tcpStatus != CifsExiting) { \
+		if (server->tcpStatus != CifsNeedReconnect) \
+			server->need_sock_shutdown = true; \
 		server->tcpStatus = CifsNeedReconnect; \
+	} \
 	spin_unlock(&server->srv_lock); \
 } while (0)
 
@@ -353,6 +355,8 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 
 static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num_targets)
 {
+	bool shutdown;
+
 	spin_lock(&server->srv_lock);
 	server->nr_targets = num_targets;
 	if (server->tcpStatus == CifsExiting) {
@@ -365,9 +369,21 @@ static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num
 	cifs_dbg(FYI, "Mark tcp session as need reconnect\n");
 	trace_smb3_reconnect(server->current_mid, server->conn_id,
 			     server->hostname);
-	server->tcpStatus = CifsNeedReconnect;
 
+	/* Cover cases where sender tasks didn't manage to shutdown the socket for some reason */
+	shutdown = (server->tcpStatus != CifsNeedReconnect || server->need_sock_shutdown);
+	server->need_sock_shutdown = false;
+	server->tcpStatus = CifsNeedReconnect;
 	spin_unlock(&server->srv_lock);
+
+	if (shutdown) {
+		cifs_server_lock(server);
+		if (server->ssocket)
+			/* Don't release it here/yet! */
+			kernel_sock_shutdown(server->ssocket, SHUT_RDWR);
+		cifs_server_unlock(server);
+	}
+
 	return true;
 }
 
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 6e21b5f8754a..a1ae8548cf16 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -179,7 +179,18 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 		 * to avoid unnecessary reconnects.
 		 */
 		rc = sock_sendmsg(ssocket, smb_msg);
+
+		/*
+		 * If need to reconnect, blame it for any non-interrupt error and bail out early,
+		 * even if -EAGAIN;  reconnect will never happen in parallel as cifs_reconnect()
+		 * needs server mutex (which we're already holding), so it's pointless to retry.
+		 */
+		if (unlikely(rc <= 0 && server->tcpStatus == CifsNeedReconnect &&
+			     !is_interrupt_error(rc)))
+			return -ECONNRESET;
+
 		if (rc == -EAGAIN || unlikely(rc == -EINTR && task_work_pending(current))) {
+
 			retries++;
 			if (retries >= 14 ||
 			    (!server->noblocksnd && (retries > 2))) {
@@ -654,6 +665,23 @@ int wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	return 0;
 }
 
+static inline void cond_sock_shutdown(struct TCP_Server_Info *server)
+{
+	bool shutdown;
+
+	lockdep_assert_held(&server->_srv_mutex);
+
+	spin_lock(&server->srv_lock);
+	/* No need to check status, need_sock_shutdown is only set if CifsNeedReconnect */
+	shutdown = (server->need_sock_shutdown && server->ssocket);
+	server->need_sock_shutdown = false;
+	spin_unlock(&server->srv_lock);
+
+	if (shutdown)
+		/* Don't release it here/yet! */
+		kernel_sock_shutdown(server->ssocket, SHUT_RDWR);
+}
+
 /*
  * Send a SMB request and set the callback function in the mid to handle
  * the result. Caller is responsible for dealing with timeouts.
@@ -724,6 +752,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 		revert_current_mid(server, mid->credits);
 		server->sequence_number -= 2;
 		delete_mid(server, mid);
+		cond_sock_shutdown(server);
 	}
 
 	cifs_server_unlock(server);
@@ -982,6 +1011,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			delete_mid(server, mid[i]);
 			cancelled_mid[i] = true;
 		}
+		cond_sock_shutdown(server);
 	}
 
 	cifs_server_unlock(server);
-- 
2.55.0

