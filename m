Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5337E399CFC
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 13:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783518726; cv=pass; b=QJNU0iWr8PbG938A4j4rXbPCT0oYH1ZD2eIABV647zC+bzP4jaNewv2dClY5y1+2jR4C5shdU4EAtGeGxJNltTopdqwMJKBqDAUogrZi3m3MWuZN/Og9aIYFYXtgn5W52S4z6WJOqMfphBuIuqtW+dFHhSrAywh+p3GC9BdPKSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783518726; c=relaxed/simple;
	bh=D23WgVmpLf2fbD/XF205+PPyVDniYblTWJSF0KdX8a0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nQIJFSnZ5fAnaxlo0kjVcgeLndCwnfJtm6YYD6y44LtF9lK1koL8ClgJcGMMdYFNuXlc3oXGBZIajiZjbibsFkP3OHlmwxNK3pnSE2W75sGHrXM6NAWL5SQQB0UVG7IcvcKparjNJ+gKtK0MjWO4KlHiSFtBgOlxfL02Gto480I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kAo8/iKB; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kAo8/iKB"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8ee43b3e5abso5021476d6.3
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 06:51:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783518713; cv=none;
        d=google.com; s=arc-20260327;
        b=hKlpVk+h34LONjpveyfDVEpqgmqDpVWr6kK/4RNJXlURhDj20VN4dlgw4eQELCtZqy
         zGzxAIkkwOdDQkShuOW/ygGknxXGQuu7c9Wwz6f+abFIhRK4rzOJCb+fFWdfAVQGZ/1l
         xrVh2jmdum2J7Jr+NEgu0FyEQ27eQWW8Rsk+hRcbGvB74Ha1GrxsdU8dHWSZ+1+k2ghe
         GFYm4A4hQ0NI3xJVAo/jsVhrfgHF42sDQQEvOW1nBc8VdkxxnUp3Z9W9hodt7P+fuTyj
         v2EKHoemijlwGYVnpmfNFJKnhMNCKUdrvfZpDG9/B7TugzvnRqzbHGCGO/kKZcBW/ixf
         6r5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jf5UGuVyGWqvht5C/twvGZWChKN93r8KBbR8d3NiRaQ=;
        fh=u5FPapvsg5w3JIYy97TRsfIuNRrSW9/3tQN/8qxREk4=;
        b=pK0Yfn4iajVM9ENw2/qoZ4V47qpEunoDvYx3n+hznWqFJTYP9XXQgesG388u6p0i7c
         8Lp0suBvfz2I65xfvtUpQwf4fyzt8jqzO96mOQnOo2kNNB43rBHQ5Q9KAi1Lt7m6crnx
         /JSXM9KNRE+ELHTrAyfVSw+R71Y9kPb4jp5ltWJu7bfg2vTsNliVjnEo07Hl1YTxB1LD
         9dNcTx+zWHaH85fRjWSRaKv7cbMApTfCEcxwSMC41YAfIBNRJxVlVmwKQIs6eenGXDXf
         hQuDZa2JjJK+433fYMyR6sOpjAB7N6jWegNG8JrF94gHqW8Fl3XZun25suU5ptzQ5ZzQ
         4D3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783518713; x=1784123513; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jf5UGuVyGWqvht5C/twvGZWChKN93r8KBbR8d3NiRaQ=;
        b=kAo8/iKBKnt9XqXrStRDfEADbcWDARtnY9mH8sAqiL4IjLyJ4wOnBmc6jLcr7t9NPg
         LhJKw1rUVTb/NqKKddyrI4hIUZF/A0o+99LGHvVtwEWrMycr/MJovDC5X7XOIjLtyaYa
         c7+YuhxpSGfc/p8P6PQd+M+4DnkgbxDwRxAD5a7wDwjwP6ZeRBkqIMfd3LsjO4dpP+as
         /NFW84Mvlkv6R151SMzHQ1vy89I1ilp4anDl6h69LpSrRCSw/PnUWMPSZ0ZQmDANWiQj
         MyJTqWxQ1ry7oSXVKQaS0qkF1aYpSeN3dY3rP4RmdvugjgiKIskD1Ljf29QInEOztbFK
         pM9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783518713; x=1784123513;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jf5UGuVyGWqvht5C/twvGZWChKN93r8KBbR8d3NiRaQ=;
        b=HFUTaXDg6yj8daLLPvCG4kzL5WflHoaR5XhngR7p0Y78tWdjdl710lFucq0VfFDolB
         PUy8m9b1E0G2pR5JmBOOFqJAI/L1lIYY0dFmdlEGT8NHEBfTnObzmECUnF5GOWrJGYay
         YQ6aiqOmQPJspf2e2ucOkVuJIveGueuUW/WdXLmNBbv1u6D91K2VslcClSF+N3S+Wqrr
         GjlcxBCfntfJd91aXddH47ETNGJGK3lR9aq8QAhfj1j1/mE5k5/fxMz/zDoSxu6fuSy6
         z3dAMFcaWxFjrC2VK1LgkABewADoKt0Na6Aw2f59uaPV5Wfd8bKt2usmnEgnjW0saGea
         /fWA==
