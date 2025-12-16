Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9541C23278D
	for <linux-cifs@vger.kernel.org>; Tue, 16 Dec 2025 05:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765861615; cv=none; b=oaaQ2JNQsp91uqizu45SJH44UA+/bm+oMAz72sBJ15uWsS6W93R8/sSrcR+i8Q+qqnh3WhH7C7nWsBFBvwR/cNmwj75oDLNdyN84LAQPjgcy13CR7LWvgXZTVx+Zp1zqe3dNpqlz6qq+dTAGdCkBJ5kFRsVfZG8waxtfYSXXL50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765861615; c=relaxed/simple;
	bh=bpvoSGuynFlzVyRocZ+AvYhqFy9Bx6fQ/mUZKOvC0ZQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=kqin9cQtRhiSxqn/3cwY1szbay5j4l8BCSHxNeDFEnBiYASDkRyzNJUTRnTIS6PLUf7QS4JN8Urtf7Fk/82PNe4CRPWrIAibk9wQcXPxVeFFZAWqO5E0uhJaJKeC0BnKbkI4ZLqEtqpEDl5x5SIknQpClPPrBSUQj+HKPfHs0d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=luSZyK3A; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="luSZyK3A"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8b2f2c5ec36so428147585a.1
        for <linux-cifs@vger.kernel.org>; Mon, 15 Dec 2025 21:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765861608; x=1766466408; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ezfPhqVi7PyUysNcDNov/p19LHfEvrYvWg6QlkuT+O0=;
        b=luSZyK3A88gljKHRL9tF8FW/gNiTmx2NYexcea5nVy5O3yuTN+59xDHMq1iAjkyN5V
         KngcQNeEKeTRHDKrj8s31D2Z5GNTrDRZlZ7Iz0pspGCwtODehX1sMhcxVF6/b/LCfarW
         iMZU69X4kGHYiDVdrUSrezxdIM3RVzTgAUsW2uMgEbXi2r+2XfoKgRBvfWYr4Uiqh8Qs
         1OlIwA85SGCg5xGnCSuo3UJNAs+Eh7bu5+j3loy1mxKCY95xAcZcr4L98077zWzFB3Nt
         czpnMMUHiQjqgVvQg0EZHeZv2j/mwRXJBrZ3kD8SQADhB7Vfil4N99/AoDP7v6Xiu6jT
         +yrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765861608; x=1766466408;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ezfPhqVi7PyUysNcDNov/p19LHfEvrYvWg6QlkuT+O0=;
        b=hEydMjwHi94kiTdqaYrO0gP2phRPCXv+osjZ6Yg5VpE5+rrkE14BfDgQDz+7ncPgm2
         ImJwf+MGmS6xwNaRx7TcayRdJ1uQbB+0PSz0qotS39lFcCeXNd12vV5W8N7C79nHyPSy
         GbR6dMTDBNNmCqPNGhkRcoXrKVeAKSfhRaDXF6Gu+j8ab9XBtGdCI+lz+jVmxDjWGlYJ
         HiUW1x7in6M4vhioLmrntK9IJujYm5NgeQKHbLSnqGkAhEat6g6Lo37Q4kkxkVp1DB+H
         xW4rVQ5WxlCkFNqHDWV6xjJ8vyks+BAh58K9PuPUeCmNAjPGzLcLSs9f/vk9MgfK3o6L
         y1nw==
X-Forwarded-Encrypted: i=1; AJvYcCVViO82ICVcXtvtHWkMXC8zZB6JvcW1OOr+R5C8f3pHMlHy5ToljWA148aoR2ruya9f9d+Zxd7VOUJz@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4aYq9dyiM3dOpKtsYkdsS6s/+MwQaBtnDTZ3lCqDT1T+72aNc
	YvnGg7+dwcrUNmTA+LgTYJcjNvg0IgxJFo7eCl1DyOZO0aoccYwBQn0QmAoC0vryzi2oxmAiGZs
	E+covaY0hRf75TxTdu3MThr6XDmTYjew=
