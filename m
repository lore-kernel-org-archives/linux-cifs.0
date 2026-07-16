Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352913D9678
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 23:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784244148; cv=pass; b=Gf6yuilWIHSRWwhGfrpKNUZO5WcGt7ktiFNnMDiOO5JUqb5v384Yl95hAmjE9lzj1KrpG9/GCbZ83IMN0967k3m4WRD/4ePdLUm6rXYD8IOdEX0QTcxEg3ByQqkTXaOm+hhEcVTslkIb6Chgvho8fG0OVoXvJHL5msxycV4ZmT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784244148; c=relaxed/simple;
	bh=EWN6gDuKG0YyEw+orb/T7ojVyEAGLDOUVQpq19IONdM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=AYChM4gj5fKUIvFyiv8TBt56/mXFRT8/Zw3v3Ku36IxZCCaRmyvNzUdYxNn6923ewC/u0GI+/rHWdTOE7pxR+Hpum9nOUmyrOMbl7EIKVmrIvUrlrqb/iuadr0t8TxFi4pLYoeOsJHPeGnkf82pGiJ3yGHqoPK5htG+nnqy0cr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RosCnX+R; arc=pass smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RosCnX+R"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5b0f19bea2fso3455528e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 16:22:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784244145; cv=none;
        d=google.com; s=arc-20260327;
        b=Cz7j5Td6RZwnqcL4BfjOMnafNSsn3D8d/zYkwUxJDLSbSlbgPbAHDzzDjDaRBlZizn
         eHnKLaw7Z5LCbR3+pwCmd1jhCFboAPfjDGo+olnKI9O87i/UVO622aQWKi3rc4ymtIfI
         QVqRDrR7zZZYW7X1nEZxKNl3kgp9/F0IBE9i9EfrnPuFkuAAUsb9eo0I2UrhqD4Zig9O
         zerLka6HS8K8bAefByfEQo+Gnb1SO/XLReZwM6q12akT4O/ZXOWa656xsjMYu9+qi7ZO
         UqGRCHr3uWBaYTvOR7N16V1ZZGeUElglZNGf0kFikBqHFi1WpmHeVluDgRSjZ/+mTenB
         OYug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=tcuWXuD1fDuDpMMOcnT567qxr0fli6HxjsqLv38lk+0=;
        fh=zUSNYzDANoKfNRCxl5RFYOGgmaHzF9yQ43+yCSxHu4k=;
        b=jxxgyBYqTnlgw4dhzdCKYJGzTRnk7EMqbngeIEk6WPhXN7nfxVe5f71KuxD+dJ7Ozp
         RPeT3CXSv8D+1bdbQ3wRFB2rwuOgbbRLKhOAhzeBdRw25t9P35aHg5B59lHhgCHK+t/5
         /rXmQDA5PFTbYormAGdtvqkCVjrN8sFWbZ7peGCRFfuMb5Nc4ba71XAKb7zRmMFPpmmH
         5LAShxBY2vrCV0QCz4DWrieLWvnMwbb4FIIbLxLKw/Zy2HJ6o79IPiRulgXZYPC+v8cj
         ocUEEpVgasU+YQGQNo0XTnNdJBCP+dRbTIMxprGbTrOgN2KDFrPgEenXmfik/K/lAqrc
         kaCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784244145; x=1784848945; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tcuWXuD1fDuDpMMOcnT567qxr0fli6HxjsqLv38lk+0=;
        b=RosCnX+RqAYTV+PlFHt42NMhQ9vGjcukrfgYj/E2gkVcVqDdotCnrltMfN1DBM+QAS
         phf8SHWbRVE5zAgqh9ofPBqieY2wp1uR/gm/06GZL72eaVZmbsLJOwI6pqsrA20F2xzq
         YLVTrXUq+adrIzwKFKwFE+QnjRGgAvnpFHCDM1HAdmcHeWkXuHksJgYJHM3lIXB5dN1g
         ADL4Equ+dd07QpXytbB+JcyoWufIeFJE+sclvp3akZkh3/EyGA8Wnsz8/Wj6jTp4yupI
         zALZqaj0HP6sxJ4bBkodjWjk05GJ37o9zgK179tBURtPF0Q/Raeg/qL5m5Z4M0g2hXAa
         olOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784244145; x=1784848945;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tcuWXuD1fDuDpMMOcnT567qxr0fli6HxjsqLv38lk+0=;
        b=ixtTUJ0AumFPjS9zE4jkwGR46J1UZkdLoPm73ajsDvt/hVS0X2idrQ6peZ3wG9jrTu
         KS3c8m0n1G52ait6XFHbGinJeGXotR45uGWpAUJtTdVi2tRZRlAqmMrVTHYN9KvdBIz+
         xVOOVXcP6A0vAf95GFeLk51Ik4Y3jwuUK4T33Mo0mFuASMK9vO9erd+5da7DspYwCxkO
         ZLl2/IjK/F5NMB/3WRPXUu3m0O9rbceBSNYmggDI3Kwc50hF0qbNnb7LEr2BBsy2bFs5
         oKsrS2FGxsN9juS7t2zwnLaeyuLooeEYmahLDbmlYGhH8m+t0dXQWjs3i+wQ1XoOshbW
         QOIA==
