Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D622253EC
	for <linux-cifs@vger.kernel.org>; Tue, 14 Oct 2025 23:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760484318; cv=none; b=bImio9lWTpU2pNX+DSBDyXpquCNrGF7moYm8gG6wD+2qZfpbLv6n8DYNgRmatT/yX5j8D1HpIY1gvLfR7mrtx+yuHfhFdxg47mOdPMiQcLCtkborQlsBViT1I9BPOKYO2ZWc0kqqWuGAzRtZ5mPCyjWJhgurSGQ7IgrzIrOHcTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760484318; c=relaxed/simple;
	bh=iezhuMLpTo1eVQJh1lF5WALEZQK/SF3mWGY8dumH/gM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fp1YBuwoKmMSRIiQpDwoxeYW9Hn6jYacNklEs3R6U8TQYw7Q5IPSeqvZik0081ls9AKxTlbV5wAk5TRf/4WfdiNPROINanAo+M/qV9u1u/pqEjobn28BnkdJmy/4HYAbdQBXvvAe5AwHrkUANSs/euI6OAQ5HMwHABPH4vdJaOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m2aIPk+w; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m2aIPk+w"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8738c6fdbe8so6012756d6.1
        for <linux-cifs@vger.kernel.org>; Tue, 14 Oct 2025 16:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760484315; x=1761089115; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kf2pDAfVjngTpkzODXnMwe0Da3237xRoCmOAzAJbeTc=;
        b=m2aIPk+wzWcO9BLPKVFhtaZYJa0WgstUO1V+52Xe6O76gLtpNoUvOeqXb/M9JemqwW
         YeUSAK2veua4ahKK1w62zmhb/2bqF14RmWUUXpJvESQz7BBPpzknUd4DVc9nXaUxHZcF
         4TZQRVOKpRd1iC+kGelHT/rnKajQLsrailsdWsvGumT0MMHJykrAu0Ob3QFw6eXpEpDf
         cPHlB2mae+3k/5bALjAnUq5scAH7E8VKg68X9dy5leixX1f5ucCGkzR4/loLqAEYlA+A
         VDKMRSa0q4IRa0u3bVMHNV1AIHOP9E8cWY3fCuPLPVVI8QvggQWA/jVgcVOJ0vlJpx+2
         Sk4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760484315; x=1761089115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kf2pDAfVjngTpkzODXnMwe0Da3237xRoCmOAzAJbeTc=;
        b=oF8n2R5P9mwY+DZN7R3+Oae8yGOLmSR5hLJmzwSWtG7LyVvX2bfrVYiBP/e6MPFWxU
         Ah+dfj9A+b0lYLKFhfz/6jWedNkmhVvBNitB/6HN8x+1fBr0vzxNpV/Fyl3N7q/Uo4SV
         zIHushnzSoT1EVtQCz7ae21yPANxW/93mLNFG/NfcWCPLjII0pPWtE8VA00opCM3hNTa
         Nv4BPZFqWbPFcdEINMtkALU9U1PXkiU8r2CfXOkgqDBTVmTi2/aIpOPSSxE43bSQNVxF
         B79EB8E9DJxDHMHG/6/iMQIXzeMm+Le3WlDmQdknYW2x0mLH+YfEQ1waOGmzsXUnqH4h
         acFA==
X-Gm-Message-State: AOJu0YzT0nxm/TADlZURouM3twj9fRttp30ez3/xdCoEglRV7s1mDm4b
	SVCkv2UPfDUSEyNmdSoi5tBCWooz2m7vmscg/3oJIgibMZCw7eETONuu6oAw2kTmfbvQEe+KW6x
	Q77EGgL6YoP9nTtmfWjseR1ZqPpGHsVkMzg==
