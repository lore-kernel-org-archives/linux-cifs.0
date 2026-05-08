Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC2E3D88E7
	for <linux-cifs@vger.kernel.org>; Fri,  8 May 2026 17:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778259956; cv=pass; b=SXeU255OpnpaVLUnscVSDf03N29IBXTbfQf1omKfSOZ/XJP545tx9/T39qq5E9zGb963GgfTHL7rU8OCazpw9IBjwPAqmdy2CWbN8Yw5wV9zHUIftTGzTXH1Se1JuZa9K7kmdlyzkGN+sA89B1u+mR8knjAQPKsPxYNRYN+WPeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778259956; c=relaxed/simple;
	bh=dfIp0LQRh2UCGWN/hJmgh8ibRfgnEyeX9Lkx/QxQfTI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=UlyAOFyEGgrPN9zJhYbVkC+8C3z4tSuSLj+fWonZsLwCfn0D0Q7Q16HEUJzv4COKl1LJA+8Wdt7kKWrfKUcK0YyBz0xDzyrFX0czLpk1ef0peSV8jrNaIh/ijl6p7U1uLyll3WM7EklKE/bMEI9Yy+Xovs/oBjqf49QD5OtQuJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E475cqDd; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E475cqDd"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-65c6a2158d3so1604863d50.3
        for <linux-cifs@vger.kernel.org>; Fri, 08 May 2026 10:05:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778259954; cv=none;
        d=google.com; s=arc-20240605;
        b=g16aFkIQ87E2ZsxML0rsgwBjaFKM4WG3zOCNz2qjbQ3POjrwGTMnsUf/+3ExWNewlY
         YRNYIvGMTo8CO3O3IHnWUpBn0b58ckiIu0mUsnwNCxjFdB+d/Ly0SXOxvlSlaEPHBuw9
         shWsqsvhZWWzbN+fpPiDBisfu1yaWgHXUjHbcuHwIZ+LRQKbWbySXjaFtdhGjRZkSN5r
         eW+ATh7jJu81JGJmLADorsyU3xnv32s+hm0LWk2VfGGffeD1bHBJ/oAsiy/ZW1izQytK
         j5va7xKnGjOwHvu2f/ubLQh6xKD9pFkh49Qi4oEMs5ucUJsOdR75O1BciguX13KdzXO0
         Uhsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=gZd86MkHJefRFGSbIb9rgXR/bDmHvyHfi77iZUnuLYU=;
        fh=pRoctZrcQoUUxfmHPFHNy5zbGM7GJI/CoOPk/rzIeWA=;
        b=LcaLap/jyngO64U+2+k/CwoEQbEVvoj/J5xkI2XZuz9bbiyAeRH4aYwqtny/McybsT
         JzorKbtk7iAvcBXKo59jFTAu5hGcxMg22ee32goTKBwVkyHn49azyLdHgZAM2kT6lk9s
         hR5EBKGV+hIe9uE3ON7z4jlNHL1NgdoSWKteeyelPL1nAdBckmk1nHUXmwc5spiN3C6k
         kG/P/elwPkMLA0reKF4FaZzhJLp3sgji1ZIpjwDAJDLZnNej4aTfRpvDPale0rLaiZDo
         Etwa4dHT6qaW1Zn2sP6xoO0/f+6WOqbzPUgQRoSMxGCeTWxTh8od+biLN9WISXKHabqJ
         u/3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778259954; x=1778864754; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gZd86MkHJefRFGSbIb9rgXR/bDmHvyHfi77iZUnuLYU=;
        b=E475cqDd86AE8Y36lIablV4NI35xSxWC1PNOHgHnlmgek71o2izzq3xNAvn4BqPPNu
         vfST/zpL1shFBKAI1Yz9wFA7t/dzW34OfTeYAVYUzxLMtMz7L6p1ONzg/LJ4xRQb/O4F
         QsWo5/bFoAkeSGCKAZln6KWGYGi3M2cdgmF8qtP2VSfYvM2sZVGJntE3l69acQbciXjz
         XZsSC8lBKdAtBCmhg/C8tkiFtxQiAX/0uaDfP/SBFGVjFZTj580XQS8bmCjao+GNHGoZ
         PFcae2PGdfPV3e4EbviLev/hU7C79mt7GxL8Mo0GJTyZVbJ+o2ruk2RH9KE23ObJFCXp
         5ZvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778259954; x=1778864754;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gZd86MkHJefRFGSbIb9rgXR/bDmHvyHfi77iZUnuLYU=;
        b=rIUObxkaDK8PZrAfVufa/eA+FGDOJ3BejnLJfzjvLeil3fxb2rf6t7IZL4yyUJmrU8
         wuMA1IrLPU9FZOBrgqe2TVkgRrsExxK1m5N5yz5p+WsQs9JUOU546FuU1vtpPnub1L8D
         Cf+4YcOE9+wcf+mYHzbx5gZS+UhL5Qh/lr18ppLJP9/AQ6kkHfZk456X33kqo+mQb9nT
         ER9yi4HCTpi8LrMqDjswsFPD3UCbVeYEmd0QqQhqtG17lgD1t0RbPgraT3xtyJcPAWga
         WpsH0JCJuC0Zc1sl+FC9z2WJ7uAaI0tsYidOxLDOvJYV8gx+vWr5Sx0mj8atkmTd6La5
         0VsQ==
