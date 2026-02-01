Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6987220C038
	for <linux-cifs@vger.kernel.org>; Sun,  1 Feb 2026 17:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769966994; cv=pass; b=IfOuSpUcCNkfbh1+Y+HmEqaZTWb6pjmGhPR5dIcn8xyT8uD5V/8aFSAL4sZTLxB2wIIufD6burOu/nGnEXXVbyHdKULD+ZfqXYYez4k5c9JSWNS6rZu7nH8SHPx/vX0aDHs+b+xyQho/RtK/DemI8nQg63ZTT4kdggtSvPMNlgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769966994; c=relaxed/simple;
	bh=V0JVOX57LhC+0Ud5G7M3NjgXTvqU8JXYIIrYyhkbfo0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qhFmrjkD6SXDHl28XKOa7xKQw5i1PVu7hHwD6WzAMk4XUBkYf3/OS+NCGU/7Pt0+e17Cz+CfrIEb2Yijl2M25g8eBwoA832COS2w0Rux7d5mxG6Cl6BejXrefnNKxH6of7A5cMcJ6ir24997kEQJWqjBs33o4lHRUtbGzj0XIw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kK3Iqe10; arc=pass smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kK3Iqe10"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8c6d8751c88so396168885a.2
        for <linux-cifs@vger.kernel.org>; Sun, 01 Feb 2026 09:29:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769966992; cv=none;
        d=google.com; s=arc-20240605;
        b=iDE5p3PT4cXzcvnEVXI1NPzSB7yENh3TySrJWwq/6zX+9EnbqK/XT46OwG1h9ewEEA
         6t50/qpqdKGk0OiRKx7OLY6lo6v0ZQkY4psvS8aKMYhI+LsuwuBM1JA+z2iMKbgOz914
         LTggtPOq8sx+U+NjlmRhw7LdID2vhgM9tWPR6ZUVfx0mjbyCufssIlF2eeiaEFeIy/j8
         geltfl+NAMeDuZxGu9E5AmH269hGWlaDOamDWbgM89HMU+zM0mosBsP4Xy4qt62OMySA
         /ST7o+JBXIwR/w3viGp5rDZp8c4oe7upnfgExjDl6sdLsbXNYlucPXLyOhTAytDPXfQC
         QwWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uPM/v34QgGjDGZhwyhaDdMN7hFv2rocYBUP1+tBCXb8=;
        fh=2fDzuJ1kbPl5SEu2p2hyvdy3Cd7p0SnJ5C4ZY20Dikk=;
        b=cwXSB5S+hlvNSThoh6QRgFaQWGkF3jQhY5SIbXu5IW/MlrCESkgoqRj4M5gG1vYwJE
         +YzZtOL+UNzYuvmmv7+/GkqEbY8PNp/XOIDzZL3f30z0jqG310BRI5pCElIRc/c7zj7a
         WHZ6veQBAX+UI5zWL19pibP/DfPZF26JUICY38X2Wy5vLUk5vFrQ4Mru8bpug/k8AgKo
         RKAs9jY5Z5IhgYhTIvjzD3rGjS9ggXZl5duKpthNNeS8kUJ04zWSyfAQaQcO8QOSb7+F
         +kPL4MPuwhLT60L+zGE5ofBn0ffTZgY88VRKUSUsN/T5ZhBV0Pac6BK+qLrG0Imjioex
         BxAA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769966992; x=1770571792; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uPM/v34QgGjDGZhwyhaDdMN7hFv2rocYBUP1+tBCXb8=;
        b=kK3Iqe107NvHwpqgQrWNVJ2osjBJgnX9gUE0V/mmsp4dGEl7mkDWvJyZUlQGVZ93Ft
         SZ2AA09vER8m+Fgd7A8uS4f7v+7YHf+LPtttaMBpZlzj/vvzyRFh3IviCADMNdVFPZ10
         4sW0FSMaQ6Jl1YvlP6a4o4yyGSzcNK61h2yA/cUhIdKmYTVe7c8nGiE8E64GWlM3le++
         yDFFP04qyL3d3p9xq+FJy+SzAFgSW1wKFaaTHzepbY1csUgm56Qf+J0aAQGR4tjtgak8
         j+6MG1jX3l/h5997druRquPL2YT3hzWbce+z1mQgu7qja52ydrttF2e/MkG497BZldIz
         04sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769966992; x=1770571792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uPM/v34QgGjDGZhwyhaDdMN7hFv2rocYBUP1+tBCXb8=;
        b=EvpZLp5pVTiTgKhF9Upz35r98rWSz83alj6r2xPFIitsu1c7O5OG5knHzQtmpQv23m
         6Jc3AvzwN4dUsDCvAyQPgeEVNAkRWzbdYJb8qd2K3gx7EHi5q2zzCIE3D9nV8EmSSAPo
         SACg9DTUf8hE74uhmnc2t++kpZ4Uwq25Y27uhJ6eAf3HkyBdgvjhSmCuaEQN6lyJevVz
         wo4jqtaIvT2JPHrT6yh2BrV+beTud4f5RwHFM/0bBEZb+D7R7Uz2RNG66HV9F8aiJrgx
         ooxV70KtLGqdOP/1QCLOoz30v6u2gEWAaqlJxB/N25dj1UV5Q6jjYR0K1CIp9idRYA0J
         IAhA==
