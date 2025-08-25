Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CEC28F1
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155741; cv=none; b=Otlz7UArCoLTwy8GmSmiPgLFK69m1I4mGl5iiE4i71hj0h83uZX31752BfWNVIr6c530nBTYtBchuG5e0+Mx4/sk6p8Qj9ogscV2I8vE/ycB7z63MKFzGsDkpHWBhq92AyY4T0V3xgkavgPDMpD7bfS0iSvsJGFRC40Nx/dtWIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155741; c=relaxed/simple;
	bh=+ukUqo7Psy6hLrP67S+Mx8e7QK1MQuUeQaAdkCF9+CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfsgMzpiEh41DjukaBKpzQd4GCqIr58s0Ws/I0oEpdBHux+NXxL16IgwYwx+/HmhhGR5jO3I7uaTvZWNVhRvZu7zfTXcewreB9aklL9FHH9Jd2JVlGi5d4rvDhqbL0PtiPlH+6Wo8ViH8BGDwpHZn8GvKKz5oJPEQVJx6EaftCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=1hvp/0H8; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="1hvp/0H8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=uOxATc5RifhFc2jk29RQKrrLWNJmkAYe3y/vjGX65BY=; b=1hvp/0H87oLN+YeDPGvJjA85E2
	2BICWsWsTuX16kVa9bK9f3466xDbqN7vDI0e9tvIKFLzleYI3pVjTIq8okbJ8CXLWpUj1gOkr7j0G
	hfyA7CyouaLYuy4GESYG3jtckOf4rloMQJTT/S8mbmkJp9ovuSQSYYWQjAepSkW83Jts1grEMSwKJ
	MDzBdrEcDBGTRQi114T0U+yqT2fxnpdwEswNJvLQtLVShyFLLSfycgdPBM1B55z/98ktMe1m4M3Qq
	QKad3YNyS9RIFi5wa2NvklY7spnx2tt+UMuLI/uPWQ4Lo3qAuAikm1E6dAvYy7Um83BrKc8/mje3n
	/gNeDzZHX4LxgQhrlNjQpxD/Fyyvj/lvDy7GcaY5vb9NNt/BJ4QAXYyFj28nxpB6ZlhAeoNgddn+K
	/xio2MGE5rcr9BC0GQXLhoAul9i9x34HNtrqIwoysdP7I4QiMDPtxf1IRVJUqJqHVDZ/jspRgqZTQ
	zmkeH+1vznPrcsrx6MmC9Pyg;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeKW-000nJV-0p;
	Mon, 25 Aug 2025 21:02:16 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 123/142] smb: server: pass struct smbdirect_socket to smb_direct_create_qpair()
Date: Mon, 25 Aug 2025 22:41:24 +0200
Message-ID: <16f843d5c32cc39176d4cfe3f85569ad09826f16.1756139607.git.metze@samba.org>
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
 fs/smb/server/transport_rdma.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index c3be52f251c4..2650c6c5e1af 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1894,10 +1894,9 @@ static int smb_direct_create_pools(struct smbdirect_socket *sc)
 	return -ENOMEM;
 }
 
-static int smb_direct_create_qpair(struct smb_direct_transport *t,
+static int smb_direct_create_qpair(struct smbdirect_socket *sc,
 				   struct ib_qp_cap *cap)
 {
-	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	int ret;
 	struct ib_qp_init_attr qp_attr;
@@ -2062,7 +2061,7 @@ static int smb_direct_connect(struct smb_direct_transport *st)
 		return ret;
 	}
 
-	ret = smb_direct_create_qpair(st, &qp_cap);
+	ret = smb_direct_create_qpair(sc, &qp_cap);
 	if (ret) {
 		pr_err("Can't accept RDMA client: %d\n", ret);
 		return ret;
-- 
2.43.0

