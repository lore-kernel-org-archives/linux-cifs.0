Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95B51F8AD8
	for <linux-cifs@vger.kernel.org>; Tue,  3 Dec 2024 16:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733244184; cv=none; b=qX46I9K5AmKm/YwuaavpmIIW50oW5+MxkNte+sJKQpQs6icq52pmK7459vP44rGVA7oImZtzrjmy5rivygOej2T6kb5s5JK3jVxC2pQui40QdTg4LL5uz9IlunPA9/+HMT7vYm7JKd8yKu095v7L8BK3YAJX1X+lnTBsjQ65boA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733244184; c=relaxed/simple;
	bh=aGbgsr+MX01SaJBuYASfCXrSmYQ6gRzFZ4gD911/RtU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z343li9wSzSnFzFEAxJ/HKHCjvxa6ydZxUITQnqFfJFmVTh47TmkTK1elUS33M1dov5VNaNSOMX2oNZkZS8hM1I5dUO4WDO8tmaCY8+y0nwLrFBPpvxvxvcRul5Xd0cOGQK35mlbSAUq+R+ZXF1fc38j3erPrWpxM6DqPyj7f7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gWCV178C; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gWCV178C"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2ffe4569fbeso51311461fa.1
        for <linux-cifs@vger.kernel.org>; Tue, 03 Dec 2024 08:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733244181; x=1733848981; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aGbgsr+MX01SaJBuYASfCXrSmYQ6gRzFZ4gD911/RtU=;
        b=gWCV178Cr1RDYWggSRWcF6+kD0m6XEmckkIj1JnhNixAXXPt7M+YxtyClP1DRtn3Kj
         6XBUqSeLaSQNVRjoKDotStEz/EdYtOYhqLgx3XDhtQfRQr6QRaOg1PLRwruOtqM5hNfy
         Fs0n10qpEF1QGY7KGB3Gww4pZI8SNRoNnEbUqCZQ+1TjVPzbQjKBrnmNB67zRzpYRJoS
         ra2NZzjfnbXcODqB8Ne3QLYfeB4iHZgwrqsrv/yuqLXfvX2qBU5QSR9r/yOA1MecDCkX
         f9z53UmBK2kPxSZLnfZZ3Mqs5goxpzUPSTH2wT31XAU580t3OQH9tqEn+LD4DLPyc2co
         quhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733244181; x=1733848981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aGbgsr+MX01SaJBuYASfCXrSmYQ6gRzFZ4gD911/RtU=;
        b=MhbiJ2R6thoGbyu5fpaITnS/ogmcUujot/NE15aTaeVkZffygMmPR15o6D/yZIIHj5
         oRrB/wthlMKMSs6bSeNJmqPZFZIaM2qzm10ef5h5ja1se7PK1O1WcTu2jTr8SCc0/BWD
         Z80gto37Bw8AD8vuMi/oRU8mWBtzj9cr7tkzt/xspIXCP+FEzLHhm2l5BHecM9rcDV8O
         1oW0XPirEeEj90BKe5zmnvrTt+zE873Di7ETYABVk1dLR3KF5mstwmuJfsJopGcbpwrF
         J+sd8/pAXs+Cb96TKdTM8BytpbZZFXkd8hzNsdrN9A7epcshw0EE4kDpJ9/MEdDbvSMS
         j2oA==
X-Gm-Message-State: AOJu0Yxs4dAZ0oPOppE8FGZeKi0j40bWEqlCksT4onfIWNqpB5VSb1Ci
	mHkgIZj5FLXqjAcsEGwFFtejFOGkyBCd+aRBoJ/paBFVkrdXzI+xAexnngMZ7nxy2kNSdRBYHii
	E3hAylQdvZB3PCldDaFFw9QHBATQ=
X-Gm-Gg: ASbGnctJipzF5gu3wuwM46MZ+E5JqP0yRH0RscIsl586uCXF3NM7qIYyew2JS6mcZ6O
	Yyl6xBi2/uKgOJhJ/e7Uco7x6OjJmOBKxa/rYSQMKeRYYq3wLXrDyfK4cXFZwy4CLVA==
X-Google-Smtp-Source: AGHT+IG0oE/gIWb2Zfz4ojlMro47BUfe37ukHkz7+BD64Np1N2qstkb34vCE67IIIHts9xGoh95nOvPwWGNO+dRULzI=
X-Received: by 2002:a05:6512:4026:b0:53e:19a2:d56b with SMTP id
 2adb3069b0e04-53e19a2d63fmr670319e87.8.1733244180849; Tue, 03 Dec 2024
 08:43:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtJ-GtVWf-U5-WMrcg92cv+pd94n+F8phztuLKpYMv9Bg@mail.gmail.com>
 <537404.1733243749@warthog.procyon.org.uk>
