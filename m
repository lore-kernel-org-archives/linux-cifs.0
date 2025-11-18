Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34651E1C11
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 20:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763496061; cv=none; b=BY+Hv4vbJzdJjvC6pdnZ7JVlQtqF0J60JnPlIKisn38S9kvLI1AoLf9lf4SB0Gju6aRtU64zYZA97qOfUNa98jTECI4a7i1+FpsPO4bjr5vwCSxRtYNRT8Kp40rhM2oIu5aKDo/9VJtvMQsJKQKl2JVENjjSEYrx/O/SNmli/Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763496061; c=relaxed/simple;
	bh=bxwZkyXgJK1eG2OMsfD30BKE+5u9fMN89vG41h1E+5s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jS7SPemfxfbhRroYygc5ho7UJoQh81+ahtfKqmnZ2JHep/frD2Sv1eDlHyxFv6Yq3ckXLgpYhVIbweZ6kK45XZrTfQ1Hbpnm84XCdVsZgzbEyFHitpPJ330NYI/jWeJL1Eq5GQwQxLZMjratM3TXl/O4im0sklLyuF8JJ5M04H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XrrLAj2O; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XrrLAj2O"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-88242fc32c9so65007206d6.1
        for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 12:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763496059; x=1764100859; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SB7FwqNIKbZ7R+GS+j9DGZBpb2NO6ssSsIVjR5I+uyA=;
        b=XrrLAj2OliuzxC65AP7Z5YP6JPrU5NeynbNCM+j7cAy4ssd13VFKmMugrripOSxMGv
         cU35vWcftq/wpaI/okMgq/IgIN4mIeVWILH3ewX8j2fY5zGX/tB8bAFkA17Tznnqajsk
         v6lC9ZL9Tybpo0ML5ff2VoxYLd63vdIvwDkwXEUBMXZpvkLjG6Ike0z9maVdQfdwjMDW
         oKgvd+BjL1TXBT7C5gV9Y+QrKtkeVUZWmq8ex6e9NsN0ckjA4EeS4aT9K6ezpm0Gmvwn
         YsJmpclTtaYJWTK++LaIcn1q8vaHjx1oCSrlf5ksS3DqQz2wOejqGTUtkRPSPeM4ssyS
         BNLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763496059; x=1764100859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SB7FwqNIKbZ7R+GS+j9DGZBpb2NO6ssSsIVjR5I+uyA=;
        b=tiXBtKD5j1xXvgeOdj2xsD2hCwHW9msuSB1hILJ7uOZE8IN7ii0+4yjGiFYbwb9mPK
         ehx/xP+pHwH/v68LkUF55sbYf8EpWiuQ7cK7gpnh6wn7+8/KpqhEFO03hhV5ZL7O9LuS
         +EWSQYsmcuE9YoxleKvVtfxYVnBFMtDuXdFb2uX0gpxfPf/HLdnmIvhgwIXw/DxUp442
         jAZAGVNu1WQHxRPiqvVnv2siJ1XsswgKppmrDdLCOtDFLcI5wn+jjPAe2a7pWQZbh5Oj
         t5dJpvuDjdj8ndkaOdUDw4NrwSso5zepPlcDHS4t1KXUCvnvvXBHidwjoQx4qEa5AD51
         N12g==
X-Forwarded-Encrypted: i=1; AJvYcCU5FqTwbtVHSyw3JpPtTOqGiSDarwMPKs6nWk8iBMjRe6gJfef077x0VjbshWBH3rycRLqcFX+KOKj9@vger.kernel.org
X-Gm-Message-State: AOJu0YyFNv064dmA794hiRtJVqsJgidKhJoKA5k0d+LUXoKqobGGV0nx
	ZIroGtUGFs+jWZU0HP2GgJ+cIjFFxjXqLJP4xLWnr2xtJjjaGzv/kem+p+0TIDVNi9udrnzRxcx
	CkqS6e24O9k2K+5NgGeMAwYfyYT+S9EA=
