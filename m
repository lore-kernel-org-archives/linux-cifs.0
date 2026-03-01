Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812FA2727EB;
	Sun,  1 Mar 2026 01:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328397; cv=none; b=sVxPCQRCaVu7LGCuAidTcvQ/oOu0XqBKsHWl0fRKrXSegkcYZ44UfNsavhea5esQSnafMCxifqqY7G/P9RmsHKE7VakpLvyXoxx/+mPAWh1QhsrTA29XGRi4zQQIRAGO3P6/PUlWWMJI9plhz3ZrCCLbLnwACfx8tQTA/sgrTrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328397; c=relaxed/simple;
	bh=9TSMZf2X8zU3Mbl6Zppyozf+NDMtCJRD0VEjvuJxCts=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oAxnp9papKkgLi9Q/4QZWBqwS5+DWdoLDgxTh25FcwXe6tLxdxSW4yCoZ1TkekNy8zuF1xYPyIS7COKRS5eXyMoFj3TGYN30QqLN4itR2cpJOqL8pf81o3DdLK5og6ubr4YWqzgnEEKipFgf5L3+Nm4XWwoLqHpwXO1gGm/EZEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IIe3/Fiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IIe3/Fiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775AFC19421;
	Sun,  1 Mar 2026 01:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328397;
	bh=9TSMZf2X8zU3Mbl6Zppyozf+NDMtCJRD0VEjvuJxCts=;
	h=From:To:Cc:Subject:Date:From;
	b=IIe3/FiwYkgL9aE4tJvSP/xxr2Q2t/kxUmsguSxVxCc5t0uK8VfpkcurAcHRtNLh+
	 YQhCEPH2Tlb9DoC1UCi8J5WkcmSdTLpsGVoWB8lrASLJNQyM4nzmjCi+2i/nIYe7tJ
	 7R0bUm0EQlVFX8lE+h+Z1Ee0WaHIdjjeDEXcLHO+xbhAoFdcPXmSfb4yWRbZ4jxaya
	 m5EveAdyA06E+MR0cbz3IwFfiMGr5MOswJcahAxz53A+hNDcZJZURrrMOh0D+cPjdO
	 ebZpju3gIxgUgJgRUKOmD0cxoJxFepMAiTdMod5Iq+hzoM+NnpQb8D+LHaXWK8USLC
	 PxOBSemkyJ/mQ==
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
Subject: FAILED: Patch "smb: client: let smbd_post_send() make use of request->wr" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:26:35 -0500
Message-ID: <20260301012635.1683986-1-sashal@kernel.org>
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

The patch below does not apply to the 6.12-stable tree.
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




