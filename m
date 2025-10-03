Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13F84A23
	for <linux-cifs@vger.kernel.org>; Fri,  3 Oct 2025 16:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507394; cv=none; b=A4R8baNlXE27mpz1v6mYc3D7x1B+sSdi0bBqaw7RY2HKvM7+gFz6a/5qUAiux22AN6eFq2PVP0H/hEJCNQ+FV5OsJ3Lt6U7zqIQr+0wQhtr5xY2cuNLJz1mA+3+AOG1ArvjfCAjmVLUXGw6XUn41UnsNVFGmngas6+4rHZbZyxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507394; c=relaxed/simple;
	bh=z0h3Tu/KOtHPZ8+AACzKVO4cAeHzBa44OsQyYlpA3bc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=qPtb6X37waldZOf+5gGOqInThO6dQMhNiBmUncXZkCLZ/iXBNzA3wqQ5FZFHvng9I01vopIMsS7L8qJ1KRr9wbZ0SYdvWyxgA8whgPPPjsYR2NisdtqOyHt5qCcPIFQr3HK7iP6xf5NfeMR6mGAmK9QlT1pPIoRhKkuweMl7kyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cCgUIWgp; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cCgUIWgp"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-799572d92b0so21791326d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 03 Oct 2025 09:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759507391; x=1760112191; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=L3nWcPfR0+ZIvptj+Lev/cZAzIGOU9pUYfZtwr+0fGs=;
        b=cCgUIWgpGIeBgzl0doWaQWyuDyAdoeDa5lF4rEAvnOgE5hIS1IdtTsfm6nnBRS8Ol0
         tJ3pQH0bX+mfDkExXQdeUkV6OPtlwMiDHvwn4mzaJuum758jZTnenSD04UiH79bqoBQh
         7KMVLDyPkGvrRjcwHFWMyUtig4ChiXw8OMgXnOhEO/Ts6d4W3FZ1qMfMAR+Sy+utuYy+
         zy0qnk31AUQJtr3OidROTlmpuvqr3fN8Okb6ulLboUCrHJCrkaG66FPY+7ZJmwUpZTDx
         Ut+ztD6q2OWadI44aR7GmfzS0fFnMTou9THdIbJ0ddUF9GN/6LodGEhgwxMrUvf8U40o
         ek4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759507391; x=1760112191;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L3nWcPfR0+ZIvptj+Lev/cZAzIGOU9pUYfZtwr+0fGs=;
        b=M2/PSjGFx6sTIu5Tb9kwWCMcsm2r3MwLkXL6snHfR3kCe7Wz7WTV2vLoIvW5TarheL
         PGsU8EzbHKyENgiQRCbwoSJsheC+gPlbG6A9UxHUr9YK77QxtD/eCvYKNq25gU4gvq29
         PRkKKJIA9urG8vHfXycJVvwWp4y83H1F3sSgQ5elwLXxhAMkva/LS9E+XtjkkW01eBOy
         Fyu/B20VlR/NK7HhLIR44L2cYULQWj6Fjw9rlpXNYsN/qqNtmWI3j8825jvyqmcSrGVZ
         v5oxVRkLIyY7P738tumk4KXl24q/sg8m23l9/Rib5wRYg+z6lzQgJSUY9syK9gPcPG4U
         SUCw==
X-Forwarded-Encrypted: i=1; AJvYcCU3Ag9BtPlkxX8pqFZlRggYvSDsS3hPmhs2+AIkdHqNlw83ZZMe0a8aUhiA0AMUvn9eWpWDRwKBm/sh@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2/0MCdLiwrBVwz5PPzq29TPhBbAowoUCVkZxmKeiWyfmM07iP
	+OBozmkOd55DrFt6i/nJihKtTpCASHSsxTLiEChg/z0U/I63Xi8uK/8tn29pQ6WbNOH3axOyNQY
	JstDswGTexfdHHcADaC2sWVxc4groS18=
X-Gm-Gg: ASbGncvkwu95Dp+k9hWUFHMV43EXLBhsxKYl/mcFL8lHaZhspljWdXg15aKNAGU7UY/
	u8fuO8zJvj34VJc9JTAI7jmR9IcQt6+gqwR/aLsFEaSlKn6kvakqyJRb3tD7tzKbCHtPjvsbHEo
	KoX26uAZySUSY2MHYODu7ZoDgbfetbhG8n4jZ98ZZ6zztn+Rs8kWE5K6v5n4bInKKX5F+NXndg+
	tRYx6eBtHCUFsiA92s7yygns/o0yCuwOo3PZpDWsr94FghEGBzmsEK93WQe7oK2KLAsRqK7AgBt
	pUsoBy3iqA43zzaWHohSTLKurwGv9nK6WmEPT+t28znXK4Cy8elNPLY7Gp0d+khK6qZVvLuwD/w
	ouWxxSyJl+Q==
