Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87EA7E
	for <linux-cifs@vger.kernel.org>; Sun, 14 Jan 2024 06:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zgp1KVQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54355C433C7
	for <linux-cifs@vger.kernel.org>; Sun, 14 Jan 2024 06:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705213650;
	bh=FsINH7q9Cs5IpZaqpXfIB+BPLRR6UGuyWE47/GXrQPk=;
	h=From:Date:Subject:To:Cc:From;
	b=Zgp1KVQshcGdZJXumBwAD2++FCjPZwHZUhIzA5I22oZO46uQIENiv42e26NNhy4NE
	 AgaTtaUy3QdO9o4QzpnjGZiD0EV+SKe0G4v4O9dHEnChjXSW2xzehXAk8g9z+kz9qs
	 SA88A/zLlLRwsULtCb3UUpSo3MaWAmjEgztxgrXwmEAoKawiH/4GrdO07aOv8ZH/Sk
	 V0w5jfD+X6C5h4TpylSZs3A1lpfg3UqXplaxYkOYZXRV0x56LvKK904MgkbnWZvSoq
	 Jf9KwenhRyS3hMUzaJAQRBWCa6QrPyPCkFVShjR0b8BRKJ9yh7vATldP8DzjriDaUp
	 dJAtdxh7BQORQ==
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6de83f5a004so2398842a34.1
        for <linux-cifs@vger.kernel.org>; Sat, 13 Jan 2024 22:27:30 -0800 (PST)
X-Gm-Message-State: AOJu0YxDePb/SWGd9f0jdXY1UlCDKNNsaevuWnoECEOeFZQTSA7DFlzM
	HKS/a93FXohNvMWGToIOazNwXC0gzOZdhtcSGaw=
X-Google-Smtp-Source: AGHT+IHYcbi/GV5KQfE4hCATxjHEAwp4Ae1Yb5wS38Ue2KCAylqjA7JQJIvhMQ9Z62tkD4fkewNE95WezkdDsCeq1ls=
X-Received: by 2002:a9d:4d96:0:b0:6db:fed6:a7fd with SMTP id
 u22-20020a9d4d96000000b006dbfed6a7fdmr4005324otk.4.1705213649533; Sat, 13 Jan
 2024 22:27:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:ac9:668c:0:b0:513:2a06:84a8 with HTTP; Sat, 13 Jan 2024
 22:27:28 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 14 Jan 2024 15:27:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-+bso=Aq4ReYFbQeAzJ4059YBQ9QU5uuMYPmEAiS-Cfw@mail.gmail.com>
Message-ID: <CAKYAXd-+bso=Aq4ReYFbQeAzJ4059YBQ9QU5uuMYPmEAiS-Cfw@mail.gmail.com>
Subject: [PATCH v2] ksmbd: update feature status in documentation
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Namjae Jeon <linkinjeon@kernel.org>

Update ksmbd feature status in documentation file.
 - add support for v2 lease feature and SMB3 CCM/GCM256 encryption.
 - add planned compression, quic, gmac signing features.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   - add smb3.1.1 prefix for compression and quic that pointed out by
Tom Talpey.
   - add gmac siging support that pointed out by Steve French to
planned feature.
 Documentation/filesystems/smb/ksmbd.rst | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/smb/ksmbd.rst
b/Documentation/filesystems/smb/ksmbd.rst
index 7bed96d794fc..6b30e43a0d11 100644
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
@@ -112,6 +111,10 @@ DCE/RPC support                Partially
Supported. a few calls(NetShareEnumAll,
                                for Witness protocol e.g.)
 ksmbd/nfsd interoperability    Planned for future. The features that ksmbd
                                support are Leases, Notify, ACLs and
Share modes.
+SMB3.1.1 Compression           Planned for future.
+SMB3.1.1 over QUIC             Planned for future.
+Signing/Encryption over RDMA   Planned for future.
+SMB3.1.1 GMAC signing support  Planned for future.
 ==============================
=================================================


-- 
2.25.1
