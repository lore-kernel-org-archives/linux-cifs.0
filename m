Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C0432C31A
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093978; cv=none; b=UiGRUD8hyXyMDMhCknOZ5GsZiZgwVLsbN+HCqh+B6BZgErjlz1Vk2qcMru+HnXA5M4b73QTji82r9SxvIn5Vmd1se5lORZ9DnQETAhmZy1ggFIk3MdJvN1OYXjToUUeuPfj9yrzX2nZviZcPS6zqvA1Ez93xBNt0vSAh+pytMAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093978; c=relaxed/simple;
	bh=72GpgRv1+GdCsUgm/ArlIdXz+vPyS/zkPJQ3XXjUggo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBdRUyAb4krKGCz3hHq/YWck9KMHNgGelKEABR0WrEUBK54Xp2xOTHGqunGxEQCw9aWdGXaxaebOOhWkuvkrhUfw6hKCTMW/3f4zDh9hK+M/bxP6u67uiZtcKH5RwfGXQhPpVIxJLiGZvSu0X0llKUYIbEZe/vrEg4wSkIfQXqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=beUPiB3S; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="beUPiB3S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=xgRkxj8MlIApNKFGbQzthm1RA/kbsz15MGuOKSS5dII=; b=beUPiB3Syb19521SJpqzI8XTs8
	uu9powd+uu5EHd/8w2Vs3eZw+h96BaFCORscYvRfHB5VkfiL+HtY5riqxp5gO4MoWpN7koBnybeXL
	T1Vdjd1KfrRxvlx+pl4fsmmXnYMnI9o4cg+WJu69EBe6Wx8BqN8p2CNqqz9VfnJ6r7iFsAhPt1yqm
	2gPBNgWrMV82SfVHdViyegUaahYrsTT5W5iZ5jAe7mtb7G1sBzP5YXt1V9uEgacxXrbNnW3q3vczh
	PsMStUtAQMEkAKlVpB4CM2vam7MDaDPgezx2Bpa0xjFAqZXucf8Xwz/EJ5xcYUe+4TmZ1Ttq7Zh6h
	H9W/VhpLiizu5SoPW1LfNYhglcSVpnvaTE6ak5iQH+ckmJ+QjzdseAgAhioqPi83qovjzrws5O3r+
	JrvfWz4+UUc/do7B1YoLFLFweKAUPdF9mMJ8e67QDmVw6pFvQCv5LSWnP/YhyV7eVkWG6jhO57fE1
	4iBHcIR8HgrRTYCZpij3Ui4V;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxNa-00FdaN-2p;
	Tue, 25 Nov 2025 18:03:07 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 061/145] smb: client: make use of smbdirect_socket_prepare_create()
Date: Tue, 25 Nov 2025 18:55:07 +0100
Message-ID: <6efdeba34072c02767779107b9d5b6fa3c684757.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This prepares the use of functions from smbdirect_connection.c.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 320166f5d267..05ac030ab653 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1800,6 +1800,7 @@ static struct smbd_connection *_smbd_get_connection(
 	int rc;
 	struct smbd_connection *info;
 	struct smbdirect_socket *sc;
+	struct smbdirect_socket_parameters init_params = {};
 	struct smbdirect_socket_parameters *sp;
 	struct rdma_conn_param conn_param;
 	struct ib_qp_cap qp_cap;
@@ -1810,20 +1811,10 @@ static struct smbd_connection *_smbd_get_connection(
 	char wq_name[80];
 	struct workqueue_struct *workqueue;
 
-	info = kzalloc(sizeof(struct smbd_connection), GFP_KERNEL);
-	if (!info)
-		return NULL;
-	sc = &info->socket;
-	scnprintf(wq_name, ARRAY_SIZE(wq_name), "smbd_%p", sc);
-	workqueue = create_workqueue(wq_name);
-	if (!workqueue)
-		goto create_wq_failed;
-	smbdirect_socket_init(sc);
-	sc->workqueue = workqueue;
-	sp = &sc->parameters;
-
-	INIT_WORK(&sc->disconnect_work, smbd_disconnect_rdma_work);
-
+	/*
+	 * Create the initial parameters
+	 */
+	sp = &init_params;
 	sp->resolve_addr_timeout_msec = RDMA_RESOLVE_TIMEOUT;
 	sp->resolve_route_timeout_msec = RDMA_RESOLVE_TIMEOUT;
 	sp->rdma_connect_timeout_msec = RDMA_RESOLVE_TIMEOUT;
@@ -1839,6 +1830,22 @@ static struct smbd_connection *_smbd_get_connection(
 	sp->keepalive_interval_msec = smbd_keep_alive_interval * 1000;
 	sp->keepalive_timeout_msec = KEEPALIVE_RECV_TIMEOUT * 1000;
 
+	info = kzalloc(sizeof(struct smbd_connection), GFP_KERNEL);
+	if (!info)
+		return NULL;
+	sc = &info->socket;
+	scnprintf(wq_name, ARRAY_SIZE(wq_name), "smbd_%p", sc);
+	workqueue = create_workqueue(wq_name);
+	if (!workqueue)
+		goto create_wq_failed;
+	smbdirect_socket_prepare_create(sc, sp, workqueue);
+	/*
+	 * from here we operate on the copy.
+	 */
+	sp = &sc->parameters;
+
+	INIT_WORK(&sc->disconnect_work, smbd_disconnect_rdma_work);
+
 	rc = smbd_ia_open(sc, dstaddr, port);
 	if (rc) {
 		log_rdma_event(INFO, "smbd_ia_open rc=%d\n", rc);
-- 
2.43.0

