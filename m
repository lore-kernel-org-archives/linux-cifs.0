Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A80399364
	for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 22:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776117991; cv=pass; b=cIa7Mt7jpuPFL+MDWrM6uO7U7kUGDLwnRxFak85SqKW769FHQBJZKmxGpMoxvgKb0JS8v66jU+NTO9RPz1McdRytqUkafPQVYYUXS/5t3v8b+xMlR4+q3df0254uEp6WiBpZ1uOpoWyQ90GA+mV6JwCsH0y6KN/prRckgMJ4bts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776117991; c=relaxed/simple;
	bh=1NUh5TXhKquauf2LnU1ejg+92slSFqW4npS4wv9kuz0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=hMrnvR5uJIU1Lrix5HcKmvTq7RVqNnHx3kx4BQXVhAsVbisEibmNxBCo1KFpMySEYInKA+7H1q7ja8vTQQFQFMU1UE6LtdGYhTVfZcPXZu4beJSEmsfXh+U+Gsyx0G1xcG9mjTfWK1zHcmoYArLwBEe02cEpxyRJ9FXe/3DR6pM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bPjhng4O; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bPjhng4O"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8aca0469204so21234776d6.2
        for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 15:06:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776117988; cv=none;
        d=google.com; s=arc-20240605;
        b=VhiH0s7gzV4dEfBoDHNXHzIy0VDM2+PUxuXv4GIN8nXfbQXZQTelpV7T9qPV8GUvVF
         6f8EaCGK9azSC2dof9Sgg8y1nxahphhPi+Dhsya7q0HXZQF1M5/jUvdUjars5MZB/v8P
         GBQ2Id3vT8RuTqgLhQr1rySBP1YRG9IHHF4PdikrL1xcFD3Ny7f2SN8LsKHT6i+G0E1C
         KurXIttE3fU3rOzvBOnixOWdvYtnJj3r6UylLv2z4fbZgaBCQPo4HdzQ+uytcYdo1nl9
         owgLWRyTa7td03iwJAltikzqe1Tw/SGr1f8wF4q61s+V+OMXskPnMiwRhqtrhZw9QMLD
         Y1kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=x7x+q7J1ObtQol3Z08necL3Hy9XISVeZKFkRbzFwqWQ=;
        fh=5iestLkdP/qxb8mEq9sVMlWGXeO1aT2hNpdgrCt7T64=;
        b=DfSBxuvRwYlU2jm/9p6tsun0CQk33z50V+LHdefDUODG1NCr2FzjXvXZb3WcPdxD7Z
         wOlc5/f/ScZXS7zhdMozXNq0CQcb914wXFs8qUAM21qWnhJ2IB4WquUOphN9JTX0Pmr1
         vPu0wzUN88Ql9R7z9hOUHbkoBFv8L871KzxpMiZd7N0ZsPf9A58v2xPd1B7rght/igdY
         C+QvWXbFXUkJxS5aoiC/UK+rNa+gW+JeQTVjEi7yldBEyYuM+J1cWZmaqKj9JIy9mta6
         euozJOJXjYg5pxt4tFjOdIxl+bVH8UVnikIkyopjJAq2pXNcHouF52sbEsSA8RK85sje
         VYeA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776117988; x=1776722788; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=x7x+q7J1ObtQol3Z08necL3Hy9XISVeZKFkRbzFwqWQ=;
        b=bPjhng4OY8BJa+zOa+o1LHmcQ5XtASeUORdbNy6zeTVPln5oPPppHseypCnpS+LH4O
         bj6oiXAqFwk3ATDN3//o655Z0lThngHCguFpo5oCuH1JW3/zOvXYGyOIlhgSH4pCz12l
         loNbZCJFYf3FTKj7puHRB8LqLxByJ0/v0lsMBJf30USoF37sDXkBaGyfM5zXuRfuv9yu
         d7GtsUqR1SAognA5Wh6saZN60vFu+N+CF8nEq+7q7kFhjIJAqNE0L4vl7cWBbiiMF7hz
         6v0jRYDzZp/kfvxkdGTVTaKAjxofxQHfL6CMMienEwhM2QFedPPb7VvEHYx+53rSyk9X
         JG3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776117988; x=1776722788;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x7x+q7J1ObtQol3Z08necL3Hy9XISVeZKFkRbzFwqWQ=;
        b=ooyMtWINEsKbIzRaGGkwj+FwFQ6oWeleNoQ1DM4xXdLo13WMLcKZtsSxSQIbcOYSMM
         OQsuyc9Tyv98pCkQU4qpNrfW5ImeTFPIk2rfeE6g99+LnR9yW2Fihdp4i8egBIzbGubV
         asnoafhPteSsgeFDdtY7KYICqGkK2dHnJ9ZwpTaGoU7fIvjGZvtSjXaiUOaUGi5KLZWi
         KVEiCbEw5m0OBJUVBJ1Q8dl6NEItt1rvna+Z9KHTzoomNve2I6xQv9lrCAv6oQ05nkuu
         8HpImMM5BblIx4nN4xTZgHrLpb7vLLGDTc95gpZdtrkd19yS/AXZ0x/uBVrbPOnwrvIY
         lK2Q==
