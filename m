Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C29030F924
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 01:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784941917; cv=pass; b=IAr4pNLDUJ2RDVTyz3NNaG1vLveXk4xXoL9ghDsAPx+vNEs/2YLNpw1+SvecK+WOkZMMP3wMWt5+cglW0uLvOSj2qk0Kx81GYSwIp0+qB2WTILIayKHafub0F41A0mGEp9wIrRfFR7gGcxtBzBLUaQCVF06fuNv8RuzQN8QCYBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784941917; c=relaxed/simple;
	bh=rx48LcDphPgLSKhX4bF29wSiAifxrAA9jr6AS1Jb+tI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Y9xYrkq6NZ4god9Pe5GiCdg6TzeUzLn/30Z2Z1JorBIhJ5AnytongWI/EYEZc6E8j0Cmre7o4nLFoJ7K7X3QQAggo39zYsWcKf3FqBHUhXripw+SCfnYBhtGvn/8YOtKhVEVcopefQ3AU8+eV01GKty7fzw1MPdHamMud3okMzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R/BBxdXc; arc=pass smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R/BBxdXc"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8efb708b1a0so8978186d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 18:11:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784941915; cv=none;
        d=google.com; s=arc-20260327;
        b=H2Zkrrp3PEXkwG5DZ1ymm+PZVEViswTDgYXLsHuAaOvYsdbaoOYOi0i5SyGsiiw3um
         JJGxFIBN46va5SoGVRb/dns0Wp/VwnrzjK2mW+7e7eCYy1CuRZYBUcSIyTNkbvtgdowl
         ijNI+fFt4AquG++cEcyKZUJ6zk23O2Hbh/qeSswgkCcubuE523bmZFkDOWa5yHpnlQJT
         YnR2JOEhY38J2ZnayTq6gLxzSeEFUPXbz5aEa4+5VF15CXHg3B07aHBAZsp+cT2Icafn
         w5Nc1nyfZLza2j1Su2xBuCljqLpM0bIIfxZypDssPh0o98B2aH2gpIi3gAHJDfY2Y1Hn
         7krA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=HHEj4t5JqO5228+AyRGzi+7Y5IpGk0poTDWH6KePh4E=;
        fh=VVkPkarw+PLYoMTJpDMDdffr516f6iQGZCTnaldaXjc=;
        b=gKGB7rWrK2a9AzzO1JUYMogj8Rl4X5crww10KNq1StuFXnE6tM2V0nQr9J/K1vMlnz
         csSwcYKeQ4jxQXtmNQ4YErNPYKiToRjHsf4lptJXbSragWTPI5ZwRxTED1CgCUTAX1en
         drSh/QxIDV3Ypjkhtt7WfNbJlbRszHM3gxYqda6+1wYprRusPvc+U/u89if4D3ek3rKL
         g32fnCb1wdIKk5oMW3yWi4Ps3WGnaONJgWWyIbf/N+gw0hBfi/QmRupbEbe3uVY6egeK
         zFV0Q5Z3ejmMxkaPXvUQrXbZjEMMktc9OtcBmNG7oI85mE6afQmcqaTJaRHphQy++/EZ
         78NQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784941915; x=1785546715; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HHEj4t5JqO5228+AyRGzi+7Y5IpGk0poTDWH6KePh4E=;
        b=R/BBxdXclsqjiRxwIrK0jZ77d4Y68oWergZ/xTwJtHyp1aPHMs7oZukemc0An3AdQ5
         blfB3KRO4rN4q1+rLjKQkQjMblr+ZCxlJAg/j0BTeF0oTlWPhhG2+tFHq8vavm3yOVpv
         5Q/+BHLfRAhA8MYkGpuP63jpDLL8jHr/0YyzC1rExKw/354NylP+zp9rezGFLi7clHKZ
         +NpQu52efQBslppm6N5prUTzdl73lNbV8PS2GyHIYXejUqIwgooA9W9FdkjolILnNVc2
         2qDrLKGLXTrpx9LVIYeu5dURH+87lm1OUBc0dRReGLarrFMTSA0uyk1AsU0Ja0c0gfY0
         yz2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784941915; x=1785546715;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HHEj4t5JqO5228+AyRGzi+7Y5IpGk0poTDWH6KePh4E=;
        b=Y5XbGkywzXV4eLJHjTowpNPklmNuhhbl+aoaZfe4RaTyI+TiUycZYWcbDS+y4mNkxO
         nSYZACeYAi5rOZ6UoneWm91tCfNdw61o6vijFdwAD5Xk59fk6XInlO2HGr7gCCzkTtnx
         obXWqAaNSVmMcDZin9FzVWj493D8D56sOyZSkVPbnkAJe0uxY4FmGTGu4HFl9RnE59jG
         P6OPGRduYAGVGUVHs5+f/Boddp+QKLnWQrCSH6DehlvfZ297x/8aPaxWP/Lxz5ajEhI+
         leRI84NPiWiZ+tIJ1gfHO77XDnpC1ypDtIqEjYjHgPoYhFGiEVy+k+UbWwIH0QEMlU67
         41Bw==
