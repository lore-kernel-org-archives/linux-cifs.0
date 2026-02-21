Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D08329E52
	for <linux-cifs@vger.kernel.org>; Sat, 21 Feb 2026 16:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771692067; cv=none; b=ntMC8RNeS+WXP0FGqfrCc8Fd8rxcOjtHgZDf3KaJjtqqss/yF82eT9OPdHOPzddA1JXMyNGgSvpld+0+1zDygucKgClqalZkt3VLqwUQ6qCPpZuXBXMdUOL6pEYoalOOwIxImExWyA+TnB+RI7yBtbl9pGyZ+iELMrSbDF4/Wus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771692067; c=relaxed/simple;
	bh=Q8LjG5w0LfBzA+qqIJUKX9oy/FN75Vn0W7VHoH69Qv4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qTln/zbiaKIE/sbuQglSIKWJybsLvjvlgiXbU1wLHHxVXFnIhIHnr2pM6blAnYzcp8LNBCKzA1mQZvNqldCfSRU4LrFRp8cyp19lL4/KgYedQLJ38vaH43ktNkSInH/HVKnHbKvJWPd3cp6+7ub5G9KIyEaPKiyGzxrKaWWgF9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e7N1c/zO; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e7N1c/zO"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-5fd05e8d317so1939126137.1
        for <linux-cifs@vger.kernel.org>; Sat, 21 Feb 2026 08:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771692065; x=1772296865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dchZpIBGjK9hFXqFYovVVV/bmoJVWZnsrs7zJJ1McUQ=;
        b=e7N1c/zOH82mkRI8UtTY+OapIXMoTudqptRYtxYHw9kjMqyVDQ4OqCT7QD0xhYEk9/
         FIubjQXkkXLzcyXTp1tywGJooHOZ2nZ4n/akH45Tncx/yzny3k2mQ2DdRPPJZb3Pmz9J
         T5e/VfOBfdwZo7wvtVwPSlE43R410GyoPlEe9f4kMvgKkeMTuRh+cjV0DCWNHX3L4dvR
         rGLdF970sI6OUDbr3FhHs5I5Bx57EhmzT3Fza21/22ffAJRLnQY6HTXEPupnUbJG4CbZ
         iLf1zT89kCzAinibjLxhhkC6c1HoRVXU7yfQfHwmIsEDB4HA2Y5TDJ3mEVlP44oAFbzv
         xMMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771692065; x=1772296865;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dchZpIBGjK9hFXqFYovVVV/bmoJVWZnsrs7zJJ1McUQ=;
        b=aZrBZrIixkbYDsPNl54hGGtZeRaM79QqH6eKT8MvFRbk6/46jDT71bjT5Gqil8eAjQ
         S5ae1/FPY7nc2vcTyQJmDCBHQuAKGp3kJhE5YjkupGP/3LLXcY3Fuob+cUgraw6YoNnx
         Fu+uk5yjfqVFnOdKWfsrUAWuIUv5fn1rbFH+qHFitgXVr7xpCbd5wSundyvB5rgjg9mX
         MMy0s8JYkBqhg2816ry2eBupheR+BXRLvH27tkA+iLCadibh7SY+/ngBOJsLXNNeQIhe
         bKvXOyd3jxKsxIi1/uPTJ4VNsYB4deb+o2pgwNjVc3vlMZOFHUfI6lCEQVYOzNFimIDk
         QExw==
X-Forwarded-Encrypted: i=1; AJvYcCXk6J9WPhHXN9kmGebydq4VMvIudkSj3mMYokUZy0lSnAk/vy553GkMacIrmBPe1V6TD+JBfEeue6aL@vger.kernel.org
X-Gm-Message-State: AOJu0YyNm7tZRmQeDuZZ4uWqTRyQT3ntBjpPOVSpT9ABwawri42215RC
	YhJqN5pBlHEr2U7Q/1PPc1t/K4iuJVRZcaLjPZLTasMHkiQqiWOVYhE3vZ4D7A==
