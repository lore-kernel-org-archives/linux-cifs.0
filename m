Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDE23271E4
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744491; cv=none; b=UHrMSYbVom0i2R2rDM4pb2qKogjmmSioswtVqh13HZ1sMXTkm7jv6DGU9YhrPJaCDog16LjUBBgGRLEArjBT4nKrNiufLN/tpZam5sbEqeSjPoWDip9K/jfXu8N7KidD/dy2s1g0lQvpPntq/LlE+ek3JNdAe0tIDKJ2WiqSzcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744491; c=relaxed/simple;
	bh=1BIvgBJiJzYv+n+GUJE4LUtMcMffaeome6/h0NpS6Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJQ/IHM7rbzQOzK58XHoZgG3sXPWvrhEMBiQrXlkjPpZ03c9Hg8JHsGnuQFHkJYUKhSdAGZkcXVRBiwsgarFXqJWNB8JsW3zJcaWAb10Jtp6rQg5m3HcyXX5uEnz6jkIYVO5Q1nHWTgQtSIVmGBbim+bE0/qcXmidkM2RXX/ec0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=2QK2Z+SL; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="2QK2Z+SL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=OFRXOkz2qoXM+EZMcIUL0vN6PbqKZbBqNyw2hIqeExw=; b=2QK2Z+SLFYokLBdZiJy2BnkEjV
	jwvA4ezh3+VRe1bIryvtJAm4QkpN6QQiuodQHjI6zEkNGVs3wAPysL78g/A3ZHq/h82MKGh+5cK9p
	H7jnTfi0u6RhueIXtNMvvM6yFdZNkZRnvI4DnPSshvHvklN1sRotsveQ4iH1kUE25hr+FzWATjBaR
	vtSF51WI3OFjb3gdxUxW9cZvZ+kO2X0RW54Kg3k7Y7UpMwxo3liIptyufsSLYLw8UFmNuFqHv+Bu7
	LNXNNYcv60XSUjtxWC4O+jiZO7woayr3XGvIcIWWKOnDCePFMocPr7JfKS1WY4ff3IPPCz3vjD5NU
	YIDgtc9mcksMMdv3STC0TG5sMH2gZCzQWNMInmAKkemEJCqYiDJbt4C3rm+zK6PneOsygUepQ5HxV
	PDe+Oc/+HXR3Nzylkzy4FmSZoe/0VdMNgLlZU0ErGhr5nOsV1Mmi0Nme6PBLSvSc5I4bgU6GRlSDh
	dmIYOp4Qt/y9d3WY7pQOakju;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Df-00Bc35-05;
	Wed, 29 Oct 2025 13:28:07 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 057/127] smb: client: make use of smbdirect_socket_prepare_create()
Date: Wed, 29 Oct 2025 14:20:35 +0100
Message-ID: <33fceea3c3f2155f27db17909557b6fc4008f858.1761742839.git.metze@samba.org>
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
index 5ae22c8dea81..04a90fd0971c 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1793,6 +1793,7 @@ static struct smbd_connection *_smbd_get_connection(
 	int rc;
 	struct smbd_connection *info;
 	struct smbdirect_socket *sc;
+	struct smbdirect_socket_parameters init_params = {};
 	struct smbdirect_socket_parameters *sp;
 	struct rdma_conn_param conn_param;
 	struct ib_qp_cap qp_cap;
@@ -1803,20 +1804,10 @@ static struct smbd_connection *_smbd_get_connection(
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
@@ -1832,6 +1823,22 @@ static struct smbd_connection *_smbd_get_connection(
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

