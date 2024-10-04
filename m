Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324A2D2F5;
	Fri,  4 Oct 2024 01:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728005794; cv=none; b=q7o+85J6px6rZYK6t8KFBRXbTaJr4La0lIP07UOKjvPYUC8+QZOSQLe2ULN6ZE7uKy29Gjtzj71eSqJdpRuTi+t2nVJZHIZU6elba7ujNzpzULx7u7sjo/mNK98nhvX2jB+qIEtQkrUyRjIND0IHTrSteyUCfq1SqeNbuXPZQ5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728005794; c=relaxed/simple;
	bh=qSo80J7TlDCZvmbSSFHYTyT3W/AxKAGKJC/+QLgQ2Ac=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=BeHRTZqq5KLCzN8NwCV5Il22byA1IlLa8oogvWQgKg7lGaywPPtG/y5Jiq+HWphqTSsYs1RSXKWOw85hE79BUSqUlJuxQSVTT1083ekpkKcN19gWMXtJusz3rfmDSEQW50nYUNpJLCnjAIuwj5sU7dKrgX0M7dJvoKpyQDi2JVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hOkzPnew; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hOkzPnew"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2fac3f1287bso19256181fa.1;
        Thu, 03 Oct 2024 18:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728005790; x=1728610590; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Lc5bRE+8ZfDxh1AbrZNl0WsQ7RF/kO5yAB83il12D2Q=;
        b=hOkzPnewAJOdoTXG6STkPPLLC9ICLyr2IyDpJ4eiZ9KpGa1wvyZnZvlyR3+ev7qaT4
         NFnaS8/Ot4KIAcSzmC5ziLL2eYX+mLlbY2+2/ch7wdAtDVzCHFfNBuslZvykp20M/pnU
         cJ4WpI5rAzSDpDwmZdPAYaP/SWEiKiVpikMzXgZo+1HHO+FlOKi2Zc9DVcb5S0rhrfid
         T9bugPScNgDnkl7C52cJfdCefLZfhwRWxBKgUdKxQSQoAtDOaXDMisdTPvl0rby7zkAG
         Uc9mBFbbwzMv4SWlPa+rP9pd+uw2lMkHaG8Oz3Jllp4CctE1SkziVkEOgaJyCVul/jiK
         dz7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728005790; x=1728610590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lc5bRE+8ZfDxh1AbrZNl0WsQ7RF/kO5yAB83il12D2Q=;
        b=CAB3ic9ebqAwZmm027wlPofKiuYqQKNGxb8pS55z4t8ycTyPHGusYAR60ojdel7JfZ
         5YE9YLx4wa1lPqjfY5jqma3i89p8yd+6XwClUncQsN9bPctS5JUtUI8Vo/Rsp/5p/fuT
         sQ28jCAZCzsGUL/c7refsgcNsmMSCkKql0yyAwpTuIa/sdNjVcs7F1Xz6wIaUtRpzGc4
         6Qk9u5nQurQD4jEBDX6SRIbJI6B33KmY5EBsG+fW0BrVGO+dkbJMSeiZdLxZxx0l2n0P
         lMbLjr+KIdIY/7uo8dZRwSg8j7XZhzGHhdVMuwrlKVD7/k54aI4XPV3hDE14RRtclIbq
         q6qQ==
X-Forwarded-Encrypted: i=1; AJvYcCVG1Yz1Jbvls5usOVijDrKwzDgSlp0XGAGxoUZZFJIL7YbYOBILOGy2G5T2FRjEkkA/LD1QgdVIbI4N@vger.kernel.org
X-Gm-Message-State: AOJu0YyaAM3q44YoW8oi7g8I889aWz2Am8+8O5k8AvcroPvaFAjxOJxP
	BJfXRnUM1GmPIDKfsD1KKPg8RFruBqsr/SakH9GllBxBT0D1lQUv8Q235hV/exnYZ2ow9r0vG+O
	wTm35SmWZYvSqKyTa+UgY8KKfX8fMFqBB
