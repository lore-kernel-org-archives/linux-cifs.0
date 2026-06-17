Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBD43783DE
	for <linux-cifs@vger.kernel.org>; Wed, 17 Jun 2026 22:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781735567; cv=pass; b=U9cgMLPp85bweuz3k/5BpNVx0AEzXBNZqiNnoInVWYzPhBe9S3OAsCjE0nA2g61r58BKubxdIQsiGj9tr+4aQHVRQVhmDVXNkCD2fnuGzd/EG983yWSd7WD58yEivlaYJmuhkRATwNPypuFT4ieIoJz3WIAOr1ze18j1hhVT6Is=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781735567; c=relaxed/simple;
	bh=v+9oXRaRNNJD61TqzJPL4b66pHyOG5H1zhGzk3+YS4M=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=FeIlk8dHmOJeiqLDz+UE/UcPfgvuraYn48MYSpNz8iGbF77glPPr3eRsiXgOZr9DURHs84JUltBF/mGMcSPUBATVGljsuSJ3sDvMIz6xSYKIrm6BskTa70h0CZQqCIQpy8c9lxMDvnj2iHk0HHPAJ2MdoSy17T1Un9bStPPDuEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QLs8tDzw; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QLs8tDzw"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8ce9df4732cso2659526d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 17 Jun 2026 15:32:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781735565; cv=none;
        d=google.com; s=arc-20240605;
        b=LFUcbN9N3GaUZ3KmmcVuEVMn13QQSzJGDthVNyJTQvo4V5rcKLp78JgBtN9KtsCq9I
         oIkrBFapJJ7Wt4B3ZztRY02MCnmt/edvppB99iGI/QuUHi0vtjMAYLmLZCu+izUdahZn
         4I2VrjP8kGf/3mg/91Y0kqJfxT3Wry96BoCDi/cpiZBsCYIkmTw/X/zBfDSvLr7Mf1jk
         4GkewT6u4TeBxphRwovAh55fFCz4ytbNAVgvw+pgUktVZi+pB5nwxJYK8fUdJYrp+wMs
         vEZQYKeRLdzMNyWscQEurOd4a9IdyZbKa+d/Uq0TslHI7FUCy6OnRv1zJXYEesQvLoGi
         /Bdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=yiYLavcggvcchcAVQlaC3NjoyAp693EWIYdpFNimi+4=;
        fh=Nf1mvuQ9XbZKOmPhacDz1X5aHl0t82a+aHbY+2n4zlg=;
        b=OfXFV2Jlcr+ctJ15NOilLDfdYVw4Uzd/MvzY3nFwP6IwvULPjCKSexR6AZMFf4t4WL
         mJZdg7z3BWwrPEsbc+Yx21KBbM2OINliicb2dxtfDXpKJmcbVR2Eib21rt8L0LCuq47h
         +JyhbFOsK3z8WwNeSAj/TrC6UhYDA6a1OwzcVujzG1YySsVNXEnF4UQAQLkGSlzxnjlM
         /2NiRq1DT6lkSQXIJpvVBzV65YS8xHpkTC1AuTxKokpnwbhx2nef4MHJLzmaxjzWTGUV
         TVvthAwHISgJkU0K1DPmqBI353ncrz9k8G65CTwuhMEJhjBKsDQ3YjkLOV76gEtRp+ty
         1UzQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781735565; x=1782340365; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yiYLavcggvcchcAVQlaC3NjoyAp693EWIYdpFNimi+4=;
        b=QLs8tDzwZ78Ow4Df5hYaW4PdPNb9boLU2hvzUW/HTJtiprIHk1jFTLxk3w+UsGUiWp
         U4R0cP9B1FOLrZWkRXcCfYqukPcI8b30+32EBn92EVgbuQCO8XiVXqt+DesyDGpn3DhK
         T6dTdy7eF4jg+kBNVYV29EFoY6KdpEUciSuEVFISvBPWQ3rnKmuTAyE+Syolf05bl9M3
         LG497tB/z2pvkm2J1Bkfk9XQl2sltcnt4hT9W0DyQS9xdgzlzBUAylkAMph8DLokA2zT
         5HtirX11C7IVcR0RlTRjoZRzoL2D6RUmCldFftSM99rz6NeKfMCbnVWrrfTDc9/xYFxN
         e6VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781735565; x=1782340365;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yiYLavcggvcchcAVQlaC3NjoyAp693EWIYdpFNimi+4=;
        b=fBO6HLlslHLnz0IrKA4S/7g0u/aHditPSE5khMErC8zEaNd85nmo+8qRA3sop1Yv51
         cbnQXsOnVJCHwFZI3mTc1CKq6MH7ZwQcpcm/00ksdhpsb/dYDmj+zdnSXEO6IA93+LuK
         iVfOZSLKHdY3kfWYrCQ25xDgle4yWBWW/CwXWbt1PCWQD0GtacluZUrhuAd0jKVJKxgc
         pvmlDxSrisY5bf23igk3FFivMuRIA1RQ4VYUeqUn8YKEEMxlG4K5mYaIOYZRjOcfjEOD
         3QDA3veCpiPI0gF6it6gYA7q3kmwXtFuZ1pGZprtL/wfNKa7JQDoBnJsI9IV0QzrVtic
         xzcw==
