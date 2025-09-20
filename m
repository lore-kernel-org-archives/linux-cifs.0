Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A76080C02
	for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 17:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758389858; cv=none; b=GoSKML/5AFXj0k9AEUjlmel5A/6NyJDSqtPGsjCleTreg084zPLyQcVhhqo3WGBYN1JEha6KzTnLqa74GluTezzthl2nYrjSx22E9mPVoTxclbeVl8RxKjEZIdptidWMKnhlreSAjzcJR6iWNzBkjUU9m5GG3O3QiD2Ea5gWom0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758389858; c=relaxed/simple;
	bh=f+nAcxABZAbrauxy1frHe6eUcCNFVf565g9JEMRH99U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j8sAI+A7J+IMGxmH8KdHkv4oCKcQUiX/u/KNtwz7QR4dVNoZdZH6H7wdYmWDJYWQ4MdOPJL9kuacvMyqyRXNuL7pR1SRh4yDcHjj3Jj/aYWnQ6ae4qLHzJZX2V8MY0fuwpN5NXb4osnE0Q+co6WI13EtpbDOER3gKkPtUDYPGQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E3dI/wao; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E3dI/wao"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-78ea15d3489so30442806d6.3
        for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 10:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758389855; x=1758994655; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jbsx7rUmB91XIm5gWKsYjh9edIm3/1qRqxHrPjtMuIs=;
        b=E3dI/waovTG7snS3wHhf2mgQIjU8NydKx89hKxAnDEXnxCrF9OiJnTWxd62yQ9Cce+
         kCSJzxDJ7kfd3Xfqd50060SKX7J7/m3m33CnV/k+w8Xum8RFTlbyHfhJO79wDIbEqXrN
         apcl+MRWSjj/arE6GVp7J7pSJmyGqvVybx8Cg3wDZ26lym2op5cuLqp9m61cS97DXZvc
         3qMcktKoAkSC2oETu+a5nrv57D5ZqplzjJaUUHRtTHCn+GghNmTQ/AXJuDr1IkGr8A2C
         aPD6koR/PC1HSCOhpvuLwfEBdOwFGQEno4eTNmXPSjLTw1oknRkBaFJtgwzq1jzoQc+f
         gysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758389855; x=1758994655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jbsx7rUmB91XIm5gWKsYjh9edIm3/1qRqxHrPjtMuIs=;
        b=xEr2WnYAT+bzlEpaThTxG0jLAbOsAD68KPMUnpJOWgX9ViqieekG+SfOQ+6YftKQdr
         MTaTXhqip4x7VKkbBoTzWxjxEefeqh6j06jnULwy1hWenTv9cnNuQS7m/5tn/Ku3eegm
         39hndfdqDHQRjYq5ZF7pb1rdjNRnywsu7EkaTMN6n6fzRGQB8iWa0uoVhUflLmBKUxz2
         OCm4PNaRVn0AJD8dPOS/7kHOlu3F5nn6qXRlvq47+HA18pqXm8IYR+bMNR5rU+SGS5az
         7z94f/fdkWeXlYn2bl/7c1yLGfOm0HiRW3J42texgTzYGfVIKuAE3q05LnkNOacQ9oJ/
         Gddw==
X-Forwarded-Encrypted: i=1; AJvYcCWP5jfqDaLTF2CxS63Amz23/fEcHrwJpC9cS6bGfD0ePAuGyZnwOUpyExgGx6j1sp90sr0xoIF1m0g+@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc9QWISjn8LOQa7M5SbuyQVEcyOcWgB7HPDBBTXFSerAUL+iQr
	sNOyYH+/CkSxI0gdPrQMkGPilMmzqNon4a9WlmqgmgSsw/z2VGV5DzddS31lBm5htIrj1Jk1BsS
	Tl8LEXWgP05Mu9t1ey79sAbp8I1CGx60=
X-Gm-Gg: ASbGncsn+HiThJs6HFMGHJi4ZbC+CI0muahqh/I7AiHUtQy+wFB5V3Sn72MFh7CO14W
	7TuSt9JqpbcbdGLA9A5Tfu3u7FiVPcCB+fy+JtXBDFNnpMEnaT+kJIuKOSbNXzbSSDJg80Pgnh4
	CQb5LuOvOvilL7GSzT/v0c/DixRE+H139fbEdyGHFEBQiqCEXvPRy397RP641IGQGQZ/QaGeVmJ
	/5fXnsLHlUrraUlo11x3zCBbCLp+DAnELFZYq4G0PR1aCy4Qtm6YJNytfb51KutKyOek05jHWnv
	tiltSbOifruW9YctYLoVVyTjLkmQLoIw9L3zqHxzfF1n0P+lOnyaqp2c2Hd07KC2zZ4yUewI7jP
	xt9JYeGFccarqojb0cIxo
X-Google-Smtp-Source: AGHT+IEGG/+DybMY0xWLcKMJ4e4xoQe1Ku4mr7qRXc/75fg96Yh4+/j5dqHLlbHCvMPSUlGVuSawtjaX2U4cHWHYVcI=
X-Received: by 2002:a05:6214:252e:b0:7b6:5b28:6324 with SMTP id
 6a1803df08f44-7b65b286515mr17533506d6.48.1758389855275; Sat, 20 Sep 2025
 10:37:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250831123602.14037-1-pali@kernel.org> <20250831123602.14037-29-pali@kernel.org>
 <CAH2r5muoF-OKg9e=T8moEifwJ+RwmGX28nXqgECM891TufqY_Q@mail.gmail.com>
In-Reply-To: <CAH2r5muoF-OKg9e=T8moEifwJ+RwmGX28nXqgECM891TufqY_Q@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 20 Sep 2025 12:37:23 -0500
X-Gm-Features: AS18NWAJekJFB_NLhgKjRocfWNcpOd3jLrYXMXU90vSTnV4EYdBzw7k6k57ufJc
Message-ID: <CAH2r5msw5+TxRRO7Ap9eaQX2W4AbZ4bqRHs=0Kv9O1mjV6TvBw@mail.gmail.com>
Subject: Re: [PATCH 28/35] cifs: Fix smb2_unlink() to fail on directory
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	ronnie sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

And of the remaining patches only 2 apply (patch 33 and patch 35) on
current mainline

On Sat, Sep 20, 2025 at 12:34=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> This did not merge to current mainline
>
> On Sun, Aug 31, 2025 at 7:37=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org>=
 wrote:
> >
> > unlink() should fail on the directory with ENOTDIR error code.
> > Flag CREATE_NOT_DIR handles that.
> >
> > Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> > ---
> >  fs/smb/client/smb2inode.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> > index c8b0e9b2438f..c69293fcf26c 100644
> > --- a/fs/smb/client/smb2inode.c
> > +++ b/fs/smb/client/smb2inode.c
> > @@ -1348,7 +1348,7 @@ smb2_unlink(const unsigned int xid, struct cifs_t=
con *tcon, const char *name,
> >
> >         oparms =3D CIFS_OPARMS(cifs_sb, tcon, name,
> >                              DELETE, FILE_OPEN,
> > -                            CREATE_DELETE_ON_CLOSE | OPEN_REPARSE_POIN=
T,
> > +                            CREATE_DELETE_ON_CLOSE | CREATE_NOT_DIR | =
OPEN_REPARSE_POINT,
> >                              ACL_NO_MODE);
> >         int rc =3D smb2_compound_op(xid, tcon, cifs_sb, name, &oparms,
> >                                   NULL, &(int){SMB2_OP_DELETE}, 1,
> > --
> > 2.20.1
> >
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
