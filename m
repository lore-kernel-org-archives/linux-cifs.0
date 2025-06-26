Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FE6175A5
	for <linux-cifs@vger.kernel.org>; Thu, 26 Jun 2025 03:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750907164; cv=none; b=qJGMSwrOakH0cn8h0XsjEYP7Shr4f11WxfbA0JNq3FWX/IF4NVIacAbtqi128+DnUnOloGUGkkin3thrCTXhclnDljP51voMFufiY9MZe+//uZ1rNamXkcJKnz/Ik5HhmFH81Ll477WF0kzwNEu4dbKnkRMcHCq7P3pJuDMP2Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750907164; c=relaxed/simple;
	bh=NiNmbK1/Hxwmq5jTtjC07hNGtru+Bz8bDoDsGjn2xLI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WNc0niSzHHFzZDVvBhe/iRM7OhAeM6+4M7RTqvNKrKP0BZS4lMKBSCCzXWr/V7KV67HJvvVcRzdvi8h/ZTbmiT/agQEmNS4yQUfj4gVFpD3LENKhhCJOLgtsUEOi2S5tUTLpotHn+7PHgdR+/0MnX4Ki1WXDYEm8aRhRNANWYv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j1Gf30ze; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j1Gf30ze"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6fd0a91ae98so4389516d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 25 Jun 2025 20:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750907161; x=1751511961; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0VmKdU3ZULm2SxlF0XYLD+OrJov0BrOIxYsw/ncOyCw=;
        b=j1Gf30zeWyRTB8P3WHzYJZyt7oQCZvVIAxIdscJnREN83L+x7d0r0nt3JI5J3nyh+W
         McvoAKSa0GW4RBh6jQErSmKC+RPKgmnCxVUtvd2JMsVJ6b+h0I8ZqcwnK79FFABUYPcL
         V+gGo2ISuN+P7B6WlSFVc3LNiyPSK94Mslc6ETIKELvv5pHDQqTdDqQza6433cJFSHRy
         UiYCYJw2tYdjTexvskDgO4rDyOBppnr73Mn1p0Jc9Xy2Vyuy2YS9Ikxe8T5n9VEuJ6mL
         LD2Zam7ymN1WpZhk77xR/EV6BIyN6P6Ad/VchoWXPNsXrxnrzPkNYixkqpEhVsy9iERC
         GsUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750907161; x=1751511961;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0VmKdU3ZULm2SxlF0XYLD+OrJov0BrOIxYsw/ncOyCw=;
        b=SWne2M9m+kB1IYoAmrJgFFVlLNi2OGWL50ZYcVg5Bmt0GNaAv6vKd8Qn9bt8VMAj9p
         DUwJup2elR/vk8gBa+ZUkoS5SYxS0T445/d0aKqr2Poo3LrL7LINMVN1VROLM6n4WmUa
         Cw++dWh4ZLlpZZrUaEOaRZpXt46ZgNu3hsIE5M4qBFJrkqhU/VieNpFWyz5x61eLaxh5
         tVoNewyySYVXi5FkMbEqX+6eFpZwVN27R4qmy3KERanDaA9ee1GzwoUCo3tN8PQI4yOZ
         thn2ODT4t3oejq6IwGyDt2Xv05DDPXVrsebk4GDG4qdy++1UDAm2rF5P0/cm+3XEJjgm
         mxgA==
X-Gm-Message-State: AOJu0YwlI0kqXfQisCgXkY3On4jJr/GsBAHVfBSIOKq8Np6TWO2v9s1C
	cXYC7QQt0t1sfqc6EMS/7rV9j91OfqmuOjO8LDEBsKuMX5m7DjZHOJwtbHIonYSPU8mpaKwtzt/
	CNJumFapZU2SsBa2XamGq2F4dzrfk3GE=
X-Gm-Gg: ASbGncv6CAXg8i01M4ahJwwHEMeTHA5zy0GvWVkpFGg5N/iOU3nEzlYivNQEUOc7nAS
	/PxnuOB//Cgq9QxQ9wtfI2la4QtLwBMARfor+dGEWNFSngpFn3atxqwaCBuYL9Ty+/IwoTdn8V2
	WBYR1a96eHH25esusS0w3HOiQ9HMcZM69yClvPD64Ehlmn4N/P3GIxmsnGx5nOppzNkanmbjvhJ
	y7cJA==
X-Google-Smtp-Source: AGHT+IHGgRDCWko2TLWTi8pLSci5ZN8+mznhzrvNYwtQsnBkxPmY64N06I3BX3GKSLy3bBry0XmjfCwZvJ6mlYzD/K4=
X-Received: by 2002:ad4:5ae7:0:b0:6fb:4954:846a with SMTP id
 6a1803df08f44-6fd5ef2aef3mr83043856d6.3.1750907161416; Wed, 25 Jun 2025
 20:06:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mvHYB91=HU2NMUbinpXTWzKq82RXhRMiAPwSa-u5c6x7g@mail.gmail.com>
