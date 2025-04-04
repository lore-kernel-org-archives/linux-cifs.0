Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D127E214230;
	Fri,  4 Apr 2025 22:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743804662; cv=none; b=GcXRO3pZuhUzjB2LTI79bCNfsO4A5u+wcRDOzJVAaXd2CG+8FZZIvegpapTUvWphQ0OmdEFccIEB8AdvXFdgnQez+nfzUXnqe1U5JNmPzDJg4d5Gyp6qzmCguvP9GSGkMfMZFNncqvpVnZW7xFUUsgpIPRQs+ArT/RHeC1z0i1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743804662; c=relaxed/simple;
	bh=DRvNs395019k9at+wq1UdwuZ/ermUan6qb+p6CjMJT4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Zl5MJhJa3oPZl8YgDhvrf6CWJW3oM5BJ5XlKnbqC3BFGhSdisFT9CrEHl9Ktj457YkQmdO1FHh6a3f5xvwQkpE84Kd5xwL8a5vObSBt1TEaCwPiAELM8uo66mAvMuqiBQvJjJNUTirFJ810zVJXKRPBPz6oq1py4Ve4AbPIuuPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iWWZyH4d; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iWWZyH4d"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-549967c72bcso2910511e87.3;
        Fri, 04 Apr 2025 15:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743804659; x=1744409459; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s+8+ZL21ft+usZZAcQLDzLsmkJtvMklhHGryk2hKbUw=;
        b=iWWZyH4d1hEjzNjSCDrscclgOFqrzy11P7VMYgYQxU2W8Rc4zyatoMihcYTWs8ZSZZ
         ZFpZrOHPCayCrTNdQDzu0XoKGMfgKvYh3rmHeMvv8vUJlevbhWR+0/3jPndRU4k1wtvs
         ixsxBTJfGSGQumwyyuTg2svrUJSJC86LQs4SoSJvdv4mF+Basrufhi4vrUfzP/Ev/qQn
         l48XfaSy9AzGLZlx2YrvZAebXf/bkxODfMy6NHM9C/J+ET8HGxjkAYIvN8mQG7Dkkr2v
         o56FETemZXyr9rFlFiU08T5EyHOyinB7ziAki2MDWcj+1yMUsf+MLF/yEgrqipZ1QHCH
         pWmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743804659; x=1744409459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s+8+ZL21ft+usZZAcQLDzLsmkJtvMklhHGryk2hKbUw=;
        b=GyUAZCwBSOaSEXLEciMffBW8zSGQXNfNEYs+nyDrrilJGxVV1de15PpCbZpdxMST/b
         MMkHXbpExuNPHImlyAj6kBWJjaEBeIbwN37vopifJxcLkakIO+KHBgpCkYl8W+cjN5c4
         8pfz1ILOnFSHXYUA99VUwtcYqdwQ/svPxlSpFadNcY1FIfZrR7B9aSVJT5wXY/EtityZ
         ppCgeWlCTyUAuxcDAatYXBdEr+JPC2hUZbpR3o5CohyCpEKqPDrE3ll8fwPgete90ZXx
         hFrqEFBjB2invIAnQ2cI1QItIG8BRgczrqmzHZ54gVQjRkBBbtEYn0g96B0ZJPAfmGbB
         mSAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUNRQJIMfGhkly9WZ0Zl97XHACHbhUC8ud4sBwrdyjjcmLBzi74AouB/l8GyGECHaVr9cmizrOnBcm@vger.kernel.org
X-Gm-Message-State: AOJu0YzxyDGDUrIHZWOTj0nfkewUSDI6hkTSZ9/PuV7UqYGNggX/x66U
	8dtYj9aE2zPVMaynvqXHfhvxoWbqRX5YDhtxnwd83sqlUqGrYWUu7aOh3wVXVun/iB/BHNMf+sg
	ur9Pm0cAUEMBvARrOsMQSYQ0SP7C0htmc
X-Gm-Gg: ASbGncuPTPuXWlDPNGYF7q5ojQRXhF6D1BMwfcnISfm+LEE5JvKB7102gHBt4RqxGO8
	s4i5iTangcoBpMOlbWYrlMm5WkwV/TEvGBNMQ+Owms3kMivpzSCsbCT6w1ER8VYUBV9QQKDHPt7
	teysGPDR513hw+fJmjzOqDIzJCVLLbIbeXMgEPL0oGofNp8tuMRi+I5jytLLMSbb06fl1uxOg=
