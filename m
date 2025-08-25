Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D2128F1
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155811; cv=none; b=d/wQi943Nq5WOSJ5zndaGW+e27ytTyFd8MhUkgIsC4lS2H9CRbrnlWuOLel9/npcKXkqhy7kA4aeLvjyk8ypJQi+owH23o7zOg7ZMYtwjdOiTYmFVD07h9t1BNLVaKHcbQznUToIvx7TLPgbh58ZlEu8xMf6oMkWRKXEBT6AWak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155811; c=relaxed/simple;
	bh=jNo2rtiURR3hP4b2/vf8mezRPSB/HbiCbQmhoJFhX+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgctxtezvIhxF2PTK1n8C8iNHYVkDN+A4J2fvw/JUC3ClXVm+LLzJOkMwdWYkJO7yCFcl2FhsYxKQwqExcYMwQ/OXaAqbF45uPH13iacGSJSNgZDA999kEba6ypr7ng8lSqPtQ/0+w4jOKuftofMXw8yhUwOlm1j7Ms+I5mwYWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=g54lGSxD; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="g54lGSxD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=oS0yl2nXy+V3u5sMzkpR/in8rkDR0nCAj3OeM8LHdtE=; b=g54lGSxDGwvdYhlTiQJBU239tQ
	n/qbbee2D2yY+JZcw6zl2jSWCvezBD1J668l8YwvR4jTjMDI4jTypy6m7XNIZdusfzVWexRNxS/yC
	s5ilN3SyCl3PtcYLdT08DNFkcot8K8K+CXZmn/GUd9xjdTon10qR1g6n0lcw1W9HMxYhJ+LgCMMST
	LYNt83DDchkNrwq6WJ3Baw+QvnL4e5Ntctd+lE/uq08vjfrNoafJapv9u3d/drR8KQQnaGuykWdh7
	DEhKrFLlQdqM8GrHA3QTLdJSI2DqXdA1H0QDKJ1cTSWnunXzxdJSmK93tF5+bGAVXMdkFLVl2UWkA
	kV60itUTjs9Ah0Atc+xBISSZJfMWjr391riJBqkprq9FaSx7bCQU7OBKybc3SBQ43K+QFTh0HfJMZ
	Ru/tqHM5HrGt2V0dVzxV6g+pf2E73xpX3RjLfQj2wCmgsitz9i7K9F6t70qut5jH7pITAmWzx77qp
	yvMSl3q5fpIUnnmMLtDNDmoP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeLf-000nYA-13;
	Mon, 25 Aug 2025 21:03:27 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 130/142] smb: server: pass struct smbdirect_socket to smb_direct_post_send()
Date: Mon, 25 Aug 2025 22:41:31 +0200
Message-ID: <1228751a1156b983be3631088e2f84402b022593.1756139607.git.metze@samba.org>
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
index d2e587ae3931..d29afc4be6a7 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -879,10 +879,9 @@ static int manage_keep_alive_before_sending(struct smb_direct_transport *t)
 	return 0;
 }
 
-static int smb_direct_post_send(struct smb_direct_transport *t,
+static int smb_direct_post_send(struct smbdirect_socket *sc,
 				struct ib_send_wr *wr)
 {
-	struct smbdirect_socket *sc = &t->socket;
 	int ret;
 
 	atomic_inc(&sc->send_io.pending.count);
@@ -931,7 +930,7 @@ static int smb_direct_flush_send_list(struct smb_direct_transport *t,
 		last->wr.ex.invalidate_rkey = send_ctx->remote_key;
 	}
 
-	ret = smb_direct_post_send(t, &first->wr);
+	ret = smb_direct_post_send(sc, &first->wr);
 	if (!ret) {
 		smb_direct_send_ctx_init(send_ctx,
 					 send_ctx->need_invalidate_rkey,
@@ -1151,7 +1150,7 @@ static int post_sendmsg(struct smb_direct_transport *t,
 
 	msg->wr.wr_cqe = &msg->cqe;
 	msg->wr.send_flags = IB_SEND_SIGNALED;
-	return smb_direct_post_send(t, &msg->wr);
+	return smb_direct_post_send(sc, &msg->wr);
 }
 
 static int smb_direct_post_send_data(struct smb_direct_transport *t,
-- 
2.43.0

