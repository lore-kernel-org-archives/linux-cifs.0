Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DF22AE90
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154769; cv=none; b=XC3SUtyiLyN/kZSpTC4p+/eF/QAnKzTHP3ldSoqn2FzoLGHj0l+4yWHajgqXs0jzFnbulkeHtT69vMONZsDH2hHSnbN2aTXc3fI/3MbbY197JJSslQRHPl8aEvIpr/1MQvZDyLKMwuiRzw52XJSiZuqhskexLCxrSOESWO0HhMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154769; c=relaxed/simple;
	bh=Tp07He3sUEq7RnYPb0VQL7XuUxw8eOm5tnZqWIWnY+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJ56VwlFVYwF1chMIb5SahZRJLp7GQKANPs0KxwU9yyNuOVqfw8/HCf5ovbMZM9v2U8elaY8ZPhgrHUyTDk5/lgF1cqZSpOIf1NOP/EwpyVeHvjTuvX/uQ9JqKOTJVns2C21A9eUN0kzaBSCxSaQyyy5FvZ94nAbWdzaWZod0OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=YhEHs0OE; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="YhEHs0OE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=W7BCf1FH5/ehSVjUInzEVRfJSINq0jXrwiFZs1mDCY4=; b=YhEHs0OElTCI3o0LYDsfm4qi2p
	2AuQsFiCDTKYlLPy3i48QEyWz9l6gHstB/kL36lNxXHED1M6dFOs2NN3EzRvcCK0koTuEEW0VllWT
	yZdICnyAVkO+IrZT0eVtsQ8tDdb2visTmQ5SvkUFEhC6pl/hnIGdyJdUKDlD+d/NoiW9cLofFA/HU
	1xKYSTrr62jxtjRWJT19NY88/EonmwbXztCe6DYPlSQ5R3WTNIb/KpK8BBjNOWhgLivuhLLqw0q0u
	BAnLARddoYhEwas6Bf8q0y+0btETsSCRDsuzAQsDQqkqMn0SqAu8YvlYdPLRAriOkNV/vRp9Y5gg/
	KOySPoq5l5IjBjZe9a3rnDENW96LBv/Jjac/T0sW1W48Qbxunh91Qjkm+IP+FMvwHFOaWft52vWQ9
	XfAodKof7BMfODYodTLTLCc5LMt5bJXuBpczFo2pCy2HilP7xB5h7jYiMcGMXrDpYi0C1hB9dN+LX
	lb/TLIZ6eYxU/P+Jk6yucp1f;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe4p-000k00-0t;
	Mon, 25 Aug 2025 20:46:04 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 025/142] smb: client: make use of smbdirect_socket.disconnect_work
Date: Mon, 25 Aug 2025 22:39:46 +0200
Message-ID: <8fefc9e5e71a4a4626e7a6d8b2db512312fd334f.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 12 +++++++-----
 fs/smb/client/smbdirect.h |  1 -
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index ded912e904f0..58db3e7d4de3 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -157,9 +157,8 @@ do {									\
 
 static void smbd_disconnect_rdma_work(struct work_struct *work)
 {
-	struct smbd_connection *info =
-		container_of(work, struct smbd_connection, disconnect_work);
-	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, disconnect_work);
 
 	switch (sc->status) {
 	case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
@@ -196,7 +195,9 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 
 static void smbd_disconnect_rdma_connection(struct smbd_connection *info)
 {
-	queue_work(info->workqueue, &info->disconnect_work);
+	struct smbdirect_socket *sc = &info->socket;
+
+	queue_work(info->workqueue, &sc->disconnect_work);
 }
 
 /* Upcall from RDMA CM */
@@ -1655,6 +1656,8 @@ static struct smbd_connection *_smbd_get_connection(
 	info->initiator_depth = 1;
 	info->responder_resources = SMBD_CM_RESPONDER_RESOURCES;
 
+	INIT_WORK(&sc->disconnect_work, smbd_disconnect_rdma_work);
+
 	rc = smbd_ia_open(info, dstaddr, port);
 	if (rc) {
 		log_rdma_event(INFO, "smbd_ia_open rc=%d\n", rc);
@@ -1800,7 +1803,6 @@ static struct smbd_connection *_smbd_get_connection(
 
 	init_waitqueue_head(&info->wait_post_send);
 
-	INIT_WORK(&info->disconnect_work, smbd_disconnect_rdma_work);
 	INIT_WORK(&info->post_send_credits_work, smbd_post_send_credits);
 	info->new_credits_offered = 0;
 	spin_lock_init(&info->lock_new_credits_offered);
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index f250241d2d24..1c63188664df 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -45,7 +45,6 @@ enum keep_alive_status {
 struct smbd_connection {
 	struct smbdirect_socket socket;
 
-	struct work_struct disconnect_work;
 	struct work_struct post_send_credits_work;
 
 	spinlock_t lock_new_credits_offered;
-- 
2.43.0

