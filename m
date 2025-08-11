Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD3C8F6F
	for <linux-cifs@vger.kernel.org>; Mon, 11 Aug 2025 03:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754884218; cv=none; b=upb4PRhXIK+jykBxWhzDQ1ZW/oK66ryZnAnBRWQafEWhOD3hMhh5pUoa1Vc1pxk5IK1TCbZiyIzmZyrD6eYDwlKUCEzdyHX4G4fsrAPb6IkKk6vKFfbIxwDXq6kiC1iv2QdPPz2jSn0BBVamE4hU7z2Ui0qFXosDCD0HPDM7h70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754884218; c=relaxed/simple;
	bh=eCsWdT6RrQE3d0f/DlQhFXS57vWwxv6DGnRkk4Bye1g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qVhKyV5lVnBz6PStCghfxTg9uGeIHm54Oevpgz8xIxFCIi21ZWyl0d7e3gE8kCBuSWlPnN6nM/brjw8s6Y8kaHwTE6rngw+cc/IsRogtF8jbQmZUY6ench1hL+O2FHy2KeCaa8Herp11q0IcyYeAswu8d65nA2pg1VQwAu6NMbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JvE3WzUO; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JvE3WzUO"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-7094f298dc3so34581706d6.2
        for <linux-cifs@vger.kernel.org>; Sun, 10 Aug 2025 20:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754884215; x=1755489015; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2aF8ie0G7IlCAybCosIY3EFsHxXHoO6LOX4nYuylZfk=;
        b=JvE3WzUOoq2ARHlevDmfDj0FyfQh95eM6NySoUfrTA9XTsU9oEopVzyb6c+hXhQiJK
         bGbInQlKcEKT8fLDzjrruMgY1/hYdbwG+nWaC7jtBTFHtvm/Fh3IHI/PMOE/JsnkYiI+
         aL0MbYbsc86nRtejLu/H/cp9Z8GjprWrkZzvlDpKv6v+255bqfocreFpwI3FhNal6Ujd
         81jgjyD7MB2BBR6mwNVMp4YWv9aQxql3NSxyc2zMbjfKDd6CuCGq9B/Mt1Knl/acDDkQ
         V6PqkTI18PRS9uigwenc5SWKIMgx9a6D6KL5aSjD9+ub0TnzmbI+Dgc1bnIweZaprEIl
         8+Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754884215; x=1755489015;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2aF8ie0G7IlCAybCosIY3EFsHxXHoO6LOX4nYuylZfk=;
        b=cvyV/pxRLSjGa51+lD9zEadR9q5S1Vgiu2EgOGr1QUudVNDvNlct12VJGK+o61owtU
         APiu3YfYC1QXvlLxWFxA5smdkzIfUB+vsf3d3RvqZk9M4K6IXEwHVlmf7MjWfGnemm8h
         Q27N3TlF7/UhI6LQgYF0UCUOKpYcIM+k3onYOJ0xy4zViA+7oHKr9d2Y29nZkMLVkazY
         jZXliOxeRwU/M4kfNEbHYvWafhgoSBCd/DrSsSw3FB1zEdlduEkWv/r8LyaI9CyoXTKk
         A9+rM9bbxwz2AIfOHp7LmtpPreXDYRQoaQvcrmROr0y7sfsaxwd3VXUCj/Q3e4uRnua4
         1fbg==
X-Forwarded-Encrypted: i=1; AJvYcCWpuQu8YJb3Xw1ul+ggJN02JHeAea10FM5tH9Yde7nWF9/Zzr01enG13heyTkR6+cEkPXBr/jx2mape@vger.kernel.org
X-Gm-Message-State: AOJu0Yxqw8M5HXCuOa70b/tu4oMxJm4E9reAvcD8JTWCXF1LFBpQ0LHo
	7NKC638N0lZJyLM9e09MNeMVrPmNHmfwqubAbjYWYJgm5mJZ2N0Aar9EiKAy4hV82dgSxPfhPjT
	QgELInyWAtUn6JTvDce6GEjl/QHmCPsQ=
X-Gm-Gg: ASbGnculdua6c+F0ucS76BN/Eg0EwEFMJVsgOn0BiPEeICiqQUP975u5csB6hZFNMt4
	+eIjU/NjnY0/MR9pmY+GQNGdo98MljWDhtPmFHl+g7XUXVl1t+LOJyG5JdjMWqrADKHnfiA0FM8
	cvjSiH/ZJqwpnxGrud24MKLf1KrFedTDeNHhJvL4kyqcGVC066T5BNvHAOY1peVf8/BZb/XraN9
	pKkecGdrQ0okTvazE7II35i3usbr7JzPsczLvZXWJSpXvXMuGmX
X-Google-Smtp-Source: AGHT+IG8qfp8KmDtigzZQnkcyCzhfTA562s/K4M9aXkeGW6TeRxYa9Th+wl9fWVsWeArTatRzBz87WJT4yFV2sJSUyk=
X-Received: by 2002:a05:6214:e4b:b0:707:5a23:7382 with SMTP id
 6a1803df08f44-7099a4481a1mr186583316d6.23.1754884215100; Sun, 10 Aug 2025
 20:50:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250808145221.479993-1-dmantipov@yandex.ru>