X-Forwarded-Encrypted: i=1; AHgh+RoEkrQJqwGhc64cut+xODSX7BnUNIZ0O/9S7LjYBttFgSLE+T0jb8YXd8nZOhQFPK6lfGh+IitclvDH@vger.kernel.org
X-Gm-Message-State: AOJu0YyaN+XxNDeDBgSbE8xUMNNPtcXQdw3slGrzo6U0wp5Ew4Dt3INM
	gNADsMECrazebSh4lUtedWrky+DNap+to+HUaT8+HRH1qBC5qeNel1mA+tJwH3JD6RaQfRG5qAG
	Ecz8FqOpJLhDSOdjTbVsJvXSOc2pndNBzk4r3Xs4=
X-Gm-Gg: AfdE7ckqvmUrTNU+tFd8+Fmfos0IvyQ+G6xerZFYI7xt3wZ4q6PIO7yKMyqgvOJ9trO
	nK/PV5Fd36tHpzyEW2+8/nwU/EbgkZY/eUDqF0S7aqWmuajNoI2mNnepYjVMvNPTP+5I2kT4pon
	GbPLwCIncRwNapuhT9kAsUb6UPuXE0wVPmBB4o5JQqcpbcZWkIIE3PeH77SqUZjVgtAO1W03mAL
	rVL3dd+U3Ocb/Z1Ikv5QriEntFVQ0HEr9KMWhGB6jSzYNdonYvigq9BbyU3Jh0uAsE2jbVtYGQR
	1vbkbpIECSzN8oF7dce64mv/WJhSo0NKgomKSPtqiHYfcCahbWhOBBHX8TJ6j5PlmsfnyRmkrrs
	r4p7Hs5PjQXEjBIzjlwF6DBAG0cN4hwCyNeOe9PcQeunY4j/2myL5
X-Received: by 2002:a05:6214:8097:b0:8ff:6bbc:2a98 with SMTP id
 6a1803df08f44-8ff6bbc2e94mr4144206d6.46.1783518712853; Wed, 08 Jul 2026
 06:51:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707090318.26130-1-pali@kernel.org>
In-Reply-To: <20260707090318.26130-1-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 8 Jul 2026 08:51:40 -0500
X-Gm-Features: AVVi8CeWguqrXF9zhTwlB_qmp_LCwSrjo1BvozvP6q4KoFqOBqLPIW0wPt33bWY
Message-ID: <CAH2r5muHZ5+znNZv4rsLFsVEW-z1XHB3U2N2FWaYRC6vS+ijgw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix support for creating SFU socket
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

AI query made it sound like "LnxSOCK" is still used by WSL.  Is this
change safe?

"Yes. WSL (particularly WSL 1 and WSL 2 when interacting with NTFS via
DrvFs) uses the Lnx* metadata family to represent Linux special file
types, including:

LnxSOCK
LnxFIFO
LnxCHR
LnxBLK"

On Tue, Jul 7, 2026 at 4:13=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> SFU sockets are natively supported by Interix 3.0 subsystem and also by
> later versions. It is part of Microsoft SFU (Windows Services for UNIX) a=
nd
> Microsoft SUA (Subsystem for UNIX-based Applications). They can be create=
d
> and existing (stored on local disk or remote SMB share) can be recognized=
.
>
> SFU sockets are recognized also by NFS server included in Windows Server.
> Windows NFS server versions since Windows Server 2012 uses new reparse
> point format for storing new sockets, but still can recognize this old
> format (also in the latest Windows Server 2022 version).
>
> SFU-style socket is a regular file which has system attribute set and
> content of the file is one zero byte.
>
> These SFU-style sockets are already recognized by Linux SMB client.
>
> But Linux SMB client is currently creating new SFU socket in different
> format which is not compatible with all those SFU applications. Fix this =
by
> creating new sockets in correct SFU format which would be recognized by a=
ll
> SFU, SUA, NFS and existing Linux SMB clients.
>
> This change affects only creating new sockets when mount option -o sfu is=
 used.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/smb2ops.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 4f7eefa7a683..e59fda1b2230 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -5288,10 +5288,9 @@ int __cifs_sfu_make_node(unsigned int xid, struct =
inode *inode,
>                 data =3D (u8 *)symname_utf16;
>                 break;
>         case S_IFSOCK:
> -               type_len =3D 8;
> -               strscpy(type, "LnxSOCK");
> -               data =3D (u8 *)&pdev;
> -               data_len =3D sizeof(pdev);
> +               /* SFU socket is system file with one zero byte */
> +               type_len =3D 1;
> +               type[0] =3D '\0';
>                 break;
>         case S_IFIFO:
>                 type_len =3D 8;
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
