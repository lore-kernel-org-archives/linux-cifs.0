Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856DF261B71
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 18:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783706678; cv=pass; b=nbPG5PYHRTs9o18qJnHRIXUMFm2dLHPctzmD4V4m4hA6CK/cudQBXO4EZ/qyI+QUdBkSoruai6wOmdwPLRm5u1BETanKTlBoIjOpx2DaS6WKBY4gdcX8Pd/PDQqVbJkBG+Ayf9eoRgABQXfJw34lZhwtQTqr421HaReIbxaOlpM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783706678; c=relaxed/simple;
	bh=fDpzHS870/ll2H6bL+4XZZ4l7iF4BMQMLvLordmcfKc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=E3vtXXoZ+Wc+UW3j2kepbme8bBSu05ZoA1e6pkrozozX/PBGvNg4jBgPFKYes9jzny7Afvwflcp9fPf4LfrwgXSHGs8V0z+DrpHL+tG1rTw90ZZESzuwqYkC1f4MV1CiQ7t4Is2Jid0Y3rgnoRUw7za5KwaqNKFb6VbjAb7JgqY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hEiFdEqh; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hEiFdEqh"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c2808dbc3so7307441cf.1
        for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 11:04:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783706675; cv=none;
        d=google.com; s=arc-20260327;
        b=bIKt6WvWkieDoP1QiFLVh6ENTGLOHtcXrPGsTnJV2n0cSAOHwUgSYBzVeLbp51Zr0u
         /3c0BzQlfpn/zvTMFsZu9HeiYpt1rCfiaYIlBaOPRV9k+cxfsy9XztdTLTa6GvaUmNrL
         uLNM7bfr9C4DAGiOdzgFCJhXLv9BoVRaMao30IzXLGEo3Xn3tjWaTFdVdZ6rFJDzahpc
         /NaFOldZTEkBFy51JvD1nQ7BQZgS26xPjSGfdBmLFmtdIOiP3il/Zr8JFJ6x6wEgCCW+
         kmv0O2bcW1Wdo2vgxT4kMZ/xLSSTQvMhlX9XD6jIFBRqkfzuoaTh+DSweAd0RkY9gPL6
         KBFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=aWuoIiTWd6CKC5WT2iLgbFPnY5SCLuI23SoYZKVMgjw=;
        fh=19qWtpzjazHwpc/rfO6Eqx9AAT1u0rwQfwoQY0l6Q+c=;
        b=g+mqNmWtDZlTbsWbPIcWFxJ5omvJ32DTZxZ7epIGmgCesEbJi3ESVK7Ql6ODMtHbrL
         uSJEszCyfaSDf1glKBM6lJsR9ZwzFhXsc6zUEYrvLYNPqxvKMFL2mhVMSsM7dJ+h7SmK
         B+fBxDQIEVgkviMnwVk9p6Mm+Xa1a3kkh4SMNSy4s/xgGM1UY2dSag9EqVdLrBobBmJd
         oylr4LHV53918SXLVZ2Pa5eSIPlQdY9mASKMyzHyYblTsouD62ny+00XMLo9Ej00l6+j
         8a73a5iLhdD5fznWld0j9C2cKVoHA5iZy9TwNwamWUp/bPBr2uYoolwKlwwQGaw0LVvF
         8PqQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783706675; x=1784311475; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aWuoIiTWd6CKC5WT2iLgbFPnY5SCLuI23SoYZKVMgjw=;
        b=hEiFdEqhhtfmUOt+FWUk8HOaoBPP+KJol+Orx28IEwopTILx8CNB7AOXnNicAWkOu8
         Rf3BormmuS4pb2MyzZRX/IU60SSyMnAN/igrmGu2LrUE3YvGPQAOJofWHu74sxMVbSMN
         RsHtphi9uxk3whKet+FntuydIn003NmDc/kRcWm3V/F++lgn9P2wSMy0tjbmJ170ctwk
         Q1zQiQCnjE55ipSvK11Um/8IcVA+Od+xYnIn22eXJI6zKcM8Pfuk3/mBLVeD2KHO9du+
         ZqgLUxWfN4W5yWNysvCxO+wLQce96G06Huh8uXAHgu25D8ToLo0yZJ+5ZdZIvlzgs6de
         mBgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783706675; x=1784311475;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aWuoIiTWd6CKC5WT2iLgbFPnY5SCLuI23SoYZKVMgjw=;
        b=U5RN0w8Df5/Es3TIIe52Ev9je2r3YPmFHppTfIJMqLPIezWgOwKGOJwCwFQq6+YldK
         PpFHHNHYe8hX24WQyEzIItqFSKmZ3dU2Ee8+Ota6alOrWgtv/gHZ+/V5MaA1DCQSFg0U
         IHTqUQbuJDAbuuO+SUlZgCKJqlnVmO2wkIqNWmCmrhBwRww4MqpZUwU35qPGq++LAtPp
         c5xLtPaFJqbP1Bo5Ra5jrvevJhn1Z4poOEBokn68HPkHCrQdlT86HGTWiLaStm3OtA7r
         3JRS/nvQ4QgcEfo81DPmBNEtZ90YPqLPjR4oLXzjEBGJz9VQC1mcDWBScYJgyKKEXJ+9
         sRGQ==