X-Forwarded-Encrypted: i=1; AFNElJ836RU41MLiS+6sMzxU1RkopS6zvj1fNegqnHb1H6+5tg/Uh4l3kFUHTtc5oapEMKrWGnxrRFafljcs@vger.kernel.org
X-Gm-Message-State: AOJu0YyBFn3Qt7VuAudttPfRFfTA7xC7wehZY7+/VmV4xPD75TZhMCOf
	Rgp3ahmz9b1E1+G3sA72uB80zqNIcrqsIcgmp+O5ZtgpLiKYwyWW+7jxXTrlkJ6rMBS7xBOdl9P
	5HutnEA07QrfT9Qf/acUC7LaVzvwmq58sWCd5
X-Gm-Gg: AeBDievZ/T6Ewm5gXsDRso2b+2vTNrAhYxdF8G8C4C/JnpF68KgAOxsKT1yU6f9E4rT
	fcL4ymLxG6Fdt3unvT9WE0F4wNqqxUDdLoc+GTO4dymY4zT9tbLo8zII04sRZc0ptCEEPYimtQ1
	tg4w7ONdnKUzuc5nR859X+WZmzYfzLOuQbpbsFy5Z34GicqYKMPkTR0nArXyOr5JepjZC91dEg5
	QiQQCH27XIXELgs6IbqBhGzOxuP0ui2EoFyzvLDMqFp1/wZjzU0dg2nqEEZzeCCeUlNXX0nksKM
	Ylcua/rMI6w+rzFf59DpNuabjVEeT19bNbVMojAapcu5LNJkA8BrZ6PMWPbNckcYFYeUGDkbMMv
	fmpKRMZp+qMgAYNI5IvfynIbvZqDdEz96DUPZH+gS9qjuz7YECj20D/d7waRUrQWsdJmV2fqhBN
	Sust6PxLpdZMAcypJ5DwAfa6d+/7V3uiNs
X-Received: by 2002:a05:6214:27c5:b0:8ac:a9d2:9404 with SMTP id
 6a1803df08f44-8aca9d29bcamr104860656d6.30.1776117988159; Mon, 13 Apr 2026
 15:06:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 13 Apr 2026 17:06:16 -0500
