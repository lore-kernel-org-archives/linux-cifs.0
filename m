Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4B228751B
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155896; cv=none; b=t+61kKTFkPHfvEK/9gDt0psCmzUuvJOaS/yoMJ9wNKpPy9wAurPXiz64aWAMH9PL47Fc4L/859bJhXuTJ0bXBjOC7X6A37qR4+AkkxQNsgDi+auAWqSIGUAwmUR973IdePzsXe6CuC+g50mVnj5/8Fc23vEmcf1xzKzk1DFRsEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155896; c=relaxed/simple;
	bh=kwQiNbRrYtnbXqvo4MWS+0PQ2dpdaS4PUeghV2Dggl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpJBPvfgrjmPIWq3AkFt5u1wbTKb1v4zZSCSwBB8z3faZisacvKZqhhYc350cWIiQUDGvr2LK7tSgKakk70/evji/Wd/DxTo59DPwqyh+3DYFoWHbPpU4TR+a1tPwIWQXruAkxq13Mz/tcI92Ps3UqK6j1clwitnjQP22yDB5x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Ve4BI09+; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Ve4BI09+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=esh5/BLG4ViP7Rsvd+k49zuMzjhOnNnug8OGAehW8i8=; b=Ve4BI09+1J8fBjweehNISuR8B6
	Et9yBTiAeCxrLaeu3iZQ4bZFG3pAIWOVb0A8ia475PRL3bsZc3SpJhRR9AafPmXoNEe+a3R2Wsm92
	M/b6yZFxS3KnPN9FxJ5ANYSYz/BVLBJiKkCDDx/82yVcGhUOtfi9NMqDZvE9s+6XMISo6x/TjxIQo
	pCC7+saXVPF8BzJWt2OaK+1n0e7VAeflKo6zYUHQNtBQG2juC534JCQpbgVLL1lpSqwL7Je+0Iemb
	7qWrKFtsjRwJvZMgBqXtP6qXKFiOR6wpIjeuIVaCTR5AV8rMFQltFHAwUKgmOb01A/QCFFraRcNib
	MmAvLvV+nCcNmQZWAcpNp5QBTESP2arVFZ8vEz2+r8hkVRbWBJhd5oqJzTpBMcSJsOO3qO9PO3HXB
	XDw7vY7SVi83R2JSkquH+J2Il8zeq3aY8JSYfBhFjD+GetmzxKRnoKyewL5bp08yxlQ64DeRadzl2
	SD3Yu00o5gYQhtmsqU5MVCzn;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeN1-000nps-35;
	Mon, 25 Aug 2025 21:04:52 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 138/142] smb: server: pass struct smbdirect_socket to smb_direct_create_header()
Date: Mon, 25 Aug 2025 22:41:39 +0200
Message-ID: <000a2540a9a4af06f09cabfae971f817fe163c9d.1756139608.git.metze@samba.org>
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
index 600c541a919b..0c11855a2a8a 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -995,11 +995,10 @@ static int calc_rw_credits(struct smbdirect_socket *sc,
 			    sc->rw_io.credits.num_pages);
 }
 
-static int smb_direct_create_header(struct smb_direct_transport *t,
+static int smb_direct_create_header(struct smbdirect_socket *sc,
 				    int size, int remaining_data_length,
 				    struct smbdirect_send_io **sendmsg_out)
 {
-	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_send_io *sendmsg;
 	struct smbdirect_data_transfer *packet;
@@ -1163,7 +1162,7 @@ static int smb_direct_post_send_data(struct smb_direct_transport *t,
 	for (i = 0; i < niov; i++)
 		data_length += iov[i].iov_len;
 
-	ret = smb_direct_create_header(t, data_length, remaining_data_length,
+	ret = smb_direct_create_header(sc, data_length, remaining_data_length,
 				       &msg);
 	if (ret) {
 		atomic_inc(&sc->send_io.credits.count);
-- 
2.43.0