X-Forwarded-Encrypted: i=1; AHgh+RoPnrO1Ni3SpwG2Tg/V34nTDabcjpU1a4cTJdWL/0TVgwusX8h655UtoeBbuut9nWdgbqruheuFM1Np@vger.kernel.org
X-Gm-Message-State: AOJu0YzmrmP0QvMjif0x7BhWydyokj66kf3SjgSYR1xwiz5ZyWAK3EL6
	FY39iPTgkJCM/cvVT29Ceq1IuKPgF0QAIxBfj+DhRxNsH6vhStZJG9bL4E+F8dbbb5TJGDYOR4v
	440cNSUaZSnLB5h2UssxMwJdLu+QlKr0=
X-Gm-Gg: AfdE7ckrTaUSE1QVrOrL+vmi6sUekvd+SsUiKII29SJxcVcCW5mQy3nYtEjwHfc+GnY
	sxd1K3T823gFcmGQMyPpT9GbKALe8DYynQjCeByhFPr+KD09bJoDQf3aRrFYGTb3XflOWx18Fv6
	W6o9GMqS29ImxKRdIaprJDCmR8kGBin4OIgonqbPpTzlzoGVnZ8Jmt1GxSFitAHUC70+jZNJnCa
	tsO+56zJUERL3LDeYeBMnUjv9z2XKhA6Ps//WTOOXhXUgvpb4ehpjCgontswPCegkPzDeT8K4z4
	K4NRaQlYEqwXTgYPxB8JegCtGSplGRNy6VOLbpJjX8iqWNLAPZT0jSCx6WDEpHhAcG8NfBWPQG2
	qsdEwmrFr16WyP94ZhRJMjNN284rZgDfBpENrZb0rD68XHQbhJE+qY/jxKACQv4yyq8eLrtt/t5
	JkwT+lk9VIkQ==
X-Received: by 2002:a05:6214:cc7:b0:8f0:12e8:f453 with SMTP id
 6a1803df08f44-90400d84760mr1427856d6.33.1783706674975; Fri, 10 Jul 2026
 11:04:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 10 Jul 2026 13:04:22 -0500
X-Gm-Features: AUfX_mwsI22d5BXgX9b7Vm60oOlQgV7EFL79fBn_zpvbksW8WfKYoH57L3iVrjY
Message-ID: <CAH2r5msowam2AVfazUvVxhkoQ+PH=-Lx=u_U-nyArAnzUGrF8g@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pull the following changes since commit
8cdeaa50eae8dad34885515f62559ee83e7e8dda:

  Linux 7.2-rc2 (2026-07-05 14:44:06 -1000)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc2-smb3-client-fixes

