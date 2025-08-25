Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AF72628C
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154806; cv=none; b=OC38c5QymUg8fVhTTFsndc87hF5CKbok71BC4o2k8DZrTlItQ71vfF72jTFClKZVHoQw00lAIjojX5SUsGZXTde9XY766vtsi5AYBLH3OCdR66x91RHsDV6lUVRGm7djlqViSufFqNBYpyMznj7aHEBsc3LkMflrKJqVsJ02zUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154806; c=relaxed/simple;
	bh=Kl0kMPqspSCgpg4C8C0Fl23QQZtLHp07X+/WkJ2IOX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUFO3ieNQUGJfhmmjjt+HcLW0zABQNNCpHC6WCt3P0Etu3uipT/QYiDlsLtc87w5s5Z7gFAJKrjFAXE45sKGXH4BMi6+DG1/0uIvSmdXRdAVZN3GXY9uAy26N8Q23jH4Lu3Um//tB573VNG3WMEDqajRATSMX9UGuEKQJ40oN3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=3Xk3snJM; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="3Xk3snJM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Y6/nlBSg8A+NvwBSbcGUNlQwdnB6Qfcegl5rxs1zdp4=; b=3Xk3snJMsk0SQ5ZnnKLf11U/ir
	z8dImSyVSOvhTr8xAqZWl7qZ/4Z0SDHKonWEpruHKQSkr6cdtr+9rkWtAUIL2++6M6v0lUcr94Bzt
	iLOYMqYPDWyeEJ41qsvJtmpuw3iPp7qjJFNHgdovHNkDZyeos0chy3gC07ml9k23mST482Twgul9f
	aBnxzhIANgQTuNTM/SYGll3AjtxQpIxWfcd27B4STsKipp+V/8bC8t9tAQK0w0hTn3wyOJKuenKm8
	Qcb0S1fxh2TZynLybh4Dze12FGaYTNKqjqxmSfpOIRBJR9biNb8T/q5eKNR6Eth6KPRBX844nLuAB
	bufKYXa5wyzOx23ZZdTZmc+LcFrVTOU5FMWImMaA5YAahLJXdbXGlWS8eLt4F9qT7lOOAXCS3zuu9
	fqXlJdV6qWxitCn7v4wskrRb70JJH0nTiDj8ARg3H+loZ6F3XQgwwoCAyw+yVX50VijigSOQT2TUo
	WrpPZmOhilPWzYiagL65wKpy;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe5R-000k8c-01;
	Mon, 25 Aug 2025 20:46:41 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 029/142] smb: client: use disable[_delayed]_work_sync in smbdirect.c
Date: Mon, 25 Aug 2025 22:39:50 +0200
Message-ID: <7557378cc38349fcb66205c5dcfa0b0b2fb98375.1756139607.git.metze@samba.org>
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

This makes it safer during the disconnect and avoids
requeueing.

It's ok to call disable[delayed_]work[_sync]() more than once.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index eab8433a518c..d36556fab357 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1468,7 +1468,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	sc->ib.qp = NULL;
 
 	log_rdma_event(INFO, "cancelling idle timer\n");
-	cancel_delayed_work_sync(&info->idle_timer_work);
+	disable_delayed_work_sync(&info->idle_timer_work);
 
 	/* It's not possible for upper layer to get to reassembly */
 	log_rdma_event(INFO, "drain the reassembly queue\n");
@@ -1841,7 +1841,7 @@ static struct smbd_connection *_smbd_get_connection(
 	return NULL;
 
 negotiation_failed:
-	cancel_delayed_work_sync(&info->idle_timer_work);
+	disable_delayed_work_sync(&info->idle_timer_work);
 	destroy_caches_and_workqueue(info);
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
 	rdma_disconnect(sc->rdma.cm_id);
@@ -2200,7 +2200,7 @@ static void destroy_mr_list(struct smbd_connection *info)
 	struct smbdirect_socket *sc = &info->socket;
 	struct smbd_mr *mr, *tmp;
 
-	cancel_work_sync(&info->mr_recovery_work);
+	disable_work_sync(&info->mr_recovery_work);
 	list_for_each_entry_safe(mr, tmp, &info->mr_list, list) {
 		if (mr->state == MR_INVALIDATED)
 			ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl,
-- 
2.43.0