X-Forwarded-Encrypted: i=1; AHgh+Rr5CmZzyUiAj60qGpax/qahjejbDjxUMBOl23RezIRmItGXjXTcSyI6hf+DpaFRLbgKG6CS8dwfhWix@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ9fnsIUPVBwhYX2Rb0nANR9RebzGT+i3lRongA9Iekie8fZkf
	N+hYrUxXk09vaT4n29wwZnCxRowNFjlhvQ6SO8dRE4h/eSocuaTmtCfabVJ9LA3VYYgzBbav6/0
	AihGmy5aLLboU/x3DICUuBCf5RpDgENHPqvAdHcQ=
X-Gm-Gg: AfdE7clXGpj8Z1GwgoHXXyOkcvtiTiV7JQSt+pGvQ8N/T7yeUm4YYrcvfAY+Xx4uZ+h
	EPRDiSYoj3o6copKPzjMpUJsWwZ7o3hid7aL0c7ryGlxxoj75zHLaEs8okFfUGEJNsdGpROGXNf
	KG7GK3h+KUAaVzWA8EA4rpUFlkCE7NMB9PXk8UnO8xa03ZoB/I6ZsaB4DWDq2yF09n8tNVLOkuA
	E9kFVyxC7pCtzRZCSfFlryFLm8koB/wnpp0/L6RKk/Dn4Q3Z65bo/Xunskmkt2CfCpnPTT+5rMj
	Bh8BDkylvnyYuYCr3d/AMbqo0LlP62llyxMwDWqQNGHnLeQTqveJ4QYsqlfu8o+woPdB7TWEFBH
	/Wp5JrbZkehiovLZfmaWCubzliOuPk0k22guEv4XH8sqI2iPwnQaedG02UX76J0Vt2p92yOZrIs
	p5
X-Received: by 2002:a05:6512:607:10b0:5ae:ba28:a56e with SMTP id
 2adb3069b0e04-5b28f9aa422mr20563e87.35.1784244144879; Thu, 16 Jul 2026
 16:22:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 16 Jul 2026 18:22:11 -0500
X-Gm-Features: AUfX_mzuwqfyAYqb1BF1f2YADFZfGUvrdCDB7nKeR9VPHkdOl9tcogUusqYYnV4
Message-ID: <CAH2r5mvYSLOu72Nv68a1uSNSPY-0j-jYtTDMe7JufX4FL3vCRA@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
a13c140cc289c0b7b3770bce5b3ad42ab35074aa:

  Linux 7.2-rc3 (2026-07-12 14:16:39 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc3-smb3-client-fixes

for you to fetch changes up to d7d2adcd022baade5cab65ca492ce63421ce3a6e:

  smb/client: flush dirty data before punching a hole (2026-07-14
21:51:52 -0500)

----------------------------------------------------------------
Ten client fixes
- six fallocate fixes
- two unit test fixes
- fix allocation size after duplicate extents
- fix check for overlapping data areas
----------------------------------------------------------------
Andy Shevchenko (2):
      smb/client: Use EXPORT_SYMBOL_IF_KUNIT() to export symbols
      smb/client: Use EXPORT_SYMBOL_IF_KUNIT() to export symbols in SMB2

Fredric Cover (1):
      smb: client: use kvzalloc() for megabyte buffer in simple fallocate

Huiwen He (6):
      smb/client: refresh allocation size after duplicate extents
      smb/client: handle overlapping allocated ranges in fallocate
      smb/client: reduce fallocate zero buffer allocation
      smb/client: emulate small EOF-extending mode 0 fallocate ranges
      smb/client: refresh allocation after EOF-extending fallocate
      smb/client: flush dirty data before punching a hole

Shoichiro Miyamoto (1):
      smb: client: reject overlapping data areas in SMB2 responses

 fs/smb/client/cifsfs.c            |  10 ++-
 fs/smb/client/smb1maperror.c      |  24 ++---
 fs/smb/client/smb1maperror_test.c |   1 +
 fs/smb/client/smb2maperror.c      |  12 +--
 fs/smb/client/smb2maperror_test.c |   1 +
 fs/smb/client/smb2misc.c          |  34 +++++--
 fs/smb/client/smb2ops.c           | 183 +++++++++++++++++++++++++++++++++-----
 fs/smb/client/smb2pdu.c           |  19 ++++
 fs/smb/client/smb2proto.h         |   3 +
 fs/smb/common/fscc.h              |   5 ++
 fs/smb/server/smb2pdu.h           |   4 -
 11 files changed, 240 insertions(+), 56 deletions(-)

-- 
Thanks,

Steve
