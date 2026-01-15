Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23A4EEA8
	for <linux-cifs@vger.kernel.org>; Thu, 15 Jan 2026 04:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768449650; cv=none; b=IvUcPiSFbrLx1wmuE3GZP2psyKI/ls3Knc2bZ1O8u+9QGvUP5+0taBYgKaW3IWEpWkq6ccLAQRrkf0bTHTXGs8VNkk+9tXFy5roigLs8OdTZDq2bcs6oVLkONfOhXLSJFyWPegicmpjB72gRGYAapmfvzS08Hmg2WKrkw+wFAQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768449650; c=relaxed/simple;
	bh=BIaCcxgsYTVmwKnFH8qHAk5dB2uSmISsFkUVpFg4cws=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dk+chwRhhnm7Grsn4uDvQGra32Gj5X+TOW8pMK4xnY9JiGAbM20DpZ5XUe/xPASibF1rIW4WG6KaeCIVgtNhvDOff+ScNQzNrA8hYcp5X9EcT7slNkUcAupzzxE/FhEF8oQxfyZLfgZZCIc/ozvRr8+SaF4QurCVn3f7eSNprlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MinCN+mY; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MinCN+mY"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-88a26ce6619so3501956d6.3
        for <linux-cifs@vger.kernel.org>; Wed, 14 Jan 2026 20:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768449647; x=1769054447; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s0gqLqvc/A8IA65eqcBscrIIRoTRZJPY10gRz/rm3uc=;
        b=MinCN+mY6I3WB4u5zMwgUS1FEDPsirsa4ogpa+LMNYMBEoUBgEYXRS4+yKQ7bO5EUD
         0EH3FirvD8SEnX8Ax74ftQJBDUDb32cngWSc6rdTsw6oAh1ChwW7/P+XWDjZ+U8LMd75
         uo7sr5jD76uSgJ0KLc8scbDB5OETwXdkfCvI7PoLwQRmwm8V0e1Mq9X8WTbbatP8QjfC
         wWTifLvY7EhlHE1+xsRCYhXubmxPk4XQWIvZaWj1fDbOSmAkKJNrcbAVHA7vXeR5Cxkj
         vBEiKVpq03kAZwegVGBthv8SvR/WwETph5xydyi97omhiUJicotS/NhNWKsoKtl5Ihnv
         hzOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768449647; x=1769054447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s0gqLqvc/A8IA65eqcBscrIIRoTRZJPY10gRz/rm3uc=;
        b=qJOLcWEexQtASQoSj0pzd9upRaHz4RqQ7E0DYH19HdMcUQP3RPt6fHHBmJ/wXl0drz
         4OThNCP4l0LQWMCRG40RBNA7d2GkQZP5LXUkJQv7QNsqPgKXx+uBn6z7UGoULk9g0daR
         O725UIRk80prQu2BrAuSDbMDn8lnDVOG3Ku6K6ZnA7pnUhpVdBv8Td2kamWUxTJyiWQp
         lh8vuOGNvRT/u/SSqUukhqzn8mVFDrvYfIWjs79O5hJqMX53LQrRC6jW6JJRcpVQ+HyV
         C4ZV08ENC235Q69xVDtY42btQXc/iv6zs2cm5rEfEBIqOE36w5xshFE42+osNznjGcqR
         l5UQ==
X-Forwarded-Encrypted: i=1; AJvYcCWx4jlGyRundllfC5LCAjx055C3PwSQJls4/eW6mWZEFQboTGvuCRI6jTk++lErrmnnnBmuMo/hjr2T@vger.kernel.org
X-Gm-Message-State: AOJu0YzkqYW6d5k4+eBL34lVo31wiyEC+KTQPH+EYk0eKOpQ0jqeD2lh
	OWfI703ZaVddNvv2Yvf7E+u5VMegedD3VRslYcf5iGDqLec04b33wqqWgvNrtmzyygWh868M/3Z
	zKEQdZzqENSzydMCv0spmeW/cx9X9Z48=
X-Gm-Gg: AY/fxX6teoWhAntYbA8Ua3Itb426tMeDv7e7U79Y0Bf3bTKzknnr00zrEAgN19Vaw1s
	2qaeMPl/J9SO5bl62h27wYg2kxxjpXVQ6S2ADU9M/n3sSi0imXSaI7maupBSNVfRV24G+srdn3j
	GjzTRQfB85wMZgY1fpKC15jZjqPBPwIbtElFgMKGs2jfp7k5rdbsnLCts3KS8SPeFarIP9kDJ4w
	q4uh1lSkuLGNLi4WYqT+8e9TGNsJWdns6Il6adQV2lbm8JScc0aa0H5E/myEn308PTKgtAf0Qzd
	B/PF7+RW7gZfHtOXOTgkO39j2nNNOD02fuJYfVRkZCMcfOwXgQSYyS1Pwxzt7C0hOxTXyWvp4Bt
	SgSO0plxR+Dlg3h5nxnh+YDrGTOJXA31Jm3wQCNyOuPbVxMsAbiCYqAIHxxoyNR9J
