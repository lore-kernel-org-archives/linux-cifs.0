Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0F03E16B8
	for <linux-cifs@vger.kernel.org>; Fri, 15 May 2026 18:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778870705; cv=pass; b=h7ojcltJlaMcdvrbQ91IX3Gv0zWyzaL0EnibPSL0QtD6b4Oj+6PQtAI9YAlQMz6EFqKbe0Kkf36DnLwsLXUHsynyj3iqULHXWUKB9+i/miZHCHwcFzCYR9FQlGzYMJXZNjC9KWL7kLaMe6flL/vuCUDCd5oos52/aJm2gCJ8o+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778870705; c=relaxed/simple;
	bh=JbPpao5twJzVh7e8g5jgRWw0Ql9YuDv6AhNtPt0UbVE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=keQ4abYNplz9WMD/OHO4W5HstMQ1Z1eu3Ry9AaeI5g1aHaA+giQ8b3meW2a2JxNI5dRUXtJG6SpvgFIcR3z4jG4nI7mcQY8eWsBJfQ8TK2vP4+Vy9Yejcc2Qkb+j29j6mURLXbGS7pqEqlQRuEiE0/tgbnestuD/Sh0TLxtO8sw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ilLowsKb; arc=pass smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ilLowsKb"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8bc3ef10cc4so1349056d6.1
        for <linux-cifs@vger.kernel.org>; Fri, 15 May 2026 11:44:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778870698; cv=none;
        d=google.com; s=arc-20240605;
        b=OC47re+FW9oJyWb37m4phWxNT6AwnsOZhZyAY909NtuQBAzDhl9qGOdxZdybHdgCWY
         8EDVaoToPZVFXWODxc47vPQ/m8GPvcS3VO63aRMgX2jV8JP6gxWpJG5gMRlTcFNTpAsi
         5rVmSmz1G/V0P8zCQxWLHN98O+kCRrJ38CNJtk8CneSFIntl5PfDCza81LEUvKHY1dTC
         3bad42wUz/6CxWynP3pvs4/oreh4xfNyyOmt+XJZV7fww1YIXmkFvxGxNuIymMljERtH
         L5zVCBUdESUlDsAFphv+spwuS7fXd8i6hGFY8BsZajrII7aN2obrU5MffA9/EFOkMuIp
         rVrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=BBd7Bfzp7bFCnoV1EGd0JsT766S+OudnUNiMnAS3KEE=;
        fh=Nf1mvuQ9XbZKOmPhacDz1X5aHl0t82a+aHbY+2n4zlg=;
        b=BkjjyEjqSsEIqTCr616EnOaMVhkUiZLnZ+4t+MElWSZsUJcluCC+4V6HNr9ny/VGX/
         cGRqF7AKYBioqKyu9ZWQ84dldu8W+gigoMEVM3QVC5n802WnRMrGUykC7fPxQPShvS90
         tH/VSx+F7nVE3cKyXf+drHgL49Fc2oBIcawJ3VPrmzilYe9nnt7q9xQL0duI2fPD48x0
         aCK6qoAlP1boMbdMC1rQgXzUwz9YHQnDYj5KD1XV0/LUStUPvZrZrdVSJ8Bml9kxYq75
         qfGSDKGqlc5qiVqdonp6N40i2VjtKMAp4n5eizRVQD0FXpGIP0A6OvgcSFj2i++PUwT3
         i3BQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778870698; x=1779475498; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BBd7Bfzp7bFCnoV1EGd0JsT766S+OudnUNiMnAS3KEE=;
        b=ilLowsKbZeA7B2lPZ8W6ZLwOwvGO3/2iaQLf5/0TnKmrGFMCDb1v6mq7oiwOfWWRMv
         Dx2iQv87j1fZ43sn0P+6fcrUMEzbhMjxb8ei2Xvb+Uj89eejnoTWO0S8ujdRSyBbHV7R
         DOXO9GfmMxQvhOKynCReU+ilviyihV9olCkhONnivMlb5TyC4Yb9kSu+w5sKuYEHqpRG
         93xQGpdf6mgCdR1oeeY5WzIcexovDXtSrGXVTO4QksAPWyc54iNDTM8Y5Pf+WWd+xbAT
         Ii5K1vDR3yLg6/DdPqe0/wUy3GAAuRCjqkr61bCvmecZncEaOwmWqPfjcoM2reF4CiSc
         z5Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778870698; x=1779475498;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BBd7Bfzp7bFCnoV1EGd0JsT766S+OudnUNiMnAS3KEE=;
        b=ZIdtfCTwXtrTSkzIucJW616HGT962gazTq2tlQwyUHxlwLBXHa6OElPwl7EbbFK9e0
         l7RhH2ojIrRKzJMxJIU2ZnTwR8VpYJYbVdTQT8IXE7tX5zEvSFExvuRnf/SGIhH78AwT
         CYG4hpaoi90EdK4ICRjCAB+wLRH5SJeTZHhfsXdBDI0bc7UNyKITUi6lPVg8HIOVz4s4
         0Q+WA0EV/AIOfbwFdRWce7cxD/1flt/L4z8t0L43xnT5/vIsgHCjG8Ybj+OM1rzdu/2G
         vTbhRnBAe4pT8PgSs1/+4U3ey4nqYNliToazBJXf7YSbUTajZ4W9J/vWPT9/FMs3Tx4B
         xSeA==
