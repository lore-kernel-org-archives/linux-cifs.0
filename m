Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2143A599A
	for <linux-cifs@vger.kernel.org>; Sat, 23 May 2026 14:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779546154; cv=pass; b=O4yJ1gV78kjUOP0sralNmh3iojEtTe55GtWDkgetE7AQcKju+UYEMxabcvdZJPFL8Q0FqHaBU4lxv8JpVElSbrpKB99Cs0HSIss0m6KXywQonNs4bNHjuckaCZiH9iUIPQLby20+Ic3LariP+isCYyE5X7RmLL3Yq5+gzkVI6Zk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779546154; c=relaxed/simple;
	bh=QOq5bMTggiNr99Gq2aTqL2RF9tdp0JdXTbvp2nJVayk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=TnkiyFK5eLaO5ayLl/Luc9D8nuqOUMYeY+qLnYEgsMXuzEPFE3EYLd3vG43mRKdWuI+llq2GXgQ6AtR2r2KuDSfO9QmiMonaFJR0MH+jcS+FWC55nUoNT7pEGaq+wX6GuNhZJ/fM3I/QYql1y1TnPaKkNrDnEKZnkFKls1DKE6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pjZIf1Ou; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pjZIf1Ou"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8b4eb1fd5d0so102099896d6.0
        for <linux-cifs@vger.kernel.org>; Sat, 23 May 2026 07:22:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779546152; cv=none;
        d=google.com; s=arc-20240605;
        b=gL0blyN2NC7xWHfbzqPcGZ15W234k7XgZo2wcu/TXGXw/AvaBJYaMQjskN0lwgbXRo
         mkBv+tvkGjeIbUvnl7rFfnIU7tZDHcAWLUbt46eEMBxKNOv0F9UXLu0WEVqcTT+3c4il
         qzYLdp8DmdZ2x+an7Ii80qrjkeLFsO+RN2ePhxtCZoSu97ikBGwo6Tck91IM2i9WOvVz
         xJpdyL5qUzr+nut1+bjy6y8nm9w26suFbbn7KLASYGcSbzAPFMZf+InzL1Y9l32Fr51e
         SU5ZkHLpCKvyfdS4iGES1XWw1aYi/5HmX9A99lFpg6JQQg0zNYJQDpP6qXFnxKbqBy3/
         NVuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=fvokk1U5NisQLg359Y/XFPkPqxa2c23Xwq58Zq0IY20=;
        fh=7ZzNP9kU7nNunR+v9k7J1wfXsjrldIhNmB+WMtQIYhk=;
        b=E2QpntNBhM4fcIcEPVTDJAeR4rcaW6QDyeT7le5UIl1my7Mi/PXZrMCK5lc9zHr/U+
         iCtwTgNqpzelraXtbq30Pggxd85Q3L901HxJN4z17tc9Ts4syb9LpqSofnN2vW49G8ru
         0+oH5eL2ytB8djWogHeCFmfrtadFCMutS1KIsaazv4cCORVf0AswFnc/GEbIX3A5t8hu
         oigZsN6pr9DbWTev8odDd7KXfhU/3BODuRiEYpeo0WSTj4EaAUJaHE9tdH6F0v1rZGpJ
         9AAiqtj41fpnvJ0DSCm2cO5fCaIyA071EzmnP74pdoaptlkDaG8HbbJr4fs9jVi1afSR
         sEiw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779546152; x=1780150952; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fvokk1U5NisQLg359Y/XFPkPqxa2c23Xwq58Zq0IY20=;
        b=pjZIf1Ou4v1JTFg0ABlQD8AckuCungbe/b1tkTFfiZTvhw6X0H0uNfZ7/FA0xNSlou
         lEPImggg4cYwA5YpiokkC9RgnjFWFa7Y3V/eLOfsparMblNsbQ/Fg42Z54p3H05r7fMu
         9jxbEA5G96yPwGl2T7Mu9tdDvYun+pImyRDp3QTOuyYpH7oAXSu5G7Xcj9waxUE4HGfp
         o4VtQqAjlb6AA45r7HdzIvVTRS5IqDZiCY9MNirbiJOPdFdp21dMcgTZpeCoyDyifx89
         0FAGyZ0tJA+oLFgP2cqtbwbBShv8pNFB8r0bf7CO2WkhFcsub7gCMU1xrl+5iwBKjQ0i
         8W3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779546152; x=1780150952;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fvokk1U5NisQLg359Y/XFPkPqxa2c23Xwq58Zq0IY20=;
        b=XnRI+t8EDm7nclWgpyD4z0zkE0LDMVgDJF+4LtR1yEELAz611QWK/MKBOg1hVtf7GJ
         xn3wbGegxcUqNV2Zsbk5T2kdAuOgZHCkcX9/PmJVyrqk4KJqBr0CTFoAhdlN2ysx3kU4
         CemNBUs5Ea/Ow4PlnTZk7E3cFeC5xJJIpvXtDAoT4nUGI2cOcyh8EbLIFg7eNM+gXclP
         HLiiSOq6Bz7kraSidAAId8gNFctzDCJBFRy9cQd1UPn5/DHpW7qUAH4Bb1ehvx2bwWoD
         rI44JaX6Qgjo3/k+H2iG/w12b7nZZnSkbWrhAbcjX3ke89cBCn/UFpCRHOy0Dis44o2H
         URXw==
