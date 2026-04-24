Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899DF41C6A
	for <linux-cifs@vger.kernel.org>; Fri, 24 Apr 2026 04:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777003663; cv=pass; b=TjgK1C9Si4f2OlGJ4wXvNLA/31JnTfZGaeyE4hw9s1cpEw03JBu6Fr1rRUqV/orunI8iNjn20obK4OnYqC0lwa+9p6C0+Y+Ip6S8RszOupyYprRoKy/9IoFp2FywVNhoh5KyRsjZBcoBcsqZPReT1EtujGCS5oV7DA6b2+Oea2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777003663; c=relaxed/simple;
	bh=8lT7lc9gnjls/ciyCvKLODuCStiG/EA7QUVInLxPsxw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rLbModYqO7+cjNm8o1cdNEa9BlgDt65sQNYCzHDEbzEfuZzRj3T6QCixXZ4QHlRtYUe3dj1SPB+xyuaJTDPiaEE8qaR7d1kS8X7G1PQYJrHPWhsilmvtif4ekn6iSncaZcwBmH6gJC92LxlrYOFzWzNBXhNFma2ULMDzsL0KLu0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JzkKsuOJ; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JzkKsuOJ"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ba67b332bbaso824923066b.0
        for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 21:07:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777003661; cv=none;
        d=google.com; s=arc-20240605;
        b=fDCpAagoSe1Evhbp6brQOs3dbNFbjxEuVC/fZ7vUEElf9JthuwkZIVCwpo/WsOo7NZ
         NhZpfo1wmfBi/CHOoN7bWA7R1HQGKxbdqcKNDtMzLPx00gdLBaXjKts/t+HaYe56my4B
         slh+X2s11uqnST/LCgO5khYgIK9fCFVpkCHxVtn/73PT0kZeanunz8FuJ02jiI5hXQF7
         8xvukK4WZqseUlIuawWELEA6Alxfl1+M/YG4QRLFAMfPVaOXOcigdahZEOlWfjYqAJTk
         02+G0Oswhb/8+IUcwixm2bQVzKibN3c+HmSg2MUa0Bbb5U+tMPB1YGyuZfaET84u+wAT
         arVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iI2n+RqTAHgebFCF3Qcd87I1wf5GwnnOD9L0RHCmZxk=;
        fh=KUxQK/NEwTqWJy7v5tO6GgQtjZUUyRr+f4DkWFVnrJM=;
        b=QKmygBrfwaMZqKKER7U8cZ6O/uEeUcgpbjqbL8s/wSgI/7lm9YfDHss/JkwhxrNN0Q
         r+J9Wvpx7/UcWn370vg6G1UM/cP9Y5hcpD7mtXjau2me+WPUu8xTsce62qjtMs/a/J0x
         fg4j3U0sPPGvbFmTsGgDcYoAY0WDO57Thp7zjFuNt6893llKuIsYutfX3EcOEXx6mC/K
         FzoLDTJIFaIHBxLqjTodW5b9CqUX0b80I7E7JoG1uL9A57UnMXkWb0qgZVCEwXdwnziN
         kFKQVkP8SW1v5OYneSNaQ5tzmkAc9E73/QMctw1LCBThG3BeEa//5oyoXCWG7ZMzPlex
         EJNQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777003661; x=1777608461; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iI2n+RqTAHgebFCF3Qcd87I1wf5GwnnOD9L0RHCmZxk=;
        b=JzkKsuOJELGr7bluJ0y48SN7dVbS98KjpXS6+YpZfKJNLlo3I5yBBaGYEj9M+PodYE
         WL7j1Qk6/V1NB9DhjhjYmmZNdQ5T8Pq3cYulPJ7OCxrkDkephNsgGlmzcosr9/s3VW8A
         KTbe6m4XXsicUBg0L0wFz5jFvVyEt8lCBKKDBp0N3ure1qPfTnfR7nrvAYrNU/FcwM7N
         +Uehragfhb++4TWZPeXICw7XJrQ0d+ygOMFuvoTqapGwzpmG1hnZe//uYWs5YX0SirSU
         +cEPiJ1+C72PEizSXxXjdpQmyKUWU7aCV+My7sdN2cTpGO2A2Nvv/hslfkBzdLi8ZESr
         te/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777003661; x=1777608461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iI2n+RqTAHgebFCF3Qcd87I1wf5GwnnOD9L0RHCmZxk=;
        b=m58+8ytw9G+W7reasIvzMm8cIZ613ALBAJve+lyp1t8AWYc71KlbjI3bzJ11DFgxrw
         e95xo/NFNGtvGAH7SO/Wo8Nv1uZvyATQhy5RyPZqd147rp2Y2DBW/YX2wMCTJK8lSzj5
         2oNYF97xVjhVvECcX2/7Yjo3knr/u3LmjQxirjvjZ1eM6UvdI71kZ+Aqzd+JrRMpnXyg
         t7Kt1CF9FpJApjQZ2mYBPm43sjTMpyezsB0XYTExWr4nl+TMoJfY2MIQobHMgSYkrfqA
         gLizP0xeaHGKilGL0pK7n0LVaFshmjH0ucz1X0RuPZ54pqREQTLOTkAah85e33S+UZ9f
         knjQ==
