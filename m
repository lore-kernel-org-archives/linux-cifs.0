Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AD743AB2
	for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2024 16:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724258303; cv=none; b=hHZuGVBLJEZEz1G6Ohl7ZjU/Yo6qEZ30CutBH4Cd/D+IPk6pGNEPTkwTBZJwrhLRW/ay/pIt0enRng/HbaTM1MGFmo3vUWo6JId2LiHunxix0DRbNNposdIqwFeJKMycFJD7yfcxbNtK+iDeuXaRjGU1W73gk9so4cgEQ7nSLLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724258303; c=relaxed/simple;
	bh=RQowEtLqORhQSTrjlpFQyIHB0C5OpwECFgTHuEbZZbM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=syfDIFVH0Kj/83OZHp30ll6gcp5TuMU7Xwj0d/yzPVW0PzBT9hQ3jULMCPtEpl2+q44SpQTaGdxrqyR55i8XKtwb0hCvpa1TwQEhnoA9bmwqTVydb6a7EDB+brpIV0AOSOX3WD/G8yPllZIsoLi2xMV6Ef5CZgYOT6rZAVoShGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M9q6lG2C; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M9q6lG2C"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5dcad91e64bso266193eaf.2
        for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2024 09:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724258301; x=1724863101; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ux2bSLYi4Lwzuro3wt2W6QOAJogwNq5yskHwfGucrMg=;
        b=M9q6lG2CG6i82Cr4HSU5e3DwDGT+PjBEzNFAQnuio+N/bibPjmcjpH8wdRLXgu06ml
         jUB+dJ6XeW6r5WyHkidK7UYIJ7gZnFrzw6crodjZZwLDJjRoworTG1gYj6XF7NISK+Dk
         9CVE2ubZdIw6If1PAunfH7h7qXG+Yxt2kfTpusHy79ybkDdK1YKBsIkMRhYfRcXwCE+f
         hetLLu/sdaNGc6Nais90XGBCsh0xLW6k5ICWMElqNRiU7k6ld/bM9qtXL9cWYWs5o2KZ
         yHlRxWU+7U7Q+Q9pWsEuF2C8f6LQa7EIN+Mk48dO+JTeGf1Er1ccn1WQxa0DPF6Lbvde
         OQqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724258301; x=1724863101;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ux2bSLYi4Lwzuro3wt2W6QOAJogwNq5yskHwfGucrMg=;
        b=V28oe2mqur85cBFtaqPQhU0ZP6UsLJq2PxVAVY7A5i/ONcXMwOaMk8bREkHdJdD8CU
         kC5sfPnpK1F9/N/lzYCFTAWJa/DiGGB0of7JqqEdSMpjVGhE8hv+6Ou/gSYnGQqKTD9S
         7gE4A2uRSz9DtD8UKpZH2r13R9yCPVVt4HyiGxOuAhWnnTcwOLgz73Vo4uo53mOxPZKf
         z2cQdxhftjRrfzulKbFvCyEUElIzCC+mUJc0tSh43zlUFsE9X2PsssAv5QzicUVDxXXu
         y7my/wfuqLOfKoGILO/Bs2bAICanukZaDhJ0tORkGr026Hfr8RcpxYyU6B14M6T0D2bB
         ybyg==
X-Forwarded-Encrypted: i=1; AJvYcCWGt9+mpdIXxNbNW7WpGJ7B6QRgbwYxRx58zCIIXV6jNF7cxEg2L4MhjV/sSdN90K71y7CvQ5IkuwpT@vger.kernel.org
X-Gm-Message-State: AOJu0YxLCkE9tyQYrD6wCLe/iAS9Hzsjw7Ga6d16uHNYGNUO9NT3BdJ+
	T238AQiv2Jl0Sq1Oj9YvgOSozcobmM9T27HAsH/DjhiBeVNH49bIFJx6PzSJNyAYDTrJ+dtY9CA
	57sBPsJQPG3uVnHHYq9gVdNmXOD/8bRPD
X-Google-Smtp-Source: AGHT+IERLueznaLqeGLmsBiOsIG8vs/UuxVNpWAwPWQciHPKDjXKSbKMkyyq3133EuzOagEnVDbH2WZxY8cKlLjLdpw=
X-Received: by 2002:a05:6820:178b:b0:5c6:658c:a9f6 with SMTP id
 006d021491bc7-5dca3c13b7emr3029835eaf.2.1724258300846; Wed, 21 Aug 2024
 09:38:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMHwNVv-B+Q6wa0FEXrAuzdchzcJRsPKDDRrNaYZJd6X-+iJzw@mail.gmail.com>
 <54a46d0e05c754fbc5643af2b576e876@manguebit.com> <CAMHwNVvAT-qeRvJ0jV2+5byHQnwzW9-YFj13ovXFC+M8hAfmyQ@mail.gmail.com>
In-Reply-To: <CAMHwNVvAT-qeRvJ0jV2+5byHQnwzW9-YFj13ovXFC+M8hAfmyQ@mail.gmail.com>
From: Anthony Nandaa <profnandaa@gmail.com>
Date: Wed, 21 Aug 2024 19:38:09 +0300
Message-ID: <CAACuyFXv=9WJtVLoTx9xhwUR=WPBbtYM11zEv8LO9biDaU=ZNQ@mail.gmail.com>
Subject: Re: Issue with kernel 6.8.0-40-generic?
To: Marc <1marc1@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Sorry my previous reply was with HTML...

On Wed, 21 Aug 2024 at 15:15, Marc <1marc1@gmail.com> wrote:
>
> Happy to help and assist where I can, but I have no idea how I would
> try this updated code. I think it involves compiling a kernel and
> applying the patch to it. This is not something I have ever done or
> have an idea on how to go about it.
>
I can help with this. Marc, if you can help me with the minimal repro
steps, is OneDrive needed?

>
> Op wo 21 aug 2024 om 09:45 schreef Paulo Alcantara <pc@manguebit.com>:
> >
> > Marc <1marc1@gmail.com> writes:
> >
> > > This has been working great for many years. Yesterday, this stopped
> > > working. When I tried mounting the share, I would get the following
> > > error: "mount error(95): Operation not supported". In dmesg I see:
> > > "VFS: parse_reparse_point: unhandled reparse tag: 0x9000601a" and
> > > "VFS: cifs_read_super: get root inode failed".
> >
> > Can you try the following changes?  Thanks.
> >
> > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > index 689d8a506d45..48c27581ec51 100644
> > --- a/fs/smb/client/reparse.c
> > +++ b/fs/smb/client/reparse.c
> > @@ -378,6 +378,8 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
> >                         u32 plen, struct cifs_sb_info *cifs_sb,
> >                         bool unicode, struct cifs_open_info_data *data)
> >  {
> > +       struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
> > +
> >         data->reparse.buf = buf;
> >
> >         /* See MS-FSCC 2.1.2 */
> > @@ -394,12 +396,13 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
> >         case IO_REPARSE_TAG_LX_FIFO:
> >         case IO_REPARSE_TAG_LX_CHR:
> >         case IO_REPARSE_TAG_LX_BLK:
> > -               return 0;
> > +               break;
> >         default:
> > -               cifs_dbg(VFS, "%s: unhandled reparse tag: 0x%08x\n",
> > -                        __func__, le32_to_cpu(buf->ReparseTag));
> > -               return -EOPNOTSUPP;
> > +               cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag: 0x%08x\n",
> > +                             le32_to_cpu(buf->ReparseTag));
> > +               break;
> >         }
> > +       return 0;
> >  }
> >
> >  int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
>


-- 
___
Nandaa Anthony
