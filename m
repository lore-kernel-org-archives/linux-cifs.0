Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B513B637F
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 02:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068743; cv=pass; b=G4TDwFrBYihIZiFdjPVJOmBM9EzKvjMMnQLP+7ZouGYnAyRxRdkoU5B7RxVIujAuJ5PhwIuR3BYg2O87Hr2hsu3u4jvMIVwU8NEuoevo7Fuxh8PEDJmImNaKnB/PN5ha209T4XW7Y+4cU827M8EbrTbosIs301AUeMtw69CfeR0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068743; c=relaxed/simple;
	bh=te7705G1oAh5q/axfHWxsxOg2KNVPW+ie4XzNfPzV9c=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=CwaZk01Sg+JXiO8wd5tgMdZcZxwYkKfZqxoElz35zNPzo9L8eWocrywILoQvTdVRjA4hMes/5/I7+jr3u5FslKUrhMTtj8wjg7JH6yHNYfAYeIFmVmZhSZWRp7+2GLUovoCqTC1n0fWU2lvK2eHMk7og9BobU3obZiWUjxN9Bqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J3nv1bTn; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J3nv1bTn"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5218927884fso28645731cf.3
        for <linux-cifs@vger.kernel.org>; Thu, 06 Aug 2026 19:12:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786068741; cv=none;
        d=google.com; s=arc-20260327;
        b=ctEleVWu3II4lf5VSF7rms++ed4Og0ZwTAgSMZOy8Ip5IpyKmBD4BtVwnAzwi5Ff6u
         sZlEU1D9t/IRS2kFDrURnCBEegAxrsufBIgc3D/+5XSB+tMHpOObXnUor0sR7ezmGypl
         CEKk146s8W6UZwfB2bT8IZZzMa1My+EjWmk21Dqt6Tnj+2ZoBhQRbTvx1FNXL1Mnw5BI
         LtAdGE8Xvm5iPAXkaoahOm7fXMkpIKf/jxqrDCOruqlqqXLKjxy6OlxKjsSdtNzqom0H
         gMYt99C81AEV67UWzkl0TX9YJ3aDU4zLXa3NTU1JaDeLzddGoIHpHVCGITbSBTWxhcAl
         xOvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=hpe6pX+KB3Ob5tUDNgDq2Eyw1MKgA1YncIGmoJ8MOFE=;
        fh=5XDuC4gb/o5Y3DTz7FlziBQTiDT9Io/0GASx95nsOcQ=;
        b=p+Lsvlm/ll40AnFiQOvYHCkiFqTcoqQ05Slj3SMXPYpgC1goxMvlKeHwOmKyOUS740
         se/7i0+BGAtvuBBVfoQ/WPICC/zmIXTHy8dhG5ef8BsR+9Nto1Mx1Ta/hsyY8ynjNyg5
         xNYyeX47mkoN19jRHdcARLPwLQ77qJSp42MLdD0RfAf3NwXhkG9yhTfvfYS+Ff37wrOO
         +hXrGSxIy388Ufr0LYLg754pT+W7NUN+TYXoz/Zbo97GExnzSpSRQDsIC1Q2L4m9OUTP
         wuHENeBl7h4Rm1TRKBnpN8QxJQXPEnZXoV/ilTQa7HUkEsx5NWZuTBAtxhuf4nwFYqUN
         jpsw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786068741; x=1786673541; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hpe6pX+KB3Ob5tUDNgDq2Eyw1MKgA1YncIGmoJ8MOFE=;
        b=J3nv1bTnRuVwryXbAB+O29Ut0B7GC2cUhQWSsBOINrjkeq73duImTtqZIgB+L5ea0O
         zhIkgZ+Y1E7Pl+5Nu17PmA/rXfI3YUUugb7CK8Y5Uwz032yQsVIoTp919UU2P2yB5+mE
         9Lj+ioLm9SlLV3CHIOxd66x3jzjPrIK6fdWsl1AJQOHqCjQHgsY+lOo5daYCLwm3ZeFZ
         EMXpoRkVMNQaN0cIZXmCRvY6PGJqDkZLyP+XlmsMULBDOpkOGVywgaRNpk3pFvY8h3s+
         5dIUKM6fp4qJ7e42Ei9+Zk3dzHeWTEjIf7zMXD7/Eh7Bbdp98q+2/k5sJrjEpJIB5lUB
         h1dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786068741; x=1786673541;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hpe6pX+KB3Ob5tUDNgDq2Eyw1MKgA1YncIGmoJ8MOFE=;
        b=DMAJ7C5sUfwCWsiHAd7hhxlezuJ7eK7a1JqkDG1wwu8KMNJKpcrQ5T/JQURJqIlngP
         78BacIOYLcsMhN+MYgfi3+FL5Zh3D+9BgQexmWsfKNyFSPo5MuNVyh6YyhvpKL+33srf
         Gblek5Y8njQ3JZ1ckc1ZwcKZCzwWTuxZfUT/f9fOL6qn7JcFzPCRAIZqKNjOl1AleZfW
         dPI4nCu061sshbBb2xRwchiMRiTWdLO0D6XsUokNFnMEETkkfCqIWc4DZf1lzfRknGE8
         OojIaQ9AyfLcYUG8VMSGdjDXwn7VLzzguwyurpqDRQqb23jORc61FVYeCeUrWiLSDg4w
         UYKQ==
