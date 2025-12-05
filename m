Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632C61684B4
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 01:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764898622; cv=none; b=cdQ6Zmqx11Stz2q5z+L0pYdJ4tAEANAyVOZFlekDE9VCun9TQJsqGZBDu0rRzuWn79qVQdDxQtm27lJliQSXMbefmY2tXNDJmGQVf/SS3Lb0TGwM4ykzQftTpqASADqGhRo5EOljrGfQs/q6eqRuRe9yqUCJ+RXTxpcg040d2Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764898622; c=relaxed/simple;
	bh=5vlw7fnkIEebqaZGveJqacot8oGRW3PBI81ZGCbhOyE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YmIh0pIjBHe24Ga/1x8rf9Y5iSN8Z/+1Ktpyx6T3SFDk/0feFGCqRgHWlpWOe1esiCs7Lz1ztDNEHJklj3ChUDE5gHQmpQ1dpcEpiUrBN//Dv/iyoEwHCBm87Yp/0rZA5fT+vsLxvKjRMbJ5X20QSj9+EhHdEm6bn7tAk2HHbEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GvFx7l6l; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GvFx7l6l"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8824ce9812cso15349836d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 04 Dec 2025 17:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764898620; x=1765503420; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E+so73SKVthc8eMe6gqiy4aYZWZS/aN0PT3rDfwzKcc=;
        b=GvFx7l6lnpATcXLJ8xqS9BxZ4m0lHgf95L1udIMC9+VrrXskAlN6Mmh2nkr7pVgiNl
         Ivn8govRthAzFM6rcsqGTCXUUa2yPX9VR26oFtiGgs+2WupfnGvTF7QMff4op+Z3xOHG
         T0rN6T3o1wJg0a/SngSA5+Nd3xFa91y1Ms4mLUrFg4LcfO4PUxQ3FNBe6aH8o9fr9iTG
         Y95wduDSOEfV0s9wR0r0ieyhLTsr4JUWxVHAuZXZh51rTNd+dYvwjRvwD9p8AaRymJ+r
         jxxaNXYeaFTGu99RdBJeeE+03RD6v4c50BOsqa+Iyff4HtjFXOieCF7/ESmOmuCCuAEE
         bAOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764898620; x=1765503420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E+so73SKVthc8eMe6gqiy4aYZWZS/aN0PT3rDfwzKcc=;
        b=IjX1FyilTNDh4+Hns6GFTYo+c9x/Z5Mce1x00nv6Z315ljAkXmfaSTwQeJh1ITDAD6
         VM2VS4Ddch5Se0yvBFRp2U9rvuvYYzyKtgJKf4osbFSwVaIzRczKJORgC2QBX8JkMAm3
         9L/J6GPmz8vY+/RRzmiC/DUel7VxRljdexIDlvl+Dccxjj7vpmxwQ2Pet7zThsABVgO4
         ixRt57Nfq9tOetbi9av07G9K7yhi7KyRVQsXtYJfmheLZtENlnWBYJk2+WsGeXoCyCO9
         L7itV0TCXtttBwUwUWlYx9DpZWXY4fCbOWd+lzNnCqjDCM+zYgWk8g5Ei47GUROsy0A2
         6ALQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvlyiKpm87kBepyMiUbFmmVvNA5EPRN0bu7tFr3DiH9aBBMtUaIl+nm6xrLjHiWkbHQLbn/4dxRofm@vger.kernel.org
X-Gm-Message-State: AOJu0YzJtXAxuxESaBR2kUx8SiNqaAGDk5lnwKUXOMMKi9k2L+wgrh+X
	6DU4AitkY3FZuYl/gXDpL4brYtn+7JkoE+0KsGXmKQPKAjpK7j8pYrHBxbsSSC5FD53N88eUVhg
	REDn5nY5V+9T2WQzC25SJoko522ryouE=
X-Gm-Gg: ASbGncvi+xrQ+TCndeAO8S6JN3GMu53g/lUpcp9PLkgxszsLCqu6Z78lwtnJxi6/V1j
	VxOGTa4+whDQ0HL9Y8DCds7tZ6/9gcqO76N6c27VaOj38oheoRSllsm309dv+y/Jk019RuzTrvW
	1naXBLk1icaU6Enl7qF39mLr8JHEH5YStzVLyTx1glXOXZagZQjZ3AeJDjSloxx8Gye2i5t4YU9
	XxzxBlJbexNxdNrO3JJVnl+vpLyvgVRxpkcitFxso6IOj84S4wd/1JgfCg2itywW4UTrHZaZIUj
	nEzPONB1/VX9uVo4W3Mc5E0ZTgcChxgvg/GAtWLOZwgor/DGpbkLJaGihmzRchgCoQfmM2TDIh0
	Zp2jfn21kqL2QZH6ujO5ndlxLxTCQ9RVQmWL0Q16B0sY6/BoAoL5era1R95B5zDfUQBlDx9qMqP
	urBkKmMDgCy3S1fZ8xFe5m
