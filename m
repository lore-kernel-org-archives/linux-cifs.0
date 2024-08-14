Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9370C39FE5
	for <linux-cifs@vger.kernel.org>; Wed, 14 Aug 2024 23:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723679806; cv=none; b=CwPR7H8yL80HNEtvvyGNFRIJ/n5nOCwjLNWpL33FzEjEcxgmq9mw4gfHrR4AR+mRM2gVwjVfRbWSuHhnyahxg4BdKdWN/1hbK79DefEYRgY/GlGAfyZcx7E0I4cpnvfka6rKsW2L4c9Kx+QueVV/Zg3UUQTqy4QsJVtfCD34gjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723679806; c=relaxed/simple;
	bh=y1Z7GTwMpLTzESOJDbnKIpGhBqmmKgDL78p2kSwC0OI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lITld3jPznyDsChBT1KVxbcgFGwl/4c1hX2C8uJhWPGuQGJXpFWBlTRRjkBc9csdbdVfN/epqxE1r6dvX+MtSRgp+YSC0L6xLGs2tuqewzEFf5ubdHWq07guiEAuZAsv/PHnoT1iGnUEICL6fhY/DUTa+mcfz4gJPAwToPFpWI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-70ea2f25bfaso298808b3a.1
        for <linux-cifs@vger.kernel.org>; Wed, 14 Aug 2024 16:56:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723679804; x=1724284604;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Q3Vh8+ZDHeLUWySJsxTmRO1M1vjWxzjOx+Pg5HYY7I=;
        b=wN4UjeEbOdes/FXQPQLPSaEOJ1WV9e/mHfzCU5PQHP5KGY5Y1UBwBOQHMbKxVuT9Kp
         GuOBcyJfIGZY0Am5WVjJh0Gz064ix8l7O+3cqLSRBe77JkkzgW0yTXyy+rYGP9bWJeOk
         tRTT89zhEyhvTQXUqc6G3e6ahlLYHuuFWmwkOcxg1M7QVmvJh0uU5khGxrKiS9jw4zmf
         8nGOFQpshTvBeubmEh0pJhwz4FrasDQ5XHJeOt/F5RqivvNXiW6gF9o5+hsxwMhsRnec
         iZOmQDSjpnhjhXLs772luE/OW0ZuVsVIcy90Mi8yq0Zg/1oS7lIDHs1SfO4a0hwWDT16
         dZdQ==
X-Gm-Message-State: AOJu0YwpHlzhYjRP7tJu8ALDrLgxeILdwDKcN29xzaE4xdB1egGZZgza
	W/qCI3A8A0E2+PTDubj7iFslWcyryBiE10trNtQAg5bie5vERDCHxEtjCQ==
X-Google-Smtp-Source: AGHT+IGJ+mfL93NaX4sS97y5+IvfbzXMG0n3F75BSDBQ1hdBncNI6XQxbpaL8JhOtJg6YpcD27bfUA==
X-Received: by 2002:a05:6a00:1894:b0:70e:98e3:1ae1 with SMTP id d2e1a72fcca58-712671042admr4901471b3a.9.1723679803677;
        Wed, 14 Aug 2024 16:56:43 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127add3ea3sm136306b3a.16.2024.08.14.16.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 16:56:43 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: Use unsafe_memcpy() for ntlm_negotiate
Date: Thu, 15 Aug 2024 08:56:35 +0900
Message-Id: <20240814235635.7998-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rsp buffer is allocatged larger than spnego_blob from
smb2_allocate_rsp_buf().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2df1354288e6..3f4c56a10a86 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1370,7 +1370,8 @@ static int ntlm_negotiate(struct ksmbd_work *work,
 	}
 
 	sz = le16_to_cpu(rsp->SecurityBufferOffset);
-	memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_len);
+	unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_len,
+			/* alloc is larger than blob, see smb2_allocate_rsp_buf() */);
 	rsp->SecurityBufferLength = cpu_to_le16(spnego_blob_len);
 
 out:
@@ -1453,7 +1454,9 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 			return -ENOMEM;
 
 		sz = le16_to_cpu(rsp->SecurityBufferOffset);
-		memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_len);
+		unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob,
+				spnego_blob_len,
+				/* alloc is larger than blob, see smb2_allocate_rsp_buf() */);
 		rsp->SecurityBufferLength = cpu_to_le16(spnego_blob_len);
 		kfree(spnego_blob);
 	}
-- 
2.25.1