X-Forwarded-Encrypted: i=1; AJvYcCVpaaX2SigkBht1lFxLEqLTyhnimFpCdO+iQ2WBwhbq4RecZIDK2dfFIyfazpCLI4ZwgT2SNl/NXKxu@vger.kernel.org
X-Gm-Message-State: AOJu0YyrtkBU6m/GfjcEw2cObOI5V6x3OEeA/5pNIT2dwWM1ieXuswyj
	Wq0Zq9FA4Zg/+cCTwomGCWtwlcC+LmFJAWM2MdKuT6dOybyAZ8lR9tYf55SUC93v4H5ZebgBQJG
	/7dahylrjuFPaEka3W8s94+jdQkJKqt4=
X-Gm-Gg: AZuq6aICaDtWwJ5nkccU7ZAv+5IR4+H3z62/KHrdIESDtotZONnr5drwEImCjk2r+TQ
	26Lr6VcgBD/Sger3UeirSyH2gTgMd9BSkw8qxeYpR5qMqTUtUkYvk6K3Y10CXPimy5oqw+4PO59
	yaOuhgHWE0VyMIJYKHT/MPXyEd5UInnYnPWYVXZPnxGbEBm/hGXTrEf6Qkg2bvZlmhvJdq0176u
	eExFuBFpc3pPuaQsLkU6wTYN+o70zHdj6NnZXTY18nB75jquw3IbIKBsGC25VnjM6rbtpKHh1kZ
	zbTEZEDdTw8nPhC7gJE0JV2B8W1KxmFswE1U91rQyLvEy3ePMjvzWjdLgtG2jQ2VustpFPHlaAS
	RL38HK3W6P+JVlmjiZGs26JBBZ40POAWg2x0hmjXNDTBZDBoRAxW1N5FzSth5EwSTo/BTL6hqoC
	2vIgF2mbeZajUHxAvi4G8=
X-Received: by 2002:a05:620a:258b:b0:8c7:fdc:e87c with SMTP id
 af79cd13be357-8c9eb2eecaemr1085706885a.51.1769966992165; Sun, 01 Feb 2026
 09:29:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260201081017.998628-1-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260201081017.998628-1-chenxiaosong.chenxiaosong@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Sun, 1 Feb 2026 11:29:40 -0600
X-Gm-Features: AZwV_QgEJ5jRGrWVf6Bd-6DMoualyMmfsitsPAsNtQdMg8kOwg0ECIrf5663nA4
Message-ID: <CAH2r5msbLmvEpaDt4HK+jdRQw1kkh13iNtigNZ_-KxyozDoa-Q@mail.gmail.com>
Subject: Re: [PATCH] smb/client: fix memory leak in smb2_open_file()
To: chenxiaosong.chenxiaosong@linux.dev
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, nspmangalore@gmail.com, 
	henrique.carvalho@suse.com, meetakshisetiyaoss@gmail.com, ematsumiya@suse.de, 
	pali@kernel.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good catch.

Added to cifs-2.6.git for-next

This fixes the problem for smb2 and later (next will be to fix it for smb1)=
.

On Sun, Feb 1, 2026 at 2:11=E2=80=AFAM <chenxiaosong.chenxiaosong@linux.dev=
> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Reproducer:
>
>   1. On server, set the permissions of the shared directory to read-only
>   2. mount -t cifs //${server_ip}/export /mnt
>   4. dd if=3D/dev/zero of=3D/mnt/file bs=3D512 count=3D1000 oflag=3Ddirec=
t
>   5. umount /mnt
>   6. sleep 1
>   7. modprobe -r cifs
>
> The error message is as follows:
>
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>   BUG cifs_small_rq (Not tainted): Objects remaining on __kmem_cache_shut=
down()
>   -----------------------------------------------------------------------=
------
>
>   Object 0x00000000d47521be @offset=3D14336
>   ...
>   WARNING: mm/slub.c:1251 at __kmem_cache_shutdown+0x34e/0x440, CPU#0: mo=
dprobe/1577
>   ...
>   Call Trace:
>    <TASK>
>    kmem_cache_destroy+0x94/0x190
>    cifs_destroy_request_bufs+0x3e/0x50 [cifs]
>    cleanup_module+0x4e/0x540 [cifs]
>    __se_sys_delete_module+0x278/0x400
>    __x64_sys_delete_module+0x5f/0x70
>    x64_sys_call+0x2299/0x2ff0
>    do_syscall_64+0x89/0x350
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>   ...
>   kmem_cache_destroy cifs_small_rq: Slab cache still has objects when cal=
led from cifs_destroy_request_bufs+0x3e/0x50 [cifs]
>   WARNING: mm/slab_common.c:532 at kmem_cache_destroy+0x16b/0x190, CPU#0:=
 modprobe/1577
>
> Link: https://lore.kernel.org/linux-cifs/9751f02d-d1df-4265-a7d6-b19761b2=
1834@linux.dev/T/#mf14808c144448b715f711ce5f0477a071f08eaf6
> Fixes: e255612b5ed9 ("cifs: Add fallback for SMB2 CREATE without FILE_REA=
D_ATTRIBUTES")
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2file.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
> index 0f0514be29cd..9ab0df01b774 100644
> --- a/fs/smb/client/smb2file.c
> +++ b/fs/smb/client/smb2file.c
> @@ -178,6 +178,7 @@ int smb2_open_file(const unsigned int xid, struct cif=
s_open_parms *oparms,
>         rc =3D SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data,=
 NULL, &err_iov,
>                        &err_buftype);
>         if (rc =3D=3D -EACCES && retry_without_read_attributes) {
> +               free_rsp_buf(err_buftype, err_iov.iov_base);
>                 oparms->desired_access &=3D ~FILE_READ_ATTRIBUTES;
>                 rc =3D SMB2_open(xid, oparms, smb2_path, &smb2_oplock, sm=
b2_data, NULL, &err_iov,
>                                &err_buftype);
> --
> 2.52.0
>


--=20
Thanks,

Steve
