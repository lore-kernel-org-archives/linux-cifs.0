Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B79E35AC0F
	for <linux-cifs@vger.kernel.org>; Sat, 28 Feb 2026 18:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302778; cv=pass; b=d1DH+ffXaCQdq+65Oyx8rMfc2RaVo1zXvaP38es9Zh4KOeh2UJr3ZLABZtiqi4t8F8BAVXMSkY4fiW85jGyrBMO3CDx9A/gIW5c8uybch31B10ejVnIRHcw36QVXT3hr7lIUO2mC78pp/4yrz1Zw4Ixw5etXCcFLjtPTQ5ArHmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302778; c=relaxed/simple;
	bh=FQuv5vbLUMr5dnQ+EodM3lwjBIqpVVO3sjk98tvHRec=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=EeNrw38szm0a+9vSd5Kqd8/j+pHTAVALCpJ3d83ed16mKE4kpiUaHOiCSLwOZTEf55/YdJghyHPIKpFkXqGzC1xjAJgYA3nQMy4O+p5khZZwdyQANI9jI2eFg9r6gV+t4uSYtLWgts7rhdrl+gA1xZFb7qU4Tfz4mKmf4IvvYHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hxS+FpWo; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hxS+FpWo"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-896f9397ecdso37614886d6.3
        for <linux-cifs@vger.kernel.org>; Sat, 28 Feb 2026 10:19:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772302776; cv=none;
        d=google.com; s=arc-20240605;
        b=JJSMdbitXz3cL9tulpdK11pavYVFU7XQviGzKxXQpMrgJzLcs2WOLWSevqdz/FksY5
         twGHu3PLbCGRBfnzF6gc14QzOZGsseF7lDE3dTtPigAzuylLd4jwH1hJ1W5ytGlmP2Dn
         MOHkmu3/fd2rm9CYlbbYSY5De7qSeEg1kQHM3H2MgkyKDClN3BEsPuv02WJFiRWi+2ov
         MwOTAW3NTJzYdlHN4p2va8ESfFcK+lZ0L+GTk4F85f15dS+qtI7NDXc19EZYfMHcpNut
         EYSapCidfQodFFZw9s+Hgh5ZK1QY7M6bpwlVDMZFMwpPsN0XnDaQ7dPtaLngnLK1p34t
         APAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=XC7oIcoonfv6rztqcQseurJxuVOxiWVLV4WfOZKB9A8=;
        fh=Nf1mvuQ9XbZKOmPhacDz1X5aHl0t82a+aHbY+2n4zlg=;
        b=Ke4btwVKt1bX+b9ge21d9epFkMettdu2cvisqzjKmJgobbtTKuY1FvhQTnlVVNFJqZ
         cjleOyVgLJ2MmnKFEJgnw2LK38qud1iNJspJy6sG785jS4OyszepDzKz8jaGYqb7luDQ
         q7W6Y9RsgQ+J/mexK3zRbjuC9WaIcH/Td2zKyI7pTBPw4IbbpdFiuDAev8p/g2pHk3ln
         bFdLqCBHF+qMsnVGPL5N6RFLrYk617cxDn1jU58fZZMAQSo0cJev6iaznkXIynqvx/oa
         85tze6oJEX54DvYvmnTybIqyhIn489nsWJobs22GhpoDPn+IU/T2sEaLk4aj7QcQp23r
         b3Tw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772302776; x=1772907576; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XC7oIcoonfv6rztqcQseurJxuVOxiWVLV4WfOZKB9A8=;
        b=hxS+FpWoHF6zU+MP3hBEFXDMLCBMXt2C2PgqH/Ez+S3QNGy7qVfETN7gltTTSTMKOv
         RO0iaiA2s9zwBGJZwA9FRdegvA4o2YiF6FYP0fIt/xazE8ng1HbL/vt0cmRc8FWqzcOo
         j3IjF83HkwwSD46WNByhOwBuLQZKzf+tFgDAhHeQjJMpOs2ideexZ3SxRxAOJuGS7z0E
         ACm0j89gTXcmy2PRe4GVc9D/V/rYhC6t/PJJG/KlRKjb9H2/xtM3llnznlpD05sGgaxO
         F+Uilndn0SSbusuy9HLAEUDHxbTVctSd4YINCLcZNCjI1Yu9iDN7/LjzPzqdkWXvlaUK
         Qw6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772302776; x=1772907576;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XC7oIcoonfv6rztqcQseurJxuVOxiWVLV4WfOZKB9A8=;
        b=IVH4LubpOY+0VxAtiE5loiO6ZWM770zN4sY3YYMJUpI27XuzRCvv0vKoJqdIjRQ2HF
         XtudFczXnbS6vivfPeoYVTAZ58jWqb9PcBicNUcT+nkpumeZ2HqypRurj10/309RhCf4
         ESog9zdMSdbh9rNFomZkFwhPlYonGxaKlmzcDICpFrf5jmEVDHiUOULhT6fM5LqrbJf8
         oXP/CrhcsnmSLHug728F5pS5QKXh0J2C9VJqvZ7NaSAV/GastWVmVU91Hf0t6U9aYE82
         +qrZJdi4zBWcjJ1h+hUMvfrguD9MNji4mxEoCkjbYSV37oYHaBCZVLHiKH0JfAshIL0G
         osdw==
