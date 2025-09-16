Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C6E28315A
	for <linux-cifs@vger.kernel.org>; Tue, 16 Sep 2025 13:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758029710; cv=none; b=e5crZorjzieEQiJgodZqqz+5+Vy1h6fdVoVgJg+4UUqJtBbGJPagkT7rctfrq3kfSS1pf1FymkgIcboQr5VIgGd+sho/Zhx8QlioVAwLwzsJsVtayVsgww7byYvGifxp8URggCM/Zf+qRU4CV1r3kFRU8WpaqaOSw278f9Znnas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758029710; c=relaxed/simple;
	bh=XCDOqK5iaZ1JI33MM8v8hlZTcrkZ+wFpzW1TDCR0lSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSA/bMDL6wyJiSkNC+AA5cjHN+wiYPP0ZtnTXrlQNIGQ9GgF7okv+LlpYspG7yZ2KxoZsCW+vyw4qc0ZrE5COExdO7M7C531CPeP3wcSuBYaTaT6Qry+M7lx+D3jHZlKWDT1d7kD5khsa1TmH+JsyqtqnKasBzq0nRPLAfPlrQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qfi71QSy; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qfi71QSy"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b54d23714adso1573953a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 16 Sep 2025 06:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758029708; x=1758634508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N1/0Iv8n8j3b1+8h6/axavWfA52Z27zi5tq9inAyNbY=;
        b=Qfi71QSy3psajlr+ZFh6IhCDpDQAHx3Z0AgIiZyHNa2N9Lpud2bqU5WGTeIID4uyG4
         dVeWgq2RUAlOn0Z6qTjbH9Dix0UkG8gJnp7osOqTGlU22/nVhgQQXg8xEgq4wVHE9Hal
         7lwWR9hUWrOp1iUISWcfWipbXBBv2PTmakEHNydHKk6pczddvmuPqYLIYF7h+O4AU5ma
         9RIEVMdfP3JXW2mb04ZY/CajGug1XcizUPq9Dc//kEEA9PEA7xziTocLOIx83j6uVZLD
         3lToN4NiyPWM4PevhuVtyZhuq48MFDn4c3ZUOLY2TPgiWGXXsi5wjoxWq6Te0jybs4Nr
         XitA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758029708; x=1758634508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N1/0Iv8n8j3b1+8h6/axavWfA52Z27zi5tq9inAyNbY=;
        b=jIbbjJOPBp2zYoUVJg8n0dwlBWfFjB0b+E8lVriPfxqtZpjTqoFmDVmFVmZywk0Moh
         ceMuaMGKhHSZrrAOXdCGepibE0FBqDfAouTwP0JKoBXrEFPiNMwmdstuNVDz9uACbTXP
         yrAJLGsoBBufyGeNl8WXthBAqS7aJbXTW1Btc7TQWpVw8RwEYrwgKXB9G3I3uWvXjWJv
         TTT+J66pN5WO7nSrnqWXF1T4QDveh3ahKPeyeYqi9K5bm3sW/mRQyBBZAYrUoejgwibn
         Jtq5nXGGXq1QwLTt8Jko5F6jTT29ZC5gmQVV1P+lN4K5rjI/HL/1jxMLF/M/++JwDpzq
         zxEQ==
X-Gm-Message-State: AOJu0YxLvr6dMe1S0C8t7h6M6QEdSpTABcHc6IcldAIAE2afXU5h4cYR
	jjGqAF/uIZPp++3T9n0n00hDpF/MGv+1U6oFAw3OTBUsSXoMYkoO4raC
X-Gm-Gg: ASbGncs6s14h/zLZK2greOpDWkGE+9d2frFeAW5YUdPKvgGUHATx3a2qmtaBetJpVL9
	hXHybKRyg5qzA7OllotVdG3eKViX/Lb6e2V6vLRwR0RUcgQHH6+PwgUK0kBWcfz45QudwN8BzOt
	SvfPilKaokvNU8vHPJ9yVmLHnu+2rlerquEkRxQCPWM2yhqk5F9IrZhFG58vAjrdBS+okkViWQz
	tSRx8mkA7aaklUwd19BkuWW0kn9q7ZU+hp4PVzivAZWwlsXtXEnYAwPuwG2VXb0wtk0zo9oTHkf
	SIMDoTs7FP1Grox3QaCIDrLlFNOsYcjojYPTEece7/DeJoBt6T24W0dxZ8QQMVCm2nS5zJdJCeM
	uILnnjpZaFYIs4qxn
X-Google-Smtp-Source: AGHT+IG8SC4IMk/dz31dv2uJVNaZUwQVE0a2ynla55XuwOlF50LutVqoa08+4C5xVid08Qp4WZLLGw==
X-Received: by 2002:a17:902:f605:b0:262:f975:fcba with SMTP id d9443c01a7336-267d1578749mr26581415ad.9.1758029708061;
        Tue, 16 Sep 2025 06:35:08 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-267943346f1sm51578905ad.14.2025.09.16.06.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 06:35:07 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sfrench@samba.org
Cc: linux-cifs@vger.kernel.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [RFC PATCH 1/2] smb: client: export SMB2_notify_init for directory change tracking
Date: Tue, 16 Sep 2025 22:34:36 +0900
Message-ID: <20250916133437.713064-2-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916133437.713064-1-ekffu200098@gmail.com>
References: <20250916133437.713064-1-ekffu200098@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Export SMB2_notify_init() to support directory change tracking
feature. It will be used by upcoming notify.c module.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 fs/smb/client/smb2pdu.c   | 2 +-
 fs/smb/client/smb2proto.h | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index c3b9d3f6210f..4e922cb32110 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3955,7 +3955,7 @@ SMB2_get_srv_num(const unsigned int xid, struct cifs_tcon *tcon,
  * See MS-SMB2 2.2.35 and 2.2.36
  */
 
-static int
+int
 SMB2_notify_init(const unsigned int xid, struct smb_rqst *rqst,
 		 struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		 u64 persistent_fid, u64 volatile_fid,
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index b3f1398c9f79..15f46aee4d17 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -175,6 +175,10 @@ extern int SMB2_ioctl_init(struct cifs_tcon *tcon,
 			   char *in_data, u32 indatalen,
 			   __u32 max_response_size);
 extern void SMB2_ioctl_free(struct smb_rqst *rqst);
+extern int SMB2_notify_init(const unsigned int xid, struct smb_rqst *rqst,
+			    struct cifs_tcon *tcon, struct TCP_Server_Info *server,
+			    u64 persistent_fid, u64 volatile_fid,
+			    u32 completion_filter, bool watch_tree);
 extern int SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
 			u64 persistent_fid, u64 volatile_fid, bool watch_tree,
 			u32 completion_filter, u32 max_out_data_len,
-- 
2.43.0