X-Google-Smtp-Source: AGHT+IEKkhxPq6FKYil4XrC91XOa7tlEzj20W796VPyeZISVk7gR1GhZfiH4OEK4+zjLEf6dozL2km8X0T3O+mSXV5A=
X-Received: by 2002:a05:6214:5d11:b0:882:6d42:53a7 with SMTP id
 6a1803df08f44-8881953a3d6mr120039056d6.40.1764898620125; Thu, 04 Dec 2025
 17:37:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251204045818.2590727-10-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd_-ctfkz1E_Sqh0bJMarUE8rDrd2o7yKKa_cOFGPaYELg@mail.gmail.com> <5f7758db-cf88-4335-9a03-72be1f7d6b65@linux.dev>
In-Reply-To: <5f7758db-cf88-4335-9a03-72be1f7d6b65@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Thu, 4 Dec 2025 19:36:48 -0600
X-Gm-Features: AQt7F2o1BFjIYmvIyLbQIl8fskkz4CYNlkQLW1jbYcuBAHl2Ab70MszT6IFL7HQ
Message-ID: <CAH2r5mv74OszZ610pTn+vZq3ubRdx=+au=SHRNFpyt2rigKkYQ@mail.gmail.com>
Subject: Re: [PATCH 09/10] smb: create common/common.h and common/common.c
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: Namjae Jeon <linkinjeon@kernel.org>, sfrench@samba.org, linkinjeon@samba.org, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	chenxiaosong@chenxiaosong.com, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

i lean against an 'smbcommon.ko'   - it can be helpful to move common
code (headers, #defines etc) into fs/smb/common but other than
smbdirect code (where smbdirect.ko makes sense for cifs.ko, ksmbd.ko,
Samba and user space AI apps e.g. to use), I lean against creating new
modules for the client and server.

ksmbd.ko for server code
cifs.ko (or maybe someday renamed to smb3.ko) for client code
smbdirect.ko for the RDMA/smbdirect code shared by ksmbd/cifs.ko/userspace =
tools

maybe (as they did for the md4 code creating an cifs_md4.ko so that
less secure code doesn't have to be linked in if unneeded) someday we
could split an "smb1.ko" out for the SMB1 related code (since we want
to discourage use of old insecure dialects, and could shrink cifs.ko,
and slightly simplify it)

Finding common code is good - but let's not complicate things by
creating lots of new modules - in the short term the focus is on
sanely splitting the common RDMA/smbdirect code out (because 1) it is
large enough 2) it will have use cases outside of cifs.ko and
ksmbd.ko).  But I lean against creating multiple new modules in the
short term.

On Thu, Dec 4, 2025 at 6:59=E2=80=AFPM ChenXiaoSong
<chenxiaosong.chenxiaosong@linux.dev> wrote:
>
> OK, I will create new smb2maperror.ko and will send v2 soon.
>
> Thanks for your review and suggestions.
>
> Thanks,
> ChenXiaoSong.
>
> On 12/5/25 08:35, Namjae Jeon wrote:
> > On Thu, Dec 4, 2025 at 2:00=E2=80=AFPM <chenxiaosong.chenxiaosong@linux=
.dev> wrote:
> >>
> >> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >>
> >> Preparation for moving client/smb2maperror.c to common/.
> >>
> >> We can put cifs_md4 and smb2maperror into a single smb_common.ko,
> >> instead of creating two separate .ko (cifs_md4.ko and smb2maperror.ko)=
.
> > Sorry, I prefer not to create new *.ko for only smb2maperror.
> >>
> >>    - rename md4.h -> common.h, and update include guard
> >>    - create common.c, and move module info from cifs_md4.c into common=
.c
> > ksmbd does not use md4 in smb/common, I don't prefer this either.
> > I would appreciate it if you could send me the patch set again except t=
hese.
> >>
> >> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>


--=20
Thanks,

Steve
