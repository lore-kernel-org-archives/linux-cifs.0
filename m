Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830C92E7BD4
	for <linux-cifs@vger.kernel.org>; Wed,  5 Nov 2025 22:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762381246; cv=none; b=saE6Ax2C+fCPVbCo4Lhf63XovqhTEkSNmjZjgT3aeAugY0BYA1AhMh+K6Na4nXJ3WUS5i+jod1dM8+wSxZyDYnPSlhlG82GVHdJR/WsmbHR3FoBKg+bAfQ/gaAJrLqaLwPkqoTrXe9UckHXnVCxwlEVGGHVOoYPOXMf7fi8TiiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762381246; c=relaxed/simple;
	bh=I2Hsg/B2GBcgQ3xLGmh7nx19s9mgd3/8xUEED7dpNHw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UwKBUZEFxZwJxbqF4R3BE3Ppr0j8GRgnI/h5/k3xEMINj4ZaA4Zx673LknGWyh913hKyWW/JiZ73aYrTXzHntPsebMnpgbvqCH8RAThUBLUqqfY5mkVbIa2Uwf+N+R7ZTA+C+fh6Tox1ocjNaDGUaYXZ2scsMZkah52tUJqytNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e11MUsmK; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e11MUsmK"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-33be037cf73so394058a91.2
        for <linux-cifs@vger.kernel.org>; Wed, 05 Nov 2025 14:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762381245; x=1762986045; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h2iC3i/NABlxjjFozwtUiIBPGgmouctXhyOdEE/QiTU=;
        b=e11MUsmKnRZBbWPMOZX+kAWrlpzLPaRe+zIOUZecpS149AfOpEDaMpsxdsGWFt9inu
         hGRjtivH7t8m5XwkOiEF67KwEdqb57daKsJPuNYlSWZUMHa5Y8P5ki5mpzlGq0UvkIbu
         ponjqaK0B4pX9Vr2XzT0zu8gNIHoYAJRUTK4qwt2CTHVscN3O9Fv+1H5nxTJEzHl5VCx
         FqRT39yPPaKHL5SRXqjgaF/9h7Wc9kGAiUeLvwAbCDNoHPnEIG2VeJfOpBJ6KJL4jEHJ
         VwGynUz6IohPqXaeFFs/zpPCQPo3pdkCk4bwX3cVZWeHGTY0Zx/Ay65//RSGdy8YA8qB
         mk5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762381245; x=1762986045;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h2iC3i/NABlxjjFozwtUiIBPGgmouctXhyOdEE/QiTU=;
        b=ZK27yTATw5z/XY0hkJIGTJTvqDpCnN+FkyAH+7E2gFgW+qqP3R4PP69C5PtnenOEVI
         AcM1M8AD4gR1Y74EQ9fb608JjBxJ357hNP9oa9CgtarwRQCfD1mKbQLxmWgtzvNBwW/h
         hQugXfXXEiZm9wewJi2H3HHoHeeAmoI0JDxJBy14y+VP5Z7ZjB09qfxdNTXbG23uKWPc
         XFpmIjWGadzJBZsBu/Zi7roVlRFQT33pfwDInbZBGrPl50JAgtOrcqtrclulGP0JF0BK
         yDHrrBkPHCbcws0dgUz+YyOwWNA2+B5NcJUQAMIpCGBRyTEZ5sLtguVEpcEiapzDSDiD
         pnCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWndDpI5sx/E/UVaYiFi/VjQwmznrAvpAv8p55t5uiIyDGeI5QHjjv0LICflsJDVBtuKDn2oDYx/ZQy@vger.kernel.org
X-Gm-Message-State: AOJu0YyAPiQJDSn6G/m568xYru7mGU6DqFZTOEJg1U8QiTPfPrJ7XLN8
	sN5POwfDlytEK+5wtz54+gkMS4fEg90LiyEauO4Xcf7yd1ClSnA8AbstiLchg6jgWyZxQi3urhw
	FPS4Czj3p/F8XZLUggPCGM2UazOiUlhA=
