Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83CE33C8
	for <linux-cifs@vger.kernel.org>; Sat, 13 Jan 2024 06:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5cdfed46372so5640706a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jan 2024 22:46:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705128394; x=1705733194;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ihcc4kqZFV/E3AOuls4rSSEVxPRpmGjLFFpn1fYNgYA=;
        b=XRe16vzcjKh5Z8tKCMa6Omufv1RW13D69BGB2Y0U4CBu8//jOJCBCOuKQzDN1KHU+z
         84FcQua8OI7HEgJos2iu+V4Bggz+j4TBixgl2tdNVV5suvp94yx5jU4vo70EtK9W0njY
         3YpJg9ES+LK8k07dIUTExSSFiC9bBB8bc7QTWrsWrGvUNdCuxsNkrsx8pWefWF9LSlgV
         B3zabKmUYwmlWj9fuBZ2HrW1L+L55/dArlrWqzHOdiZqaD/Rz/j9g14wS32fTqwelmuq
         e7b+S3LXw/yzrxSNXRq4X9kzytaNl4Ocdjec9VQN+1Adsty1WwNBrSolKBrBTAEnzJgO
         mL8Q==
X-Gm-Message-State: AOJu0Yy1YDz2Js76DMzsYYTmjrk8mVEP1IVjiHFP3uFj17V+NuCOUnmW
	uWENH/OV1nFkVYBqzVScbayyqtWo++Q=
X-Google-Smtp-Source: AGHT+IG5uYNAIB2fjBAcN4HagEUjfewDun8xDqyFX8YEYXOmT63qbCG0ftkECBWLt1qZp4ElxrAm9A==
X-Received: by 2002:a05:6a20:1303:b0:199:a11d:921b with SMTP id g3-20020a056a20130300b00199a11d921bmr1949004pzh.45.1705128394620;
        Fri, 12 Jan 2024 22:46:34 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id e2-20020a170902f1c200b001d1d6f6b67dsm4208995plc.147.2024.01.12.22.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jan 2024 22:46:33 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: update feature status in documentation
Date: Sat, 13 Jan 2024 15:45:52 +0900
Message-Id: <20240113064555.3839-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update ksmbd feature status in documentation file.
 - add support for v2 lease feature and SMB3 CCM/GCM256 encryption.
 - add planned features.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 Documentation/filesystems/smb/ksmbd.rst | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/smb/ksmbd.rst b/Documentation/filesystems/smb/ksmbd.rst
index 7bed96d794fc..251e27900f88 100644
--- a/Documentation/filesystems/smb/ksmbd.rst
+++ b/Documentation/filesystems/smb/ksmbd.rst
@@ -73,15 +73,14 @@ Auto Negotiation               Supported.
 Compound Request               Supported.
 Oplock Cache Mechanism         Supported.
 SMB2 leases(v1 lease)          Supported.
-Directory leases(v2 lease)     Planned for future.
+Directory leases(v2 lease)     Supported.
 Multi-credits                  Supported.
 NTLM/NTLMv2                    Supported.
 HMAC-SHA256 Signing            Supported.
 Secure negotiate               Supported.
 Signing Update                 Supported.
 Pre-authentication integrity   Supported.
-SMB3 encryption(CCM, GCM)      Supported. (CCM and GCM128 supported, GCM256 in
-                               progress)
+SMB3 encryption(CCM, GCM)      Supported. (CCM/GCM128 and CCM/GCM256 supported)
 SMB direct(RDMA)               Supported.
 SMB3 Multi-channel             Partially Supported. Planned to implement
                                replay/retry mechanisms for future.
@@ -112,6 +111,9 @@ DCE/RPC support                Partially Supported. a few calls(NetShareEnumAll,
                                for Witness protocol e.g.)
 ksmbd/nfsd interoperability    Planned for future. The features that ksmbd
                                support are Leases, Notify, ACLs and Share modes.
+SMB2 Compression               Planned for future.
+SMB over QUIC                  Planned for future.
+Signing/Encryption over RDMA   Planned for future.
 ============================== =================================================
 
 
-- 
2.25.1

