Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2484B1E7A;
	Thu,  8 May 2025 03:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746675270; cv=none; b=eFa9ULB3q4oKZLE8TNxqb44gX1nTXjl7t2LACyj2DU6TFr13NgKYtQpmzQ2v7yE1eTHUqqXTSMPcuTmVNJZfLfXOJB8cNq1VrdzjE+VBfMUl9bGnGCkSLyY9rrJIMmMJ8dHM849Npvoaaveg3i0vcKFtbpECRBhHBCAPNP3mOm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746675270; c=relaxed/simple;
	bh=uXdkj+hTkdojfqIvqdoklrPedAqevSz+dSVNtv+pZw8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=qbaLgNKljBT5DxeXX0Xcbokc36YQIYv+nZd1TAxiOMBs7iP1iU8MGe1axwiohmPGoUndoabNEwX0PH2nmrCsZBH0iAkmjJi6fLQmCFtGnWnNhW0li4eZk+OFF8eE112sxSmNUb/LU5UK45RmKpHHuBz+9sYczVLAe64wP2hUJPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iKWrZ6NQ; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iKWrZ6NQ"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-54fc36323c5so9611e87.0;
        Wed, 07 May 2025 20:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746675266; x=1747280066; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Vs79sT1z9pcn5mqMpa25QtZJuWH27z2drEI50rV/J2g=;
        b=iKWrZ6NQl29bZWZRMGcQsvzpSgmg0h0+x4uRfgF7qsA1caqIf318WjqRNdCeXSAWow
         ywS0KGGa2/CD58WoPWM78gtCBhAkDzg5IrQCrpazQcJdW6AKy2vyMp0MxMkz6GfLG80T
         qzyJWyk6bNl+AI7PTKQsKKIWznzFT0xU8+YVJCLI1gIBIpNuYMoKvwox/cgB8dr5ExKB
         7IAjaTpz8fAURM2YclpVE9AmXIjcXPk1ZIgrLV0fgDkpYZ2enlwBZJowxBgTGTcyZd7D
         s4XV9fctIAvcEMWaKcqQBhMZg8GkLQzSVl4KjFEghxQAHwTERk4yFxIqccCFgNuI4ekA
         ok9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746675266; x=1747280066;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vs79sT1z9pcn5mqMpa25QtZJuWH27z2drEI50rV/J2g=;
        b=IkU5mGrvG/QQRfAnGozyZMgplws2F9oY/wRdsjE0ZUJ9qOhD9NgayfWGPeT/gZR3Zm
         AKUS7J22TEJYjsqFGy0mA1PS/V8jWOpFvhVqBB3iojs4gxHVckPAbXoOrGdFXDRbAVAh
         kpWRPGOjGk/8G2NUF/G9wUIgQWSJwFQXO03M0AYwxquYzUyNFmG/mOm1eBANOnD73DHs
         SxzniG0MNsxqMCv4CWzvZwYFjluegeVLVtXSu25rh6nBah2ljGPTpmC48ynW4bysRv20
         l7ixvxpcfliKCrr8RfrbPSnfQ/vmApNMmFgxsW7zwLlQLp7dKsQUFa4fyjk+53Y2ua0S
         TGEg==
X-Forwarded-Encrypted: i=1; AJvYcCX7d4OdwNNg158+vgrlgXzHlxj0XDMWkqhZ+U8p36gtg080hxpvfPoSxyDT+EjVpclMgDA9ZPSRMgUnTTOF@vger.kernel.org, AJvYcCXXWzAGXk0SNN8fn/aL4Yo6ugXFmM2M23ci4hecZw0BVMhh+yS1IUBWwA5z+VP6zBaPDk6TvXMNaSfO@vger.kernel.org
X-Gm-Message-State: AOJu0YzhZZNg9qkcHyNXzVJiasvUaC93sJRFsxJAh2nGARRSKn92akc2
	q3+z1/RpfpZpUazYQQwzCog3DZu3N2bNXblpO9Dr7PmHdzc0ay1whze6HzJpOyt4ISq1Lw8z+Ji
	iM3GvLqS8nVIpycyueQOZB9x34vg6IKRs
X-Gm-Gg: ASbGncsjfnPxqUCNeuIAvK3Dglx5NXfZ3b+2F5BBqm/D6S3pxAGTrOdDdUxeUbhuqla
	bycjnRETjx3zV2r1Gk9B7a+BzBZuzQGIkCUl5rFDOGev/wPpoYDyKdcqLZjrEXCc5CqBQgQgKI8
	FB+I8OlZhwPEDAAzSrqd2M9P4=
X-Google-Smtp-Source: AGHT+IFqdlXOoADn1dUreyEoDR3eL0pLNDbnFfRkc3P4LZdSrEXB4VzDHAxFfv9TfhdzPZ+wa3Z7HRzNKUSrRNzlSpQ=
X-Received: by 2002:a05:6512:104a:b0:54e:784e:541 with SMTP id
 2adb3069b0e04-54fbe41e56amr592572e87.14.1746675266286; Wed, 07 May 2025
 20:34:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 7 May 2025 22:34:15 -0500
X-Gm-Features: ATxdqUF8pqJhrhpfqZJwWnmu5w6ANJvVwe4AwgVBbrR3xAJbThyFwTaiJ0wVX6k
Message-ID: <CAH2r5mv5iu20LFsASnA=G3OUtrUAkp0CnKvckT+fbsYWzSAaLA@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
ca91b9500108d4cf083a635c2e11c884d5dd20ea:

  Merge tag 'v6.15-rc4-ksmbd-server-fixes' of
git://git.samba.org/ksmbd (2025-04-28 16:56:01 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.15-rc5-ksmbd-server-fixes

for you to fetch changes up to 36991c1ccde2d5a521577c448ffe07fcccfe104d:

  ksmbd: Fix UAF in __close_file_table_ids (2025-05-06 08:37:02 -0500)

----------------------------------------------------------------
4 ksmbd SMB3 server fixes, most also for stable
- Fix UAF closing file table (e.g. in tree disconnect)
- Fix potential out of bounds write
- Fix potential memory leak parsing lease state in open
- Fix oops in rename with empty target
----------------------------------------------------------------
Namjae Jeon (1):
      ksmbd: prevent rename with empty string

Norbert Szetei (1):
      ksmbd: prevent out-of-bounds stream writes by validating *pos

Sean Heelan (1):
      ksmbd: Fix UAF in __close_file_table_ids

Wang Zhaolong (1):
      ksmbd: fix memory leak in parse_lease_state()

 fs/smb/server/oplock.c    |  7 +++++--
 fs/smb/server/smb2pdu.c   |  5 +++++
 fs/smb/server/vfs.c       |  7 +++++++
 fs/smb/server/vfs_cache.c | 33 ++++++++++++++++++++++++++-------

-- 
Thanks,

Steve
