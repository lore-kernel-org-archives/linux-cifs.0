Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971951A9FA0
	for <linux-cifs@vger.kernel.org>; Tue, 17 Feb 2026 04:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771304107; cv=pass; b=gjGJrs1/7JE+SYR/3Tdm9a+fWn/msBeOVWKdQ90nhrenq7+ecD5woTckBmoH5E/gIsv/DMt7IO4Q6RbbX+Ao2wsu3owbGRfA8e36VSR8v9vT2haHdUqeqPB+NIjdx6iM9ib0ai59THDflhjr8SsTxVbeg2Re06/8UTAZsgGn/2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771304107; c=relaxed/simple;
	bh=Mvzmn3fT5WLRqxDc7zOrcPwCiSkzAE4OGdhVuw1tX5U=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=mrrI3WacwiHeQP6GD75TUaRsroMYCxnqoKcxEvlNr+OnwQXeaa+hBDRlkMUTCNRLkG8X4niwsFLqwVuAAHbyEcKRF1hTNnGZF9l7x0PVQ53PS2JOAPN7sPw+soGqRSotg2lmxQFvTL4kYRPOqmlGPHFnZyW2LpI1ex42X5h9HQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TpdSvIbR; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TpdSvIbR"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8947ddce09fso38185916d6.3
        for <linux-cifs@vger.kernel.org>; Mon, 16 Feb 2026 20:55:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771304103; cv=none;
        d=google.com; s=arc-20240605;
        b=BVXucsjOBbiBipcyivSxRVRAmHhAsShxAG41ldErzNWKtJbxWvxHPqV+EkbDhyHgXX
         CJzeThSaduwYepqthXvxr3RO9i6h6kKywYgMyySpEjSdZN//l7fkwMsjVUnd4bht3pFr
         SDxiXkppt111MEJ0DPXW7gZoUzq9NhF8yd5OhPtE8gf2xccBlZPdtqo4kn7n+cnwrpHs
         emwq3e5FD4Wi21I3ziuq5qxhd6QzHpsicbcaETlsEBZFgI7x6oMSCbKwqOBDczZEml+l
         AbFVdgiXtbRn7GxVzhH5+CWV9WDrxwjm+349QzjHGHDDU7qfxWYHa5RpinvmEFBfujqB
         TiuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=XemI36NQo4trE5HNtSPRz7PF6C0ONtiy/VnxP+vpTJs=;
        fh=PcYIDj+h+/khW7S/sIkRgnwlVW83caXkRK+7LWXWu4I=;
        b=R1P1CIYLDuSRs9dCkyWWo9/YgJyzC47lBlBb3gctoqWbSS90Ar5Pj8gOYU1Tg3PvnO
         LaHu4NuP5+eDTHpYqSfddqeuevpUEzgaLli9kwd3N1Qj02+jhR3IUs/FVQFq7obFyvl8
         LU1O/8DN9kTGHE6EsnnXc2sFQdMk+LyDV7teJhnnt1OArp1pyCng2HsUorZ9RQAClstu
         bjaWz/1ZK3g51JkKKegvBypU3lQy171g3PjG6rWz3ehCL0Xk6HcM/KmdyuxCltHX6ij3
         XzAylMU6UHNEAhQwQOdk8hKk3nYlxXXoH1PNeMvOsfFYHR5j0HNKbw/Sm1JECRC+rNKN
         Dthg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771304103; x=1771908903; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XemI36NQo4trE5HNtSPRz7PF6C0ONtiy/VnxP+vpTJs=;
        b=TpdSvIbR6zwf/bJJj1uYjgkVUhHlCQ09PfjN6NlwBqAQiTEn5GuHXoUi0vIatTMqce
         qbHEZp+Vp4MwUnpQvMU5/601OSZFimvJLNt68jQj62EYfPGhhaXFPTr2LF0TgIa5sNED
         /qDpA7Rxbs10ve+JhVQXbpaT7JXFSotVxXwVKEnwMB+PBSPILS6B17QxGFmZXW3eXoyy
         u098bzVHHkvRQeHKu8vKgeYiD1pjh2TPI3CaQn9FWidS8bLDckMN/lG8qy1bqFR9xZIB
         PnBQJRRaWnC9Wr/bMzrXw/nDzqy5Kv5gtd5b1QSUu/+DDwYpiEgIFkaNbjIQSjfGfpbb
         VogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771304103; x=1771908903;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XemI36NQo4trE5HNtSPRz7PF6C0ONtiy/VnxP+vpTJs=;
        b=PEpcRpMGKgFvILm8N95ItG3QSGrWuZSxBxpQWMhp3F2Aq/2b0eMIVUDeN/NjXK1fhm
         5jdwBpk2u+yuysfkli6LnW9qVmIQrCZv2N6tTRDnGpZ7RfTv5JsUICZXm003br3DYPpG
         6Ut4XAjCLv+8QH6KU1gaPS+Abg+Hl/J1TyUfiP2bD8OrxhM8afXgrmDwICZ4DY8kuPj4
         oVXUEJ2rT8Yc4xkWPYrtAstvb2E5C+y42GoOO4NAQFgBxzWWuKKdkdJoOxq6dX5wGuk2
         VF34Mwb/C6LcleFbLhoGT2rhMOY68RX1eQzUiG8ZZXgcNPL8HLY48Z+A5Q1BvNq92PoS
         OFkg==