X-Gm-Message-State: AOJu0Yztnja/y9kie24Mhd4kKAC16/FIh/XhMzQ8iSHMyRVJlb7GrJKS
	lzsKE9ogYxefPyXl4OgicvsJpKNV5h7yb4vPgny1oZ7XD91bh+PBDawVIRgP+eI+LSW1p28c1+G
	d1FxwFmPBXzIQOvu0Iug7wbkzm1o1+eoadNbXmTY=
X-Gm-Gg: Acq92OFlCv3Xgk/9llVPfx3u8H8KyWSv5a6vjwwiICvFZXAKv8of2jKKLbsnNjKcTZq
	2O4w9ukhtkNYBJq82voUh3I3MDElvKk4tvBrul2XSIVP2qzV82fHaQ6LFColqkwwFVnDxUhS5lL
	G2AjAbO8y6NAV5VcpZpukcH4WBLeVYfqdsyqMXQQk4NtYj9x4V4hueNK55uBHBbkktnGkV8GbLe
	MqHPCGNX/fONY/rcfXzQ1D7OQ6uu4/7iCFEo4hPgyUx7EknjjZ5uWkta7PndQOV/Y4wrzHy1hmm
	WztQISY0v7ngCrFPRAnme2iPmhtVfgybbAo9lpU75kit83panA3KtRJVjVEpSTblGT1TwFBRXv+
	MUbutj7ufWqpImVF8vkeFQj11iy7MAiSuoFeb6IPp9C0Ush19HAT9wbRzHfTQkC9Dws6qcPIn+4
	DUbAXEiH0mJPrzs4DtCZV1vg==
X-Received: by 2002:a05:6214:3010:b0:8b1:f297:a54b with SMTP id
 6a1803df08f44-8ca1ecce81cmr20114016d6.18.1778870697845; Fri, 15 May 2026
 11:44:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 15 May 2026 13:44:45 -0500
X-Gm-Features: AVHnY4Ji3d31QjulfDs_JJnH7x7f9fT-X8a5O3Qz5o2IdWQK0GSbeFciWI9MsQA
Message-ID: <CAH2r5mvGAbdCXg8uJ2NrFWLT0kB1myECtq5B6ttcXqdQ-SXE7g@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
5d6919055dec134de3c40167a490f33c74c12581:

  Linux 7.1-rc3 (2026-05-10 14:08:09 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc4-smb3-client-fixes

for you to fetch changes up to c207f1d785044667f87cc8c72355e33f3981f2d6:

  smbdirect: Fix error cleanup in smbdirect_map_sges_from_iter()
(2026-05-14 13:21:00 -0500)

----------------------------------------------------------------
Five client fixes
- Fix integer overflow in read
- Fix smbdirect error cleanup
- Multichannel reconnect fix
- Add some missing defines and correct some references to protocol spec
- Fix oob symlink read
----------------------------------------------------------------
DaeMyung Kang (1):
      cifs: client: stage smb3_reconfigure() updates and restore ctx on failure

David Howells (1):
      smbdirect: Fix error cleanup in smbdirect_map_sges_from_iter()

Jeremy Erazo (1):
      smb: client: avoid integer overflow in SMB2 READ length check

Steve French (1):
      SMB3.1.1: add missing QUERY_DIR info levels

Ye Bin (1):
      smb/client: fix possible infinite loop and oob read in symlink_data()

 fs/smb/client/fs_context.c    | 161 ++++++++++++++++++++++++++++--------------
 fs/smb/client/smb2file.c      |   3 +
 fs/smb/client/smb2ops.c       |   4 +-
 fs/smb/client/transport.c     |  15 ++--
 fs/smb/common/fscc.h          |   4 +-
 fs/smb/common/smb2pdu.h       |   4 ++
 fs/smb/smbdirect/connection.c |   2 +-
 7 files changed, 130 insertions(+), 63 deletions(-)

-- 
Thanks,

Steve
