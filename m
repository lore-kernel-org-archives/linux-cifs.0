Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7F14F4D0D
	for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2026 18:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791483997; cv=none; b=fx7pakFkHhRzKHYF6gjaRVywjTLbZm4l6mB5dTFM4pS2xuD7rHCivxuC46CVwnR4mbB6w0SjGmrr7VGJfzzpepZy8MmqsRHyFummDghTi1xCJPvV2YQXbozO/7P2znNCRH7PNmhq7pkLB/20090knJUrvdUkILutKc/OoEoldJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791483997; c=relaxed/simple;
	bh=+s+mmd+Bu9vOpHqTaXVkESOqGofREx2HXja8SHUrqQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KrdXppRB8NelmXJBUx5r1Ak5gu2lgth0Y/rrwsq6K9HtUehFiIjqrJSy4f7e0IgHDSe6HOkP9UirDWHhO6Du71plK7C0KK7s/IG29LoGkEyGRI3FwPdKN6UqlylTP2FawXEyV/zZ9txgHU/fyPsXoUd90hRra0JTn+BF8IGJm4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 857F61F44E;
	Thu,  8 Oct 2026 18:26:25 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E5CA413354;
	Thu,  8 Oct 2026 18:26:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iB3oHVDgx2p/SwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 08 Oct 2026 18:26:24 +0000
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
Subject: [PATCH v4 1/2] smb: client: fast fail sends if need to reconnect
Date: Thu,  8 Oct 2026 15:26:09 -0300
Message-ID: <20261008182609.2208508-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Spam-Flag: NO
X-Spamd-Bar: /
X-Rspamd-Queue-Id: 857F61F44E
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spamd-Result: default: False [0.00 / 50.00]
X-Spam-Score: 0.00

smb_send_kvec() keeps retrying when server needs to reconnect, which
makes no sense as cifs_reconnect() will never run in parallel (because
both need server mutex).
IOW, retrying will never succeed, but only delay reconnects further.

Bail out early from smb_send_kvec() when need to reconnect.

Also shutdown socket queues when CifsNeedReconnect is first detected,
so any sends/receives fails immediately (and don't wait for socket to
timeout).

Add TCP_Server_Info::need_sock_shutdown to ensure socket is shutdown
only once -- even though socket/TCP API will prevent multiple shutdowns,
we need to prevent, from cifs side, concurrent tasks from accidentally
shutting down the socket again in case cifs_reconnect() is successful.

kernel_sock_shutdown() will be called from whichever task detects it
first;  cifsd (cifs_tcp_ses_needs_reconnect()), or sending tasks,
through cifs_call_async() or compound_send_recv().

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
v3 -> v4 (fixes from Paulo's review):
- code style and syntax
- use READ_ONCE() for unlocked server->tcpStatus read
- modified commit message, explaining why
  TCP_Server_Info::need_sock_shutdown is needed

 fs/smb/client/cifsglob.h  |  1 +
 fs/smb/client/connect.c   | 25 +++++++++++++++++++++++--
 fs/smb/client/transport.c | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 79e4e84f8985..166e8d8eed66 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -802,6 +802,7 @@ struct TCP_Server_Info {
 	bool	posix_ext_supported;
 	struct delayed_work reconnect; /* reconnect workqueue job */
 	struct mutex reconnect_mutex; /* prevent simultaneous reconnects */
+	bool need_sock_shutdown; /* shutdown socket when need to reconnect */
 	unsigned long echo_interval;
 
 	/*
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 28e1ddeb6182..ff8637301fa9 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -130,8 +130,11 @@ void smb2_query_server_interfaces(struct work_struct *work)
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
 
@@ -353,6 +356,8 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 
 static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num_targets)
 {
+	bool shutdown;
+
 	spin_lock(&server->srv_lock);
 	server->nr_targets = num_targets;
 	if (server->tcpStatus == CifsExiting) {
@@ -365,9 +370,25 @@ static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num
 	cifs_dbg(FYI, "Mark tcp session as need reconnect\n");
 	trace_smb3_reconnect(server->current_mid, server->conn_id,
 			     server->hostname);
-	server->tcpStatus = CifsNeedReconnect;
 
+	/*
+	 * Cover cases where sender tasks didn't manage to shutdown the socket
+	 * for some reason.
+	 */
+	shutdown = server->tcpStatus != CifsNeedReconnect ||
+		   server->need_sock_shutdown;
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
index 6e21b5f8754a..cf11af490b0d 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -179,6 +179,17 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 		 * to avoid unnecessary reconnects.
 		 */
 		rc = sock_sendmsg(ssocket, smb_msg);
+
+		/*
+		 * If need to reconnect, blame it for any non-interrupt error
+		 * and bail out early, even if -EAGAIN;  reconnect will never
+		 * happen in parallel as cifs_reconnect() needs server mutex
+		 * (which we're already holding), so it's pointless to retry.
+		 */
+		if (unlikely(rc <= 0 && !is_interrupt_error(rc) &&
+			     READ_ONCE(server->tcpStatus) == CifsNeedReconnect))
+			return -ECONNRESET;
+
 		if (rc == -EAGAIN || unlikely(rc == -EINTR && task_work_pending(current))) {
 			retries++;
 			if (retries >= 14 ||
@@ -654,6 +665,26 @@ int wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	return 0;
 }
 
+static void cond_sock_shutdown(struct TCP_Server_Info *server)
+{
+	bool shutdown;
+
+	lockdep_assert_held(&server->_srv_mutex);
+
+	spin_lock(&server->srv_lock);
+	/*
+	 * No need to check status, ->need_sock_shutdown is only set when it's
+	 * CifsNeedReconnect.
+	 */
+	shutdown = server->need_sock_shutdown && server->ssocket;
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
@@ -724,6 +755,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 		revert_current_mid(server, mid->credits);
 		server->sequence_number -= 2;
 		delete_mid(server, mid);
+		cond_sock_shutdown(server);
 	}
 
 	cifs_server_unlock(server);
@@ -982,6 +1014,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			delete_mid(server, mid[i]);
 			cancelled_mid[i] = true;
 		}
+		cond_sock_shutdown(server);
 	}
 
 	cifs_server_unlock(server);
-- 
2.55.0

