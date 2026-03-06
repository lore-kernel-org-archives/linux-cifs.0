Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3103ED5AC
	for <linux-cifs@vger.kernel.org>; Fri,  6 Mar 2026 22:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772834642; cv=pass; b=dN6HHvaMd1pcF3Q5GWS5LYVdXH3G4ACJmokROttKgd0pS+joyuv6vHeB7s99CXPFpYbMZgQi7fED5vf+nY3wz5IgKWhhRiZ3q+RjgsbwCWRkKZxwlRyNMe7zudC5jIwQgdnFuTEvE1n65h6bUmwi/1Cd0DyWK4RmJhYsLfzEY4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772834642; c=relaxed/simple;
	bh=cWW4PJgSBkjl8c6eE9Jenhh9SBcDu9UEl7wyyUD3XGA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=sWp/8hkMNyUj24CuA5BRxMjy3tKuNqTc3RlzQgvJ2paGBehDsHQBgjMChuFQ14Vm1Rl5g1HQ1Iz3LtWLY/ej+ve/STH04WsKcx0BynGjo/nem3FOLnez78Zkx9dorlZlUnNRONKm+EtyerVFN9PPV+BnsH9I93im1lCNmxbN4vs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZHPYGvX2; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZHPYGvX2"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-89a0d53f3d1so49506546d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 06 Mar 2026 14:03:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772834639; cv=none;
        d=google.com; s=arc-20240605;
        b=b8O1a2VkVFowLzzygklHJPq6CEKvXc4VcEiAid8FszI0iLhfYQAG3ljj8YzkgN82/U
         1oSE76BHbyBkT7HwR51u9Y1xn9o089Pydj1s61zkgsA7T6PEqizSzAvDnkWhe/ve7/9R
         SrSKUt718CZSrfIbHqI5d64Q5gG2RjbhRgewZUfzBw9cZ76R2+txgCSFDN7uHZoTZz+q
         Z0I+R+BXxesNPYe5iOeuPfc94hMtCo5XdsXrGiiNBrW9bwgio5O1GSU4YXPx0I5d/za2
         yfVKHb74b3+cOzF4LRyqA46VbpHt68urteigH3qYF268v/crPI6sJUEUEzTNTmDQcId3
         R9lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=aTchkLR/7Ez16Ej3ZaRCH8w+uoCbJY/5YvCfKaykM+c=;
        fh=uiyiW1y8cXN/IqbiZK/vfdhM/ZeLw1nspk1VrAT2X2I=;
        b=QDRE8cPXyR56/7vjMdwAZmkap0UmojsyhaaQx8RvlDl0x3IgLuIkn+DGTiAK17HMez
         WL+7Ru3f6mPt2wQKhW++Dkqg8JLTYeGLHBlFrqnoi095hU1+SfQ3O+vdvLdSZKrOfZP8
         lRgBYbfEv4PJAIe3O7blOgGDkDRLlYGK5xL68kvUm3no1RMSSRFwtCvdcD84+oYk4xPk
         qYo7eqZmEp0CqjmhQ55c0JRb8D3kniclMP9EjyA4hE+5t7eFY52sOAvhZeWcFTD/4SsO
         0sWlWzcfYOjtr5eWKpO81ceHn72aBO1DbuoXPmN7CjWfpqCLdIUnsX27U1izkSiRGtv3
         EfHQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772834639; x=1773439439; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aTchkLR/7Ez16Ej3ZaRCH8w+uoCbJY/5YvCfKaykM+c=;
        b=ZHPYGvX2Dq2N9ocDRtzc07njEoz5LW/5FSWLqqXDzD9Qy0Do3/fOvD0k72MSIloakU
         8egtw5KyCKDUgtg0cxUJ8UbxMfHGZEBLcqS9ec0NoV3yOQ8J1/lTSUr5CpLGWrVQqv4n
         Ydc4D/WjNewGNOdaQLq0zzPoK+W1qIzQTq/uPJyf0dG6D9br2yezRpE88QbAJdVtF5/+
         HXtvJp4YIpxNjCfvyZSFGYDSbzK3aqLQzFENXHCY7ghCD45jAb3IiIP7fFYV0qJ7L4Vn
         kvfzwMo7jJzk6cfV3tQOnHcotR3gcaM9b7N7DWxVHYMHoTamLJFZ4J1Jl4hPKnyfD71Y
         I6vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772834639; x=1773439439;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aTchkLR/7Ez16Ej3ZaRCH8w+uoCbJY/5YvCfKaykM+c=;
        b=fz4EhcViCp/BnDLDm6R37eAU4X3pxporDUjoGPqoBCX/ni9Np2MSn5adJZM/JtGfht
         du3GP46y6WqEU4rjGtZujBFplIake1OS0my7yIz0J3QKD2r+tRNGVOhiHdgR0k+wnL8y
         ZBRU8DabnqRSGNIHAqPIKqTrp9137S45EKXmqlVXg/1Puw0qTt0+daj53bT2HWJWCEVg
         WxqMNfqMjX3Kr76LU6CeblEN3ZQ8nB8s4MjaXNaR7gZQBUWl5dwZy78KNjx2IOZcPnbK
         3lycmDwZCn/MbSYMaFXkmZQcXZyoEmhgs0y6HkdDFxW1kFw3osNb1mcMoJ0i3akSmP42
         79/g==
