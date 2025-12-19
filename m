Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B3F2D877B
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 23:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766188548; cv=none; b=iiG6u7RdJ81zzYoxbxOynOo7L/FovfXtoEZ9CaZRJD/TQmilZH1suyL5uUWxhAJTEW5CFWXlnlrvEKFx0MMg17vuNtSxZU/CfnubDPy1hCvIjaCE+0ohZ6mpGajfzAXD+5KWarrYtp5fH05fEj14Ft0d7JEo5fKFsG8+9rogfEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766188548; c=relaxed/simple;
	bh=rcV+wJNoGtvA8y0OMUMjEcOPzSmLxbwAFMwj/z15C7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ds4XDkyad+vI4zF70RLxJPdtn1bxoTd0PKPcfXINBYgJFduf9fX9AB4WQvHh1yGBYtVvBLT43AUfhYJOdb1ESk6iGavWFWup1v0fup2Jt7OxAQFRSX0wl2ZzpUtQnXpo5Ah/rZ/WMf29x5nyQt8P2ynD9VJKdyvW9t/FOSUVeIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KKRGHfjZ; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KKRGHfjZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766188544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=41tdkkrysZGgnkwF/K+diYy43M/XNxo6opFAisJSZ8Q=;
	b=KKRGHfjZlpv16/t0Rdd32Fg7Lwp4s2MuTSBeWeIMEpjWvNGaPAvPNYWTOK8u8H4+HWJoCY
	hJItA52B7Dl45QLT4szSNe9B7YbDSMp/0dPj2jTRvFoHHu7jqL9hJ67YoB9ES6dJJdgCGG
	aaZKZ8WG9/cuRRJuKWDGVoFEJOgXlaU=
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
Subject: [PATCH RFC v3 2/3] smb/server: fix minimum SMB2 PDU size
Date: Sat, 20 Dec 2025 07:54:18 +0800
Message-ID: <20251219235419.338880-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251219235419.338880-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251219235419.338880-1-chenxiaosong.chenxiaosong@linux.dev>
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
`struct smb2_pdu`.

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

