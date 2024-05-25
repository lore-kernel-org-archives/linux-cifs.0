Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2571EEE6;
	Sat, 25 May 2024 22:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716675897; cv=none; b=qdBaFI6bZFOBMfqYQz+a/iWWe7EgjV87C1bc/o/+zAc/5uE8kLuTIr2L3992+/MoV/AJ9heIXu3D0GSX7qHO/DjrhJUkfd7eHiFI/hCgBWlERoYxI6VLFilZnBKVY2M/bNSi9DTwmAIUqcP1YML5mk2DJIu4MzPgkrUJh/vxmVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716675897; c=relaxed/simple;
	bh=j0UtRCHR12StVnpl51PxRxD5Dra5Oy70r3pKeGtXcgQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=l2I3rvFMV80YALJASLP5i4a4wAT90Eb3HuFJo4FUAgvlsu3vxfNa8WYgomunIsIJa6Yei3EdMuBmDSicuLHtmI6KH68sQR176CQGfw5APGywMeKjkynwE/SN7ygXWfmttyVGdoB2+cvLZhLjlTe3G+QxW5pjyptypeV/O8dVlsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KBEDPhD6; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KBEDPhD6"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2e964acff1aso14167661fa.0;
        Sat, 25 May 2024 15:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716675894; x=1717280694; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OdmxIXeIleqt9vF3s+/fobqIkyAJY9hPbd3yMAbWsfY=;
        b=KBEDPhD6iwFhmo4rXiki1OmoD0nh0o0swu1sHn4fZ+hWaMgpXKapiHP7zruBkQtAg0
         xfODIFAm5ZBQgcu0lnKhnyw8qG8gG+wJvYYzOUH/rxrepzLN18xWk34NUeMDWjAyZHB4
         zA8GQd9ylRrUAj8ecoHyG7qE9fYfvyfFos3axrsOqOdDk85IzQUP2XHSn6dA0YTRhAf9
         T0zFxb6ceS4Utx2sNHXNfDE9RskDFZOBbXXys0AMO+Cwl8FbZP9m8FHJQBx8Z9GzTp3l
         HUWWgm5s9Q+kusZc0TSeSTEL/z5QF28KSzoEvkMUm5GWOtC9rThqJk29Ikae2gTTR0NQ
         0GFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716675894; x=1717280694;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OdmxIXeIleqt9vF3s+/fobqIkyAJY9hPbd3yMAbWsfY=;
        b=auYmG8GAagaSqXqdAucg930GvdBYWHx2t/92XWLXVqUdD8TCqtPK9qAxbvaN4BiP7W
         yPgv3G/wuogwnN5Kh40lj3Jpu7Jgx4WuSzuIWRorWY9qaNmbA5j/lxFoN9LvGSvuEVgT
         S6C4A+tcUX+IaND0FZWZL0ffI+UwXN8/ssHibhrkjstfAv2DZ3+WpShlPaobGvdBAdsW
         hSAweNYObGFq4iN0IOkxgs37Re5C9vuBQRO4BEn0rJ1fRlC857RYoFkW1DtOrpwkWYPX
         dy3bWte2iIQ6jfBf7IGRTIeAxkjyv16jW2JdLaX6iQYniaNHN6yKJ26xYFVOx0TxW1RL
         yWyw==
X-Forwarded-Encrypted: i=1; AJvYcCXpPMStoSqNC6r1LzrzsMGQlNmsZ0QA75WyEw2+Wg113NRsd3yh9FoVzU4ogiPONDW+t3NZyio1LqrVvLtYfWPg3prSbr52ITHb5A==
X-Gm-Message-State: AOJu0YzXdvHK2RhPz5HO6AWUI/bbn5R+1GOz1+x2MCK7FuJnY/j3tPU9
	Z/Bp6cLNNluKbqIO9XVKjcovgMjP5V4/tV1YkYuhU9qQS7gB384OVHRHNXBiTzSmxSMy6Hi2L0T
	sgFvrUN0DRbQfmvlpd6CTw8kO/uA=
X-Google-Smtp-Source: AGHT+IFQ4Me3hz8wDGUoApCPLaLNWr5nNb/xm95YUhw5BARqiNZynaVgoYyEBHNeREMnXhqzDu+7gaS97q+OoGBCGUM=
X-Received: by 2002:a2e:9659:0:b0:2e1:c479:e226 with SMTP id
 38308e7fff4ca-2e95b0bcebbmr34523401fa.9.1716675893809; Sat, 25 May 2024
 15:24:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 25 May 2024 17:24:42 -0500
Message-ID: <CAH2r5muATaLWcsuYWw0x8pjKjJqBFNP20GdU63vBiVYhQvEVoQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
0450d2083be6bdcd18c9535ac50c55266499b2df:

  Merge tag '6.10-rc-smb-fix' of git://git.samba.org/sfrench/cifs-2.6
(2024-05-18 14:19:47 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc-smb3-fixes-part2

for you to fetch changes up to 93a43155127fec0f8cc942d63b76668c2f8f69fa:

  cifs: Fix missing set of remote_i_size (2024-05-24 16:05:56 -0500)

----------------------------------------------------------------
Four smb client fixes:
- two important netfs integration fixes - including for a data
  corruption and also fixes for multiple xfstests
- reenabling swap support over SMB3

There is an additional smb3 crediting regression that is still being
investigated and is not included in this P/R.  I also did not include
the netfs fixes that are in Christian's VFS branch.
----------------------------------------------------------------
David Howells (2):
      cifs: Fix smb3_insert_range() to move the zero_point
      cifs: Fix missing set of remote_i_size

Steve French (2):
      smb3: reenable swapfiles over SMB3 mounts
      cifs: update internal version number

 fs/netfs/direct_write.c |  3 ++-
 fs/smb/client/cifsfs.c  |  6 +++---
 fs/smb/client/cifsfs.h  |  4 ++--
 fs/smb/client/file.c    | 23 +++++++++++++++++++++++
 fs/smb/client/smb2ops.c |  2 ++
 include/linux/netfs.h   |  2 ++
 6 files changed, 34 insertions(+), 6 deletions(-)


-- 
Thanks,

Steve