In-Reply-To: <20250808145221.479993-1-dmantipov@yandex.ru>
From: Steve French <smfrench@gmail.com>
Date: Sun, 10 Aug 2025 22:50:03 -0500
X-Gm-Features: Ac12FXygIZLqHkdtHpXhiUjwnS7mI1r-23JZMFAlueVVe5eLtxwb3uyyKbMLIkk
Message-ID: <CAH2r5mub9jHuMkMDE7fej4ucJ_bnmN0F+Ecdhwj_zFyW-C3kxA@mail.gmail.com>
Subject: Re: [PATCH] cifs: avoid extra calls to strlen() in cifs_get_spnego_key()
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending more review and testi=
ng

On Fri, Aug 8, 2025 at 9:54=E2=80=AFAM Dmitry Antipov <dmantipov@yandex.ru>=
 wrote:
>
> Since 'snprintf()' returns the number of characters emitted, an
> output position may be advanced with this return value rather
> than using an explicit calls to 'strlen()'. Compile tested only.
>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  fs/smb/client/cifs_spnego.c | 47 ++++++++++++++-----------------------
>  kernel/bpf/verifier.c       |  3 +++
>  2 files changed, 21 insertions(+), 29 deletions(-)
>
> diff --git a/fs/smb/client/cifs_spnego.c b/fs/smb/client/cifs_spnego.c
> index bc1c1e9b288a..43b86fa4d695 100644
> --- a/fs/smb/client/cifs_spnego.c
> +++ b/fs/smb/client/cifs_spnego.c
> @@ -124,55 +124,44 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo,
>         dp =3D description;
>         /* start with version and hostname portion of UNC string */
>         spnego_key =3D ERR_PTR(-EINVAL);
> -       sprintf(dp, "ver=3D0x%x;host=3D%s;", CIFS_SPNEGO_UPCALL_VERSION,
> -               hostname);
> -       dp =3D description + strlen(description);
> +       dp +=3D sprintf(dp, "ver=3D0x%x;host=3D%s;", CIFS_SPNEGO_UPCALL_V=
ERSION,
> +                     hostname);
>
>         /* add the server address */
>         if (server->dstaddr.ss_family =3D=3D AF_INET)
> -               sprintf(dp, "ip4=3D%pI4", &sa->sin_addr);
> +               dp +=3D sprintf(dp, "ip4=3D%pI4", &sa->sin_addr);
>         else if (server->dstaddr.ss_family =3D=3D AF_INET6)
> -               sprintf(dp, "ip6=3D%pI6", &sa6->sin6_addr);
> +               dp +=3D sprintf(dp, "ip6=3D%pI6", &sa6->sin6_addr);
>         else
>                 goto out;
>
> -       dp =3D description + strlen(description);
> -
>         /* for now, only sec=3Dkrb5 and sec=3Dmskrb5 and iakerb are valid=
 */
>         if (server->sec_kerberos)
> -               sprintf(dp, ";sec=3Dkrb5");
> +               dp +=3D sprintf(dp, ";sec=3Dkrb5");
>         else if (server->sec_mskerberos)
> -               sprintf(dp, ";sec=3Dmskrb5");
> +               dp +=3D sprintf(dp, ";sec=3Dmskrb5");
>         else if (server->sec_iakerb)
> -               sprintf(dp, ";sec=3Diakerb");
> +               dp +=3D sprintf(dp, ";sec=3Diakerb");
>         else {
>                 cifs_dbg(VFS, "unknown or missing server auth type, use k=
rb5\n");
> -               sprintf(dp, ";sec=3Dkrb5");
> +               dp +=3D sprintf(dp, ";sec=3Dkrb5");
>         }
>
> -       dp =3D description + strlen(description);
> -       sprintf(dp, ";uid=3D0x%x",
> -               from_kuid_munged(&init_user_ns, sesInfo->linux_uid));
> +       dp +=3D sprintf(dp, ";uid=3D0x%x",
> +                     from_kuid_munged(&init_user_ns, sesInfo->linux_uid)=
);
>
> -       dp =3D description + strlen(description);
> -       sprintf(dp, ";creduid=3D0x%x",
> +       dp +=3D sprintf(dp, ";creduid=3D0x%x",
>                 from_kuid_munged(&init_user_ns, sesInfo->cred_uid));
>
> -       if (sesInfo->user_name) {
> -               dp =3D description + strlen(description);
> -               sprintf(dp, ";user=3D%s", sesInfo->user_name);
> -       }
> +       if (sesInfo->user_name)
> +               dp +=3D sprintf(dp, ";user=3D%s", sesInfo->user_name);
>
> -       dp =3D description + strlen(description);
> -       sprintf(dp, ";pid=3D0x%x", current->pid);
> +       dp +=3D sprintf(dp, ";pid=3D0x%x", current->pid);
>
> -       if (sesInfo->upcall_target =3D=3D UPTARGET_MOUNT) {
> -               dp =3D description + strlen(description);
> -               sprintf(dp, ";upcall_target=3Dmount");
> -       } else {
> -               dp =3D description + strlen(description);
> -               sprintf(dp, ";upcall_target=3Dapp");
> -       }
> +       if (sesInfo->upcall_target =3D=3D UPTARGET_MOUNT)
> +               dp +=3D sprintf(dp, ";upcall_target=3Dmount");
> +       else
> +               dp +=3D sprintf(dp, ";upcall_target=3Dapp");
>
>         cifs_dbg(FYI, "key description =3D %s\n", description);
>         saved_cred =3D override_creds(spnego_cred);
> --
> 2.50.1
>
>


--=20
Thanks,

Steve
