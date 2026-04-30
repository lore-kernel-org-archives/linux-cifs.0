Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9CC54652
	for <linux-cifs@vger.kernel.org>; Thu, 30 Apr 2026 17:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777571320; cv=none; b=cb6dJJ3xWVZTbmR55vHti6S1srJxMnEX/2YHpxtGWJaneAT8s6kkQDelHYMcwM/28EkMaIN0Q2ZSgRP6nEyfQ+Y8YHkFYSMDUaDt+GED6sWeP/rMmodRAeczIMK8d23LVpx0kjT8XhzLgNXvkHlG6RwOXiUkpko5+/UpK0AX7Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777571320; c=relaxed/simple;
	bh=GqJ6tP9cEJF8yaCQdar1w41VrPtzXU/fP0c4/Bu1opo=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=tCApUgqt5UdnMKSmMFeSusm71rtCccHaJgX/AqSetS+rbcODOI1m4zl/fdmFDsKuHSNAig8qEJkf965/doQUmXToxNnvFIxuUDy/DQ0Y+BbkI3WWNPwWsm5JLB28sSobd6xxPQ+V58RFrCQB1VndaaZc/q8OoMspRj87g8aLk7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cww5Qex/; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cww5Qex/"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35fb0bb27e7so795603a91.1
        for <linux-cifs@vger.kernel.org>; Thu, 30 Apr 2026 10:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777571318; x=1778176118; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JYOw483XEYi13+OUc/sCE63RTb5xjYzrdcvXYR+gxeo=;
        b=Cww5Qex/XzLaDRGsLk+Npo4JTV7hURwW//VhoQlldaer+fd3p6faw7YuxU4kLDo6qv
         Wr4vXkLtUSBdTw3dOFax3PcXlaXPQdOECA6B7bwV4ZZJ7ef6T6lGaJsGmv4CNxAXVjt/
         QAkjRHTyQWsbT+sJy+hjjjkAqL35QxtqWuAQB9dZCAGUwV+cxysyr8izpo26lFM+zI2m
         1Y4NLbluV2un0Z0lQXBi+9u4KVChhwmxJxdZRblybd0IQsopXtOSBYbogs4Kvt+H0Spe
         Snvq4hotoqNwBSmP+YdIszdJVNBddLdDHtp3bgtgNnSde4Gj1FP5hoRbHRUb4C8RlfHl
         FNkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777571318; x=1778176118;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JYOw483XEYi13+OUc/sCE63RTb5xjYzrdcvXYR+gxeo=;
        b=AdokDsLlE7Cn+ipyAqyEq0iI2rriW3xmkdyJW3+iaBAvjF46jaQYvOJerirVVlyQJl
         hBpf9W5UZtvL3fuepQ1Z6npQ/4ErxDFdse8muPZJ+KUZt/hFSRxc47UZ7xXKTORd8Mp8
         IaAfMoku78MjLqeIqsnw9Buwg0l4a98cK/1E7vLf1l4HKQRR53ht+YOjGkbaZz5xwbOv
         d6VirgaygJVQO9FrEBslOro+Ftosu9D5HmQOw7zC+O5X7s5DEYjPDoVZdGQSM8H0ArNd
         07KZjD68uNRAy0ofXae6WfzV+k7tKqjMGRqYzvFLUILS0Zo07GgtBvXPdtOfrH8PTS5o
         QNOg==
X-Forwarded-Encrypted: i=1; AFNElJ8RDJCX8sYYrVODccysP0fDXykuXV1f/NkwUxD5FjdRRK1w+2dLm+Afw19yP7zCMeb15LBsXWvdHJt8@vger.kernel.org
X-Gm-Message-State: AOJu0YxrQcYX5hWUtJWY5/AXdGraQgSrUrgkGDYHlR8qZI7djpetIkph
	D8tZbEsQUsu4QUIlIVWY+Rv8B59Ndkvycels/hPH6XJI9yuUcSsFGiLXXsfbww==
X-Gm-Gg: AeBDietWdZX0oDpuKVe+XF5Kg/Zn/3KmPaOBpJbxAhqS9NpFm8DADRW1jINEjWFYNRs
	uTi3qGEtfVrg9pfS2/Rf2Img7ZLphrhHUmmOIs2v2XHYiGRE040cODYr6w4J3ShP5NL47owbOmc
	QG+yM8Vfhqs//yCDwiJmP9Ua6s/nA/wzHWTLTaPD3OfU3TwSX9DH8jy59xnexkfC19+DywPxLtG
	b1oV3d4sUTSDZ2PdUpoWVu9K4VfT5zwyjCmH01ees2KEKxElhsCypF/dd4AeXtwNS7IBXVS4Dd7
	ud1mq5H1BM+KEQYJPF/G9CwoEB1d8QZJ94nPkafvOKB5hbxL1fEDKt+9TopgvKvIgchJLUMVypt
	6w1kFYyuQvz2P5VI1r2Xcil/YbIhmLoqhZ1qsnN0BJsEcNdGFPqz21K8Y2cZp53r+J8FdclewEV
	NOVjehNrGWrUguAX2ZbG6rViy2r3uYAe7JAbHk0gmwED7xtrAZbw==
