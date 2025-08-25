Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C6D2AE90
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154853; cv=none; b=RC64y7Okxra9O/3EDvRk99SzQeYdVZ9+H4kFTdqOBHPNSCaaHGAMW+fq440YJ57/HlirWvLC8wAmpQ/F2Ts0g/2kxvUtu9Ey5AXIJcvpnYEc+1bFImHODzig0xMy61Q8KfJ7QCAERbeo64L778GaV5dMyH3bWlTp7jYKal+a1/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154853; c=relaxed/simple;
	bh=a7b/PEiFPJLT0zYracljP2Vb7sFLutNQEta00RIs0co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsIR/ObTvJveJKWC41rxhHl2+x0q/8A8I4sOlgzcN3mQgRE3g16f32/Hy8AWj4dUwgdv36PtnSulQECvyfex0sfSVZRgmHeuvU1FNTWBr/QhLWzzH9kDyeo6Bf1q3cWH/m65PDuYwiieeDtq3qMLCO5lcZG4tSNqOVK/d6jvVnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=PASJKTEH; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="PASJKTEH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=kwt9GwDKdKbWfXjCS+P0KCEr39rZN+WWgufwE0zSUM0=; b=PASJKTEHDT3qJxJFbKY2bCnOr1
	z+Q6bD+pzXNehIRDfG7qqO+iM5HNy4OfhOgRIOmJiRd9w0J0ihZy87QNwZQrrTRK833DGz4OPDGHn
	KXDzAdI5ebtqTa4G6eoEh7V2ZfFrZZJsVNtyZ9N7DzhSoEmn/DWP92X/80LyHqu/B1lzlqPJGnL39
	jTApGqMatX10Plkd/ZHo4BrPZr/+8eA2iC+S20TN1vDPBAMZsm+N+D17fdy1vReCL19TvL4tVb750
	ZUQo/36iFhhrD+nqA/bn+r96oBaLjrH5OAcU8gHRXB78Ju++ywuYqvZnZVLI7fc6VmKu1SRHjSD4l
	TLVq3nw0snJIlFbBvNcPbXZeHgoJw9a6psU7i4WAdl5GX7INDLW8/0P2s3/iRc8F4G7gQecitpTOS
	6Y2Nofr0eKTH088fgzzreNf71VXHWA3nIM2Y1RFnYeOjNmYCRLc27IOPRPgBpK3zJcSYTiXfZLYu3
	K7sRsELOywnzfbHk4lAE6IIf;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe6B-000kL8-2g;
	Mon, 25 Aug 2025 20:47:28 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 034/142] smb: client: limit the range of info->receive_credit_target
Date: Mon, 25 Aug 2025 22:39:55 +0200
Message-ID: <52664b62bf651170b13b2a88f7d157c2fec777b5.1756139607.git.metze@samba.org>
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

This simplifies further changes...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 8 +++++++-
 fs/smb/client/smbdirect.h | 2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b1ecfdbbc67d..e567fdc6e223 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -456,6 +456,7 @@ static bool process_negotiation_response(
 		return false;
 	}
 	info->receive_credit_target = le16_to_cpu(packet->credits_requested);
+	info->receive_credit_target = min_t(u16, info->receive_credit_target, sp->recv_credit_max);
 
 	if (packet->credits_granted == 0) {
 		log_rdma_event(ERR, "error: credits_granted==0\n");
@@ -560,9 +561,10 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbdirect_recv_io *response =
 		container_of(wc->wr_cqe, struct smbdirect_recv_io, cqe);
 	struct smbdirect_socket *sc = response->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbd_connection *info =
 		container_of(sc, struct smbd_connection, socket);
-	int old_recv_credit_target;
+	u16 old_recv_credit_target;
 	int data_length = 0;
 	bool negotiate_done = false;
 
@@ -623,6 +625,10 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		old_recv_credit_target = info->receive_credit_target;
 		info->receive_credit_target =
 			le16_to_cpu(data_transfer->credits_requested);
+		info->receive_credit_target =
+			min_t(u16, info->receive_credit_target, sp->recv_credit_max);
+		info->receive_credit_target =
+			max_t(u16, info->receive_credit_target, 1);
 		if (le16_to_cpu(data_transfer->credits_granted)) {
 			atomic_add(le16_to_cpu(data_transfer->credits_granted),
 				&sc->send_io.credits.count);
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 693876f2d836..6f18e4742502 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -54,7 +54,7 @@ struct smbd_connection {
 	enum keep_alive_status keep_alive_requested;
 	int protocol;
 	atomic_t receive_credits;
-	int receive_credit_target;
+	u16 receive_credit_target;
 
 	/* Memory registrations */
 	/* Maximum number of RDMA read/write outstanding on this connection */
-- 
2.43.0

