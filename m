Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B803E1DA62E
	for <linux-cifs@vger.kernel.org>; Fri, 24 Apr 2026 21:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777066901; cv=pass; b=lu15z6gx2PgCSOY+zph7JDfQAaT8AiFkR36OS8bZqceT1PNI4TYrGAuAG7UmOxmeQ1H2zVH1sIgueZXBJlsd+CSl/unbfLK9YGoiMqzMxh91MKnwCc9PyLg70PAL8DrQKXfyYor7c2LQnoLD9KfqIW5eJvGVGEXhh/hfg/j1T68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777066901; c=relaxed/simple;
	bh=wdZHR6y1hg1wX6a3PW3X8QB50GnbHZ0LacwHOJQo1kA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WuLfcZH4mtf17ivb+Yn6UFElM2wJRIT1aF5i2Zv126izHH89QCCoqvyMJJEIVBPIYYg3Vx1tPjdr4+ruBaVewlXWrPQO56Do+kvLfYPAMCoqpsTEeqEi/YyMwKxQhT6kz6ansohBBcebdn41+D78+68fWzDU31pfesN/HhtFJB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bKPULHoE; arc=pass smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bKPULHoE"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8a151012558so88939446d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 24 Apr 2026 14:41:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777066899; cv=none;
        d=google.com; s=arc-20240605;
        b=csrFak/QNduLTcIYwZwT9T5gyAe0unoS7+7Fc0umToqwBGiXjNcFeGoHZvIGpUix6E
         YF8gZ3+jVhVprNvpT1Op4vvDPRuQLmXduEDpM/1+MhiDAns39FSX0R8FKBdaSoRsWIGf
         ThSthzFJDzIbUW9TzbsuElQIfsOXxMRozFdScp+Mgm//99aMpClGBk6KVz3YN+dd63VR
         OsfiV2ysFIMQAIPBMT73XnlLlrycps2oh8VNmfRw9ZFbl4RStEqg/Og0IyB5gqiRCGbT
         2v1ie67K5qPcrMcgzXhXerTdlyfjUglUiiQGnCYSJ2iQpiHFlpmqltzzqUs879igvWeT
         B4gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5f29QzAEDUaUtvIHxTJaU0kJo8gpp1zKNjg2ruCLPPo=;
        fh=Gn/fZ0vI/MlkeqUbyStAmmdHFkFkcL7kC0yXwf5EKkU=;
        b=J9tZ9372U33uVsbGbJUz6nyqRf2Gs6TzYlS9nshrDdAIHHAcmqGfh1NMunVOZXy3ww
         erwQ/YjYBRjkfzoVQiWPatDNABw6TOxgmJZwCv7EpBaWDSreuTMvR8YRno+W3Sg22Z4R
         aJNdcsTw7zBgowzZZGMBEL3tyMstURaJ0gagaPc00ht+UF5i4V2kiLYIlDfUGnV8SZDG
         IX1bCkUJr/V0fV4wGv2K9ZG07C1XK7gpybCQGhouY6tspBL4imeEzH3jI8NEEOXpLEDa
         iajaHoGAdAdeZncdODLjVUy6AbGXea6sMp4KWn2FI/QNf9zSELpSP2ks3iVTnZFMOCYb
         3RBA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777066899; x=1777671699; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5f29QzAEDUaUtvIHxTJaU0kJo8gpp1zKNjg2ruCLPPo=;
        b=bKPULHoERpYK0d0ioZdlzURi3SDn+s6JELwLxlmP6GbE/7OYZWxmpLMWz9Tv4M7IJi
         lAePBUzNHxUOmKfvJoGgqEefRf2RFOAO6a0Vx8/PsqQNxbyd7T//wlEroDq39nWnvlep
         sylWDDZDzaaqMRt4KwrjnxI9++1SRFSrnUTTH4DaTYHZH7qwsOxzfJeqZFBshItoHGSu
         mtUJoGHaWj99YnOXP/9YYIz6trF+rbfSwSxHWROGbM7wm4PjtTfPqXf3iRqs3d7fY0qX
         UaUK2pQ+J+UD9PW9iJsB3N3ntI7wIO99e+2YZDXI2jGOwmYAI6iZ3rGUrnnvs+Cemy5K
         Gbbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777066899; x=1777671699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5f29QzAEDUaUtvIHxTJaU0kJo8gpp1zKNjg2ruCLPPo=;
        b=ri0Yhy+Gm7BLcINUwRsgYmUBzstK2nCi7n2qrhiStmrKrPKXzzDy/xKYwgX8O+bat7
         ozn33igt1F+1CNqmzxxtGhOvcbCGFVjbtmIkqZPhMDsABmXw5KbwnvCCx3v0hDoz9LH4
         Z/VvBnP1+hKQLwF7rNrm50VGxS5mv+38BUOH1wr9IE9YdRXlcRVjP7HmncjP1S9qKPHW
         /IC+UkRpUyddOMse7nZSxtK6N9ftFFa3FIqosjmnvOxShCgr9YSXc+2EsKG4SvSqmknq
         RdTK02WUSnD6TNiGXgC+UmSuftBCodLDidJqklRUWBKFCIOgGvDgt2+2A3h1QtWECUlv
         E9MA==
