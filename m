Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2EC376;
	Thu, 31 Jul 2025 19:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753990484; cv=none; b=n4W9G1pB3z90Tk7O3TXcCP8l7BeOn/LDRs5fVyuqFwXWZUap7F0pYMfOTN8d9+92R1cw/LQuddLpYpZz5Sb7X+8kOe90tFkbCa1Z4hF+T8hj52c4JWBEEEAoiuXb4hyuIRRvNkotxByJillYZ7pVs69bb0bC5WtsQ2lTkJFlz+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753990484; c=relaxed/simple;
	bh=i+BQ+iEbI9xjS6D26lIshdxfenGZ4mFsWTfJKfCVlk8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=bPLGD5AjmfvK203SuZ3HiGJAL3G6Fn8XptaWlSWS5523boeAXnFBG9TxBxUb6yviHVdY3vibeTcLW5KJkobtz5gRXCfLPvDPVimtjUb/pq5Plj0ReaaQdBUF7zv09BAoXGkz9m+cVqQ0FEKkYs9Hobn0NfbvFm56mt21U7xAQZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DWxN4lhq; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DWxN4lhq"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7e169ac6009so18712685a.0;
        Thu, 31 Jul 2025 12:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753990481; x=1754595281; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cxgx3kKeNhUTqZY6/YQFNW9kbIWVWsFZ0RRPBsNGl9k=;
        b=DWxN4lhq35KifgffHBtep60vKtrIq3QSfJzxvVlQFw0NFxzxWX0I4kvNhxqxUbtt33
         Dn14Pt3UioRfSh6BQIhvahcCplSnwXXFRd8FupPoDz+jUzCZQpUMLnMZ9fjq/ILwcrGS
         fN24iKNMiCRm9/j3FYRyH34dBHzIwF6/jEH+pYHCjOUQrWApHvV/iX+EtEEbH+gNFauX
         V7JoO3Key1ZQcvny6oAvv2l3D3FY0CgjhkxugC4Ls3qpAQNLhULXuCm0OwWdzyf96cvN
         l6XevBFbXhhmAbU+NILv/eiCxeUR4ON3rZiwc03bj7R5eGv8B1hOQI+syyVzB1dfQVwb
         H86w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753990481; x=1754595281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cxgx3kKeNhUTqZY6/YQFNW9kbIWVWsFZ0RRPBsNGl9k=;
        b=Mz7i2Sx/U+gu0u4FqHm+PujJDab14bdWpeXV9Lhzw1txMDBFjAATwGoyY6/WzuhIFN
         3CyuToUL8HNeMDNNx7Cp5XIK88MCcGCYzh1kKd5VGU7EwKPkdOube4GEzsJK4fK6OsTY
         NNMzsFPdjmGy6Jq1rRM1bujt5irmrKANA41j5RFt8wecZMrTw8ey2ii0g7zY06KG3qE1
         afVB60Bj8ZybFsabpIymaqSMhdpJqVVYghbIS4Pte4G+fyp9LkFsC40Z1psvIdyo/qtE
         WSkj6QoFhgZKsxPHZJI/T3Y8l2lxpKrTsCLTycGD33j5oT23tFXr0PYHrR+7TYmaqPDx
         dM7Q==
X-Forwarded-Encrypted: i=1; AJvYcCX+pwBiigfP84IS1FaUqfYXAtTnpa00GwUL7V5BkSzA3OoqVKWj44Dj4DhmyRVxVhC/pM9eNOYAMwyC@vger.kernel.org
X-Gm-Message-State: AOJu0Yws3O/DG4JTQE1jOUBcYcz4jlPkW5d21yqoVyc6wIf3txQaiCWI
	HFbqRVgmtmhJnpSTbsUrZ58EyB6dB1wtNHPOQEGjIYV1XQeekh+xfdFUSKOo4iUsEsL/pgmXOc4
	pkffBhgxAc5HrhDk4DHGXG4TFqSU0m+suTGeehPE=
X-Gm-Gg: ASbGncvJqz7rWGMers5kGpQue/NqkRlMDntC+mtbUdOMj9qcpXLyRStkcsUk4HS+UAC
	YgB7r5PdrSFxxBbtRvXiZJB/ZcarmZUzgUy0Kx/dhW7hM8jw7ig9n9VqIsnx5nfc+I44zyQZT8R
	6G4bqgmLzFMxbfXiobYF00Jas1P25WnHNb/hq2xs+E/4UlRRosJv9rbKeLrrdu58596RA22FS2F
	OMQgBYDuuuHjyxpTv5et3GglY68peY7jWEExK6MxgLowx5cq/aW