X-Forwarded-Encrypted: i=1; AFNElJ8oJ730Zlne2ZNghJjLIZI/4KoZ1vmjcN05nasARgCeA2rWiuZJBAd4qWN+KuW16OzUxibCdiVm7tWX@vger.kernel.org
X-Gm-Message-State: AOJu0YzuNiheFBt3XmlLmPDHexBqolw75CLW72eO8e5PCpLEzRJRsfN4
	VgysOuWJeSFHXqoYC9GU3/RnEqU0iQN/L+KYQsX2OB1125zHOto1irWNFwUX+egITv04d6cX/g1
	XpkXHi/M7osmsb9pYGjq7mbohbK1wVE0Lm1fq8GI=
X-Gm-Gg: Acq92OGxwx4Sy4MQm3+8HW9RWREHBAl0fyBffNmrPxZ5udPTqTd/zfkmhmp33PnCuV5
	z49fJe8BmSQhLiKW0vCJuc382/+GRh1CFypb41L83qHr1bG5Bca1J++yuKgynzEFggC1ek8hbze
	7CMFWLhcVvWWtQiiWEn1RqMNGa1wf3uoRYdkG2I5agv5fU8L8QpPxdUuTm5Oju+Cg4rtcx8Z5IA
	P/u4FZsKyZ75LsabDxuTzwCJywq/2ZzeW+MKPYo6YEWiqp1izwDgRrxcwByL6SWMkfGIHIO0aqa
	y8iW4cTI37OKTmOF2zgC+N52SXzzDr7b+V8X6PjCp7YrSS/tN75zkd23fC6FOXPTQfL6U936XoE
	o1CEFTe8oojVG0v2RrXsOLXZDxxEydxECMbPLVauh4qusv4sZCdZYvODOUa4QD6X5y3tbTGvLB8
	HmFMYD9iHi1kHP7IZQk4QV+catxclAM5xy
X-Received: by 2002:a05:6214:2b83:b0:8b0:2c81:ad5f with SMTP id
 6a1803df08f44-8cc7b541aa3mr136892836d6.11.1779546152406; Sat, 23 May 2026
 07:22:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 23 May 2026 09:22:21 -0500
X-Gm-Features: AVHnY4Kfyfqa984Iro5x5lJG1lkvn-6WVgbmntqyNEgW4_RGs8CXd5XWiZn-afc
Message-ID: <CAH2r5mv+AhWk4nM8tWcMDwQHL40VneHN1XVwuQrX08OLRB8R9w@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
1a2ab0feaa23147e347b4d4cb79cb3fc392118eb:

  Merge tag 'v7.1-rc4-ksmbd-server-fixes' of git://git.samba.org/ksmbd
(2026-05-19 09:49:32 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.1-rc5-ksmbd-server-fixes

for you to fetch changes up to 4ec9c8e023c79f613fe4d5ad8cc737112efb2e44:

  smb/server: promote S_DEL_ON_CLS to S_DEL_PENDING when close
(2026-05-21 18:20:24 -0500)

----------------------------------------------------------------
Three ksmbd server fixes
- fix for creating tmpfiles
- fix durable reconnect error path
- validate SID in security descriptor when inheriting DACL


----------------------------------------------------------------
ChenXiaoSong (1):
      smb/server: promote S_DEL_ON_CLS to S_DEL_PENDING when close

Junyi Liu (2):
      ksmbd: fix durable reconnect error path file lifetime
      ksmbd: validate SID in parent security descriptor during ACL inheritance

 fs/smb/server/smb2pdu.c   | 15 +++++++++--
 fs/smb/server/smbacl.c    | 66 +++++++++++++++++++++++++++++++++++------------
 fs/smb/server/vfs_cache.c | 16 +++++++++---
 3 files changed, 75 insertions(+), 22 deletions(-)

-- 
Thanks,

Steve
