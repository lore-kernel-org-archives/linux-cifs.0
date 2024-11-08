Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512441D2B05
	for <linux-cifs@vger.kernel.org>; Fri,  8 Nov 2024 12:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731068016; cv=none; b=rMN5MdYT/49yPV6ywemcbwXdLRzMi6ylKpBQAL5j55NS1hSbAjl6MqwEdwhwG8MpHqCZaJDlY2Ptknnsv7a9PVTU+8SHjACiHl7C+fV6KBq9690wQmS1q2+BOJO7g+ymSWGr8soKAsKCKj6LeXJRZjA8CaaHo1vGYLF7ooK//fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731068016; c=relaxed/simple;
	bh=s7U+/pdRG/VCTcjFhEWTnUwinR31GSM0dBowg2f3Xk8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tdax5XLgiiz91TqwKCeCnIpMdrl3gvZF3ODtfcWh52jjaY8KyemLwwBVanU1ry2Qrbj6SChQ96DQvLXoNnxc36eqBbpwmrcrqwO/ojICmCFhb2vv5nuzbKtlM8aFMItcvR4wBRaIcvxgIL9l3P9TZSuBPJY5P0IBTCqbg9B8WL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CE5OHECb; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CE5OHECb"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2fb3110b964so18009101fa.1
        for <linux-cifs@vger.kernel.org>; Fri, 08 Nov 2024 04:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731068012; x=1731672812; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gYHR89BXeqWb3L3ONxF1WcUylgp79U45+DoYNa/qhqU=;
        b=CE5OHECb5KFRnXRKuBWrTF5dC5Dis7b+XPtSAjPME+n5H2WaS5EaLa4gz8tweMHMp4
         4bnQWNoSc62lVZAJwHZG+8gxVG5Yi+ETAmJWCFbda0zmBPpIdL5BT/+aVZoBBdHGUNfM
         TnAlng6YoAxlHxN76EM3kyc4volUqid2ANgBJWSr+QINYZPcXACAUCq6FtrSB5p8sjyr
         S2HhW9eVo3hZ+0AdqQRdKRpzztyb5wr7sgrqWq2BUPu6r7BHevzjLk0n9Y2arfUHg82e
         yqoFGm7qfxACJUlKozgct5wuT1+4VxUppgSTtI7nTnc1gnyg+qObZDjb3ixQ3Bj3H1+K
         S56g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731068012; x=1731672812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gYHR89BXeqWb3L3ONxF1WcUylgp79U45+DoYNa/qhqU=;
        b=MxZcXPT2Pw0ZdP183Z4mI0rmb2ePCD2dTL9JcePB2nYBKJu0QRdVqbceEBWhtmYdXe
         Jc5XOvBNQ1cX99LNwwKzovNXBbdyPB+fHLZ3/w/C86btvMV9isJNf9xjnGQugZvhMOWG
         f6DGsc3fu2XJA8OBBRkGvewWfAx8XFmyH03I4FFu8gGDtAKltrWGC2i6ljEVjOjyHo0s
         zshqy+DDDqFFLMB3l9qD7NU95WzVxcs7yFLgOKGAiR38NIt0rPA1J6AZbHczH4IjYw6C
         sQd49tyBIryJKj6fH9BR+m415Ok/AlwDrLHW+VGFKt7SDb8fa4JiLm3S8qCDLvVyVMmw
         Mxug==
X-Forwarded-Encrypted: i=1; AJvYcCVTRFhTqFXFoQ1CJ/n/MR4sLA9yfCh4XPal+0lEsuvcawuz5TZMltoTbODDx9lY22jIn8152NAeLYrd@vger.kernel.org
X-Gm-Message-State: AOJu0YyUyzUkJg6X/KNlJ2d/qhwPvw+wfHRl9wcyz8V0+kVkognISHtl
	t3vbjhpVXmBqX5F0vner8ajM5WXHUErFHrYunNVosYZdJ26La9qVJNn18ixawk1tW1Xc6SJ44JQ
	4+TUQhCmQzj2kkapXw94r48bZXL0=
X-Google-Smtp-Source: AGHT+IHH4pmkym2/fWDU6dN1k7esSePSy6DFLs0EHGgwhPNU6buzdnjfQnVgqoCyJTU/lMewDSko8/Uw8cqTLvpMpYI=
X-Received: by 2002:a05:651c:160c:b0:2fb:5a7e:504f with SMTP id
 38308e7fff4ca-2ff202acf05mr14414751fa.35.1731068012268; Fri, 08 Nov 2024
 04:13:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241030142829.234828-1-meetakshisetiyaoss@gmail.com>
 <20241030142829.234828-2-meetakshisetiyaoss@gmail.com> <0282479bc2f446bcb34c53a30bb53bda@manguebit.com>
