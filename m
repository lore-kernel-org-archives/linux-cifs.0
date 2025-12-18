Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C18533A9C1
	for <linux-cifs@vger.kernel.org>; Thu, 18 Dec 2025 17:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766077914; cv=none; b=qg45L4rGGMqD7Io2OfbcQ08xfx43+gcmCZcLlZak0t96qgE+qUevai7uWcu6DuOpCN8Kr41sCpV9uX6KfubFnEq41/fJzsJ9ti5eNv/FFHgew1rv6LTr7RAcZqhpvtt3nVE76cw91qkt5CfAiinwcbOJH3EKjD0dzM8vMp05Alc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766077914; c=relaxed/simple;
	bh=mGxiKyJaCBQhYX40L2XWsihEyQhbl9s/7ky9baEafdM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U8b0pH58JbIpRLD42EuLCCRTEeBV2qZCIC9anaxQ3RCRaaK5/fw+PH2zQ8K4TPSpcBu+M1Mk4l6bloPDDkT2L37ARJdhdMkfNVrdMaZriRSP1be0s0cRJeFR8OUDku5ryPxLqSA5VHAuOZyf9pAbM/6SoRguYhUVz8LUxqI5Cyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LGCVq41o; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LGCVq41o"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766077908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZFAtD/RB9n5Guzhe8ZLAAvMAto4IAOHtdvk4NjvK7X8=;
	b=LGCVq41ocN60wgKsVnRMCSYqmv6n52InWzySPbOxBK0wlqnPlRBODx9BcyvRs2PYYqOtDL
	OiramZrhWOz8EwfiAfM5chPsKaVgP27yOWMTc0zU6syhjNIhs5tP83Zx67rOlASKnhlznd
	tQiVV1TnNYBXq5Zkq3eHB0zLMzoqqWY=
From: chenxiaosong.chenxiaosong@linux.dev
To: dhowells@redhat.com,
	sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] smb/server: fix SMB2_MIN_SUPPORTED_HEADER_SIZE value
Date: Fri, 19 Dec 2025 01:10:38 +0800
Message-ID: <20251218171038.55266-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

See RFC1002 4.3.1.

The LENGTH field is the number of bytes following the LENGTH
field.  In other words, LENGTH is the combined size of the
TRAILER field(s).

Link: https://lore.kernel.org/linux-cifs/e4fbcbad-459a-412c-918c-0279ec890353@linux.dev/
Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/connection.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index b6b4f1286b9c..da6dfd0d80c2 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -296,7 +296,7 @@ bool ksmbd_conn_alive(struct ksmbd_conn *conn)
 }
 
 #define SMB1_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb_hdr))
-#define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr) + 4)
+#define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr))
 
 /**
  * ksmbd_conn_handler_loop() - session thread to listen on new smb requests
-- 
2.43.0

