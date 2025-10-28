Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E81519755B
	for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 00:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761611594; cv=none; b=D+74wOxcNUs1PZ6KkhbmXAaf/abmz/xP8aqMOr3hNWX8jJ8iLiSAI0IHDYyCk2ggPdi9aCvoLkRHy+6fpENHyQ6hPHZDlZedqOHlcOCzSF3UzujZu649eFAfHilnXjGKbNAPUt2eHlEYcVPK8uPWuEeDMUAT87sqgFdwyGWRre0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761611594; c=relaxed/simple;
	bh=JrJSeGZHTN8ftiiXKPyingNz3ltTN7dHbGkFP8FsPZQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sfiyi2qNO8SPh1iSWYUzH/4CFj4qdAG7pjoiOH83kLlnWksqMxnif+Hq/K26WLZzGD9MP0VrBXatiAkB9zuWMtDEKYSvtOVRHq1K+rA685U3eFzLpb7BWTvadxEEgvFfEK+howkUAxPJkC2+dU9lZeBuSu3zQMeeQLnlosP8EpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RTznF3Q9; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RTznF3Q9"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-87c217f4aaaso65298126d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 17:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761611591; x=1762216391; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZ1ZEoQyhaLklv+RVzrPcp3TM3HVWzGytne15vV1p+E=;
        b=RTznF3Q9lMsYjed0gOVDkkIRupsfMhie5TYEpTHIIpWjwWVzw3PjvM2iMtNMAifClG
         sQ8+Frg6AWV/2mfBZbzkC7SftzyamBTI1G9pviZ67HBWJQhLd4zucdIAFjjTH4qQZbUZ
         U+bwqOlMYStALCIJORVodzx/p6ucoH4gdFyPZfvNWp4fENYzv14CheAtirBK8ap9bphK
         WDQk33Gz/kqBAWt7IIQIvhtmmHDgRWodo+mGf7Ys778oKeSKEZMZirq4JGnz1uSSgZEQ
         aW/HeZuJiNGXM8CZ60qXXn3+EOUzRs31pTfs9dVQxeK53O/S+VHyKijSksBLmkfZ9jLq
         hTVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761611591; x=1762216391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YZ1ZEoQyhaLklv+RVzrPcp3TM3HVWzGytne15vV1p+E=;
        b=Cf+X6cuWgQtv+O/YRXNtD0q0NRpBtSaFUlMH/+e6Jn8IIGq/Kq8UnTX8XHU0sHXaV3
         Gu0A++yTmds5azveLivkJ+sOlz8AGyTm9/0FM2nwV5K0UfHpzxbKMaJVlZEPJ8XpoIRq
         r37//lXlnawZCz3hDEKmRG2YpuG4aZzOLaVdduYX2s7virVcv/YHHQVt4hoyXXyJfFCX
         LkzHjrkNyLb6EXOT4vCFOU+IfvPtuXCpgQH+6RZTOVSjn9fAE5lyzvH7T+eirJ4FGpe1
         qcnOocIkkdmEPGVqjbLuHNnbK2dBbPNIsxMqzBlNdHdJL4+PXrWaQ3/S2tUQW1m3HEuv
         CPBA==
X-Forwarded-Encrypted: i=1; AJvYcCWQ4zejIGPbr7Anfhfta90z1leU4zgKnPn7srBGw8ra8CWVFdkvvLcsiUJZR6N62PUYILO5IHIIvH9G@vger.kernel.org
X-Gm-Message-State: AOJu0YwF5E1XAblobc1BToUSY/zSmBN7ykRggEDCdN4YRq2vPSXrQoq3
	iTsttI5kTwGj6A7KRDYnc08WBlOdynPZAvErW3D22aWr5ZYm+8DDWWnmAJephrSt9zWc26Dvsnr
	Kgj6F7XE1pppl2xRibeVnVduLfK5v5MXJ/h2O
