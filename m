Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE70BA34
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 05:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758606673; cv=none; b=uGlzHXviTi2jlaFFGivjjKylptTgGGJnHsJgC69aeBfejtSvBIUzFFJ8UrHrl5l9QjVN7F7hihijSaAlbqcxAaNyEFB2hQygLrbId32up+FVc2wPntk6AUhQH1AH8FvLfF5S0n/fSZh4umw2x7uJVIsruFvZiGFZ4Odi8zAmwvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758606673; c=relaxed/simple;
	bh=7vzNUyVbTkZEX9Yo0h80M9KHJXaNs2BROEdqSbIJ2I0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oCkRpsdSv8ag6G0IjE7haMN8wWUGIRhEu/5DBcus5u7PLCbtTQkstUwX/LMmKUT/FKMw1ZZbTRMjNQ1BYaSDtvDk4785Tx+kJTkKs1Q9Q+nNHgN+9mgXuErebRvX1/5W6Ol1wPgT7VoJnHTraQJg96jCVyYr9Sr3COuf31HhrCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W7/XMcH0; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W7/XMcH0"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b2e66a300cbso250598566b.3
        for <linux-cifs@vger.kernel.org>; Mon, 22 Sep 2025 22:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758606670; x=1759211470; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Rclo64BIQ60aWNHFZJxWB0Ardorfdp+QiYuOEftSfU=;
        b=W7/XMcH07SWvC/rY1TEOWUER1ejTMEj6/ei9+AO75Ztj5JviHn93IjzogAp+Cksnbv
         iK/pUTiC9rJA+2SNMdqcKCk9jXoQRjsUuKLvDLALF1QXrhboFQUVBjwpfSsQZRCjxs6N
         dp/4esytpCXYHOPGoARofm4Ze4oFDDYhsQI6UKH4Vl5xfFQralVaWbHonxbDzGLul4Sz
         10VQ3JRhh3hE38d8Hz6hGJV6ioalsSYISGscAevKDYinIrKNPZ7aic6DVeqSChFDbboE
         jRIbLmWMI5Dnz9Y/09zk0W4vswANkKw8mHYhHLpOEEwA5opKm7r9JP3E10mSO8cI7dfl
         6YCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758606670; x=1759211470;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Rclo64BIQ60aWNHFZJxWB0Ardorfdp+QiYuOEftSfU=;
        b=wqUQ0eVATZxRzk6XUUqL+/S4nYg69Ce8iPDS+XZ8kpArEao0mepAka4Xk1DpLO73dw
         XQhj24WynpERDtMLwZYuvRlbcjfEAiJap9y+97SVZ34ndZX2bmwuX4Ezp1yvaiVxZuIX
         fMMEskHKxzm78EkM7EpBGitd6uJ/MYLwJz2lxjOhPu8N36eS781hJRDnWsll7vSI6GbC
         YGjx9t/SchjdS+oxTz0LihFyTO9y5GnBAn7/bd9XfoUVhkQ8LgZI/he89FHXWE54B+wb
         TvIwBYrq8XnrMKr+pxof3dFJQf0TPdTRlPtGN42KreYwtOtTxNWuEq1pVxkFasm85OUK
         Kmmw==
X-Forwarded-Encrypted: i=1; AJvYcCUB6+vUPlREsDn9DCn6oQpBuGZ1edGiCWf2VcrSWCxe04LOyo+cClc2ZU3F0BJetz+Ff6ZZVm0lzT4m@vger.kernel.org
X-Gm-Message-State: AOJu0YxglgNMOnIRA3vgykrploWYsLjZY+axaEZ2pywUrnhvPj0SCuR1
	kLQ44vOFZ1dDUaGuMJ+ZIRTVVPfFpH291KyENg3GjSCcZxsFErdFe++AxxxAjG5V5lMQg+o2jSa
	k2NEKPAhCyhFguPiBvVa/oN5taN5ziXI=
X-Gm-Gg: ASbGncuJWPw1grFKlpta8g48XNFV3uXproxKoDYVcv4KScri8JLoVjPoB27FGLSzGFe
	s67sjqgAO5EnJHw47H8ueiPMn84DfWvKJ2zGjYLYoFqaZ6fWOqtGb8SyhfrR2BpgEM8B+6PvFUp
	MP6pNsS+7YMo4VIvMuVfMW4/EJ5RvcuWd0o8BnGZEFp7UIUMdQeGSWHZqNjEFxNriuGdoPOgwbq
	qzJUg==
