Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9216121FF50;
	Fri, 20 Jun 2025 22:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750460251; cv=none; b=id9Yr+6N20aLp/dVQrw2FIJgOo829wgRN3+eTKDjGWDVzZJnQaER+2K56kBXyD/noNhFo+ddn3SWOdi6TeTgUJeON4BKDbWtmIzL/0xv2DMQO1jFqZpcJt3Pv4yR0djxhjVfLsZH86vgnJMvw1/GwRFWrrmAwaTKltu0imYP1cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750460251; c=relaxed/simple;
	bh=LpAYjac3WawVFFPMG8aMMVk2GbhLoa+PG4ywDJstQ3I=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=gY8MYwDTaFg+2iH68LDJokMJZYplurax+CyLVTwUyPAW1RlDlZykNUQB+tiybZZS0CdpOOJGrfwogNyA1SJEaiVMbe+UWZ2IOLw9A/EzoJtmCynU8oNygUEWjfi/5nSq3C/6hdQyepKHsHSORYE9uBmKk1wy3LBghRRBWjdWc+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GrrXAa5I; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GrrXAa5I"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7d38cfa9773so247095685a.2;
        Fri, 20 Jun 2025 15:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750460248; x=1751065048; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jpO5DPyG070PpTFJJBl5nUxzHXHerB0PtgjlVu/hKhw=;
        b=GrrXAa5IyibpSK2PvCd4W/sgZpLQsUMQsjTNuMs+9Mofg5V/mw492zLbHZzUUvL4nC
         FnEDMp77OymY7bl2wTcccx2OELfbTYER0KxcppQLOvR32XpXZY5mEpyYhpaSzE21xXP7
         ZNIBgRteR+WdGmWbAMjDv5FrlqhBToxJbb3+5yeafP7H4zVsiDmfAUDPRnhua3aTnJIZ
         RlVwL4dIn2x8jP5zSHjOz9l7j+wLd0k50NRl/Wtjg+lyidVv3frz6bDD1fxdPj+8ZJ4/
         beMVDOSc+ErJtOtU6oYEHAAjYgnYhySx7ptnnS+T1XZ/+a0QZdhz9IWMeFDzIou4pt0Z
         XsqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750460248; x=1751065048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jpO5DPyG070PpTFJJBl5nUxzHXHerB0PtgjlVu/hKhw=;
        b=pmmuNU1P7W7gz0IuVm39T1MIzp9VtxgGsBcQzxIVHHIFNr2W3d7dUwBJpNUBy8yxYW
         E5FNrTHgDSvDxDcwkWP9b24EnVzhJ7QspQ36zHiXEu/Qaj4WhuFt8V60tFK1VSKiH+2C
         QMdBWY8z8FpuevNKyB5ZiTCXFwvQ0U0zmHCatXa4LyhjzZa8EWFzcaX+rDL9DqhXxA23
         j81IHir9rUmK9U5xm5c8tuhSoWPzsFuCXuwnmfqDLQTNOcF27hNX1hOfUCvoEkXaemiG
         3bsgsTQbJLjw2HmfmsCt0bTNOfN2shZktIujmIClNEkms2xv5BLOuUZT4xLROKOTFJvT
         iCHA==
X-Forwarded-Encrypted: i=1; AJvYcCXGGGe5yby+VV3212Mo1PUY4IizQmIiGBqzVokI+NKre5WfS/zUzCLdkVzJakCbRbs2QK8guMU+9kiU@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2WQPDgreagrj5AyZ+c/WcAVcDr7mZMkCgw/8PG3UlDT+q96f4
	qDxPcL9lOirIEzgHiUB6Xcq7YS46A0wKZ43+2bClipPHVB8MHkNDhHvy+Lg2RKKZ/icZq7LvZQc
	u+GR4bX+Eia/YlDrsW7yVa71xfHtB/OTdXZMf
X-Gm-Gg: ASbGnctyV69Y0BR4Q+6qY3wvpCj70PrfLf0l1TF2HOimx9jCB51Xr7YeAWYAmiyC+v2
	jp1eaAJHYJA0swytpHLwD7ylGuDSvSXcHhfoieiroBn4+Pjg5zPus6szoXaQ/gBvSFQXGQMP9Lu
	JzIppUXg65ztMOPjWxDdB5mK303H1cDJIBPYLdhba8S+dn3reotI8NKVsdV7vOH5e8/ID58UwTH
	FaC6Q==
