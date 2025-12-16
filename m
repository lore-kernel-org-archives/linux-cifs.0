Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4641EEE6
	for <linux-cifs@vger.kernel.org>; Tue, 16 Dec 2025 03:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765855537; cv=none; b=nSj9XwhiCNBrAb+0kfPzXQL+IiyeVysHGEblq1VFBcMGiBy0nethHNQPBD0qNzqafCj1gMdizl8M51xIXFbqIbxRdrk8VLNCPLr++vKLfy0Clcc79zUWY4eVeiPGlhJ0Ql4h4+l8lqNiI0EKriyPk2LiPWFnuMSon1T7M05ce2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765855537; c=relaxed/simple;
	bh=VMgvwkHi9AxR+iha+K6U/IPakzSD0Ri4Ix3+af0/EH0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m8XegqTSkLM9YKkeNJJPx0HhFJwM/SZ/Yip9NYcRicEzqqqAdnVdQcqNREuAeQh0jeAQrjrHdB3umFxLiQ8WqhuTl6T6c8nEfdBpPvCAFYJapWFgk3ps1CaihaDILXLcFYLgrLLpkoY9llnYNV4h842c3Q0Lckcof9UsLkxOTeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lwhzmu6V; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lwhzmu6V"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-88267973e5cso22911136d6.3
        for <linux-cifs@vger.kernel.org>; Mon, 15 Dec 2025 19:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765855534; x=1766460334; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2meeOUUJq8S7YGMEaPQXxeGlz4H8t8mkRqj8i/4dprc=;
        b=lwhzmu6VY+6jAH+DZAb7orfbbps0CRneKaZtsHc1PrFoszOQ5u3tSvS1I2gnrEfaA5
         mDASP7w1zYc+25NmkceMznSh1IO0IuA8xGgmAF7KVI3YFiWSBVQBVxnUGMGiCvc8VQq1
         eBh5JHjNGBNFmZfh5NM4lCcr+gDJZyUHamCLIpnU3Qv02NCg5u+kbVg4/fhtYiCUWH6d
         wTz81tWdMiWJ8zNTYhh04Vzvk6FI/IlXOTdnViVT4FzUqLz6JJoolcSfa7WWksSUislU
         WSy+y6kcT8t1t1ZEBAKeoVbvOJMMhBbfcFVUhr25TlZRp+LxKl7+NYMs9UtK5kZ/N7eH
         2pYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765855534; x=1766460334;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2meeOUUJq8S7YGMEaPQXxeGlz4H8t8mkRqj8i/4dprc=;
        b=Xxc7tkqiHEPNauK/T8UjOEIoM9I9ZUup30gg+xXvBMr1zJoXz5jq+xvHdXVLuresep
         AS5ziHPHIZTQqMSs5bZH2h3uc6tSrjKLU/pUzdfTXuabi5MiOWsFtB8QR03JJbKw7H9k
         IrDp4xiLc5ZjOivZPaft+qTmM+/rfsIFYf8X1Q83hGYY3LVeDtqXoFkCyry7ciDZAaf+
         sMN2x9YsGHRG2+NqFVJQVw3j7XyJus0bHMbh8Eb8fU3DxliHTtK+PFezerh2QoA9cvgg
         F+gsZygvoGUIpNnt7AqYl/TQ27Myh7IOVkmYSQfdfQ+k2HCficCQwGAQEtt343FTbj0U
         Vufg==
X-Forwarded-Encrypted: i=1; AJvYcCUDNZ4zZDYRkYG/NYYkUgMGQ+euHzycFaMFXFXZANPGeqIOtfcPILmy8FF3edA673PSh41XsRg5aW8t@vger.kernel.org
X-Gm-Message-State: AOJu0YznR1FhXqOYJzwD/y+0C53QEFcDWUuHXFn4aKDxxu5ucW4EjRWU
	P8gv1l4WnEwEheNpoeyEpfUSV/YCuasdNq44hfN0NQM3iXbaPhQ4BLo+kKLZ/yP+FXPvNgHSAoi
	hj5e32nwwTbG4jwW5B5+Gh5uX9Og2WCY=
