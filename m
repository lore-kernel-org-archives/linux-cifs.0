Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DB447DD50
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 17:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785863322; cv=pass; b=masbALbAfY5DKxXcXlvsvrAf9CcSMuHpPprskaquZkQy41f5YtUR1iDiaFTH6avR23PrKwPa1KF+o7I8E9LvTI1r5EPtPdUqRWDs1kOM6CVOjYsio6q/DFlreNAoe26hE4dV7DaadWpwQHOKFcG3TfeJZn3NpUYoo/FPc3BzSLQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785863322; c=relaxed/simple;
	bh=/3z92dzZ7siaGUH9qlC7WZUvcgKWqSbVZWdcJdQ1s8A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aWHEgeIuIohrsYH4e/3OeGeblhTDhjSh/ErAlocqhRthTffWY2MARCLOYJBAEViOsn/K+bD5/k64V1S8FMSCVJ0TyqfoqhT2j2sfUKrt0en3+6H5h8BQQYkpQBewXI4urwFmYzoOw/zIavDpTt9y3jR6VN18not5KdjAE9ZSAaE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jem4IEd+; arc=pass smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jem4IEd+"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93108a3c326so81854185a.1
        for <linux-cifs@vger.kernel.org>; Tue, 04 Aug 2026 10:08:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785863313; cv=none;
        d=google.com; s=arc-20260327;
        b=PbfDVsyKRBmJJR4nZEtdlQ7pagOqmCpUIiSg8+gj81JqN6V3pg5FrRvzMDI19cVa6+
         ktKksExxEX3AQtPRbE0QW2dqtERf/FjyRIoMaX2/Heh75YuMZ+4cn9hiaBEkIZMkLhc4
         Py8mdbnkAeAZ56QhIlnDhthLKIYwZVVGUf87NK/NcoXqB4FlaRFEwsAj2zK8pVFQPCOp
         jPgUCwtin0o0Ly8tZVNL0I/pi/u6fZJVKG7Q4mgtH++HEphLR0ijdYv6ncOCuuEZy1Db
         YNIJgnBJVtu4PIyrfsrd+Y6JF3tE7Qqkyfs+F4uX7t2m9lndAzpSPTpOdrM7YMerGcfe
         OOSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PgmhZ7U5+qyUjfFnw3ZFKZmBsdiXoPyqnsVEpOQUGRc=;
        fh=tHqS+GEFCzMc8+k55/jl3JuGHXAw6eKyReaCfgHaECM=;
        b=Q+wuggGOCsmFPcO+8nG1JVhVMez0kzFUMLf2jp5InrTHfKa4Ivq6msaUyt0w5eALJs
         26xqzb22oynxjfE/aVhNEWYuERh62YDgGFQ0pEvmBOmnrmVbU7nEij9u9zvFOQxZEX+N
         mb9oPUpoInC+1tQPCTkOG83uqBdGgKqjJUze/sygEJegnNKqHoR/849fP9Bdp/tpkxJ8
         KIu05VRP8/hEiYlaBxOOOA7Go3A+BcwLxryT2RUsTMUCxarRXolRtjpWJATZGIsV7mQO
         NUm7gxyxQpt21Qr1u9S+FPo7MDFrLI/vPBko754zRlPEjodIFHbqeOZVIb/EesiTbIe0
         ZFtA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785863313; x=1786468113; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PgmhZ7U5+qyUjfFnw3ZFKZmBsdiXoPyqnsVEpOQUGRc=;
        b=Jem4IEd+Pfb4wpmwIzCZVpdR4qMWOzlgUUtxXmDaiYNuKedUIJk1MGDhorVmkAcuKP
         VZ6uRWkqKhA3tIkfXoeH1j3DNXBOLqF4AkFNuMEFhigpg7wn7pveMit2kKLX071RMNuL
         OPDTUj3OZ0ZaBf+zkGbuRQXVybA/arTWZUsroFoCynPqEzbbCVGW1gXo8/M8iKgy+sAV
         eQxScBuvHD+1CcuPQammntDlFmahzApVADn9uBW8mi7TjTh8CvxTjBpmNKnKDZdMxLHI
         B6jBl7WIaRPYqF+0GbEOA+xolNJq9bTdUHkLQX6FZmpeOjiTeYOf95YndUK1OJwNU9co
         3VAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785863313; x=1786468113;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PgmhZ7U5+qyUjfFnw3ZFKZmBsdiXoPyqnsVEpOQUGRc=;
        b=SdJB7AnPD0R6rRK5SuUiDQeeEAVLuF6PjDsjOYimoLKKSqcAB1b9PtLcqELJy/YzS3
         7nvfDjw9/F0SJEdSPpyocZB/0hVfA6WJ2FuuYqFSBBLymuhVv6ZHGj9aRm5CNyxdWAsb
         mUK+cWQm5fLcrDoyP4wPhXmRHxVT2XkGv1k6LB2F9Q89PKHW3opYy8fRqVgHDBy9J7/A
         saOouO5qI9otE/CLJWn6+3dFZAwPOPqjX+HgN7v7H5iJ6eag9DxVjcL1HwKDT0wzc7TL
         2fzSU1JA2yF9S123F6J8g5GhGgIyV5A4EIzWyfk7L3CRgAwqi25PEYn3dg++pOiymyZe
         jWNw==