X-Google-Smtp-Source: AGHT+IFIs6Y0psEXE2wRJR5zXHyzkp5gNpm3M8PGNt8TtnmwXHc69OBKZFycaHpo3VpI2S5YX0fvm559DmIFtDvpNKI=
X-Received: by 2002:ad4:5ec8:0:b0:77c:6e39:b652 with SMTP id
 6a1803df08f44-879dc7a46ddmr48015516d6.5.1759507390877; Fri, 03 Oct 2025
 09:03:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 3 Oct 2025 11:02:59 -0500
X-Gm-Features: AS18NWB9vvfDBbaTpguGRJjLCPV7v1NVz19bLXfr6sowwaPS6p_45KQCJxCXzP4
Message-ID: <CAH2r5muO=jZMFwi+Hnr9mvvT+8wQqOFJgBZ0ArZhRZQNccNT=Q@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
a9401710a5f5681abd2a6f21f9e76bc9f2e81891:

  Merge tag 'v6.18-rc-part1-smb3-common' of git://git.samba.org/ksmbd
(2025-09-29 14:57:08 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.18-rc-part1-smb3-client-fixes

for you to fetch changes up to 37e263e68c5e27d5f1fbc1377f64f9373dc5bf15:

  cifs: client: force multichannel=off when max_channels=1 (2025-10-01
22:42:15 -0500)

----------------------------------------------------------------
16 smb3 client fixes
- Fix oops in crypt message
- Remove duplicate arc4 code
- Fix potential io_uring reconnect
- Two important directory leases fixes and three perf improvements
- Three minor cleanups
- Four debug improvements (e.g. for showing more information on
leases, and one for adding more helpful information on reconnect)
----------------------------------------------------------------
Bharath SM (4):
      smb: client: show lease state as R/H/W (or NONE) in open_files
      smb: client: add drop_dir_cache module parameter to invalidate
cached dirents
      smb: client: account smb directory cache usage and per-tcon totals
      smb client: fix bug with newly created file in cached dir

Enzo Matsumiya (1):
      smb: client: fix crypto buffers in non-linear memory

Eric Biggers (1):
      smb: Use arc4 library instead of duplicate arc4 code

Fiona Ebner (2):
      smb: client: transport: avoid reconnects triggered by pending task work
      smb: client: transport: minor indentation style fix

Henrique Carvalho (6):
      smb: client: add tcon information to smb2_reconnect() debug messages
      smb: client: update cfid->last_access_time in open_cached_dir_by_dentry()
      smb: client: remove unused fid_lock
      smb: client: remove pointless cfid->has_lease check
      smb: client: short-circuit in open_cached_dir_by_dentry() if !dentry
      smb: client: short-circuit negative lookups when parent dir is
fully cached

Rajasi Mandal (1):
      cifs: client: force multichannel=off when max_channels=1

Steve French (1):
      smb: client: ensure open_cached_dir_by_dentry() only returns valid cfid

 fs/smb/client/Kconfig       |  1 +
 fs/smb/client/cached_dir.c  | 50 +++++++++++++++++++++++++----------------
 fs/smb/client/cached_dir.h  | 16 +++++++++++++-
 fs/smb/client/cifs_debug.c  | 41 +++++++++++++++++++++++++++++-----
 fs/smb/client/cifsencrypt.c |  8 +++----
 fs/smb/client/cifsfs.c      | 40 +++++++++++++++++++++++++++++++++
 fs/smb/client/dir.c         | 46 ++++++++++++++++++++++++++++++++++++--
 fs/smb/client/fs_context.c  |  7 ++++++
 fs/smb/client/inode.c       |  2 +-
 fs/smb/client/readdir.c     | 40 ++++++++++++++++++++++-----------
 fs/smb/client/smb2ops.c     | 22 ++++++------------
 fs/smb/client/smb2pdu.c     | 18 +++++++--------
 fs/smb/client/transport.c   | 13 ++++++++---
 fs/smb/common/Makefile      |  1 -
 fs/smb/common/arc4.h        | 23 -------------------
 fs/smb/common/cifs_arc4.c   | 75
--------------------------------------------------------------
 fs/smb/server/Kconfig       |  1 +
 fs/smb/server/auth.c        |  9 ++++----
 18 files changed, 236 insertions(+), 177 deletions(-)
 delete mode 100644 fs/smb/common/arc4.h
 delete mode 100644 fs/smb/common/cifs_arc4.c


-- 
Thanks,

Steve