X-Google-Smtp-Source: AGHT+IGDEgWr6ggF5Iuy3d/T1WVstciw8+Lk0KoJhmwFKw4nDuwsvflSYbf1PZLvV9pWdbv7F2OnNTK7SkRtPghVAI4=
X-Received: by 2002:a05:620a:1a27:b0:7c5:a55b:fa6c with SMTP id
 af79cd13be357-7d3f9938fa1mr626913785a.38.1750460248323; Fri, 20 Jun 2025
 15:57:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 20 Jun 2025 17:57:17 -0500
X-Gm-Features: Ac12FXzZOrXre_lSxsQ0mEzQ6noAOSQx0LqvzzuONgoB4geC8zrwDsI3qH1BdVk
Message-ID: <CAH2r5mtz1-JLM8PEZngKOd4bwESBLU+bw8T=ap5aMmJ6LOaNiA@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pull the following changes since commit
e04c78d86a9699d136910cfc0bdcf01087e3267e:

  Linux 6.16-rc2 (2025-06-15 13:49:41 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc2-smb3-client-fixes

for you to fetch changes up to 48b3f9b3763c253cc88fc40be5513aa5e874f5c2:

  smb: minor fix to use SMB2_NTLMV2_SESSKEY_SIZE for auth_key size
(2025-06-19 14:20:47 -0500)

----------------------------------------------------------------
Ten cifs/smb3 client fixes
- Multichannel channel allocation fix for Kerberos mounts
- Two reconnect fixes
- Fix netfs_writepages crash with smbdirect/RDMA
- Directory caching fix
- Three minor cleanup fixes
- Log error when close cached dirs fails
- Fix reparse points (special file handling) for SMB1
----------------------------------------------------------------
Bharath SM (4):
      smb: fix secondary channel creation issue with kerberos by
populating hostname when adding channels
      smb: Use loff_t for directory position in cached_dirents
      smb: minor fix to use sizeof to initialize flags_string buffer
      smb: minor fix to use SMB2_NTLMV2_SESSKEY_SIZE for auth_key size

David Howells (1):
      cifs: Fix prepare_write to negotiate wsize if needed

Pali Roh=C3=A1r (2):
      cifs: Remove duplicate fattr->cf_dtype assignment from
wsl_to_fattr() function
      cifs: Add support for creating reparse points over SMB1

Paul Aurich (1):
      smb: Log an error when close_all_cached_dirs fails

Stefan Metzmacher (1):
      smb: client: fix max_sge overflow in smb_extract_folioq_to_rdma()

zhangjian (1):
      smb: client: fix first command failure during re-negotiation

 fs/smb/client/cached_dir.c |  14 ++++-
 fs/smb/client/cached_dir.h |   2 +-
 fs/smb/client/cifs_debug.c |   2 +-
 fs/smb/client/cifs_ioctl.h |   2 +-
 fs/smb/client/cifsglob.h   |  14 +++--
 fs/smb/client/cifsproto.h  |   8 +++
 fs/smb/client/cifssmb.c    | 128 +++++++++++++++++++++++++++++++++++++++++=
++
 fs/smb/client/connect.c    |   1 +
 fs/smb/client/file.c       |   8 ++-
 fs/smb/client/ioctl.c      |   2 +-
 fs/smb/client/link.c       |  13 ++---
 fs/smb/client/reparse.c    |  17 +++---
 fs/smb/client/reparse.h    |   4 +-
 fs/smb/client/sess.c       |   3 +-
 fs/smb/client/smb1ops.c    |  31 +++++++----
 fs/smb/client/smb2inode.c  |   2 +-
 fs/smb/client/smb2ops.c    |  10 ++--
 fs/smb/client/smb2proto.h  |   5 +-
 fs/smb/client/smbdirect.c  |   5 +-
 19 files changed, 215 insertions(+), 56 deletions(-)

--=20
Thanks,

Steve
