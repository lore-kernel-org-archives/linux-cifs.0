Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4187B1DA58;
	Sat, 15 Jun 2024 15:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718466344; cv=none; b=FZkONmOtWP5Kj3pa7LTSshM0nHZ1fBxSxJe4OdlRtbyRNUSeNqqWUa3ydVH9tWzXPaOfBr3OEEvkoj9krzaJXgU8HbbIYUbR9pg48HQylNGUDezoDdWxBxF3u/pEyQ50KLu8/k3mzY+01yZrMHOWTWrscRJXymxx78nCX+JMtH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718466344; c=relaxed/simple;
	bh=1kRPayDFHcZvea9gXZgxpVL6jouMrK9l2N+Wz42WHsI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Bj+xQHEj0RPQLTiG+LDiDgJ2EYVJUmVqhXNgljx2cCJYAirrfpzQPMM0xVRB21GpPXnxiBneKPa+c0IYNHAd0GlK+3/mHaTuZqEPRBafFn33DXTdzrcCy/0CoaRNPdhEGNU7mw/LdH4bXiqAE8Y2bReOD5Qmjd5XqwPW2hdG7SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bz6N4EfN; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bz6N4EfN"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-52bc035a7ccso3332103e87.2;
        Sat, 15 Jun 2024 08:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718466341; x=1719071141; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O9ZzDkP95fBQv/A5sWHObernfrnOjnFO0+7x+SYK0Ho=;
        b=Bz6N4EfNeojITEm6ALGeWKN32FyLD83agrpbEl0FUCnsu9W9p0/1HTQGLtsmH6m44b
         wjlR27Kzi1lNoSU/3unk9MvSglxOsSQXeRK3q9nAmGv9E9DwTOFhQdkmvoohPQrzEGPs
         5Eh3PlPMMWhuFPXFyWQqKpt75Uf7sPGNEYa1ZoiHQtmBD3Pq8hSHaMXJsRucoDjl2zN4
         eFTGebj3aCoAuILmBuVQHnq+jNEbQWMwmPB0xs/j7CnWQcSKzwemNj6ms6vnNxahGW8X
         nXQ6QBeCJFNFhntRS8hEuCywyqix9JE0hIWqp6hc8wC/ZfO3GLb7fo408/PDkKtD/dLo
         B8Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718466341; x=1719071141;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O9ZzDkP95fBQv/A5sWHObernfrnOjnFO0+7x+SYK0Ho=;
        b=KmWvnBwyWP50GXIXvG5XDyeX0hmos11mJ+nfhy73FDnriXVrQcf6hkewmteoAOtkhc
         V0S1o3LvQj6rOLWocKWloWhGqizG81qdDIhmtUM5B69LestUlxGloEMcRnHl6hMvxcLv
         qUuV8TXEk3Pye9OhDlFqSuRa8IayDo78iqa7NCXIDwye5eIwxdzErU5RTwyEdK5Jc5en
         Hmgrim0zjBuPMqyIDddTXKVwQK8wx7rYdo1eInuiYATcSLHgVARQSDaFqOid4Yj0VfDG
         NAiim1WLLtbn3S28xMmWJA9UlhsjAohTUOqH06P19xpQtVuqftglsH54Uyb89CKatrWu
         36Jw==
X-Forwarded-Encrypted: i=1; AJvYcCXHHZFUBQGEbUg3aUfUUf/TyXleKYexX1iR7GPREoE3WiWTFLJXNwGnwvi2OIgAs+Mnl11TP2pITRWVhGuJ13nCuEOvZL6HZ4BdUw==
X-Gm-Message-State: AOJu0YzMoHp9O954oexdngjDA/teJN1iGurVl/0lKq0o9dJnULXXcECD
	0/zq/owbnM7DdnqpsiYtQ+1imOej8ZbFN4J3TT2zlmwwWkAImCuOpKU7iCFmQOeN7p1ONiJUXXZ
	ghUYDOCG8WICSA7afGMTG8ekZfug=
X-Google-Smtp-Source: AGHT+IG8g+yM7A6PKFI5bI2+Vj1v9gNuoUFieSXKosimY9Wi4bJNS2wWg+gnrlivNNpe6BBB5NaIWLj/XYjBZGnNgxg=
X-Received: by 2002:a19:ca5b:0:b0:52c:999b:52f9 with SMTP id
 2adb3069b0e04-52ca6e987f6mr3128276e87.57.1718466341089; Sat, 15 Jun 2024
 08:45:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 15 Jun 2024 10:45:30 -0500
Message-ID: <CAH2r5mtj61t0AH6wDZ=k=rzGjAuYngLZCTYtw7AMT6ZhJcyWXw@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
83a7eefedc9b56fe7bfeff13b6c7356688ffa670:

  Linux 6.10-rc3 (2024-06-09 14:19:43 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.10-rc3-smb3-server-fixes

for you to fetch changes up to 2bfc4214c69c62da13a9da8e3c3db5539da2ccd3:

  ksmbd: fix missing use of get_write in in smb2_set_ea() (2024-06-11
23:43:09 -0500)

----------------------------------------------------------------
Two small smb3 server fixes
- set xatttr fix
- pathname parsing check fix

----------------------------------------------------------------
Namjae Jeon (2):
      ksmbd: move leading slash check to smb2_get_name()
      ksmbd: fix missing use of get_write in in smb2_set_ea()

 fs/smb/server/smb2pdu.c   | 22 ++++++++++------------
 fs/smb/server/vfs.c       | 17 +++++++++++------
 fs/smb/server/vfs.h       |  3 ++-
 fs/smb/server/vfs_cache.c |  3 ++-
 4 files changed, 25 insertions(+), 20 deletions(-)


-- 
Thanks,

Steve