X-Google-Smtp-Source: AGHT+IG8iRp2C798gEnpRgyB3/Rpdk8zefYoG9SGWF0LJIjO3vi6LYKtVx3836EcFvoxEAkCixd24M9yJ82BkNsahrQ=
X-Received: by 2002:a2e:4e19:0:b0:2f1:5561:4b66 with SMTP id
 38308e7fff4ca-2faf3d7a84fmr4175191fa.44.1728005789890; Thu, 03 Oct 2024
 18:36:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 3 Oct 2024 20:36:17 -0500
Message-ID: <CAH2r5mtkbzY5hRNZQH4TzLV8gP90ni=Zk-DsSpEC4_uEWT6_Bw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pull the following changes since commit
9852d85ec9d492ebef56dc5f229416c925758edc:

  Linux 6.12-rc1 (2024-09-29 15:06:19 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.12-rc1-smb3-client-fixes

for you to fetch changes up to d3a49f60917323228f8fdeee313260ef14f94df7:

  cifs: Do not convert delimiter when parsing NFS-style symlinks
(2024-10-03 12:06:36 -0500)

----------------------------------------------------------------
Ten smb3 client fixes
- statfs fix (e.g. when limited access to root directory of share)
- Six special file handling fixes: two to fix packet validation to
avoid buffer overflow for reparse points, two fixes for symlink path
parsing (one for reparse points, and one for SFU use case),
and fix for cleanup after failed SET_REPARSE operation.
- Fix for SMB2.1 signing bug introduced by recent patch
NFS symlink path, 2 NFS reparse point validation
- Two comment cleanup patches
----------------------------------------------------------------
Pali Roh=C3=A1r (6):
      cifs: Check for UTF-16 null codepoint in SFU symlink target location
      smb: Update comments about some reparse point tags
      cifs: Remove intermediate object of failed create reparse call
      cifs: Fix buffer overflow when parsing NFS reparse points
      cifs: Validate content of NFS reparse point buffer
      cifs: Do not convert delimiter when parsing NFS-style symlinks

Shen Lichuan (1):
      smb: client: Correct typos in multiple comments across various files

Steve French (1):
      Revert "smb: client: make SHA-512 TFM ephemeral"

wangrong (1):
      smb: client: use actual path when queryfs

 fs/smb/client/cifsacl.h       |  2 +-
 fs/smb/client/cifsencrypt.c   |  3 ++-
 fs/smb/client/cifsfs.c        | 17 ++++++++++++++---
 fs/smb/client/cifsglob.h      |  5 +++--
 fs/smb/client/cifspdu.h       |  4 ++--
 fs/smb/client/cifssmb.c       |  6 +++---
 fs/smb/client/file.c          |  2 +-
 fs/smb/client/fs_context.h    |  2 +-
 fs/smb/client/inode.c         |  8 +++++++-
 fs/smb/client/misc.c          |  2 +-
 fs/smb/client/netmisc.c       |  2 +-
 fs/smb/client/readdir.c       |  4 ++--
 fs/smb/client/reparse.c       | 39 +++++++++++++++++++++++++++++++++++++--
 fs/smb/client/sess.c          |  2 +-
 fs/smb/client/smb1ops.c       |  2 +-
 fs/smb/client/smb2inode.c     | 24 ++++++++++++++++++++++--
 fs/smb/client/smb2misc.c      | 28 ++++++++++++++--------------
 fs/smb/client/smb2ops.c       | 23 ++++++++++++++---------
 fs/smb/client/smb2pdu.c       |  4 ++--
 fs/smb/client/smb2proto.h     |  2 +-
 fs/smb/client/smb2transport.c | 32 ++++++++++++++++++++++++++++++--
 fs/smb/client/smbdirect.c     |  4 ++--
 fs/smb/client/smbdirect.h     |  2 +-
 fs/smb/common/smbfsctl.h      |  7 ++++---
 24 files changed, 167 insertions(+), 59 deletions(-)


--=20
Thanks,

Steve
