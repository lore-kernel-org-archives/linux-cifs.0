Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD81314F70
	for <linux-cifs@vger.kernel.org>; Sat,  8 Nov 2025 04:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762575647; cv=none; b=Hlay2i1JEDlYgo94o1k5N/grOUg2zOR1r1maDU+Iq/oAc/0RhoKTwIu2zoWYQOGvIpP8L8TDpjEQ7HjO4IZ0bqMDYfWPJAhRRqiO1y0d8spRauVbfqs6uc0jrhbbpxXSJ3QLt78kes2pCtTYj19Btv0sSHgIEixsovMP+cfnOhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762575647; c=relaxed/simple;
	bh=STlkqdGrDoo+88AIBJTLv0H6uIR9a0t75UtHcEB7r9Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I9m4ct1NzyZKQVYeTAyRb+9+8/FtGUgTCsKeuLU27F1YbNDKuPhv5ELtOVPu1xhOPkbXiwlbp/8i2yOhjBAHrPgLmwm91sOMcK5hWYEf4rMRS+gh3V6yANAbffd7PBqmOsPPm0TAYvgInJJOjWfva+J28ic5rn49Bol19JE5r54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I436FFOQ; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I436FFOQ"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-880438a762cso9784706d6.1
        for <linux-cifs@vger.kernel.org>; Fri, 07 Nov 2025 20:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762575645; x=1763180445; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=79YNMbH4ZlmdAmN5eLTwL9qoFRrSSAo+DQFW2zIn42k=;
        b=I436FFOQxqHJUbAkjWMjHDmMqjYmaz25xG5nF6v55I7TrDX+DgMszwAVxZvzvZjICd
         IE8ySE++25xZMe2X6k+jp1+U+rSoHd750sWK3KkSpQ0rZTVCHcFaRKZRKfEL/yKrqIsv
         ty1565K7jQa2bUhakP58ucdpvJNP2Kr+zNbDV/Fe5Ti6up6rGQZprc3igmVuM44Ej4zg
         keYx/Qtbt9FL9rhlnbeS1N4XXgzkurfuXV2PUSHcxbG4SFEGpnqCTpvRDeJDw4ttJEyV
         c37Gx9aItNC2dimeSkvGyOzLg1MAe95Nc36oGzS0r7ZJLuVqtTK39Qwfo9P7TAZAafCw
         fcpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762575645; x=1763180445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=79YNMbH4ZlmdAmN5eLTwL9qoFRrSSAo+DQFW2zIn42k=;
        b=B8cAbug7FTofFfn391rh9uaBqnhWkk5baxDT49RI2WS+xwRCqi4tXbITkXPTfiER5G
         +0kVBw8Nsffe4P+4ZLxHZdwC9V9vbeWjgQEPo76BuawdgH1u38JovuVS3OCIUcy5fCHt
         lyM5cc/lH0NM8roPoH3vdoIU1/p1xg5/HJ08CpgkHDhFkAPKa1kkqQL1JOoxMamPkzym
         cWKQeso+LihyhlumLFN9yiwMMcdu8/4QtT5dbR+2LDwKMWz3jCWVVZihd0DKFADwjDvI
         4mnkfIk0tM+mVD9P+4qBhB526SYuWePKZbLvYrAjwW94zRZNAE9OVipvQ5OFJucRI6vm
         2bGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZw09TZ+DNeq+Fp23ZI67ge07+3uyI3nhwrY9Cfkr8baKseRhzxDtmeOhET8cmN+yIuGG2+K/U+dAT@vger.kernel.org
X-Gm-Message-State: AOJu0YwVLvOvF892/TBaNphPckX1JnrOQVUfwgKaZleLBTayt4huTO54
	enSPeKkMUCu3P2ADXsvAanXyglY/o8QR2D6l6Y2Nz7e4bSOfgkPHTkyji3RQmL89++70JU9EM/O
	9m+uHMKzZSnyd6n6YpKgm6D42OYH8cdc=
