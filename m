Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6877E13B58F;
	Sat,  9 Nov 2024 16:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731169196; cv=none; b=LdqihNapQTgNSL3WIVlLIUobA2FoYafRgfZOk5vl5vDHfYW8Nsmb00HqrEMZukoo8ppjDuSrSsHU2r4Pw3fiWsBS1k4GZVsg7WWoL9Wx7y20M6AFbcLL9LH1r9KUcXCP5cNA6s6XzNd1+HHEBZWt8ZbS0S0VOcDzZE9r5ra1sSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731169196; c=relaxed/simple;
	bh=l8DWwhPb0rAQmWp+sjg2gO133FCWzuZ0suwRAYZ/OBs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=myYnq2YTAt2ViOol/EdMSeCFuVRKXLiQmwD53b5tSRA73bXo3hGP8GcQgfClTEaX7CnpoW6Q3TToLUmDDblBsFAMVI+04P1F+PYlM2oGh0ot6oDoELMbWP5EqqXIbUgHoW4JWfVuzRBaBiefqfPhzVuEPPrFjSj90FGaHYC+7uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=grPm4TR/; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="grPm4TR/"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-539f0f9ee49so3714582e87.1;
        Sat, 09 Nov 2024 08:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731169192; x=1731773992; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mRWtlcyY2izEkSzYYIHE1UOiudA0JS/itRRT72CzCk8=;
        b=grPm4TR/yPgsuxlZgQ0I3GRfnsFO6sC4JdWtdsC7rFRQWHLaQ9Kd/DEoI/8lL2Dyz0
         Dq7WR8DdTxGOAyZDhMMVMmH5iD7aLRScdeKn+jAErCMFho/f7HbIZ6cb4p0yOz9161NF
         aC0q31J+nYnEzjht7dmU/tYzzQFNh34NJayLTQg0f3g91Uu+PqXznT6SglDurVAtqYws
         Mqxs7WZQfvRHq9p6OcvrmXkSmzEVSgvU8eY/73Y0ON+PVWwV77RMVQ1bg9gyaxCxFsKc
         aAsrHxk+kBeyojMblXzTU+spKm/Wpuhsg+yz6FkNHKDob427vj/4FgX0/2t0WzNtb6xi
         1H0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731169192; x=1731773992;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mRWtlcyY2izEkSzYYIHE1UOiudA0JS/itRRT72CzCk8=;
        b=IVI67afLuSMegnYc+bTeQVdUOP1uQQtU322yENt2uPlx/mxCkrkEfZQZ9F5tbA3+CF
         VDehoii8uuyG03VIAccu7X/yJpEFVeKsEdxTY1kTEbhLwI9dhRR7DzY4FMADnKLawIcl
         SOZSgeHsxtcUrFteR/GrLjsqmorOqz4u+hBu4v9CWSDwLjKjVe6YvrdANSjZCOr6/rGk
         D0jBRDdBfHqrrZ95izN7z6UCoOIGz7sTzQ3KxoF4KXHSGty1lw8Y9/Czz1SJf4v45vy2
         c6tMYMpjqEUzgHcKwMBfTB2uDBzfrrPti+M/ocnf1KMi4tBZI/l4La0D4XHD2NPN5/Ix
         JdJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsNFXIilaPhkz0rKBccvLbzmQiYHPoDDc0H/fmcRG69bd2TzT4GFMMzAKehk669rsOy6rEbtKMoRRxTDk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPmk1kDJh+hukJfjuBOILZLRUrbWHYAaXmfpMX7dfOrpD52Zkx
	cBnbrqhXbfrcDDkkrmuh1lstyRUiSctk5O0T1gpHbq/Qb6wOvxBqAhS+ssGaj3k56UY0EBIF/bO
	7eQCRhNl2ukI5ck7SsJuGDtacQIQcyw==
X-Google-Smtp-Source: AGHT+IESYsMfBl5b0SwnnUAxChpOuQs5RVrb5wAzmwjR7Yv8NJTD+tIkOBpES8SXi/YIS5G82URjls1A0inX0I6qkdo=
X-Received: by 2002:a05:6512:1090:b0:539:f705:dbb3 with SMTP id
 2adb3069b0e04-53d862bd9fdmr3393031e87.23.1731169192146; Sat, 09 Nov 2024
 08:19:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 9 Nov 2024 10:19:40 -0600
Message-ID: <CAH2r5muek3UG_akFmCon+NxksAUuWn9ZaY-AMiXSh9OLA8QvUw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
59b723cd2adbac2a34fc8e12c74ae26ae45bf230:

  Linux 6.12-rc6 (2024-11-03 14:05:52 -1000)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.12-rc6-smb3-client-fix

for you to fetch changes up to ef7134c7fc48e1441b398e55a862232868a6f0a7:

  smb: client: Fix use-after-free of network namespace. (2024-11-03
19:28:31 -0600)

----------------------------------------------------------------
Fix net namespace refcount use after free issue

----------------------------------------------------------------
Kuniyuki Iwashima (1):
      smb: client: Fix use-after-free of network namespace.

 fs/smb/client/connect.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)


--
Thanks,

Steve
