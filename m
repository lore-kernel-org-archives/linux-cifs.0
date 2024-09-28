Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD031CFBE
	for <linux-cifs@vger.kernel.org>; Sat, 28 Sep 2024 15:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727535696; cv=none; b=ZUMfDsNRQfe7xoph84w0MUi8KezRwBM96gKsuOzzkYhFqR8qa2OMplxN8eSmAA0ym84v5YcUdAs6p7N1VRYa94jdbPckXPJ49uMUxhBCWJtkb4sAzbxKVRHUJyKAHZud7ZxmuFko1piHUNHoceNsghD0QKpmU3gNFiinTd7YYnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727535696; c=relaxed/simple;
	bh=hQbNGU+VoX7SrygvtUBPpfRaQb5XWKk/IVkjxCjnCZs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SlRp7jyTytuRhlSXOFFXfZG67mf3ogY3HONXb1H0Vxgj0SVaKd/eK8Hz2BdWJAd4f9f7VVNLhx6W8NTjh3p/Bp4wTQlIOeKg1zh3d900tW/yxEwF4PYQYDKdLl5O504/vRrZVnvN0t0HM5jH+ScZ1s9fNCgxWqhJx+cIPY3v4gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NKpd00nq; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NKpd00nq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727535692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FEgxMd7iJWObOMaqxmGr+avDbf/vb2+1l6khmidZT+U=;
	b=NKpd00nqs1RcAhOEZMMQPj3AmVzP32EtusjN2EIY/PIeoH3KZFk/40qoHv8YMC9D6TxmoR
	zBO2SNzlwISr8ZOzHtSQuetPlY2rS0QkkZc2xnyXzm/ywEK3BvLsM/B2pYZHra/qj0E0cp
	8kMpUR3Y6iWMRcosJDohLcb0sdF+yrA=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ksmbd: Use struct_size() to improve smb_direct_rdma_xmit()
Date: Sat, 28 Sep 2024 17:00:30 +0200
Message-ID: <20240928150030.1217-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use struct_size() to calculate the number of bytes to allocate for a
new message.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/smb/server/transport_rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 44c87e300c16..17c76713c6d0 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1405,8 +1405,8 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 	/* build rdma_rw_ctx for each descriptor */
 	desc_buf = buf;
 	for (i = 0; i < desc_num; i++) {
-		msg = kzalloc(offsetof(struct smb_direct_rdma_rw_msg, sg_list) +
-			      sizeof(struct scatterlist) * SG_CHUNK_SIZE, GFP_KERNEL);
+		msg = kzalloc(struct_size(msg, sg_list, SG_CHUNK_SIZE),
+			      GFP_KERNEL);
 		if (!msg) {
 			ret = -ENOMEM;
 			goto out;
-- 
2.46.1

