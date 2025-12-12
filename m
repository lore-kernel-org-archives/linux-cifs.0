Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB83295DA6
	for <linux-cifs@vger.kernel.org>; Fri, 12 Dec 2025 02:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765505526; cv=none; b=MMeezE0HHFPSVrLDXiLzLATRfcYFkiwRSbP/CeJN+qqsNe8aPAPk5Ivk/Hlks7lBDZ7G8tDOz/azPJQS0yo9ma/IQL2jGXYb6hXXPUtRymyaoo8yagWCxFkRrN8q+dihjKmRj7Vt+8aMWwaH1oEEXUWblVPlBC2aVRaTBvdXcR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765505526; c=relaxed/simple;
	bh=K5CwS5uRP2VerhsjDrqiFtNcMvawo/aeKiYatOeJbX8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=f/OH4jTCz75kl3L0ikHprX/ZfN1skXJlxdQhlzysUKI58SpPyk/6jc4rpy//tr/ZMWmuibGl7w0KerswdIsU8W+Nmpm2IuXX+BuLgLUsfj1JgtZcvRsu6HkZpp3eG9jgg3ocqe7wnhDByWa4ga6bo/zYvu7DiSxb1RwUP5Dl4jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EKmve4YP; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EKmve4YP"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-88246676008so8780406d6.3
        for <linux-cifs@vger.kernel.org>; Thu, 11 Dec 2025 18:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765505524; x=1766110324; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wo6R6yr3cC8IptwRUuE5brZrvt11Y9pnMzSskaamYzw=;
        b=EKmve4YPRhYyGXzsQMGf5HcPBu0uk5C/cOR4OtejHURCPjWVF0l2lT6YKVegx4XNXM
         pFAIVqrjvJChMMFe0yWmtSkgeXxsOFJgrHQZu1DJa6VXHNe3XiesZzzYA1ah+egOJMMF
         ZFJg7A8vbp+iYdTRhnXPZ/uqF4/b/YrI19CLmY9x589PTLDnNNEDmdmhl31M/gA+3eAL
         WcgG4j0fvnkZe0bUMexxI5rXjXVGOek2HNfy0zUEcenmAuOoEJEZafk1VLK6SlE5vWhB
         vSZc9pvd2TEmELOecTYJrIu47GQS3h/N6dK/+OYBvykqo2eh+C9X0lR6hUr3iacuI/w1
         b23g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765505524; x=1766110324;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wo6R6yr3cC8IptwRUuE5brZrvt11Y9pnMzSskaamYzw=;
        b=LrcG5PSs3pvVeTh8LIW1qocnqsXU40O16+4Wi26FBSEChmYNBDpm1EHR0EwpaIiMKu
         MdYAHIt+FYXQ68c8vqzhkbfLSev6HL+B7nKwDd5d84uy8lSjG+EtaFWK82twMB1b9km7
         3KO2oGXFs4+FfHokMVoHDtMEri+Nzd4X0qBiz2y12uv5anwzwu0y+oyEM5jDaG5PZf6R
         IsjjrxDwmXnDCMipKDKDvyBVBLHt4z+4c041HhxyfXj7eHjjvsfF2YRBZKbaepOMklNe
         wdGn5BS+FxDp9CRc43a6v7TnjqaebhzCD/MEPfct0a4R/nEb+nooyFdfOWO2uwkSILTj
         Zzlw==
X-Forwarded-Encrypted: i=1; AJvYcCVYKOS2YL4fngOVCvghLeaUz/bvOgCC4CQZF+gu1KbviczmSJqrGnjcTHdweB14x1m8LSSvgD27BjQQ@vger.kernel.org
X-Gm-Message-State: AOJu0YxmniA2SBj/wM8d7UJeEZdr1Lne2GJRyaLFqw62fZeU5N8TwfTf
	AVgyDVT7YibWPcEjAk93eOEo7QUMOnOyE2hODHhcDa+SunznROB/FkgnlWD3Kqm7lPcJ8pETQOQ
	aBm12rP+FJhK7s1iTDdLWafqqoD1fO/8S+oSZ134=
