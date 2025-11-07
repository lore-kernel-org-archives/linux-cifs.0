Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB202EDD63
	for <linux-cifs@vger.kernel.org>; Fri,  7 Nov 2025 02:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762483320; cv=none; b=RHANGMVnsCwz05qTYEDgv10ZraKl3XQrPzDmiNk07EiHRNB3IUbsZQg+F8v6jDdM7IjTs5mcGSErXLzkexIzUUSl+OL/OtAF3cDRlwF6IG4yY4AOp8EK1DOzLiPqA2ZoitkcmaY5i0GBiS/m6xYIPxbM4DeaHqx8jwBVxop9hWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762483320; c=relaxed/simple;
	bh=Q7q+6HE3gBACuPDLSuVD5gMut5hwjMOGYzMwDa2J+qs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Ycp0ZnswMa2pyOM8OuxuN3+LTCs3Sw3VzjNms32ANTK4ncejXFTwdNbi8n20sLNMy57opgpmPd+NtRjKNcohtg02UYNJ7c/z779/e8vzA7+l8jpruMKlEj2bGcTddE5HcuJ9TWqzW/HXgftaFYby9yYgmzufKSs4/0nUnNLMpDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZzRfi/MB; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZzRfi/MB"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4e89ac45e61so2202151cf.2
        for <linux-cifs@vger.kernel.org>; Thu, 06 Nov 2025 18:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762483317; x=1763088117; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GuX6ozITqfxTr69Iutw4PA8KBIRjaj56s+0CHhG7Hc4=;
        b=ZzRfi/MBNUwy62nCl2LQuaeBgZf9QuIwgXlmifrcxiQ9wQB2hZceILSCyyyq5a3NSH
         Qkl1Dlrz8VxlR9as6rlFKGXexn6tpwNDxmuycuLN/ehan6Cnxv0nc/b3CS1J6AI93kOz
         UFISTpAWS6SLjz5MN4OOYDSiVFeSYhfFkIWXse4bQUQmsySjKdmmISNgcqTVlXp577HP
         dhx8HN2jY3PtuuaKc9iRSou36LhclmqAxe2pm1OYS58CRY1QT/k5ihPOmjlHQOTLf1Ko
         YtHX3c3+/SsWckO451NgSrYftoILqYG8H2l3vl+Lh30c0v24aotHlGe/hVDRt/Brv6rw
         Jd5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762483317; x=1763088117;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GuX6ozITqfxTr69Iutw4PA8KBIRjaj56s+0CHhG7Hc4=;
        b=AozIwjQzI66ROYH0Oaxx0rMD1QZ+EqiGT3KZMCMG7+F3U0K64ky4yAIRcL4VfIFZ5k
         kyy0YZeaI8kZ8CcuvIK1I/uzFye05Hy20qbnVv1fg9jD7GFSMk8wQD/I2ba1dcGbyfLm
         82EiJDBlL5klNYSB/a4zXPJjT4/D4O8UXcLD2O9IEZ5n3TQTFTIv5S4gH6H5xyGjRlnC
         c1cTO/uCHMUHdzj/tiZ3B2R1RjJR96xINU3EF2qzpVGN9raiBaUKU+wSYvVxmnNOJWfu
         HxShvRvx5e/KeaIvZRgm4wyXa4Zk/gB3h+D14FPrd22RcaeTET0bbGRyJQBv/05riZqg
         Vp9A==
X-Forwarded-Encrypted: i=1; AJvYcCXaJCIj2KdvV6j6MupXA9F6/rdRxpK5c2AqhgWN0Xjy0VJe3svX1TUiHXQzKpnQY/Fm3/7dZ4bbsUsU@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb2gOazJI3FYcn7lb47QauDyCyt5VJYER6IBYpZuIW1cFe37lw
	k4anHVB4NCE8sSRi64Xg1yIU55BBBkkHUF3nhaFBjnv9bix8GefpfOo7SC3SQvZBbRn8G07quI7
	KOaNbnib4AxZ3f1cRQo3QX7sLgJmhqdg=
X-Gm-Gg: ASbGnctxwjA2qKiccHkw14ufiD6ax3XsC7C/CD1pf9RnbJSbNm3im4pewU8lFa3p/vY
	dBCzs3Ld2f5OfdqM/6g1pOhqcMlsnv1S0hJYGvwgBQKZpw/eapS7U++8x+HBJSB/CkD+6b8rtvo
	XFS6MwfxO5KwAVj/IhyZeayDeTWe5Mjudvbgb9fpMfRq0GRiPaqA6c2aT3TggTymrj0i9HNlzfq
	jaquSl6asgqEF3mBFYHBjt6PZGi/dOOXDbgdHMx5OwikrAF9rv25W6C1OTTbaSJTmZ+O15UogGM
	7M9KlNp/1iMP0DNwZdE2ho3WymvBFmMOsvdK4bA1WHBqPVeA9DaWmXIP/2+BWwQ72nPKRMXelTQ
	ZD8mgpeAK3/aEhw9nyZUfhuPmP329NYxkEZB1aUCtjWhjYYgR7NhGFUgap2ipgEAUyjcLcetFSo
	WFZTklhFtVl+4M4tyJ0Ys=
X-Google-Smtp-Source: AGHT+IG8du6mXS4YIE7YkG3FvWVLy9rkbo78r1iMccu8LGwiFJHEj4xS/Hg+LBgGfZTkQH+wVD0xqjBucNgSkcKvQgw=
X-Received: by 2002:ac8:7f4f:0:b0:4ec:f486:9f27 with SMTP id
 d75a77b69052e-4ed94a96916mr17252291cf.75.1762483317518; Thu, 06 Nov 2025
 18:41:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 6 Nov 2025 20:41:45 -0600
X-Gm-Features: AWmQ_bldFeideAXahC5S_-_FMH2uBiWUtixisdc9C4fudEWjXpTcI-FD3T_b3Uc
Message-ID: <CAH2r5mujzgdeMzwHrTaeK8fBNrpjcWyHCQkNq5Lm85ADL2pYew@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
6146a0f1dfae5d37442a9ddcba012add260bceb0:

  Linux 6.18-rc4 (2025-11-02 11:28:02 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.18-rc4-smb-server-fixes

for you to fetch changes up to e6187655acfa2dd566ea2aed4522083f0bb940c3:

  ksmbd: detect RDMA capable netdevs include IPoIB (2025-11-04 08:47:55 -0600)

----------------------------------------------------------------
Two ksmbd server fixes
- More safely detect RDMA capable devices correctly
----------------------------------------------------------------
Namjae Jeon (2):
      ksmbd: detect RDMA capable lower devices when bridge and vlan
netdev is used
      ksmbd: detect RDMA capable netdevs include IPoIB

 fs/smb/server/transport_rdma.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

-- 
Thanks,

Steve
