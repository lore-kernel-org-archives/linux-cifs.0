Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC413559C7
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744713; cv=none; b=MIs2D3oVB0JZT86tzUvtdWBUmJoH2/Dqgi52sFwgzeNy9zcm9wvEJJhL5Yygnmwprls3fBd9CEyHrRTNbs/lxiLQpkc7uB+lQqI7dv9279VtsiMeIsG5cgecEGx7Yz1RDuugtFMWbiH6xKeBt40x7uuqqCiXtyGK6ceEGY9YHVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744713; c=relaxed/simple;
	bh=nT0ahUoa3/V9QcAmV1iIT/GLCYnBs7OSotkbukCgIMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8L4TH17ua44wtU8blDV1brlNFKiLe8xB1p3mqe0oH2PI3BeWScG0XszsoIG30kRFCFFZwrryiKxx88YGafAo2BLB8vD05k1wPyck730o4mOfvrweQDBcAB2/dOPc9pe6qrwiQK8CG6cH9HC3QPrC2k39V4zybDtRZeVms2Uflg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=E3pAobyo; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="E3pAobyo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ueulkKE7HArikNyXqAiB1zO6sRHIz2USFQHvqFe/aek=; b=E3pAobyoFAxG/ulvRQjLs8IZ54
	KfOGNJ01P6UqGdHCPO715MkWWPN1tIObIdq4rnxY5B26VqrhvHWpI2whXn29GRNCCRyiEDhynkd1Z
	swylngggPe5jP96fMEK8GNs4mVMbl81IgzDpmRTIyiR7IEnE11BuZX8kXAdedzh6ywSzBxMPsjnR9
	Fa83UO1rxpG8K3ZPD1VU9jNT6DJgnk+nfqrW4ZN0rbnL3jBz5IEFgDcXt04BsuM7PakemuTkeQyJR
	dcrlb6viFLJZW9tBTpdz3hK4+mbIPjEkNBDWZrHpJ//jOZr87O3zjQbRL2rZCvGl6wAFsb2bJYXDX
	SBbMpDQs4ia9jM75/KBznOtMSM4dU3LC6SiTb2EXmt1t4SAJxwjPcJ38IzqEMOzx3XYxKm09ZoykH
	8pohn2Uv6bLNszrQ5EdvVxpwapFtqpGgtfP3SWI3p96j6UWarkoTzt2US4y3kYCMKZBJdKTo8x5S8
	Y3wgtzsbnrDLYesTeZ4k3CaV;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6HF-00BceI-2M;
	Wed, 29 Oct 2025 13:31:49 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 093/127] smb: server: make use of smbdirect_socket_set_logging()
Date: Wed, 29 Oct 2025 14:21:11 +0100
Message-ID: <1964f010965464e492734f4281d96595048545a7.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will allow the logging to keep working as before,
when we move to common functions in the next commits.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 62 ++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index bcc584884f29..fa6371ed0b76 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -109,6 +109,65 @@ struct smb_direct_transport {
 	struct smbdirect_socket socket;
 };
 
+static bool smb_direct_logging_needed(struct smbdirect_socket *sc,
+				      void *private_ptr,
+				      unsigned int lvl,
+				      unsigned int cls)
+{
+	if (lvl <= SMBDIRECT_LOG_ERR)
+		return true;
+
+	if (lvl > SMBDIRECT_LOG_INFO)
+		return false;
+
+	switch (cls) {
+	/*
+	 * These were more or less also logged before
+	 * the move to common code.
+	 *
+	 * SMBDIRECT_LOG_RDMA_MR was not used, but
+	 * that's client only code and we should
+	 * notice if it's used on the server...
+	 */
+	case SMBDIRECT_LOG_RDMA_EVENT:
+	case SMBDIRECT_LOG_RDMA_SEND:
+	case SMBDIRECT_LOG_RDMA_RECV:
+	case SMBDIRECT_LOG_WRITE:
+	case SMBDIRECT_LOG_READ:
+	case SMBDIRECT_LOG_NEGOTIATE:
+	case SMBDIRECT_LOG_OUTGOING:
+	case SMBDIRECT_LOG_RDMA_RW:
+	case SMBDIRECT_LOG_RDMA_MR:
+		return true;
+	/*
+	 * These were not logged before the move
+	 * to common code.
+	 */
+	case SMBDIRECT_LOG_KEEP_ALIVE:
+	case SMBDIRECT_LOG_INCOMING:
+		return false;
+	}
+
+	/*
+	 * Log all unknown messages
+	 */
+	return true;
+}
+
+static void smb_direct_logging_vaprintf(struct smbdirect_socket *sc,
+					const char *func,
+					unsigned int line,
+					void *private_ptr,
+					unsigned int lvl,
+					unsigned int cls,
+					struct va_format *vaf)
+{
+	if (lvl <= SMBDIRECT_LOG_ERR)
+		pr_err("%pV", vaf);
+	else
+		ksmbd_debug(RDMA, "%pV", vaf);
+}
+
 #define KSMBD_TRANS(t) (&(t)->transport)
 #define SMBD_TRANS(t)	(container_of(t, \
 				struct smb_direct_transport, transport))
@@ -422,6 +481,9 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 		return NULL;
 	sc = &t->socket;
 	smbdirect_socket_prepare_create(sc, sp, smb_direct_wq);
+	smbdirect_socket_set_logging(sc, NULL,
+				     smb_direct_logging_needed,
+				     smb_direct_logging_vaprintf);
 	/*
 	 * from here we operate on the copy.
 	 */
-- 
2.43.0

