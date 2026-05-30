Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E55D2F8EB5
	for <linux-cifs@vger.kernel.org>; Sat, 30 May 2026 16:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159369; cv=pass; b=bbffk5ocnuvvQQcawMn+eClVygqNfyXxKlkH3l7dWdpdfAi481VaBkLlQpsxjdnw9xdyVQdAfRIRQwhLg/N0YAfMxXvqet4MANLeC9dZl4b7BlMmAQAOFvrVxPMSx/7N8kpVJcCTRVTuHjUaivOqasuNnlBzX34GammBuBosQZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159369; c=relaxed/simple;
	bh=qVo3UV4FAuryX//alBC0to213t23CMYWpaJ73/oA4jU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=EjrqFKLmFrZDCrJWSU3YpFdi4Wkr04wK+dR+4nSHySpULEKGRW6whPnGz6pEdJCS1oQs7SOgPW24Wcafi5eI9PK1mI+lzMGqi8RqJNrhszTxx1X6uf4IKbvrowID/zxlyHd+VDJYCTtBRIDSwvMJR0yNyPWrKCiynu40JvpdThA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jtMM4vx7; arc=pass smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jtMM4vx7"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8ccf887de87so5066716d6.0
        for <linux-cifs@vger.kernel.org>; Sat, 30 May 2026 09:42:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780159366; cv=none;
        d=google.com; s=arc-20240605;
        b=NNJ0hcF/296G8/qdj15+TZLqcvpnxOnzhF7gBUm/Q4+VpHwhMWsb5x9gUNMuGqcVc9
         g9Pqi8ce5hWoBf9CqdzemerTdubNeV7mESxrOBg8NO8PKaWIBX1E+kgko0Z893ppx8xl
         mmGdl7lWJ2xr/vd72n/VDWsE83YssnypygcoI8IsljNFWTle1j3fkusFVz/f+LRGeXli
         LgeyZIb/xzOU+2RgP2mxWShVpYCo+GRjCq06Qdpe6Wc2CfUiq+t3a4IyQp2BtPvwKitv
         bNSuGCVvCRRt5Wv8wNoxpAogpwkZ4TQuhXmttlaYnkuUIzQr2i+PlM6vHM/z+XbUgCy5
         /XmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Ghc8Sq4ZNBzyyR77SdwJ2IqDrxHM3BnoOIZVcMo/g/o=;
        fh=XFMGpRKbYjYBeYcUBVw7bRjQP4vCInC5a32mZugXF7g=;
        b=PwQtWJlr8UX3B/Kf+zzBtvb1jxFH/bBxZroPAw+pvwEhNUXDsa1h8As5e2OInWbx74
         4ljbdzz/EfItA5D2kcq0Ik5joGUevu5/us29snsr5wrAKSHuCb6akNWgfojivBqsBORm
         JjUlAIOkBJO2TJHKjdZ5kkRWQ48uE1ts4WN6X0/Vw+RBA2v2YW4x2bb9grAlUhy1NVT/
         M/5NFNMS+rtRjA+VcQemI8UTAblejOYQJKQusU7ya1zoZahLUbCBm3AJ6Qxgybu8lOO/
         UM3zYDelFWkvew68OSDiJyu13E6f7kL6wtjVu+MVXUqtXMfvuoAT86ovK8X8wC6+BnIW
         P8EQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780159366; x=1780764166; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ghc8Sq4ZNBzyyR77SdwJ2IqDrxHM3BnoOIZVcMo/g/o=;
        b=jtMM4vx7YbcftiN+8j4fC/zGypLjv5E1vAilzxgIEQ6y3COX4R9G4L9AAvadd1HRa3
         63JxBefZZzE6mGffdqyImPNrrauiEoHiODf+w44Y08HBXsM61nZkUJeSQiTSqyED05ed
         YN0oixSvbEKqBQit6lvob/mniYmRSejNRk4TtENlhSa9hexKNKgVQI7msdZ1zt0Jrhue
         Ddp/iJkUrjXDP4Q0lb6t+j9G6PmOFKmCJhjmOFnlQ0xKS7pue8WuFh8oaRh4+rh/G2Cg
         sevLC9yP8y1552CowXl57l++CHpnrFnsXZ0lRt3MpvIND+lXLz8VEYd0kHkaIeOv2E80
         cp6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780159366; x=1780764166;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ghc8Sq4ZNBzyyR77SdwJ2IqDrxHM3BnoOIZVcMo/g/o=;
        b=bapyZiS0FKJgQlJHs/iT5bYNd0Wf6XBjb8j1vF3po4m98+zZZzKr7ZmqYh5WJoQjl+
         J1vfaIAofvqadFkzkIWrzajWkPHkBTUZUb7XYpdke8pNWCLbPsyG9+19rFrpnhrofLVs
         54XbhvqaYteGH0tabsI9ETkW/YMfFLT/pIJd7UiJOpoZylAnRToB9etqgnmUPVIdn1rm
         7tAarY3agUtT+fKGTHgY0p/iGWI4MZ2uj7IjKj1qLN+4T2hVUrpIVCeK+BTu5NnCKb24
         QVWFlCNLaLXOoXhhmbdIrvnvuSHnU9Obe0XLQsGO/ZMRHh43VpH8ilvqbZjs3kDAQoIm
         rZGQ==
