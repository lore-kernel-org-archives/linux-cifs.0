Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AC23F39F7
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 13:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783518933; cv=pass; b=KrJsj2eSOs7GL7zD4gapTInfHeppat459RTGxdEJl7qMunskK02erIq55mq2a5vWgIUrMe+XertKNQgwFV+8/E5FK6gNwASZPeSf+I4E75jLxoT+wAyyblmGCX4VT8VkFi1ZjQ+oLDBz1L1UoE6XnvWwNg5WmdPqZQMcqLsMVp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783518933; c=relaxed/simple;
	bh=1865X+tlDynOYoVId24k9n7McdyrBCKTVVN+UkLSW68=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KXueYvP2uGwe07Br9csMfTRlwNCOdFbHEzHKjZAWKXnH44i83Qid77KSqvTw2jJW4VntP11rcO2Uzw+Oni/VK6BPAOqE/vqKlQmrKLVNwzaEJvF725owZtjpt091t5Ik5qTsnbEgeYSLx9zHAM6k1V9t4xP6nRTU08MF3O9Zftc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jd8ymuVd; arc=pass smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jd8ymuVd"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8efef6533aaso5592596d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 06:55:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783518916; cv=none;
        d=google.com; s=arc-20260327;
        b=eVcBW80uaFMbUXmwJ3kfXH+ViTqHw+HB7xnEH8zgkf+2JS4EkSh5i8Qw3dwq/bkycd
         zyKDuhe95tihVU1ocaJNzcPY8CTtWsz0HRR5VtfBNkrG18NQe6r/PhXTgEw4k68zlwID
         quPijXzPbYmMoDlJdPUzuQUPrS+2m2TYWiD92s40ywlI+Rqo437P6svPbHF3vxfVqjMW
         blbDgKbiF3IMGSlTzC4d8HD8LoGK4g7u/QuRWrW2RK4cRfSSEmsuSzUnETAU1kaXlOeK
         Rr8udWfGeqJWnU8Zs9DuQB2Z6oKERem77c7DX4Lhpu3d6hWQJPB4kzR0Nw1zS75/7m+T
         kzRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3woS1LbCNvniVCSfbr5TVCsTBJnqTPAeSxQdUM6rrOQ=;
        fh=++sM6jCfLv2D+eVP6bd+tpw3m9PTHAlCA7PCLBv6fCc=;
        b=eNQ+sqMBYhJyUyEyJ7/BjiOm5mGdAJO0G93Yp3EUu33nEUwRiXvkkg/DF6WpulYHnI
         TJNwGFo5BcGAPGg3a6YpVR31eYUhv+EeSO8Y2PP5aIB2uvqPkNkovlpwhwUzTy0eE2IN
         tJ5B4FpE/LsVlQe14PBScqZN9Xq3PQN7ykOkQdzXSrMkm/ZZ+EkQxF8hVON7WuRSWZhk
         OO97Zw/2te5Vo3hBKNa7JUOzaz+moPy8D4TPQutl4fJfkkTePLUal231C/iIVDzmj2wq
         HEE+2J8rPgbLNQXoPPvUAqPY+M9nBiPzr3JqE2IRFSw0MhaYjm3D7bME1MDdMnd5pdqX
         86Uw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783518916; x=1784123716; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3woS1LbCNvniVCSfbr5TVCsTBJnqTPAeSxQdUM6rrOQ=;
        b=jd8ymuVdUlJ77Oe9UrToDnjtsKCw2qG9hC1eqZjOa1/pqcpLQssGkYVoeWjCbBLJli
         QQ802si2oNCTNP77LI0gSiBKgA/AY31VwbNa7tQyH+C/2HsJtKmRSU5Mould1AFQpk7p
         S3xrS6a4boqIaL4+2ub+9LbQavOzqOiP6DDxGQk3RUs7ixg4JbHVHvf9e7R58rYaAxGo
         KUFWwhbx6dapF3o21W1RYK094FfZvx6uTuE+HgKaomWu8rVZTL9cAfPlHlJwDWlad7ID
         eMwGcVGnLcdWfz7AUty7tluPwZX86Tf652H2MNBCmDgBym9A55jM/tIO0MM49rJ6F3Jz
         IB9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783518916; x=1784123716;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3woS1LbCNvniVCSfbr5TVCsTBJnqTPAeSxQdUM6rrOQ=;
        b=MtlgMFQUMJL97W08cJEJflZk7QV5OoVLLkpvEjYIxArtHymCgfogXAx1Kv5Hd7zm/m
         eFLLUQgGRA6y05hKVxYPqGUOfH/b5UKyWqtg0sXX8KkbhXbasI2ga8cE1prlzCsNtA8Y
         1b/bNmvruywVCqs8RbFI1Z/Yy+ZaT7IAmikkd3G+m9bD36/XZmP+TBVKEeFmt6BuN1nW
         BAN7NRI5+LQ4fq+w9NgG6WGf95lfZv5tJOu6MWmMCDi7cqpZHh0R/mtysWmiJry7V8Ie
         WXDGbw9vqoLKAPgPDje6APWLUlX4brr2GVb3ZeIfm/v95mwAGgtkeuJWusT74a3RhGL1
         ks/Q==
