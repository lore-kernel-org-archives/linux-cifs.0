Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABD92DAFC3;
	Mon, 27 Oct 2025 19:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592403; cv=none; b=obV5LAr7Pn26hPfaqED6cubojjhpBjUu4W8vd8mBRmLeTde9SGDmlHBZYlCnCRai3nq/VDSLdi1BJR22NYQms0Gr7gJEV+05gVuuXr0GkPTyHagGq06PJ4RQJnpYXV3dbrjRwxp1riz832hJNDyHAFhb68bgzhKztncg1rYDOiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592403; c=relaxed/simple;
	bh=ojv++QjIH3srBTSWoiCAbv3TpdgQBa6uC6+tCx2a8Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghV8CRLpTasJbBHM05GnSKH7bp05OGnYr392f8NoNhbgfqH6PWedoEPpKcYWxHLyFc2t9BN6YLlp1x3xaB2OdJVgBTCGzKZfjfR03FXDv9UlDLXhWFzKLRAesT7lksNMeYd8iCP2XMyhSRzHaBeIrz0gJdSIkPvpiz9kz0qbmO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjdxUXsp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjdxUXsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92906C4CEF1;
	Mon, 27 Oct 2025 19:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592402;
	bh=ojv++QjIH3srBTSWoiCAbv3TpdgQBa6uC6+tCx2a8Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjdxUXspa7DonhNhzsVoXco8jbe1lXfqmDJ8LFchi9tBVpVOX7qb1r0+JJ9aQCLQm
	 R/hbJnM4BtsMmZduhgf0JRginXs//fEMnASzlCx2tCPdqSliIotBwS33n4DjQwHUJX
	 QRZHAr6qn8o8N/zAK5iSpXa9jhDjZ7X7Q0ch64Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/157] smb: server: let smb_direct_flush_send_list() invalidate a remote key first
Date: Mon, 27 Oct 2025 19:35:41 +0100
Message-ID: <20251027183503.420851234@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 1b53426334c3c942db47e0959a2527a4f815af50 ]

If we want to invalidate a remote key we should do that as soon as
possible, so do it in the first send work request.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_rdma.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index af1c41f922bb3..81da8a5c1e0db 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -933,12 +933,15 @@ static int smb_direct_flush_send_list(struct smb_direct_transport *t,
 			       struct smb_direct_sendmsg,
 			       list);
 
+	if (send_ctx->need_invalidate_rkey) {
+		first->wr.opcode = IB_WR_SEND_WITH_INV;
+		first->wr.ex.invalidate_rkey = send_ctx->remote_key;
+		send_ctx->need_invalidate_rkey = false;
+		send_ctx->remote_key = 0;
+	}
+
 	last->wr.send_flags = IB_SEND_SIGNALED;
 	last->wr.wr_cqe = &last->cqe;
-	if (is_last && send_ctx->need_invalidate_rkey) {
-		last->wr.opcode = IB_WR_SEND_WITH_INV;
-		last->wr.ex.invalidate_rkey = send_ctx->remote_key;
-	}
 
 	ret = smb_direct_post_send(t, &first->wr);
 	if (!ret) {
-- 
2.51.0



