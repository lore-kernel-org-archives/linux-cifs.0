Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0311E4AE;
	Fri, 27 Sep 2024 20:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727469614; cv=none; b=Qrl6dlERJLSSGIHZaXcqhpy8nJk5NhkYBCruw7WWvNlF8k6cQr6mXDBs9TQDPcdlUrRM8ZthYzEriuUZByor743ySeKn9CaPmpiISOP0vRl/8i9hbAl9QMLeK66Z2alM/4RhsXiNn1APhRfH3+1Id2t2cWERXZdIUhyFvo3A6ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727469614; c=relaxed/simple;
	bh=3DGUJ3TLsK0lVuJXsACcJZxaucifcbxqwagxApclWEc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=hyREbdLmTe9LlhrNBNb9ATRRRMLGwyCNP+EYk9UbJCCO5QfXGUS/1A93lUPnUcSE8faOC+eIRVcC5pb3Xhnx2w6kRJDQCK4qXy8NWjAsWuTAIViwyDSOocHKNHj8t+2cgGG15SxxYIukfVNnNSHgbH3CtaKKvFGeMykuQDEWN8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l+QGF/DH; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l+QGF/DH"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-53659867cbdso4142372e87.3;
        Fri, 27 Sep 2024 13:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727469611; x=1728074411; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hthAcDKPQMJW1A+hjzFdpyeRVVHnV5fmXsD68YpD0u4=;
        b=l+QGF/DHrqPMuittVYX+QMZgqPMu2qPOs0VDr24Hsnx5LtD063zWlvHuPZHEKV1MIe
         YZdlvfMFJ95fX1GSQCR5yYTC5uOSaMth/XeCrHo3tSge3uLl412UeSxp1VwXLFZqkX01
         xlINslsaWGsS8mTeWVGIzhs2ypOgTmT6RZovHr8+mWJTjYsxQgpJfC5YOOPxmnmHx45u
         p509qPDiabOSFrqU5sssUMRuh55EgayeL5EEaPWDprDI/Yst7OV0t7Hio0ui6NIA84P0
         7C4kRVwk6Nnz0041rYWih6BcOzQ7IAL8QmwCq2DZ0cvKpfC4riSpTRkcuqoq2iz3Fa4m
         giow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727469611; x=1728074411;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hthAcDKPQMJW1A+hjzFdpyeRVVHnV5fmXsD68YpD0u4=;
        b=Wq/za5FAoeMtvkOD8edqe0Egtk3O6sGaEe+OTAD57iAA42AvsezhWFcFoRlqTf0Ntf
         sT2SNjRuu+/Z6AyZJHh1+VWEWeyc7YcflVWmluwHAtwB7+wHjtUn424sUr7TRhaZrSyR
         oWZkcGDHAkwvNQOBTwYrJSA3Prvu6HryaxbUDoGDg0ukkfa+uG/CHPa02wAvhA/t43VL
         IdqYGjuw6Cmi3X3Q0SYThxHPo+O13yz5eTqNeSHvQfpil6AikbAZbsVVCG8lmJ6LFsgE
         qkhmMUF//lSnZ+hAgCzVxzPkQKmFQd5oYSYN0DxD/7Zsc5hA7R8ZqFCg4Motfsp1NeOM
         fVew==
X-Forwarded-Encrypted: i=1; AJvYcCXbrCcYxWnwbgITNF9fJUrCorv99XQsIR98sEHjj1Z+9HSvH+gh38FfwVu88UTZYth9tVauBedA2RPH@vger.kernel.org
X-Gm-Message-State: AOJu0YyfUi7m2J/+fQVal9yFBT0jDPVtECzcE4AFjTpPxKj7c+hvWhmS
	1n3DbVKJMyHbn+bvQBgs4rLztM/36DedTPzKP4CU5mN8gCRezcX9JW1h+i8wL0WgzSjDcDyiGD7
	z3Y7kJsOBI9TUJr1MAubqT6afGg3C7fLi
X-Google-Smtp-Source: AGHT+IH3DmL/UKZB5yPvchHnEQUAmyPoNU5cm+KbxtkilRuEU3FV3gdezLxwkO+1P5WGGJLCRrn36GESu/C1mwnXGxc=
X-Received: by 2002:ac2:4c56:0:b0:533:4505:5b2a with SMTP id
 2adb3069b0e04-5389fc478b7mr4561184e87.28.1727469611014; Fri, 27 Sep 2024
 13:40:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 27 Sep 2024 15:39:59 -0500
Message-ID: <CAH2r5mv17isy4Or5+Gffn82y=HWWdgdsUOayJbbJ7dd4r3Teqw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
ac34bb40f748593e585f4c414a59cf4404249a15:

  Merge tag 'v6.12-rc-smb3-client-fixes-part2' of
git://git.samba.org/sfrench/cifs-2.6 (2024-09-26 09:20:19 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.12rc-more-smb3-client-fixes

for you to fetch changes up to 220d83b52c7d16ec3c168b82f4e6ce59c645f7ab:

  smb: client: make SHA-512 TFM ephemeral (2024-09-26 18:15:19 -0500)

----------------------------------------------------------------
Five smb3 client fixes, and an immportant netfs fix for cifs write regression
- noisy log message cleanup
- important netfs fix for cifs crash in generic/074
- Three minor improvements to use of hashing (multichannel and mount
improvements)
- Fix decryption crash for large read with small esize
----------------------------------------------------------------
David Howells (1):
      netfs: Fix write oops in generic/346 (9p) and generic/074 (cifs)

Enzo Matsumiya (4):
      smb: client: fix UAF in async decryption
      smb: client: allocate crypto only for primary server
      smb: client: make HMAC-MD5 TFM ephemeral
      smb: client: make SHA-512 TFM ephemeral

Paulo Alcantara (1):
      smb: client: stop flooding dmesg in smb2_calc_signature()

 fs/netfs/internal.h           |   1 +
 fs/netfs/misc.c               |  74 +++++++++++++++++-------
 fs/netfs/write_issue.c        |  12 +++-
 fs/smb/client/cifsencrypt.c   | 151
+++++++++++++++++++-----------------------------
 fs/smb/client/cifsglob.h      |   2 -
 fs/smb/client/sess.c          |   2 +-
 fs/smb/client/smb2misc.c      |  28 ++++-----
 fs/smb/client/smb2ops.c       |  47 +++++++++------
 fs/smb/client/smb2pdu.c       |  10 ++++
 fs/smb/client/smb2proto.h     |   2 +-
 fs/smb/client/smb2transport.c |  32 +---------
 11 files changed, 182 insertions(+), 179 deletions(-)


-- 
Thanks,

Steve
