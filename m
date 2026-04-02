Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A923009F6
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 18:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775156200; cv=pass; b=btpQ0I6hIxJ5StLWfAiWeTIbKWNTXMyE3hktgI7GXFyyLehT9FbmIFLaxy5pfhJgPj2c1wCD7C1F/uOti9OMq8orTL3d3KPOgGLue+iP2Z4b8I/yE/X2740AN0RyXckQd/fTsqLsZHoaiwQAvpMzSiUqe8G7dzqRgZadTBbeMXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775156200; c=relaxed/simple;
	bh=1HpgnGd4EKh4ich+UIQHc16R0loLO7jWknV1D2NYGkI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=XK/MmWoH3l0QWF+zH6B5siYbsf1nHh1bYlBZ+13qjvq8dan6FHKvKPPBSIcw0rNR6sOTKGYUkn1YaaIL7lKZIBdCcBKA688zDBrEQnL9mtNYmxF8XLuU0p0f4lgnXbV0qF2YDaB60HMSY/U4jEsNPxbR6Y/CqEQu4V/Z5xLJbIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RrixXfy3; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RrixXfy3"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8a08fa355a1so17051226d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 02 Apr 2026 11:56:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775156199; cv=none;
        d=google.com; s=arc-20240605;
        b=d2P8PTHuHkuv+19KM7pPDs8R3EMi2QnBRYR9w7J1OojAgKFrEFdNJLRhP59BtJrCd0
         4eK/YpRHEuJ5XOZqKaBkxx7j9VQujI/ppXnJSna/EnhL/AvUmBKTMM5PbJ1/mhg50hgg
         doJQeRlXWGCZgnRa2BHFsmDUeorHS0cmOJoM1FxCmPztQOXM2/3IuKNvVP4lnYt6C7+C
         5NpVOIdKF3p3dVkIbXn3nK7bXArc35rSXE8NNeV8Lyz45DOfrkTaB1IMYz8P8JmMrZKg
         9MzHDLLD4m2f/s5iC3jzVIyXhVFpyJM/E3hGreVXFo81sN6/X8nzw44hbiYVvy1qy842
         zJLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=CnCgU6dvtuUomPyZPzeZi/EAQVgtCv4P0b+Grry7b8g=;
        fh=xLsiidLQxgtwXG/6R1rXvHrae07E+dz2rEVTtboTCls=;
        b=iEWqVDz9gH23mBXnvPsfl68ShpqJxP03yJEOzukDM/BKK5/XCPl+DltudpuzsaysRZ
         md4QilyNjhdbh5j4AoukElLG2Hm2tYRgcQZ9NxmK6md+pRsAgzBy5gLr8+CdZNa3a3Dd
         8NxMR3iELkDvHFNof/q70b5hG0xUFTyI32+tNYbB0LSAlRCc4cwyUGv6z5IqFSw2CfQX
         KZfgeSojLiEJBMidvI6mVn2w2B36MGExjhpXHiq2SNZp56dV2vyoJZ4LpRebt0H7lNer
         z7YT6alA0MiEmCd29/S8YpYMHZSmDoArgMamS42A+UddJ/aCTx5o2CDcrzquLd5ztXOV
         QoGw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775156199; x=1775760999; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CnCgU6dvtuUomPyZPzeZi/EAQVgtCv4P0b+Grry7b8g=;
        b=RrixXfy33TLRifPieudf8BDSnoOU6bGRyZhtxJ1iYF75MHcb4gQPdzmONNOD2stBXF
         aHIidV9QSRoMAjxCW6PsYtTu/okVQOWLr7L8PYpRQN6I9Fym7hcdiehKXyf6f5wI+fQl
         bW8Fv6NAI/RaA7dwAgQ445i/GwrPEn+rpIJoqr+JT2PmySwCXuS9UShPvdunp7+BVHF0
         /WzRUeFcxOmFixJiwUy6dVoJmWeYscHSmgK+t6X4Q/I1stRRt8vnkb4PiHm1RNpa3edm
         ++N/3U+1K4iymL+9feihUYjy42a+yO8a6ofyybn496r0I4LNDaD3aoFR2WF7bnTflDer
         F6bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775156199; x=1775760999;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CnCgU6dvtuUomPyZPzeZi/EAQVgtCv4P0b+Grry7b8g=;
        b=IjJRkoY4BiNMKJGP6bFw8pzMBSVm1tKQWGKNbftWnU4qgEoD8ZhhI72uPHh5t8x+n8
         QIyXjuoe1+aT4+oQWFRpNzuR63ggWYmjicPwovTJvRoVHlca3Wkhila+Wx5k39fn3EVh
         YbrDyWvC4v2ZbHsnCHf4CYC302L4kfLHOqPmS0HsVfVIXMzbEs/jREMoCw6tXJXfLV20
         ShAYJd9I6BHGP9EQrOKBxHs/EBnqkP4wQpjzRDXAJ836LxIHOvgXov7Rm4b0qwnjmxnF
         +m6Z3uTbZGtO4FmVKDMd7Ah/oPWojsYlJyQpzakAvmuJnFHGRf3BuKD9kpf4Wvdw52Di
         dcUA==
