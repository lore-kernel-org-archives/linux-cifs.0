Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24460282E1
	for <linux-cifs@vger.kernel.org>; Wed, 28 Aug 2024 13:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724852782; cv=none; b=TNxWGiqNFI2aJEJDHRJ7AhSYYrzMNQ8UZRE8ZwS7+aQGxmKIMFldOxTLiQ7hh03hsRWBOUitPaM7JvdzEyP3QDYXyQ7ZFu2V0RqDhVAIzMwYD5yPFsiX8oqv/GZ8Nd9RmAYRkuraGT8F3pDomBVifsSln48Fv878bVZZljAhnLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724852782; c=relaxed/simple;
	bh=UPVsyg9jhE7jrUGJIlaml9jpYvZQwLSCE/+JMVX1JFw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uRPLYXW7UuwI5+aIreJdVhERFUBYW/JsP4Z5DpqBRd3Kpu+3lKW3OIGt9HnSLnb3W32pdzZotsEIyhyyzUvbJOMdBeSjiehke77r1M+LjtkpOnYasL0DLUy0LxMzigxQFBbtFJ3tWdrvMgRr5gBmzSLgoqQvDGd54Kg1RFLuwkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2d3e44b4613so4952225a91.3
        for <linux-cifs@vger.kernel.org>; Wed, 28 Aug 2024 06:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724852780; x=1725457580;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s36Zy5YRuyXRDt6kPoJShU6NQaEWlxS0Y4rAu/BnFZE=;
        b=uk6rRN5+1g+z0qi1knEfg4LXyhtGL4zl4kkA83YEyl++m4aJUdhTGZiJUHrgMXJoAJ
         SLoXBtFNKBae2c74AfAKobHNGowmaFN4HEcpxyLT2sztYJf6PTLB+48HoQ6p16TjzFcv
         MmK3ojJ+EOXJWRFieezplPhe2nn0I2jscBx5MeCKZVSp/HPW1A6zBudfbh6IasEbNd+j
         Px4BiBrSEvY+7II4iwE/OLqmIoXnmNSKLupOC8R/mC8L5i0BRjkPW7NJkFTODzDccx70
         a8CwZ750FvMRGLbkGCscmak08p+Q4XF63ZrttVXKeFUveYj30xG8kV3zJu/nKyR5NQQo
         fqWg==
X-Gm-Message-State: AOJu0YwrtqLSiRiSUoMfCEZkMG3p1ryTIXDf4VntFguZH6fw2NU4s/fs
	m8bRcCc2SG7g430kHFdfR4NPBAuu3a+pCN2JDNm9ABGv6c0Tco4vcNnPEA==
X-Google-Smtp-Source: AGHT+IHas7yGvxTNHuJRXAETeuWbUadASeINO+M9YlJYTI2m5hSUKJPfuNyV1gk66hk0noZuDdXl4g==
X-Received: by 2002:a17:90a:4a11:b0:2c9:75fd:298a with SMTP id 98e67ed59e1d1-2d646d73335mr15370899a91.42.1724852780073;
        Wed, 28 Aug 2024 06:46:20 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d8446f3949sm1817856a91.48.2024.08.28.06.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 06:46:19 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: unset the binding mark of a reused connection
Date: Wed, 28 Aug 2024 22:45:49 +0900
Message-Id: <20240828134549.5377-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Steve French reported null pointer dereference error from sha256 lib.
cifs.ko can send session setup requests on reused connection.
If reused connection is used for binding session, conn->binding can
still remain true and generate_preauth_hash() will not set
sess->Preauth_HashValue and it will be NULL.
It is used as a material to create an encryption key in
ksmbd_gen_smb311_encryptionkey. ->Preauth_HashValue cause null pointer
dereference error from crypto_shash_update().

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 8 PID: 429254 Comm: kworker/8:39
Hardware name: LENOVO 20MAS08500/20MAS08500, BIOS N2CET69W (1.52 )
Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
RIP: 0010:lib_sha256_base_do_update.isra.0+0x11e/0x1d0 [sha256_ssse3]
<TASK>
? show_regs+0x6d/0x80
? __die+0x24/0x80
? page_fault_oops+0x99/0x1b0
? do_user_addr_fault+0x2ee/0x6b0
? exc_page_fault+0x83/0x1b0
? asm_exc_page_fault+0x27/0x30
? __pfx_sha256_transform_rorx+0x10/0x10 [sha256_ssse3]
? lib_sha256_base_do_update.isra.0+0x11e/0x1d0 [sha256_ssse3]
? __pfx_sha256_transform_rorx+0x10/0x10 [sha256_ssse3]
? __pfx_sha256_transform_rorx+0x10/0x10 [sha256_ssse3]
_sha256_update+0x77/0xa0 [sha256_ssse3]
sha256_avx2_update+0x15/0x30 [sha256_ssse3]
crypto_shash_update+0x1e/0x40
hmac_update+0x12/0x20
crypto_shash_update+0x1e/0x40
generate_key+0x234/0x380 [ksmbd]
generate_smb3encryptionkey+0x40/0x1c0 [ksmbd]
ksmbd_gen_smb311_encryptionkey+0x72/0xa0 [ksmbd]
ntlm_authenticate.isra.0+0x423/0x5d0 [ksmbd]
smb2_sess_setup+0x952/0xaa0 [ksmbd]
__process_request+0xa3/0x1d0 [ksmbd]
__handle_ksmbd_work+0x1c4/0x2f0 [ksmbd]
handle_ksmbd_work+0x2d/0xa0 [ksmbd]
process_one_work+0x16c/0x350
worker_thread+0x306/0x440
? __pfx_worker_thread+0x10/0x10
kthread+0xef/0x120
? __pfx_kthread+0x10/0x10
ret_from_fork+0x44/0x70
? __pfx_kthread+0x10/0x10
ret_from_fork_asm+0x1b/0x30
</TASK>

Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 20846a4d3031..8bdc59251418 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1690,6 +1690,8 @@ int smb2_sess_setup(struct ksmbd_work *work)
 		rc = ksmbd_session_register(conn, sess);
 		if (rc)
 			goto out_err;
+
+		conn->binding = false;
 	} else if (conn->dialect >= SMB30_PROT_ID &&
 		   (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL) &&
 		   req->Flags & SMB2_SESSION_REQ_FLAG_BINDING) {
@@ -1768,6 +1770,8 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			sess = NULL;
 			goto out_err;
 		}
+
+		conn->binding = false;
 	}
 	work->sess = sess;
 
-- 
2.25.1

