Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820952FE074
	for <linux-cifs@vger.kernel.org>; Fri, 13 Mar 2026 14:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413847; cv=pass; b=rZiOB2zu8FbNXr4n3oZaiFBFhNo5QDaGWUo56rUWKU9u293hbiFxD2nFvK3N+kTGNDA3ySYT+3wWnIPybQKfBRawT/y6E8Bs8H9swj1RbdUC/85QtvVltGx9cXSyH08LTPIdumH34TksWxfdJWqMTF7vXiSTxYMR3Xwxs916kJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413847; c=relaxed/simple;
	bh=LvYdoLJ8+bW6M6PTSfL1FxjKH1AkjGnQVx0bTCexAX0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=jwFUdr2D6XUWxHa1DPFHnoMckRyxOsJdq0WqacLt0FDhuAz74PzAB8kgs0Vzc/cCDdAX7E14JxzpoVTKsbPHOJLDfZ+T7f4VK/uIwRwoJrFPuGagHobp8W1QwE6DqfFicOimvRIRwpA7c+s0VW8Jt4xz+LRJcrqvoFmNXKYHnYs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kuop86Zd; arc=pass smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kuop86Zd"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-89a09ef1e3aso30187406d6.0
        for <linux-cifs@vger.kernel.org>; Fri, 13 Mar 2026 07:57:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773413845; cv=none;
        d=google.com; s=arc-20240605;
        b=QzsnF6UP+wo7XW3pYLE3mTmsXVAYmUQkpprEj+gHZ9vTJ+KfAoCYzdfzG14NiaP0KU
         moRs1LTkx3oyCsHGZojnVszGJ7lN4DR5KSMoJtc2JLb+/Sai5BFw/m52iH561IslN1Gv
         Y7s7Yof7t4tNUXOHrfHWWAu7CZVoSPuxLQhRCRXJH/ytYZSJ2qwF+1ZPHHO//4PmKBZz
         C5gLe+JY5ypK1bC5Y228FGjqbncGYDAzLxLlNQ8tkLMCgfyuO6zqwbjSoMyNR+ARUDs/
         ymBUKVZnVxbQVA/8RSzGQOGJrvk893p4us7pXkm+ZlKrdo+3BJ2XiRk13wtq2SxEwYUU
         +fGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=44IBOsYW9LVz7zyXlVjGU+iD8KaO6YaGMyS4ONOsLYY=;
        fh=HdCVYyNJSghe77PTE3f0vod0Typ15eQR+1RU9qnF/oI=;
        b=Hb+DQTJrVHT9mYhStGiVGLxyowwlLMj8SU97KxYjvFeJ5J7SMUdqQhMW7fqPtDw8ib
         bsC57wmqYYW9p+A/h/ustWeS5gHiBdUIPD6NSfxRnSE2oLdy4hnFzete6PqNt0Fq6dgL
         htVTk/uK/48GV6s4TDL8wJ0bEly8hi4s8g72bVz/6u+Kx2F5wz3ToZfXbj6DWiHolFH3
         MSRxaW6rauIeaeEAOE1XFybveuVzIBoSiowLkpBG4m84HfYYdYU0GZE/FtDKUPOOjsoS
         9W4XFghqABau0pRK+merGeyvRoouHpdzf384WXsUBro5gy5XmkodgmTtBietMlL9pwRt
         Ynjw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773413845; x=1774018645; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=44IBOsYW9LVz7zyXlVjGU+iD8KaO6YaGMyS4ONOsLYY=;
        b=kuop86Zdx9aVoxgoFqLKiwFRz0/r8EcAmzR8kq6SoEfCYTjx/YtB6oq0/1ITWGWKe8
         rvZQMRwfEFcH3TwmXdVOeacHdLscYGh27zYFiyz9uFz9bIxEZyQQdEBPNuF8bmwhoTp4
         EMTgc1RaWkvDMDzj1bgVNGtpdlnFpSvgH/2eKEBMQ92/SGsTBdwAG8plgyjTXMNvN+v6
         gcSVo2HafagUBoIQ78iM4z8IuNaCyT5LGwjKgvl8R1GuVPrWXCbl15PPULshmufsfkog
         1VWnlqjUVsKWtO0VdnXqlH85Zn2pfHMBBNr/WOU7YKV2IXB1RAG3luv6vNqboF3EiUlM
         KUzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773413845; x=1774018645;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=44IBOsYW9LVz7zyXlVjGU+iD8KaO6YaGMyS4ONOsLYY=;
        b=Xj07M2wyK4w7xOC2V4T+n6HEeAocZRsvBzZy83+dLy9X92HK1UtS0KjU6MdjSMcg+A
         niodsjiFL7fL5MgLe37jfbZb3LXHGjXTWZ9T5j6UDkdINEu0scvIZE1M9AMzErtBhqtQ
         Hg1xq6fHS5w8oGBGyrVgcsfnjEe/c2CvZVLcIxwsEaNNApkJo5TYwrqj2y16tCOR3pti
         EYipropQYlxrEgbf3/AiDOWEUOUisOS1pP7FwmbAxoHGFHssn2vtnYwDh+ZVPjkkUUBb
         4AiM638Jq1pR3cu89ETsjnOyFk2bUeY/0iUyQjHNGbh4i06yFbv8HDYorqEOrKn/cjqT
         O6oA==
