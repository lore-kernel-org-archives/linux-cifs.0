Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3F528F1
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155686; cv=none; b=IJwgrgzcjlv4PHYBoZK+oQe6EJfXzBgB0AaF3Af5ElinlpXZdnd9z7exd19ymFBOKRhmI8ZsWeK5qD+PC+6kG84G9Q+NSyLWd+9Ke5UWKkQwgLmTKvKWS99yyT06fCA3ZnB9Sqs3GnuWWVL9BEvLwsIfhgiF3Q4xQgMetbwLPLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155686; c=relaxed/simple;
	bh=YmI20ycnZV6O3wT/gZguRkVbeXxWUX2EmAKrOnvIItU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lm1zSo2G3ObzxA/MXZIe0rWjQg0MMJvL/29CGl7N1kZntiZvvTsB/NbIe/4OZBpd/5qY1qURk1WOSwn0tzSixFQXb1U/Di2rifrWEQ0xmgT1Elz9M3/5qLA+RXVJTeHXCCZmYc4HI9TBegNMd8vTNjyTwbI2hYFNXIfS/++Pl5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=agdmsyM5; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="agdmsyM5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=+yutqYzfF3Lt8v1a3G4Z5pG3D461I4SJlOrP8aeosCE=; b=agdmsyM5qGhi5d72KkLPpJUsB8
	XZhHXnNOL8zV8PLYcX9rnkn8JrEb4M7Au+NBTrXYQFtOfApGb+WFy9XyDmAxB9bM/gyXaVMSoWnXG
	ntJ5uYPi98EyT6JWeV/E9u5hNAJMfNXsz6I5bDAP91QEnaYkr8a3QoJU5Uk01MagfDCbrp62/xG6+
	S57cmrb/mlr1BkrXt2yL4uMm+NwIFgMrb3993RB89PqOT0V3h+vsBGSc6yD+0pM/IddHPDopyYxZK
	gnPi2D1ZDHdC4jRCszCPMXrFV42YtZcUY5/FtYPG5bdcdopbsJMxl8ofVw/7OVxOkArmKauYBwU/s
	HxreqcKrOkhJQQOmbgUaOEDKfe/XCMt3K3B3HrdFmT+Y6rhgl+zk0TXEl0xRqaD5hhL8whAdbVkS4
	KDQn159+KKY/+jBDYE1VC48CmHbYTKD469IPtrcjqIzY4QLSDRSyd5irnTemnYM1MDRMHOmW8AjU8
	WVqVxy0HEr+vePgEBeM8q/lA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeJY-000n6W-2d;
	Mon, 25 Aug 2025 21:01:18 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 117/142] smb: server: pass struct smbdirect_socket to smb_direct_{create,destroy}_pools()
Date: Mon, 25 Aug 2025 22:41:18 +0200
Message-ID: <57eaa0bb38e89012940583dbc607ffc41c1cc15c.1756139607.git.metze@samba.org>
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

This will make it easier to move function to the common code
in future.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index a998f6c04aab..1aabd617c6ec 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -133,7 +133,7 @@ static inline int get_buf_page_count(void *buf, int size)
 		(uintptr_t)buf / PAGE_SIZE;
 }
 
-static void smb_direct_destroy_pools(struct smb_direct_transport *transport);
+static void smb_direct_destroy_pools(struct smbdirect_socket *sc);
 static void smb_direct_post_recv_credits(struct work_struct *work);
 static int smb_direct_post_send_data(struct smb_direct_transport *t,
 				     struct smbdirect_send_batch *send_ctx,
@@ -412,7 +412,7 @@ static void free_transport(struct smb_direct_transport *t)
 	if (sc->rdma.cm_id)
 		rdma_destroy_id(sc->rdma.cm_id);
 
-	smb_direct_destroy_pools(t);
+	smb_direct_destroy_pools(sc);
 	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
 }
 
@@ -1835,9 +1835,8 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 	return 0;
 }
 
-static void smb_direct_destroy_pools(struct smb_direct_transport *t)
+static void smb_direct_destroy_pools(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_recv_io *recvmsg;
 
 	while ((recvmsg = get_free_recvmsg(sc)))
@@ -1856,15 +1855,14 @@ static void smb_direct_destroy_pools(struct smb_direct_transport *t)
 	sc->send_io.mem.cache = NULL;
 }
 
-static int smb_direct_create_pools(struct smb_direct_transport *t)
+static int smb_direct_create_pools(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	char name[80];
 	int i;
 	struct smbdirect_recv_io *recvmsg;
 
-	snprintf(name, sizeof(name), "smbdirect_send_io_pool_%p", t);
+	snprintf(name, sizeof(name), "smbdirect_send_io_pool_%p", sc);
 	sc->send_io.mem.cache = kmem_cache_create(name,
 					     sizeof(struct smbdirect_send_io) +
 					      sizeof(struct smbdirect_negotiate_resp),
@@ -1878,7 +1876,7 @@ static int smb_direct_create_pools(struct smb_direct_transport *t)
 	if (!sc->send_io.mem.pool)
 		goto err;
 
-	snprintf(name, sizeof(name), "smbdirect_recv_io_pool_%p", t);
+	snprintf(name, sizeof(name), "smbdirect_recv_io_pool_%p", sc);
 	sc->recv_io.mem.cache = kmem_cache_create(name,
 					     sizeof(struct smbdirect_recv_io) +
 					     sp->max_recv_size,
@@ -1903,7 +1901,7 @@ static int smb_direct_create_pools(struct smb_direct_transport *t)
 
 	return 0;
 err:
-	smb_direct_destroy_pools(t);
+	smb_direct_destroy_pools(sc);
 	return -ENOMEM;
 }
 
@@ -2059,6 +2057,7 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 
 static int smb_direct_connect(struct smb_direct_transport *st)
 {
+	struct smbdirect_socket *sc = &st->socket;
 	int ret;
 	struct ib_qp_cap qp_cap;
 
@@ -2068,7 +2067,7 @@ static int smb_direct_connect(struct smb_direct_transport *st)
 		return ret;
 	}
 
-	ret = smb_direct_create_pools(st);
+	ret = smb_direct_create_pools(sc);
 	if (ret) {
 		pr_err("Can't init RDMA pool: %d\n", ret);
 		return ret;
-- 
2.43.0