X-Gm-Gg: AY/fxX74KoW62UhqgOlemuadef0Fyr14VbCF7/1vFKLofVDCZJyGKWLP3LbVHuTTmVx
	TCylzH60AFg6et+c4tEDPZs4GZ1g5gUN9BNaxMO8cjcFz2jI5UxADN6+V1EsqK6V60R1rqoMBAN
	PMAiu2mdGyG7kHYkeUETdt/iLb4vseWlw/DvHal2D/2ZKDqGvBe3BLFBLHL7UA+jyt2hm5A/TXA
	+Z8NxE/k1vcpNZFc0kp+XsytWR5gVFU+U6B7sFatRjUNx/FRX5YQgIvJ2sifsmPu91q0EbGhk6b
	o3k+M+5CELBpoIV8jOZ+24LIArvtU1tVc8if1rJj81lLd7kRcKfV6QUMUqPP44twgk6IMzB2q9p
	3O0GUxCy+cysF6TsUaca3xymj09kHXVP1WBKVDxGM0r02lv2ifQk=
X-Google-Smtp-Source: AGHT+IFXBHwVOlwfT93qVwzLIJbaQCTisSyBbBYw05BeQYrDjkp2eyggAKtZPWWGkuc5i43ToUZ5cfc5UmQWtWCq7uk=
X-Received: by 2002:a05:6214:3c8a:b0:888:59c6:7c43 with SMTP id
 6a1803df08f44-8887e185fd9mr11220096d6.63.1765505523981; Thu, 11 Dec 2025
 18:12:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 11 Dec 2025 20:11:52 -0600
X-Gm-Features: AQt7F2rBpbO1j5_3Xz0Ll0Rn95z8uYOalH5YQSNDnlwvobYi-VBeKSCOpUldJSo
Message-ID: <CAH2r5msAbUgccRkUFLPAyzR9+7L=4+=q6csmx6WXTAzMwOriYQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
3d99347a2e1ae60d9368b1d734290bab1acde0ce:

  Merge tag 'v6.19-rc-part1-smb3-client-fixes' of
git://git.samba.org/sfrench/cifs-2.6 (2025-12-09 16:09:32 +0900)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.19-rc-part2-smb3-client-fixes

for you to fetch changes up to ab0347e67dacd121eedc2d3a6ee6484e5ccca43d:

  smb/client: remove DeviceType Flags and Device Characteristics
definitions (2025-12-11 00:53:07 -0600)

----------------------------------------------------------------
12 smb3 client fixes
- Fix three incorrect error code defines
- Add four missing error code definitions
- Add parenthesis around NT_STATUS code defines to fix checkpatch warnings
- Five patches to remove some duplicated protocol definitions, moving
to common code shared by client and server
- Add missing protocol documentation reference (for change notify)
- Correct struct definition (for duplicate_extents_to_file_ex)
----------------------------------------------------------------
ChenXiaoSong (11):
      smb/client: fix NT_STATUS_NO_DATA_DETECTED value
      smb/client: fix NT_STATUS_DEVICE_DOOR_OPEN value
      smb/client: fix NT_STATUS_UNABLE_TO_FREE_VM value
      smb/client: add 4 NT error code definitions
      smb: add documentation references for smb2 change notify definitions
      smb/client: add parentheses to NT error code definitions
containing bitwise OR operator
      smb: move notify completion filter flags into common/smb2pdu.h
      smb: move SMB2 Notify Action Flags into common/smb2pdu.h
      smb: move file_notify_information to common/fscc.h
      smb: update struct duplicate_extents_to_file_ex
      smb: move File Attributes definitions into common/fscc.h

ZhangGuoDong (1):
      smb/client: remove DeviceType Flags and Device Characteristics definitions

 fs/smb/client/cifspdu.h |   65 ----
 fs/smb/client/nterr.c   |    5 +
 fs/smb/client/nterr.h   | 1014 ++++++++++++++++++++++++------------------------
 fs/smb/common/fscc.h    |   56 +++
 fs/smb/common/smb2pdu.h |   48 +--
 5 files changed, 581 insertions(+), 607 deletions(-)


-- 
Thanks,

Steve