X-Gm-Message-State: AOJu0YwwzxsiJUQOEqUwLNW+sfJ7spxdA/jEyOukebg/58YPZZkkaVfI
	B9Qc9k7xuG4J7yKPQI/AB+g3UybFo4s77A4a9blrd5R5G5UdP1v7HFJAQULoKEooGDX1GYyXmSQ
	mOFLkTBJeyi8m5t8d/UihSOencx1y0Fyz3/jQIGQ=
X-Gm-Gg: AfdE7cmPo4NZkhv93A2SDt4ETzG74GvLRMvUDezZJRNWKVUBe/QzoYDjqRCVr5LV8Yr
	kSPMWSd+g2jeooNf/z/SQaLB9FjBarwyw+gJx1/CCCsy0xj2iCWzNnwQPrFEoZBbWDKMrJVHdif
	NMdcEDjq3jIEjt1yJ0VnWsW+mCA4qzzOoaZC4h9vEw8FkOPC+SlkiyhOUFMGEq8L6NHeKMxU8Xp
	tQ3wM4B/uVq1V+M9OgoQ7QBzDf2MAcb6nw7/qvYEI3WUQpd279ve+0b98KamsdaRj+VHY5pUyd2
	O6VHDMOZU3kSRCR1Al1cFDfML2yOYvz2ztq7+i+lA86IME8AobKhBgJ2GK15PNxERxK/B8S4h74
	T0IlKNJ50zUJf0w93Bo42DjDosMrkq33G/KtBy7Tg21lkanOBh/Ha8g6SQlH09zNnlrCavgGheG
	/S87LxYb+Xftg=
X-Received: by 2002:ad4:5c44:0:b0:8cc:edd2:6a57 with SMTP id
 6a1803df08f44-8db81dd0509mr95403836d6.18.1781735564549; Wed, 17 Jun 2026
 15:32:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 17 Jun 2026 17:32:33 -0500
X-Gm-Features: AVVi8CemvKYbbHu1qinv2CXzxw0DE3v9xKZYWaOFYUTRuHnbwqWPlqnnSfoYi5Y
Message-ID: <CAH2r5mt-tckYA+GROnJLQWrR4JO2A6BgWGK37G5Z=HQ7efrkxQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
8cd9520d35a6c38db6567e97dd93b1f11f185dc6:

  Linux 7.1 (2026-06-14 15:58:38 +0100)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc-part1-smb3-client-fixes

for you to fetch changes up to 0eb17dea51eff940230b5e562df29ce457124d41:

  smb: client: Use more common code in SMB2_tcon() (2026-06-14 15:12:24 -0500)

----------------------------------------------------------------
14 smb3 client fixes
- Three cleanup patches
- Fix rc in smb2_aead_req_alloc
- Three compression fixes
- Update i_blocks after write (fixes various xfstests)
- Fix races in cifsd thread creation
- Fix potential out of bounds read parsing security descriptors
- Witness protocol fix
- Fix umount bug
- Mount fix
- Fix cached directory entries on unlink/rmdir/rename

----------------------------------------------------------------
Dan Carpenter (2):
      smb/client: clean up a type issue in cifs_xattr_get()
      smb/client: Fix error code in smb2_aead_req_alloc()

Fredric Cover (1):
      smb: client: fix races in cifsd thread creation

Henrique Carvalho (1):
      smb: client: fix conflicting option validation for new mount API

Huiwen He (4):
      smb/client: update i_blocks after contiguous writes
      smb/client: always return a value for FS_IOC_GETFLAGS
      smb/client: use writable handle for FS_IOC_SETFLAGS compression
      smb/client: allow FS_IOC_SETFLAGS to clear compression

Jian Zhang (1):
      cifs: remove all cifs files before kill super

Markus Elfring (2):
      smb: client: Use more common error handling code in smb3_reconfigure()
      smb: client: Use more common code in SMB2_tcon()

Michael Bommarito (1):
      smb: client: resolve SWN tcon from live registrations

Qihang (1):
      cifs: validate full SID length in security descriptors

Shyam Prasad N (1):
      cifs: invalidate cfid on unlink/rename/rmdir

 fs/smb/client/cifs_swn.c   | 314 +++++++++++++++++++++++++++++++++++++--------
 fs/smb/client/cifsacl.c    | 196 ++++++++++++++++++----------
 fs/smb/client/cifsfs.c     |   4 +-
 fs/smb/client/cifsfs.h     |   1 +
 fs/smb/client/cifsglob.h   |  11 +-
 fs/smb/client/cifssmb.c    |   4 +-
 fs/smb/client/connect.c    |  30 +++--
 fs/smb/client/file.c       |  52 ++++++++
 fs/smb/client/fs_context.c | 109 ++++++++--------
 fs/smb/client/inode.c      |  30 ++++-
 fs/smb/client/ioctl.c      | 153 ++++++++++++++++++++--
 fs/smb/client/smb1ops.c    |   5 +-
 fs/smb/client/smb1proto.h  |   2 +-
 fs/smb/client/smb2ops.c    |  12 +-
 fs/smb/client/smb2pdu.c    |  17 ++-
 fs/smb/client/smb2proto.h  |   3 +-
 fs/smb/client/trace.h      |   2 +
 fs/smb/client/xattr.c      |   4 +-
 18 files changed, 721 insertions(+), 228 deletions(-)

-- 
Thanks,

Steve