X-Forwarded-Encrypted: i=1; AFNElJ8rLRUFrsRUX18ush8ySfLPcubwWcYbUQHun2Dfal8rXz99Z0rekzSTY/TQQ4krt76o/GbK4PyLKKkz@vger.kernel.org
X-Gm-Message-State: AOJu0YwDyDmSVOb+plafgJERigscZ/KujshONGLYjP/JxbqI9+xbfYjW
	lOM7uuI13Zdg3hMbwxhVH29dCjhDnqlFf/1fdsF+jIB2KuvK+hPmsktYEen6YhCJoUbMcE/KI4g
	VNNVVCBOJa5jBCdxXz8b18/IrE62gV0M=
X-Gm-Gg: AeBDiesJbm/kNsnzlorzv6DgoDwrG7ll7AAqz+j1/sefzaLXVF920TB1dHAGAH8Ewa3
	GDUZd8yvzbPTCxllIy6dEKEHUC/Fl6vArdb4VfEIflaNxSdoPofrVOQWkN/lFGYDytPiHo510AD
	yxlQv1q8nZ8zvAZw8R8/YU0JKKLGeZrVgBxPzGISgoiGxSutU/Qy+tMM9kXU38murl3auFFlI5s
	Gu72KrQOkpbrDgBiZtnAvy6MGGl8UT1DeWp5IpUvM4n0/okQWhGQ7QoUBc9Sjygy7xpYwopt2wb
	jjsKEK5/SxbbWyFr32GaB3H1vGY0f5u1pPqphNsSb+yUTPVM+DQ6xdqnxezxlIPuuUuO/uzmi8k
	MxKs6lZ9zs/eZjkA5xDKdVT5Ihzs38CAZjgM2hndOLBE9H+LMGapReheb3GQcsOlrdd0BGMw297
	zm20wcg4aFVGgfwcfnEshZee3mMYTYFMQM
X-Received: by 2002:a05:6214:5d82:b0:8ac:ae4d:7de3 with SMTP id
 6a1803df08f44-8b02808005emr542479926d6.22.1777066898587; Fri, 24 Apr 2026
 14:41:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260423055915.695024-1-youling.tang@linux.dev>
In-Reply-To: <20260423055915.695024-1-youling.tang@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Fri, 24 Apr 2026 16:41:25 -0500
X-Gm-Features: AQROBzDFtvMZVAK35YyFHSHoudeYt35tw6rLVFvQPQKz_iTR_v32FTcWC26txsM
Message-ID: <CAH2r5muDQM93tWbEtjbYsUVjnQcERKhCHjwmJJmjcA54ZxUS6A@mail.gmail.com>
Subject: Re: [PATCH] smb/client: fix unaligned reads in wsl_to_fattr()
To: Youling Tang <youling.tang@linux.dev>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, chenxiaosong@chenxiaosong.com, 
	gregkh@linuxfoundation.org, linux-cifs@vger.kernel.org, 
	Youling Tang <tangyouling@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Were you able to reproduce this bug with a test?

