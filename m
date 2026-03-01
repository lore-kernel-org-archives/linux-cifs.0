Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB002DA76C;
	Sun,  1 Mar 2026 01:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329576; cv=none; b=JxaOEdJAm+ABFFKZYy4TROo2+aZZTBbUChcJvSYA5/1eXd6PSANYSr6UJ+HOGB7OHtxnl8G2qtRw3q+a6v39gih/jRTO8jBHjgSCTAU01ZStPDS4bLQSwm8YQEHqNzmeMBr0OSmbHQkLyk48n5VoQMXKH3iVgnteCf9X6ctSmLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329576; c=relaxed/simple;
	bh=ptQRqpYHL76c9NKN0JlkWHoatiin8BBt5DqUUnAUcho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Un4ziG7mCptD5Myfz8ZTfVgqa81lXULsqwqJeLEJGCddJ8uIktiTtZhR2NG2AxxCE4VxZ2btw+293EeAKekSLAHdwTnuBzmHxJcgGr2tclARWOslwd6SKQtdK3UEeVBtsficcZKB7ChBSMrZCEWnGEM0J5xGt/fQFB9S57+j0qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ifWERTVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ifWERTVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E63DC19421;
	Sun,  1 Mar 2026 01:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329576;
	bh=ptQRqpYHL76c9NKN0JlkWHoatiin8BBt5DqUUnAUcho=;
	h=From:To:Cc:Subject:Date:From;
	b=ifWERTVrbXqK+A0fztkknppGldh18Obv98bGuBtqvNfIv00Ywg5huuCBtEQIFSw1M
	 AekzE++HFnBbuV0YMzthr51WSUpPyTStBnyO+C2xXKVh55l3ZKAPbgXeyMt8q+takD
	 bKhsVOdPgHIhfMbr0/FvKVI8oHMSdD3sr09cFTSqfr9Ot0ULOzzWGAPe0neEXm8Sgj
	 WASlZbtTo3FmxpMxas7gkjj0TTWpRymPUWeaPI+LpdlRvqRD3mHkONh2mOjL/5HlLK
	 5wEfAcIVVum6l4QXxKWSFblpbvXkqx5dtZQ12YLAZU8JLHMbOPUBsAcfLaTB4AxNru
	 avqLKbFU18gcg==
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
Subject: FAILED: Patch "smb: client: let smbd_post_send() make use of request->wr" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:46:14 -0500
Message-ID: <20260301014614.1709095-1-sashal@kernel.org>
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

The patch below does not apply to the 6.1-stable tree.
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




