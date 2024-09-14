Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D865861FFC
	for <linux-cifs@vger.kernel.org>; Sat, 14 Sep 2024 07:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297235; cv=none; b=kiWu7YyuIU//Qebjk20ffnSTeCZyQEi1wMhPJgV3zUzsOyLsADbkKx3Z91yigPiR8oTzUjG31JjfYqBcjPnJVqloS17px5wMCekaCkUnmVn+DYkAAueOgL8gbwNWTt43+MgwhVmvXQtOCs7+/kG5Wk0Qv0OMiiG3grb/VZBZTc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297235; c=relaxed/simple;
	bh=fJTRXVkor+19HCZMs6C1NKwlx9yOLUpG5gvHTJr9KHs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TLU5wmEhZRHguqDaeQZgx7mnlzLXdlqqWfZHmusuWdBz5AkmDu/aOmqfeag3bqCR5cX/elDoWCJuLdZ5xaXtj+vVHMk3aWdu0qZqUf4Z7pTFe527Hcqy68HszMGrOZhhKrZxsl0CoVq4i15mW0rPGSelA9uUv4hFsSbNzX8iQxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EHD4O/LE; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EHD4O/LE"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c3d209db94so3266592a12.3
        for <linux-cifs@vger.kernel.org>; Sat, 14 Sep 2024 00:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726297232; x=1726902032; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DIKb1Ydx4IscWCfyIBM4d64+iaaXSfV1J2zQfsF6eI0=;
        b=EHD4O/LEKoh5lQ6NxQoRu0DAi0A5d6eu+VfvGJGIEylHCt7VBPQDiw2SCU9ANptFoA
         hXL6aXgKPfxcuDrjrl7nK4Et7xbU0uisyCZkx6MIchu0dVtD9qBTK21nzV9QveM6DwEG
         nD2hHQy2NWBTSJ3omlPQjkxaXLehOvUsfvKF7PTudfQYcbXiqETI60Y1gImaEtyPYmy0
         KKBZBgUpLsOiaCREd0rL5ImNT8eunhHsq0hkfqNYEDB90j8vNy/dBVRKP/3GwzmwF8gi
         dPg2hB1hMHIFoR3ivammYLQvRoCeezk+EQSHV/bTAkFSYr6dCaIS1PIOLmxLxh+5X1Rv
         2veQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726297232; x=1726902032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DIKb1Ydx4IscWCfyIBM4d64+iaaXSfV1J2zQfsF6eI0=;
        b=Ua4OD1s4w6EwCwTZA5XXjbMOnASo/jRWx/kIhMinXYZdr8R2/pk9PP/znfZxuaa6Rn
         RxnJ6IzdlVkzNFFV6W2qJUxpRWdkVsdn1SltAMg6kXhT+jFopR+cyl0ZKcXZiBfScHIa
         YT2LRLxCR7itV/f0aTydWLq19M2yWI76zsVobwj5hi2mcy17IfEEcF+jMGxYb0I+TAQg
         ZwzWwNm4t67zNDa/ix09LefBRtfk88B073IqE64xAiJaL8MXSRyZvrWRPxb4XQWvLOrh
         sA5OuuM4jKW/NCEvtnK66YpCUmnX/BVLhNHQgD32U1+08T0RVzy0CPjqt1P9YjwuiDeL
         e9Rg==
X-Forwarded-Encrypted: i=1; AJvYcCXSRRq+f0abUObCuR6pOLFk73Aei1TxlKv34lZVCF99usslavzLqRFIOqQiO89O2zO0XBp/7q4ypagF@vger.kernel.org
X-Gm-Message-State: AOJu0YxRxztGi0gHVR3FTTCxWUuj5uX50AeagdOvy+4rSPmIrEpUQ99X
	HsBN6S90Rthbwo6O+Z6lNODJ0CKbliHz9US6RenLmUSRGkf9CJyPkqdH/HbQd7shYAFf3Mtu7S/
	VEqL5umfyJCWLzgEkrKjXV6I6VlI=
X-Google-Smtp-Source: AGHT+IHhZ7hzKoGRxLECmu8/o6p6ngS0GyKLDs3INxkradcgbHhzRsOwBplkx0I3h6HjbtrUvfJL/FNvG7auoqtYbiw=
X-Received: by 2002:a17:907:60d4:b0:a8a:7248:d4c5 with SMTP id
 a640c23a62f3a-a90296202aemr960914566b.42.1726297231746; Sat, 14 Sep 2024
 00:00:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240826032803.4017216-1-cuigaosheng1@huawei.com>
In-Reply-To: <20240826032803.4017216-1-cuigaosheng1@huawei.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 14 Sep 2024 02:00:19 -0500
Message-ID: <CAH2r5mvnh7KKLceWPkg2WG8J9btcAVp=-NZ24YWHMo8k7okgng@mail.gmail.com>
Subject: Re: [PATCH -next] cifs: Remove obsoleted declaration for cifs_dir_open
To: Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

thx

On Sun, Aug 25, 2024 at 10:28=E2=80=AFPM Gaosheng Cui <cuigaosheng1@huawei.=
com> wrote:
>
> The cifs_dir_open() have been removed since
> commit 737b758c965a ("[PATCH] cifs: character mapping of special
> characters (part 3 of 3)"), and now it is useless, so remove it.
>
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> ---
>  fs/smb/client/cifsfs.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
> index ca2bd204bcc5..61ded59b858f 100644
> --- a/fs/smb/client/cifsfs.h
> +++ b/fs/smb/client/cifsfs.h
> @@ -106,7 +106,6 @@ extern int cifs_flush(struct file *, fl_owner_t id);
>  extern int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)=
;
>  extern int cifs_file_strict_mmap(struct file *file, struct vm_area_struc=
t *vma);
>  extern const struct file_operations cifs_dir_ops;
> -extern int cifs_dir_open(struct inode *inode, struct file *file);
>  extern int cifs_readdir(struct file *file, struct dir_context *ctx);
>
>  /* Functions related to dir entries */
> --
> 2.25.1
>
>


--=20
Thanks,

Steve
