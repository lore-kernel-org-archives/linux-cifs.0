Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BD033C8
	for <linux-cifs@vger.kernel.org>; Sat, 13 Jan 2024 06:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-28bc870c540so5983092a91.2
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jan 2024 22:46:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705128414; x=1705733214;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ihcc4kqZFV/E3AOuls4rSSEVxPRpmGjLFFpn1fYNgYA=;
        b=kdlm0hkMkG95a80wRaJcLh/Y1SRFzmHi9xCHS+RQp6Xh0lGJg7AjnVkRHlrdNl2Utj
         fpbks0enVgu/hMfR1VsJLtdP5+Fwoh61TzgZKSVJSCMmfG39cAXyY6ZC+jLZRv8HsupT
         t/81tZZzvSqvSmLEuJnYfpvw4LUZjloSJkE+rx/tDYEzj+oJf+758ZiRuWEya4laV2QN
         2fl9DCTyWzCkgxDbOKQq+9wdRoswyULJ9lrJ5trQeGBZBk/AQhjD/03gTu9CgbHAjLzD
         rqv//1PJ/8TbcnE7OWXPabWCOCauZeVX0TB5QGJ5j4uoxrP6+xnA6XwcJ0mhdVEVL1EI
         oyKQ==
X-Gm-Message-State: AOJu0YzT8tu2kJzSZ3EmFRF2QG2Fhgctmezao5Kt/RaolmbsMaz1LQyf
	27Q3mB36NCR1enOIw2l5AmDfBcR644s=
X-Google-Smtp-Source: AGHT+IGMMT4W8oWf7o9FtzbGK2RcfhOkSYKRLCqWVeRpjC4SGxV80cdYtMEl8bylxD6IKDwXZdAhAA==
X-Received: by 2002:a17:903:3251:b0:1d5:36bd:c61 with SMTP id ji17-20020a170903325100b001d536bd0c61mr2194419plb.87.1705128413638;
        Fri, 12 Jan 2024 22:46:53 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id kh15-20020a170903064f00b001cf658f20ecsm4225784plb.96.2024.01.12.22.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jan 2024 22:46:53 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: update feature status in documentation
Date: Sat, 13 Jan 2024 15:46:41 +0900
Message-Id: <20240113064643.4151-1-linkinjeon@kernel.org>
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

