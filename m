Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFC628C841
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155356; cv=none; b=QTctqLVKyuOvqB2zp51+qkADKMskjj6bB9xHyri45VoMg+0CodYxCXIe3Ymsfn8I9fNQNXl/IXDRWpfTdS61v8/wwglvYnGVHyxlIP/m4c+pSCNnSceJtstmbvpfxrysnpXTxsaqCktdVOyNdL/I/1QEQTSH9mxgGV1hh8SBWaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155356; c=relaxed/simple;
	bh=Oh6izTotNyYGyK/col6a01UKjBoo47kNdBuQcQLapLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tS6QVLNM8j6pNhLIuuaEAG8u4B/fqOYyjrRxcp9MWWO5Gy90rSr9p53fBY9+n/Ucb3WAQ5Y/iYUbBase9DN+9y7fbNj0HttPQc4Y6ML5it7DL0hANCaqX9ej8Q+1K8lOh90IA82szaXtBx03tbOONS9z3wEWJ9MeeBTcjmqPVuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=DiZkphQm; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="DiZkphQm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=pEUIFp0iInJsZvYyg4vLNBlNOBm8Hg0Cav/wQt1CYPY=; b=DiZkphQmvI5W3pzG8mYnWPV0Pe
	mWKRNucalQw8zXzi1CZUjM6x1i8XF6viIKc6QsVHOVrDVYkw5oswPHyr5wdfxSyXzSsEN6T/eiX8Y
	j/XkcLraohQhZvcj35rCNjLW/QtNLFCTdTPT3s8PJ9WsJPVzk6ywjs+hqDsu1d3qCTxuzwcEnGT1k
	UWd8CZzV2QyEJwU7Zr6xFqdoJnsmIlOq7P2o2J4kiVVz7Z0MUtcf9tss5WoFrqnITI+OiNG5cDX3F
	U/K92lq8Nt2h2QNxwPXc4kHgZAdb5JyxEPNhFahUElCvrvt+LyG7f7u+7jbT1YVeSxyfUdlI4NZaE
	pRmLDuv1HU3I4TTBhYZTrFcN2wLzhPZKckBPGt3sVBqfJ0DUngRxd890jxCyo9dkxv19W91NqjCmb
	UPrRq3ub9khSgOXEaXjaTmxq6HY5Jr5brnvlEXeToBIiMP+xarpJYhw0MvgwDWoVNCRiPyLpM7uYf
	W4jqhj7aJApJOz5NbzCcaOA9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeEJ-000lz9-11;
	Mon, 25 Aug 2025 20:55:51 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 084/142] smb: server: make use of SMBDIRECT_RECV_IO_MAX_SGE
Date: Mon, 25 Aug 2025 22:40:45 +0200
Message-ID: <ab548063c39fb74c56f5aa0e7bb7474f17fc340e.1756139607.git.metze@samba.org>
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

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index d8274bd9a020..c56cbd6ab0af 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -37,7 +37,6 @@
 #define SMB_DIRECT_NEGOTIATE_TIMEOUT		120
 
 #define SMB_DIRECT_MAX_SEND_SGES		6
-#define SMB_DIRECT_MAX_RECV_SGES		1
 
 /*
  * Default maximum number of RDMA read/write outstanding on this connection
@@ -1767,7 +1766,7 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 		return -EINVAL;
 	}
 
-	if (device->attrs.max_recv_sge < SMB_DIRECT_MAX_RECV_SGES) {
+	if (device->attrs.max_recv_sge < SMBDIRECT_RECV_IO_MAX_SGE) {
 		pr_err("warning: device max_recv_sge = %d too small\n",
 		       device->attrs.max_recv_sge);
 		return -EINVAL;
@@ -1791,7 +1790,7 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 	cap->max_send_wr = max_send_wrs;
 	cap->max_recv_wr = sp->recv_credit_max;
 	cap->max_send_sge = max_sge_per_wr;
-	cap->max_recv_sge = SMB_DIRECT_MAX_RECV_SGES;
+	cap->max_recv_sge = SMBDIRECT_RECV_IO_MAX_SGE;
 	cap->max_inline_data = 0;
 	cap->max_rdma_ctxs = t->max_rw_credits;
 	return 0;
-- 
2.43.0