X-Received: by 2002:ad4:5aae:0:b0:88a:32db:ca2e with SMTP id
 6a1803df08f44-89275c79a19mr54301346d6.66.1768449647422; Wed, 14 Jan 2026
 20:00:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251226201939.36293-1-aadityakansal390@gmail.com>
 <s4kmfu25glkgu44wl46e3q3bjvyhlbcvnlaiuqkuey4qlg4d5o@s7ispothcved>
 <CAH2r5msUWXyzLTK1BtJ2feNe7Sj7+P-y6aix6Tdc4yJgUc8TEw@mail.gmail.com> <0b7d9053-db8b-4153-9bf4-99af66c64262@gmail.com>
In-Reply-To: <0b7d9053-db8b-4153-9bf4-99af66c64262@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 14 Jan 2026 22:00:33 -0600
X-Gm-Features: AZwV_QhHhotl32No4O91pT88mkvzsTcFHbIQnlGB1WMExF1rzSKg2JOasbAuv2M
Message-ID: <CAH2r5msfYRdaGAMuTbni-0T20tQi=N=fT4qxiaQ3siQ_WVm=Qg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: terminate session upon signature
 verification failure
To: Aaditya Kansal <aadityakansal390@gmail.com>
Cc: Enzo Matsumiya <ematsumiya@suse.de>, sfrench@samba.org, linux-cifs@vger.kernel.org, 
	pc@manguebit.org, ronniesahlberg@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

If the client required signing (on mount or via SecurityFlags), I
think it is reasonable to terminate the session and reconnect on
signature verification failure.

If the server (but not the client) required signing but screwed up the
signature it generates (due to server bug presumably) seems ok to keep
current behavior (presumably we ignore the bad signature and just log
it)

On Tue, Jan 6, 2026 at 10:03=E2=80=AFAM Aaditya Kansal
<aadityakansal390@gmail.com> wrote:
>
>
>
> On 1/5/26 22:30, Steve French wrote:
> > On Mon, Jan 5, 2026 at 10:37=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse=
.de> wrote:
> >> On 12/27, Aaditya Kansal wrote:
> >>> Currently, when the SMB signature verification fails, the error is
> >>> logged without any action to terminate the session.
> >>>
> >>> Call cifs_reconnect() to terminate the session if the signature
> >>> verification fails.
> >>>
> >>> Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
> >> Thanks, I think this was long overdue.
> >>
> Thank you for acknowledgement.
> >>> ---
> >>> fs/smb/client/cifstransport.c | 7 +++++--
> >>> 1 file changed, 5 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/cifstransp=
ort.c
> >>> index 28d1cee90625..89818bb983ec 100644
> >>> --- a/fs/smb/client/cifstransport.c
> >>> +++ b/fs/smb/client/cifstransport.c
> >>> @@ -169,12 +169,15 @@ cifs_check_receive(struct mid_q_entry *mid, str=
uct TCP_Server_Info *server,
> >>>
> >>>               iov[0].iov_base =3D mid->resp_buf;
> >>>               iov[0].iov_len =3D len;
> >>> -              /* FIXME: add code to kill session */
> >>> +
> >>>               rc =3D cifs_verify_signature(&rqst, server,
> >>>                                          mid->sequence_number);
> >>> -              if (rc)
> >>> +              if (rc) {
> >>>                       cifs_server_dbg(VFS, "SMB signature verificatio=
n returned error =3D %d\n",
> >>>                                rc);
> >>> +                      cifs_reconnect(server, true);
> >> I'd like to hear opinions on having reconnect happen only if signing
> >> is required by server, otherwise only log the error (current behaviour=
).
> > I was thinking the reverse - if the signature verification on the
> > client fails but it was the server,
> > not the client, who forced signing, then we could skip the reconnect
> > (and just log), but if
> > client forces signing (sign mount option eg. or
> > /proc/fs/cifs/SecuritfyFlags setting forcing
> > signing) then we should be more strict and reconnect
> >
> Thank you both for replying amidst holidays. I understand what you are
> saying. I am
> happy to revise the patch. Which version should I go with: reconnecting
> when server
> forces signing or the reverse?
> >>> +                      return rc;
> >>> +              }
> >>>       }
> >>>
> >>>       /* BB special case reconnect tid and uid here? */
> >>> --
> >> Nonetheless,
> >>
> >> Acked-by: Enzo Matsumiya <ematsumiya@suse.de>
> >>
> >>
> >> Cheers,
> >>
> >
> --
> -AK
>
>


--=20
Thanks,

Steve
