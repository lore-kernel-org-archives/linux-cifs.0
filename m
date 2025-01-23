Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6E7155A34;
	Thu, 23 Jan 2025 21:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737667429; cv=none; b=sOBb1a8y2l4VPRJWfsqc9X9mAeC5ZVrFPAztSie21hsXcPCoIVbLaqR1wm6hnl8T2RkvOdNKI9RTgtux7YE3Ac7sgz1/NqzHO3e5sR2kO6/ftTaB0TrVtmQRlJw9xX7rB2pTAX4eO4F4l3k00gLUWIk+J0FFvyZzqsSo8ZPX5cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737667429; c=relaxed/simple;
	bh=EBhdbFMcYOa8JwRj8nmCaSGzpVAmzFp4WnIh690oayA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=clffjsj90cUZpIWr7C9oQnfvGIKYnW80K+piJncJ1BcmMwm9fHCkMVeF+L1max9xff0xLxkCReGuWPoTO0nK0Ay7CHbg2DY7CwpY/6pL1U+xoZJSKS9ji1cJhE/VJEcb7Zu4OoYHEjqOVghBT6kGCO8KDpfgR0AUww4hkVFtfBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pf+A04VR; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pf+A04VR"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5401bd6ccadso1534153e87.2;
        Thu, 23 Jan 2025 13:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737667425; x=1738272225; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Xmb8r210IE/k4POMk+HneOpNybfHZ9f5EMcY4NYKKf4=;
        b=Pf+A04VRQ4M71dd4/ugfmnyUMRtUnYwiDF328DhKkPHG43xHOtYkzhEWQYTtHLVLBO
         k5kuH4abzeL2qdI/7KmMICQF9NBZA0bW9xR6LddmNNZbXb55ylnwdZ77y1ZjclVcHgoS
         h7WeTnN2IwNbDK41vjua4iNnCcMMj8BW+AXDavUrHxHJuraXNFI8FaMqRKvKtiS7JT/I
         OAFOR+yVmd8nlON2W3zkp5bDnpGQoRlq9FcBCqW6aA85Q5QCn5gvWK6rHRn56HUHfFMU
         fBCBZctzoF5XRpd29f+wcZG52+CLEexBMlwMJEFw7M6UhlptilIoNxrQ3nWMJAGsfCea
         Xc2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737667425; x=1738272225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xmb8r210IE/k4POMk+HneOpNybfHZ9f5EMcY4NYKKf4=;
        b=qLBY/iGjiJZmcADieQNDWLIvzbB62PVAZH/zXD25LC+B45URTs6uWrgO5e7ZBAfGrw
         W5xDPMO8dSmOy9WLIPa3JwhP7mZBNl5lyYyVkuBOie/ZXypz+JTB6UrleG0d6joCaE33
         wsKC2HoQYxrQT5ULC3UiIPbpmhrFCtfDT7MxH2xKypoQ4V6JAQUa/W8YOfFee6Nm0RzU
         ge7JzugzIlF1XK9x6/lA9zhthyQcrNcquekNoIZfUNYQNsURKxLvp08bA2fBhpGJl1i1
         4yqeaWn3UxPvjRUnV4iP48TY1E4roKwO+qlXsQocl0z8X07qgOY5vP4RNN+9WO6wK6ZQ
         VZfA==
X-Forwarded-Encrypted: i=1; AJvYcCU2MNroMXBq6mdfPwG/O6jT0mBBzgYmItdUi3npiArZw/R9D4gC5bTEzlLZ3J6Zk1ow2jyAyYiYhbgkrio=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2KXLCJzNCJ8GP2wYe/poAvsOjygscBqI66mL0dBvMIhWgE45z
	BLdLEZ4XdfiwKE7YYhBE8q7GDYHDnu3IahFTITDhakWRznE2SsGGotj3ohtg0rKcTShkFZ3UkM8
	KuuBPdoeuSr5YpzVsuNkR+pIccHWIYQ==
X-Gm-Gg: ASbGnctoyD8Ky47omL3rl4ggC3pgn0T07ZE1pttXBbXNEqb0pXx1IwaMQ5+Keu/leqo
	tVrsWbFBV03A0eN/ET0fJjquxp/TZz17GUb+GO2YGoMqM+9fxIHndW/FrF0hIWA==
X-Google-Smtp-Source: AGHT+IFUxcPrA/e/3ZxblryCHxBmbkpY3Rdo8xMk0q6PZZ/5ygASfASbMn5XP3/im15hmGFc6/jDw6BnTPKSEe98rfo=
X-Received: by 2002:ac2:5471:0:b0:542:2192:3eb6 with SMTP id
 2adb3069b0e04-5439c2875ecmr7854096e87.52.1737667425060; Thu, 23 Jan 2025
 13:23:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 23 Jan 2025 15:23:33 -0600