X-Google-Smtp-Source: AGHT+IH9v2IuWk5DZOL3+Fs2v/iMD/EcrSjA6S76Nc2IGBpP7oMGPbrVMDQA9lT1x6NL3Owyof/jY+v2AhdAk8z1jeY=
X-Received: by 2002:ad4:5c88:0:b0:707:5ccb:6c4 with SMTP id
 6a1803df08f44-7076758a988mr97708446d6.49.1753990480473; Thu, 31 Jul 2025
 12:34:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 31 Jul 2025 14:34:27 -0500
X-Gm-Features: Ac12FXwohEdJzrj2SAmqTnsxaMUkyNtMnJxzf3wgKFSgtK9BeVDvcxZAp_hI61s
Message-ID: <CAH2r5ms8tJChqqKxcfZSGsZ9NbDpx-t2cRjfwSD7yxo6JHxnbQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pull the following changes since commit
038d61fd642278bab63ee8ef722c50d10ab01e8f:

  Linux 6.16 (2025-07-27 14:26:38 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.17-rc-part1-smb3-client-=
fixes

for you to fetch changes up to 844e5c0eb1767d5f971b035f81203f939d8219d4:

  smb3 client: add way to show directory leases for improved debugging
(2025-07-31 09:42:54 -0500)

----------------------------------------------------------------
16 smb3/cifs client fixes
- Fix network namespace refcount leak
- Multichannel reconnect fix
- Perf improvement to not do unneeded EA query on native symlinks
- Performance improvement for directory leases to allow extending
lease for actively queried directories
- Improve debugging of directory leases by adding pseudofile to show them
- Five minor mount cleanup patches
- Minor directory lease cleanup patch
- Allow creating special files via reparse points over SMB1
- Two minor improvements to FindFirst over SMB1
- Two NTLMSSP session setup fixes

----------------------------------------------------------------
Bharath SM (1):
      smb: change return type of cached_dir_lease_break() to bool

Pali Roh=C3=A1r (4):
      cifs: Fix calling CIFSFindFirst() for root path without msearch
      cifs: Optimize CIFSFindFirst() response when not searching
      cifs: Do not query WSL EAs for native SMB symlink
      cifs: Add support for creating reparse points over SMB1

Paulo Alcantara (7):
      smb: client: allow parsing zero-length AV pairs
      smb: client: fix session setup against servers that require SPN
      smb: client: get rid of kstrdup() when parsing user mount option
      smb: client: get rid of kstrdup() when parsing pass mount option
      smb: client: get rid of kstrdup() when parsing pass2 mount option
      smb: client: get rid of kstrdup() when parsing domain mount option
      smb: client: get rid of kstrdup() when parsing iocharset mount option

Shyam Prasad N (2):
      cifs: reset iface weights when we cannot find a candidate
      cifs: add new field to track the last access time of cfid

Steve French (1):
      smb3 client: add way to show directory leases for improved debugging

Wang Zhaolong (1):
      smb: client: fix netns refcount leak after net_passive changes

 fs/smb/client/cached_dir.c  |   8 ++-
 fs/smb/client/cached_dir.h  |   4 +-
 fs/smb/client/cifs_debug.c  |  53 ++++++++++++++++++
 fs/smb/client/cifsencrypt.c |  83 +++++++++++++++++++++-------
 fs/smb/client/cifsglob.h    |  14 +++--
 fs/smb/client/cifsproto.h   |   8 +++
 fs/smb/client/cifssmb.c     | 140
++++++++++++++++++++++++++++++++++++++++++++++-
 fs/smb/client/connect.c     |   9 +--
 fs/smb/client/fs_context.c  |  32 ++---------
 fs/smb/client/link.c        |  13 ++---
 fs/smb/client/reparse.c     |  16 ++++--
 fs/smb/client/reparse.h     |   4 +-
 fs/smb/client/sess.c        |   9 +++
 fs/smb/client/smb1ops.c     |  31 +++++++----
 fs/smb/client/smb2inode.c   |   9 +--
 fs/smb/client/smb2ops.c     |  10 ++--
 fs/smb/client/smb2proto.h   |   5 +-
 17 files changed, 343 insertions(+), 105 deletions(-)

--=20
Thanks,

Steve
