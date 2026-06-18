Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDCB38D686
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 13:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781791110; cv=pass; b=fkk8g8IeSjkDjlqAXG2Po4j/7RDv/aQmfRAFBkNszwjhgJ93lnptQWOSbWTpyNPK9ks71mZg6OHHJI2Lm1BvtkidvsfeyePT+trT5MXYJZksZW06WDNkCto84my4UfFHzL/DVI4LZDRsrc4Q1IlbeaiLRcsLPnc8T8SMkGvstAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781791110; c=relaxed/simple;
	bh=JwYzB7BjwimNJW5R4lQY4RVYv011lZz8Dfh2G3jvzsE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=VLnxxH0SIoOcwWuoLdOtupCaV9gSH4eTThmXAG7UqoeT4UFpewJgSa2i/6bLn3F2N78MRmS9z+QQv/zhtUT952FllPCeQS6rwV1rM3fpvY6nS9y3e0bgho/HFo5Ui9RQlafkOpldDD9aQROzWggc4ZIlP3ibQIWOKkduav7sSSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JSuMZtLR; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JSuMZtLR"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8dd586317ccso7353706d6.2
        for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 06:58:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781791108; cv=none;
        d=google.com; s=arc-20240605;
        b=iw2CgvL7CcryQQuXBBB8oJNeaue9hX8tzjcphBEINNEDGB/C9lfHQppKs6wBpo9Hjh
         GJnn3xLKNROb6gFWX9qHxnPuDmiZXJIeqmhHddPGKxcq+78XIkXdqJ659+iyYc7Ax0tN
         w0TTOBKX7GDy1il4DHDspFG7Ky/JdkONoonZcXl9kBvXFQttOodQ7sj/Ao3TsAHuAVus
         0GwskfeglVDf+DRNyDSXUJV9LH3vzJGEtPHNi3/zVQme/P6mSn05aSHNhl0fAQ0aFEWj
         iRVTLzv7nWdJQzEkX9StNh4wHkaEYYx6HxHM0m/2cG5b+/T9NkSYpSH1QTdgJk+sboZI
         O7pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=IpPVp4+ODR/nzL2WgEuPjDpbalg637C/yrVGB3xLD3I=;
        fh=ODpkwlQGSWfd05B5UyeTIl4yGpLwQs9TjCAfx8Sb5Ec=;
        b=KB6/95zjPaNLNMfx7wXVEeVrE9IjHd74EUK22Neg4l9lrSgPx3D2X3Z3r/f7xRpHTa
         TMhdSxhUXjCG6v93rP/lQLku+J5Nlom1Nr+xs4t7BuYUr1HHIWfOIDaBa4j51Qs6VE9F
         9ekg98G/O+52N9JfveZCbc50UfIGz5pUeDhjBcsyzuBNUKTyUo4tcunck/7kMwjfmxSc
         QWTM4CQbQCExNsliiBd7wXzIp5pbhbjvmaIWEEzNEu90vvrfZPjjf2jhyJ/DODSupU4F
         quGhqbQOqRYJDHbbgaZ2a2fJTQq8I8mICImJbQtY6LweUCC0OYNxPD07UlwRLBKJFN0S
         YuvA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781791108; x=1782395908; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IpPVp4+ODR/nzL2WgEuPjDpbalg637C/yrVGB3xLD3I=;
        b=JSuMZtLRFFbfZReOEZAHG4tgrogy8c+n4T61g9NmoZdpPeAaqvEw5s0rlWPTRKi9mP
         wosWx7KUfbHLWew+kE1yeYrZq4NH0KIHc/r12dPmoSuv/YoWFcJc9ycXNp6fi8v3q/q+
         oHRyl5tTMTF5SfwZWNo3gWizFo36XJMmWEJ1hA/f1x2kJlFnZP8xFK5Mmbz0v3ITpXl9
         dbup0bVJPsc9stbU/OeRHV/X9Pad/J3stHrztu9bxRqVBKED5YiLdpuBiiVoxRt4XZeL
         LyWGf/7Ik+v2zZohbp9i7NqvS5DIsq0EhRHL+rLDmrF4R7SVo9dfYRTfcUm64OB34USK
         h50Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781791108; x=1782395908;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IpPVp4+ODR/nzL2WgEuPjDpbalg637C/yrVGB3xLD3I=;
        b=Xbnhxl5Dx8rxGcB1H89ppBB2qvfdSoAwzS7uVikvYSAcQaNXGg8t7XH0SE3ZrYfsmb
         xkxOLEzslnRh2TisR/HbsLw6p38P2uwWwDjVzrCq6rnjKOu/syqlgxbWezy/CZaznGdB
         vTH3wSrzoz1jgnNC31z/vU8XsKwA1HS7b9h7LLE9W9W/YQsNTV5Vv6Qz6GpP8EVswrEB
         yS5NALSUXBtNvcZANb/xv7e83WaXuaOkvdP5mEXyh1/OPPk7YbC2+cuBY17y1Ty/bo8Q
         nWs9wefDnr72PlH9kHwj0Os7JDZqtgEc+agKHM7Q5ahpgJXCa/lCRP4SuFfQXLqhCSv1
         L9wg==