X-Gm-Gg: AY/fxX45V0S+6KBgHlNEIkLzISse2MKq4QSMlqH7QOHmvXhdRvBJ22FMX6QGJsdDRxm
	nmXDTy+dPpPuUxM2EhIkkEIXEVEnULkEfu5T0UvwwNXQAkuNzm9T4mfnYi/PKZfaUbdxF86Viai
	GooU23unUgMG4/fGokStcwkAb+n4rlST4OhDx23n3EqZoLIsVshxMQcrGubdypbgBwfjGxp7oXx
	cuFzIsy3168VRO6b8Y+X0K1ai/ta3Tar3lVd70tcehwe/d718CWnBALiNFZcuhWgVfZRtBFDXVo
	fqe4KIYWPojza4vrElyKBpzLamg0sdBp+Y0ZkHqdGZPX/9ZFMv8FReiMsqe3a6mnKOxYGIyy0jL
	VyH/+oegOKkVmhTj8wRpxOSuZilwcVdyfNAxJRVpHokyc2egHHL4=
X-Google-Smtp-Source: AGHT+IEhqyUHX+A1lQaYQ/AObxTAvCybz761sC+Ovh8cClm31D76Oxfqdve4Bzk1tDR89HsHkr7/HqiZ2j3ZJx2KVe4=
X-Received: by 2002:a05:6214:54ca:b0:886:3d8d:97b9 with SMTP id
 6a1803df08f44-8887e430744mr183595146d6.24.1765855534278; Mon, 15 Dec 2025
 19:25:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d745d9cf-2dc6-4240-a4be-1982082c0d28@linux.dev> <a6c17d48-ca81-4318-966e-67fe7df9dda3@linux.dev>
In-Reply-To: <a6c17d48-ca81-4318-966e-67fe7df9dda3@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Mon, 15 Dec 2025 21:25:22 -0600
X-Gm-Features: AQt7F2qEqoi1P5vWpE47Wxm1XmJdmqPtnDHYiyrafk2C75ZVxHwr8gyiWa5CpMA
Message-ID: <CAH2r5msHiZWzP5hdtPgb+wV3DL3J31RtgQRLQeuhCa_ULt3PfA@mail.gmail.com>
Subject: Re: Questions about SMB2 CHANGE_NOTIFY
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Namjae Jeon <linkinjeon@samba.org>, 
	Steve French <sfrench@samba.org>, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000d885b20646094734"

--000000000000d885b20646094734
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I had posted a sample program for using the change notify ioctl on an
smb3.1.1 mount (see attached).  It is fairly easy to write test
programs to use  these - see e.g. the older simply notify on Linux
cifs.ko - IIRC something like this should work.  We could really use
someone to add a notify tool in cifs-utils (e.g. in smbinfo tool).

import fcntl

# constant for sizeof(int)
INT =3D 4

CIFS_IOCTL_MAGIC =3D 0xCF
CIFS_IOC_NOTIFY =3D  0x4005cf09

print("CIFS_IOCTL_MAGIC:", CIFS_IOCTL_MAGIC)
print("CIFS_IOC_NOTIFY:", CIFS_IOC_NOTIFY)

# then change some files you don't mind destroying
fd =3D open('/mnt1/somefile','rb')

ret =3D fcntl.ioctl(fd.fileno(), CIFS_IOC_NOTIFY, fd.fileno())
print("Exiting: ", ret);



e.g. notice the original commit message, and then the second one which
was added later to allow returning what was changed not just that
there was a change to that directory:

