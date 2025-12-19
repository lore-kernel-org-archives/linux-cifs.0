Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE23332A3CC
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 17:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766163865; cv=none; b=lgDzKIy3IZODC/4KSO0hKI4UvytzKlSm7g7B8X+601H7WfXJhn6LW9Ovid4NfLKdxUKSaCpbQuQqzyG6Jb1bnpNQxwWcUrvICrTwZcvQNIy/01bnUxFrwWGQf+YrZ/tcWnAVJS6csSPiS18jxXNL1bJt8etepMKtpyXCwgE0SSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766163865; c=relaxed/simple;
	bh=1EFo0SmJXH2I3ls+2N3depouTELhxk433KS99ByRKD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTXrE49dHVRNmSyCexPRmaCQg1fGiF2ia8Cclv+pG4UIy6bhTJJEBsW+cRYKMjJ3HHzTFfkPEVC5ZHgdRe9Ps8lBE6evW/a4tVM3HmBNRDFU/4A4vF9whr0lLaMRckg5e9UWkssdiWaiDgmJkMQRGvi/WQGUio4UqJ5fh/oXZeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hikpwr2w; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hikpwr2w"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766163854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qlrzz6Rcz6qybwCVFlxo90h6uvJRtLnFZisXRdmTyf4=;
	b=hikpwr2wncRxVD/tTNsH6WbjFIRFNXFjZwo0XBRYHwxV5lnvu81Ff2A463qV2k47va/9AF
	/p2dywoC+1Vul71fBIhK1jIK7HNKZ+/LqRn3H7v7cGbeZf0jC89qYsIl4pWSed6wMZbkyL
	kTAX09+mtmcY8fZM6Qyel8scA9tVzr8=
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
Subject: [PATCH RFC v2 2/3] smb/server: fix minimum SMB2 PDU size
Date: Sat, 20 Dec 2025 01:00:56 +0800
Message-ID: <20251219170057.337496-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251219170057.337496-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251219170057.337496-1-chenxiaosong.chenxiaosong@linux.dev>
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
`struct smb_pdu`.

Suggested-by: David Howells <dhowells@redhat.com>
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/connection.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index f372486ebcc5..4a8eb4fef763 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -296,7 +296,7 @@ bool ksmbd_conn_alive(struct ksmbd_conn *conn)
 }
 
 #define SMB1_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb_pdu))
-#define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr) + 4)
+#define SMB2_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb2_pdu))
 
 /**
  * ksmbd_conn_handler_loop() - session thread to listen on new smb requests
@@ -396,7 +396,7 @@ int ksmbd_conn_handler_loop(void *p)
 
 		if (((struct smb2_hdr *)smb2_get_msg(conn->request_buf))->ProtocolId ==
 		    SMB2_PROTO_NUMBER) {
-			if (pdu_size < SMB2_MIN_SUPPORTED_HEADER_SIZE)
+			if (pdu_size < SMB2_MIN_SUPPORTED_PDU_SIZE)
 				break;
 		}
 
-- 
2.43.0