X-Forwarded-Encrypted: i=1; AHgh+RrzV43+dO98oEsKMQClOrJySVKF/dvj3WBD5/9zhfb6lZYp9M4hYUAKeZ611ig8lSqtA1CBjdxT6DJn@vger.kernel.org
X-Gm-Message-State: AOJu0YwKFMNtdIe5X1rLd2a90Q4Ou2/T6ftHNXSxqN5UsGcHzkNG9Gau
	+0lzFsxvDz7YaCXwcKR8aY+UDuIDsnYhAbQTkSEy5ktwwuwqmNA+4hflrN4w5DY+P6ioK51tDkd
	Ega0tHSylmHla4fA6YRF31CaUEZDQG5A=
X-Gm-Gg: AR+sD11fxUmNROsnvqJ6HxbnG/O1zDKQJbZKakOV0jtZ95g6KczRINQDyUPBgyyJ+v1
	pyeIVw3QQClhyJFCjzrwZrR4vGbkyGmYjxMYCX3njlHUksnEVvyNUCYT3Ysl7Rap41mtkVy9bGl
	n6uamORhhjTXuCJP49VyoRspVmPO/x6hQcgwugmCj48n1nWFXRYiWotsDHEqpyI5cECocdDPyQ+
	a9Olmv1himUfGaUNsCjAXedTVVZ8/rALb96q7ktsjlDfThIiM61tmQ7b5OCRKAxgEtOtwpy6pd+
	6/oJCpOYuFQ4zMpvq+ZwFDUvbuRlHU+tj6am0OdNg+yNwpjWBUvf8vPS61KdW38aMamCFVZK2tg
	BBq/2UF5huvRfOcBvwO1vM0Q5uDLmxrYgFW9jMtXxI0sIYcGMcBNMmx8tLT5Vd9XL03WPgOnkuZ
	LifKwmJBLjiHkTpqqlchP/EwsNKoF7JIpHLlUpkr4coQ6QBXcBrP9ZA15jYic=
X-Received: by 2002:a05:622a:124d:b0:51b:f98f:ea5e with SMTP id
 d75a77b69052e-52ce61146a2mr235697321cf.22.1786068741359; Thu, 06 Aug 2026
 19:12:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 6 Aug 2026 21:12:09 -0500
X-Gm-Features: AUfX_mw-uMMcuZ_EJKgm8XV1e275A5TqOzmzf_u_Fu3pjpFistF-f4O1C-T2x1k
Message-ID: <CAH2r5mtjBVPjsp1bGwhPsVd5cK7hyUSJUbKVtTdv8p85Y=RaAg@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
075b74841bd0065a3bda3440873c747938e69b68:

  Linux 7.2-rc6 (2026-08-02 16:24:24 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.2-rc6-smb3-server-fixes

for you to fetch changes up to ab88cb66cb0028cb8038b64c2fa71b0f3e91d5f2:

  ksmbd: apply the pre-authentication PDU limit when decompressing
(2026-08-03 11:21:22 -0500)

----------------------------------------------------------------
Three compression fixes for ksmbd server
- Reject Pattern_V1 payloads when Pattern_V1 support was not negotiated.
- Validate compression transform flags and chained mode before allocating
  the decompression buffer.
- Enforce the pre-authentication PDU size limit before allocating the
  decompression buffer, preventing compressed requests from bypassing the
  limit.
----------------------------------------------------------------
Anatolii Shumak (2):
      smb: compress: reject Pattern_V1 when not negotiated
      ksmbd: validate compression Flags before kvmalloc

Sujal Tuladhar (1):
      ksmbd: apply the pre-authentication PDU limit when decompressing

 fs/smb/common/compress/compress.c | 11 ++++++++---
 fs/smb/common/compress/compress.h |  3 ++-
 fs/smb/server/compress.c          | 14 ++++++++++++--
 fs/smb/server/connection.c        |  6 +-----
 fs/smb/server/connection.h        |  9 +++++++++
 5 files changed, 32 insertions(+), 11 deletions(-)

-- 
Thanks,

Steve
