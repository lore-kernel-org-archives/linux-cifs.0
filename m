Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F7D230BCE;
	Fri, 27 Jun 2025 23:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751066371; cv=none; b=HK6wuBCDC4LqjAxn4I34EM0Ht7/Kykn/8XZa6DxqU5bEd0cW9SdOZXPv5slwhefz+q5lY5fbgGSvoyjTqLaQ77Beu5XogoiMRvgEWste+oyad1+vcV5LFEt2Sc/MF/zSpmXFkOHuZzWSFHbPYU6+fTGW/4fngVRohLd0bMTfi1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751066371; c=relaxed/simple;
	bh=cggULdMle2TeJAoxTMS1tcuLG5g3D1w+m7hLKIg0EmU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Z2NMckfP59QhNuf8OSNVWpqqqgqFfZkGgjtyWSJagJtke+L4ZSy42QyeHp3d56cRLRjMnRUWkNCoSuZWjm+No6WqdVNLGqNHJCTHpCj4bDreRa5Fu4WqrMXJzJPFt7+5PzuVBva7N77gxE7o9k1an09qDjYWDcpUo94sOl4YRWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D57I+98n; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D57I+98n"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7d3efcb9bd6so254551385a.1;
        Fri, 27 Jun 2025 16:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751066368; x=1751671168; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LtGn7JEXF3zMF7k6UE9h1fA9eDoP/JvwC3ZRU+1yFw4=;
        b=D57I+98nrFlaAc2wNCdpwy2SjNvjBThryyTB4ocArNOfagD5IRnAwltkqoaXGDz/q6
         ZTf1+0gYciA3Vvu1nhnucTNcR1OAkCK8urM5+xeW6CNVs6vBUtfB+ZUWrPDimP1OQ3J/
         idgeYnm3nbdHwrQfjMS6aC+HQqeYS9JM/Pty6v1hMQiQHNGwm4XZFlgBp54otfsuAm/A
         AeKXVu2+BzsEhz0MaHG1O0sTTht6Nr5yBWdxlp25TY5U0L2hbcqFxUGZHJjat88+JDmt
         ux4xo/VtuOFkRjqH2Fe8e96eLmsSjHt2s/Tn26ApRWTE4AbvVWBC6Ee2xS3UXqKm3wHf
         WsPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751066368; x=1751671168;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LtGn7JEXF3zMF7k6UE9h1fA9eDoP/JvwC3ZRU+1yFw4=;
        b=D4SyXuhsYkH2oHSbKuCTodqh0teR/05Xk/BlFaIUyjTdRhSY85ANdkBKzNiYK+z9Ei
         slg4yVWp+lUvtl/XlHCYQK03r7f5l1v5HTveHexzDixijv+LQAi73Ky1FXPqXQ8Vw90e
         J0fytMn4zmtmTuLx8SGKoezlPOddQI6AdlRpErsTV1uaWKhTUtwd0Hqjs5fgHK00umG9
         X6JTjuqyXkl309dM7A2oC9kjC2YeAbdm+iJTJz2QKSwJxu7fico2QCzY/GjCAgCT6VLk
         MF4P0RKtVEGSwOHjeekw4hTF8Qo9/Tcp7ILmzXBJLYpupNd1ssKgAh6IfQMKE9HnP45K
         pl/w==
X-Forwarded-Encrypted: i=1; AJvYcCXOpxAFSDbNB3CnY6y4zYe8/wD2wXnpS6CCi5gIEtch/aN2b1/2tsa2yh4ZE9h3ELpaARpFsp46PYyR@vger.kernel.org
X-Gm-Message-State: AOJu0YxO6ZlwokKm05xnP1wIrQde0+cjy2mbMW44pNh72virmy3QnQwi
	W91cn90zOqCnsfQ68g0OQVa6/FtAayXGYyEf3GOJmTB081ljEnz3X44zy74PThRjHo2y9dBvM48
	2uPfaQtytjYWSDpHn6Aw3Uym7HZMLqjY=
X-Gm-Gg: ASbGncvXMEDang1dRw3qPG9nhtMaOJntH37VfrAYwscoqzNOIoestoRIyWW1VsRfcFJ
	icUn6Bb1dPcMBvaqUaTnsRrJMUfgscA5Om7kKWPiqVwAZ2h3eC54QRQisvs6Qb3RuEte4CXZ66d
	5wUpHFV9KFdJfKf1VpB7IeabP7fjwJ2wFUjcFIgXzdSH6oqqI50M5Laqi9Gf7STPeIWpMkmIKBN
	2AY
X-Google-Smtp-Source: AGHT+IHqoqXQJ+s8V09pQDz+Xdi40YWaoSJ7Bph5bxs/p+DKiDqKUgVpC7sywebID2PHaH/1MsDqjMZ4CRmPXE7F5Ak=
X-Received: by 2002:a05:620a:3946:b0:7d3:a66d:4f3c with SMTP id
 af79cd13be357-7d443920b10mr778910985a.7.1751066368288; Fri, 27 Jun 2025
 16:19:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 27 Jun 2025 18:19:17 -0500
X-Gm-Features: Ac12FXwM05RZ36BGrQzXn07BpzLXCYfL5pKs7_ueaLKjdT_p9qB1HjlLBAC7lqc
Message-ID: <CAH2r5muAE5KvodJSk9VuFOF1fAHWPdnG3NsSgOZONqge06k65g@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
86731a2a651e58953fc949573895f2fa6d456841:

  Linux 6.16-rc3 (2025-06-22 13:30:08 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc3-smb3-client-fixes

for you to fetch changes up to 263debecb4aa7cec0a86487e6f409814f6194a21:

  cifs: Fix reading into an ITER_FOLIOQ from the smbdirect code
(2025-06-26 11:13:16 -0500)

----------------------------------------------------------------
Six smb3 client fixes
- Multichannel reconnect lock ordering deadlock fix
- Fix for regression in handling native Windows symlinks
- 3 smbdirect fixes: one for oops in RDMA response processing,
   one for handling smbdirect memcpy issue,, fix smbdirect regression
with large writes
   (smbdirect test cases now all passing)
- Fix for "FAILED_TO_PARSE" warning in trace-cmd report output

It does not include the fixes for the recent netfs regression causing
cifs mount hangs
since those have dependencies on Christian's VFS branch so will need
to go through him.
----------------------------------------------------------------
David Howells (2):
      cifs: Fix the smbd_response slab to allow usercopy
      cifs: Fix reading into an ITER_FOLIOQ from the smbdirect code

Paulo Alcantara (2):
      smb: client: fix regression with native SMB symlinks
      smb: client: fix potential deadlock when reconnecting channels

Stefan Metzmacher (2):
      smb: client: let smbd_post_send_iter() respect the peers
max_send_size and transmit all data
      smb: client: remove \t from TP_printk statements

 fs/smb/client/cifsglob.h  |   1 +
 fs/smb/client/connect.c   |  58 ++++++++++-------
 fs/smb/client/reparse.c   |  20 ++----
 fs/smb/client/smbdirect.c | 161 +++++++++++++++++------------------------------
 fs/smb/client/trace.h     |  24 +++----
 5 files changed, 110 insertions(+), 154 deletions(-)

-- 
Thanks,

Steve
