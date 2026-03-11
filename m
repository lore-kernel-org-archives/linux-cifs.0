Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B236F145A1F
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 05:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773206778; cv=pass; b=PkBqXyy5YwREFP18T56tWyLETrjyDvrdtD5k9imOPa/8efUp1Q6H8ITBo1ae/NPJwo1FNAMkGpatNGmZVYJwfrasBejWd4JnJpVMgMop5W15EagiFFU8sZ9YxYA3vDkXI6vgKBPGrUu+XX0A+sMESy/ies8JVsvkgrhMVkfE7Og=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773206778; c=relaxed/simple;
	bh=0v+xe3AN+mBw98yKPGRX6appTWeHt7TBIgEUAHtMt4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K6xZpo+oDA2CIXXaKAyq6CwKxPCvmK/PxLSr97IFj/euWGjKg02Ixtlref5ew9PgbQ0RUr8j59r+d9bXeBIFqGw195oJiq5de3IKyQpTRKOuvJCq1Nd5AHQYueiOyWIH4WthoqlrUn0QSHmeh1mIHMAWpN0oajcZd5HXmHBsr2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q6eeUNmu; arc=pass smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q6eeUNmu"
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-64c97997b0fso9716061d50.3
        for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2026 22:26:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773206775; cv=none;
        d=google.com; s=arc-20240605;
        b=lY8LT0xBWjLcUNvU83AVWBIK0hMJxIJQAi9rUApc3Ali/TQhWHGntP/2xdQwlD2wxA
         HkOt719afa2bGT/Dvn8WcLGAQ4lRFEtjoTDxJVaiNTOEkEk4kmWhNoS0iQqj9CYZnVAu
         JYeoIshoBpiQyquUgusIHgB584usbuI33lsjkza35V+Gp+TO3tWvPHfG1+TN/QpT+hyz
         VcXeb5w/W4qhtmqUzs53WprTXCVSGxnNsdOagptBpaPKScpeVqmVkrpwvgjRbyRy8rX+
         4/dXmSlM5mu/XCBiDvgAm5+EVrpwDK3Hpf1FYYgOzluZ5fuWQJjJdLyQPutoBlZ94wMS
         mSmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v0aJbLZvpjGRAiKGJsIGIvgjpHquE1jdyy7HIfD7AM4=;
        fh=+q8yoAH4CqT01T1jm/1+g8pFQ38udbvNaytqW3BbcL4=;
        b=FdK4VDbSP4GVZfUJc5xoGSUh5p1oNXo/6da85g+HiuWuQqKsSDvcpOnE0RwspEOOPB
         Rvuu5rOhrWmooBU5vJt46Wj2mqkcIS4Voczg4oB3LkfW8JdFa+elsxUhchC3ywkOljpJ
         l0pwx+YFbUpamhpWFNuI+t3w0fdia7Vd+5IgqV/qdAruQzjiuMGfdVYSwy8skLXfG4pD
         ICMRYLP3qS2z4KETHapvL2oe4AQqUXtph/bNncmGt269TQ6YRZ9ETb6wRyKM4nJMMvH4
         IX1mGEITQxOSY1nYM5OusYKbniJBlmHkicsPmPf7dhXjN3v6b1GmaC6Ol217JTvXde2P
         zjMA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773206775; x=1773811575; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v0aJbLZvpjGRAiKGJsIGIvgjpHquE1jdyy7HIfD7AM4=;
        b=Q6eeUNmuiICu3AelSyLngi+s8hJD1oXfehEGTDWGGb9/Dg9YzIssRvzUcdmqpkNHy9
         Q7xXzOt7ZbRj0QlWNVR3BY1IepxYGLMCfPhXzjhZOHD0ohhKxKIJ+CI3MMqndUpdQgdl
         aUVzq3Jg5LwegjIHzSAXF8u+iGwLFQ/HFYokn1M/NxpF319acRy5iwASYd+mH2lZ+FSe
         OUtrsfI16Y1K3BZuKZM+h9gxq/wxc14bq2HaRdO2dv7BvjVCBCeMnnmOR2crfIfygvyb
         NU+5bLn7ubG/nqFWblUDeShZeNVUQKTlawMqo6rR4JzEIa+UbfZDIWHQf0LlGOIi+3gj
         FEBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773206775; x=1773811575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v0aJbLZvpjGRAiKGJsIGIvgjpHquE1jdyy7HIfD7AM4=;
        b=CtbfYgRdNASIfQKuwG25VzwTBtyWIdURJ0VWzmz6Q9wOp5zLr5d9rP2OIfsHnb40Oh
         u1MoM2Mbq9GMmsmgilBvGTo161bEL5wkuaOM7eCi+7Uh747eKKFQbi6Z55h7YAVYGnCP
         RNr+Cf4FSiMCAXIxDJOYKtZjMskbO0sBzVYKJOUN/yyfiwandNGXtxIpF+cP1B/Nx2sy
         X6qBCOgm0jjRCEShrUD6RtsNKDtfmjgJeYUZicMntdQE5nmffEtYEkGDfJslgDR3LOIs
         dszaw5JCcOvBS/APMr//ORiR6J/NJOQXOwmmVGFa8Ylr+chKT7stuucBU71NfvATtDpD
         Sk1Q==
