Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A3B1DF271;
	Sun,  1 Mar 2026 01:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330059; cv=none; b=TllaaarEAgM66rW4nU3XWIrv5AyVvHJ2nE5fF0QP1QZwrU7L60i2N+x4RR/2A+/HobN7DyEpI2JdC/+QnFUBSPI8lO9OG51oLx8mvmjkJL+j03pvKMeQ1uKBbYs2dMhg3y/6QPf84WVicQmcMhGaXO0vbNl5tWqRPmkwPQPrcP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330059; c=relaxed/simple;
	bh=iwsGN2X4Kn1L0gMHvYMwJxbCVzKf49fqI0at07YcD2I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kBnITo21sty7B4576o8xM0J+4mDMaRmaFQKTwJ7L3Tzy5vrwUbgK4X3cAIAiXORH0kp0tehsfd3SCaZ+sL6RbOUtHENbA7O93e8Ay178j2IlHDMaZxPR+8XwpS+xMJdv93AzGrWadCtgORjFEIPrZTqbp3P59FYWgGxxV3GDOmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=THyKzjrq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="THyKzjrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD67C19421;
	Sun,  1 Mar 2026 01:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330059;
	bh=iwsGN2X4Kn1L0gMHvYMwJxbCVzKf49fqI0at07YcD2I=;
	h=From:To:Cc:Subject:Date:From;
	b=THyKzjrqvEdoI0/pI7ZXWVZWvxttIHIZNmyEO7o1bR6r+dsWgkRrlaeLalET0Gh5R
	 Finr3t59GtzRElOVERH7HpDWyW3EnYl1Ljfl9MbSSiNP9EXPgH8ZhLmpMcCCtq5Kfw
	 H3OXqHGZWVljrJk1QRqeEUfwXrEY96x5BLCMHbInvcWGqivi/GyQIQRg32MAfGiIl3
	 UtEWX5OVrHEfXBAzzZrbk2H2KCD6arwWStZm7dHDMGu0OhxduRaWKR37PdjncEWK4d
	 KlHf7Jij/yqxVqy17aBlDO+j3pQ3DF0IHnBilH9rSu5JcfUCgq1AlHjnXHpepIF6RN
	 Je2HKZyy743lg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	metze@samba.org
Cc: Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: FAILED: Patch "smb: client: let smbd_post_send() make use of request->wr" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:54:17 -0500
Message-ID: <20260301015417.1721258-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From bf1656e12a9db2add716c7fb57b56967f69599fa Mon Sep 17 00:00:00 2001
From: Stefan Metzmacher <metze@samba.org>
Date: Thu, 22 Jan 2026 18:16:50 +0100
Subject: [PATCH] smb: client: let smbd_post_send() make use of request->wr

We don't need a stack variable in addition.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 61693b4a83fce..f2ae35a9f047f 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1105,7 +1105,6 @@ static int manage_keep_alive_before_sending(struct smbdirect_socket *sc)
 static int smbd_post_send(struct smbdirect_socket *sc,
 		struct smbdirect_send_io *request)
 {
-	struct ib_send_wr send_wr;
 	int rc, i;
 
 	for (i = 0; i < request->num_sge; i++) {
@@ -1121,14 +1120,14 @@ static int smbd_post_send(struct smbdirect_socket *sc,
 
 	request->cqe.done = send_done;
 
-	send_wr.next = NULL;
-	send_wr.wr_cqe = &request->cqe;
-	send_wr.sg_list = request->sge;
-	send_wr.num_sge = request->num_sge;
-	send_wr.opcode = IB_WR_SEND;
-	send_wr.send_flags = IB_SEND_SIGNALED;
+	request->wr.next = NULL;
+	request->wr.wr_cqe = &request->cqe;
+	request->wr.sg_list = request->sge;
+	request->wr.num_sge = request->num_sge;
+	request->wr.opcode = IB_WR_SEND;
+	request->wr.send_flags = IB_SEND_SIGNALED;
 
-	rc = ib_post_send(sc->ib.qp, &send_wr, NULL);
+	rc = ib_post_send(sc->ib.qp, &request->wr, NULL);
 	if (rc) {
 		log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
 		smbd_disconnect_rdma_connection(sc);
-- 
2.51.0




