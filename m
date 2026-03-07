Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898942877CB
	for <linux-cifs@vger.kernel.org>; Sat,  7 Mar 2026 14:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772892476; cv=none; b=k3x42jHeWXuXXiOuj+MY+gfht9Gnz87s43VG7xfxVqDAAT38X26r7pkMgllA/MTzM0XGZnfJT5dfZg0ccgXvx+LQqwjadDokLtAcl24TQteGO1hxrTunrf92BHxgS7XX0TPMf9ELtKYj3ZaeMxUMROxSXZuH01PquttqXuthPa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772892476; c=relaxed/simple;
	bh=q0HizNdLQtkBg+6I2Uwr71BFH46+Qf7XsNZYRKQhaSU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BHsu/Nq+8fXxdq48rIyavZvOplOIjLQMq5vgsdSOK2L0hIFvurH/eRra/NGvu7Fq6uMP3mphlmh4hV+ZPf/T8v7BdSP8xLkISnrzJog8bWtQHm7GdwGGV6a2C+EELxfKdOXPBTwHj+CaHFtQx85zGpBCpaEIfIlA20X2Q8BbNnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E0w/g9Nx; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E0w/g9Nx"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-829b8b6c4d0so486953b3a.0
        for <linux-cifs@vger.kernel.org>; Sat, 07 Mar 2026 06:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772892474; x=1773497274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jdS9yl/p7UlIdGAR7tR/qX6v6/HUi/AMSzKRwMf8jaY=;
        b=E0w/g9NxXfrlsysae4YQT/Z4nbnodAnvGWqE08bbrpnk1Aq8YcRn0aFEoF/5vlTbWW
         WujCp1WTHP84Vu9NzWTO5cm19RDvgowO5A8HjFVs/hLEZsuKZhdoCmxRM1kaWWg6hT9c
         bEfqNF3eBHHzthgEHDGPLfvBskdeKoecQKp8je7JmxvNFEnShD+loq8YA1b8Lr504KP2
         xELbXsCVqhhCpORruuwseOoRWd68tcGotqQRIRoTxeaZu2zirMid0nJj4pJhOVtCD8Rd
         sHPN9q7TYpWWhwqC5Xs3rOMAh574q3FGNCxBTWnBEAs5nFnCCOLTUcyPs5aTqQGSpRPX
         08gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772892474; x=1773497274;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jdS9yl/p7UlIdGAR7tR/qX6v6/HUi/AMSzKRwMf8jaY=;
        b=ZeDxU+o3BQEOl1nsktHZJsoQSEFPY900vRvRQFzVN6MOhd7sJwCIUgHbX7/9eg19ZT
         9Ds5TSHB/eu3E4PSIRUugnoE++Wj3TrrTlkNShirTv/2mnUqf4kEIY8xraS8u+Q3dvdX
         m5eGFyYwY3eiTGHgl16MF9/FMAsM2I6cUKEmhBlx7Cnjk1AgAzPuLL2qGtQgfLR1L8uQ
         uxiZkwDB590VAS4AHAfUSamKCwExeMuThrW9Y91lq5/40nm9DHzEod9PW8+UDlGEmyMR
         4yYgDVCMY8hZW3DygqF8lO2zmTOMJRztN1pXWhlSZiYUzeB3j07bkiv2BHbkf3XZZfdo
         4JHw==
X-Forwarded-Encrypted: i=1; AJvYcCXDO7qW32ZNcv/PVn2Ct5d83+wP/CH/kVviYivGGZudBc44oRWxFS4r6/YKo2NC+9atnmK7nhKTca1O@vger.kernel.org
X-Gm-Message-State: AOJu0YxSP3RRslmgMhI/8j3VJ8A6c9AvnOFD/hRMZfnGKOnY+7fAkMuA
	ZTaWGfMDvmNRc5FrG3X+GKJYd6uoUSwBJ//0uSD3YEUVSKq4FNOfGgRu
X-Gm-Gg: ATEYQzwBNIqCMHKfAqbwdpDr6zF20has75HLvqApuvNmH56Sv9R4q+R0/vw2vRKAZ3p
	XMdSpXkpiJ9TGmTtqgJw4LpJoNv01SGrx9k7M+vyoh9OTcnb2KyJFaDPz8JD7YIO698f32jhcAX
	fqIN9VuirsfUFJNKb8d8VlW6TWHVLVSLglSetSf3zEC3enNabTVkoQAsLA2Wcz0I//XhVo2jbmf
	AuVjd7Ba/CttkOmXdVqV2lKKSuZvb/yd48DkpQHPr3z0eH5JlIpTDo6ImzDc0WilrPFkAuYpf3L
	yms5mBIUQABWAD2AbuLrI2l12GTlkrlz+n3JE8Ssub4SFv9yg1m0oRjIhbDF7+dH2bavAHIZbI5
	OYVfuU2ViVHICGQ2+l4mDio+KuepTHJ7X8ygw4OGBXr+Qt5nFpHjnVeWWzkYbxuFIGxQZeZUoRy
	trnHhqXoGBiDuba4eXiGSOWsdJzARSykdtDVMjLuad44+Sv4U6vbLzk+pzTZNo6pBS3A==
X-Received: by 2002:a05:6a00:1581:b0:827:26b0:58d6 with SMTP id d2e1a72fcca58-829a30bf515mr4247393b3a.47.1772892473854;
        Sat, 07 Mar 2026 06:07:53 -0800 (PST)
