Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D8B19D07A;
	Mon, 27 Oct 2025 19:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593267; cv=none; b=XqpBKvJHVpjRHmE+mhiCviGlb9hPV89czKUKHluUH/LzkLAtP7YlD+mQTcrPt2cXdnjfOM+lH4svI+j189RbtoKo55Nya/OAexETX18+w+1ERpZjYrcqjQN/PLZx5VyMfQAqVCjtzweEr+WtrQTljzNPC5YcGYEZ1AL0Vo0KGcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593267; c=relaxed/simple;
	bh=uTdsn9gl3a9gH8Q/bdU8NHVTigpfkcc25nTSNG7CqjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pU27uyUZFwhqGk2MYk+dtW4hgmTu23QE7z/qn5YqygMhVOkFDF3UTxwDifV9fU2nyi6UebGdobEfo9NAB4je6uWXH0bus04m9zFIqaMFPKSbdOeL9p2ylUn/GkwApB+yMSTn3NZLBN6amK+JpSH3ossDizfcUlXAjTt0X5u/nvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9GP9ycR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9GP9ycR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8CBC4CEF1;
	Mon, 27 Oct 2025 19:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593267;
	bh=uTdsn9gl3a9gH8Q/bdU8NHVTigpfkcc25nTSNG7CqjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9GP9ycRR3vQF4tVf9fHivFGX72yReeDK3Z1uAhon2XGIUaTtnp4PhxfbrNYcmqvX
	 I8R0NF8mYUqaEwA8uLittiBu84ceZyhyZQ3ZA7sV7430biPbM29bnOJ6k1NSErbSUf
	 rz4eRbuP7uT5dz4fM1ilDBUJWeUHzQTyihsX8jj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 029/184] smb: client: limit the range of info->receive_credit_target
Date: Mon, 27 Oct 2025 19:35:11 +0100
Message-ID: <20251027183515.709498571@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 9219f8cac296769324bbe8a28c289586114244c4 ]

This simplifies further changes...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbdirect.c | 7 ++++++-
 fs/smb/client/smbdirect.h | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b3e04b410afe6..cbf1deff11065 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -429,6 +429,7 @@ static bool process_negotiation_response(
 		return false;
 	}
 	info->receive_credit_target = le16_to_cpu(packet->credits_requested);
+	info->receive_credit_target = min_t(u16, info->receive_credit_target, sp->recv_credit_max);
 
 	if (packet->credits_granted == 0) {
 		log_rdma_event(ERR, "error: credits_granted==0\n");
@@ -537,7 +538,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbd_connection *info =
 		container_of(sc, struct smbd_connection, socket);
-	int old_recv_credit_target;
+	u16 old_recv_credit_target;
 	u32 data_offset = 0;
 	u32 data_length = 0;
 	u32 remaining_data_length = 0;
@@ -603,6 +604,10 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		old_recv_credit_target = info->receive_credit_target;
 		info->receive_credit_target =
 			le16_to_cpu(data_transfer->credits_requested);
+		info->receive_credit_target =
+			min_t(u16, info->receive_credit_target, sp->recv_credit_max);
+		info->receive_credit_target =
+			max_t(u16, info->receive_credit_target, 1);
 		if (le16_to_cpu(data_transfer->credits_granted)) {
 			atomic_add(le16_to_cpu(data_transfer->credits_granted),
 				&info->send_credits);
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 4ca9b2b2c57f9..ed362267dd11d 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -63,7 +63,7 @@ struct smbd_connection {
 	int protocol;
 	atomic_t send_credits;
 	atomic_t receive_credits;
-	int receive_credit_target;
+	u16 receive_credit_target;
 
 	/* Memory registrations */
 	/* Maximum number of RDMA read/write outstanding on this connection */
-- 
2.51.0