X-Google-Smtp-Source: AGHT+IH7TdssnS5qMaLU0popPFCw6NnbrKbkqeHN9FUSAFsycRrelKRVehoar4TXFvkLVFGqYheq/LvCXZYe8biHGWk=
X-Received: by 2002:a17:907:9287:b0:b07:c815:70a9 with SMTP id
 a640c23a62f3a-b3028427f9fmr111647866b.26.1758606670182; Mon, 22 Sep 2025
 22:51:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250922082417.816331-1-rajasimandalos@gmail.com> <CAH2r5mtpEc7ePZ58_qdE+9GRPVO3PPYuN44uHuskoQpnssbkdA@mail.gmail.com>
In-Reply-To: <CAH2r5mtpEc7ePZ58_qdE+9GRPVO3PPYuN44uHuskoQpnssbkdA@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 23 Sep 2025 11:20:58 +0530
X-Gm-Features: AS18NWCtF7MOgYcDiyoQBMAI1ZcnuNUHSecZ96WtJR-i9O-dzS01hRDZseli6rA
Message-ID: <CANT5p=oG_btGS7xKXoRS8Z46JqBQ2E8pud9XRDWrJe1AhGaZYQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: client: force multichannel=off when max_channels=1
To: Steve French <smfrench@gmail.com>
Cc: rajasimandalos@gmail.com, linux-cifs@vger.kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, linux-kernel@vger.kernel.org, 
	Rajasi Mandal <rajasimandal@microsoft.com>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 22, 2025 at 9:36=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> i just noticed a more serious problem with multichannel/max_channels
>
> When we mount with multichannel (at least to Samba e.g.) with
> multichannel disabled on the server it confusingly returns "resource
> not available" we should at least log to dmesg something more
> meaningful than what we do today:
>
> [ 1195.349188] CIFS: VFS: failed to open extra channel on
> iface:10.45.126.66 rc=3D-11
> [ 1195.454361] CIFS: successfully opened new channel on
> iface:2607:fb90:f2b6:0732:7504:183c:991e:6e53
> [ 1195.454599] CIFS: VFS: reconnect tcon failed rc =3D -11
> [ 1195.457025] CIFS: VFS: reconnect tcon failed rc =3D -11
> [ 1195.457040] CIFS: VFS: cifs_read_super: get root inode failed
>
>
> Samba behavior is also strange - it advertises multichannel support in
> negprot response but doesn't advertise it in session setup flags.

If the user mounts with multichannel enabled, then it is expected that
the client will try to setup more channels.
If the server cannot support it, these logs are expected.

Btw.. It looks like the client was able to setup one additional
channel above. But reconnect tcon failed. I wonder why that happened?

>
> On Mon, Sep 22, 2025 at 3:25=E2=80=AFAM <rajasimandalos@gmail.com> wrote:
> >
> > From: Rajasi Mandal <rajasimandal@microsoft.com>
> >
> > Previously, specifying both multichannel and max_channels=3D1 as mount
> > options would leave multichannel enabled, even though it is not
> > meaningful when only one channel is allowed. This led to confusion and
> > inconsistent behavior, as the client would advertise multichannel
> > capability but never establish secondary channels.
> >
> > Fix this by forcing multichannel to false whenever max_channels=3D1,
> > ensuring the mount configuration is consistent and matches user intent.
> > This prevents the client from advertising or attempting multichannel
> > support when it is not possible.
> >
> > Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> > ---
> >  fs/smb/client/fs_context.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> > index 072383899e81..43552b44f613 100644
> > --- a/fs/smb/client/fs_context.c
> > +++ b/fs/smb/client/fs_context.c
> > @@ -1820,6 +1820,13 @@ static int smb3_fs_context_parse_param(struct fs=
_context *fc,
> >                 goto cifs_parse_mount_err;
> >         }
> >
> > +       /*
> > +        * Multichannel is not meaningful if max_channels is 1.
> > +        * Force multichannel to false to ensure consistent configurati=
on.
> > +        */
> > +       if (ctx->multichannel && ctx->max_channels =3D=3D 1)
> > +               ctx->multichannel =3D false;
> > +
> >         return 0;
> >
> >   cifs_parse_mount_err:
> > --
> > 2.43.0
> >
> >
>
>
> --
> Thanks,
>
> Steve
>


--=20
Regards,
Shyam
