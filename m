Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A641A3AAD;
	Wed, 25 Sep 2024 23:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727306839; cv=none; b=sNCASJKgHf9Ts9chI1Sy541AEG9nRIqSYhK/HFgtzV9Amycls5EifdhX1g3W4Z8/hkTeIXoVQgDa2i/FDQEEm9WzfkKSmiBVw7yADNonvuwkqfr28PIuFBG2IMeiah/n9OdpTp4FcvRQq0rMCQxL2DS7I/vIgeJlS5SV8ayn46E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727306839; c=relaxed/simple;
	bh=+oSQJARn7CnqaHA45rq5FNWO2eKBb+fjoib3mJZ9A4Y=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=qqmMATvJ8CFtourrc9OKtkMPE6WWGuomZRWlB9mHdqinMOTBziKzmDOJmSpDiVpFM1Dkc/Zf61tIDKIaUs7wrB92yZXxIFEXs+/cJGovpCdx/+jTyVXFv2PJ01yXNOtX5JFZ/pwpp/lUoXG3+boHLXSe/yBUoLUPoFRplj93vOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sv1/Tlyc; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sv1/Tlyc"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5365c512b00so463915e87.3;
        Wed, 25 Sep 2024 16:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727306835; x=1727911635; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Wv/SNXw7MWCRNo1r0h+l0FniLvfMLhnuSLmytnaocCI=;
        b=Sv1/TlycHWuj+j3mbC51r6+zoNBkLMvHzKuYnU2CKqh69AyURx4mMDfbT8UsWQTOKx
         xWvcOtl3uszIyvjHXS5qaFq/GEzzw0P+9mO4e+mOm1MugltESm+IVjA/OsorGXWgc9jV
         go6rkdS7eu47GIy8bbTOr6nd+PNUxyTJXbELC9vn2nZlej+LTVtk77SrxwpLAF93Kz7q
         nyLSknC2j4PGkGNNY1R20lYmW+ennnjGA3NZGHNL0ytSuAzNGcGDuEIP7x2GqDYUqDUF
         tJzrELviF+X8tN1LZHfAYQuIsxeqqKbVDPk0Qq26MZLR4qFGQvw8ZUWEy5n8qDRnLDur
         VvfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727306835; x=1727911635;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wv/SNXw7MWCRNo1r0h+l0FniLvfMLhnuSLmytnaocCI=;
        b=llP+Sw6V+C9nw/TEFSfb5oKdVfHKqlKvGhgYjF2krgSi/D42kq5T6DsY0SFdk5WUdd
         aKj06fXNugVG/zC2WdZL6N1oXFb0ouhGrygeepn43+9NxFlBRt3xfkLCQ9qZgioo6UPX
         J1ot4qFzBlhyoRervtq7RaIGVqlZ5wST9l3d+eU4Y+7relx1IioNB4jDIDwXYRcboGpL
         9XpAMK/cdKb5FfU1lwzQHXBoSMChx73WB4DnReIuK3ciyMvuTHbjMf2+L/T28S7hrEoF
         YxoS6DrQpoWJcHm2/cLlGoIVB/fY0+AgnAjgnd5FDQwmXPVD3WsjcbH+CM2Y0zAyjLoc
         jKuA==
X-Forwarded-Encrypted: i=1; AJvYcCW1NHudF+82SGiFtg0N/iTQeriHQ0OvDRbgnCm/7r/0FoZV+IlBvJ+2o3xUXu0EDE7kG/vRobjijaRY@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4fdQn3CBBchrPvxSSZ53onhmDbQ77pXd0g8HNHe4DzEZeNwet
	MKT38Pel6Ic4QM4t6N7v1irNiCXmkYx2Kiu7r5icPqBBXYVlgavrPsu/PmI066A8VRz2pDSkdrQ
	Of1dTw0pZvTlUPVywTeYx/r6fCk/ujAWIkBA=
X-Google-Smtp-Source: AGHT+IHFWgL7UWymaI7bktKViWlH4MJALjjkoP5NSaAnGk9yrXlFvg3QDijDxheDFORRX5bubG/dXpPeWRYrbkz8j6I=
X-Received: by 2002:a05:6512:b83:b0:536:55a3:70ad with SMTP id
 2adb3069b0e04-53877538a51mr2819222e87.22.1727306835189; Wed, 25 Sep 2024
 16:27:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 25 Sep 2024 18:27:03 -0500
Message-ID: <CAH2r5muJnL-QRMFV=eWdY18CtCZEWijEuU_kO8RWHP0Qv_fdOw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
4e0373f1f920811a67fef0c3383f1ad602b3845e:

  Merge tag 'v6.12-rc-smb3-client-fixes-part1' of
git://git.samba.org/sfrench/cifs-2.6 (2024-09-19 06:53:40 +0200)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.12-rc-smb3-client-fixes-part2

for you to fetch changes up to 665db14d0712ac27f6a0081510bd811efb3faa3c:

  netfs, cifs: Fix mtime/ctime update for mmapped writes (2024-09-24
21:57:00 -0500)

----------------------------------------------------------------
12 smb3 client fixes, most from the recent SMB3.1.1 test event, and
also an important netfs fix for cifs mtime write regression
- fix mode reported by stat of readonly directories and files
- four DFS (global namespace) related fixes
- two fixes for special file support via reparse points
- mount improvement and reconnect fix
- fix for noisy log message on umount
- two netfs related fixes, one fixing a recent regression, and add new
write tracepoint
----------------------------------------------------------------
David Howells (3):
      cifs: Make the write_{enter,done,err} tracepoints display netfs info
      cifs: Fix reversion of the iter in cifs_readv_receive().
      netfs, cifs: Fix mtime/ctime update for mmapped writes

Paulo Alcantara (8):
      smb: client: avoid unnecessary reconnects when refreshing referrals
      smb: client: improve purging of cached referrals
      smb: client: fix DFS interlink failover
      smb: client: fix DFS failover in multiuser mounts
      smb: client: propagate error from cifs_construct_tcon()
      smb: client: set correct device number on nfs reparse points
      smb: client: fix parsing of device numbers
      smb: client: print failed session logoffs with FYI

Steve French (2):
      smb3: fix incorrect mode displayed for read-only files
      cifs: update internal version number

 fs/netfs/buffered_write.c  |   1 +
 fs/smb/client/cifsfs.h     |   4 +-
 fs/smb/client/cifsglob.h   |   3 +
 fs/smb/client/cifsproto.h  |  12 +--
 fs/smb/client/connect.c    |  66 ++++++++--------
 fs/smb/client/dfs.c        |  73 +++++++++---------
 fs/smb/client/dfs.h        |  42 ++++++----
 fs/smb/client/dfs_cache.c  | 218
+++++++++++++++++++++++++++++++---------------------
 fs/smb/client/fs_context.h |   1 +
 fs/smb/client/inode.c      |  19 +++--
 fs/smb/client/misc.c       |   6 +-
 fs/smb/client/namespace.c  |   2 +-
 fs/smb/client/reparse.c    |  10 +--
 fs/smb/client/reparse.h    |   9 +--
 fs/smb/client/smb2ops.c    |   9 ++-
 fs/smb/client/smb2pdu.c    |  22 ++++--
 fs/smb/client/trace.h      |   6 +-
 fs/smb/client/transport.c  |   3 -
 18 files changed, 282 insertions(+), 224 deletions(-)

-- 
Thanks,

Steve