X-Gm-Gg: ASbGncvZEIuhhfhi+iWny1743zs4/tV/GkkRM3fuzTK1PW4ZEM8g6fYE7WJkddCH/SI
	Rjlu7Ji7b0MLN9HwLhWMoDgoV2HDyrxrbQmtISWaBlA57p2retGZIRawmFG+zGuTTisWCqB4vfx
	zYK9PrKFnYnW53buhmaBPuDf46jRHQziwPUYu9raCW5iMchGtfi7DzimV1kka/lT760GjPUGEoi
	4zhfFlo0dPB7+cmDeJ9sFV68IJDdU6bxaxZzidMLkGhS6OJM18DOC+QcxME
X-Google-Smtp-Source: AGHT+IF9huOMB6L9BBqEVqTdSAoOXtne1VO5JWHa16xjKf9IxuOLvUQRWxxDT69nj5IfkbHYDZVPmIIL4ocNXonBxEc=
X-Received: by 2002:a17:90b:48ca:b0:340:bfcd:6af8 with SMTP id
 98e67ed59e1d1-341a6bfb6bdmr5773377a91.4.1762381245005; Wed, 05 Nov 2025
 14:20:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761748557.git.lucien.xin@gmail.com> <91ff36185099cd97626a7a8782d756cf3e963c82.1761748557.git.lucien.xin@gmail.com>
 <ffe0715b-7a60-49a4-802a-a2bd75c7dac4@redhat.com>
In-Reply-To: <ffe0715b-7a60-49a4-802a-a2bd75c7dac4@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 5 Nov 2025 17:20:33 -0500
X-Gm-Features: AWmQ_bnm5UfKvMR91-3ijvc6b8x8StJ9v75fS15sCmi9yT7hm61wUIVxJ8Ij89E
Message-ID: <CADvbK_e=UbsN2W7zqsRRHzbwZcSzR7GwZ9-YPrPcxvaHZ0ZjMw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 02/15] net: build socket infrastructure for
 QUIC protocol
To: Paolo Abeni <pabeni@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Benjamin Coddington <bcodding@redhat.com>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 4, 2025 at 4:38=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> On 10/29/25 3:35 PM, Xin Long wrote:
> [...]
> > +static struct ctl_table quic_table[] =3D {
> > +     {
> > +             .procname       =3D "quic_mem",
> > +             .data           =3D &sysctl_quic_mem,
> > +             .maxlen         =3D sizeof(sysctl_quic_mem),
> > +             .mode           =3D 0644,
> > +             .proc_handler   =3D proc_doulongvec_minmax
> > +     },
> > +     {
> > +             .procname       =3D "quic_rmem",
> > +             .data           =3D &sysctl_quic_rmem,
> > +             .maxlen         =3D sizeof(sysctl_quic_rmem),
> > +             .mode           =3D 0644,
> > +             .proc_handler   =3D proc_dointvec,
> > +     },
> > +     {
> > +             .procname       =3D "quic_wmem",
> > +             .data           =3D &sysctl_quic_wmem,
> > +             .maxlen         =3D sizeof(sysctl_quic_wmem),
> > +             .mode           =3D 0644,
> > +             .proc_handler   =3D proc_dointvec,
> > +     },
> > +     {
> > +             .procname       =3D "alpn_demux",
> > +             .data           =3D &sysctl_quic_alpn_demux,
> > +             .maxlen         =3D sizeof(sysctl_quic_alpn_demux),
> > +             .mode           =3D 0644,
> > +             .proc_handler   =3D proc_dointvec_minmax,
> > +             .extra1         =3D SYSCTL_ZERO,
> > +             .extra2         =3D SYSCTL_ONE,
> > +     },
>
> I'm sorry for not nothing this before, but please add a Documentation
> entry for the above sysctl.
>
Sure, will do, thanks.