On Thu, Apr 23, 2026 at 1:00=E2=80=AFAM Youling Tang <youling.tang@linux.de=
v> wrote:
>
> From: Youling Tang <tangyouling@kylinos.cn>
>
> See MS-FSCC 2.4.16. When multiple FILE_FULL_EA_INFORMATION data elements
> are present in the buffer, each MUST be aligned on a 4-byte boundary.
>
> When parsing WSL extended attributes, the code derives the value pointer
> at an offset of 7 (SMB2_WSL_XATTR_NAME_LEN + 1) from ea_data, the value
> sits at an unaligned offset.
>
> We should use get_unaligned_le32() or get_unaligned_le64() to get
> unaligned values.
>
> Link: https://lore.kernel.org/linux-cifs/77013349-ff89-4593-985d-520d967d=
2638@chenxiaosong.com/
> Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/reparse.c | 6 +++---
>  fs/smb/client/reparse.h | 6 +++---
>  fs/smb/client/smb2pdu.h | 1 +
>  3 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index cd1e1eaee67a..eebce954c5ce 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -1160,7 +1160,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data=
 *data,
>
>                 name =3D ea->ea_data;
>                 nlen =3D ea->ea_name_length;
> -               v =3D (void *)((u8 *)ea->ea_data + ea->ea_name_length + 1=
);
> +               v =3D (void *)((u8 *)name + nlen + 1);
>
>                 if (!strncmp(name, SMB2_WSL_XATTR_UID, nlen))
>                         fattr->cf_uid =3D wsl_make_kuid(cifs_sb, v);
> @@ -1168,9 +1168,9 @@ static bool wsl_to_fattr(struct cifs_open_info_data=
 *data,
>                         fattr->cf_gid =3D wsl_make_kgid(cifs_sb, v);
>                 else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
>                         /* File type in reparse point tag and in xattr mo=
de must match. */
> -                       if (S_DT(fattr->cf_mode) !=3D S_DT(le32_to_cpu(*(=
__le32 *)v)))
> +                       if (S_DT(fattr->cf_mode) !=3D S_DT(get_unaligned_=
le32(v)))
>                                 return false;
> -                       fattr->cf_mode =3D (umode_t)le32_to_cpu(*(__le32 =
*)v);
> +                       fattr->cf_mode =3D (umode_t)get_unaligned_le32(v)=
;
>                 } else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
>                         fattr->cf_rdev =3D reparse_mkdev(v);
>                         have_xattr_dev =3D true;
> diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
> index 0164dc47bdfd..653213a6b7e8 100644
> --- a/fs/smb/client/reparse.h
> +++ b/fs/smb/client/reparse.h
> @@ -23,7 +23,7 @@
>
>  static inline dev_t reparse_mkdev(void *ptr)
>  {
> -       u64 v =3D le64_to_cpu(*(__le64 *)ptr);
> +       u64 v =3D get_unaligned_le64(ptr);
>
>         return MKDEV(v & 0xffffffff, v >> 32);
>  }
> @@ -31,7 +31,7 @@ static inline dev_t reparse_mkdev(void *ptr)
>  static inline kuid_t wsl_make_kuid(struct cifs_sb_info *cifs_sb,
>                                    void *ptr)
>  {
> -       u32 uid =3D le32_to_cpu(*(__le32 *)ptr);
> +       u32 uid =3D get_unaligned_le32(ptr);
>
>         if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_UID)
>                 return cifs_sb->ctx->linux_uid;
> @@ -41,7 +41,7 @@ static inline kuid_t wsl_make_kuid(struct cifs_sb_info =
*cifs_sb,
>  static inline kgid_t wsl_make_kgid(struct cifs_sb_info *cifs_sb,
>                                    void *ptr)
>  {
> -       u32 gid =3D le32_to_cpu(*(__le32 *)ptr);
> +       u32 gid =3D get_unaligned_le32(ptr);
>
>         if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_GID)
>                 return cifs_sb->ctx->linux_gid;
> diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> index 30d70097fe2f..6744606dab6c 100644
> --- a/fs/smb/client/smb2pdu.h
> +++ b/fs/smb/client/smb2pdu.h
> @@ -211,6 +211,7 @@ struct compress_ioctl {
>   *     BB consider moving to a different header
>   */
>
> +/* See MS-FSCC 2.4.16 */
>  struct smb2_file_full_ea_info { /* encoding of response for level 15 */
>         __le32 next_entry_offset;
>         __u8   flags;
> --
> 2.53.0



--=20
Thanks,

Steve