X-Google-Smtp-Source: AGHT+IEcKyvZdxfOLsYYJVAm3n51tbQYHRdpfkI0gxrGdYrKLlZx9PoYsi5BtWr+NQsYscZ8hKUk7R6sTubxkcK5xCo=
X-Received: by 2002:a05:6512:3b8f:b0:549:8ed4:fb46 with SMTP id
 2adb3069b0e04-54c232f99e1mr1123963e87.26.1743804658258; Fri, 04 Apr 2025
 15:10:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 4 Apr 2025 17:10:47 -0500
X-Gm-Features: ATxdqUG9A9h5P8yJDMjwtNDD-b5hOSEyY_Lna9nU_QIa6EQ1yh-e4yaDbcbb-GY
Message-ID: <CAH2r5muz6e_n10Yia4R686nJsgqvzgpBVQ5vKk4oQe4tL-Wwqg@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pull the following changes since commit
8b175e2e189673643bf5b996335f0430faddf953:

  Merge tag '6.15-rc-part1-smb3-client-fixes' of
git://git.samba.org/sfrench/cifs-2.6 (2025-03-31 17:38:34 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc-part2-smb3-client-f=
ixes

for you to fetch changes up to 827a1bd9af9df6a4023736ff52475b2a5395d91d:

  cifs: update internal version number (2025-04-02 20:01:14 -0500)

----------------------------------------------------------------
18 smb3/cifs client fixes
- Four reconnect fixes (three for updating rsize/wsize) and also an
SMB1 reconnect fix
- Three RFC1001 fixes: fixing connections to nonstandard ports, and
negprot retries
- Fix mfsymlinks to old servers
- Make mapping of open flags for SMB1 more accurate
- Three permission fixes: adding retry on open for  write, and one for
stat to workaround unexpected access denied
- Add two new xattrs, one for retrieving SACL and one for retrieving
owner (without having to retrieve the whole ACL)
- Fix mount parm validation for echo_interval
- Two minor cleanup (including removing now unneeded cifs_truncate_page)
----------------------------------------------------------------
David Howells (1):
      cifs: Remove cifs_truncate_page() as it should be superfluous

Pali Roh=C3=A1r (11):
      cifs: Add a new xattr system.smb3_ntsd_sacl for getting or setting SA=
CLs
      cifs: Add a new xattr system.smb3_ntsd_owner for getting or setting o=
wner
      cifs: Allow to disable or force initialization of NetBIOS session
      cifs: Improve handling of NetBIOS packets
      cifs: Fix negotiate retry functionality
      cifs: Fix access_flags_to_smbopen_mode
      cifs: Fix querying and creating MF symlinks over SMB1
      cifs: Add fallback for SMB2 CREATE without FILE_READ_ATTRIBUTES
      cifs: Improve SMB2+ stat() to work also without FILE_READ_ATTRIBUTES
      cifs: Do not add FILE_READ_ATTRIBUTES when using GENERIC_READ/EXECUTE=
/ALL
      cifs: Implement is_network_name_deleted for SMB1

Roman Smirnov (2):
      cifs: fix integer overflow in match_server()
      cifs: remove unreachable code in cifs_get_tcp_session()

Steve French (1):
      cifs: update internal version number

Wang Zhaolong (3):
      smb:client: smb: client: Add reverse mapping from tcon to superblocks
      smb: client: Store original IO parameters and prevent zero IO sizes
      smb: client: Update IO sizes after reconnection

 fs/smb/client/cifs_fs_sb.h |   1 +
 fs/smb/client/cifsfs.h     |   5 +-
 fs/smb/client/cifsglob.h   |   7 +-
 fs/smb/client/cifssmb.c    |  32 ++++++--
 fs/smb/client/connect.c    | 180 ++++++++++++++++++++++++++++++++++++++---=
---
 fs/smb/client/fs_context.c |  21 +++++-
 fs/smb/client/fs_context.h |   5 ++
 fs/smb/client/inode.c      |  19 -----
 fs/smb/client/link.c       |   8 +-
 fs/smb/client/misc.c       |   2 +
 fs/smb/client/smb1ops.c    |  57 +++++++++++---
 fs/smb/client/smb2file.c   |  21 +++++-
 fs/smb/client/smb2glob.h   |   1 +
 fs/smb/client/smb2inode.c  |  67 ++++++++++++++++-
 fs/smb/client/smb2ops.c    |  32 ++++----
 fs/smb/client/smb2pdu.c    |  24 +++++-
 fs/smb/client/transport.c  |   3 +
 fs/smb/client/xattr.c      |  36 +++++++++
 fs/smb/common/smb2pdu.h    |   3 +
 19 files changed, 438 insertions(+), 86 deletions(-)

--
Thanks,

Steve
