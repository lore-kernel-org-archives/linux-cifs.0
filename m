Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4510E10A1F;
	Sun, 21 Jul 2024 23:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721606165; cv=none; b=qOVoP+nZgnu8ZKQ/0H1OapAImvudpdVdX9pqpO24kELnHcr5oba3R2BjSMaZQmdpCDjCkIjRwbe+NXco1wkSB1hRa20ktXHsdVrMBjxAYrfXrHpvJkr4HfreBC6UBB9ZEIj5HkOvw+PpOoPc61OANJ5wVXnu0XkDgNakZmvsxqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721606165; c=relaxed/simple;
	bh=SDxfwvN5MYWKJql3tfLQSbljebylLV0cFEboMtlM0oI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=tqdoAPjmkjsfgojKfA+Ir7mMhgkik7o5CCpKz5PAoqJFvlf2ntyZKMeOW+sQ82lfWlZKKOURxuJLyzlkEJU+HtMX056PjWvNdM2abgL1ZwVJeCojb33zJvPIlkXcOgtFNG507qrQxIn3XNAyeeXJYF52tSGwyHIw14qez6Bvm/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ck3id8NE; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ck3id8NE"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52efd855adbso1487758e87.2;
        Sun, 21 Jul 2024 16:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721606162; x=1722210962; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ho3lNX5DgXmefg8XZbmlAgS8rWeM9YeYeOXFWYM+M6g=;
        b=ck3id8NEMpR7sCfFLXf5wAgMdY45h3oYrZ++D5ZUMeSvhItGbrbSh/OqFw1SmVNVcr
         MRRPVbmyr/xw/8tlwssa3ZrOoz4DS/HS2eWOV4hj9q3NghawoegHqBLItVRqpUzcnZgB
         JfHRso8fGebxh8tCd5DX2Zph624l0ynKV6wFFBXAjfwnKueVbvF6+VStShnW2Q8mQYWu
         vq9fQ7RADVUUx/dmj1N/gorek9OBMH/3C6Gu6jtUVB74bKNksNrQqFHAlClIEiVgjbaR
         1q0p7yYID3BiYTZVfAWPNrQn6OjZ9DKpeVhZEOe/OnXUIGaTHJLCh6XcFjCIRFUBS8OW
         lO/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721606162; x=1722210962;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ho3lNX5DgXmefg8XZbmlAgS8rWeM9YeYeOXFWYM+M6g=;
        b=OSKH3kzwWKajaiO0m2dj+YwZjNJvae1roj0cqFShJ5UC9ppH+hj1CNTVnHfh4hM6eH
         yjY+e6DXBAnDuLFriLx699wSN1PnE16rJuFg+HQnqCddTvWiCbxfRp02bMG8X9r51QbH
         zON1ugt+PpjqxXVu81WFYlK3/l9MuPpw50N8eSwqBYJuPMGKgeH7hidV/7GszOQbWv+6
         Gv86IsXyc50dA5nUY5mpt9vriBFaAKCR9rzi6QsCGJE4q9Z7EDIRpQpboHlvgAkUx/3f
         bsdoJ4Nm/lzw7VNze9ancXC9xnjTrQll1M1MITvXLOE0dKUjXkaiZaICLbD3kGw1qtkK
         JhRw==
X-Forwarded-Encrypted: i=1; AJvYcCW1SWRzRCLvXNfCgXWbQITYGD9omyKMMr99HAW/2D9cDP6ZVj/cCoS98ZdS/NcWDjNmwXd6KBU9B3//tMXrJK7aUr6+zl8vqxgOpm7D
X-Gm-Message-State: AOJu0YyoSWvUVRE+QZaDPYeQ2kcZaycbZ/CdLrbvXLouxKDXV6cB+J5x
	SXkqs2Vo0fGHcwT2xCt72Cr5P+XKvCXZHfB2i7iPpunAsaSCKHNlqDn8ZmzoImruNjt8hfWPjYV
	tM3MBwOh8kDuE8gOWhA0d4g08zOg+8Xrs
X-Google-Smtp-Source: AGHT+IGt19agWG9X6vxWlI7KcZy/yXiwUcEbUJ8atPcaMiXwt2ieQ1OwcqQYKP1/wdubHVuUEzNMGHhuyjDq6MP+ELk=
X-Received: by 2002:a05:6512:3d1a:b0:52e:faf0:40c with SMTP id
 2adb3069b0e04-52efb52e9e8mr3165474e87.3.1721606162155; Sun, 21 Jul 2024
 16:56:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 21 Jul 2024 18:55:51 -0500
Message-ID: <CAH2r5mvap+qkuW-vOa--d+hsqEfhmFcpFWfaL6W1vAWjjR==5g@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
0c3836482481200ead7b416ca80c68a29cfdaabd:

  Linux 6.10 (2024-07-14 15:43:32 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.11-rc-smb3-server-fixes

for you to fetch changes up to d484d621d40f4a8b8959008802d79bef3609641b:

  ksmbd: add durable scavenger timer (2024-07-14 21:45:40 -0500)

----------------------------------------------------------------
four ksmbd server fixes
- two durable handle improvements
- two small cleanup patches
----------------------------------------------------------------
ChenXiaoSong (1):
      ksmbd: remove duplicate SMB2 Oplock levels definitions

Christophe JAILLET (1):
      ksmbd: Constify struct ksmbd_transport_ops

Namjae Jeon (2):
      ksmbd: avoid reclaiming expired durable opens by the client
      ksmbd: add durable scavenger timer

 fs/smb/server/connection.h        |   4 +-
 fs/smb/server/mgmt/user_session.c |   2 +
 fs/smb/server/oplock.h            |   7 ---
 fs/smb/server/server.c            |   1 +
 fs/smb/server/server.h            |   1 +
 fs/smb/server/smb2pdu.c           |   2 +-
 fs/smb/server/smb2pdu.h           |   2 +
 fs/smb/server/transport_rdma.c    |   4 +-
 fs/smb/server/transport_tcp.c     |   4 +-
 fs/smb/server/vfs_cache.c         | 173
++++++++++++++++++++++++++++++++++++++++++++++--
 fs/smb/server/vfs_cache.h         |   3 +
 11 files changed, 183 insertions(+), 20 deletions(-)

-- 
Thanks,

Steve