X-Gm-Gg: AZuq6aJhyaUKuH5zn3HbckZhBPoNUu2UnOdkrjtZ+MJ8BaSsZVdzT0o7Q+CSJOGXPsn
	tpoBfpr+7cBH//dWUOkrFEbQh4zf8F3r1EjxfnaWSZg22enJaWzBgpghDsVOcR++UiJj/7/McQl
	+J2BZKxoZEoJ3I9fJIygOsoJ6aOW/IVvAQl8zs5Qb0jdN1MPvNgzCOkpRw8LYLxvOMrUTY9S4dx
	EZ7wEhRJ8cUSyhPnb5ea2ETU0HZQuTBj83EFIKd5geOT2A2goOTzRkYkp8zTjYQXPRdy3LMAQDp
	vmg2rY4XcF2WNevrnjfh5aLK829w8hdE6BIG/3/ecgGYnPkOyiFo4/lLRVEeF7k/dzQMgQ2A70/
	Ft80EkHqOpdCfrLIsW8yNMlPYjHbOoPoyZ38Nw7QgkAoWqwIcUeV447WWImBsnSqlqQSWuLBQVv
	emvtxglGNaEAhvij1vnpmJWzTXjh0Lqar4a0SkkfGi6H6m9FzPE79qRQ4=
X-Received: by 2002:a17:903:1d2:b0:295:24ab:fb06 with SMTP id d9443c01a7336-2ad74458fa3mr31285505ad.22.1771685983010;
        Sat, 21 Feb 2026 06:59:43 -0800 (PST)
Received: from toolbx ([103.230.182.3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7503f4a4sm23730205ad.79.2026.02.21.06.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Feb 2026 06:59:42 -0800 (PST)
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
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
Subject: [PATCH v4 0/4] OPENAT2_REGULAR flag support in openat2
Date: Sat, 21 Feb 2026 20:45:42 +0600
Message-ID: <20260221145915.81749-1-dorjoychy111@gmail.com>
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

I only tested this new flag on my local system (fedora btrfs).

Note that I had submitted a v4 previously (that had -EINVAL for the atomic_open
code paths) but did not do a get_maintainers.pl. It didn't get any review and
please ignore that one anyway. In this version, I have tried to properly update
the filesystems that provide atomic_open (fs/ceph, fs/nfs, fs/smb, fs/gfs2,
fs/fuse, fs/vboxsf, fs/9p) for the new OPENAT2_REGULAR flag. Some of them
(fs/fuse, fs/vboxsf, fs/9p) didn't need any changing. As far as I see, most of
the filesystems do finish_no_open for ~O_CREAT and have file->f_mode |= FMODE_CREATED
for the O_CREAT code path which I assume means they always create new file which
is a regular file. OPENAT2_REGULAR | O_DIRECTORY returns -EINVAL (instead of working
if path is either a directory or regular file) as it was easier to reason about when
making changes in all the filesystems.

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
 fs/gfs2/inode.c                               |  2 +
 fs/namei.c                                    |  4 ++
 fs/nfs/dir.c                                  |  4 +-
 fs/open.c                                     |  4 +-
 fs/smb/client/dir.c                           | 11 +++++-
 include/linux/fcntl.h                         |  2 +
 include/uapi/asm-generic/errno.h              |  2 +
 include/uapi/asm-generic/fcntl.h              |  4 ++
 tools/arch/alpha/include/uapi/asm/errno.h     |  2 +
 tools/arch/mips/include/uapi/asm/errno.h      |  2 +
 tools/arch/parisc/include/uapi/asm/errno.h    |  2 +
 tools/arch/sparc/include/uapi/asm/errno.h     |  2 +
 tools/include/uapi/asm-generic/errno.h        |  2 +
 .../testing/selftests/openat2/openat2_test.c  | 37 ++++++++++++++++++-
 23 files changed, 119 insertions(+), 32 deletions(-)

-- 
2.53.0

