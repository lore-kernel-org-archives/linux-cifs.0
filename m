Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAAC245008
	for <linux-cifs@vger.kernel.org>; Sun,  9 Aug 2026 18:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786298759; cv=pass; b=Rf0B3gsh5eIuOPoYyYuU01ruZDxTgGPYKTUyceJORhL+flonaoPUXoe1L3sTlZF0mFOT9hoUleXibjQE6GyBAOmtUF9SPl1bvTgpckEmMHWW2UvCRs5JoB5/Lujgf+ShEYuK+bqCYDaxRt4Z0i9wvCyCbsgWz3XMXzpV4zrkvYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786298759; c=relaxed/simple;
	bh=UK3QFFZKU0EF8BNuslk2eC8BOsF6EsYVa1B1e4vwauo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ttP2/g9u0iHOUxm0lPV9s3dZlFuKXxZQoGRX5bdbEZj78EPHwMNyXc3dNR3vzTnINBJXD4ULS4gm49rFiTt1Hk2l2jYzzJGoUICELp9oHzon96EW98LxVq4pGsReLKAwFu/CPbFUENl/jE0AWNnnS2IYBZnTTQVSP2gAOb2L8yE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ooKxBnI1; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ooKxBnI1"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c20363107f4so110608266b.2
        for <linux-cifs@vger.kernel.org>; Sun, 09 Aug 2026 11:05:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786298756; cv=none;
        d=google.com; s=arc-20260327;
        b=kFruSzZJcPH0FXsrmf4rzdtuWpiQa636fuOenZZ6wA6fy42/NT0bSxw/ZGNAp03USJ
         aoEBaPW0mB82ZF7ejKyWoWYtAKDchjRyIOp72UcH/RU5t8BahaeWBidoRpKMyhRnx+tA
         azNqBT1rEI0Wjd16qdCQuPhdMn7Zbemg9OmyYsyC6lfTOF7K32ReM5MU9B1SgLw5fwVa
         XEusgCCJhQMEGI4ra2G2cU5a07FiwQDWH6spjdGRnsu6fdzHes7EC3hfE/O1pwghbzDY
         r12wk818O9++yTzOvnmGEnKfZxfrHdmdBeZAcJ7yJL86tW1/gPYgRNb2Cu+M58cNRViJ
         OeXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5K9ozXqj2RFKdLJ+8AU1E/812U+Nvya00znDP0GNywI=;
        fh=+fBmkmGz4m05VlloFQzHgdjQo1blN5GWORKLrHwcQ/U=;
        b=AM/qvsJ6NGxFqme5Fz6Tl1j7HDPwuGQI7dk0iIWUJfuWUR4hTgDRVnnDoEPY7WWk8c
         On5IoLSWvCgmYbNXza3T96SjRDzZc4UD0jlCf91St/DbZBxiona/dH4YN7SmLDW1rC8w
         RurOtYvgsgaFXG1QYbEkO4Z5U0Drd+hyYNoNP9ExJjcIy/hbgfEMzeBVo6Wgff9P17gg
         0jOFIrBo87esd/Yx1S1N1bqTLKNFtgAH0SlXSTYlsnDCeJMp8gj9yoUNQoIU9REkmqq3
         6Ktxb22U6gc9WoawOTBtlJgHkqkBdMT6/takz0iGv5QCexNvoX1Iy2lLRwN4OGZOYWjY
         knGg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786298756; x=1786903556; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5K9ozXqj2RFKdLJ+8AU1E/812U+Nvya00znDP0GNywI=;
        b=ooKxBnI1KedUJmIDfS4xZuC9lcPV4cMsst3FWdT8BgUmaHNlv3l5zvrb7XdOp1nVJ4
         ADO0sbQBElkPDKhYLeap46YH36jTlZF7A18TqeKJMr5AFsoZZioDTgYhMr0niq12uikT
         auWr8xO9SWTjXFZak7ZphTy3Ea0lDlDCZGi06QoI4n71VIS5sMLkBCZ2qrRskubsXW4R
         WW3Wm5FKe1Afz4bMBG7ySHH/aYhhFQXYkHNsJjLBnXjpceSvYLgQ24xCXZkXave7Vnq2
         iXHioUxhgVukMmLuo+yv/htoA0em51I7ylSwfQBFnMKJbJ5U2KVfsTF1uDUD7GrIb/wp
         iCqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786298756; x=1786903556;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5K9ozXqj2RFKdLJ+8AU1E/812U+Nvya00znDP0GNywI=;
        b=RTTcrzYQFRHy0UUZkwf7D0NWI82nLBMFw93pymXd0GhRkSciHIzqstU7cEzj5ct97o
         dSfd4Yp2qVZtsDGMnuGrWDsKmFFSZY5sefBh20WaBiOHOAAugk6Li2aGTIZrNVi/sShm
         KrrP6VeouvSXC+u/ybAP9I55NeHFDIs6hWR/M6QPSDLvbRTqqgITpDC/R4+McY9ndAxc
         2YdoWluST2+cRipOMxQRrZVMfgveKDgxyzOP00WB6PC0WWpWlM+FpNnoNxrnGC+prBwe
         e5X/HUcIlXQycRFeVOEJrYRmjUU0f1y7HTlq6wHWMNO0b9v3xWQMI9IbzBSLVz0Y7/t6
         eaWw==
X-Gm-Message-State: AOJu0YzkQiHLyibxCf5oML9CH+oLDr5Flq59Q5csiI3ZKWXkPg12U8tL
	o2BG5KmtarO8LCU7Tadd5gYt8oMvJ1Ih1g5JZQwRyQEj56qRRk7vjAttO1j/yslJFeONVhkHj5K
	d1xYDVX6W4HHmXgsq0biM8mankerj2Oo=
