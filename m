Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794353899;
	b=KMDd6RKm8Q8rWAnnchcAs4KuSvyinWCalAjO1pHvcmk9TiKi16JD5GFa47042D1wN7aY
	 ibDuPn1cP3pI1RlpoaE8Ly8dQLrpusdz0l/xhlTQIlceUqrTd1kBm2+JxvqCzegK6NN6p
	 Q5chC6JRVkQJoQfa3+78cTzi6G1PKda7zJTP6FpvV6gYuwApI+wIDLg+y8Ni+1yPjR6Hr
	 IbSSHM7euOdnkJ1X62pnrYA0S5uV9xQMxiFpMqF1jglsCIddMiIAoeWcGJG5jbqz5cXQO
	 Mmrj/eWC0dQ/BGRgPwm/hUzPEaf4cvLyf/CkHRU4JdEDcsu88PngZ4KMvG9NaJJVPwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794353899;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:X-Mailer:
	 References:In-Reply-To;
	bh=3goS1ZvzPsjBGPxncKSbBYPM6KR9BNseO+p7Dqy/lc4=;
	b=erx2gmKtkBOLZtyZmAvrdIG1+ww+4lK6llUsag3BmQNc+BVVRlKxZzSIoPZGLn42572L
	 XfDIURCXkcYbfy6616Q2cuOIrE48HtiKFHYClej8sqEBgpCNNy2dqXFdiIauu6qEvbwdc
	 90B2oDd36miy+tUXJC8meWOi9XOE7plj1IK4SxlQ8Zf0rLSPWT0SHS+utkzI1sp4hAaDp
	 uurbkDEwEqqD3V58ECYs2JkPce3D4W5nSaDpQZNjeqIcTj9X5KfK6/1HPQFpSA4sA4+qf
	 XzmMQf31Fx9YCYw2HG/xFewkevO3h7TZP5tCvQq1P3aDEqUt1VizAAmAbtrVxDm8/NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jdDKc8kd;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC480606A320
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 23:38:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC480606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jdDKc8kd
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-497614c95f0so1391082f8f.1
        for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 15:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794353897; x=1794958697; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3goS1ZvzPsjBGPxncKSbBYPM6KR9BNseO+p7Dqy/lc4=;
        b=jdDKc8kdHnj4J2ixG5bgLBvuzcI2INXdTJx6MrOoWNWokauorvc53N7DJ/LFOWV7H5
         kURia+FSOM57yKP4FC5ZbrJ32uSJjmWgS6utjkSBstbF49sbAzVNEj/s/XLFv/SlqkZG
         3u1zAW8aFDJ2rpzuzsd6CvX+zbYO8MsjVuseQW3VTUFw7aHAD3BB3tjGXHh4gmcLXQwe
         vT17jOmPT0P/x3O3RdcBL0XYLjj5h7uL+jWJc7qsarmuE+v+hXdSiLJZFfiyn8ldugcO
         j+CPy+WE+kWxKbnG03rfpQxgDe3GKBETsm76szBCIkMqkSCmZ1H2oivY1jp09+EHKOx/
         sVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794353897; x=1794958697;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3goS1ZvzPsjBGPxncKSbBYPM6KR9BNseO+p7Dqy/lc4=;
        b=04gASO4HgKnQGHEQA/TT9AkadTiieHjKZiS1uspLjRDsn6GtRIaIP0JTJrMshQMXJn
         UC7Drhd/LNRslbG7B6LCd0itEUSj7nSka8nngyU8Cs5xcGY8UVIEjUuYRzwitEWQH/M0
         SpDHXVy7YYKJTHXqjxDpjj/Ge/dE0+Q0gBxNTFHOgIHDCpOG5SvBCMSHhU/6JQ6xVe5r
         G2PausmLi55Lz5QWZDgzDc8uJPW8xmPzezbJLRjv5bGF8mwOjN3LGslmh/TpM0RCFjxJ
         +Rv2X6i7KAErq7rJGpltEEbcZiJiQUvhztsYDvyOxglpqUPIFnDBdIO02vdw94Su0xmq
         9JAg==
X-Forwarded-Encrypted: i=1; AL+hErGRcpqSlMOpTFzoRQ/pvleq1vWFdECT1A7U+bu6AnDfuqvFNIIeyABPHQPKFpFeVUVln/RC/CAnJF6B@vger.kernel.org
X-Gm-Message-State: APuU4Z9QNFXkzLlL/ySujPHzpJzEb+VTsqEjmUl5Z0SoByo4xiwNRX7A
	zGdqQ5zub712x5Xy8SDVhzQnxxxWNjxrEBTz9FNNvHvo9auRDIt4YA3E
