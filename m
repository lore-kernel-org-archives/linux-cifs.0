Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD1432FA13
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095575; cv=none; b=EZIYkC7wQY1z824gbo0W5pDfx8J4bLCXpL5Wn6JVmVU9Y5hvMrJ13noyX8HHP0sI9jX4NqBEmfeyzZJw4wDfFSC7kPEJF9gRxHFui5klwKxh6C541SsiLs08LEXtby8kbY+waV69b6EcqsqO1YkElQRFVG4jakF7n2yGTHwGJ1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095575; c=relaxed/simple;
	bh=hgSrCWtnjPlFjvRHsOQ2pxWNCfGEF4FLy264UTIpqa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWW6ma08YvOjSSN+XsF2TSRH9iyy2fWG2Y4UlhghkAxLKXK3fSYxpkSp9rdLvejrcB76e/cELFl+VAGF3F9qGCWB8wQ5swqGge/SBnh2eruJKbD2K4ZztAkJG/R3FEDQ2gBchW5ISYOeboqF9CszuuPXgrrkZHzwjKiK3muDomE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=p/FORkIh; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="p/FORkIh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=HeXhqlYf9fWcFDLT1id1nFuOueeCwtgSskqFUIh4hD8=; b=p/FORkIhC0bXgMgHbSTRcyh6v9
	djWLv6vQEPpFb8c5ErOH1YVvsiN2usb4sj03wd5SPcz16lTBkKzwsS3trQ8lOtlFbZNkPsPWKovhd
	KCRvYBZcRI1gBZpbsppFg80jOma7fT/cxBgqyjiJqKJP8ajLf+OXxDRU7EJ28FkR22q02lcXj/BcB
	PFEhmPUSHVURx90JwS4aZm30aZMAfcC0CH6aM6GZn8KrKmQY6guv5Kxyv4WKKBv3+zHkgWFGGuHfR
	gwLM4CjqnuWDo97YkSlTaMq5zLmdXwdP2HVwG0Sj5C7UAP6qGNR6boltAHkvmjTzA94/G/jfwbAlV
	DNXCg46eqpJuIuCy+gSBndrlWOHYYrzmf+5L+mmSqYehxjF/0a5vNVD1wryX7BmIiFTjlv58kTbyy
	tGXCBCE0LMu4W8NeiU3i8rQzNY8nPrBONywmPIRtUOrEtbEwbynEINvC2Jv2C3Y5JTa9/FYkii0yD
	OT33UbGZqVjCPwPCwq5GAXxD;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxn0-00Ffzo-1S;
	Tue, 25 Nov 2025 18:29:23 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 139/145] smb: server: no longer use smbdirect_socket_set_custom_workqueue()
Date: Tue, 25 Nov 2025 18:56:25 +0100
Message-ID: <2369db3e6594b7f995fbc7178e95a1500afbb355.1764091285.git.metze@samba.org>
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

smbdirect.ko has global workqueues now, so we should use these
default once.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/connection.c     |  1 -
 fs/smb/server/transport_rdma.c | 27 ---------------------------
 fs/smb/server/transport_rdma.h |  2 --
 3 files changed, 30 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index b6b4f1286b9c..66d6dab66ebe 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -505,6 +505,5 @@ void ksmbd_conn_transport_destroy(void)
 	ksmbd_tcp_destroy();
 	ksmbd_rdma_stop_listening();
 	stop_sessions();
-	ksmbd_rdma_destroy();
 	mutex_unlock(&init_lock);
 }
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index c261082ff9c7..15559227ad69 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -78,8 +78,6 @@ static struct smb_direct_listener {
 	struct rdma_cm_id	*cm_id;
 } smb_direct_listener;
 
-static struct workqueue_struct *smb_direct_wq;
-
 struct smb_direct_transport {
 	struct ksmbd_transport	transport;
 
@@ -211,9 +209,6 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	ret = smbdirect_socket_set_kernel_settings(sc, IB_POLL_WORKQUEUE, KSMBD_DEFAULT_GFP);
 	if (ret)
 		goto set_settings_failed;
-	ret = smbdirect_socket_set_custom_workqueue(sc, smb_direct_wq);
-	if (ret)
-		goto set_workqueue_failed;
 
 	conn = ksmbd_conn_alloc();
 	if (!conn)
@@ -231,7 +226,6 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	return t;
 
 conn_alloc_failed:
-set_workqueue_failed:
 set_settings_failed:
 set_params_failed:
 	smbdirect_socket_release(sc);
@@ -508,21 +502,8 @@ int ksmbd_rdma_init(void)
 		return ret;
 	}
 
-	/* When a client is running out of send credits, the credits are
-	 * granted by the server's sending a packet using this queue.
-	 * This avoids the situation that a clients cannot send packets
-	 * for lack of credits
-	 */
-	smb_direct_wq = alloc_workqueue("ksmbd-smb_direct-wq",
-					WQ_HIGHPRI | WQ_MEM_RECLAIM | WQ_PERCPU,
-					0);
-	if (!smb_direct_wq)
-		return -ENOMEM;
-
 	ret = smb_direct_listen(smb_direct_port);
 	if (ret) {
-		destroy_workqueue(smb_direct_wq);
-		smb_direct_wq = NULL;
 		pr_err("Can't listen: %d\n", ret);
 		return ret;
 	}
@@ -543,14 +524,6 @@ void ksmbd_rdma_stop_listening(void)
 	smb_direct_listener.cm_id = NULL;
 }
 
-void ksmbd_rdma_destroy(void)
-{
-	if (smb_direct_wq) {
-		destroy_workqueue(smb_direct_wq);
-		smb_direct_wq = NULL;
-	}
-}
-
 static bool ksmbd_find_rdma_capable_netdev(struct net_device *netdev)
 {
 	struct smb_direct_device *smb_dev;
diff --git a/fs/smb/server/transport_rdma.h b/fs/smb/server/transport_rdma.h
index e16f625caed2..05352dc47f95 100644
--- a/fs/smb/server/transport_rdma.h
+++ b/fs/smb/server/transport_rdma.h
@@ -14,14 +14,12 @@
 #ifdef CONFIG_SMB_SERVER_SMBDIRECT
 int ksmbd_rdma_init(void);
 void ksmbd_rdma_stop_listening(void);
-void ksmbd_rdma_destroy(void);
 bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
 void init_smbd_max_io_size(unsigned int sz);
 unsigned int get_smbd_max_read_write_size(struct ksmbd_transport *kt);
 #else
 static inline int ksmbd_rdma_init(void) { return 0; }
 static inline void ksmbd_rdma_stop_listening(void) { }
-static inline void ksmbd_rdma_destroy(void) { }
 static inline bool ksmbd_rdma_capable_netdev(struct net_device *netdev) { return false; }
 static inline void init_smbd_max_io_size(unsigned int sz) { }
 static inline unsigned int get_smbd_max_read_write_size(struct ksmbd_transport *kt) { return 0; }
-- 
2.43.0

