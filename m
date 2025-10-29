Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7153559EB
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744720; cv=none; b=GFtclPgjIZXrlnZmiwAH+xs+Zae238QixxtBD0102+uCMSk+sSwpahBvCtm3WH49fTaT07Clfm4jJ7SEFbxBQaHjRAuqZSwm0bAd09p3rubBRTj1qi3kmY1m2xGorjuUML8NQNsJaAu0v+WsWZff1PVMdI8bLYOZbId45ISLNbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744720; c=relaxed/simple;
	bh=KbYTFO3sAKsSyQ57AIppjAV813U/Pbylqw+Q+VkrI1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+MDxmk8aCtcVnaxvJWiUFEPc4LEFWZ0G8+h6JSXJdubw0LpdjKNIb9ILi/GHPovHkgJCRB7iQjJ1OQmrhN14meQcRqsXQ0Lt7BW5j49Nzb19Bi/yIpaklNL3627M+NwtU6HGZZx/dTqSPL6vfn6UoV0VnTzmcVL18MGvDPTTTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Es6jViwc; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Es6jViwc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=abMdsTUjWFKLgdKxdxnFPbzWh8tdWjm77OiDbb/AIJw=; b=Es6jViwcywK4yQIjaRhipij+Kv
	e7tDi9NoMI+F7iF8E9KvROofCFHnrGyV3CeCnn6/PpLybjqvXZUdiA2WRuFVADKHEs9hDwjvyxClL
	wSQtC5vI5qsX2oEtnrCNqXEJ+7M81KZL+LyoEca8WejJkKl0uiCIJh0TURqyuFsg75WBKPcWLWQfI
	cWWyvaGcYMah5fRdJAniOvLCf1ra6N6VLbC7rfqsNKlLPTjpOgal/GSYMwe34ORUGWtfFp8+IVPVk
	abIbuKis1G9PADnGHlX9w1mp/f7be1x+YbZi951SbFriixNh7h3vbfWCixq72iWU9luaHQPYkGfB3
	FQD0YcWi7OER3DVSbdFyZSBvfEwE6aTVE2oK5cmEDmuA4wzup41iJBySKizRRt+rhfJ6hsqG0lFEv
	kSnSy9wFU/uXt3mQQtYz7RwORaHhIuB6cXhKlsst3clfermyoe6F86BxN0lgJnNWWdHtE8TKsASrm
	bdbMS6Di287f5lnTk/2RRlHm;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6HL-00Bcew-10;
	Wed, 29 Oct 2025 13:31:55 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 094/127] smb: server: make use of smbdirect_connection_wake_up_all()
Date: Wed, 29 Oct 2025 14:21:12 +0100
Message-ID: <2ba5c904020e197627a9b79937174f83cb4fdd91.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a superset of smb_direct_disconnect_wake_up_all() and
calling wake_up_all(&sc->mr_io.ready.wait_queue); and
wake_up_all(&sc->mr_io.cleanup.wait_queue); in addition
should not matter as it's not used on the server anyway.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index fa6371ed0b76..b78753801fe5 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -281,20 +281,6 @@ static struct smbdirect_recv_io *get_first_reassembly(struct smbdirect_socket *s
 		return NULL;
 }
 
-static void smb_direct_disconnect_wake_up_all(struct smbdirect_socket *sc)
-{
-	/*
-	 * Wake up all waiters in all wait queues
-	 * in order to notice the broken connection.
-	 */
-	wake_up_all(&sc->status_wait);
-	wake_up_all(&sc->send_io.lcredits.wait_queue);
-	wake_up_all(&sc->send_io.credits.wait_queue);
-	wake_up_all(&sc->send_io.pending.zero_wait_queue);
-	wake_up_all(&sc->recv_io.reassembly.wait_queue);
-	wake_up_all(&sc->rw_io.credits.wait_queue);
-}
-
 static void smb_direct_disconnect_rdma_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
@@ -350,7 +336,7 @@ static void smb_direct_disconnect_rdma_work(struct work_struct *work)
 	 * Wake up all waiters in all wait queues
 	 * in order to notice the broken connection.
 	 */
-	smb_direct_disconnect_wake_up_all(sc);
+	smbdirect_connection_wake_up_all(sc);
 }
 
 static void
@@ -412,7 +398,7 @@ smb_direct_disconnect_rdma_connection(struct smbdirect_socket *sc)
 	 * Wake up all waiters in all wait queues
 	 * in order to notice the broken connection.
 	 */
-	smb_direct_disconnect_wake_up_all(sc);
+	smbdirect_connection_wake_up_all(sc);
 
 	queue_work(sc->workqueue, &sc->disconnect_work);
 }
@@ -538,7 +524,7 @@ static void free_transport(struct smb_direct_transport *t)
 	 * Most likely this was already called via
 	 * smb_direct_disconnect_rdma_work(), but call it again...
 	 */
-	smb_direct_disconnect_wake_up_all(sc);
+	smbdirect_connection_wake_up_all(sc);
 
 	disable_work_sync(&sc->recv_io.posted.refill_work);
 	disable_delayed_work_sync(&sc->idle.timer_work);
-- 
2.43.0

