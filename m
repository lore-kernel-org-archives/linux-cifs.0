Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F116F1C2454
	for <linux-cifs@vger.kernel.org>; Thu, 28 Nov 2024 22:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732833180; cv=none; b=vB9aWU2wcPQZ94RHAyqX9EaIW7o8PTulOSWqbOibRyBqT6rpZvRkrLmxsWov7yZvv/QNPuo6ZzczQhR+olQc6vyX3KDKvOq3qL4SPxnE44pa53Oog1Rxm8rWldfEXjI0AKX72x5KYAZ3rHx2pi6Hmlu0HU51xsZ/6A89rb5GaZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732833180; c=relaxed/simple;
	bh=NALGaUCe9qSDRGU0QA5D4Pi4dLL7xNlKZj/X+lPcoeM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=TpKWDlniAcc7zJYqdDIWysn5zKoEA8WQkCQsO1Zg8L9Z+RIethOiM6/7YUrJaVR0y77xhcpergGJreYqlWZjqzsOX1Q6tYLO3abYxC+FFGo8qnrFqYP0XAVp/mttns6akx32Zv8JEp3WKK/Vx24Rq0Qr4GjRoCThMph6Qp4sNn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vyk6eg9j; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vyk6eg9j"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-53dd0cb9ce3so959660e87.3
        for <linux-cifs@vger.kernel.org>; Thu, 28 Nov 2024 14:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732833177; x=1733437977; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sIBdPkSCrxCBJkdEudve7dndPWnP79RuXCr/pHSiy4g=;
        b=Vyk6eg9jd9WBCfvXmHrWI+Jpa4IcWBafeKDCKI7xP/gijNVyn4zIsxSNWh8foE3Aol
         EKE31V4qRVzfuY5tQ4ExsicS9ZO6ECPQ5SKtHWT/17Khp/4VdO2gX+lygL7Ji0o/AKbf
         +wE5NX63JvlHDZJR70z5bChOF+VTMTokcbFYe2TBSI1aAg8tLGN8S0I68/BgGsqbw70h
         U9R8FAD7e4WOckRzWgJUj1h7nY4096H5kAGsjZPx7Hvf9OqYmd6SeMFpn8shTRNywt/H
         SSQWwfPdSe1DHYFsIZG+3HTpdt/oYSRI9P9enk18SOrYm99Qa67X9f0xJNauVH3vPQlm
         MEaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732833177; x=1733437977;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sIBdPkSCrxCBJkdEudve7dndPWnP79RuXCr/pHSiy4g=;
        b=WX81fNkhr2cv/k46kguBLPUev0fs6LKCgGidNaKpMXsSnsD+J0g/DLttuPfUx1jj/x
         oZtCprzPW/IP8pfx3VfdDUA6RNh/GclbkW3OeOBxMIps8yRXzY1jAsPPvXNS3T0O5Akw
         aEDQEvFAs1C4hg1QItydssL4fNdiRz2wdM4iEZNdADPRtXi+d7SBOyNfI0iudCPnfFFr
         QNsjP4FCWOVDYUZUoA4LE9v1Z5HatEbXleL51i5w3YsL/hUya8HpUEyt1YqYNFM+h6x1
         wp1pEHdmwj4v4YE1wxu32XANLBhqHRFVkDZDJbA8idcn2BCcpBmLes67BxA0sGY4deCd
         lqcw==
X-Forwarded-Encrypted: i=1; AJvYcCU3y1rOLmM6+NhU719R9q/HKoKfvaH1uQx9RYb+kQRFJhNU8tuQNUUlpy4LLVJu/dkfBmobDx6MMXwj@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4DyS8Yx4uVCPplr+GwDmhRRuNsVm2FRXxx8P8e0atms9bZNwZ
	ZVbrHdS1veZ8e20x8gCVTOpaPP1ZYq0l3nuAt5MjAUZa+q4PfsnveR//mkrDIe+jgulWJYG6p6k
	tJHCin1/nDNqTYpM1KxYGEJFvQD+9+GQ1
