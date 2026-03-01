Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D923033D5;
	Sun,  1 Mar 2026 02:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330645; cv=none; b=hXQCRiW8ki3v/Lc/M8nUxW8F7N84p0j6roteKkQIC/jDqjUAJgza0Szdq2odwSd55RmORaiSbu/r2eTHqb8D/pc+C0JSO4bz3A061hq9KIkCSgfP5rcyhRoAmX1YG0VlYXaHHONbqq7pZu4l5D7aYzLe52mKI84E6RTqHSh6XOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330645; c=relaxed/simple;
	bh=wpJ9yfnP7Fhr+eCwbHo0SkJpPrj0Aj1KfBW+DahxU5M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JBwDdHcK7dyw1AWeOEwaMbdKamW0JgpxC0jkzycYWACCmmxYUa67JqX8VghfkzvDivTPnV/Plsjgb+r0GLF9zeJTYhbR/u5YxZbHArZsI7A+QGlUYMHjIMzTfbCZafCWtYWkpO+CcjOTgoybpmyVQ68S+6jmiqDh0YmwCLhRGAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pbc2RKw+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pbc2RKw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C115FC19421;
	Sun,  1 Mar 2026 02:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330644;
	bh=wpJ9yfnP7Fhr+eCwbHo0SkJpPrj0Aj1KfBW+DahxU5M=;
	h=From:To:Cc:Subject:Date:From;
	b=pbc2RKw+3gtMoKqojX5b6vpP3TFpWlDFoupXhU0TK8lHXptTebVPDF0w6odBJ0t7X
	 tGdq/oL7Mze1gxlybbhol1KXF9UsyRohrt9USIYucQzFdQEl4w957ht9825u/M0LXG
	 dGhmsnonmYDnn6yjsHFdAEBnJYYYZteZjKrbl0qh5aesWX6Lgoth05hYCDkKwfa18+
	 HJ52T396o+PV5e/veBiv3PqoZpDIIuEet1q2jcrEFtFQrBGDZe5ZHJJIidqoWjx4S3
	 RaOxRMZioh4eMbvV/kpi6+LtxhJqaevQRbc3AJfiXEjSrRDofWl3suwtlSHCT1NDZg
	 WF09fGnxvLcXw==
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
Subject: FAILED: Patch "smb: client: let smbd_post_send() make use of request->wr" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 21:04:02 -0500
Message-ID: <20260301020402.1732352-1-sashal@kernel.org>
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

The patch below does not apply to the 5.10-stable tree.
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