X-Gm-Gg: AY/fxX7REklaKAQ9vcU5sRtzApLlCHYdl2ZRSnied8rTZ5umRxm1p2M67lqQlzIvlHE
	C5drRKjwNC2wQfxW150bL+inrutMb86mwPx4Mcfnd8COOUI2cx6mGmnmeFTbuTProbHR8E/2Wm+
	D8hAowi415uEaeTkoLvqVxM0vXV+Fj69bWU/XMcCfDJkJKWVQzPSSJCFRC2GDx5AoeQZqyK9nrv
	g2k7J+Ilot0vt0qZeykdyDMVZas6wR2eCChyEezP+XZIcsHNhHq7HGpnTrI7O3fi+OmgLf5xoUH
	3t+1tgHJFMY0XEH3RtGvxMKrc5umtA1Gk7BEJm9JKyO/y/drZcEbB5/roxtgPnExplb0t4FUxaF
	TQtM/+CeySrxtX4dEwEZaVxAhrKHCgwmhv1PMv7Ijl3kw4Z6+ZPk=
X-Google-Smtp-Source: AGHT+IGZDteOnpeGtIOAjzZ+VofZyiXgdJxmjhJtSjauU8wA3YCIe08YlbPtWtRSVbBZUJRCgSSJuoRBuB6dePyyx4M=
X-Received: by 2002:a05:620a:f06:b0:892:8439:2efa with SMTP id
 af79cd13be357-8bb39dc4866mr1801080485a.23.1765861607863; Mon, 15 Dec 2025
 21:06:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 15 Dec 2025 23:06:36 -0600
X-Gm-Features: AQt7F2oGCRTgxpwpaKnogvq-n0i5X02nxx5arLL_1fIlbVoOIytQfSfw9f6VWcI
Message-ID: <CAH2r5msK2mYp39bX0=R+phV--knmAcLCXTdqYSWfuEfb=59dxA@mail.gmail.com>
Subject: [GIT PULL[ ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, 
	"Stefan (metze) Metzmacher" <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
8f0b4cce4481fb22653697cced8d0d04027cb1e8:

  Linux 6.19-rc1 (2025-12-14 16:05:07 +1200)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.19-rc1-ksmbd-server-fixes

for you to fetch changes up to 95d7a890e4b03e198836d49d699408fd1867cb55:

  ksmbd: fix buffer validation by including null terminator size in EA
length (2025-12-14 18:35:56 -0600)

----------------------------------------------------------------
Seven smb3 server fixes
- Fix set xattr name validation
- Fix session refcount leak
- Two minor cleanup
- Three smbdirect (RDMA) fixes (improve receive completion, and connect)
----------------------------------------------------------------
Alexey Velichayshiy (1):
      ksmbd: remove redundant DACL check in smb_check_perm_dacl

Chen Ni (1):
      ksmbd: convert comma to semicolon

Namjae Jeon (2):
      ksmbd: Fix refcount leak when invalid session is found on session lookup
      ksmbd: fix buffer validation by including null terminator size
in EA length

Stefan Metzmacher (3):
      smb: smbdirect: introduce smbdirect_socket.connect.{lock,work}
      smb: server: initialize recv_io->cqe.done = recv_done just once
      smb: server: defer the initial recv completion logic to
smb_direct_negotiate_recv_work()

 fs/smb/common/smbdirect/smbdirect_socket.h |  12 ++++
 fs/smb/server/mgmt/user_session.c          |   4 +-
 fs/smb/server/smb2pdu.c                    |   4 +-
 fs/smb/server/smbacl.c                     |   3 -
 fs/smb/server/transport_rdma.c             | 175
++++++++++++++++++++++++++++++++++++++++++---------
 fs/smb/server/vfs.c                        |   2 +-
 6 files changed, 164 insertions(+), 36 deletions(-)

-- 
Thanks,

Steve