X-Gm-Message-State: AOJu0YzHheeu0AGtN/UY1Btyj2Bn2upFtt2ANZ4KumNofbazAfXQC0Rf
	5rEvBHDnLu5+1wVFhCO5b7gIkiDh041ibTNhqGw7rLLZml2db3I9ctjCjov3e24+j7fyScaR8Dd
	FAbDUxFlbOmHijgnpzlaeU/YDBYgcLeA=
X-Gm-Gg: ATEYQzwf43ZC77OjlQh7CepMGKF1PkUBHEUsdW40he7WTMztwz5T6oANK0iu4msowsG
	5pYY6E259mVdQgcRB8JKE1hv9W4IAO4GyxroEI6xDCMdbQHuw2BcvbLnBrEJ/1jg6uVNnvLjrCy
	snG+MwweR3ThAJcHo6JFYaNQCURWghdNQ3T9ivsWSeHy8ATyyI0HKj5Z6Vu+cbz0qABhhxU55la
	YsdrC091YsFYSLt/Gc21mkEGt9HLhxFdaFWkBTp/+nOMWFTDFatlrN7MM83bff31aszjfCc+tSH
	jn3yotOrJ6rtsLIuHlWYV65z+l4mP1WYnAmJfSvhd3IhyFH/bA==
X-Received: by 2002:a05:690e:e84:b0:64c:99d7:8d19 with SMTP id
 956f58d0204a3-64d656a83ccmr1048185d50.5.1773206774730; Tue, 10 Mar 2026
 22:26:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260311051854.2584907-1-sprasad@microsoft.com>
In-Reply-To: <20260311051854.2584907-1-sprasad@microsoft.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Tue, 10 Mar 2026 22:26:03 -0700
X-Gm-Features: AaiRm50uaszDAA2-fVYx2yd83rE8HftvCEuttM7UuAGkgSoSOuXPE5Sn9J2W-tA
Message-ID: <CAGypqWzCfeckKxZs0KJuqoQMmHyfb_iJ+ObysO5-VFxGGVJwgw@mail.gmail.com>
Subject: Re: [PATCH] cifs: make default value of retrans as zero
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	bharathsm@microsoft.com, dhowells@redhat.com, 
	Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 10:19=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> When retrans mount option was introduced, the default value was set
> as 1. However, in the light of some bugs that this has exposed recently
> we should change it to 0 and retain the old behaviour before this option
> was introduced.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/fs_context.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 54090739535fb..a4a7c7eee038c 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1997,7 +1997,7 @@ int smb3_init_fs_context(struct fs_context *fc)
>         ctx->backupuid_specified =3D false; /* no backup intent for a use=
r */
>         ctx->backupgid_specified =3D false; /* no backup intent for a gro=
up */
>
> -       ctx->retrans =3D 1;
> +       ctx->retrans =3D 0;
>         ctx->reparse_type =3D CIFS_REPARSE_TYPE_DEFAULT;
>         ctx->symlink_type =3D CIFS_SYMLINK_TYPE_DEFAULT;
>         ctx->nonativesocket =3D 0;
> --
> 2.43.0

Thanks, Looks good to me.