X-Gm-Message-State: AOJu0Yz3lJbOhSne5m2PaOBMA/D0UVVgU4juzl3NGNLv/fT19S43iaN3
	2XFrArHz+vO+KVvMJ5GU/53faVDEaqa44fAWuL8hVmZde2o9g7nuQejNVYm0MdiS21hCZoMaIXz
	n4YA33l3Qm4vceN5wU+kYUNFlfIvMziyg13QN
X-Gm-Gg: ATEYQzwDll/j4A2mDYjxXPzZOT5KIJsw3CcNE4Cxabuo68kMGb1uFWhXNAZ095CnhN/
	uYnMAUfWbyYEGTJfdFTFJ7EfF8C2tP7/mIbKh9IAiWbe0udzguDFNPcmOpkMJPt4VFIjqSHcK/N
	h3eI4lEIsim9if+eL7imfmAYkCEesEQ51bJTD+AekjdJDB+aS5AAuLE5jCngW/euVsdE6f8255L
	plA0Eh2CJUhphSFeZyjfv0eZOdUWNcJw1f9+zZajI01E3vzdpdUlijMFfoyPJkc8Du9qGv6WgiS
	NZYppDNJh+iUR5kKm49iY7j+iO6qi7I6WKhv3WZqDI1eYFS8yikZ46VuJ4wzF0Tc29uA7Jd1Wso
	0cHMEL/rH515aJmvVjHiU2N+RVS83J0qWriK9+MV6ZuifMjeC5AwoU+leyTg=
X-Received: by 2002:a05:6214:d85:b0:899:ee47:9c2d with SMTP id
 6a1803df08f44-899ee47a650mr14350516d6.31.1772302776204; Sat, 28 Feb 2026
 10:19:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 28 Feb 2026 12:19:25 -0600
X-Gm-Features: AaiRm50Jwto4AaN7H2_A_0U7E6At4DKs4V23wPWioxTp1wWFC1IDIJJVjl0Wdak
Message-ID: <CAH2r5muiqKXDBeubdQPmxN_aqxsmSp0xoSLYV6mmm053VAnBCQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f:

  Linux 7.0-rc1 (2026-02-22 13:18:59 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0rc1-smb3-client-fixes

for you to fetch changes up to f505a45776d149632e3bd0b87f0da1609607161a:

  smb: client: Use snprintf in cifs_set_cifscreds (2026-02-27 10:19:54 -0600)

----------------------------------------------------------------
five client changesets
- Two multichannel fixes
- Locking fix for superblock flags
- Fix to remove debug message that could log password
- Cleanup fix for setting credentials
----------------------------------------------------------------
Henrique Carvalho (1):
      smb: client: fix cifs_pick_channel when channels are equally loaded

Paulo Alcantara (2):
      smb: client: use atomic_t for mnt_cifs_flags
      smb: client: fix broken multichannel with krb5+signing

Thorsten Blum (2):
      smb: client: Don't log plaintext credentials in cifs_set_cifscreds
      smb: client: Use snprintf in cifs_set_cifscreds

 fs/smb/client/cached_dir.c   |   2 +-
 fs/smb/client/cifs_fs_sb.h   |   2 +-
 fs/smb/client/cifs_ioctl.h   |   8 ---
 fs/smb/client/cifs_unicode.c |  14 ----
 fs/smb/client/cifs_unicode.h |  14 +++-
 fs/smb/client/cifsacl.c      |  17 ++---
 fs/smb/client/cifsfs.c       |  84 ++++++++++++------------
 fs/smb/client/cifsglob.h     |  61 ++++++++++++++----
 fs/smb/client/connect.c      |  80 ++++++++++++-----------
 fs/smb/client/dfs_cache.c    |   2 +-
 fs/smb/client/dir.c          |  53 ++++++++-------
 fs/smb/client/file.c         |  90 +++++++++++++-------------
 fs/smb/client/fs_context.c   | 149 +++++++++++++++++++++----------------------
 fs/smb/client/fs_context.h   |   2 +-
 fs/smb/client/inode.c        | 142 +++++++++++++++++++++--------------------
 fs/smb/client/ioctl.c        |   2 +-
 fs/smb/client/link.c         |  14 ++--
 fs/smb/client/misc.c         |  16 +++--
 fs/smb/client/readdir.c      |  39 +++++------
 fs/smb/client/reparse.c      |  27 ++++----
 fs/smb/client/reparse.h      |   4 +-
 fs/smb/client/smb1ops.c      |  22 ++++---
 fs/smb/client/smb2file.c     |   2 +-
 fs/smb/client/smb2misc.c     |  18 ++----
 fs/smb/client/smb2ops.c      |   8 +--
 fs/smb/client/smb2pdu.c      |  35 +++++-----
 fs/smb/client/transport.c    |  21 +++---
 fs/smb/client/xattr.c        |   6 +-
 28 files changed, 489 insertions(+), 445 deletions(-)


-- 
Thanks,

Steve