X-Forwarded-Encrypted: i=1; AFNElJ85C5RSBuXzwbDahpfxvaYrhg4odBZuUreAkaqV6vLChxLIf+5V5ZdR/BawZeAp7jrV29wp+qOKtzS5@vger.kernel.org
X-Gm-Message-State: AOJu0YxTuro7iXj2PWt2LeWurLKQWXVPyYVuyAcMf5A1mfksGmRDtbpv
	Fdqqf9Qu1KclyIJ+QwsiJHPqCIcRb3RjIV+yRmhlXGrxPJPwzBEaifSjCrW1amdMFFOh6pkKz7b
	EZzchJux6MpPbeHTDQ8d0ZD+bCthUc1I=
X-Gm-Gg: Acq92OEkjN3y0sR6BmNHWvpptdsR6OwhZlE1JAmu3py5psi5SSVZSoak7CH2CdIIaYo
	fDvXLv4aqAUWFMsNsv6lHeRGqNH8Iz5X/mt3ytY3VeeqZwZ0wZw8fp2NfKOjK34+PrOCrTfiCTi
	nH9QK24D5PzfBpXsaFRHxEu+6cuEPih9+LK209tEzE4uOpXHJ1Kv2U0xOE1lVj1vsMQyiRQj5KI
	gRK+uTyGJcmJtMWy8O3PU1FhBorqr0ZTyLwa12clTpvbQsm7uz9x3ZPWWD3B34xsFXvdOp8Jva8
	9m4BwUkzlGBLQKWbc7lpM1zQMrS1iQMo1NuX6XeE0xRi6KXGgJhdpbWOHsayWkrHdTSDmmqGMDQ
	2ACM531rh89tKYusJZucnqOUpYJ+aALnUGxMaT9QZBqqFdVzJFA5SxrW9xTo+kct/ANgz/T+8W9
	zZ5i6kQz0ke8nmW8I3PIZqZrmawqXDVpMy
X-Received: by 2002:a05:690e:4397:b0:65c:2ac8:ec3d with SMTP id
 956f58d0204a3-65c798f901bmr8869482d50.21.1778259953641; Fri, 08 May 2026
 10:05:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 8 May 2026 12:05:41 -0500
X-Gm-Features: AVHnY4LVjQvpefvoI4Yk3kVqjF-5aoZOSVH261ef8XF6BwiPwc-u8VtaOZXdTTs
Message-ID: <CAH2r5mtFDoX_ytAJty_t-OwuG0DacO2D-NOL3RHNFe+SdmnJpw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
7fd2df204f342fc17d1a0bfcd474b24232fb0f32:

  Linux 7.1-rc2 (2026-05-03 14:21:25 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc3-smb3-client-fixes

for you to fetch changes up to f98b48151cc502ada59d9778f0112d21f2586ca3:

  smb: client: validate dacloffset before building DACL pointers
(2026-05-07 14:09:36 -0500)

----------------------------------------------------------------
Seven client fixes
- Fix for two ACL issues (security fix to validate dacloffset better
and chmod fix)
- Fix two out of bounds read (in check_wsl_eas and smb2_check_msg for symlinks)
- Two Kerberos fixes including an important one when AES-256 encryption chosen
- Fix open_cached_dir problem when directory leases disabled
----------------------------------------------------------------
Bjoern Doebel (1):
      smb: client: use kzalloc to zero-initialize security descriptor buffer

Michael Bommarito (1):
      smb: client: validate dacloffset before building DACL pointers

Piyush Sachdeva (2):
      smb: client: Use FullSessionKey for AES-256 encryption key derivation
      smb: client: Zero-pad short GSS session keys per MS-SMB2

Shyam Prasad N (1):
      cifs: abort open_cached_dir if we don't request leases

Zisen Ye (2):
      smb/client: fix out-of-bounds read in symlink_data()
      smb/client: fix out-of-bounds read in smb2_compound_op()

 fs/smb/client/cached_dir.c    |  8 ++++++++
 fs/smb/client/cifsacl.c       | 37 +++++++++++++++++++++++++++++++++----
 fs/smb/client/ioctl.c         |  2 +-
 fs/smb/client/smb2inode.c     | 12 ++++++++----
 fs/smb/client/smb2misc.c      |  3 ++-
 fs/smb/client/smb2pdu.c       | 23 ++++++++++++++++++-----
 fs/smb/client/smb2transport.c | 35 ++++++++++++++++++++++++++---------
 7 files changed, 96 insertions(+), 24 deletions(-)

--
Thanks,

Steve
