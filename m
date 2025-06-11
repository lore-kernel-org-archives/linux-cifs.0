Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40C61DFF7
	for <linux-cifs@vger.kernel.org>; Wed, 11 Jun 2025 20:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749674374; cv=none; b=DCM0ngAyihVF/9sg6Us7kgbzIyRs9DZVF08/EK3w3VmFfHEDF+pdXqW8JRK82liDUeNeYpWo+IB97TVPucqU8UiIBHLjdvcrOz8YZlANqfL2ckXS4liCeV4NaIr+7pW8B7f6XyqQ7lp6uVdT1jmq/H4eYiDW2d7CGxkouyuJ31A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749674374; c=relaxed/simple;
	bh=N1p0P8xCIoSLFisVC9kN3qAkPGkdhQ2AYeoDrpCQ2GQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oigML6MgziwMEZKEmurx5evEJC8nNxK9whPW6ElKyz/ZJK1+XMCiN1LHrLXsF6E2KbH8dQcWnpscqFAhIcg8WVG4Cs/cqb0DGJ91Y8v2JV03nXkYJ6XVIXV61ls1HbRG2OpMCnOsLwj/pRDXCkpwZlvJEeFdzeQVk5SGH4MxPv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b4/7c1xp; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b4/7c1xp"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-32b019bdea3so2139751fa.2
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jun 2025 13:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749674371; x=1750279171; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=47yCjaLiY6lVOnRrUbub5nVe1q6mFs9ovRFUcJ5sUig=;
        b=b4/7c1xp0pP45N924oQvlSdmt36Nqej0jdPX/Fa6jP30rzkD4pm0Zdl1oBfff8UKQf
         Visr5syv55fkwbImTfr7YhJtn3q3hWir5NNcxcinnAmgG+3ujgChYTsFz6elyxMoKj4U
         Z2a/Bw32Y9xrZ2/4S6YRYK9jiomUQdVPxM3Cdh9epsCooXTPS8rVRdNcfHwzgg6xYEOz
         oyT8ZaXb8E9osYbMgfSsVW3oOlvGHxnbQ01Wwes45pmH5WCNiN4vVio2uY0qAlTqOafL
         XcffCvu3Um2xVtrcy4XpC6e5bJhiYm+eIqpPo48T2jqvO6IF/hlE0n0bl7rc6XDVsi0N
         nTOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749674371; x=1750279171;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=47yCjaLiY6lVOnRrUbub5nVe1q6mFs9ovRFUcJ5sUig=;
        b=c/7Hc+tKD3sDS/2cU0UxaQwbt/KZAINy7YzkY+QPwHv+aKdfTMrGUBHxObhXSsBIX8
         rkKTQPz12diinDi5Jwi6Fc5u6vSYNCl7Z0r4S4P+apGptzwNFEfY1JesMWngoK9IaFAF
         gYer0No8Ez/aVkeMj0A+52J+HK/SZgp3ivjwFCZB40LDG2l/xZQUW3E0GSUA+0UIE3Wx
         F1FNUmk4WxHH6zydMv+lmNq2MNv21wHkwVQ3/3ywyCINkTcIOGERmYJbbBEmhnWrj6Jb
         dnLezyPCpmlDeNijY3HRoWdxPIVQlTi05U3+IyAVpsU5xqlf7aYy0hhYB2PaJ5oW5kpL
         QPgg==
X-Forwarded-Encrypted: i=1; AJvYcCXdH4gaXEz5wGWVby7OH1fMKuj1/Y8jv9NdRRErX21SIVRfU2BnTF3dki1eL2TS8j0ehAdrmOcitwjE@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/gImK4wUZkRipoxMNKy2tMkNL68wKbnEGVM6SjmmqQvlxwELG
	FuZitiilfPkjtLTTvVrKqsN4/jP4yuEIpF/m6orVaH14CM6rdlrLm2MGAOyIiyVw/V4RquktGdD
	t0P8X2AHOdpC8mYK3D3uxMSukHlqPPBc=
X-Gm-Gg: ASbGncsvW89ns8QuIKfr+mTfWh48TmCaq4bj7J0ODC//tozBJbtCduNPEC/dERGBh7V
	QAqZjSvXCisTznVl1MjRi6aT58ofhhp8mIJP/tJ3KtCDOfBkk3lxPNBwb8FWuIfSd8xSMTCfWb+
	leoOQkuWpItGavys6pW1QDRk7Q3eDmJITrH+hErdgcksQZjqUD/zHc63/qhH+CedMLnd7u4eCK6
	QHnBA==
X-Google-Smtp-Source: AGHT+IHN3vMtHKcjTJffwGhC7e+5d15JUG5BeDzQ7JcTvwOYUnavoLEpqyn3uuBeDDR5qrtgw2q/hyqeI+unK3Z9EIM=
X-Received: by 2002:a2e:a781:0:b0:32b:2d54:962 with SMTP id
 38308e7fff4ca-32b2d540bd6mr7018051fa.30.1749674370690; Wed, 11 Jun 2025
 13:39:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muQB8CgN7r8SE8okujV2rpvQoKYAP=yD95a_R1hLjKWqA@mail.gmail.com>
In-Reply-To: <CAH2r5muQB8CgN7r8SE8okujV2rpvQoKYAP=yD95a_R1hLjKWqA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 11 Jun 2025 15:39:19 -0500
X-Gm-Features: AX0GCFupN_Ac74A7xvbuO_qRC4Ug9qyk8gdEjoj4MMv6SiwwtcZBFMktyWWIoe0
Message-ID: <CAH2r5mvCrHJQDYM8ZO-QmWioCtwFS4isUT0Mo4TMa4nRSrHTdw@mail.gmail.com>
Subject: Re: netfs hang in xfstest generic/013
To: David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
Cc: Paulo Alcantara <pc@manguebit.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It repeated when I retried the test run (the hang in generic/013)

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/=
builds/488

On Wed, Jun 11, 2025 at 9:53=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> I saw a hang in xfstest generic/013 once today (with 6.16-rc1 and a
> directory lease patch from Bharath and the fix for the readdir
> regression from Neil which look unrelated to the hang).
>
> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/=
5/builds/487/steps/29/logs/stdio
>
> There were no requests in flight, and the share worked fine (could
> e.g. ls /mnt/test) but fsstress was hung so looks like a locking leak,
> or lock ordering issue with netfs. Any thoughts?
>
> root@fedora29:~# cat /proc/fs/cifs/open_files
> # Version:1
> # Format:
> # <tree id> <ses id> <persistent fid> <flags> <count> <pid> <uid>
> <filename> <mid>
> 0x5 0x234211540000091 0x5c5698c8 0xc000 2 32005 0
> f24XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 6928
>
>
>
> root@fedora29:~# ps 32005
>     PID TTY      STAT   TIME COMMAND
>   32005 ?        Dl     0:01 ./ltp/fsstress -p 20 -r -v -m 8 -n 1000
> -d /mnt/test/fsstress.31810.2
>
> root@fedora29:~# cat /proc/32005/stack
> [<0>] netfs_wait_for_request+0x100/0x2e0 [netfs]
> [<0>] netfs_unbuffered_read_iter_locked+0x87e/0x9d0 [netfs]
> [<0>] netfs_unbuffered_read_iter+0x6d/0x90 [netfs]
> [<0>] vfs_read+0x46a/0x590
> [<0>] ksys_read+0xb6/0x140
> [<0>] do_syscall_64+0x75/0x3a0
> [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