X-Gm-Features: AWEUYZnYTFUMDCyKFL-pYMM6ZWO5Q34I8hyRlqvux6IgOKH6EdKtIIHwMd4CdcE
Message-ID: <CAH2r5msZ8nseF-kZMsbi9tc6rVr9ug=11AVtJ-ieJqY0qNObUQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pull the following changes since commit
ffd294d346d185b70e28b1a28abe367bbfe53c04:

  Linux 6.13 (2025-01-19 15:51:45 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc-smb3-client-fixes-=
part

for you to fetch changes up to 3681c74d342db75b0d641ba60de27bf73e16e66b:

  smb: client: handle lack of EA support in smb2_query_path_info()
(2025-01-22 20:13:49 -0600)

----------------------------------------------------------------
twenty three smb3 client fixes, many DFS related
- Fix oops in DebugData when link speed 0
- Two reparse point fixes
- Ten DFS (global namespace) fixes
- Symlink error handling fix
- Two SMB1 fixes
- Four cleanup fixes
- Improved debugging of status codes
- Fix incorrect output of tracepoints for compounding, and add missing
compounding tracepoint

----------------------------------------------------------------
Liang Jie (1):
      smb: client: correctly handle ErrorContextData as a flexible array

Pali Roh=C3=A1r (8):
      cifs: Use cifs_autodisable_serverino() for disabling
CIFS_MOUNT_SERVER_INUM in readdir.c
      cifs: Fix endian types in struct rfc1002_session_packet
      cifs: Add missing NT_STATUS_* codes from nterr.h to nterr.c
      cifs: Fix printing Status code into dmesg
      cifs: Remove declaration of dead CIFSSMBQuerySymLink function
      cifs: Do not attempt to call CIFSSMBRenameOpenFile() without
CAP_INFOLEVEL_PASSTHRU
      cifs: Do not attempt to call CIFSGetSrvInodeNumber() without
CAP_INFOLEVEL_PASSTHRU
      cifs: Remove duplicate struct reparse_symlink_data and
SYMLINK_FLAG_RELATIVE

Paulo Alcantara (12):
      smb: client: introduce av_for_each_entry() helper
      smb: client: parse av pair type 4 in CHALLENGE_MESSAGE
      smb: client: fix DFS mount against old servers with NTLMSSP
      smb: client: parse DNS domain name from domain=3D option
      smb: client: provide dns_resolve_{unc,name} helpers
      smb: client: optimize referral walk on failed link targets
      smb: client: fix return value of parse_dfs_referrals()
      smb: client: don't retry DFS targets on server shutdown
      smb: client: fix oops due to unset link speed
      smb: client: get rid of TCP_Server_Info::refpath_lock
      smb: client: don't check for @leaf_fullpath in match_server()
      smb: client: handle lack of EA support in smb2_query_path_info()

Ruben Devos (1):
      smb: client: fix order of arguments of tracepoints

Steve French (1):
      smb3: add missing tracepoint for querying wsl EAs

 fs/smb/client/cifsencrypt.c | 162 +++++++++++++++++------------------
 fs/smb/client/cifsglob.h    |  35 +++++---
 fs/smb/client/cifspdu.h     |  18 +---
 fs/smb/client/cifsproto.h   |   5 +-
 fs/smb/client/connect.c     | 133 +++++++++++------------------
 fs/smb/client/dfs.c         |  80 ++++++++----------
 fs/smb/client/dfs.h         |  44 +++++++---
 fs/smb/client/dfs_cache.c   |  20 ++---
 fs/smb/client/dir.c         |   6 +-
 fs/smb/client/dns_resolve.c | 108 ++++++++++++-----------
 fs/smb/client/dns_resolve.h |  23 ++++-
 fs/smb/client/fs_context.c  |   4 +
 fs/smb/client/fs_context.h  |   1 +
 fs/smb/client/inode.c       |   7 ++
 fs/smb/client/misc.c        |  29 +++----
 fs/smb/client/netmisc.c     |   4 +-
 fs/smb/client/nterr.c       |   8 ++
 fs/smb/client/readdir.c     |   2 +-
 fs/smb/client/rfc1002pdu.h  |   6 +-
 fs/smb/client/smb1ops.c     |   6 ++
 fs/smb/client/smb2file.c    |   4 +-
 fs/smb/client/smb2inode.c   | 202 +++++++++++++++++++++++++++-------------=
----
 fs/smb/client/smb2ops.c     |   9 +-
 fs/smb/client/smb2pdu.h     |   2 +-
 fs/smb/client/trace.h       |   1 +
 25 files changed, 483 insertions(+), 436 deletions(-)

--
Thanks,

Steve