X-Gm-Features: AQROBzCZacjbtOkxYPPQndqBRPHEzXgMEdBBFgwnC4Id2SZdUHDPRJ4kfrYkODU
Message-ID: <CAH2r5muW_D8eDN0iN7kzFV0km+QBVZn087+AGHTeSHm0E-KqYw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
591cd656a1bf5ea94a222af5ef2ee76df029c1d2:

  Linux 7.0-rc7 (2026-04-05 15:26:23 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc1-part1-smb3-client-fixes

for you to fetch changes up to 4248ed1013816f97f4029d06b16c67a6e43d0668:

  smb: client: allow both 'lease' and 'nolease' mount options
(2026-04-13 09:14:54 -0500)

----------------------------------------------------------------
Twenty six smb3 client fixes
- Fix EAs bounds check
- Fix OOB read in symlink response parsing
- Add support for creating tmpfiles
- Minor debug improvement for mount failure
- Minor crypto cleanup
- Add missing module description
- mount fix for lease vs. nolease
- Add Metze as maintainer for smbdirect
- Minor error mapping header cleanup
- Improve search speed of SMB1 maperror
- Fix potential null ptr ref in smb2 map error tests

----------------------------------------------------------------
Eric Biggers (1):
      smb: client: Remove unnecessary selection of CRYPTO_ECB

Fredric Cover (1):
      fs/smb/client: add verbose error logging for UNC parsing

Greg Kroah-Hartman (2):
      smb: client: fix off-by-8 bounds check in check_wsl_eas()
      smb: client: fix OOB reads parsing symlink error response

Huiwen He (9):
      smb/client: annotate nterr.h with DOS error codes
      smb/client: autogenerate SMB1 NT status to DOS error mapping
      smb/client: replace nt_errs with ntstatus_to_dos_map
      smb/client: refactor ntstatus_to_dos() to return mapping entry
      smb/client: use binary search for NT status to DOS mapping
      smb/client: move ERRnetlogonNotStarted to DOS error class
      smb/client: annotate smberr.h with POSIX error codes
      smb/client: autogenerate SMB1 DOS/SRV to POSIX error mapping
      smb/client: use binary search for SMB1 DOS/SRV error mapping

Paulo Alcantara (4):
      vfs: introduce d_mark_tmpfile_name()
      smb: client: add support for O_TMPFILE
      smb: client: set ATTR_TEMPORARY with O_TMPFILE | O_EXCL
      smb: client: get rid of d_drop()+d_add()

Rajasi Mandal (1):
      smb: client: allow both 'lease' and 'nolease' mount options

Steve French (1):
      MAINTAINERS: create entry for smbdirect

SunJianHao (1):
      smb/client: avoid null-ptr-deref when tests fail in test_cmp_map()

Venkat Rao Bagalkote (1):
      smb: client: add missing MODULE_DESCRIPTION() to smb1maperror_test

Youling Tang (4):
      smb/client: check if ntstatus_to_dos_map is sorted
      smb/client: introduce KUnit test to check ntstatus_to_dos_map search
      smb/client: check if SMB1 DOS/SRV error mapping arrays are sorted
      smb/client: introduce KUnit tests to check DOS/SRV err mapping search

ZhangGuoDong (1):
      smb/client: move smb2maperror declarations to smb2proto.h

 MAINTAINERS                       |   14 +
 fs/dcache.c                       |   19 +
 fs/smb/client/.gitignore          |    3 +
 fs/smb/client/Kconfig             |   12 +-
 fs/smb/client/Makefile            |   25 +-
 fs/smb/client/cifsfs.c            |   11 +-
 fs/smb/client/cifsfs.h            |   23 +-
 fs/smb/client/cifsglob.h          |   23 +-
 fs/smb/client/cifsproto.h         |    3 +-
 fs/smb/client/dir.c               |  352 +++++++++---
 fs/smb/client/file.c              |   53 +-
 fs/smb/client/fs_context.c        |   18 +-
 fs/smb/client/fs_context.h        |    2 +-
 fs/smb/client/gen_smb1_mapping    |  124 +++++
 fs/smb/client/inode.c             |    3 +-
 fs/smb/client/link.c              |    1 +
 fs/smb/client/nterr.c             |  704 ------------------------
 fs/smb/client/nterr.h             | 1082 +++++++++++++++++++------------------
 fs/smb/client/smb1maperror.c      |  873 ++++++------------------------
 fs/smb/client/smb1maperror_test.c |   77 +++
 fs/smb/client/smb1proto.h         |   15 +
 fs/smb/client/smb2file.c          |   20 +-
 fs/smb/client/smb2inode.c         |  402 ++++++--------
 fs/smb/client/smb2maperror.c      |    3 -
 fs/smb/client/smb2maperror_test.c |    8 +-
 fs/smb/client/smb2proto.h         |    7 +-
 fs/smb/client/smberr.h            |  415 +++++++++-----
 include/linux/dcache.h            |    1 +
 28 files changed, 1835 insertions(+), 2458 deletions(-)
 create mode 100644 fs/smb/client/gen_smb1_mapping
 delete mode 100644 fs/smb/client/nterr.c
 create mode 100644 fs/smb/client/smb1maperror_test.c


--
Thanks,

Steve