X-Forwarded-Encrypted: i=1; AJvYcCWDUuNxzxjaxgX3OgjrO48KPPDTm+ue7WE7Tgq0ilBnmjxhACyw2I9LmRrQkNKTTaSndBpeIIM2f0lJ@vger.kernel.org
X-Gm-Message-State: AOJu0YyQfmThM5d4AKh1hkg028uXB8g2tYRHLDrIcBC63YdBwotX/jb/
	XZjY5m3FXsvb+tC021ASEc5vYi5xtIiGyA04isJFK71r7ilIcUWRMJ0srhgH6e8oaJn2NsPaJHB
	IY/eJk0wTSC1ZT1HJIWIE8r0Jnbho0OE=
X-Gm-Gg: AeBDievGvgl9mozJq8XwoiHqRgeAwsW6hUgEuM+wisLkcYsR5Kg68SRNZ08/Xh9deCq
	VQaZ/fW+kT4K9ZVuMT+nukW7/MAff4PHWIc197JRoGSAXyiC5ORy6moLKP3aUpp3D3dJR12yCy5
	YIwTxZM8VLXbqPdy7Biz2jDDxuXDqaGshBBBfy/UHoBsS170DM9ME6uUv2+PNJG+IUyAEnrvds5
	IHIJXOcC3BMX3pvBmZij7XAhfCctvz4ZlToYpeupJH4+on/rbbhbufPi2f/X0WNXdJpdzmziAD0
	14DcY75vA/UUOIG6/fmxt0ZGjbB1XVET8sKfaGSwRzD+Z+N6evOQ86Y19McLeI6hfkEnc277WKs
	TtG8B6CFW8tgyyfccixh1/kgo1/ULbSSiptWjMcL/nIqBfmZQbEHH+0ftPbcIZVCK/A8lZgLyfJ
	fc5FZS9VAl/JqUI7MLMgUl
X-Received: by 2002:a05:6214:5992:b0:89c:e5cc:9bbe with SMTP id
 6a1803df08f44-8a70345d54dmr5857146d6.24.1775156198667; Thu, 02 Apr 2026
 11:56:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 2 Apr 2026 13:56:27 -0500
X-Gm-Features: AQROBzCfOW90hj_Z2R7GMBh7v4ajOj4fwNwoqZPE94KC1hxt3kNX_sffiZPkq7c
Message-ID: <CAH2r5muNKQXCpS0dPuXi0jyA8KeT+UNjc+LYvRJWjuY3Sh34FQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
7aaa8047eafd0bd628065b15757d9b48c5f9c07d:

  Linux 7.0-rc6 (2026-03-29 15:40:00 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.0-rc6-ksmbd-server-fix

for you to fetch changes up to fda9522ed6afaec45cabc198d8492270c394c7bc:

  ksmbd: fix OOB write in QUERY_INFO for compound requests (2026-03-29
22:07:45 -0500)

----------------------------------------------------------------
ksmbd server fix
- Fix out of bound write
----------------------------------------------------------------
Asim Viladi Oglu Manizada (1):
      ksmbd: fix OOB write in QUERY_INFO for compound requests

 fs/smb/server/smb2pdu.c | 121 +++++++++++++++++++++++++++++++++++-------------
 fs/smb/server/smbacl.c  |  43 +++++++++++++++++
 fs/smb/server/smbacl.h  |   2 +
 3 files changed, 134 insertions(+), 32 deletions(-)

-- 
Thanks,

Steve