X-Forwarded-Encrypted: i=1; AHgh+RrztV0NeHjys98eMQo0ELCwaZ/IU+JNFLp/8ek675qi/JnSiyUNIOZnJZtTpA0kCSF+nbXn12yG5fXN@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5aXTJfSREwf8TlPla18KS0Yuh1chprEY+xMeyIlBk1+IrZ7FX
	8jqK/OK9FDtlfAUQ8DDAuNxbTPf3cz4J8ILpgiB+T4gawo4hrTryCv1Fjw3BYfnXTEHipT5j4SC
	6TTcGpfF+KectnBcW1R4+pzrJbtxsRBs=
X-Gm-Gg: AR+sD1267DRwcDQCZRCHAnuos0M9547U7MmZk/ut4pBiavOrWtd3EX5gbOaCXqTMKmM
	rrjynr2dLGV2w8mgVTVu2dGT7DI/0E15TJu3sRJRqk/9LMBv9RF+iYOipJqJGyxs2Lxp+6ZVsRn
	bYp2dnnGNmIrZ4tYMkYJJsN2ON2m03ywPwzLYq9nNsKXLHz0cEI+2RstV98t66Y8VJceHzFpo8A
	7vgrL1bM64lTzkx+ZGlDzciljG/GIrge09opnlLrwsorwGiCipN47qy0xl4m8hj3dO1824VU7MR
	GUsbJo+dulZWJCcXaTc+KLQ7EQg89L8XwBDTqwCnM01M6kCAv6DRgE4pSWu1imZoJTZk5DeOckp
	H9KVKauytdefrUrq18MPrt4vgx8sNHKtdKGKAFqkiY0NJH1Lqj/sQnP+vMmxV7WN/6A+x0ZGZRH
	N49nWdpnMEdyjyZ+sdU9vdEMiDLYSWT1raoaZ9LNdv/6JEDsjU2EHMgcJ2QQ==
X-Received: by 2002:a05:620a:44d0:b0:930:e82f:7bd1 with SMTP id
 af79cd13be357-9363180373cmr778026985a.1.1785863312723; Tue, 04 Aug 2026
 10:08:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804123301.285434-1-chenxiaosong@chenxiaosong.com> <20260804123301.285434-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260804123301.285434-4-chenxiaosong@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 4 Aug 2026 12:08:21 -0500
X-Gm-Features: AUfX_mzkHXNsJDE0cWTkysVQR1CoVl6qP1se9lOu3BNqwPgpQfnHUbhNE7-T0eU
Message-ID: <CAH2r5mu0rQKQDHgcF7jTBUk6zHitWinP5pzNUQ6+MxqP7j6w=g@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] smb/client: fix nlink of an overwritten open file
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	slow@samba.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> This patch fixes xfstests generic/035 when mounted with `posix` option.

generic/035 passes to Samba with posix mount option without the patch.
Any idea why this patch was needed for ksmbd but not for Samba

On Tue, Aug 4, 2026 at 7:34=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Reproducer:
>
>   1. server: systemctl start ksmbd
>   2. client: mount with `posix` option
>      mount -t cifs -o posix //${server_ip}/export /mnt
>   3. client: touch /mnt/file1 /mnt/file2
>   4. client: C program: int fd =3D open("/mnt/file2", O_RDONLY);
>   5. client: C program: rename("/mnt/file1", "/mnt/file2");
>   6. client: C program: struct stat stbuf; fstat(fd, &stbuf);
>                         stbuf.st_nlink is 1, should be 0
>
> This patch fixes xfstests generic/035 when mounted with `posix` option.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/inode.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 0afff761aab9..0b6273ce01a8 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -2648,11 +2648,8 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode=
 *source_dir,
>         if (d_really_is_positive(target_dentry)) {
>                 if (!rc) {
>                         struct inode *inode =3D d_inode(target_dentry);
> -                       /*
> -                        * Samba and ksmbd servers allow renaming a targe=
t
> -                        * directory that is open, so make sure to update
> -                        * ->i_nlink and then mark it as delete pending.
> -                        */
> +
> +                       /* Update the target link count after rename. */
>                         if (S_ISDIR(inode->i_mode)) {
>                                 drop_cached_dir_by_name(xid, tcon, to_nam=
e, cifs_sb);
>                                 spin_lock(&inode->i_lock);
> @@ -2663,6 +2660,10 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode=
 *source_dir,
>                                 CIFS_I(inode)->time =3D 0; /* force reval=
 */
>                                 inode_set_ctime_current(inode);
>                                 inode_set_mtime_to_ts(inode, inode_set_ct=
ime_current(inode));
> +                       } else {
> +                               cifs_mark_open_handles_for_deleted_file(i=
node, to_name);
> +                               cifs_drop_nlink(inode);
> +                               inode_set_ctime_current(inode);
>                         }
>                 } else if (rc =3D=3D -EACCES || rc =3D=3D -EEXIST) {
>                         /*
> --
> 2.54.0
>


--=20
Thanks,

Steve