In-Reply-To: <CAH2r5mvHYB91=HU2NMUbinpXTWzKq82RXhRMiAPwSa-u5c6x7g@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 25 Jun 2025 22:05:49 -0500
X-Gm-Features: Ac12FXwb2S3y1TLze86gfk930AjlhWPdCvESe4xVf3CO970K74Asbf39_Ydkliw
Message-ID: <CAH2r5ms2xfU0dSrkLbVUKsN5mH1r0re=6134oH4eETtqYOLaUg@mail.gmail.com>
Subject: Re: build warning with [PATCH] smb: client: set missing retry flag in
 cifs_readv callback
To: Paulo Alcantara <pc@manguebit.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, David Howells <dhowells@redhat.com>, 
	Shyam Prasad <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I also get the same warning building with David Howell's netfs-fixes branch=
:

connect.c:144:1: warning: context imbalance in
'cifs_signal_cifsd_for_reconnect' - wrong count at exit

dc9b2fe5f874 (HEAD -> netfs-fixes, origin/netfs-fixes) netfs: Update
tracepoints in a number of ways
4d2f067052f8 netfs: Renumber the NETFS_RREQ_* flags to make traces
easier to read
9ee1c1860c95 smb: client: fix potential deadlock when reconnecting channels
ecd66e4e1009 cifs: Fix reading into an ITER_FOLIOQ from the smbdirect code
7aea400b3ab2 cifs: Fix the smbd_reponse slab to allow usercopy
db6c446f962b smb: client: let smbd_post_send_iter() respect the peers
max_send_size and transmit all data
e7878f222221 smb: client: fix warning when reconnecting channel
9006c79c12bd smb: client: fix regression with native SMB symlinks
ac6518c40791 smb: client: set missing retry flag in cifs_writev_callback()
79548ed9b3b5 smb: client: set missing retry flag in cifs_readv_callback()
020ea6c76c4e smb: client: set missing retry flag in smb2_writev_callback()
5a2221d576f1 netfs: Fix ref leak on inserted extra subreq in write retry
b2e88c77791d netfs: Fix looping in wait functions
5a5ec8260ee9 netfs: Provide helpers to perform NETFS_RREQ_IN_PROGRESS
flag wangling
4a5175d393e3 netfs: Put double put of request
76a8fb1fdfd4 netfs: Fix hang due to missing case in final DIO read
result collection
86731a2a651e (tag: v6.16-rc3) Linux 6.16-rc3

On Wed, Jun 25, 2025 at 10:02=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> I get the following build warning with the patch:
>
> connect.c:144:1: warning: context imbalance in
> 'cifs_signal_cifsd_for_reconnect' - wrong count at exit
>
>
> commit 8596d54298d3170badcfda1175499ad3af240d09 (HEAD -> for-next,
> tmp-fn-6-25-25)
> Author: Paulo Alcantara <pc@manguebit.org>
> Date:   Wed Jun 18 15:22:27 2025 -0300
>
>     smb: client: set missing retry flag in cifs_readv_callback()
>
>     Set NETFS_SREQ_NEED_RETRY flag to tell netfslib that the subreq needs
>     to be retried.
>
>     Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
>     Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
>     Signed-off-by: David Howells <dhowells@redhat.com>
>     Cc: Steve French <sfrench@samba.org>
>     Cc: linux-cifs@vger.kernel.org
>     Cc: netfs@lists.linux.dev
>     Signed-off-by: Steve French <stfrench@microsoft.com>
>
> It is built on:
>
> 50fa8c47b1e4 (HEAD -> for-next) smb: client: set missing retry flag in
> smb2_writev_callback()
> 37743a9b6195 netfs: Fix ref leak on inserted extra subreq in write retry
> 3a335ade2c4e netfs: Fix looping in wait functions
> 827cb4d8a936 netfs: Provide helpers to perform NETFS_RREQ_IN_PROGRESS
> flag wangling
> cf9167613953 netfs: Put double put of request
> 0f05eeb631a6 netfs: Fix hang due to missing case in final DIO read
> result collection
> 3556a6e915cf smb: client: fix potential deadlock when reconnecting channe=
ls
> e97f9540ce00 smb: client: remove \t from TP_printk statements
> 1944f6ab4967 smb: client: let smbd_post_send_iter() respect the peers
> max_send_size and transmit all data
> ff8abbd248c1 smb: client: fix regression with native SMB symlinks
> 86731a2a651e (tag: v6.16-rc3) Linux 6.16-rc3
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