X-Gm-Gg: ASbGnctdMW7eCr59IGqIw3vI/tY/eCPcEMPdRAtep1MYk28dR1TzaC9/3AcBxqKWScQ
	8oijrnrF2b4yMgYtPRSruNw3mRf8vAN99HEPRx1XDZROyg1U53kfAU1KSlQAmSEQDjZcMEn/FIz
	7Eg3OtDAmIlcz1f8APzJLZf7PYSkg8SfvJnDfZc8qni+Z0GsQX4bJW5oI22tttS1Zp+GX50Tgtw
	9xMln4inKNnLyJXtjNx6DtZjlZXPUJjGHDAXilJst7iNRSZ9sqnMr9dIYAKjKaONHF7IULUmVP5
	mMviDzlTMBv0UJcDqzNqug2ajsIxkGQytP8nFu485PFLFEEr/aKl1bZ9xAvVMfu2S7Oew2eh7SO
	kQ3hLhHyA3+aGcBz0d4yn94BpMM83S9eGnlSmzso8p8j/9Jzwmg==
X-Google-Smtp-Source: AGHT+IGhOjo2tt/E54qCy7T45XT65HNL1+mWVXmj0qI/0XpYaTiuuMZ2Wznu7wTOpdkqZ5zJu8fHUjR4U3NVNcxxv/w=
X-Received: by 2002:ad4:5ccd:0:b0:87b:b679:167b with SMTP id
 6a1803df08f44-87bb6791d98mr254917486d6.33.1760484315513; Tue, 14 Oct 2025
 16:25:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251014231759.136630-1-ebiggers@kernel.org>
In-Reply-To: <20251014231759.136630-1-ebiggers@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 14 Oct 2025 18:25:04 -0500
X-Gm-Features: AS18NWCwTXgSEy-D8Bgt4esOjJoQx31sKEYEozCJ_QKBcZVRkt2wPJhyVw-YdHs
Message-ID: <CAH2r5mu6p+FGXb2aW2dkm2B9XOuSDnMc+eOMxtRV8JrYrd5X3g@mail.gmail.com>
Subject: Fwd: [PATCH 0/3] ksmbd: More crypto library conversions
To: CIFS <linux-cifs@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Adding linux-cifs mailing lists for more visibility to these changes

---------- Forwarded message ---------
From: Eric Biggers <ebiggers@kernel.org>
Date: Tue, Oct 14, 2025 at 6:18=E2=80=AFPM
Subject: [PATCH 0/3] ksmbd: More crypto library conversions
To: <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>,
Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey
<tom@talpey.com>, <linux-crypto@vger.kernel.org>,
<linux-kernel@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>


This series converts fs/smb/server/ to access SHA-512, HMAC-SHA256, and
HMAC-MD5 using the library APIs instead of crypto_shash.

This simplifies the code significantly.  It also slightly improves
performance, as it eliminates unnecessary overhead.  I haven't done
server-specific benchmarks, but you can get an idea of what to expect by
looking at the numbers I gave for the similar client-side series:
https://lore.kernel.org/linux-cifs/20251014034230.GC2763@sol/

No change in behavior intended.  All the crypto computations should be
the same as before.  I haven't tested this series (I did test the
similar client-side series), but everything should still work.

Eric Biggers (3):
  ksmbd: Use SHA-512 library for SMB3.1.1 preauth hash
  ksmbd: Use HMAC-SHA256 library for message signing and key generation
  ksmbd: Use HMAC-MD5 library for NTLMv2

 fs/smb/server/Kconfig      |   6 +-
 fs/smb/server/auth.c       | 390 +++++++------------------------------
 fs/smb/server/auth.h       |  10 +-
 fs/smb/server/crypto_ctx.c |  24 ---
 fs/smb/server/crypto_ctx.h |  15 +-
 fs/smb/server/server.c     |   4 -
 fs/smb/server/smb2pdu.c    |  26 +--
 fs/smb/server/smb_common.h |   2 +-
 8 files changed, 87 insertions(+), 390 deletions(-)


base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
--
2.51.0



--=20
Thanks,

Steve
