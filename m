Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF32418FDBD
	for <linux-cifs@vger.kernel.org>; Wed, 15 Oct 2025 12:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760532458; cv=none; b=Z3jeSYV/fW/pFEPlw+lD9oz6bXkDmfoBOXBPTX2AY0gG2Rwnc5K+vz8yJUjX2e3hBkgP+sWBe7TqAipPXOvE/enVf9cc3d4af99j2M3rfBxfEcN9/ih2M07IYLcSc7cOYr3bzm0uRoUW2e5e+FUhUyi7RRi2RYW3sRz2waSu1fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760532458; c=relaxed/simple;
	bh=F8yO11Cr+XYGm2OzDRtKP03KskCc8vHL4cSy4EPwYiM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uN1KqkVz2VrftV1c4Sfg3FzJiITbZIJMdwbfJNrf0MMU/zARcaLmuCKxrFNRLHi7IFPKh+o2K9TfxFuzT2V2pWsZNahx0X2g9bg5WL/7I+qys+vOMHS5ycjzPm2q9zUxbB4PpNKewCs9dMBp0KwRjCBAyiygEMsFMAx6zHMlfWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k8cUuS0G; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k8cUuS0G"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-791875a9071so86429016d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 15 Oct 2025 05:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760532456; x=1761137256; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K5nSTrhH2BKHdQ2lCNCKTv5b55Vmr09NnhD8LaRBaNE=;
        b=k8cUuS0GBNp1kNPZNDu7o6K9w9OuDgX3yLQ064KL2e5mZhHN9jTd2QZ0VsykqEbhO5
         YvDSt6lPLm27uPaAQzq3MXMfVp1+du8rcYMfB7WFqyYED9nix+RrIILyArPGBbelL7VD
         SeNExVTwJKWi0VL6jvbvki1el/0FoFVKjnbNDv3NpOklUg4hB7fwykOYUFw6HctniFqd
         KBRpOS6UanT0VUNq5ASG8rKIm2g5d6/ddhOXghE3D5j/VzpLtA9kY75hbiyiOG7GyLoN
         fVYjmqkOS/WcK7RAfTRZ9M/GAjnONzhBCmAiN+KgX4AmTQ2uOkGJOisESXGyl5x4qF5Y
         MWHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760532456; x=1761137256;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K5nSTrhH2BKHdQ2lCNCKTv5b55Vmr09NnhD8LaRBaNE=;
        b=gmqd6n9LBqrCvsDsRi1yB3+2lcGk/TX+GLS4eSvdj6R2XHlazVwuwzR/kuKXg20I8b
         1FLrbdes+REwwM0ughnynNPo8rOytIa6c+bQ4vTD/nWZrt8ZFD8iT5OaX4u7WznvdkcL
         CSJRs40VTFisU1cWBLOQDweOsW+VBHLWYGDi53GvZzqvmfGGt3/yk3UNSBSBIHi9bygq
         rMOwZmJytGVzkuEud/DKlbrXjsZUPKZ+0YEt+sS8Jhe9T7tkApu33Jq869yYhxZ2DzYU
         JVB7nw6/dMInjrZVoew5+CcrydsT2OhYfGaW47G5YNqtxxU0z4J4YUJRRFFr0PrhnT/4
         7tJw==
X-Forwarded-Encrypted: i=1; AJvYcCWwlCDVXbMSyw6yRaQYm0KTMu0fiEIlMG4SXtZPJKQmD/8XmZLdMyzP37GshjQDalaJWJB0QnMFQS6l@vger.kernel.org
X-Gm-Message-State: AOJu0YzmR2xjXidk7DdJVgQSpmDEW+cDIDoO1xYoTxWfdE2xSBj8SYw6
	FFdtCJLIANX9BYDhUEFnE2uQ0XU5MAwH6u8H8NknkVoiHJaVm1SdA8if8SOMKjGMISWZtbNTLY/
	y2jqLj+gk5H9Vdf0ZfoVgEQdh5SXEre4=
