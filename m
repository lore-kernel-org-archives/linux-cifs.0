Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC1D24468B
	for <linux-cifs@vger.kernel.org>; Sat, 20 Dec 2025 13:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766237225; cv=none; b=t4XR7ZAA8FPde990IM8Tl+q53YOCxVfoGjwKSwlzAEkBcKZKLso94Quuli/MGZJ8MwKn5LF7cqsaohNjXuCM6AmNtmnD8fkwjp3yepl2HsBRwhDk48awXwO1zd13QA5tEY9tT0Z9zF2VpKrQgwfjwyZPBjnd7+8QJlZrE3gTzW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766237225; c=relaxed/simple;
	bh=6huUq4EZRZpzRzycioYRabseiYDDYWQzx0XoE8bpRUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kjt2hA7PWozrJJzze+Qldq4wUcMx4OqQGO8nCYE5dn3JcMf2CRtO8x27OPcFaQhXMq1KE4COQdYIjp019U8wimuauEqPnaKtHU9Rgpxg97quZuvqSfeB2AwjRnnt9tUlELqBE0MmZPIpBd5gAgwjyLIq/Pe1e1t6284aZMJg+M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NosyeeRx; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NosyeeRx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766237220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zh56EH+LciaEJ3+vA3/5t9EJxF6fSlvioccLMO6ExwY=;
	b=NosyeeRxie37ElX9y+5nnaKyX2CFJd/Yrw3Np6i7bvyjGaFm/0fjdmJn/G0xgq7n4HuVQu
	/sqX8n/FhfNHKm3kJrnf5NxiUzy1bxaO/N0B3b18O2FScldnBP9aBZjjZzoTp43Y3ETE0M
	GmqK+Bbo3+/Yxw717Vur/2j7zv4P4JI=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 2/2] smb/server: fix minimum SMB2 PDU size
Date: Sat, 20 Dec 2025 21:25:51 +0800
Message-ID: <20251220132551.351932-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251220132551.351932-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251220132551.351932-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

The minimum SMB2 PDU size should be updated to the size of
`struct smb2_pdu` (that is, the size of `struct smb2_hdr` + 2).

Suggested-by: David Howells <dhowells@redhat.com>
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/connection.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index c801edd6f1ae..22ee1a9b3f43 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -297,7 +297,7 @@ bool ksmbd_conn_alive(struct ksmbd_conn *conn)
 
 /* "+2" for BCC field (ByteCount, 2 bytes) */
 #define SMB1_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb_hdr) + 2)
-#define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr) + 4)
+#define SMB2_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb2_pdu))
 
 /**
  * ksmbd_conn_handler_loop() - session thread to listen on new smb requests
@@ -397,7 +397,7 @@ int ksmbd_conn_handler_loop(void *p)
 
 		if (((struct smb2_hdr *)smb2_get_msg(conn->request_buf))->ProtocolId ==
 		    SMB2_PROTO_NUMBER) {
-			if (pdu_size < SMB2_MIN_SUPPORTED_HEADER_SIZE)
+			if (pdu_size < SMB2_MIN_SUPPORTED_PDU_SIZE)
 				break;
 		}
 
-- 
2.43.0