X-Forwarded-Encrypted: i=1; AJvYcCVpsQqG3NJAKMGGFKfMSkaKmg0nk9humv1teMAUUgRbC6Oick7giF9rTkkklg+S/w0bbSi0eFohcne3@vger.kernel.org
X-Gm-Message-State: AOJu0YyKmN4/ns+TnROrzgdMfDqOk/zdhiMTNcT3Yt01ZiNxai8rdMST
	ANBstIzOaVx9QPorR3BQi3C464u8s1zSNDbce4sqSAFStGB7sbt68RruVfJuCNQxtaz/yiefbTz
	YukF6eSZwZuepOklmbpjtVnn4GxdkP43RuEy0
X-Gm-Gg: ATEYQzwPS/W5wVmzH8/nAuY6HSQ0L9aCp1U5bzyvCAfqtwaWugSt3WLQnVnucSMXdf8
	zmiNQQ/u7crdf9h9v4LqjPNiTsDMcuq+y0tGlJB+jakdRNmegf0q/09oDsCsXzokDALkwAB2VLw
	CW5/tLJqzItIwZxBAmwTx9CxnA/2WTDu4BhT1TgCDlSBBkTd/goR4zq3MyfLJ4hKJTOd/NhMbBp
	wmqu/oM391nJ+/HhQOPtsgAYHzm8pJo3ydPmi30VpB8ouLzxFT06OH5u1zFqGDdRt6JiZtHQTmy
	CmhywX1PSfhOzfu8sDG0d8hfdguQ8JAFRQxqTGRvmIAPwQzHbrYTEeTSh0iUOkGyOpUOl+A79w3
	rSKBXodDAsMzEemOmjzrrFxea1N3xCIcfO6BbFy4ptYhp1iIFLoD9/kuARSqDt4bEN3Ztewo6rZ
	smvuQ/b5f7mnxMAVMxynJMgA==
X-Received: by 2002:a05:6214:2425:b0:89a:62c4:5dd3 with SMTP id
 6a1803df08f44-89a81d5e830mr60542976d6.25.1773413845317; Fri, 13 Mar 2026
 07:57:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 13 Mar 2026 09:57:12 -0500
X-Gm-Features: AaiRm51mdqY8_RGwjonLlnRSc7xx663-EoZoYEuurlP1y_tAn1zksGOpdTTeZ38
Message-ID: <CAH2r5mtRx_t2rraTyEmbyWMZk9_NTwuyHjC+oAkbFXz9AwxCvQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
1f318b96cc84d7c2ab792fcc0bfd42a7ca890681:

  Linux 7.0-rc3 (2026-03-08 16:56:54 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0-rc3-smb3-client-fixes

for you to fetch changes up to e3beefd3af09f8e460ddaf39063d3d7664d7ab59:

  cifs: make default value of retrans as zero (2026-03-11 18:46:42 -0500)

----------------------------------------------------------------
Seven client fixes
- Fix reconnect when using non-default port
- Fix default retransmission behavior
- Fix open handle reuse in cifs_open
- Fix export for smb2-mapperror-test
- Fix potential corruption on write retry
- Fix potentially uninitialized superblock flags
- FIx missing O_DIRECT and O_SYNC flags on create
----------------------------------------------------------------
Arnd Bergmann (1):
      smb: client: fix sbflags initialization

Bharath SM (1):
      smb: client: fix in-place encryption corruption in SMB2_write()

Henrique Carvalho (1):
      smb: client: fix iface port assignment in parse_server_interfaces

Paulo Alcantara (2):
      smb: client: fix atomic open with O_DIRECT & O_SYNC
      smb: client: fix open handle lookup in cifs_open()

Shyam Prasad N (1):
      cifs: make default value of retrans as zero

Ye Bin (1):
      smb/client: only export symbol for 'smb2maperror-test' module

 fs/smb/client/cifsacl.c      |   2 +-
 fs/smb/client/cifsfs.c       |   2 +-
 fs/smb/client/cifsglob.h     |  23 ++++++--
 fs/smb/client/cifsproto.h    |  26 +++++++--
 fs/smb/client/dir.c          |   4 +-
 fs/smb/client/file.c         | 131 +++++++++++++++++++++++--------------------
 fs/smb/client/fs_context.c   |   2 +-
 fs/smb/client/inode.c        |   6 +-
 fs/smb/client/smb1ops.c      |   2 +-
 fs/smb/client/smb2inode.c    |  22 ++++----
 fs/smb/client/smb2maperror.c |   9 ++-
 fs/smb/client/smb2ops.c      |  18 ++++--
 fs/smb/client/smb2pdu.c      |   5 +-
 13 files changed, 152 insertions(+), 100 deletions(-)


-- 
Thanks,

Steve
