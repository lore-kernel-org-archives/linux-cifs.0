Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6412FD69E
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 19:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576982; cv=none; b=KiajvhDdadTYLMradwyJUU/r0DRXW2ok1nbmLQwzMcN5TL7FDWhgbM5wNw7gw7GkixSnGZE+Hioi7Ae4Fd/lU30yiMvW+BXl8bR9lHKKhMnrZaqB2qgIn/ppq+17kCguALuYmOGjlu2cEMOq0re5HTtMB8BJGD8hfaTjus5+NO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576982; c=relaxed/simple;
	bh=f7HNyJ/vtQhTp8s1DLaSDxv8/MIsfWvt1jW/FU1QHyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nehOkW0wSxTChtc6J/aR/vD7Lg+pJ+zjDO9ZuwzR813psY4aBrzXNXpmjAcPizjF302lSJ/j1+lAfct//oRWHUuCd8A5wOIRL3GSmfATZGAi3PbDVnnVwpIEDODpJ9P12iufb4B4XkzEDZWWTymvWe/1RyRdJpI/GLvhGS3pe2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 83BD67A16B;
	Mon, 20 Jul 2026 19:49:37 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C5D58779AA;
	Mon, 20 Jul 2026 19:49:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eV52ItB7XmoeCAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 20 Jul 2026 19:49:36 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH v2 03/14] smb: client: compress: disable compression on reconnects
Date: Mon, 20 Jul 2026 16:49:14 -0300
Message-ID: <20260720194925.2108840-3-ematsumiya@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720194925.2108840-1-ematsumiya@suse.de>
References: <20260720194925.2108840-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: 83BD67A16B
X-Rspamd-Action: no action

Windows Server resets the connection if it gets a compressed request
that it couldn't decompress.

Some encoded payloads might decode differently on the server, or
vice-versa, due to different implementation details (not really a bug),
or an actual bug on either implementation.

To prevent an infinite retry on such failed sends, simply disable
compression for that server when a reconnect is about to happen.

Other:
- add disable_compression() helper (cifsglob.h)

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cifsglob.h | 20 ++++++++++++++++++++
 fs/smb/client/connect.c  | 11 +++++++++++
 2 files changed, 31 insertions(+)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 99f9e6dca62b..5a397499dcb0 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -835,6 +835,26 @@ struct TCP_Server_Info {
 	char dns_dom[CIFS_MAX_DOMAINNAME_LEN + 1];
 };
 
+static __always_inline void disable_compression(struct TCP_Server_Info *server)
+{
+	/*
+	 * should_compress() checks the primary server compression state, so disable it only
+	 * on primary server.
+	 */
+	if (SERVER_IS_CHAN(server))
+		server = server->primary_server;
+
+	if (server->compression.enabled) {
+		pr_warn("%s: disabling compression (failsafe)\n", server->hostname);
+
+		/*
+		 * We must keep ->requested as true, in case new channels are added, so server
+		 * capabilities are kept in sync (even though no further compression will be done).
+		 */
+		server->compression.enabled = false;
+	}
+}
+
 static inline bool is_smb1(const struct TCP_Server_Info *server)
 {
 	return server->vals->protocol_id == SMB10_PROT_ID;
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 85aec302c89e..6a4afefe337d 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -401,6 +401,17 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
 		try_to_freeze();
 		cifs_server_lock(server);
 
+		/*
+		 * Servers might disconnect us when they can't decompress a compressed request we
+		 * sent.
+		 * When this happens, as a failsafe measure, disable compression entirely to avoid
+		 * an endless retry.
+		 *
+		 * TODO: implement a more flexible alternative, e.g. identify and retry sending
+		 * the failed request uncompressed, without having to disable compression entirely.
+		 */
+		disable_compression(server);
+
 		if (!cifs_swn_set_server_dstaddr(server) &&
 		    !SERVER_IS_CHAN(server)) {
 			/* resolve the hostname again to make sure that IP address is up-to-date */
-- 
2.54.0