X-Forwarded-Encrypted: i=1; AFNElJ/sBwVPnFj2812xhhJhGKcVV9thggEgPw83CJmlZgzwDqzGr/TGp9yt9XO6YGa27A+uKwd5bgdGUUFA@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8aQdD/7mhbY15mNqs/bouzgqIOaSBC1Opmc3rSUt0GtYw4SdV
	ohTTu8yhTNmiPuhPJtIJLtuAOGCngVl1Hh3caJ3KAFW0zN3cuGGnqrlidsnRZMYjERYhYDmi5we
	cVfpZP8GbfVgTVKdvZN9nQasFKI8jCjU=
X-Gm-Gg: Acq92OFie4zkkY2b1pfi4F9SKWSd5iUg9M8GRgMbmX2fxsyGrqxM3Fpo/uG8JsEQoUO
	+Z53Xdq7wsklEIdkPyYDp4r090iESdjb/EWO5A0Sj2jFToYgQtQgKXlIUiWrXpeGCR+IkatSWeG
	yX+9u6ZyrpxxRyl4EiIXXTrkWZynckHyGf+72B+wtCo+Kg75ceYZ5UVag7V2IP9vKwTNzkDm9yF
	8Vmny8M04eqUhQgouoU5sk8u39xpGhXBMNhg1L+dEMKJqpKQl5Qbcq4D8Q40qAB8uK+8V6vyEHd
	2+zNDBj7fQnyaP93UoCaHXK8Gn5XgjZD4LXa9dS4Z08OWeqhLUc69EcMtwWF3PeeDyMMgbXJz17
	STyugWpfX0aNSdqxp4BffBNyOT0HRk9iKjQPLCu3kv6JpzNAeyFjd9kmBiAc4rBZl114sJYkEcR
	wqSKRSZ+KprQnJbV76GgOGqUkG8ETkzg==
X-Received: by 2002:a05:6214:529e:b0:8ce:f1b:74e7 with SMTP id
 6a1803df08f44-8ce0f1b7677mr15267436d6.25.1780159366148; Sat, 30 May 2026
 09:42:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 30 May 2026 11:42:32 -0500
X-Gm-Features: AVHnY4KK5KtFG_XRdQeVzrNs5FoPX9HYPrh7okehXPywqp6f8z7LVqogx5Z8j-I
Message-ID: <CAH2r5muLLb7n5GEOBo-Us5zXO7Gc5OU--UmA+f+i0vfMuo6eSQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
e7ae89a0c97ce2b68b0983cd01eda67cf373517d:

  Linux 7.1-rc5 (2026-05-24 13:48:06 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc6-smb3-client-fixes

for you to fetch changes up to 9d2491197a00acf8c423512078458c2855102b66:

  smb: client: fix uninitialized variable in smb2_writev_callback
(2026-05-27 17:15:43 -0500)

----------------------------------------------------------------
Two client fixes
- fix uninitialized variable in smb2_writev_callback()
- detect short folioq copy in cifs_copy_folioq_to_iter()
----------------------------------------------------------------
Jeremy Erazo (1):
      smb: client: detect short folioq copy in cifs_copy_folioq_to_iter()

Steve French (1):
      smb: client: fix uninitialized variable in smb2_writev_callback

 fs/smb/client/smb2ops.c | 18 +++++++++++++++---
 fs/smb/client/smb2pdu.c |  2 +-
 2 files changed, 16 insertions(+), 4 deletions(-)

-- 
Thanks,

Steve
