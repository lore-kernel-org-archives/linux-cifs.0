Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ED819B5AC
	for <linux-cifs@vger.kernel.org>; Mon,  6 Jan 2025 17:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736183029; cv=none; b=bkhGqtISIJy9Xyu71G42k7nUFOB2Zwd+qESEOuqXctrRmQAcLPPhpYRnjUTcfvsBQf4psHDuThX3C+xMoUWFW0NsGCFhWR+O+RMNTAbBl/aH7ftIs97Y53JP7HBIKIYe3UOVgHExyhBHW+3yBxHn4bufmaTTMLcG23QbxPc855w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736183029; c=relaxed/simple;
	bh=OmZH5DFI3ydMZxsFlgjunTH5iT8WY/3SKlvaV8ZTqOE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PlRetqONASqjwbjbKeXuohRopWcgaZjA+/yRBJJjzwqeN1Kh1uRmMTWXqzLeTpyeo1PMTPSTFDTvs6dFfR2Rk+XhO82JIBS93ARAmJGLNHBKsseIo1O9YVqLlq2MYBjVNpcKhF6a6MXriFE6XTtGD/nUBx5YOuFEJGAhi/mupZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A7nk8zRt; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A7nk8zRt"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-303548a9361so137070441fa.0
        for <linux-cifs@vger.kernel.org>; Mon, 06 Jan 2025 09:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736183025; x=1736787825; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vDewTj+7tUroBMoex5nb7sNODcMKrxnRD7GW3YVIuh0=;
        b=A7nk8zRtdQeF+l1O6si9CmN16/zqmWIfUUfuOig3g9c1lnOvEQYxG2cg98W1cPHPaW
         Mh+NbX2trReLxpzOJiGpyxxbx1HfvO2PSCeeGdHAKyc1vq7t8ogthhlfde3tzOFWHk8P
         jcxgds9urF9uBIaACLNXb/EEUDCZkqX9ftVtJBFEUFe4CVj2kVL6nzaucK6ZW7oHsmWQ
         BynNFVOLoqqOd35S5ozJP1Ga3egIinCkxdqC9YE88EdafKZZDFF3ZRbt6KZ5UnTs3oXU
         Pwnx9EMR4x8Gc9OflUBvHmOgIIGYn6HIua89cEJDsnwOKlQ72AgtgCjE9ZRVi4PW3Wdn
         rakw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736183025; x=1736787825;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vDewTj+7tUroBMoex5nb7sNODcMKrxnRD7GW3YVIuh0=;
        b=XRGUuETgksZHPDwf76Qjo6poffgGg0KiZ+qjUu/y56GXrDGZJwTv4OAqCVko6JK62t
         qXtSETU8U7QxHIEqwD62d+k682vdfhU489aPAHKaQZz2WbVyFe8R9tHhtWFlH5oU9U1M
         meBnxfyA/uJGjtX+NCd1Nv6P223lyrxQrhNnSuVUt9ggr/cA/LCBdpYHdKUeKuINCsmR
         z1aArqymagiX+Wgl8PhGs613xFE6AybcoGRc8/pq5+6DxqRb5j3WiHVtqPDInYXIfGMQ
         caBdrICuCIqXfgLziZaIR6peI3BEk57FPNKrb9pdNOVX8kbG9FPvuYGE+YPrYuvG+71f
         J5KQ==
X-Forwarded-Encrypted: i=1; AJvYcCXprddZLNt/O2K7cMcxIEYd09HoaNpao3ZKpzfGhCSmH6ypytlEnj8JpM4eUsOevrqzeBGx2tmHAvKB@vger.kernel.org
X-Gm-Message-State: AOJu0Yxhm80XvFLucle1oYekl8z76464mO+kDxoQ89cT0fsAW5yseOpF
	rpMyg8Ezy/39Dt9E38akB2TmT1MVxWykr5bkeJvvtm+e5LYerxSxfUXuYoeRxDXrHAcP6BhAdLE
	ANT9R0k/cuTHWBhdupH+pFApv3W8=
X-Gm-Gg: ASbGnctPvGrJfKqT7b/nBD2zALgg1wgbB6rnqedNLfqL46DEZuKXRKUtuWfai/yZawA
	hSWS8k8VCx3lLVBhmBFRdIbSUFPvY/w5gx7VQw0K1CVn+Km8zhZpNVzE2hj6QHCLfAkHTKkVW
