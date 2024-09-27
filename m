Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FDF1898E2
	for <linux-cifs@vger.kernel.org>; Fri, 27 Sep 2024 14:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727447875; cv=none; b=BiXrsU93kcxIMJbFxct8bHlFr4pZoisFGkle4VqD7qH2zxejyeNv7eKjTw63tVzZR+Wv/WrN0QyVkcMmlgHognZk6nT3zf8/4MZHX8IU1H+X0nphdEP2cUh54XoTAb/k7wLXBWWS3s9OFxaCmJmk623ly0764rnzOgwMwLsSHKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727447875; c=relaxed/simple;
	bh=CPONilJn9p7dDnQ9tE2fV1Gl586yuq9bdUBsCDhdyOE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LEUtK2Js0nKnX7ia3BOf4zrM5M66z+SyiG2XScabePaVENQPfqgQrhUpmg18OK1/JFTtYysqe0nphn09F3oy/8p+s3b5SQQSMChDGjrs7AyRifJonBgddjkiGir+thTMDsmpZ75H+k9BET7EIcPSEzFiwAAFR5OTSmiIT9bbkOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y6X2g85Z; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y6X2g85Z"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727447870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/+oZiPdJEZEoqA+czkrBdMMUvfRrzlg5IyCe2/VTuBs=;
	b=Y6X2g85ZAbjieSzY5Nyw6Y093bT47aK0CS5KTQsinvUPiYThFpIQ7q7Z246KPIQ1lqhe5v
	ptsU/hGkq18oboHBt9Zxl5f5zo4vT0qJ6Z7NEjCvFDxDgSs09JF4l86phnEKAfIcOebLn/
	vnMyyer9Upw2jdqSVF5y/cvoHYpW0AQ=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ksmbd: Use struct_size() to improve get_file_alternate_info()
Date: Fri, 27 Sep 2024 16:36:42 +0200
Message-ID: <20240927143642.2086-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use struct_size() to calculate the output buffer length.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7121266daa02..b45e5b9ad967 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4887,7 +4887,7 @@ static void get_file_alternate_info(struct ksmbd_work *work,
 	spin_unlock(&dentry->d_lock);
 	file_info->FileNameLength = cpu_to_le32(conv_len);
 	rsp->OutputBufferLength =
-		cpu_to_le32(sizeof(struct smb2_file_alt_name_info) + conv_len);
+		cpu_to_le32(struct_size(file_info, FileName, conv_len));
 }
 
 static int get_file_stream_info(struct ksmbd_work *work,
-- 
2.46.1