for you to fetch changes up to d2c46c9f7a9baf80a322eb1d4494a70e535b637c:

  cifs: Remove CIFSSMBSetPathInfoFB() fallback function (2026-07-09
18:24:30 -0500)

----------------------------------------------------------------
EIghteen client fixes
- DFS cache allocation fix
- DFS referral bounds check fix
- Fix absolute symlinks when mounting with POSIX extensions
- Fixes for incorrect nlink returned by fstat
- Fix atime in read completion
- Fix busy dentry on umount
- ioctl_query_info buffer overflow fix
- Two fixes for creating special files with SFU
- Fix mode mask in parse_dacl
- SMB1 is_path_accessible wildcard fix and minor SMB1 cleanup
- smb2_check_message fix
- Debug message improvement
- Minor cleanup
----------------------------------------------------------------
ChenXiaoSong (4):
      smb/client: use stack-allocated smb2_file_all_info in
smb3_query_mf_symlink()
      smb/client: pass cifs_open_info_data to SMB2_open()
      smb/client: zero-initialize stack-allocated cifs_open_info_data
      smb/client: fix incorrect nlink returned by fstat()

Fredric Cover (1):
      smb: client: use GFP_KERNEL for DFS cache allocations

Guangshuo Li (2):
      cifs: validate DFS referral string offsets
      smb: client: fix overflow in passthrough ioctl bounds check

Mehdi Hassan (1):
      smb: client: refactor cifs_revalidate_mapping() to use
clear_and_wake_up_bit()

Norbert Manthey (1):
      smb: client: mask server-provided mode to 07777 in modefromsid

Pali Roh=C3=A1r (5):
      cifs: Fix support for creating SFU socket
      cifs: Fix support for creating SFU fifo
      cifs: Show reason why autodisabling serverino support
      cifs: Fix and improve cifs_is_path_accessible() function
      cifs: Remove CIFSSMBSetPathInfoFB() fallback function

Shoichiro Miyamoto (1):
      smb: client: restrict implied bcc[0] exemption to responses
without data area

Steve French (1):
      smb: client: preserve leading slash for POSIX absolute symlink target=
s

Xu Rao (1):
      smb: client: fix atime clamp check in read completion

Zizhi Wo (1):
      smb: client: fix busy dentry warning on unmount after DIO

 fs/smb/client/cifs_fs_sb.h |  1 +
 fs/smb/client/cifsacl.c    |  2 +-
 fs/smb/client/cifsfs.c     | 12 ++++++++++++
 fs/smb/client/cifsglob.h   |  1 +
 fs/smb/client/cifsproto.h  |  2 +-
 fs/smb/client/cifssmb.c    | 36 ------------------------------------
 fs/smb/client/connect.c    |  3 ++-
 fs/smb/client/dfs_cache.c  | 12 ++++++------
 fs/smb/client/file.c       |  7 ++++++-
 fs/smb/client/inode.c      | 13 +++++++------
 fs/smb/client/link.c       | 17 ++++-------------
 fs/smb/client/misc.c       | 14 +++++++++++++-
 fs/smb/client/readdir.c    |  4 ++--
 fs/smb/client/reparse.c    | 17 ++++++++++++++++-
 fs/smb/client/smb1ops.c    | 28 +++++++++++++++++-----------
 fs/smb/client/smb2file.c   | 19 ++++++++-----------
 fs/smb/client/smb2misc.c   | 32 ++++++++++++++++++++++++++------
 fs/smb/client/smb2ops.c    | 19 ++++++++-----------
 fs/smb/client/smb2pdu.c    | 26 ++++++++++++++------------
 fs/smb/client/smb2proto.h  |  2 +-
 20 files changed, 146 insertions(+), 121 deletions(-)

--=20
Thanks,

Steve