X-Google-Smtp-Source: AGHT+IHWwDPZme6hk8Wj9ukxP3B8UmlenwQzmdI5fIXFykX8VP3n3kaWiQt6dUCPVmPlY6BHdfeJVoKcPjKJHpxIId4=
X-Received: by 2002:a05:6512:1313:b0:540:2ef4:9cf0 with SMTP id
 2adb3069b0e04-54229532f62mr16976471e87.18.1736183025029; Mon, 06 Jan 2025
 09:03:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a376beb3-c362-4b73-b2e6-9104d4df6978@stanley.mountain>
In-Reply-To: <a376beb3-c362-4b73-b2e6-9104d4df6978@stanley.mountain>
From: Steve French <smfrench@gmail.com>
Date: Mon, 6 Jan 2025 11:03:33 -0600
Message-ID: <CAH2r5ms7EkWfEmane-V+4fd-_7Y+qpLc_+-y=nDucjo1aG3RnA@mail.gmail.com>
Subject: Re: [cifs:for-next-next 13/13] fs/smb/client/fs_context.c:1466
 smb3_fs_context_parse_param() warn: statement has no effect 22
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev, Steve French <stfrench@microsoft.com>, lkp@intel.com, 
	oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

buggy patch removed

On Mon, Jan 6, 2025 at 3:24=E2=80=AFAM Dan Carpenter <dan.carpenter@linaro.=
org> wrote:
>
> tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next-next
> head:   8f97b4a68ea216bad142a5391e30fa63c8efce30
> commit: 8f97b4a68ea216bad142a5391e30fa63c8efce30 [13/13] smb3 client: min=
or cleanup of username parsing on mount
> config: x86_64-randconfig-161-20241220 (https://download.01.org/0day-ci/a=
rchive/20241222/202412220354.ZyCvciEy-lkp@intel.com/config)
> compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51=
eccf88f5321e7c60591c5546b254b6afab99)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202412220354.ZyCvciEy-lkp@intel.com/
>
> smatch warnings:
> fs/smb/client/fs_context.c:1466 smb3_fs_context_parse_param() warn: state=
ment has no effect 22
>
> vim +1466 fs/smb/client/fs_context.c
>
> 8f97b4a68ea216b fs/smb/client/fs_context.c Steve French     2024-10-23  1=
452            /* if first character is null, then anonymous auth */
> 8f97b4a68ea216b fs/smb/client/fs_context.c Steve French     2024-10-23  1=
453            if (*(param->string) =3D=3D 0) {
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
454                    /* null user, ie. anonymous authentication */
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
455                    ctx->nullauth =3D 1;
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
456                    break;
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
457            }
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
458
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
459            if (strnlen(param->string, CIFS_MAX_USERNAME_LEN) >
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
460                CIFS_MAX_USERNAME_LEN) {
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
461                    pr_warn("username too long\n");
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
462                    goto cifs_parse_mount_err;
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
463            }
> 8f97b4a68ea216b fs/smb/client/fs_context.c Steve French     2024-10-23  1=
464            ctx->username =3D param->string, GFP_KERNEL;
> 8f97b4a68ea216b fs/smb/client/fs_context.c Steve French     2024-10-23  1=
465            /* streal string from caller, but set to NULL so caller does=
n't free */
>
> Typo: "streal" should be "steal".
>
> 8f97b4a68ea216b fs/smb/client/fs_context.c Steve French     2024-10-23 @1=
466            param->string =3D=3D NULL;
>
>
> It should be =3D instead of =3D=3D.  It's surprising this compiles...
>
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
467            break;
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
468    case Opt_pass:
> a4e430c8c8ba96b fs/cifs/fs_context.c       Enzo Matsumiya   2022-09-20  1=
469            kfree_sensitive(ctx->password);
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
470            ctx->password =3D NULL;
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
471            if (strlen(param->string) =3D=3D 0)
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
472                    break;
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
473
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
474            ctx->password =3D kstrdup(param->string, GFP_KERNEL);
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
475            if (ctx->password =3D=3D NULL) {
> 24fedddc954ed16 fs/cifs/fs_context.c       Aurelien Aptel   2021-03-01  1=
476                    cifs_errorf(fc, "OOM when copying password string\n"=
);
> 24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1=
477                    goto cifs_parse_mount_err;
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>
>


--=20
Thanks,

Steve