X-Forwarded-Encrypted: i=1; AFNElJ+e3oniMtLH/ZdZtbG9VArJrXCZQ+Pu1JuA435yhEhkBDbjm8CA6rGQ7OQ5zj49dABtvUnwSL13lz0Y@vger.kernel.org
X-Gm-Message-State: AOJu0YwUyxgNMfqBZ+u3cW+vCGo3RMTBCVHrXpiHV7z6/3iT8ezeJ9/R
	92qyD5yHYUotaX42CmzmV6dYxKZKbAnSyzIxP4A531WyCejqXtvk3sP0ThJIGjox9D98e/56DD0
	gxJyaA5fqcmwVqfb3Yveqzn8XlMAWZ/ntJ07i
X-Gm-Gg: AfdE7cmQ//PVwUeguGmgr1VomdMogDfZ3YxH9ZBwjfHCbynggPLcxU/WpPXEowrxdce
	bIwHwslSSs0Wc6746BjrLYbjhtskx2z8zApmNWenybRyebhPWpGVFlrdpLsiHN65SWIisYywsp7
	iGah3NmrXlLAM7M1CuJ85mcKrG6swtybLg3ttSniyB+NT15EBUk+nv7MK9P12LungT19eeUPf7B
	UYD3+WavRkerImAoRezuKbznpagC3+eXZXT4IwGaYGw1C+4Xk09c1Ahp7xaGLdAhSrB4QGXzJOX
	k1NV9qnQ4DzPOc0x7PElBf5N7+VCSxwXpbfxYnbawpSS4c65GPhlAtvLvadjYG0lG4b8IRyfoIP
	5ZpruBroSp5scuBqQrqK2YeZswBjq4gkpx6XIHMWjLWNAWs8jEX4FOnByXHFRD4o1CrR900ViO+
	zlEec+cEqDyO0=
X-Received: by 2002:a05:6214:449b:b0:8ce:d698:c0d5 with SMTP id
 6a1803df08f44-8dce2bdff3emr62535736d6.36.1781791107797; Thu, 18 Jun 2026
 06:58:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 18 Jun 2026 08:58:16 -0500
X-Gm-Features: AVVi8Cdto4XRQYwpcWRyjm-wD2ISwt0z9odL64Oy1ActgJm1-DHTuJPq9zPP30Y
Message-ID: <CAH2r5msgSAsroCEL14oXfCzC7iZFUmqQaZtT_cTx-1vgE56h4A@mail.gmail.com>
Subject: [GIT PULL] ksmbd fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
0e0611827f3349d0a2ac121c023a6d3260dcecdb:

  Merge tag 'pull-fixes' of
gitolite.kernel.org:pub/scm/linux/kernel/git/viro/vfs (2026-06-15
15:53:57 +0530)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.2-rc-part1-ksmbd-fixes

for you to fetch changes up to 1c8951963d8ed357f70f59e0ad4ddce2199d2016:

  ksmbd: fix path resolution in ksmbd_vfs_kern_path_create (2026-06-16
18:57:22 -0500)

----------------------------------------------------------------
31 ksmbd fixes
- Two use after free fixes
- Out of bounds read fix
- Add SMB compression support both at rest and over the wire: support
    decompression of compressed SMB2 requests, initially allow
    compressed SMB2 READ responses, and implement get/set
    compression operations for per-file compression state.
- Four credentials fixes: for various FSCTLs, setinfo, delete on close
and for alternate data streams
- Fix access checks and permission checks in DUPLICAT_EXTENTS and
SET_ZERO_DATA fsctls, find_file_posix_info, FILE_LINK_INFORMATION and
smb2_set_info_sec
- Reject non valid session in compound request
- Serialize QUERY_DIRECTORY
- Prevent path traversal bypass by restricting caseless retry
- Path lookup fix
- Two minor cleanup fixes
----------------------------------------------------------------
ChenXiaoSong (7):
      smb: remove duplicate server/smbfsctl.h
      smb: move compression definitions into common/fscc.h
      smb/server: get compression file attribute on open
      smb/server: implement FSCTL_GET_COMPRESSION ioctl handler
      smb/server: implement FSCTL_SET_COMPRESSION ioctl handler
      smb/server: get compression format in get_file_compression_info()
      smb/server: fix incorrect file size in get_file_compression_info()