X-Forwarded-Encrypted: i=1; AJvYcCW0FGsbrmiVSfxX4BBDmzgukCkDfYwUFWXbitsKyURi1DXjx3Y8NF4utQZHh5ntHqshm6D3P02t+7r0@vger.kernel.org
X-Gm-Message-State: AOJu0Yzabuq+FoRnNQW5o05JP7dK331h1OMklS3qSJIp6u7tn7hDzvzE
	+raaPfDo7l5kZgSUNGEXyIgZs806UNuEcaDXot7rSU0M4eazLJVtudgModzaKSgKwxfZq+bOxky
	aVXElHlgP8ujmoSnq67nt05v40O/FDjU=
X-Gm-Gg: AZuq6aKY0Fi53Ta2ldOWn7VpAXkzV8tXp0fXZ3PV1t1WI/0CkPGihxXfnpWuCjk39kC
	LChfzkAH1HGfBDk68y1A4c2SlASYC0giR3rP7TSjqZVZCSMishmCiUgZU9B+uUVZMQ+kWdi75A/
	H5Bbe2m0cp8AlXFfu+DE25f1cIyqgXciIbGxNMLaUqMSvxK/a88NJ8XUHVL5kzVMKEHbq4oFBlv
	mkTfQJtubCmNe/tzmX6de9WGnIiCtIMEpijXDUATvqXRA9IV3NgLiKjfO5YtlI102oO0K+wF8uq
	Gc8tXSr2Qr6RSw86eo4Fi3VK/Sp6vz+CJRCKmTYHBWNiaOTKpfvO5Zkoigla+MZ6bmhUBjhnmKy
	e0umflGlBCQx4vvzPWU2+LT+k9te9FE4c2GCA++rTgfru5ChL5PaBFbVYkZHFZxqf8uyj5ClyTP
	LgbTf7ZLRwnfQISoMaV8hmRw==
X-Received: by 2002:a05:6214:20eb:b0:88a:2d3d:7c30 with SMTP id
 6a1803df08f44-8973623f9cemr191349856d6.55.1771304103488; Mon, 16 Feb 2026
 20:55:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 16 Feb 2026 22:54:52 -0600
X-Gm-Features: AaiRm539ALxTZGR3l43p8e2_ek9FjlVD4RtHQGVC1OBTzpDayzTWqhfppwlyWvY
Message-ID: <CAH2r5mt+WBNhuWCOym8zPCfBFpxfoDF9O0gT0dbgt9q-ZJfxAQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
d53f4d93f3d686fd64513abb3977c9116bbfdaf8:

  Merge tag 'v7.0-rc-part1-ksmbd-and-smbdirect-fixes' of
git://git.samba.org/ksmbd (2026-02-12 08:31:12 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0-rc-part2-smb3-client-fixes

for you to fetch changes up to dc96f01d54cc7c785c98ee6e2b53075949ac16ed:

  smb: client: terminate session upon failed client required signing
(2026-02-15 18:35:34 -0600)

----------------------------------------------------------------
14 client changesets
- Fix three potential double free vulnerabilities
- Fix data corruption due to racy lease checks
- Enforce SMB1 signing verification checks
- Fix invalid mount option parsing
- Remove unneeded tracepoint
- Various minor error code corrections
- Minor cleanup
----------------------------------------------------------------
Aaditya Kansal (1):
      smb: client: terminate session upon failed client required signing

Chen Ni (1):
      cifs: SMB1 split: Remove duplicate include of cifs_debug.h

ChenXiaoSong (7):
      smb/client: map NT_STATUS_NOTIFY_ENUM_DIR
      smb/client: map NT_STATUS_BUFFER_OVERFLOW
      smb/client: map NT_STATUS_MORE_PROCESSING_REQUIRED
      smb/client: map NT_STATUS_PRIVILEGE_NOT_HELD
      smb/client: rename to NT_STATUS_SOME_NOT_MAPPED
      smb/client: rename to NT_ERROR_INVALID_DATATYPE
      smb/client: move NT_STATUS_MORE_ENTRIES

Paulo Alcantara (2):
      smb: client: fix regression with mount options parsing
      smb: client: fix data corruption due to racy lease checks

Shyam Prasad N (2):
      cifs: remove unnecessary tracing after put tcon
      cifs: some missing initializations on replay

Steve French (1):
      cifs: update internal module version number

 fs/smb/client/cifsfs.h        |  4 ++--
 fs/smb/client/cifsglob.h      | 36 +++++++++++++++++++++++-----
 fs/smb/client/file.c          | 57 ++++++++++++++++++++++++++++----------------
 fs/smb/client/fs_context.c    |  4 +---
 fs/smb/client/nterr.c         |  3 ++-
 fs/smb/client/nterr.h         | 12 +++++-----
 fs/smb/client/smb1maperror.c  |  4 ++++
 fs/smb/client/smb1ops.c       | 16 +++++++++----
 fs/smb/client/smb1transport.c | 11 ++++++---
 fs/smb/client/smb2misc.c      | 10 ++++----
 fs/smb/client/smb2ops.c       | 48 +++++++++++++++++++++----------------
 fs/smb/client/smb2pdu.c       |  1 +
 fs/smb/client/smb2proto.h     |  2 +-
 fs/smb/client/trace.h         |  1 -
 14 files changed, 136 insertions(+), 73 deletions(-)

-- 
Thanks,

Steve