X-Forwarded-Encrypted: i=1; AHgh+Rq6+yUuQbbsMo7DPSMPL0bWrN5tTfbU6S9jYOEm/cZ+ZCM6yPhToNyt98l67NkUKXUeMw0oweXQxrWr@vger.kernel.org
X-Gm-Message-State: AOJu0YyfsxMQxWMKVXHEPo94NxDTovc8yaMdvZuYF1m3y6oPJI65fPDR
	yu4RXVWG6dxa6WdlRULe/pw/0fLDRdi4Qy+N038RblMCnGGLtQF8THBQhX1nlXGSIZ/WBJ6meXl
	osLdpuj/zB27MbxT7HMoEGjQYnMYWLWw=
X-Gm-Gg: AR+sD11wqmeGNOlta0lvc2kdro1eNJyTzOUQLvWITm0QdfF8eGo1imwFC5i4RW3oHZm
	ZLRWEiCTK/RADl/mRysCq27PT8GawRb1voD0dGHOK21YD7ruMxrhtYYHZ6Ux6L+7bXPpCuoAZq9
	hpNdR2jjDd+hLmsvvsO03Cpwkk7ozzANzyGrgal6iQEwB5IuA6tqJD6f1SUAFc2zXIXQ/jeGcsz
	8Z6sTeAgBcrsgiEv4AYaM5Y8JGwrZKfxNlOlM9VbDUHSRDYqCHkD47M2yfYgQdlG0qskXyTvLzt
	6FiNNR7/u6+6BsAWuv99n11ACUqwNUlkqr6wJWF0xV2aTuq7GirwLu37ca1gNCrUduN6+j7qCvQ
	Ir8RqJpzlhuxlrw2diYzBMW8teP32Mx8uQDDN205uAXDbqihCvWRNxarpM+LoSKi79dcwNx6Vx2
	/0
X-Received: by 2002:a05:6214:e6d:b0:8f1:90f4:cb78 with SMTP id
 6a1803df08f44-907ec8860b3mr5521036d6.37.1784941914999; Fri, 24 Jul 2026
 18:11:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 24 Jul 2026 20:11:43 -0500
X-Gm-Features: AUfX_mwQdOj19B86vItvIHYBwjcUsrWVSTPWIY2AangraJDAdPDktDG1duXlLuM
Message-ID: <CAH2r5mtZzu=3b5uNP5+DoUXPXJ1nm3rJnLamJjM3aM5BOtiB2A@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
1590cf0329716306e948a8fc29f1d3ee87d3989f:

  Linux 7.2-rc4 (2026-07-19 13:54:41 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.2-rc4-smb3-server-fixes

for you to fetch changes up to 5e1b924808568e89c5cb132ecebe1824bd91af0c:

  ksmbd: reject undersized decompressed SMB2 requests (2026-07-22
09:54:10 -0500)

----------------------------------------------------------------
This contains eight ksmbd fixes covering POSIX ACL handling, SMB signing
enforcement, DACL parsing and construction hardening, session lifetime
handling, and validation of malformed transform and compressed SMB2
requests.

 - preserve inherited POSIX ACL mask when creating objects.
 - enforce the session signing requirement for plaintext SMB requests.
 - harden DACL/ACE processing against size overflows, incomplete ACE
    copies, and undersized SIDs.
 - defer teardown of a previous session until NTLM authentication succeeds.
 - reject undersized encryption-transform and decompressed SMB2 requests
   before they can reach normal SMB2 request processing.

----------------------------------------------------------------
James Montgomery (1):
      ksmbd: defer destroy_previous_session() until after NTLM authentication

Namjae Jeon (6):
      ksmbd: preserve VFS inherited POSIX ACL mask
      ksmbd: enforce signing required by the session
      ksmbd: bound DACL dedup walk to copied ACEs
      ksmbd: validate ACE size against SID sub-authorities
      ksmbd: validate minimum PDU size for transform requests
      ksmbd: reject undersized decompressed SMB2 requests

Wentao Guan (1):
      ksmbd: restore DACL size on check_add_overflow() to avoid malformed ACL

 fs/smb/server/compress.c   |  3 ++-
 fs/smb/server/connection.c | 16 +++++++++++-----
 fs/smb/server/server.c     | 10 +++++++++-
 fs/smb/server/smb2pdu.c    | 12 +++++-------
 fs/smb/server/smbacl.c     | 36 ++++++++++++++++++++++++++----------
 fs/smb/server/vfs.c        | 26 +-------------------------
 6 files changed, 54 insertions(+), 49 deletions(-)

-- 
Thanks,

Steve