Davide Ornaghi (2):
      ksmbd: fix UAF of struct file_lock in SMB2_LOCK deferred-lock cancellation
      ksmbd: fix path resolution in ksmbd_vfs_kern_path_create

Ethan Nelson-Moore (1):
      smb: server: remove code guarded by nonexistent config option

Gil Portnoy (7):
      ksmbd: fix use-after-free of a deferred file_lock on SMB2_CLOSE
then SMB2_CANCEL
      ksmbd: add a WRITE_DAC/WRITE_OWNER check to SMB2 SET_INFO SECURITY
      ksmbd: add a permission check for FSCTL_SET_ZERO_DATA
      ksmbd: add per-handle permission check to FILE_LINK_INFORMATION
      ksmbd: reject non-VALID session in compound request branch
      ksmbd: enforce FILE_READ_ATTRIBUTES on SMB_FIND_FILE_POSIX_INFORMATION
      ksmbd: add permission checks for FSCTL_DUPLICATE_EXTENTS_TO_FILE

Guangshuo Li (1):
      ksmbd: fix use-after-free in same_client_has_lease()

Hem Parekh (1):
      ksmbd: fix out-of-bounds read in smb_check_perm_dacl()

Namjae Jeon (12):
      ksmbd: prevent path traversal bypass by restricting caseless retry
      smb: move LZ77 compression into common code
      smb: add common SMB2 compression transform helpers
      cifs: negotiate chained SMB2 compression capabilities
      ksmbd: negotiate and decode SMB2 compression
      ksmbd: compress SMB2 READ responses
      ksmbd: serialize QUERY_DIRECTORY requests per file
      ksmbd: use opener credentials for delete-on-close
      ksmbd: run set info with opener credentials
      ksmbd: require source read access for duplicate extents
      ksmbd: use opener credentials for ADS I/O
      ksmbd: use opener credentials for FSCTL mutations

 fs/smb/client/Makefile                    |   2 +-
 fs/smb/client/cifsglob.h                  |   2 +
 fs/smb/client/compress.c                  |  12 +-
 fs/smb/client/compress.h                  |  28 +--
 fs/smb/client/smb1pdu.h                   |   5 -
 fs/smb/client/smb2pdu.c                   |  44 +++-
 fs/smb/client/smb2pdu.h                   |   4 -
 fs/smb/common/Makefile                    |   3 +
 fs/smb/common/compress/compress.c         | 399 ++++++++++++++++++++++++++++++
 fs/smb/common/compress/compress.h         |  28 +++
 fs/smb/{client => common}/compress/lz77.c | 136 +++++++++-
 fs/smb/{client => common}/compress/lz77.h |  17 +-
 fs/smb/common/fscc.h                      |  18 ++
 fs/smb/common/smb2pdu.h                   |  11 +-
 fs/smb/common/smbfsctl.h                  |  10 +-
 fs/smb/server/Makefile                    |   2 +-
 fs/smb/server/compress.c                  | 209 ++++++++++++++++
 fs/smb/server/compress.h                  |  16 ++
 fs/smb/server/connection.c                |  12 +
 fs/smb/server/connection.h                |   3 +
 fs/smb/server/ksmbd_work.c                |   1 +
 fs/smb/server/ksmbd_work.h                |   4 +
 fs/smb/server/misc.c                      |  33 ---
 fs/smb/server/misc.h                      |   1 -
 fs/smb/server/oplock.c                    |   6 +
 fs/smb/server/server.c                    |  10 +
 fs/smb/server/smb2pdu.c                   | 303 +++++++++++++++++++----
 fs/smb/server/smb2pdu.h                   |   3 -
 fs/smb/server/smb_common.c                |   8 -
 fs/smb/server/smbacl.c                    |   4 +-
 fs/smb/server/smbfsctl.h                  |  91 -------
 fs/smb/server/vfs.c                       | 182 ++++++++++++--
 fs/smb/server/vfs.h                       |   3 +
 fs/smb/server/vfs_cache.c                 |   5 +
 fs/smb/server/vfs_cache.h                 |   2 +
 35 files changed, 1344 insertions(+), 273 deletions(-)
 create mode 100644 fs/smb/common/compress/compress.c
 create mode 100644 fs/smb/common/compress/compress.h
 rename fs/smb/{client => common}/compress/lz77.c (75%)
 rename fs/smb/{client => common}/compress/lz77.h (65%)
 create mode 100644 fs/smb/server/compress.c
 create mode 100644 fs/smb/server/compress.h
 delete mode 100644 fs/smb/server/smbfsctl.h

--
Thanks,

Steve