X-Gm-Gg: AR+sD12kCZygH/EZwmZpQMwFY6JdP7pIZipyDkslkkrGMZ82nr9h4JrDpdiiqtIY0dP
	asyDFsxMjL3tz2zQZBknoH+D9/G5OVc72qTuPEXYFOoivlXuqAW9uXmEA79Ec29MQVw91SdLFKN
	RgNjM4XYrD/x14UK8esrDG/l0zpj088fVNB1dUsi3diP5Tc15pKASMPiN+FOMOE0uBAMtBJwcMO
	zUyYHmxMUhREUFVutbQ1gr7N0c0jujXCVQhBpP8lEfqsGjXuwotqX7c0RYO0QP8tjNDqrIKX6FS
	m8DCJTB2Zhk0FH0DI5DyN/faUttuBtPmyijgiCvobYWRiwx5qYE8r9xE1RzXfgglnLg8GMaN4dj
	f8CMscikkqjf7Moa88QBFD7o8pbr5ppeNew8dWkCMeLu0QLtP7zeQVGUzPCodFnnE+vr5YhTT36
	dQejEM8Gdrn67I3zxHWIato46W
X-Received: by 2002:a17:907:eccc:b0:c1f:97f3:7225 with SMTP id
 a640c23a62f3a-c2039cc4f0bmr2009317566b.6.1786298755779; Sun, 09 Aug 2026
 11:05:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260805203900.2930456-1-gustavofn@gmail.com> <dc3725f8e227b1dc7c1bee1189806e3f@manguebit.org>
 <CAJr=uVQ2VGLuHqV2oYsgCxj_EkqdtJAngq8BHUgq_4iU_MNCZg@mail.gmail.com> <d2ee4c33330379ff4a51fa090a551137@manguebit.org>
In-Reply-To: <d2ee4c33330379ff4a51fa090a551137@manguebit.org>
From: Gustavo F N <gustavofn@gmail.com>
Date: Sun, 9 Aug 2026 11:05:43 -0700
X-Gm-Features: AUfX_myBU42JKYQTjBwp3lXqc4ucCSbCAUm_zMMmj611cbptyD4HYkSTwh_YOnY
Message-ID: <CAJr=uVTOKnPDnqdzSw9j48gjdXVZ+ZwcSvKNZ=heDRnUsnY1mg@mail.gmail.com>
Subject: Re: Per-entry WSL EA queries during readdir cause severe ls -la
 slowdown on high-latency links (6.12)
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, stfrench@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paulo,

Confirmed, nouser_xattr fixes it completely:

  before:  real 0m39.031s
  after:   real 0m0.367s

  QueryInfos: 1 total 0 failed   (was 511)

And strace shows no llistxattr(2) calls at all with that option, so
`ls` stops asking once the mount reports no xattr support.

The two hosts:

  old:  CentOS Linux 7.9.2009
        kernel 3.10.0-1160.119.1.el7.x86_64
        coreutils-8.22-24.el7_9.2

  new:  Rocky Linux 10.2
        kernel 6.12.0-211.16.1.el10_2.0.1.x86_64
        coreutils-9.5-7.el10

The tell was in the listing output all along, and I missed it:

  old:  drwxrwxr-x  2 fwservice fwservice ...
  new:  drwxrwxr-x. 2 fwservice fwservice ...

The trailing dot on the new host is `ls` reporting a security context
on the files, which is exactly the llistxattr(2) result you found. The
old host prints no dot and issues no such calls.

I don't know which coreutils change introduced this either, but 8.22 to
9.5 is a wide enough gap that it could be any of several.

Thanks very much for tracking it down, and apologies for pointing you at
the WSL EA path, I'd read the STATUS_NO_EAS_ON_FILE responses as the
cause rather than a consequence.

All the best,

Gustavo

On Sun, Aug 9, 2026 at 10:40=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> Hi Gustavo,
>
> I was able to reproduce your problem with coreutils-9.10-5.fc44.x86_64
> and mainline kernel.
>
> The `ls -la` command is, in fact, calling llistxattr(2) on every file
> returned by getdents64(2).  That's why you're seeing those extra
> requests being sent to the server.  See below
>
>         $ mount.cifs //srv/share /mnt/1 -o ...
>         $ strace -e llistxattr -f ls -la /mnt/1 >/dev/null
>         llistxattr("/mnt/1", "", 152)           =3D 0
>         llistxattr("/mnt/1/.", "", 152)         =3D 0
>         llistxattr("/mnt/1/..", "security.selinux\0", 152) =3D 17
>         llistxattr("/mnt/1/008.174041", "", 152) =3D 0
>         llistxattr("/mnt/1/008.5301", "", 152)  =3D 0
>         llistxattr("/mnt/1/008.5307", "", 152)  =3D 0
>         llistxattr("/mnt/1/008.5313", "", 152)  =3D 0
>         llistxattr("/mnt/1/008.5384", "", 152)  =3D 0
>         llistxattr("/mnt/1/008.6320", "", 152)  =3D 0
>         llistxattr("/mnt/1/009.6781", "", 152)  =3D 0
>         llistxattr("/mnt/1/012.8056", "", 152)  =3D 0
>         ...
>
> That has nothing to do with the client trying to get WSL EAs on the
> files.  By using 'reparse=3D' mount option will also not help because it
> is only used for creating special files and symlinks.
>
> I don't know why why llistxattr(2) is being called by default when
> running `ls -la`, sorry.
>
> One way to prevent the above from happening is by using 'nouser_xattr'
> mount option, which would disable getfattr/setfattr entirely, so `ls
> -la` wouldn't attempt to llistxattr(2) each file over directory listing.