X-Received: by 2002:a17:90b:2f03:b0:362:bb93:f25e with SMTP id 98e67ed59e1d1-364c312f38amr4265606a91.23.1777571318048;
        Thu, 30 Apr 2026 10:48:38 -0700 (PDT)
Received: from localhost ([49.207.150.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364bdf531e4sm3215579a91.5.2026.04.30.10.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 10:48:37 -0700 (PDT)
From: Piyush Sachdeva <s.piyush1024@gmail.com>
X-Google-Original-From: Piyush Sachdeva <psachdeva@microsoft.com>
Subject: [PATCH v2 0/2] smb: client: Spec-compliance fixes for Kerberos key
 derivation
Date: Thu, 30 Apr 2026 23:18:22 +0530
Message-Id: <20260430-kerbmi-v2-0-0b98fe250425@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyjHQUlJIzE
 vPSU3UzU4B8JSMDIzMDEyNL3ezUoqTcTN2UZAMLU+PkFCPLtGQloOKCotS0zAqwQdGxEH5xaVJ
 WanIJSLdSbS0Azr6/WGoAAAA=
X-Change-ID: 20260429-kerbmi-dc0853cd29fc
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
 Shyam Prasad N <sprasad@microsoft.com>, 
 Bharath SM <bharathsm@microsoft.com>
Cc: samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
 vaibsharma@microsoft.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2612;
 i=psachdeva@microsoft.com; h=from:subject:message-id;
 bh=GqJ6tP9cEJF8yaCQdar1w41VrPtzXU/fP0c4/Bu1opo=;
 b=owGbwMvMwCV29FJ3ncRHDT/G02pJDJmfp75fI3ksbQJDR6flvRvW/uWzlwdXPLni2u05deqe1
 xdWFeu4dUxkYRDjYrAUU2TZcOKOLG/8Lsl5n54YwcxhZQIZIi3SwAAELAx8uYl5pUY6Rnqm2oZ6
 hkY6BjrGDFycAjDV6skM/0M0j8b9mKXgPrs3eEnfzukhm3RfmM/a+iZUJSqyTyPRUJ2RYdeKqt7
 Hp1um8P45es+Bydw9zWmaue2bCXvmJyy76nvgBzsA
X-Developer-Key: i=psachdeva@microsoft.com; a=openpgp;
 fpr=80350F71F916134953C3EB979E19C6F9839C3CFC

This series fixes two MS-SMB2 section 3.2.5.3 spec violations in the
Kerberos session key handling path of fs/smb/client.

Patch 1/2 (resend of v1 with a small cleanup folded in) fixes the
AES-256 mount failure with sec=krb5: encryption and decryption key
derivation must use Session.FullSessionKey (the full Kerberos session
key, typically 32 bytes for the aes256-cts-hmac-sha1-96 enctype)
instead of Session.SessionKey (the first 16 bytes).

Patch 2/2 closes the related corner case in the same section of the
spec: when the GSS protocol returns a session key shorter than 16
bytes, the buffer must be right-padded with zero bytes. The current
code copies the GSS key verbatim, which causes generate_key() to read
past the end of the allocated buffer and derive keys that do not match
the server. The trigger is deprecated short-key Kerberos enctypes
(e.g. single-DES, 8-byte session key); modern KDCs disable these by
default, so this is a latent issue rather than a reachable one, but it
is still a kernel slab over-read and a literal spec violation.

Verified against Azure Files (AES-256-GCM + Kerberos aes256-cts) which
previously failed to mount with EAGAIN; the dmesg "Session Key" trace
under CONFIG_CIFS_DEBUG_DUMP_KEYS now shows the full 32-byte session
key being used for encryption/decryption KDF input.

Link: https://lore.kernel.org/linux-cifs/20260409161538.3618-1-s.piyush1024@gmail.com/

Changes since v1:
  - Patch 1/2: initialize full_key_size at declaration to silence
    -Wmaybe-uninitialized on some toolchains, and drop the now-
    redundant else branch (self-review).
  - Patch 1/2: tighten the FullSessionKey condition to also require
    Connection.Dialect == "3.1.1", matching MS-SMB2 3.2.5.3.1 verbatim.
  - New patch 2/2: zero-pad short GSS session keys per MS-SMB2 3.2.5.3,
    eliminating a latent slab over-read in generate_key().

Signed-off-by: Piyush Sachdeva <psachdeva@microsoft.com>
Signed-off-by: Piyush Sachdeva <s.piyush1024@gmail.com>
Bcc: vaibsharma@microsoft.com
---
Piyush Sachdeva (2):
      smb: client: Use FullSessionKey for AES-256 encryption key derivation
      smb: client: Zero-pad short GSS session keys per MS-SMB2

 fs/smb/client/ioctl.c         |  2 +-
 fs/smb/client/smb2pdu.c       | 23 ++++++++++++++++++-----
 fs/smb/client/smb2transport.c | 35 ++++++++++++++++++++++++++---------
 3 files changed, 45 insertions(+), 15 deletions(-)
---
base-commit: 0cbc300257d9b399491909806777f504ec687c1d
change-id: 20260429-kerbmi-dc0853cd29fc

Best regards,
--  
Piyush Sachdeva <s.piyush1024@gmail.com>