Author: Steve French <stfrench@microsoft.com>
Date:   Thu Feb 6 06:00:14 2020 -0600

    cifs: add SMB3 change notification support

    A commonly used SMB3 feature is change notification, allowing an
    app to be notified about changes to a directory. The SMB3
    Notify request blocks until the server detects a change to that
    directory or its contents that matches the completion flags
    that were passed in and the "watch_tree" flag (which indicates
    whether subdirectories under this directory should be also
    included).  See MS-SMB2 2.2.35 for additional detail.

    To use this simply pass in the following structure to ioctl:

     struct __attribute__((__packed__)) smb3_notify {
            uint32_t completion_filter;
            bool    watch_tree;
     } __packed;

     using CIFS_IOC_NOTIFY  0x4005cf09
     or equivalently _IOW(CIFS_IOCTL_MAGIC, 9, struct smb3_notify)

    SMB3 change notification is supported by all major servers.
    The ioctl will block until the server detects a change to that
    directory or its subdirectories (if watch_tree is set).

commit e3e9463414f610e91528f2b920b8cb655f4bae33 (tag:
6.1-rc-smb3-client-fixes-part2)
Author: Steve French <stfrench@microsoft.com>
Date:   Sat Oct 15 00:43:22 2022 -0500

    smb3: improve SMB3 change notification support

    Change notification is a commonly supported feature by most servers,
    but the current ioctl to request notification when a directory is
    changed does not return the information about what changed
    (even though it is returned by the server in the SMB3 change
    notify response), it simply returns when there is a change.

    This ioctl improves upon CIFS_IOC_NOTIFY by returning the notify
    information structure which includes the name of the file(s) that
    changed and why. See MS-SMB2 2.2.35 for details on the individual
    filter flags and the file_notify_information structure returned.

    To use this simply pass in the following (with enough space
    to fit at least one file_notify_information structure)

    struct __attribute__((__packed__)) smb3_notify {
           uint32_t completion_filter;
           bool     watch_tree;
           uint32_t data_len;
           uint8_t  data[];
    } __packed;

    using CIFS_IOC_NOTIFY_INFO 0xc009cf0b
     or equivalently _IOWR(CIFS_IOCTL_MAGIC, 11, struct smb3_notify_info)

    The ioctl will block until the server detects a change to that
    directory or its subdirectories (if watch_tree is set).


On Mon, Dec 15, 2025 at 6:30=E2=80=AFPM ChenXiaoSong
<chenxiaosong.chenxiaosong@linux.dev> wrote:
>
> Steve has already told me that I can use `smbinfo` (which is part of
> cifs-utils) and libsmb2 (which is unrelated to Samba or cifs.ko).=E2=80=
=9D
>
> Thanks,
> ChenXiaoSong.
>
> On 12/15/25 9:11 PM, ChenXiaoSong wrote:
> > Hi,
> >
> > I am currently using the following two methods to query a directory for
> > change notifications on the client side:
> >
> >    - `smbclient`: https://chenxiaosong.com/en/smb2-change-
> > notify.html#linux-client-env
> >    - Windows "File Explorer": https://chenxiaosong.com/en/smb2-change-
> > notify.html#win-client-env
> >
> > Are there any better tools to print detailed info about change
> > notifications on the client side, or any userspace C program examples
> > (using `ioctl`) available?
> >
> > Thanks,
> > ChenXiaoSong.
> >
>


--=20
Thanks,

Steve

--000000000000d885b20646094734
Content-Type: text/x-csrc; charset="US-ASCII"; name="new-inotify-ioc-test.c"
Content-Disposition: attachment; filename="new-inotify-ioc-test.c"
Content-Transfer-Encoding: base64
Content-ID: <f_mj80s7wv0>
X-Attachment-Id: f_mj80s7wv0

