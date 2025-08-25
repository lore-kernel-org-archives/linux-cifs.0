Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3A822128B
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155589; cv=none; b=HzqTEXa0hqhjKqH4ll4tFijgWdfnFlYgeYvksqnSeVdLPS4UPEum0OfjjkqIH4ik6u6MdkgRLSI/kZ6vgJY20a2uVGKlkBuXFzKcdOM4cB58KJi/P6OMnSeu0er2MP/Zp8xNPV2AT4Ggd5D0WA6ZSFhy6khHikRNDbj045uR4hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155589; c=relaxed/simple;
	bh=kLRV96JYmiMoEOSc+6tejUa+ktO40BPIS4Qcj+tWHIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2OMBJK/W0VO+IcbPoauCna2OZ//FwDblzsdZq4xttcocuOlP4gYEov1ZzozTVemNcjNg1CHT1V/bwkgtFRWxef8X4qVwMw+CqqrmfkG6WWVJJyOKhPA67wq1ypIhuhHFWxXRGNuZnF4mO/XKW/Ixjg4HgrVCS19zIMfQzISAKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=nPNbd66J; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="nPNbd66J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=/RudlnxUmyv6elk/2DrnFDeTcQ6ZWQqtoAd5KhuXTEk=; b=nPNbd66J9A6Hbv2Gs7EntCrhty
	bAjPEhDoauuwWYa0uOHiKcSbYi5GYYITKB7/n22lgH/9/zCVb0z4R34yUgp81qdr+cy0WDQjqozMP
	Djz6DQpB4+O2wbp3k65XiNadefMJG7ktTUUD11fh4vtQFEaLUoyu5OkeQRXfIv1e1Zyd0UEkUZUkK
	4uGIkMaLvYVuumpe2JjeHSYvlS9VbOZV5HT3hnGHzjNugrL7yIuF6VsbX/K/Ciu/PdK+wb6wkaYyD
	166pJrKSblMn1HeiADF1VdOONn/bjFcKaDX6weCXA/JiR0i8TzbzTz1sPbBatWYzBieRQkAAzWDX8
	Gy/qzm9HOkSjb/7NI2weRw+Pc2vevpGQL/22m+U2hZ+qd8enALk2Y8rMnPkkm8hGJojbkMW3pGcPq
	bq7750PIOOMlCzGBidwztkfy3+IULrOBHcTPZN7dREJg4uWcrLP8tEAy0vLcv6hlmZJK6qyHwdHdh
	1ky/zRJVt3zn5qau/4uG+Syy;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeI3-000mno-2s;
	Mon, 25 Aug 2025 20:59:44 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 108/142] smb: server: pass ksmbd_transport to get_smbd_max_read_write_size()
Date: Mon, 25 Aug 2025 22:41:09 +0200
Message-ID: <0c4b9bfb8da62e004e578e485b8b3a2557e5524c.1756139607.git.metze@samba.org>
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

We should use the per connection value.

And for TCP return NT_STATUS_INVALID_PARAMETER if any
SMB2_CHANNEL_RDMA_V1* is used.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/smb2pdu.c        | 12 ++++++++++--
 fs/smb/server/transport_rdma.c | 15 +++++++++++++--
 fs/smb/server/transport_rdma.h |  4 ++--
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a0ffd49d611a..8cc747a4c6c6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6759,7 +6759,11 @@ int smb2_read(struct ksmbd_work *work)
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
 	    req->Channel == SMB2_CHANNEL_RDMA_V1) {
 		is_rdma_channel = true;
-		max_read_size = get_smbd_max_read_write_size();
+		max_read_size = get_smbd_max_read_write_size(work->conn->transport);
+		if (max_read_size == 0) {
+			err = -EINVAL;
+			goto out;
+		}
 	}
 
 	if (is_rdma_channel == true) {
@@ -7017,7 +7021,11 @@ int smb2_write(struct ksmbd_work *work)
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||
 	    req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
 		is_rdma_channel = true;
-		max_write_size = get_smbd_max_read_write_size();
+		max_write_size = get_smbd_max_read_write_size(work->conn->transport);
+		if (max_write_size == 0) {
+			err = -EINVAL;
+			goto out;
+		}
 		length = le32_to_cpu(req->RemainingBytes);
 	}
 
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 09838efa12bd..b65215b4dd76 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -111,9 +111,20 @@ void init_smbd_max_io_size(unsigned int sz)
 	smb_direct_max_read_write_size = sz;
 }
 
-unsigned int get_smbd_max_read_write_size(void)
+unsigned int get_smbd_max_read_write_size(struct ksmbd_transport *kt)
 {
-	return smb_direct_max_read_write_size;
+	struct smb_direct_transport *t;
+	struct smbdirect_socket *sc;
+	struct smbdirect_socket_parameters *sp;
+
+	if (kt->ops != &ksmbd_smb_direct_transport_ops)
+		return 0;
+
+	t = SMBD_TRANS(kt);
+	sc = &t->socket;
+	sp = &sc->parameters;
+
+	return sp->max_read_write_size;
 }
 
 static inline int get_buf_page_count(void *buf, int size)
diff --git a/fs/smb/server/transport_rdma.h b/fs/smb/server/transport_rdma.h
index 63eab9f8f13d..3f93c6a9f7e4 100644
--- a/fs/smb/server/transport_rdma.h
+++ b/fs/smb/server/transport_rdma.h
@@ -17,14 +17,14 @@ void ksmbd_rdma_stop_listening(void);
 void ksmbd_rdma_destroy(void);
 bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
 void init_smbd_max_io_size(unsigned int sz);
-unsigned int get_smbd_max_read_write_size(void);
+unsigned int get_smbd_max_read_write_size(struct ksmbd_transport *kt);
 #else
 static inline int ksmbd_rdma_init(void) { return 0; }
 static inline void ksmbd_rdma_stop_listening(void) { }
 static inline void ksmbd_rdma_destroy(void) { }
 static inline bool ksmbd_rdma_capable_netdev(struct net_device *netdev) { return false; }
 static inline void init_smbd_max_io_size(unsigned int sz) { }
-static inline unsigned int get_smbd_max_read_write_size(void) { return 0; }
+static inline unsigned int get_smbd_max_read_write_size(struct ksmbd_transport *kt) { return 0; }
 #endif
 
 #endif /* __KSMBD_TRANSPORT_RDMA_H__ */
-- 
2.43.0