X-Gm-Gg: ASbGncsU4qMRpbCStmqb9DSgZCu5EbO2B67Ti+b6yyp10ILNQ8qAG3K+HOcmAd5ZYiN
	rcjG+6gnWfpHOE4+7DWdUt/INXVwQegle/dfigRGfptt0F9riskBaDx/1qsIpBiyqTYuBudMa8e
	fMiKPiJs3osEzMmWiOanLRhm4re4m26A1S59pgP2ybSUhwvysSKOUEeVS0xVVsLYsMDDVGBHG10
	kSFXTwZYQZciYpINGM3P108Jmc/Ly5K2aj90YEdBj383UUDIkS6o4lj+UZzVq4bLW2R2JnlO4pp
	ZZkhRZIJINq65OQvdO08mERRL51gqTPNERCQ4DbRFjSwyDH+BwUYAwF0yeexMK4obiExSYKdj5E
	8ZgdE+gShwWlwCatE3TW74fto0u2AbJXURJ5S+YHsQD6ofGO1wQfb5ywe2R7PsMWfT58HR6LY/v
	IlKB2mKJJW/g==
X-Google-Smtp-Source: AGHT+IEzcID5f7dTHllPGe4SjNba4i4Vc1aIbdetPBVm+QKYnxiRnnGjP/XQpUxcvMY4nnNYoSNmVWJtT/ajwC5+5Ew=
X-Received: by 2002:ad4:5e8a:0:b0:880:54eb:f66d with SMTP id
 6a1803df08f44-882385f19e3mr22004096d6.30.1762575644736; Fri, 07 Nov 2025
 20:20:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251107215953.4190096-1-henrique.carvalho@suse.com>
 <CAH2r5mt979CqEHa8wTEV3U+qCVnBqB2N7fCYynQqE2=214Cy7A@mail.gmail.com> <CANT5p=rqcPr86R4Dz3jXaHY8w2M9JxSqUcHMg1fjegNp8Sza+w@mail.gmail.com>
In-Reply-To: <CANT5p=rqcPr86R4Dz3jXaHY8w2M9JxSqUcHMg1fjegNp8Sza+w@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 7 Nov 2025 22:20:33 -0600
X-Gm-Features: AWmQ_bkFvTiWNWyu2oj9AdttM8t2chhcXypIPJevh32JjtEFas2fxeqSi4wlKpk
Message-ID: <CAH2r5mt9RHWBYLj_fLLWjfW21KQQqJkOeepFaDcEZpgf-5Zxbg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix cifs_pick_channel when channel needs reconnect
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, sfrench@samba.org, sprasad@microsoft.com, 
	pc@manguebit.org, ronniesahlberg@gmail.com, tom@talpey.com, 
	bharathsm@microsoft.com, ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 7, 2025 at 10:11=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Sat, Nov 8, 2025 at 4:46=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
> >
> > merged into cifs-2.6.git for-next pending additional review and testing
> >
> > On Fri, Nov 7, 2025 at 4:03=E2=80=AFPM Henrique Carvalho
> > <henrique.carvalho@suse.com> wrote:
> > >
> > > cifs_pick_channel iterates candidate channels using cur. The
> > > reconnect-state test mistakenly used a different variable.
> > >
> > > This checked the wrong slot and would cause us to skip a healthy chan=
nel
> > > and to dispatch on one that needs reconnect, occasionally failing
> > > operations when a channel was down.
> > >
> > > Fix by replacing for the correct variable.
> > >
> > > Fixes: fc43a8ac396d ("cifs: cifs_pick_channel should try selecting ac=
tive channels")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> > > ---
> > >  fs/smb/client/transport.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> > > index 051cd9dbba13..915cedde5d66 100644
> > > --- a/fs/smb/client/transport.c
> > > +++ b/fs/smb/client/transport.c
> > > @@ -830,7 +830,7 @@ struct TCP_Server_Info *cifs_pick_channel(struct =
cifs_ses *ses)
> > >                 if (!server || server->terminate)
> > >                         continue;
> > >
> > > -               if (CIFS_CHAN_NEEDS_RECONNECT(ses, i))
> > > +               if (CIFS_CHAN_NEEDS_RECONNECT(ses, cur))
> > >                         continue;
> > >
> > >                 /*
> > > --
> > > 2.50.1
> > >
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve
> >
>
> Good spot. I think reordering of patches may have caused this to regress.
> Changes look good to me. Please add my RB and CC stable.

Done


--=20
Thanks,

Steve