X-Gm-Message-State: AOJu0YzLU++RKNNw1Q11e2XdtE8qAbJ9hF0LNPPLZvdqypgJkHw489uN
	Aa1c2vPFOAlAtrh0C0OfL+AqKcAT98aZlG7cUnze/qB08a3L2v92zlM+OX650sDBWGrw8+Rxphd
	X5LhQmmeFNciUb5CUHJ2BFJzeindj2mU=
X-Gm-Gg: AeBDiev1QkzYkDPFrhIEnHagGoDvMCg1wdmMakQPxOdsSjPxTkjMl5pYQpv2Y6ll30j
	jN0D9G0Binx74rsynDp+mmP+RQC8b6L9d2n0N6IQn9I1RPYCJe0LsPc8Ocwj9NcHWvuAQ7IOgl+
	rVu4sdlmyJeCOgeAqUS2H9FTInlO/DS9DZ5VvdOySQfdcwOaNNFrK8jMmVanX2tKSQphPnAcmId
	4Wu56MvhKSOBibM3SjIdNnmh3p81EDBDyEd01xdIItJ6h56bvqR8t98nM5fdQqlZUmcNsVYEviP
	lRb4/XXF3ExCs0RhIZI9wjFpDik=
X-Received: by 2002:a17:907:9407:b0:bad:9363:901c with SMTP id
 a640c23a62f3a-bad93639641mr72236466b.17.1777003660722; Thu, 23 Apr 2026
 21:07:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260421063955.99164-1-sprasad@microsoft.com> <CAGypqWxMLSdPhpGcomCeokiRXFR5kb+CQGNON7bsUiOPfswLKg@mail.gmail.com>
In-Reply-To: <CAGypqWxMLSdPhpGcomCeokiRXFR5kb+CQGNON7bsUiOPfswLKg@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 24 Apr 2026 09:37:28 +0530
X-Gm-Features: AQROBzAW3w1FuK-XdtcDYR_CneGiucSLwJKIh7osAVnd0qm3QWtn-FJvFxz7nZc
Message-ID: <CANT5p=resJ+99BXP59w-ydagKExL3zUqX8SVUiWjnQNd8-_dsQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] cifs: change_conf needs to be called for session setup
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.org, 
	bharathsm@microsoft.com, dhowells@redhat.com, henrique.carvalho@suse.com, 
	ematsumiya@suse.de, Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 21, 2026 at 7:29=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> On Mon, Apr 20, 2026 at 11:40=E2=80=AFPM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > Today we skip calling change_conf for negotiates and session setup
> > requests. This can be a problem for mchan as the immediate next call
> > after session setup could be due to an I/O that is made on the
> > mount point. For single channel, this is not a problem as
> > there will be several calls after setting up session.
> >
> > This change enforces calling change_conf for the last session setup
> > response, so that echoes and oplocks are not disabled before the
> > first request to the server. So if that first request is an open,
> > it does not need to disable requesting leases.
> >
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/smb2ops.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index 509fcea28a429..3625030d1912f 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -111,10 +111,19 @@ smb2_add_credits(struct TCP_Server_Info *server,
> >                                       cifs_trace_rw_credits_zero_in_fli=
ght);
> >         }
> >         server->in_flight--;
> > +
> > +       /*
> > +        * Rebalance credits when an op drains in_flight. For session s=
etup,
> > +        * do this only when the server actually granted positive credi=
ts (>2) so a
> > +        * newly established secondary channel can reserve echo/oplock =
credits.
> > +        */
> >         if (server->in_flight =3D=3D 0 &&
> >            ((optype & CIFS_OP_MASK) !=3D CIFS_NEG_OP) &&
> >            ((optype & CIFS_OP_MASK) !=3D CIFS_SESS_OP))
> >                 rc =3D change_conf(server);
> > +       else if (server->in_flight =3D=3D 0 &&
> > +                ((optype & CIFS_OP_MASK) =3D=3D CIFS_SESS_OP) && add >=
 2)
> > +               rc =3D change_conf(server);
> >         /*
> >          * Sometimes server returns 0 credits on oplock break ack - we =
need to
> >          * rebalance credits in this case.
> > --
> I think it would be good to add a comment explaining why the ' add >
> 2' threshold is chosen
> here and the assumption that the final session setup response SMB
> server returns '>2' credits.
>
> Otherwise, Changes look good to me.

Ack. Will add more descriptive comment.

--=20
Regards,
Shyam