X-Forwarded-Encrypted: i=1; AHgh+RrNFpIkr+a70n8kHmnyuW4e5go+JlWhAg6UKvX8R24k8GZ8sAsHOw2f++wycyC/46g5lpa1HHafLoP1@vger.kernel.org
X-Gm-Message-State: AOJu0YzYunhwslKaiUaShYpZEVFUd+wBKV5BEuwAAWqSVQiMFYJwDDXT
	RFhJO1IqtGiKuveZlcYkY4OjLBkPYA2/WdvGxn2yrh4SIMfm/HUAOCS4KAtFS2PUsQbkVddVhKx
	Crn+Rs3u7jLC/ARliHn4ETHwx0Tjg7qI=
X-Gm-Gg: AfdE7cmslAaHMJM6jgJZ6RCo83hyTrLIF4sKu9c3/D5gutbPU5Kt8kUfM7dT/homuU6
	KI6UNevEnh6yzJSvWMC4Sy5tgxRHfI8feaEqy4EqSfwiv4YfPbUXy0kmH1sHfEWtHhM98i2R9wG
	6Y25Em7b+foPu0gDNsmv6ThWFycrToYBnHe9vLWqwYyHHyorH/U2gESwARoV/+u9ZUhpwyoX7S1
	Y3uvzT/atIJz4sdY5J91QOU0kr01L9wJzWjo2XwPchOxPZE1UeIi3lxyTNUBzgh4+v+TZk/kFxg
	NsyJreUa60koxn3xmuiT14JvC8y+stRBj80lNMx+lAGVJMOLh6PwloqIjTiRgRR2c09TWuhr+7a
	5DC8qVq25gRPyiWfmWzxHgOVCq+qLK0I22rZUTK09q8uzo2/eQP4f
X-Received: by 2002:a05:6214:4890:b0:8f1:d316:42cd with SMTP id
 6a1803df08f44-8fec0eb76d7mr25844906d6.25.1783518915617; Wed, 08 Jul 2026
 06:55:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707090356.26163-1-pali@kernel.org>
In-Reply-To: <20260707090356.26163-1-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 8 Jul 2026 08:55:02 -0500
X-Gm-Features: AVVi8CfXrxHwqSxNZV8N_3aRFkhEyXsn8jpl1hBiT5MoHpNxefLCbAUWjeG6ugQ
Message-ID: <CAH2r5mtT0-o-jTdtOEsGe8wiO37kEmxjYrrts5L0m0pen+sb-A@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix support for creating SFU fifo
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

AI search says that "LnxFIFO" is used by WSL?  Have you verified this recen=
tly.

On Tue, Jul 7, 2026 at 4:13=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> SFU fifos are natively supported (created and recognized) at least by:
> - Microsoft POSIX subsystem
> - OpenNT/Interix subsystem
> - Microsoft SFU (Windows Services for UNIX)
> - Microsoft SUA (Subsystem for UNIX-based Applications)
> - Windows NFS server (up to the Windows Server 2008 R2)
>
> Windows NFS server since Windows Server 2012 uses new reparse point forma=
t
> for storing new fifos, but still can recognize this old format (also in t=
he
> latest Windows Server 2022 version).
>
> SFU-style fifo is empty regular file which has system attribute set.
>
> These SFU-style fifos are already recognized by Linux SMB client.
>
> But Linux SMB client is currently creating new SFU fifos in different
> format which is not compatible with all those SFU-style consumers. Fix th=
is
> by creating new fifos in correct SFU format which would be recognized by
> all those applications and also by existing Linux SMB clients.
>
> This change affects only creating new fifos when mount option -o sfu is u=
sed.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/smb2ops.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index e59fda1b2230..1261b928edee 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -5293,10 +5293,8 @@ int __cifs_sfu_make_node(unsigned int xid, struct =
inode *inode,
>                 type[0] =3D '\0';
>                 break;
>         case S_IFIFO:
> -               type_len =3D 8;
> -               strscpy(type, "LnxFIFO");
> -               data =3D (u8 *)&pdev;
> -               data_len =3D sizeof(pdev);
> +               /* SFU fifo is system file which is empty */
> +               type_len =3D 0;
>                 break;
>         default:
>                 rc =3D -EPERM;
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