In-Reply-To: <537404.1733243749@warthog.procyon.org.uk>
From: Steve French <smfrench@gmail.com>
Date: Tue, 3 Dec 2024 10:42:49 -0600
Message-ID: <CAH2r5muzdv_pfEfqQbBwA5iJ7BUBRRFk5b0SZhd=bCAcnNp8RA@mail.gmail.com>
Subject: Re: xfstest test
To: David Howells <dhowells@redhat.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 3, 2024 at 10:35=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
> Steve French <smfrench@gmail.com> wrote:
>
> > I sometimes see xfstest generic/207 fail (e.g. to Azure
> > http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builder=
s/5/builds/281/steps/70/logs/stdio)
> > but usually passes.
> >
> > e.g. "write of 4096 bytes @5455872 finished, expected filesize at
> > least 5459968, but got 5455872"
> >
> > Does anyone else see that fail? or have a better repro scenario to
> > narrow it down?
>
> Can you collect some tracing from it?
>
> It works for me, but my Azure I/O is so slow that it tends to overlook th=
e
> races.
>
> What patches are applied, btw?

This was 6.13-rc1 but it did not always fail.

These are the cifs/smb3 patches in 6.13-rc1:

$ git log --oneline --no-merges v6.12.. fs/smb/client fs/smb/common
8d7690b3c146 cifs: update internal version number
cda88d2fef7a cifs: unlock on error in smb3_reconfigure()
0f0e35790295 cifs: during remount, make sure passwords are in sync
b9aef1b13a0a cifs: support mounting with alternate password to allow
password rotation
c353ee4fb119 smb: Initialize cfid->tcon before performing network ops
3fa640d035e5 smb: During unmount, ensure all cached dir instances drop
their dentry
796733054e4a smb: client: fix noisy message when mounting shares
36008fe6e3dc smb: client: don't try following DFS links in cifs_tree_connec=
t()
e1481075981d smb: client: allow reconnect when sending ioctl
b2fe4a8fa0f6 smb: client: get rid of @nlsc param in cifs_tree_connect()
28ec614f2f9b smb: client: allow more DFS referrals to be cached
f4ca4f5a36ea cifs: Fix parsing reparse point with native symlink in
SMB1 non-UNICODE session
1f48660667ef cifs: Validate content of WSL reparse point buffers
d3d797e32653 cifs: Improve guard for excluding $LXDEV xattr
06a7adf318a3 cifs: Add support for parsing WSL-style symlinks
dd26bc067e44 cifs: Validate content of native symlink
723f4ef90452 cifs: Fix parsing native symlinks relative to the export
4bdec0d1f658 smb: client: fix NULL ptr deref in crypto_aead_setkey()
ab02d8774181 Update misleading comment in cifs_chan_update_iface
07bdf9272a01 smb: client: change return value in
open_cached_dir_by_dentry() if !cfids
ceaf1451990e smb: client: disable directory caching when
dir_cache_timeout is zero
f6e88838400d smb: client: remove unnecessary checks in open_cached_dir()
a9685b409a03 smb: prevent use-after-free due to open_cached_dir error paths
7afb86733685 smb: Don't leak cfid when reconnect races with open_cached_dir
0812340811e4 smb: client: handle max length for SMB symlinks
9f544d26b15b smb: client: get rid of bounds check in SMB2_ioctl_init()
bc925c1216f0 smb: client: improve compound padding in encryption
9ed9d83a51a9 smb3: request handle caching when caching directories
0d6b0d2e3816 cifs: Recognize SFU char/block devices created by Windows
NFS server on Windows Server <<2012
db363b0a1d9e CIFS: New mount option for cifs.upcall namespace resolution
7a2158b73c36 smb/client: Prevent error pointer dereference
d413eabff18d fs/smb/client: implement chmod() for SMB3 POSIX Extensions
128630e1dbec smb: cached directories can be more than root file handle
343d7fe6df9e smb: client: fix use-after-free of signing key
7460bf441656 smb: client: Use str_yes_no() helper function
f69b0187f874 smb: client: memcpy() with surrounding object base address
6c9903c330ab cifs: Remove pre-historic unused CIFSSMBCopy
9bd812744db2 convert cifs_ioctl_copychunk()


--=20
Thanks,

Steve
