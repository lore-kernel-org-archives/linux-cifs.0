Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1A81F30A9
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094943; cv=none; b=PbyzHzX7lOTPowZnpvIb8BcK48Z+vqTWmrRsTlc+XzQiaj2VMG//mvSaGpaLlRnr/sbhNLW51tTFtYzlXOS4/j3/x0FoyMUiY4OMlY6sKuxxUG4jQk4mAM6eyOoyoDUszuLolcaqO+NgShlSy1GvIhK0Mn3kVhD3vG7xWDlWoFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094943; c=relaxed/simple;
	bh=ErCBzH1KDN/CRkkTeYP7RRPF2BS3CqRI/r+d0c2BACw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaLnMYhJEidpammYLUU8LgFAQKXiJ7C2gI3kRo+r0iw6ZH3oHFtIU/ZjccBNIZCnhSYspj0FUxAP0DK/sENdAra7THkCKJyakFttLA3zde5wcU/ZzY7pV+5zhYDQnI7glUZobL5m3NhyZ/8pqNqdPilgguyiEv1XGN7FKz6amdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=k5c+JGOK; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="k5c+JGOK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=5UiHmF5qdnfn3Z/sWHoIjWsSJReGVGhwC9wdigR0CU8=; b=k5c+JGOKrx4IIoQWLOOboZB7Kr
	ctav8aOGAnJOrrM/f1yP6+G+wN6Og9djVgtk3YWaDMubnmOQFg6jUD/uRUCSwVo1UUtS2bwR0zZfP
	n/XUXLM79UInCSJKhBlektvAmiFocPC5qWCqeMhbm7/rzrVYbRtkzxxjAsVzgvzc5spfNhB0V/05g
	J11lxZEqtYkAEI1K8cr4Zc0CYvgb56cv5r47oIjFPN/PD4LXlmTlLecX7r0mWI3mWvv8Ftnc8wHaY
	ZoEcgtLO47uSgrUq9xN1m42zr1rZhaes1RxfXnq3BB1aRDDx29b0EcRFAET2WCU4RI9cCOZgjFbRm
	AU7y0sLa9hGMhFrGy7rHpblcx0jzvD8oC/dvh5oFnbIji65VOj/XWrSO9O69Q+XMTFYiTqAq4Ya+d
	19R7JbdqNJbNOCZVGwt5UPzZc9jBpt8qTe4SFJpyKqH7rE9cVfx1TIbkukmvU9AqUBLqMqFo+8MwV
	0dwHW65Jhsa5bZ1kOJGRGY0E;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxdA-00FeWk-0o;
	Tue, 25 Nov 2025 18:19:13 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 114/145] smb: server: initialize recv_io->cqe.done = recv_done just once
Date: Tue, 25 Nov 2025 18:56:00 +0100
Message-ID: <6d9ae90aacbe51bf229020f703bcc3c6538a9331.1764091285.git.metze@samba.org>
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
index ffcfd9f859bf..e0a39558ebff 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -558,7 +558,6 @@ static int smb_direct_post_recv(struct smbdirect_socket *sc,
 		return ret;
 	recvmsg->sge.length = sp->max_recv_size;
 	recvmsg->sge.lkey = sc->ib.pd->local_dma_lkey;
-	recvmsg->cqe.done = recv_done;
 
 	wr.wr_cqe = &recvmsg->cqe;
 	wr.next = NULL;
@@ -1792,6 +1791,7 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 
 static int smb_direct_connect(struct smbdirect_socket *sc)
 {
+	struct smbdirect_recv_io *recv_io;
 	int ret;
 
 	sc->rdma.cm_id->event_handler = smb_direct_cm_handler;
@@ -1808,6 +1808,9 @@ static int smb_direct_connect(struct smbdirect_socket *sc)
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