X-Gm-Gg: ASbGncsQqzHexKTise/ZCgOw4VVMZbR4dLXD+DPGa/nlQsttTXWkHSTWzJpFnsh5oSw
	aHkimddwHX0pFwg9yWJKGUqOHOJGVUW8+NHlVsaHk4dZBIHy2aAQ/UitOGBs/sSabhKTep3jFA+
	Ebnc8pfEHct5IubYyAb5Cvr629I5HcoNA5gv9Z2Yt09pex8v3UZJWJ/XmRRk6vS+D3nbNmfeJQh
	3+YacwWN9ln37+uOumCAYdGmFDL4LYI3dfUms173Q90CVoB3r6bfLsbzaS317wf7Pl/Lie8Dmm0
	M7TaR6dnNAGZfFmfRkd+AyuzYu+tJ32GA2BAeyW/7zfP2M4NinyGWnCRHzKMsHJ+BssSPoo/Brr
	lYupCHkurMd9VaYOLRls6iIcFwa4y62ROVs0kuarX
X-Google-Smtp-Source: AGHT+IF62bqoQuCp73EEVfVxaaSqmFM+khKNICG0CY8KpU8GilmURda0BLy48rcxDI/e7CzdXtL18x9Coeinsage2Mk=
X-Received: by 2002:a05:6214:5007:b0:7e9:bba6:511c with SMTP id
 6a1803df08f44-87b20ff9c75mr352467346d6.5.1760532455726; Wed, 15 Oct 2025
 05:47:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1760295528.git.metze@samba.org> <6d275bab3ee66cf653c9e1e242a0a87efa352063.1760295528.git.metze@samba.org>
 <7af986c8-7050-4b51-962e-dc3984ee1f58@samba.org>
In-Reply-To: <7af986c8-7050-4b51-962e-dc3984ee1f58@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 15 Oct 2025 07:47:22 -0500
X-Gm-Features: AS18NWCp2w-q0vpSgOTKtiWRl-iepuEymc9PaYb5Xdb57OMr96NlZvWm4yo_dxM
Message-ID: <CAH2r5mtW+FJ2mK_DwEDWY1J222o3BrRivE+j7h0+npVOgDvmXg@mail.gmail.com>
Subject: Re: [PATCH 10/10] smb: client: let destroy_mr_list() keep
 smbdirect_mr_io memory if registered
To: Stefan Metzmacher <metze@samba.org>
Cc: Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

cifs-2.6.git for-next updated with newer version of  "smb: client: let
destroy_mr_list() keep smbdirect_mr_io memory if registered"

Let me know if additional changes needed or if you spot any issues

On Wed, Oct 15, 2025 at 2:20=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi Steve,
>
> as already discussed, one additional hunk is needed...
>
> > @@ -2402,6 +2448,9 @@ static int allocate_mr_list(struct smbdirect_sock=
et *sc)
> >                       goto kzalloc_mr_failed;
> >               }
> >
> > +             kref_init(&mr->kref);
> > +             mutex_init(&mr->mutex);
> > +
> >               mr->mr =3D ib_alloc_mr(sc->ib.pd,
> >                                    sc->mr_io.type,
> >                                    sp->max_frmr_depth);
>
> Here we're missing the following hunk:
>
> @@ -2483,6 +2483,7 @@ static int allocate_mr_list(struct smbdirect_socket=
 *sc)
>   kcalloc_sgl_failed:
>          ib_dereg_mr(mr->mr);
>   ib_alloc_mr_failed:
> +       mutex_destroy(&mr->mutex);
>          kfree(mr);
>   kzalloc_mr_failed:
>          destroy_mr_list(sc);
>
> I fixed it in my for-6.18/fs-smb-20251015-v2 branch,
> up to commit e4418cd1d5d80a8c24530ac0a41a5451c44f82bf.
> git fetch https://git.samba.org/metze/linux/wip.git for-6.18/fs-smb-20251=
015-v2
>
> The above hunk is the only difference to the current sfrench-cifs-2.6/for=
-next
> (at commit 7949ce089965bd025a8d46dbaa2f5d0a2bd4ec77), I only moved my com=
mits
> to the top. So you can just replace 7949ce089965bd025a8d46dbaa2f5d0a2bd4e=
c77 by
> e4418cd1d5d80a8c24530ac0a41a5451c44f82bf.
>
> Thanks!
> metze
>


--=20
Thanks,

Steve