I2luY2x1ZGUgPHN5cy9pb2N0bC5oPgojaW5jbHVkZSA8c3lzL3R5cGVzLmg+CiNpbmNsdWRlIDxz
eXMvc3RhdC5oPgojaW5jbHVkZSA8ZXJybm8uaD4KI2luY2x1ZGUgPHN0ZGJvb2wuaD4KI2luY2x1
ZGUgPGZjbnRsLmg+CiNpbmNsdWRlIDxzdHJpbmcuaD4KI2luY2x1ZGUgPHN0ZGludC5oPgojaW5j
bHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8dGltZS5oPgojaW5j
bHVkZSA8dW5pc3RkLmg+CgoKdm9pZCBkdW1wbWVtKEZJTEUgKm91dCwgY29uc3Qgdm9pZCAqcHRy
LCBjb25zdCBzaXplX3Qgc2l6ZSkKewogICAgY29uc3Qgc2l6ZV90IEJZVEVTX1BFUl9MSU5FID0g
MTY7CiAgICBzaXplX3Qgb2Zmc2V0LCByZWFkOwoKICAgIHVpbnQ4X3QgKnAgPSAodWludDhfdCAq
KXB0cjsKICAgIGNvbnN0IHVpbnQ4X3QgKm1heHAgPSAocCArIHNpemUpOwoKICAgIGlmIChvdXQg
PT0gTlVMTCB8fCBwdHIgPT0gTlVMTCB8fCBzaXplID09IDApCiAgICB7CiAgICAgICAgcmV0dXJu
OwogICAgfQoKICAgIGZvciAob2Zmc2V0ID0gcmVhZCA9IDA7IG9mZnNldCAhPSBzaXplOyBvZmZz
ZXQgKz0gcmVhZCkKICAgIHsKICAgICAgICB1aW50OF90IGJ1ZltCWVRFU19QRVJfTElORV07Cgog
ICAgICAgIGZvciAocmVhZCA9IDA7IHJlYWQgIT0gQllURVNfUEVSX0xJTkUgJiYgKCZwW29mZnNl
dCArIHJlYWRdKSA8IG1heHA7IHJlYWQrKykKICAgICAgICB7CiAgICAgICAgICAgIGJ1ZltyZWFk
XSA9IHBbb2Zmc2V0ICsgcmVhZF07CiAgICAgICAgfQoKICAgICAgICBpZiAocmVhZCA9PSAwKQog
ICAgICAgICAgICByZXR1cm47CgogICAgICAgIGZwcmludGYob3V0LCAiJS44eDogIiwgKHVuc2ln
bmVkIGludClvZmZzZXQpOwoKICAgICAgICAvKiByYXcgZGF0YSAqLwogICAgICAgIGZvciAoc2l6
ZV90IGkgPSAwOyBpIDwgcmVhZDsgaSsrKQogICAgICAgIHsKICAgICAgICAgICAgZnByaW50Zihv
dXQsICIgJS4yeCIsIGJ1ZltpXSk7CiAgICAgICAgICAgIGlmIChCWVRFU19QRVJfTElORSA+IDgg
JiYgQllURVNfUEVSX0xJTkUgJSAyID09IDAgJiYgaSA9PSAoQllURVNfUEVSX0xJTkUgLyAyIC0g
MSkpCiAgICAgICAgICAgICAgICBmcHJpbnRmKG91dCwgIiAiKTsKICAgICAgICB9CgogICAgICAg
IC8qIEFTQ0lJICovCiAgICAgICAgaWYgKHJlYWQgPCBCWVRFU19QRVJfTElORSkKICAgICAgICB7
CiAgICAgICAgICAgIGZvciAoc2l6ZV90IGkgPSByZWFkOyBpIDwgQllURVNfUEVSX0xJTkU7IGkr
KykKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZnByaW50ZihvdXQsICIgICIpOwogICAg
ICAgICAgICAgICAgZnByaW50ZihvdXQsICIgIik7CiAgICAgICAgICAgICAgICBpZiAoQllURVNf
UEVSX0xJTkUgPiA4ICYmIEJZVEVTX1BFUl9MSU5FICUgMiA9PSAwICYmIGkgPT0gKEJZVEVTX1BF
Ul9MSU5FIC8gMiAtIDEpKQogICAgICAgICAgICAgICAgICAgIGZwcmludGYob3V0LCAiICIpOwog
ICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIGZwcmludGYob3V0LCAiICIpOwogICAgICAg
IGZvciAoc2l6ZV90IGkgPSAwOyBpIDwgcmVhZDsgaSsrKQogICAgICAgIHsKICAgICAgICAgICAg
aWYgKGJ1ZltpXSA8PSAzMSB8fCBidWZbaV0gPj0gMTI3KSAvKiBpZ25vcmUgY29udHJvbCBhbmQg
bm9uLUFTQ0lJIGNoYXJhY3RlcnMgKi8KICAgICAgICAgICAgICAgIGZwcmludGYob3V0LCAiLiIp
OwogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgICAgICBmcHJpbnRmKG91dCwgIiVjIiwgYnVm
W2ldKTsKICAgICAgICB9CgogICAgICAgIGZwcmludGYob3V0LCAiXG4iKTsKICAgIH0KfQoKCi8q
IFNlZSBNUy1TTUIyIDIuMi4zNSBmb3IgYSBkZWZpbml0aW9uIG9mIHRoZSBpbmRpdmlkdWFsIGZp
bHRlciBmbGFncyAqLwpzdHJ1Y3QgX19hdHRyaWJ1dGVfXygoX19wYWNrZWRfXykpIHNtYjNfbm90
aWZ5IHsKICAgICAgIHVpbnQzMl90IGNvbXBsZXRpb25fZmlsdGVyOwogICAgICAgYm9vbAl3YXRj
aF90cmVlOwogICAgICAgdWludDMyX3QgZGF0YV9sZW47CiAgICAgICB1aW50OF90CWRhdGFbXTsK
fSBfX3BhY2tlZDsKCiNkZWZpbmUgQ0lGU19JT0NfTk9USUZZICAweDQwMDVjZjA5IC8qIHByZXZp
b3VzIGlvY3RsIHdoaWNoIHNpbXBseSByZXR1cm5zIHdoZW4gY2hhbmdlcyBvY2N1ciAqLwojZGVm
aW5lIENJRlNfSU9DX05PVElGWV9JTkZPIDB4YzAwOWNmMGIgLyogbmV3IGlvY3RsIGZvciBjaGFu
Z2Ugbm90aWZpY2F0aW9uICovCmludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikKewoJc3Ry
dWN0IHNtYjNfbm90aWZ5ICpwbm90aWZ5OwoJaW50IGYsIGc7CgoJaWYgKChmID0gb3Blbihhcmd2
WzFdLCBPX1JET05MWSkpIDwgMCkgewoJCWZwcmludGYoc3RkZXJyLCAiRmFpbGVkIHRvIG9wZW4g
JXNcbiIsIGFyZ3ZbMV0pOwoJCWV4aXQoMSk7Cgl9CgoJcG5vdGlmeSA9IG1hbGxvYyhzaXplb2Yo
c3RydWN0IHNtYjNfbm90aWZ5KSArIDIwMCk7CgltZW1zZXQocG5vdGlmeSwgMCwgc2l6ZW9mKHN0
cnVjdCBzbWIzX25vdGlmeSkgKyAyMDApOwoKCXBub3RpZnktPndhdGNoX3RyZWUgPSBmYWxzZTsK
CXBub3RpZnktPmNvbXBsZXRpb25fZmlsdGVyID0gMHhGRkY7Cglwbm90aWZ5LT5kYXRhX2xlbiA9
IDIwMDsKCglpZiAoaW9jdGwoZiwgQ0lGU19JT0NfTk9USUZZX0lORk8sIHBub3RpZnkpIDwgMCkK
CQlwcmludGYoIkVycm9yICVkIHJldHVybmVkIGZyb20gaW9jdGxcbiIsIGVycm5vKTsKCWVsc2Ug
ewoJCXByaW50Zigibm90aWZ5IGNvbXBsZXRlZC4gcmV0dXJuZWQgZGF0YSBzaXplIGlzICVkXG4i
LCBwbm90aWZ5LT5kYXRhX2xlbik7CgkJZHVtcG1lbShzdGRvdXQsIHBub3RpZnktPmRhdGEsIHBu
b3RpZnktPmRhdGFfbGVuKTsKCX0KfQoKCgo=
--000000000000d885b20646094734--
