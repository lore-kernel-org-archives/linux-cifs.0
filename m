Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0A827A917
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155770; cv=none; b=CjgavHMjwGG9uECwseQwA4udoLHMcstOogYM+w3ggGVJHDbiM7ZBdj5I1ZZEhsyfxa5JX4BI1WekrFn8low76dPrCwFUbhpBoBusaL030p9BTEKRUFYzdVbLGbHQHXLyLLFYhTfnzY0ysCV2sbFlHRwVHBQTp2Qy+qFAt7UwcIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155770; c=relaxed/simple;
	bh=NiyxIXpoF21LJOtCOWuV1+L8SLGuEBF+0ihguy8f/GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvxCV3zo+i3ECSpg/0MZGZOAng63ou5/7TVrTO3OVpObcrSav+GkUrvV1pAE3AfEHL/RU6SgrcC+j1YG0NkA2ImzQrF8WhXBWSEcZx+i9MSDfbrbDVNseqgNafD+eBzOE5TN6ooWpchijiHI6kiyZkcr3C6iqMROH2kT/m68t1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Y3Vr0HS4; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Y3Vr0HS4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=AzoqKD4DGs+JKwATvoIbZq8BPrFHr4SsTooF+wy6t0I=; b=Y3Vr0HS495J+uJujNd9I8/jNyp
	ILjDVHQSjd5WdkGrI7f7shvth5uNpkw6YBjQhVhVYL4R/uDIbRteaYEv5vYoVo3vMB5hQ/Y8myrE1
	6ZqF3m+Mu+g1t/DBgEGZIgs8C0AIUhqL2zp8ZpVQVgfJJdkMRONlymD3mVFL0GpD+85qJkAW/qtTo
	9yMI/B3loXhS6p1sme2DCepRJOjfW7y+YFnsPp3LOBYzJU89Wf//KN7W+qmYJRdnhv1CxaN5a6EvG
	i+kP/Ggd/LBgkC20BR7A6lVnUMtWD3p5v6MNmZ57MjODTswltBMAmJxnYbYsgAS2Jw8Mj78s+iX9H
	kFh2VNK3fQ3YnI8z4+ScWg2d0fJ0KhKpsG1ypZuMnuOLRvy75mBDVVPqt3rrKb+24GZARNaU6mcST
	8JjCFIEfznbOwdxYrGjcVrQjHugK8qiVxOSlVNIVTXAatlYpmw2aHBO7dqw+ftRhsWJ2wP5iT/0e7
	dhaU4O+4/epsc7EA/5VhgwSn;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeKx-000nPv-2Q;
	Mon, 25 Aug 2025 21:02:44 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 126/142] smb: server: pass struct smbdirect_socket to smb_direct_prepare_negotiation()
Date: Mon, 25 Aug 2025 22:41:27 +0200
Message-ID: <1cb0d1dcf980ee599c1a8f1a1c30bdb4292fa788.1756139607.git.metze@samba.org>
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
 fs/smb/server/transport_rdma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 99a8e1b1860d..48f739af65e9 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1703,11 +1703,10 @@ static int smb_direct_accept_client(struct smbdirect_socket *sc)
 	return 0;
 }
 
-static int smb_direct_prepare_negotiation(struct smb_direct_transport *t)
+static int smb_direct_prepare_negotiation(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &t->socket;
-	int ret;
 	struct smbdirect_recv_io *recvmsg;
+	int ret;
 
 	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_CREATED);
 	sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED;
@@ -2063,7 +2062,7 @@ static int smb_direct_connect(struct smb_direct_transport *st)
 		return ret;
 	}
 
-	ret = smb_direct_prepare_negotiation(st);
+	ret = smb_direct_prepare_negotiation(sc);
 	if (ret) {
 		pr_err("Can't negotiate: %d\n", ret);
 		return ret;
-- 
2.43.0