X-Gm-Gg: ASbGncuYPWyMgHM2xcGGrWNKbP55zALod5fOjSZ4/LMuC+z+VqnQm9usM/tMzFjm24/
	wLcwNJgRVb6+VcmORCsga5Mwrz9/HEE+YQER/h9nsuPRBsTw66hxnmwnAAlolRHz6uL3xmWW4kl
	PQY2FgPSUlXqoGPiTMEAq1d+K2q6CzmaEYB0HzCbN3W8rIHLhpeFimJtjm6+afR0S2KYHmqC9NJ
	Ag7YHwRkVF9ES+35ShY2FiKVxPP2oNQGhyWnM3MwQC058FaWERLsruPsuU46js+XUA3hHzUJ5PF
	MKwrA8FRvcCHcpbErWszjQxtg76bQzYaCiVim5zvZybJAaf265rr0OOSfpbhColXltTIUCjO9BN
	C5a/vr2m2D37w0KHxjwG6g8WQ6GMRXrAz4A7WUce9vg==
X-Google-Smtp-Source: AGHT+IHpXbwArcYMaSlMJclyND+qAQm2TmGDhw1Cr4BJ0wSl42Su3fPabY/lEAQAwSDBDUt3J8Qn5s41TgnslIRV7xA=
X-Received: by 2002:a05:6214:20a2:b0:878:e13e:97f9 with SMTP id
 6a1803df08f44-87ffb1067f3mr20669116d6.57.1761611590793; Mon, 27 Oct 2025
 17:33:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027212919.2082212-1-henrique.carvalho@suse.com>
In-Reply-To: <20251027212919.2082212-1-henrique.carvalho@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 27 Oct 2025 19:32:59 -0500
X-Gm-Features: AWmQ_bn0d0kERimEeCK5C3FBcSEicqKKXFRoGNQG3QExqGazDf83aH3pixLgcl0
Message-ID: <CAH2r5mszqYAxcvuQp+VXMqx1OA--KvqNAXzX0nQN1BeDg6hFJg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix potential cfid UAF in smb2_query_info_compound
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, ematsumiya@suse.de, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending testing

On Mon, Oct 27, 2025 at 4:31=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> When smb2_query_info_compound() retries, a previously allocated cfid may
> have been freed in the first attempt.
> Because cfid wasn't reset on replay, later cleanup could act on a stale
> pointer, leading to a potential use-after-free.
>
> Reinitialize cfid to NULL under the replay label.
>
> Example trace (trimmed):
>
> refcount_t: underflow; use-after-free.
> WARNING: CPU: 1 PID: 11224 at ../lib/refcount.c:28 refcount_warn_saturate=
+0x9c/0x110
> [...]
> RIP: 0010:refcount_warn_saturate+0x9c/0x110
> [...]
> Call Trace:
>  <TASK>
>  smb2_query_info_compound+0x29c/0x5c0 [cifs f90b72658819bd21c94769b6a6520=
29a07a7172f]
>  ? step_into+0x10d/0x690
>  ? __legitimize_path+0x28/0x60
>  smb2_queryfs+0x6a/0xf0 [cifs f90b72658819bd21c94769b6a652029a07a7172f]
>  smb311_queryfs+0x12d/0x140 [cifs f90b72658819bd21c94769b6a652029a07a7172=
f]
>  ? kmem_cache_alloc+0x18a/0x340
>  ? getname_flags+0x46/0x1e0
>  cifs_statfs+0x9f/0x2b0 [cifs f90b72658819bd21c94769b6a652029a07a7172f]
>  statfs_by_dentry+0x67/0x90
>  vfs_statfs+0x16/0xd0
>  user_statfs+0x54/0xa0
>  __do_sys_statfs+0x20/0x50
>  do_syscall_64+0x58/0x80
>
> Fixes: 4f1fffa237692 ("cifs: commands that are retried should have replay=
 flag set")
> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/smb2ops.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 0f9130ef2e7d..1e39f2165e42 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -2799,11 +2799,12 @@ smb2_query_info_compound(const unsigned int xid, =
struct cifs_tcon *tcon,
>         struct cifs_fid fid;
>         int rc;
>         __le16 *utf16_path;
> -       struct cached_fid *cfid =3D NULL;
> +       struct cached_fid *cfid;
>         int retries =3D 0, cur_sleep =3D 1;
>
>  replay_again:
>         /* reinitialize for possible replay */
> +       cfid =3D NULL;
>         flags =3D CIFS_CP_CREATE_CLOSE_OP;
>         oplock =3D SMB2_OPLOCK_LEVEL_NONE;
>         server =3D cifs_pick_channel(ses);
> --
> 2.50.1
>
>


--=20
Thanks,

Steve
