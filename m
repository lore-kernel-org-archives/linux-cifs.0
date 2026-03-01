Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBDE19CD19;
	Sun,  1 Mar 2026 01:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329044; cv=none; b=WM1Tme2P8lH5RwFsLTs+DqMK55Loe7RmROe3rIXTkRVovjOls4lIbdIIHlajqBrOstWCvWLd7xw/JeCVgQRGGKyrwvXfL1zECQhioXhzu8c+GAYbdL+81/n6jGjAo1iUoUiByhOm6MoeZWX2R802gpEQulP8gEnD3whKEu2l02E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329044; c=relaxed/simple;
	bh=Do1z+zMrnP2OhBfbCyVE1vKctjJdKfjjKH/IDc3JIUY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O4aIQQ7ZvxWqn8JXgiTTCIe+fsnSm49dz8+1HAZRaHoOynblKgWV79sOMco1R0a/RWtJiAI++X8NG/gmfg4oLkp7W3loF3zysdnjbhF+cKdtKtWaUclmu322wOAGH8/tITiUimWlCM+ESCw3YF+H18e5ZVi5lX7nIepJo22aKWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eb0nYU+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eb0nYU+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD9FC19421;
	Sun,  1 Mar 2026 01:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329044;
	bh=Do1z+zMrnP2OhBfbCyVE1vKctjJdKfjjKH/IDc3JIUY=;
	h=From:To:Cc:Subject:Date:From;
	b=eb0nYU+Lh6Xp1fHQrBXmn1Q3fh/qUcWaLne6f0yxCXfJBHiVba6a9ZmVR6072uFeV
	 xgpC3IJe0IzkqpN3UfBNGDLUxlQ+xIhn2ygNs0Hep7zwjUJx7JOj3r/h2zpqvr7MZf
	 5T5u0U9oxsMt+uZhrO+8BfmQq7rSXQeqX5tCXOrZPgFK7lDw6WX597ygnesEX/Ue/j
	 xgno259eqT5Hgzg5wT49/R1NArE4RFZo1atuNHaiZEHHcikBQbsaq9bteYi4jQr3Ud
	 W5dDHCJQqZwe7vHxK6UyhaHdvZfRk1B4meEcW/54zo9Tz+8CqrXPnnOBhnamjFcKuZ
	 AVl+hbxNb+CrA==
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
Subject: FAILED: Patch "smb: client: split out smbd_ib_post_send()" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:37:21 -0500
Message-ID: <20260301013722.1697587-1-sashal@kernel.org>
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

The patch below does not apply to the 6.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From bf30515caec590316e0d08208e4252eed4c160df Mon Sep 17 00:00:00 2001
From: Stefan Metzmacher <metze@samba.org>
Date: Thu, 22 Jan 2026 18:16:54 +0100
Subject: [PATCH] smb: client: split out smbd_ib_post_send()

This is like smb_direct_post_send() in the server
and will simplify porting the smbdirect_send_batch
and credit related logic from the server.

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
 fs/smb/client/smbdirect.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 405931ce3978f..75c0ac9cc65c7 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1101,11 +1101,26 @@ static int manage_keep_alive_before_sending(struct smbdirect_socket *sc)
 	return 0;
 }
 
+static int smbd_ib_post_send(struct smbdirect_socket *sc,
+			     struct ib_send_wr *wr)
+{
+	int ret;
+
+	atomic_inc(&sc->send_io.pending.count);
+	ret = ib_post_send(sc->ib.qp, wr, NULL);
+	if (ret) {
+		pr_err("failed to post send: %d\n", ret);
+		smbd_disconnect_rdma_connection(sc);
+		ret = -EAGAIN;
+	}
+	return ret;
+}
+
 /* Post the send request */
 static int smbd_post_send(struct smbdirect_socket *sc,
 		struct smbdirect_send_io *request)
 {
-	int rc, i;
+	int i;
 
 	for (i = 0; i < request->num_sge; i++) {
 		log_rdma_send(INFO,
@@ -1126,15 +1141,7 @@ static int smbd_post_send(struct smbdirect_socket *sc,
 	request->wr.num_sge = request->num_sge;
 	request->wr.opcode = IB_WR_SEND;
 	request->wr.send_flags = IB_SEND_SIGNALED;
-
-	rc = ib_post_send(sc->ib.qp, &request->wr, NULL);
-	if (rc) {
-		log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
-		smbd_disconnect_rdma_connection(sc);
-		rc = -EAGAIN;
-	}
-
-	return rc;
+	return smbd_ib_post_send(sc, &request->wr);
 }
 
 static int wait_for_credits(struct smbdirect_socket *sc,
@@ -1280,12 +1287,6 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 		     le32_to_cpu(packet->data_length),
 		     le32_to_cpu(packet->remaining_data_length));
 
-	/*
-	 * Now that we got a local and a remote credit
-	 * we add us as pending
-	 */
-	atomic_inc(&sc->send_io.pending.count);
-
 	rc = smbd_post_send(sc, request);
 	if (!rc)
 		return 0;
-- 
2.51.0




