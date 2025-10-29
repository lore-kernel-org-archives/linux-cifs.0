Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5C0548EE
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744807; cv=none; b=DAZkL14dMND1D+R8VyHKrIiuLM+TT8tkxZZTZPbkIpenTCXj5gMPM9OZo3rQUyBvROvFfh+O8Fx5W9Qox9aUqXSCh+EJsD6fKh5qmElPk7Ma/PNNmFW9N17e9OIkidavZviqZAhie0vRB2T2mIlrJwm0oyGXRY6urEx2+5mBtHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744807; c=relaxed/simple;
	bh=koPSbEYCScpd3KWLBWMVBdsCyzoWYccArTcO4d/S+Ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tuECl/7jvlMSLbrmDqfoM0s9QE0E1RAehiLEvrs7RcYte/Wgp1Y/sOefsD8IjtIUjWtgryZX9mJnG9Gj2ZyIUGzzx2Bl/PMXbO4120vA2JaYebkXHdH6zMVtbdjYQIVbRvjl5Zy0ORxspHV4zPi60djMWWpJabMJYD2A41+AFTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=3t5xOq7b; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="3t5xOq7b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=QT0wcuyTVjBt2vovQItUScCBG/tc9d8Ct1i5N6thBNs=; b=3t5xOq7bd7cYTnjGxPJjV2fIYq
	Wq13aQG34ZRotDV6SCRDOJhkb3A28cC4D+J5Ig7yYsVg1MfYQ8Xtja6pevPuTg9eTg8wk+U5Sb1bI
	XMdoyr27+v+QSMI5bahqUY+CYCj/spxGxKmxiAacqaSbWwxTpuLrKWGxd7jwENKE45KqKgGVsk/Gm
	n8oKzbLxmIp/axxyVNWvURDEvrUm+BL6r829bgF7x9ZuzfqZrcfc1YytjBcNPmZ7q4eeVRC/TdCAb
	/z39DbXTJpJAL7Am/LbMmp/HKVhSdagfF96U+ZZ6y7VIvovmd+12RXipNYL+e+BAOR69njm7Z7+WV
	CW9PhrmcYGv2IktvfhsmtOt+w/LGr8ODjM9LYYGVS2037TBkIfoQq9RW5ASD0xiwiiP6bhTF0/keN
	mlXIzC6c+hKE+STHI82Nes0gHITV+hHPop90fB1O5uYGUnr8CxZyAtI/0t6vtZbgHMwEQbnZ8IVWZ
	yUK2bq9FCu6Ri4knHbAPliVX;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Ij-00BcuG-2c;
	Wed, 29 Oct 2025 13:33:22 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 108/127] smb: server: initialize recv_io->cqe.done = recv_done just once
Date: Wed, 29 Oct 2025 14:21:26 +0100
Message-ID: <3195bc5e016de833559acabea2bf65ad8ba6cf5b.1761742839.git.metze@samba.org>
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

smbdirect_recv_io structures are pre-allocated so we can set the
callback function just once.

This will make it easy to move smb_direct_post_recv to common code
soon.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 2f55764a5f2e..0919ef007602 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -547,7 +547,6 @@ static int smb_direct_post_recv(struct smbdirect_socket *sc,
 		return ret;
 	recvmsg->sge.length = sp->max_recv_size;
 	recvmsg->sge.lkey = sc->ib.pd->local_dma_lkey;
-	recvmsg->cqe.done = recv_done;
 
 	wr.wr_cqe = &recvmsg->cqe;
 	wr.next = NULL;
@@ -1761,6 +1760,7 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 
 static int smb_direct_connect(struct smbdirect_socket *sc)
 {
+	struct smbdirect_recv_io *recv_io;
 	int ret;
 
 	sc->rdma.cm_id->event_handler = smb_direct_cm_handler;
@@ -1777,6 +1777,9 @@ static int smb_direct_connect(struct smbdirect_socket *sc)
 		return ret;
 	}
 
+	list_for_each_entry(recv_io, &sc->recv_io.free.list, list)
+		recv_io->cqe.done = recv_done;
+
 	ret = smbdirect_connection_create_qp(sc);
 	if (ret) {
 		pr_err("Can't accept RDMA client: %d\n", ret);
-- 
2.43.0

