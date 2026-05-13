Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6EA3A7F4C
	for <linux-cifs@vger.kernel.org>; Wed, 13 May 2026 20:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778703633; cv=none; b=k/Cr8Tcrf0CdvzTDe8UDjSwU37Bm4HJ7736YxgbV01MMwDY5JEiqmLhJHtehl2NEapeWopXjwrk18Yj6jgbNwNruSJH2P6+dQ2YgWmLiVHSuMSAQvWaXCCQin3ThTm9CE+xx2tc03IEp7j7pZVaKeQxaX8qTik7pNDVAw/qXdUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778703633; c=relaxed/simple;
	bh=1+JfEVh8IHmLlWdK57jRDorQflGfu7RT2ANUDg++Yrc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RU4N1G5J6p4RcUmGOZQ2jqbZuNlCRMvGIToeC5QYM0yM1A6VMtLYDYBfyEzewzkhWLfIuYoVLDfy1ETm8dK6Kbcl+59ppiU+b1i9MdKGly4UseynYhL98kJnM2kdyiB9B6Y8bxG0c2t5R6QCt4jBwWn2A60RbKCD0akKLhi8RkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JHcRjM1a; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JHcRjM1a"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2bc85eda6b6so23711955ad.1
        for <linux-cifs@vger.kernel.org>; Wed, 13 May 2026 13:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778703632; x=1779308432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BRdLkjPZb6o4tdcWRE9ouOn7tpuKUG0gkuZr4j3LG1Q=;
        b=JHcRjM1aeTYnBHVN3npOSGV7nG6uAfxeEgREZ4WR+5wzqH3ifOqb0VmFRw7CHOaXiM
         jd7b4XajBdJi3XQlFQ4ORj4Eiw2GUEhuJyJcbonoOq5FfNZCbXYudhUdBDJk6GSViS0x
         uv93Lxc9vaaJhTRH2quKT8UaqXnAMt9zZBhZmpYryYBofEqtqYxBF6AtiKOZylz1TOup
         K6K43SZN9kHPaK+Sxm8TjWGFzsLMtOciZmI20FVM00QjEEa8TVFaprJX35eg3YJ8tFrZ
         fNTpbakeKc9rG9xg0q3Rb38jQyxMmEud2Vju31XJkg40aWSOu1DJEb2b3sSD8BLA1rM/
         jQOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778703632; x=1779308432;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BRdLkjPZb6o4tdcWRE9ouOn7tpuKUG0gkuZr4j3LG1Q=;
        b=g+c1sAP9V2rlB31AF+rPduc8hUC/8E5jq6rt48MGfjdecbpCet59ZQZW/uDbo1J8BZ
         a/cfYodUTkfixSAXIsFXMq4n/xVd8rONH7LxfeXZUPtdQssbwCKkmceO7MqGcC5zunrx
         H7OYUc4Emt7QXi+bozSGkWOSTc5cX3is5yWPnguLVFDxSIgctDQUJ8GhIOZNroVz+GL5
         ea11OMrIqPJkdUbsbFjSIahM8i9pEFiuUqtuqxuKNhVN9V4M5VbMhX3jdujz4pxzFSY0
         8qvijeGFMD5PVYaG8YhuraMh2OqHRgY/6y5jzbPDHEjNxFNQvF94OjPyxRMs+ihntrj5
         RbqA==
X-Gm-Message-State: AOJu0YzctWdPu+s/ivC9Ow6Hhgu2S93GuRm05ouhE5HcWJkJFyIKXLyi
	0GRRi15JyTqTtHID68gOFd5B0MUwIwlKUghiUTMbhUj/tshuNYLJSavH
X-Gm-Gg: Acq92OG/sxaPp/uAtWzUqXIIck5CpCmgx+Jj3U3OBZtCLL13DXEzPV+rlvE3h9n/HYc
	KIj89CBuRzje/DKn6mZKzXtBqJ8k8M1plFJ8lxkQk97Ol/T7igQ9q065pbdgz3BH3+L+csmzEls
	qbZgTsBAIhqR7vUdeXJNwVrij0+Yz7biTDzDFJtYoXPrrKd94/UdMvF5DRArWvcevR0GULTrdqM
	7ZB08zTFfLpQo0WEwYYnJRijKWe9rxqxrY8/sq7wwZqmKsHTetzBnBXZJrBrNXZsbaA902iHjsz
	TtE5rnDkpTXePSgekdzgTqoqCNGK5DeLiS7+D9CCIddUyVDorfPsIljIiu6mWzfEZ0eXsPOIBvg
	d3Jlls3RUyS30thzV52uqWQuzgZkhI7sjUAUPADngah7bqtiAakBf36+fdvcT3CKyD/PCb6slsn
	Pjyf9E4eS195YD8LvgpnCgydxW3hlZIYw+1CBEizHqvCM=
X-Received: by 2002:a17:902:c254:b0:2b4:604c:ec6f with SMTP id d9443c01a7336-2bd273aad39mr36066335ad.32.1778703631600;
        Wed, 13 May 2026 13:20:31 -0700 (PDT)
Received: from FredPC.orting.wednet.edu ([164.116.47.202])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5d0fc80esm741775ad.64.2026.05.13.13.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 13:20:31 -0700 (PDT)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
X-Google-Original-From: Fredric Cover <FredTheDude@proton.me>
To: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>
Subject: [PATCH] smb: client: change allocation requirements in DUP_CTX_STR macro
Date: Wed, 13 May 2026 13:19:15 -0700
Message-ID: <20260513201915.401320-1-FredTheDude@proton.me>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

Currently, the macro DUP_CTX_STR allocates new_ctx->field using
GFP_ATOMIC. DUP_CTX_STR is only used in smb3_fs_context_dup(), which
is never called in an atomic context. Using GFP_ATOMIC puts unnecessary
pressure on emergency memory pools.

Change GFP_ATOMIC to GFP_KERNEL.

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
 fs/smb/client/fs_context.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index b9544eb03..a3ccc06c0 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -420,7 +420,7 @@ static int parse_symlink_flavor(struct fs_context *fc, char *value,
 #define DUP_CTX_STR(field)						\
 do {									\
 	if (ctx->field) {						\
-		new_ctx->field = kstrdup(ctx->field, GFP_ATOMIC);	\
+		new_ctx->field = kstrdup(ctx->field, GFP_KERNEL);	\
 		if (new_ctx->field == NULL) {				\
 			smb3_cleanup_fs_context_contents(new_ctx);	\
 			return -ENOMEM;					\
-- 
2.53.0