X-Gm-Gg: ASbGncsfHNkggsJ2A8Oq8DxwLdEHkAINGgK90gHD8doRIdhGBzc4Ix6mgijDJzKc+f6
	q0VaSIyHsfqfT+bsfSoxGjntzT+Nqyyjf/lerbpfXaKP80Nktl/zobvhFviQ5itmsig==
X-Google-Smtp-Source: AGHT+IEXmS6fXodU8OlUlJAaPMH9qfVfAbESvKBZy1YJh+lR8u7dwA2Ln/iLQhvhIW7HaMEIOGJc5h+wEyRLwChSHMM=
X-Received: by 2002:a05:6512:3d88:b0:53d:ed6d:71cc with SMTP id
 2adb3069b0e04-53df00c645cmr2727231e87.8.1732833176652; Thu, 28 Nov 2024
 14:32:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 28 Nov 2024 16:32:45 -0600
Message-ID: <CAH2r5ms2Omc5gZ_4CbTYMUAHzdadb3Yz7hLg_e92ZEnUQDYHgA@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
adc218676eef25575469234709c2d87185ca223a:

  Linux 6.12 (2024-11-17 14:15:08 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.13-rc-ksmbd-server-fixes

for you to fetch changes up to 9a8c5d89d327ff58e9b2517f8a6afb4181d32c6e:

  ksmbd: fix use-after-free in SMB request handling (2024-11-25 18:58:27 -0600)

----------------------------------------------------------------
Eight kernel server fixes
- fix use after free due to race in ksmd workqueue handler
- 4 debugging improvements
- fix incorrectly formatted response when client attempts SMB1
- Improve memory allocation to reduce chance of OOM
- Improve delays between retries when killing sessions

----------------------------------------------------------------
Namjae Jeon (7):
      ksmbd: fix malformed unsupported smb1 negotiate response
      ksmbd: use __GFP_RETRY_MAYFAIL
      ksmbd: use msleep instaed of schedule_timeout_interruptible()
      ksmbd: add debug print for rdma capable
      ksmbd: add debug prints to know what smb2 requests were received
      ksmbd: add netdev-up/down event debug print
      ksmbd: add debug print for pending request during server shutdown

Yunseong Kim (1):
      ksmbd: fix use-after-free in SMB request handling

 fs/smb/server/asn1.c              |  6 ++--
 fs/smb/server/auth.c              | 19 ++++++------
 fs/smb/server/connection.c        |  7 +++--
 fs/smb/server/crypto_ctx.c        |  6 ++--
 fs/smb/server/glob.h              |  2 ++
 fs/smb/server/ksmbd_work.c        | 10 +++---
 fs/smb/server/mgmt/ksmbd_ida.c    | 11 ++++---
 fs/smb/server/mgmt/share_config.c | 10 +++---
 fs/smb/server/mgmt/tree_connect.c |  5 +--
 fs/smb/server/mgmt/user_config.c  |  8 ++---
 fs/smb/server/mgmt/user_session.c | 10 +++---
 fs/smb/server/misc.c              | 11 ++++---
 fs/smb/server/ndr.c               | 10 +++---
 fs/smb/server/oplock.c            | 12 ++++----
 fs/smb/server/server.c            |  8 +++--
 fs/smb/server/smb2pdu.c           | 76
+++++++++++++++++++++++++++++----------------
 fs/smb/server/smb_common.c        |  4 +--
 fs/smb/server/smbacl.c            | 23 +++++++-------
 fs/smb/server/transport_ipc.c     |  6 ++--
 fs/smb/server/transport_rdma.c    | 13 +++++---
 fs/smb/server/transport_tcp.c     | 18 +++++++----
 fs/smb/server/unicode.c           |  4 +--
 fs/smb/server/vfs.c               | 12 ++++----
 fs/smb/server/vfs_cache.c         | 10 +++---
 24 files changed, 171 insertions(+), 130 deletions(-)


-- 
Thanks,

Steve