Received: from toolbx ([103.103.35.10])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a48ddd18sm4747313b3a.56.2026.03.07.06.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2026 06:07:53 -0800 (PST)
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	jlayton@kernel.org,
	chuck.lever@oracle.com,
	alex.aring@gmail.com,
	arnd@arndb.de,
	adilger@dilger.ca,
	mjguzik@gmail.com,
	smfrench@gmail.com,
	richard.henderson@linaro.org,
	mattst88@gmail.com,
	linmag7@gmail.com,
	tsbogend@alpha.franken.de,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	davem@davemloft.net,
	andreas@gaisler.com,
	idryomov@gmail.com,
	amarkuze@redhat.com,
	slava@dubeyko.com,
	agruenba@redhat.com,
	trondmy@kernel.org,
	anna@kernel.org,
	sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	shuah@kernel.org,
	miklos@szeredi.hu,
	hansg@kernel.org
Subject: [PATCH v5 0/4] OPENAT2_REGULAR flag support for openat2
Date: Sat,  7 Mar 2026 20:06:42 +0600
Message-ID: <20260307140726.70219-1-dorjoychy111@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I came upon this "Ability to only open regular files" uapi feature suggestion
from https://uapi-group.org/kernel-features/#ability-to-only-open-regular-files
and thought it would be something I could do as a first patch and get to
know the kernel code a bit better.

The following filesystems have been tested by building and booting the kernel
x86 bzImage in a Fedora 43 VM in QEMU. I have tested with OPENAT2_REGULAR that
regular files can be successfully opened and non-regular files (directory, fifo etc)
return -EFTYPE.
- btrfs
- NFS (loopback)
- SMB (loopback)

Changes in v5:
- EFTYPE is already used in BSDs mentioned in commit message
- consistently return -EFTYPE in all filesystems

Changes in v4:
- changed O_REGULAR to OPENAT2_REGULAR
- OPENAT2_REGULAR does not affect O_PATH
- atomic_open codepaths updated to work properly for OPENAT2_REGULAR
- commit message includes the uapi-group URL
- v3 is at: https://lore.kernel.org/linux-fsdevel/20260127180109.66691-1-dorjoychy111@gmail.com/T/

Changes in v3:
- included motivation about O_REGULAR flag in commit message e.g., programs not wanting to be tricked into opening device nodes
- fixed commit message wrongly referencing ENOTREGULAR instead of ENOTREG
- fixed the O_REGULAR flag in arch/parisc/include/uapi/asm/fcntl.h from 060000000 to 0100000000
- added 2 commits converting arch/{mips,sparc}/include/uapi/asm/fcntl.h O_* macros from hex to octal
- v2 is at: https://lore.kernel.org/linux-fsdevel/20260126154156.55723-1-dorjoychy111@gmail.com/T/

Changes in v2:
- rename ENOTREGULAR to ENOTREG
- define ENOTREG in uapi/asm-generic/errno.h (instead of errno-base.h) and in arch/*/include/uapi/asm/errno.h files
- override O_REGULAR in arch/{alpha,sparc,parisc}/include/uapi/asm/fcntl.h due to clash with include/uapi/asm-generic/fcntl.h
- I have kept the kselftest but now that O_REGULAR and ENOTREG can have different value on different architectures I am not sure if it's right
- v1 is at: https://lore.kernel.org/linux-fsdevel/20260125141518.59493-1-dorjoychy111@gmail.com/T/

Thanks.

Regards,
Dorjoy

Dorjoy Chowdhury (4):
  openat2: new OPENAT2_REGULAR flag support
  kselftest/openat2: test for OPENAT2_REGULAR flag
  sparc/fcntl.h: convert O_* flag macros from hex to octal
  mips/fcntl.h: convert O_* flag macros from hex to octal

 arch/alpha/include/uapi/asm/errno.h           |  2 +
 arch/alpha/include/uapi/asm/fcntl.h           |  1 +
 arch/mips/include/uapi/asm/errno.h            |  2 +
 arch/mips/include/uapi/asm/fcntl.h            | 22 +++++------
 arch/parisc/include/uapi/asm/errno.h          |  2 +
 arch/parisc/include/uapi/asm/fcntl.h          |  1 +
 arch/sparc/include/uapi/asm/errno.h           |  2 +
 arch/sparc/include/uapi/asm/fcntl.h           | 35 +++++++++---------
 fs/ceph/file.c                                |  4 ++
 fs/gfs2/inode.c                               |  6 +++
 fs/namei.c                                    |  4 ++
 fs/nfs/dir.c                                  |  4 ++
 fs/open.c                                     |  4 +-
 fs/smb/client/dir.c                           | 14 ++++++-
 include/linux/fcntl.h                         |  2 +
 include/uapi/asm-generic/errno.h              |  2 +
 include/uapi/asm-generic/fcntl.h              |  4 ++
 tools/arch/alpha/include/uapi/asm/errno.h     |  2 +
 tools/arch/mips/include/uapi/asm/errno.h      |  2 +
 tools/arch/parisc/include/uapi/asm/errno.h    |  2 +
 tools/arch/sparc/include/uapi/asm/errno.h     |  2 +
 tools/include/uapi/asm-generic/errno.h        |  2 +
 .../testing/selftests/openat2/openat2_test.c  | 37 ++++++++++++++++++-
 23 files changed, 127 insertions(+), 31 deletions(-)

-- 
2.53.0