X-Gm-Gg: AYBFou13eWu1a8+dQyFgXZa6z82NOm1PpCczOToT/Qd5KOKDl3XJ3yHN4isLLYGq7Hy
	KPeKA01cgaxiLtHSvz30AYjzZhpkM3jbShEftxC2wnaMCZO7Z7OpGX9qMJf4jhdPQbc/EeCZ4af
	Ig0bWLi7ErJ96qUobWlP0w1dJFujfU5fbWVUAEfoMxCbMYfzOTbv7uZTb+9x35s47pPmK/Mq6de
	l3GOCHje7Ou6BvGelWrQ3pAIoyrSWKQlWKQVRwyYWptRZhZ9Mjj3qStZcz0R+W/RClo8sk42DWk
	B99Rt6WhwCt6qfSFPY5V++ZIF/5i1gFLp3ei/A0BkXMBmZZklY73mMcOb2cnxwy0wqp1r+PueFt
	irNiRonZZnbtKLfHcxCbyNWn1cN+U56hHzDDSdhSJWSM1TnqFenlS+jO76Q1C7+PWBtB+T4UXJx
	gp0D6Q1tGBA39KUlO40XhxVNZk7VIAhQjPVmEdviHW3sC5OtjhkDkcZv2JH4nYW1g3FTZx0eOi/
	1J/44Z50NltjESqBB9xWtCWV5ozPSzf8NxidZXgT2jib/EU5oLjdlZAgmCcKryZVN/kR3kmID0x
	mctP5yUt13s9umLAyqgIKGCOUQ==
X-Received: by 2002:a05:6000:22c3:b0:48d:f851:ee5f with SMTP id ffacd0b85a97d-499c7a24a58mr837283f8f.24.1794353897092;
        Tue, 10 Nov 2026 15:38:17 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4983284c990sm7145551f8f.3.2026.11.10.15.38.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 15:38:14 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=df3f1d7e3ac6deb5b88938f076a8c8df9b981cb0159dbbcc10385a6dc479;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Wed, 11 Nov 2026 00:38:08 +0100
Message-Id: <DMRXD8R42LDK.HU7NYASSMO7C@gmail.com>
From: "koraynilay" <koray.fra@gmail.com>
To: "Namjae Jeon" <linkinjeon@kernel.org>, <koray.fra@gmail.com>, "Ian
 Bridges" <icb@fastmail.org>
Cc: <senozhatsky@chromium.org>, <tom@talpey.com>,
 <chenxiaosong@chenxiaosong.com>, <mmakassikis@freebox.fr>,
 <linux-cifs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ksmbd: set create_time to btime in
 ksmbd_vfs_fill_dentry_attrs()
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261110161659.481208-1-koray.fra@gmail.com>
 <20261110195625.3211657-1-icb@fastmail.org>
 <CAKYAXd_vxYCEXAJPSH7i5+0Oeaz11P=7-vfA7yP-KO=z569vtA@mail.gmail.com>
In-Reply-To: <CAKYAXd_vxYCEXAJPSH7i5+0Oeaz11P=7-vfA7yP-KO=z569vtA@mail.gmail.com>

--df3f1d7e3ac6deb5b88938f076a8c8df9b981cb0159dbbcc10385a6dc479
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Tue Nov 10, 2026 at 11:45 PM CET, Namjae Jeon wrote:
> On Wed, Nov 11, 2026 at 4:56=E2=80=AFAM Ian Bridges <icb@fastmail.org> wr=
ote:
>>
>> Hi,
>>
>> On Tue, Nov 10, 2026 at 05:16:59PM +0100, koraynilay wrote:
>> > ksmbd_vfs_fill_dentry_attrs() queries vfs_getattr() with STATX_BTIME,
>> > but discards ksmbd_kstat->kstat->btime and unconditionally initializes
>> > ksmbd_kstat->create_time to ksmbd_kstat->kstat->ctime.
>>
>> I tested this on a kernel whose fs/smb/server matches ksmbd-for-next,
>> with files and a directory created on the server, so without the DOS
>> attribute xattr. Before the patch, a directory listing reported their
>> ctime as the creation time, while a query on the open file reported
>> the btime. With the patch, both report the btime. A file created over
>> SMB keeps its stored creation time in both. smbtorture gives the same
>> results as without the patch, and KASAN reports nothing.
>>
>> Reviewed-by: Ian Bridges <icb@fastmail.org>
>> Tested-by: Ian Bridges <icb@fastmail.org>
> Applied this patch to #ksmbd-for-next.
> Thanks!

Thanks!

Best,
koraynilay

--df3f1d7e3ac6deb5b88938f076a8c8df9b981cb0159dbbcc10385a6dc479
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCavOq4AAKCRDmj22qf5IG
XINhAPoCAIej/sisqURd0Ymd8YFq84QGe9rn6aXtTtvXnXv7tAEAwKnnjlYbfJby
oWrXd9I3soiPgNwRf+pblHVL44o22Qc=
=bDzo
-----END PGP SIGNATURE-----

--df3f1d7e3ac6deb5b88938f076a8c8df9b981cb0159dbbcc10385a6dc479--
