Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4E42AD0C;
	Fri, 21 Mar 2025 03:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742528600; cv=none; b=ew7zkhde26AAOygtbuzvuGK4ZqzUq9tripiTtabY0q5fzpb3zvbEwMbiH1I3No62y/g+WjvUs5Pek7NYyFITiHY8iP9x70rf0BhS07m5+Qe9fxqYI1X31tRxssNgjHwQGdhP36W6nsUKq7awjaV6M2hntH0Jyo+0obRcEU97ZFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742528600; c=relaxed/simple;
	bh=IdxaG9TX0F9ExNqzft0RHj4RFEmulvjaCOKZDDZ1Tzk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=cqQs+l98++uP6M/7/mDX5+mSusb+VCuMhIZ30dd/ClZsOVYi6/R1o13ZGSsVPZ19GfzTWi8uE2YPKmRS6TGqISC5TSEJGbKAAMXAcnHeWdhu014Osq0gTIxOoVSkVJ9I6/MsDYwNYNK+aBKMKw5a3+9eU08JNFbOmbwnanwkgWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CNC1lPl5; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CNC1lPl5"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-54ac9b3ddf6so1579969e87.1;
        Thu, 20 Mar 2025 20:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742528594; x=1743133394; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dF2bDi3yJw0vfILvMVMYaCRrtIP2oPzcZE7Ah0NFL6M=;
        b=CNC1lPl5jUDWZgQOk3j3Qt/K1Wty5BQVzmd1STyfwL6XAtpFHjN/GIUkFxwCf9xAVg
         Q1J5Ku4UQB/+79qd7vTNg7+GvmWHx/Wnkp3X5OvYUW+Wb2wHsFc0MACFZIcmqiLiohq6
         6DerCWlGHfPyhp7dmPWpzWe9SHnWgzBdi2ry/UZVqzOmCUORBOzWBYXAvhn15Ou8n5o1
         SP5R9ifaN5VeFTN+2yhuQAr4mXuOxp3V3bkWQ8FTHj5Cei71NdO5E9rhTOZZP21gmWxD
         hl+VNvJyHTaE5uEtgImYXB5W6Igba8r4TInOMKFSJcXrap0USHBFZS7D3x8InlIVsW2V
         ugTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742528594; x=1743133394;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dF2bDi3yJw0vfILvMVMYaCRrtIP2oPzcZE7Ah0NFL6M=;
        b=Q2gaYYZpptJoLfr51/7gZFQzb461lhCh9omGGPlhJfC55z2vLvG8zFZAvF+TaiXgnc
         4hFEKyQChPZOT+i9pxHbwEpkK8et4bIshYQ1QFAZcLy0H05UzNx2tYLJxMC1vv6AoClG
         JLIH7mJdfXaHnpjkYZD8e/wrH8dfIy/YFwUephi7fzykqdYX0G/FsR/TvF4bfcuArQeO
         09LOkDg5fF/QYIJlmSOd2LqNykxhklTgGs4CZcl+VEIBrmieq4Jg9TUaf4BNfAVvWtwt
         m8XnwSIllnzMHCVSNRSv0mCqpmU8WDMdYmUYPKGm+qdYm5xhM53XLyHqwtVy6SkxMKQt
         DL+w==
X-Forwarded-Encrypted: i=1; AJvYcCVPQvCCaXPXPn/VFEfPnHEv7P9W8IJf+qhvTwEQzEvv8TrNcg89PNHSm24Kex5O9elJphLOqTOTTWXP@vger.kernel.org
X-Gm-Message-State: AOJu0YxyhqNoFEmkM83+v48MI6m4UymPl2ArPzlgHp58P6WQf0/uEUfw
	JA3BcFfS7MkDVDohZ8iKNs+KG44ScTVst2yWXBsfKxDagFuOPJj602e5KdTCORXuPuJ+MoW98Xu
	Oz5SLvyn3Tl+Vceo7teWnhkwrLgisaabo
X-Gm-Gg: ASbGncu+MMUoOjX7bQPSrHA9DIoBCxqSpCbFErOWHBlWRtUeVtMd1l4y4xJq3WUMRDM
	x+c48rLoDGkY5sIkgXxUcvx2Ec3Z5a/qUcfBk39aDdCx925bexeurWODUHtLQbwXduujyy7h/Uk
	Q0OedsUh7zoPObWfdirYmrY9o/W5tvexl3GsqTxdMhLPnH5vqIXuHzhAXq91s=
X-Google-Smtp-Source: AGHT+IG3hjVDe+I2qdG2q7GrheZXfSTRUTrN9aiMZGsBtp0uN/lni6VbIbqP2qxDVfjorSMVttUN9+QTNPVurh2kkFs=
X-Received: by 2002:a05:6512:3d0a:b0:549:4d7d:b61b with SMTP id
 2adb3069b0e04-54ad64f4f01mr577430e87.35.1742528593869; Thu, 20 Mar 2025
 20:43:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 20 Mar 2025 22:43:02 -0500
X-Gm-Features: AQ5f1Jrve5aqF1OMeYoCPODC5kORF22PncMwM32JYd_lD85H9azvLi1WOsyw7Ak
Message-ID: <CAH2r5msU7_yWYT+waaDx16Bi2ejPJDTUmeMczXOVF1+wPUXvEA@mail.gmail.com>
Subject: [GIT PULL] smb3 client fix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
4701f33a10702d5fc577c32434eb62adde0a1ae1:

  Linux 6.14-rc7 (2025-03-16 12:55:17 -1000)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc7-smb3-client-fix

for you to fetch changes up to 7643dbd9db09fffebb4a62cd27599f17f4148b17:

  smb: client: don't retry IO on failed negprotos with soft mounts
(2025-03-17 17:33:13 -0500)

----------------------------------------------------------------
smb3 client reconnect fix

----------------------------------------------------------------
Paulo Alcantara (1):
      smb: client: don't retry IO on failed negprotos with soft mounts

 fs/smb/client/cifssmb.c | 46 +++++++++++--------
 fs/smb/client/smb2pdu.c | 96 ++++++++++++++++++----------------------
 2 files changed, 69 insertions(+), 73 deletions(-)


-- 
Thanks,

Steve