In-Reply-To: <0282479bc2f446bcb34c53a30bb53bda@manguebit.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 8 Nov 2024 17:43:20 +0530
Message-ID: <CANT5p=qJ+zAU_0bMx=5uhsD1a5BR4Nj8Uv0KvNPOBNt9AtPs6w@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: support mounting with alternate password to
 allow password rotation
To: Paulo Alcantara <pc@manguebit.com>
Cc: meetakshisetiyaoss@gmail.com, smfrench@gmail.com, sfrench@samba.org, 
	lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com, 
	linux-cifs@vger.kernel.org, bharathsm.hsk@gmail.com, 
	Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 8, 2024 at 12:35=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> meetakshisetiyaoss@gmail.com writes:
>
> > @@ -2245,6 +2269,7 @@ struct cifs_ses *
> >  cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_contex=
t *ctx)
> >  {
> >       int rc =3D 0;
> > +     int retries =3D 0;
> >       unsigned int xid;
> >       struct cifs_ses *ses;
> >       struct sockaddr_in *addr =3D (struct sockaddr_in *)&server->dstad=
dr;
> > @@ -2263,6 +2288,8 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, =
struct smb3_fs_context *ctx)
> >                       cifs_dbg(FYI, "Session needs reconnect\n");
> >
> >                       mutex_lock(&ses->session_mutex);
> > +
> > +retry_old_session:
> >                       rc =3D cifs_negotiate_protocol(xid, ses, server);
> >                       if (rc) {
> >                               mutex_unlock(&ses->session_mutex);
> > @@ -2275,6 +2302,13 @@ cifs_get_smb_ses(struct TCP_Server_Info *server,=
 struct smb3_fs_context *ctx)
> >                       rc =3D cifs_setup_session(xid, ses, server,
> >                                               ctx->local_nls);
> >                       if (rc) {
> > +                             if (((rc =3D=3D -EACCES) || (rc =3D=3D -E=
KEYEXPIRED) ||
> > +                                     (rc =3D=3D -EKEYREVOKED)) && !ret=
ries && ses->password2) {
> > +                                     retries++;
> > +                                     cifs_info("Session reconnect fail=
ed, retrying with alternate password\n");
>
> Please don't add more noisy messages over reconnect.  Remember that if
> SMB session doesn't get re-established, there will be flood enough on
> dmesg with "Send error in SessSetup =3D ..." messages on every 2s that
> already pisses off users and customers.
>
Perhaps we could do a cifs_dbg instead of cifs_info.
But Paulo, the problem here is that we retry every 2s. I think we
should address that instead.
One way is to do an exponential backoff every time we retry.

I'd also want to understand why we need the reconnect work? Why not
always do smb2_reconnect when someone does filesystem calls on the
mount point?
That way, we avoid unnecessary retries altogether. @Steve French your opini=
ons?

> > +                                     swap(ses->password, ses->password=
2);
> > +                                     goto retry_old_session;
> > +                             }
> >                               mutex_unlock(&ses->session_mutex);
> >                               /* problem -- put our reference */
> >                               cifs_put_smb_ses(ses);
> > @@ -2350,6 +2384,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, =
struct smb3_fs_context *ctx)
> >       ses->chans_need_reconnect =3D 1;
> >       spin_unlock(&ses->chan_lock);
> >
> > +retry_new_session:
> >       mutex_lock(&ses->session_mutex);
> >       rc =3D cifs_negotiate_protocol(xid, ses, server);
> >       if (!rc)
> > @@ -2362,8 +2397,16 @@ cifs_get_smb_ses(struct TCP_Server_Info *server,=
 struct smb3_fs_context *ctx)
> >              sizeof(ses->smb3signingkey));
> >       spin_unlock(&ses->chan_lock);
> >
> > -     if (rc)
> > -             goto get_ses_fail;
> > +     if (rc) {
> > +             if (((rc =3D=3D -EACCES) || (rc =3D=3D -EKEYEXPIRED) ||
> > +                     (rc =3D=3D -EKEYREVOKED)) && !retries && ses->pas=
sword2) {
> > +                     retries++;
> > +                     cifs_info("Session setup failed, retrying with al=
ternate password\n");
>
> Ditto.
>
> > +                     swap(ses->password, ses->password2);
> > +                     goto retry_new_session;
> > +             } else
> > +                     goto get_ses_fail;
> > +     }
> >
> >       /*
> >        * success, put it on the list and add it as first channel
> > --
> > 2.46.0.46.g406f326d27



--=20
Regards,
Shyam
