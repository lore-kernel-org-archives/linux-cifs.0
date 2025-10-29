Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115BE2512F1
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744566; cv=none; b=fO690Bs3Q4zJCZBo0jHHX8KvF9q0Ib/N23eiLDPusweJlORx4PHFXG+kHYx1Q2gwrf/V47nSeMbgdKRHGecZMGXQs1Sb3wJgR7YhH9XdLqV+4JVI9RVQiRt81TIdCBpI4ZIfIqmYof7p305IT9q0sJAJd07rloZT7M5B4wF1CSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744566; c=relaxed/simple;
	bh=FBVcBEhN6n83/yj3zBvIj1a/cWSNaK5+yl2LrYXgYdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3PKj2vq7uAHPja8KF1gxCSwKfeA4h7+utJC6UI9Sd4NAue1pShf/7QCHSy7f3+gWQE90B1vCF364mUosNiXB8Q/Sd4FDVaZ/stxZufMszFsYSJY6/fnSkzF8lkhzh4C/zCUf0P4DVHYmcTthr668A9MCZ089vCRP85bVXK+x84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=dDBrKF5n; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="dDBrKF5n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=xwmdRwumXMGb+fJQetHzL5yN5CsEsyORP95k/Oe/bYI=; b=dDBrKF5n1/j4vG/9ngdl4hAcyR
	TrR0lUOJWbrU2hxcF+q3t9cc9z7ri0Dl/zEHKFFnUsLEFldLEDuQ+0ThcxbO25c14807F1kDVGRWG
	4dKWFXS1Um5fv4/VzexJYX2tj5E7W+PJleXrlGIdC6VmzMdwGALsQh1RIO6U168buzBU+RbdRCqrd
	M+T7klxqOwo2t8PmL+ao8x63CSiCN/uEbe++wM8OU5/kiYeUhu4YIUQ67RLxyNaghfP10RbpdJ0Sw
	aXvsdd0vzLmvRdZIxyV542dK7A3VWwnh0ZVSlYfbsiiaWxgt23BCldf5bXlxJulZal5D3TSnC9rUJ
	HhyznXrLxjky7sIsioKI5/1ggUKMWuWNPkqeD1ijbTai7iHwywvI83KSRID7iCBbYeo5p9xDACjDs
	0mrRCWCDXMzr+sXclXcYaUbE/wSE1ad2VPdxt3+FdMrwF+76h93Nc4NCaJq9qi3CZ0oOa47+POMx2
	LZ/jVqlAximDrILaRozlzMl7;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Es-00BcEw-0s;
	Wed, 29 Oct 2025 13:29:22 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 070/127] smb: client: make use of smbdirect_connection_qp_event_handler()
Date: Wed, 29 Oct 2025 14:20:48 +0100
Message-ID: <68c644c4660b5f908e3dd1b0203c261bf30adef8.1761742839.git.metze@samba.org>
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

This is a copy of smbd_qp_async_error_upcall()...

It will allow more code to be moved to common functions
soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 19971f7c4670..9326023c4afc 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -343,26 +343,6 @@ static int smbd_conn_upcall(
 	return 0;
 }
 
-/* Upcall from RDMA QP */
-static void
-smbd_qp_async_error_upcall(struct ib_event *event, void *context)
-{
-	struct smbdirect_socket *sc = context;
-
-	log_rdma_event(ERR, "%s on device %s socket %p\n",
-		ib_event_msg(event->event), event->device->name, sc);
-
-	switch (event->event) {
-	case IB_EVENT_CQ_ERR:
-	case IB_EVENT_QP_FATAL:
-		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
-		break;
-
-	default:
-		break;
-	}
-}
-
 static inline void *smbdirect_send_io_payload(struct smbdirect_send_io *request)
 {
 	return (void *)request->packet;
@@ -1478,7 +1458,7 @@ static struct smbd_connection *_smbd_get_connection(
 	}
 
 	memset(&qp_attr, 0, sizeof(qp_attr));
-	qp_attr.event_handler = smbd_qp_async_error_upcall;
+	qp_attr.event_handler = smbdirect_connection_qp_event_handler;
 	qp_attr.qp_context = sc;
 	qp_attr.cap = qp_cap;
 	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
-- 
2.43.0

