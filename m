Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5443E9594
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 15:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776179491; cv=pass; b=p9CeitQKxmhM+GEWPUp+FYYWaEuiFF+7lL1iO1PI5vxwVRkd6/jfvv9KFAWGTgGQL6Jgge/uKuE6v4AY0Eq+oJLeHsjAQGNGneRVuCwXDxVJhvB6lNthSSQO8Evit2lhZvqKC5vfmG8uEmVK/Zs3x5YOjkhvXq2UmwQmcEKVGeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776179491; c=relaxed/simple;
	bh=EUV2Y8t2ofLmWHno5itkusuIaaU6Q8lOo/IzO2NA69M=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=T3NFR/C+fmvrN2NIsCgLfFxvEnY2/y4VUjwfaOO/HDB5S5imNib3JuzoJ+Yeuk8O2bt6idXmi1Y8cg64Bh1xRK+wURUqKUBrlrQEd9H7eZqZMGvrt6rZEOIt6Dq1uBJcHGzBQDH9ydvkLAga3vj43NrquBAsm0XBxyg7zkMMyVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mKh94+bs; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mKh94+bs"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-89f1e767f92so45826096d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 08:11:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776179489; cv=none;
        d=google.com; s=arc-20240605;
        b=LR5PM85I2MzfS2dDpINVt6rRNl9/CNCt4nSzN9QhRmK+E/Sw9Rsgy+sL+JdBtuSejy
         2hOeM2EuHhbhM66uKbYjDyvYpufxTLfZOf5yf3/u0RxkKlbU2Id3FMUtRX3n+KxdZ875
         HETf5kEEJL7OqJYnDEbtsPR1s4A8Tvpwncqm44GBdwZP1K2HSzXPikeL+P4z+wNsjD9Y
         QYKKY3btQGlRWeKVtR7fPMl4jshM9l8RHvR+zZqj/dR27At677Ulb6w92YvRrSW+DAO/
         t7ZMXshFsAJuAqropnyMUgvjDwmp/e5M3i7ocYc0zpcu808kQrgmGQVzQMzYj+nFYoOb
         IKzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=A1ajaM+/PnY/fU7hrvyz0d97ujY4aWU6AnpQt8m7U4Y=;
        fh=tWoD56v9lZXV68C4JTYPGibInU1bVIcDz+RLhwxXIsI=;
        b=ggkrPXB6dX7NIoHm0fNlyNjd39Z0ScV8VETQ2TyzFYWRvedIvWRsxf2GBf9TroB9xJ
         svVo5T10HJyg3p+aOFiUYcOfvQXAsMe9T8PzkDrGBtOQvll1oDIAS9SBrWUI4/zctn4C
         3Cua4TKRfhceZBoJHp4CGtCisYTg2vFt1eRoU3s2BtEGHMKr5jkSaqXk4Z+k6R4S0ryl
         rDN3f2RqRKaqusAd7GeJ5StdzP+ihsPFlBkummHCBoCuw3gMPcv9E2HS2hivnNvXLnFf
         x5YggXqwUsLuYBOlc6SBdCnWdm/nfa4Yq7sf0AonxtEJeR3fvihfsptc6pg6EHYsARaw
         bwzA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776179489; x=1776784289; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A1ajaM+/PnY/fU7hrvyz0d97ujY4aWU6AnpQt8m7U4Y=;
        b=mKh94+bs5eXxgSuvtv5uOZepf12AcbGCjciBwwhx8bwLcbwm6ier2X0nZS2Zgsl+yS
         c3JY8neOsTSckpAn69hudUiFDYps0o8je05NS2M7UP6n45d/y4Gbr77MRIPcfYSyoyq6
         vspakuYTbZmp7pmWdC0JCH9rmy/boseGsybQZjqWwOkCtdrot713l4FLOwvaAdU4CkFy
         8PP8OwcDK4XCrwGxwn1m8wd/arOKatTO0va1gxImXwwuHvMNX9SQIrodJUum/F7avaZn
         0zoCr7J5IINqrPfoT8FTa0UjiUwD1MEkKxgzK5MJJXp+E5yZbcpmq8QfvEDrakQmzOFe
         HVaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776179489; x=1776784289;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A1ajaM+/PnY/fU7hrvyz0d97ujY4aWU6AnpQt8m7U4Y=;
        b=eqtVxXDBcd3943p4n6piN3uI6iAKLLOGBY7FB4y/wZVgDwrBnl9qTEUOJQ6ryvAB2Q
         3liei9vGyNMHhZSQlyLlXHXbtTI/IIWOjCInWh9r0XGI45ktBRfQBmh0VlbBaZ+hz5jU
         yYhfPYrqcH/Wue3yYKCMkGiNjq9wG4fjXxmLGMRVfrA6tR9aOdIHVa5wOlGs92NgAWJK
         3uGgBkJ54/cLaTeUxhah2gUMrQFmHO4XRfyI3TErrjmwojtzUD7EwIj18SM+h0k3zmEH
         An/w9k2dLU/IB8B+FyWDerjXcWK6w/YR4clQZADTSaFpNqYQ1BGdjzQtu3W/vpRqVALK
         Vn4g==
