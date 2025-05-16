Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147CA227B9A;
	Fri, 16 May 2025 23:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747438955; cv=none; b=c0MNpUqugw+Dlv0r1IiFT2P5UOYi6AW9tFJED8cjNQLYh1IWnDwAeMSXXwiIykz92mrebEkFW3b4eKxGJgRyScB8qSUd7x2k9vuki+yXY/eHcRTvNeDC4kM0QPjZxM7rOJtdexvQH/G/WWYX3H+mKgc8j4Pz+cRAUthY+nYX7xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747438955; c=relaxed/simple;
	bh=enhUdYLZNGuxjvV2Ouo1ieQ/uQBsaB2W9PP8wdHqgjk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=en0etCTSbxETnkNxymUkH2O5csNbG48B8tpnKRISnDGVZhs31qQmpr4h1+F+7fyiLjrtzU9fIRMoGWVyOgKVzwXGuekUpZZbUT8VYG3S1tZtBfx3OATo81DdVAw37P3X7iwfH2Y+4cPAeBgx95e068FaIeJApsklPkJHBhr+HEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I6XuD7X5; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I6XuD7X5"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-30bf7d0c15eso23730691fa.0;
        Fri, 16 May 2025 16:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747438952; x=1748043752; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xLZr7VPDkLZEOG2In4Hkybds2QcDTETRuyHOMbZn0I0=;
        b=I6XuD7X5LQTLk9YlaNyizK71YWGu58XD4lSgFcBSYNqnJ6y3xShemrqn4ZHTwR4IYm
         eAx4GOseKWVlPsAZB98CWvJyWnOxgkKY/9IFOhuJH/9FP5hQPsQ8nra7EI4quY13qaHW
         j2+eFXeEFNdUpHEs1lQlfzewe497kc/LwcydcWcgjDAt/c1mUPj+y3ZY2JoyYQi2hjcM
         7KrO8RowU8XcXf8bsk0By71E7s5d2vZi+4yH13m8c88rXqfQF+E7L6IGUeqR2GXsAfWF
         X2TFG548qpBwqSAPAQS7JUh77gQ4LVUOaBcGtCz1i9JHpl53E8N8xvDXlKhiTdln+9Bw
         mUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747438952; x=1748043752;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xLZr7VPDkLZEOG2In4Hkybds2QcDTETRuyHOMbZn0I0=;
        b=cdIdGZ+P9Qncp5ikjTce+BU49dOi3dei6sONQ344PGnRhDSxd9A5VuGiIn+ciTFzFO
         oeRh4SvnyGNmE3PIxy0dTXpGJ8vrsdaZEb3X0VcOYuJ2eyxwXOVMpVFWlvcudYWbTOKW
         JsD5N7MTDsllzDwm9NrwLtb+q47RqjlvPgaGNMCZDIzrUt6Oy9nmywSVkQZNviTyC+p1
         WsKe08ux0txWXHtehNvCTMrZ/NF6x1OdFTIgpq6fS9zK2VmdjxiIl/oqcq4HsU9tYRYW
         5yTK6EysDWMFei8PDhYTMF86i9PsjyUfLKGboHz6w9hhCxnyXw8OmdJ1Ev1sTbnw7yYL
         hOFA==
X-Forwarded-Encrypted: i=1; AJvYcCXA599CjJ8sd2NfWOcVo+eCjyZFqHTKRrJyboVc70pGlBHbVCp8k9WT1vmE3a5vVU2myyH919DwOw8qsS8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEEEJkDGtBKpuUpTSFOqZOnzng1ZTiyxzq5LGUTQFqwbQW8SBT
	LPlJFRLCuooGOGaO8yL+tB5I8dDcLcapPhcULYpHDC+r1ILiEXt0UO1kRpW25Qs4Clg3oxR8rag
	BRiWtr6FWExR+7bcGqVPCGxFJLOJfilghbu3f
X-Gm-Gg: ASbGncsIF5PrJZx29E3pibjdDNHLfw5fEdUISx6/f+6LzpzmedvBOCMVBzu4XF66K+K
	EROgtepHeimKwKaVPvNQZGfoDgFtCzHEzVvpwdlDE2Tw9jdnHYmDioeGoNOpJqjjwdFrblMCEhC
	M4mSmsjijRFD/HCtqWzhRGJPtDuTbQ453FyPd3eFje2bT6S5OouCc33vDzJ04awM4=
X-Google-Smtp-Source: AGHT+IHWA0Q42Yme9yar+nJKETqGN6P6XPgO5dgbsqiCW7CZnmvrdQJh1/OATeYw3Dk1Wp5wXUDmiePYru76htQVZGc=
X-Received: by 2002:a2e:8a88:0:b0:30c:b2c:edb6 with SMTP id
 38308e7fff4ca-328096cee8amr12394851fa.18.1747438951796; Fri, 16 May 2025
 16:42:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 16 May 2025 18:42:19 -0500
X-Gm-Features: AX0GCFvohLs-QQrzZlsilxheGT-EDcZhxA3HzyLs6TaG3uT-eoyVlqE2sQ2H3bo
Message-ID: <CAH2r5mu7-vNnVE+1fdESnV4kJ-sr3gV4YnAQJ==BuXve2QOjpQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
82f2b0b97b36ee3fcddf0f0780a9a0825d52fec3:

  Linux 6.15-rc6 (2025-05-11 14:54:11 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc6-smb3-client-fixes

for you to fetch changes up to 3965c23773e81c476f6de30ccc5d201c59ff9714:

  smb: client: fix zero rsize error messages (2025-05-14 19:26:38 -0500)

----------------------------------------------------------------
Two smb3 client fixes
- Fix memory leak in mkdir error path
- Fix max rsize miscalculation after channel reconnect
----------------------------------------------------------------
Jethro Donaldson (1):
      smb: client: fix memory leak during error handling for POSIX mkdir

Paulo Alcantara (1):
      smb: client: fix zero rsize error messages

 fs/smb/client/file.c    | 6 ++++--
 fs/smb/client/smb2pdu.c | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

-- 
Thanks,

Steve