X-Forwarded-Encrypted: i=1; AJvYcCWSJYInVmlN67P87IUkvj9JwEspFqgJQWcLUNL4SBoMHUMWyWpT0diWOypc3WsKx++OQx4KlDg1YI+W@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5i8KBhQPyRY9kkNAupk7IUrgkOaq0p2v/AAOlciIr5SpPwTDy
	JziVwXGX1kkeFeY3CgcB6OKTGg+3QJtqJu8S2rUisfYwI8RioTqYJMN9glIbB25ddquEyYiuW2x
	QQtnwjAT3REPfe5GwHIwOxY8fn5hy/g6tUQOb
X-Gm-Gg: ATEYQzxsdqCe/MAF37fZmk2JQk/R2nwd0xP8xdvkMc83XtvQ6TnLagel2jzsrMaAjVL
	r/X41nkcG3lEsJAG5/bwuJ9s8BtuF7QVbM+75QAwTxYemhQb5L0lhINU+l5CatV8Wagn7v3EwyP
	r09XRpwdoaNX6+nswc3HzjPb9QfrxDLunXTrwAntx0aqlOgYWt+tbSHb+v0U0EATwY8CiGvIazp
	kMh8Y3HVTUR02XLJqUD2c+tUvseG5sjwudl002GuhrNLdmw5vSjY/vH9+m/KgZqZiv7KakVjMdk
	MGWZ2mfSC3JIYL8dGC2tx7NIKBn8dvNHNZAlp52/AhryMCwbyMWQoCODf+l9l0GuDjTUAUGMhug
	aVwn6DldKXv2LQ57AZ6DuLsQF3jPuOH2Isv4o04tqKDsuzfIa1AwsEycn3XLdBoEpNG7gIHCd0A
	B5nAR2zUonV4eXz8qlXKnWWA==
X-Received: by 2002:a05:6214:528d:b0:899:fd7c:d46a with SMTP id
 6a1803df08f44-89a30a5e418mr53248336d6.18.1772834638748; Fri, 06 Mar 2026
 14:03:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 6 Mar 2026 16:03:46 -0600
X-Gm-Features: AaiRm505G9jwArrYfMVkoWicLiaj3mVuxCkm6aRS6kG5iFp8FoWBBuB2UgI6q3Y
Message-ID: <CAH2r5mu0T+Gcea5YKaAA7L6FfM5OMjEKenih6Sgk2W4EXrSpWw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
11439c4635edd669ae435eec308f4ab8a0804808:

  Linux 7.0-rc2 (2026-03-01 15:39:31 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git v7.0-rc2-smb3-client-fixes

for you to fetch changes up to 048efe129a297256d3c2088cf8d79515ff5ec864:

  smb: client: fix oops due to uninitialised var in smb2_unlink()
(2026-03-05 20:41:16 -0600)

----------------------------------------------------------------
Eight client fixes:
- Fix potential oops on open failure
- Fix unmount to better free deferred closes
- Security fix
- Two buffer allocation size fixes
- Two minor cleanups
- make SMB2 kunit tests a distinct module

----------------------------------------------------------------
ChenXiaoSong (1):
      smb/client: make SMB2 maperror KUnit tests a separate module

Eric Biggers (1):
      smb: client: Compare MACs in constant time

Paulo Alcantara (1):
      smb: client: fix oops due to uninitialised var in smb2_unlink()

Shyam Prasad N (1):
      cifs: open files should not hold ref on superblock

ZhangGuoDong (4):
      smb: update some doc references
      smb/client: fix buffer size for smb311_posix_qinfo in smb2_compound_op()
      smb/client: fix buffer size for smb311_posix_qinfo in
SMB311_posix_query_info()
      smb/client: remove unused SMB311_posix_query_info()

 fs/smb/client/Makefile            |  2 ++
 fs/smb/client/cifsfs.c            |  7 +++++--
 fs/smb/client/cifsproto.h         |  1 +
 fs/smb/client/file.c              | 11 ----------
 fs/smb/client/misc.c              | 42 +++++++++++++++++++++++++++++++++++++
 fs/smb/client/smb1encrypt.c       |  3 ++-
 fs/smb/client/smb2glob.h          | 12 +++++++++++
 fs/smb/client/smb2inode.c         |  8 ++++---
 fs/smb/client/smb2maperror.c      | 28 +++++++++++++------------
 fs/smb/client/smb2maperror_test.c | 12 ++++++++---
 fs/smb/client/smb2pdu.c           | 18 ----------------
 fs/smb/client/smb2pdu.h           |  7 +++++--
 fs/smb/client/smb2proto.h         |  3 ---
 fs/smb/client/smb2transport.c     |  4 +++-
 fs/smb/client/trace.h             |  2 ++
 fs/smb/server/smb2pdu.h           |  5 ++++-
 16 files changed, 107 insertions(+), 58 deletions(-)

-- 
Thanks,

Steve