X-Gm-Gg: ASbGnctjwyDKQR3REF6aSvv+nFVzT3i7YDZrrVVNCyX/ZDpo4jp6JNJ3GPCZ6H+MFNX
	SEAIRySzPPPWANN8XY/c0MQ5A/5boAR1L5yy5h62NoXIWdwaYALeWQ8IFfuvw2q0fOmXB5Anls0
	cnLokr7jQK4vgXwvVVQ8eOTsoMGNh3jZY1O872uQ7/tlen+iGbqGVi95vKEEKvtIuGO+hC5MtJk
	77L34jWzpSybGQhdl5sLrhk7kV4HyizqKYZEGYBexMfop/NgQlY4nGum7/9iGlVdveFd5oU1aUz
	DZNNsopQO2EWgrjrI9XdZannIF5U4P5IRFo2cnFImqrRDsJrfmQLT+ileXLzsezsrq+y5p7Ewy5
	cSejKhduUZn4M/WxmZDx3jvwpeDfIwrdxYymszqIY+AEyjhfRdZBpretdC20aF1VYxVCoeBB5qt
	63TQ2xAMy5DsmdLq7+fKg=
X-Google-Smtp-Source: AGHT+IHhfzBJAEcCphFwzomj2W7zGvOCPeFDhl/lHKkpj3xi16n9G+ByWNLrLHv/3vIAjtNEDflU7OTWv23wgwwm1Ys=
X-Received: by 2002:a05:6214:cae:b0:882:4901:e960 with SMTP id
 6a1803df08f44-8829262506emr211040446d6.29.1763496058322; Tue, 18 Nov 2025
 12:00:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118150257.35455-1-ssranevjti@gmail.com>
In-Reply-To: <20251118150257.35455-1-ssranevjti@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 18 Nov 2025 14:00:46 -0600
X-Gm-Features: AWmQ_bk518tBwIwq4km9t_okTCnI85hG63NOZgFy5r88Hbvu-haY_fDOfVuyttk
Message-ID: <CAH2r5mu72dDwVfnK1ffAELCa1iWa5b5XXwTY1+7CTsFvTnN7Bw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix memory leak in smb3_fs_context_parse_param
 error path
To: ssrane_b23@ee.vjti.ac.in
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, 
	linux-kernel-mentees@lists.linux.dev, david.hunter.linux@gmail.com, 
	khalid@kernel.org, syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional review


On Tue, Nov 18, 2025 at 9:08=E2=80=AFAM <ssrane_b23@ee.vjti.ac.in> wrote:
>
> From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
>
> Add proper cleanup of ctx->source and fc->source to the
> cifs_parse_mount_err error handler. This ensures that memory allocated
> for the source strings is correctly freed on all error paths, matching
> the cleanup already performed in the success path by
> smb3_cleanup_fs_context_contents().
> Pointers are also set to NULL after freeing to prevent potential
> double-free issues.
>
> This change fixes a memory leak originally detected by syzbot. The
> leak occurred when processing Opt_source mount options if an error
> happened after ctx->source and fc->source were successfully
> allocated but before the function completed.
>
> The specific leak sequence was:
> 1. ctx->source =3D smb3_fs_context_fullpath(ctx, '/') allocates memory
> 2. fc->source =3D kstrdup(ctx->source, GFP_KERNEL) allocates more memory
> 3. A subsequent error jumps to cifs_parse_mount_err
> 4. The old error handler freed passwords but not the source strings,
> causing the memory to leak.
>
> This issue was not addressed by commit e8c73eb7db0a ("cifs: client:
> fix memory leak in smb3_fs_context_parse_param"), which only fixed
> leaks from repeated fsconfig() calls but not this error path.
>
> Reported-by: syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D87be6809ed9bf6d718e3
> Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
> Signed-off-by: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
> ---
>  fs/smb/client/fs_context.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 0f894d09157b..975f1fa153fd 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1834,6 +1834,12 @@ static int smb3_fs_context_parse_param(struct fs_c=
ontext *fc,
>         ctx->password =3D NULL;
>         kfree_sensitive(ctx->password2);
>         ctx->password2 =3D NULL;
> +       kfree(ctx->source);
> +       ctx->source =3D NULL;
> +       if (fc) {
> +               kfree(fc->source);
> +               fc->source =3D NULL;
> +       }
>         return -EINVAL;
>  }
>
> --
> 2.34.1
>
>


--=20
Thanks,

Steve
