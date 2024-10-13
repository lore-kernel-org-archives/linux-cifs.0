Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E3F231C88;
	Sun, 13 Oct 2024 17:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728841844; cv=none; b=r5g12qYCbXcQqrMb9Ehg++R25F6GUXUXNuFYycFHb9dvkPZlUCJtgG/yAMqeClTyCbO7nGuE9LxcY0MXWHCo1O39QQakfodZpEUzDu/zzp+phOT3p0w/y2mN8dpFfSOl2qvu7mDqYr/Cvp3kCqhVfbKkVV/EIGgVFX95Q48ognA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728841844; c=relaxed/simple;
	bh=EJZPfUC7yVWYpSlmhm/M8EuNozKvte0LBSNsHfH1MG4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=fqNmgDSsBGOSf0/k3oDEFymH3xvnNcSWEZueL2LKo7c/ff1mlrmmAW5HTLn7yxDQyr+7KL1gbhP/335n16VphAm0HFEv1Oo9vcFiPquJGs+oQCFvOv03kD1Bj+K6xjMyu5z39VCAG97wSX2hMgeWn5DdfgEcwdNQVLfaO+KGVu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mOiPU3Ez; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mOiPU3Ez"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-539f6e1f756so271928e87.0;
        Sun, 13 Oct 2024 10:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728841841; x=1729446641; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hxbACub/5iilf5Pw609ubUMZh8eS5xKN+hjQXWQCpqs=;
        b=mOiPU3EzCWNQhH869qJ6lirj8E+9xZe3Mj1HSBluwHEcCcwkL9m+zfrkIVFkzTMzs1
         WoOPHvXUhhb91VDCo/aSDoa+MnEfkaN95NVlt5frHnWgDJhmYFvKQDB2BULrnHIB7HpW
         Hy9pdEa+HD0Efw82ze9smNkanMWcVtMX3u9SLvLzFUmZ14kl+u/EN/mJo+V3UfGfIVlr
         /XhNOyz2jVAiGSQ59rBHxoKaNKITApjOU73cYN98Zxmk7H/NOwIga26kP4lN9Y1stss9
         qhLSF0/yUI19x6JUlDco9F3Biz6lbUJdSaSK9/0xOb6AYXG+sTpc7Ur7dizhuYnoysqv
         ErSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728841841; x=1729446641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hxbACub/5iilf5Pw609ubUMZh8eS5xKN+hjQXWQCpqs=;
        b=P8baDhyEpuXX3QYQVBhonanZwFPm7/eelgigdVR/sYuyqkhFApk6/MoPMb5B8MpNt7
         cGOTpc+nM2H1usAHnLEdqxIspPvSMZXN7YyG4HlGL9Gc1W0oTx0K2Ncazxvpk78t7M0P
         XvWED3gIQW1GbVUgAMesnSPPL9P5tFyAVKXWIN9LU/I4tIfu+RQ2WeD/4uAQipZVgiqt
         SS+33gXfJoSwKl5jIxAZ+VmLARWnh7l+tOC3jLZD4tvDwu4X2BltEPH2SLev+T/ht490
         LaX9hqtJlQ6hktpUsOr554MgqWqF1ShqVB/JLyOd/e+I9KjTVVqyCzvQ2e0ULiOcloZy
         2b0w==
X-Forwarded-Encrypted: i=1; AJvYcCULWYEbArZQ+nseBPkPPgMaLQJUVmkzw9NXBI8W61NZ2v3zksWU8+CEnfZiEyFtD7r/heMBSD9Hr/uaICw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywn5GzxM9b+PQ3MrtJDWvV0C6bWQYdqHGj6ZH0nUuB8GSEzWD7a
	S04LCd/tJCEPcERQ8obfTcXi5sGsAYNg0WRhwkyxS+ZkDslWWUXWMyKwj+3VEkNDAKdMGS/72Hv
	JPBcov3XBhYUojokDimp5uV0Sz1gwL6BgwH4=
X-Google-Smtp-Source: AGHT+IEFrbAv8qcNSwcd/9/FNA7YAbEwDHSSc5CItDDH9QzK7uVGMad5ZGxTk4Iu62JLA8P5QrJgc8bQBKIDoDyOckg=
X-Received: by 2002:a05:6512:128e:b0:539:920a:f886 with SMTP id
 2adb3069b0e04-539da58a9afmr4020700e87.50.1728841840947; Sun, 13 Oct 2024
 10:50:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 13 Oct 2024 12:50:29 -0500
Message-ID: <CAH2r5mtWduOymGy1QSUycG-v6k4p9g=gamROOsrs_dF9SLMbyw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pull the following changes since commit
8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b:

  Linux 6.12-rc2 (2024-10-06 15:32:27 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.12-rc2-cifs-fixes

for you to fetch changes up to 63271b7d569fbe924bccc7dadc17d3d07a4e5f7a:

  cifs: Fix creating native symlinks pointing to current or parent
directory (2024-10-06 22:57:12 -0500)

----------------------------------------------------------------
Two fixes for symlink creation that address some interoperability
scenarios e.g. to Windows targets
- Fix symlink creation for directories
- Fix for symlink creation when path begins with . or ..
----------------------------------------------------------------
Pali Roh=C3=A1r (2):
      cifs: Improve creating native symlinks pointing to directory
      cifs: Fix creating native symlinks pointing to current or parent dire=
ctory

 fs/smb/client/cifs_unicode.c |  17 ++++-
 fs/smb/client/reparse.c      | 164 +++++++++++++++++++++++++++++++++++++++=
+++-
 fs/smb/client/smb2inode.c    |   3 +-
 fs/smb/client/smb2proto.h    |   1 +
 4 files changed, 178 insertions(+), 7 deletions(-)


--=20
Thanks,

Steve
