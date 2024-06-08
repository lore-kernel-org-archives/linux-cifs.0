Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457B8D2E5;
	Sat,  8 Jun 2024 23:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717890087; cv=none; b=Bq4xy30cGC0/Bb4zAg9kqPldP3RBOe5/pGTo10IQCUedn89VNVAPCPqjxaQV9ieFS9kX26DsrfubUVQ1pqsiTqr1sW5Fi6n8eeQ4FKbYlpsHXSubCgNQk1TWJ8v34R0t8oIMSWRz89KuU6T7FB2BWOYT/tfBh9w0tRUjIoO5yeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717890087; c=relaxed/simple;
	bh=O1B4nByr+fGXuo7Cj+bE7XDB0z9CzQ9nPn+ClxDbnQw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=splsIDLvMm59x/u156osUEGl6n2POuw6pwDMpDxkoe5h84s7eB0dhDZDvwlwZCUzrLuh+a4D1GQTvgoU/s1lOtrn1BiMGum7orMDycJqwHG9tFXDiwFh/52bBk8lQqV49fqZ1hMlBrI5o1wITmYO07oeeagvNRC3YQme+HWixKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=im8AQeD3; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="im8AQeD3"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5295e488248so3755008e87.2;
        Sat, 08 Jun 2024 16:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717890084; x=1718494884; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7rb8pojIjzKusW/K2QDO8cUOkG5F9hUZO5T+/iX63+s=;
        b=im8AQeD3LNzPoXl0Q6yPpW382gwiF+u1Q/scaMZ7PYtuyL2b22VV/4xQCjehqqMABj
         KwyQ/rx2JB3ETjo6V2v5cxT0h4wLF5MocgPxRjJEOFsc9eghbVt2+uBoF9qzV8tBaExq
         tXdGR8N2W0Ur+byU2cb4SQ8IKZTzRG0hhJT0+EVUPyJLYd/DSfYwULxlcd+ssFFIfLnj
         lj3hayW8WeEWo9pr6lfmFXM7Nrp7xODK55zxhBDhhMon4bej7odaEdqRcZU1mY28qScp
         4uIC3VS8wwVDSlhKiGBz1mAwkB+T+jW2gAp2Opif8F4zPCzKm8lYII14yvOS2o3YkGmI
         kToQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717890084; x=1718494884;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7rb8pojIjzKusW/K2QDO8cUOkG5F9hUZO5T+/iX63+s=;
        b=SV4QEoxkUGhVVSZ6/12ZNnPkyInGTkx2Uyt5adnDilf43srQALkNQS8ritUgUGC/dt
         bgW5RGsRGn8wZAHTCE6nQJPY7CaR3UNb3zYbECoVcrOrnk8+lQvlqskcdMtd502h4VB1
         MYtCYP66Ycuf4BkErNVjc9fL1k/Mp7BD7d1gZZWUFLio4NAXSiS6WrpTF04hvCbEnbaE
         Gt9QV07KYTteLaRRdtQS4Hc9PSMDRUT5nIWrg7fheG4xKwObKxjsuIcvZ6l248ckG01/
         jRb0XkVKcDyyFXZW1+qfR3VijGnZ6QpeQUOAWq5t4iEbE9Zu/t6Z5AnW1tV5C28U1bLX
         YQRg==
X-Forwarded-Encrypted: i=1; AJvYcCWp0tOPvCsqKH8QGNmCw8LXGgOhFrqudU/sN9/OsKfdV4XLcn6fhFDvgQCzrbhCpfSfUo8RX71lkyXCavouMcSMZSK66f/h1O5a5Bsz
X-Gm-Message-State: AOJu0YzQ0jbJYH2Iks7hUIirQw228Zm1PrZsgcJges0h/tsM3WW2duQD
	gTaB86AViWfjCg6Oy29kG05MqF1/U7HDxxDnR+tMLxSqrk24ogqKX/Hii/lSp3c3AQuI2WQgGfN
	759EKRmOD/9utMo7hfT0ACS+Kgmc=
X-Google-Smtp-Source: AGHT+IFWTxKa7uSDFZyQ4Hl9QSXyEbzjD7dYpBqnwcahslpdvL1t8fz+Tcf/5WBLDGHgq3RdKcD9Yjh+OWFR54kw7bY=
X-Received: by 2002:ac2:4989:0:b0:52c:7fc9:954e with SMTP id
 2adb3069b0e04-52c7fc9976fmr1329516e87.41.1717890084290; Sat, 08 Jun 2024
 16:41:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 8 Jun 2024 18:41:12 -0500
Message-ID: <CAH2r5muOwzD0cy_mZ5ydJfQLpmY4MYpKqYsHgAB1Z+qs6Gknmg@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, David Howells <dhowells@redhat.com>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
c3f38fa61af77b49866b006939479069cd451173:

  Linux 6.10-rc2 (2024-06-02 15:44:56 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc2-smb3-client-fixes

for you to fetch changes up to a88d60903696c01de577558080ec4fc738a70475:

  cifs: Don't advance the I/O iterator before terminating subrequest
(2024-06-07 01:05:26 -0500)

----------------------------------------------------------------
Two small smb3 client fixes
- fix deadlock in umount
- minor cleanup due to netfs change
----------------------------------------------------------------
David Howells (1):
      cifs: Don't advance the I/O iterator before terminating subrequest

Enzo Matsumiya (1):
      smb: client: fix deadlock in smb2_find_smb_tcon()

 fs/smb/client/smb2pdu.c       | 3 ---
 fs/smb/client/smb2transport.c | 2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)


-- 
Thanks,

Steve
