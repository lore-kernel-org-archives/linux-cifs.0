Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC822C11E7
	for <linux-cifs@vger.kernel.org>; Tue,  2 Dec 2025 21:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764710161; cv=none; b=e/o0qlEdaRRwgta7k4sJOlv2OmdR5PUsqKIEg+Gp0h9ul4Z8BpdgwETipnSXtmYLUvzpDazN8o1g6bWUyt3aT8lZtV7VfzL/ztNafkhARvfiYD1jS9XCb98jUhLi+XQJWr5qwPsoO2+OGv0VKZWJUN7aYARBElvVQ+AL6ids+dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764710161; c=relaxed/simple;
	bh=7EyTzbWEQaSCTHJOoP74PP1Qa7L9IkxC7b20vHicJ2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpT3zLidU8JepwqGhWdtKUG4YbwNCOkoEBnxkfAJM9g6D0tS9R/q6fUzlQFmLCZVTmhDv/cLtzmdE7AAAv70Lej+kwwYVtZQuRSUJJaMHsEsHqqB+Gfw4JLVg5dM8TFvUXIMWI7YKaydQ8poEJ7N/LAQ/4mr6+SQoU+TCCpLRt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=eZ1uqJbV; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="eZ1uqJbV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ETifBO0BRItXYdw2g8UEDYG5jajyOkRES59f2VUFBMk=; b=eZ1uqJbVLSNunOTtAIIH6+cjRE
	1tY2sYgWIvaASJZtkKIl+54Veud9peLCWJ98iVAPYDJkdxxaIzEhav6Mj2wSHmptllpTxaIGauJKn
	B6arNtV/2TvKVOdNVKrefrbS6WYaTF1W1Eb51NWwDZX3d4Vb9V2A0z6Dl75yHYpjCyEewmF7sr89D
	fz9g43bC7FlX7JHvo8RzWyh/dUDS3bB2/OmeOZGBYQb8sjyQ955eTPFzjTskTEAnIfOcVa8Fk1Wt1
	C5LOVJmr5NxQQ4FfjS1HD5pikSaHbHeElBBs8OF1js4f3obWTnl8Z+X3QlbkPs9s2doN29UjmVx6U
	WM0Na6yCpQRzrRPxFzmkis4AordC5NO7mN28C/Hkv+PPi81gFxeNVh/ChbD+jLouB19R1v5DuZEVJ
	BvmOte8RoILYXKRX+/vp8dJe0Ak1Lp9tWkvqHH5QGocURGxpYzo4+k2ySCMqeiWFb/SfaWq/HmWE4
	CWRxiMGqlRFPRzfs4RS6i7gw;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vQXj3-00Ghsx-0u;
	Tue, 02 Dec 2025 21:15:57 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [RFC PATCH 2/4] smb: server: initialize recv_io->cqe.done = recv_done just once
Date: Tue,  2 Dec 2025 22:15:25 +0100
Message-ID: <212a61f6053319e9114ebb55319dc0ad71c6204a.1764709225.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764709225.git.metze@samba.org>
References: <cover.1764709225.git.metze@samba.org>
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
index 4e7ab8d9314f..222d1b5365e8 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -758,7 +758,6 @@ static int smb_direct_post_recv(struct smbdirect_socket *sc,
 		return ret;
 	recvmsg->sge.length = sp->max_recv_size;
 	recvmsg->sge.lkey = sc->ib.pd->local_dma_lkey;
-	recvmsg->cqe.done = recv_done;
 
 	wr.wr_cqe = &recvmsg->cqe;
 	wr.next = NULL;
@@ -2339,6 +2338,7 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 
 static int smb_direct_connect(struct smbdirect_socket *sc)
 {
+	struct smbdirect_recv_io *recv_io;
 	int ret;
 
 	ret = smb_direct_init_params(sc);
@@ -2353,6 +2353,9 @@ static int smb_direct_connect(struct smbdirect_socket *sc)
 		return ret;
 	}
 
+	list_for_each_entry(recv_io, &sc->recv_io.free.list, list)
+		recv_io->cqe.done = recv_done;
+
 	ret = smb_direct_create_qpair(sc);
 	if (ret) {
 		pr_err("Can't accept RDMA client: %d\n", ret);
-- 
2.43.0

