Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A66F21C164;
	Thu,  5 Dec 2024 16:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733415466; cv=none; b=H9mbrAAUbzM8JHWteZMoLZT4M5vBMrKN0EylbVUYjcrMrzYyl8VB0qSaZxcCEdPGvQhxc7GRkgmiiniX//TDtvAXIhj7bqElbBLQK7trqNkqeJeFs3eYC7ngcrdgyxiocV0FsiRt2LCuXf59c6uuLBSSEWrJpxJkC0Wvm0n3Z3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733415466; c=relaxed/simple;
	bh=mcTrAR8a4DmNUl1E/z7+TvNCe/LZUqWeMMwu1D1UqOg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=mPalIIj8gBagZ1kHEGWWgRB2GmaC5YHV0OlOd5oUCAEWDqXtX2DSIROz4CN5RC+bsdufBIMTM2NYuoRVHjvtqWVjc+I0NhpSYCD+X5nq3b5jcziUiFYfATATq9Mfmo9mq3S0wDPxEgHiCUd1YiOo531YLecN41IV0MI0GW/YjwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DuInaTP/; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DuInaTP/"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-53df80eeeedso1195300e87.2;
        Thu, 05 Dec 2024 08:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733415462; x=1734020262; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nb/JmQhc6KfEsPL0Mx/n12aavAN005keBbBzw0EhJw4=;
        b=DuInaTP/mVceLhDOEZPXm4nRsUnLBvYOaJ1bTV5VaG3jGG471rk6HeKHhAvvxqQfVB
         PW0B//d+fNZQPhK2iqXX9/P50YMohgHZIYhpufV+3LKiMEqxmLwnUmAMbzX874KVsjYl
         AIKexmAxBI9TZR+QRu1hKNTAnnlDzyWa7zvDtPBo3+rjhqpHwrUQixP6z+81rVeCloYx
         qVk8jwBbsADbWSvhpPgXRjDDjEBrvj52EyyTaaPTyC8RKYOIsrXLhc8kOjTGT8mxwcaA
         +ItCrL7CZx0lZv57inTosyowXgahkZbpLCLZIN3fx08gyucsTTjz0XpE4wQYKoxm1GDk
         VAgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733415462; x=1734020262;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nb/JmQhc6KfEsPL0Mx/n12aavAN005keBbBzw0EhJw4=;
        b=wr3XkSe2nKP4eL3KglsOmloIqHnGhaYYRk0ZN5foC7c8N8jSwuENnS+XCVf/QpnS4Z
         y7GLQOG0KzlcL2AdneKJfePn1sSPDlJha0xWavmgGTEOi6dGXxQvIfj1EzeDjTnGex+3
         1MbVXzYUO6lrGAUycRJ8VGGJw+tB2kRPlhEDLLXEfy50410lr8M9dDsZ3j4UanrD5BGx
         uUrGQxUUZ4DCp1TCP0S+RMmYJK6EHiWLhTHWDYKDW4RQU4JKDcJavSt5/6MRxCZynexU
         AW+LeN0OAQhlbHLH3aOe+00c2ocbg7l0gkA+h0VvP0nw2a+zZV/3W34OnNnpuy8G5/Nw
         WIcA==
X-Forwarded-Encrypted: i=1; AJvYcCXoXGHx2pjcma03aGeaAGS5UCp/X3uGRQ2o0ruxUKlnsPONshkU86+Qh6huNKg/blOsZWAkiF4vZ6eHDFc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0vrBbW8/Y+oP5YfA06n1YdZUwfupCVM1r/BGFaPd+SRH/UUlX
	TydsBOe+zBtD7a2Pi/pXJcp9iNljhioZRET/4mDYfAzl6KW1GwS1L1qqo+1vIZQaB2FEcAoa7Do
	KPuKRGjsK/lsg1IXfYJTWWSLrlD96cz9b
X-Gm-Gg: ASbGnctoaPTz3hZk5o8z1kP1zZ2Ic3qxa1SAD1tDNLIXVBBGdwXWBlkcoY/71lwhPb8
	pYq0sdspP99GbG0yBY/eMgGhDrJFExyPsGrOKcJhxf32I4aW4S7snhis0y+vCBCgcsw==
X-Google-Smtp-Source: AGHT+IHQN8FkgW7B3TSBittX8UFE3BY9k56wEfv3iiYcuVxczB8KtHK4VgFI0BBVzADuPkAUMaOJ4wDe+bgrQgfiT7o=
X-Received: by 2002:a05:6512:3b9e:b0:53d:ed69:a593 with SMTP id
 2adb3069b0e04-53e129fff43mr4639517e87.22.1733415462302; Thu, 05 Dec 2024
 08:17:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 5 Dec 2024 10:17:31 -0600
Message-ID: <CAH2r5mtvv021NNhBaHt2byQkFvPJ1cJ_oFSog02hOuRX2p8kpQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
40384c840ea1944d7c5a392e8975ed088ecf0b37:

  Linux 6.13-rc1 (2024-12-01 14:28:56 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.13-rc1-ksmbd-server-fixes

for you to fetch changes up to 06a025448b572c3bd78dd23a31488a0907cd9512:

  ksmbd: align aux_payload_buf to avoid OOB reads in cryptographic
operations (2024-12-04 19:45:28 -0600)

----------------------------------------------------------------
Four kernel server fixes, most for stable as well
- Three fixes for potential out of bound accesses in read and write paths
  (e.g. when alternate data streams enabled)
- GCC 15 build fix

----------------------------------------------------------------
Brahmajit Das (1):
      smb: server: Fix building with GCC 15

Jordy Zomer (2):
      ksmbd: fix Out-of-Bounds Read in ksmbd_vfs_stream_read
      ksmbd: fix Out-of-Bounds Write in ksmbd_vfs_stream_write

Norbert Szetei (1):
      ksmbd: align aux_payload_buf to avoid OOB reads in cryptographic
operations

 fs/smb/server/smb2pdu.c    | 8 +++++++-
 fs/smb/server/smb_common.c | 4 ++--
 2 files changed, 9 insertions(+), 3 deletions(-)

-- 
Thanks,

Steve