X-Forwarded-Encrypted: i=1; AFNElJ8s5Q5AL9Gj4jP2l4plx1rNogBC5kKtljpXD8IpPV7EPTg1Au4lyTBMajtvH4tWi2L1Fa21Tid1z037@vger.kernel.org
X-Gm-Message-State: AOJu0YxN9wx2qIhrRqZ0BZ2wSoaQTnkyceYQocxdcB+3nWwLZjabFn2u
	isgVEsMxzJfm7gS5Bu+F0dYMWX8PSUNaJg7R9hlrtheppfHpYGqrdePZJ3M9w/gAoLW+fCaPSA6
	Is//Uuf5QrXbEhQ/BWh2xO48f4N5hMRbX/vEo
X-Gm-Gg: AeBDievV4WW1YJW5S1M2pTXK7tyih+LMPpUrAXnsbLsBbzGSbsgjOhBrfjwdK9oSINw
	e0CGroYYckNzyFOg2Mm6VIitu/v9lON8Q0yS0RBDNGVlcZmCVsu1EonTD5oIOsJaP5KT05EZT13
	d40GtC3Zi2+cHwycQb5nMVyJpO8ofO1595odBdo25oGUPxgNnZw7fKKTOf7qyyXORLCPuapAjY8
	gPqeffsKhiJJTGa7FS7YbqsVjcjM4w9q+TbzU/tyRRB+MsKGVgJhgh4grlKzkgLdG8GcOhz6tdd
	8S6DWuFulIviXbR9mreGz9LgXFzfoEFxfScbE5mhNLzbxbMxZne6FDej6ZsVxUEnuIpssa/ArY5
	dpB7FdB9XmZP0E5X/Vjm0oSG5Vq18F7AMrP3fgGU0bIyGqyu0yXi3mVRMuk/IQdrzUXqaCfAXJK
	Gub10uOLDP3+P+TDWN0BqOcwfXv4Z2LMfx
X-Received: by 2002:a05:6214:500b:b0:8ae:5f29:effc with SMTP id
 6a1803df08f44-8ae5f29f37emr37980346d6.54.1776179488780; Tue, 14 Apr 2026
 08:11:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 14 Apr 2026 10:11:11 -0500
X-Gm-Features: AQROBzBzXQFcfbrPjPOKmUK0Gvc29I8_N9GT5RGdooO7YRFSlobvu4ndN8EqCuc
Message-ID: <CAH2r5mtZvz3OW5V_H8Q+mxvY5xeaNb4JVhCxz9ZsUj1FiEGXkA@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
028ef9c96e96197026887c0f092424679298aae8:

  Linux 7.0 (2026-04-12 13:48:06 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.1-rc-part1-ksmbd-srv-fixes

for you to fetch changes up to 2de35d992ba1e4017ec21cde06a85ca7fca94810:

  smb: smbdirect: add some logging to
SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}() (2026-04-12 18:07:55 -0500)

----------------------------------------------------------------
Sixteen ksmbd server fixes
- two smbdirect double free fixes
- Add some smbdirect logging
- Minor cleanup in crypto, and smbdirect and in IPC handling
- Minor cleanup to move header info to common FSCC code
- Fix crypt message use after free
- Fix memory leak in session setup
- Fix for DACL parsing
- FIx EA name length validation
- Reconnect fix
- Fix use after free in close

I will send the larger set of smbdirect restructuring
and cleanup changesets later this week.
----------------------------------------------------------------
Eric Biggers (1):
      ksmbd: Remove unnecessary selection of CRYPTO_ECB

Greg Kroah-Hartman (3):
      ksmbd: validate EaNameLength in smb2_get_ea()
      ksmbd: require 3 sub-authorities before reading sub_auth[2]
      ksmbd: fix mechToken leak when SPNEGO decode fails after token alloc

Joshua Klinesmith (1):
      ksmbd: fix use-after-free from async crypto on Qualcomm crypto engine

Namjae Jeon (2):
      ksmbd: fix use-after-free in __ksmbd_close_fd() via durable scavenger
      ksmbd: validate owner of durable handle on reconnect

Rosen Penev (1):
      ksmbd: ipc: use kzalloc_flex and __counted_by

Stefan Metzmacher (5):
      smb: client: avoid double-free in smbd_free_send_io() after
smbd_send_batch_flush()
      smb: server: avoid double-free in smb_direct_free_sendmsg after
smb_direct_flush_send_list()
      smb: smbdirect: let smbdirect.h include #include <linux/types.h>
      smb: smbdirect: introduce smbdirect_socket.logging infrastructure
      smb: smbdirect: add some logging to
SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()

ZhangGuoDong (3):
      smb: move some definitions from common/smb2pdu.h into common/fscc.h
      smb: move file_basic_info into common/fscc.h
      smb: move filesystem_vol_info into common/fscc.h

-- 
Thanks,

Steve
