Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B531B3931
	for <linux-cifs@vger.kernel.org>; Mon, 23 Dec 2024 18:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734979718; cv=none; b=cBoKHrXTn0AewtlxcaiYnQPNIo72D3MC7dwADacqpPG0T45FBTgZSdwf3BspXsRz5/YeecmWM7JJyP/9EHvofdI+VtV/PRMaW7XzpZt6J9tMdN4y7YKM1qoSdGoM94zmODl89i3kYauJLVLuKEYRXhjKVc9GXyRyun0k7gBsNgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734979718; c=relaxed/simple;
	bh=lDz8EX4H6zOG4s9Nl7Phc1Nq00BSh0cItuw9Pd2UvYg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jKCtR4H6ODW1NTaa5PfWWfIzrVkeYkrGUln+9JO7nr0fWC4yA9Sc7Lo9ekye4eYYpa7jMuZFMbFg2R836T1IV+zxV07itiXvLziMiEOf2HT8ucs5CAOfldCIYRelx61ZbbOcS2KCh2oFrHPrcop4CfYW+QOE//kqtQ6ils6d30w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z7ClUBKv; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z7ClUBKv"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5401bd6ccadso4947747e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 23 Dec 2024 10:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734979715; x=1735584515; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A+bl/WFRtyd9PW/GExhxKvwQA3xwSOw/AY2CegYjTI4=;
        b=Z7ClUBKvlynFf/kgR0HIT4K7lGdzselL7ZlNaxvKwQ+K7HVXNCEFdnjkGQgrshX0b/
         dLgnLkKgzmOoJdY+WYc1Sh7MTV82BBypIYmJNJwTeQRzoiR1DGxXd3dGEsmtebJVJXaO
         SIt80g17t+GvAiu/upX6ekTtf46QKVp4Nu6hh5kTLTTn4W8whZUTRIn7j97iCvDaODTy
         kUGjPoofe6S8o65ION7qkX0bOlX1eyZkhXuYkFtABQkietrcCUZuOVHqdCupyJdKHnX5
         pp7IChh3fS407/ZOSViX7TzE8hJKpgolz7dMAlLfI5ZZC//9yFt4SKJwG9ETuKiy4o0X
         QBug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734979715; x=1735584515;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A+bl/WFRtyd9PW/GExhxKvwQA3xwSOw/AY2CegYjTI4=;
        b=bjt2T7u/u3pCVxZNih8WwkWCDcxl9OIrx28gbi/bFCIXuob1JLUxbqk4rbIbJ12sNN
         JNKeeB6r5wz6h5XTOlNEaLX9wCdVYBf6LZVFuhQdjVBmw3YoPwhAfG8NcCxjtMvoIjb2
         IUY16nvaA8IbUzHsx16WJl4Ri44Tc6eVoHDamwpu+MpvN/B9J2O1pQz61s+Dv+6+r8h0
         F0GUDlGUT0Y0Ut1m8wxgzL/akkYKD1J5ftZuR2abx1ZGpDsxTSXW4ymjLHi01sB03NCX
         QHN3XWn8pWyGHLxkm16AcKXxRs+yfvIZzs4M5XudgIJH6XmIRuaiK6a5kesWAbIL+Ppb
         G0iw==
X-Forwarded-Encrypted: i=1; AJvYcCU7ADLA0a52OcdCkKzIbRw2QQlKmSts68zzA9YEUg6CqouBctF7wqq5CzsHLFEaw4t2u1Vbwipo8kxs@vger.kernel.org
X-Gm-Message-State: AOJu0Yxeb/kJSdxY7J96+X+JsOhpbBq82iiJrdmUpVKzBD4M/LkVUqM1
	g4U4xndrGmQlsusb3VAVv+vcOpm8vsjdYQVTYaxvJAHpmkhu9yLyFFRcD7mrkN92yLMun/se8aj
	HnB/EI+8uM7DXlOPZzbb9F2+OhGc=
X-Gm-Gg: ASbGncu0E6CNeR16Otgas0/OG2RDUB5O5h3/NuoyOUiq4jdQnxTgxo5vxpdeb4Jg/Ph
	T4/YcxXDCHyko8Mx39Mgy9pbVJyeK/CjYw8GU
X-Google-Smtp-Source: AGHT+IGZbO/KS7UhR6qZjs5U//PiHO2rjj20dV4/iwboLQGT2r5DwYVtSKipnM2YHrdnl59aaYWK3kYFzSkDQAYbfbA=
X-Received: by 2002:a05:6512:334f:b0:542:29a6:db5a with SMTP id
 2adb3069b0e04-54229a6db7amr3650847e87.35.1734979714276; Mon, 23 Dec 2024
 10:48:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241216183148.4291-1-bharathsm@microsoft.com>
 <CAH2r5mumh1xU8zAdE9sqmgGN11sY=HedD-PpdqCvR3BTod1NwQ@mail.gmail.com>
 <CANT5p=rYjgbteSBRuZFfXYwC-g6QLMG20250RzO9Es8GZPeL2g@mail.gmail.com>
 <Z2SijUfZWp37R2Do@haley.home.arpa> <CAGypqWxW-tG9omw7+s=DK89KPs+RFDFneYUKa2ZqjZ0yJkjbAw@mail.gmail.com>
In-Reply-To: <CAGypqWxW-tG9omw7+s=DK89KPs+RFDFneYUKa2ZqjZ0yJkjbAw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 23 Dec 2024 12:48:23 -0600
Message-ID: <CAH2r5mud1DHfjMa0UziTyy5KX0+HGnBC8RcSD1HPhcvDcV2WCg@mail.gmail.com>
Subject: Re: [PATCH] smb: enable reuse of deferred file handles for write operations
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, linux-cifs@vger.kernel.org, pc@manguebit.com, 
	sprasad@microsoft.com, tom@talpey.com, ronniesahlberg@gmail.com, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged into cifs-2.6.git for-next pending more testing

On Mon, Dec 23, 2024 at 2:12=E2=80=AFAM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> Thanks Shyam and Paul Aurich for reviewing and sharing comments.!
> I have attached an updated patch.
>
> On Fri, Dec 20, 2024 at 4:17=E2=80=AFAM Paul Aurich <paul@darkrain42.org>=
 wrote:
> >
> > On 2024-12-19 15:03:48 +0530, Shyam Prasad N wrote:
> > >On Tue, Dec 17, 2024 at 2:22=E2=80=AFAM Steve French <smfrench@gmail.c=
om> wrote:
> > >>
> > >> merged into cifs-2.6.git for-next pending review and more testing
> > >>
> > >> On Mon, Dec 16, 2024 at 12:36=E2=80=AFPM Bharath SM <bharathsm.hsk@g=
mail.com> wrote:
> > >> >
> > >> > Previously, deferred file handles were reused only for read
> > >> > operations, this commit extends to reusing deferred handles
> > >> > for write operations.
> > >> >
> > >> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > >> > ---
> > >> >  fs/smb/client/file.c | 6 +++++-
> > >> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > >> >
> > >> > diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> > >> > index a58a3333ecc3..98deff1de74c 100644
> > >> > --- a/fs/smb/client/file.c
> > >> > +++ b/fs/smb/client/file.c
> > >> > @@ -990,7 +990,11 @@ int cifs_open(struct inode *inode, struct fil=
e *file)
> > >> >         }
> > >> >
> > >> >         /* Get the cached handle as SMB2 close is deferred */
> > >> > -       rc =3D cifs_get_readable_path(tcon, full_path, &cfile);
> > >> > +       if (OPEN_FMODE(file->f_flags) & FMODE_WRITE) {
> > >> > +               rc =3D cifs_get_writable_path(tcon, full_path, FIN=
D_WR_ANY, &cfile);
> > >
> > >Wondering if FIND_WR_ANY is okay for all use cases?
> > >Specifically, I'm checking where FIND_WR_FSUID_ONLY is relevant.
> > >@Steve French Is this for multiuser mounts? I don't think so, since
> > >multiuser mounts come with their own tcon, and we search writable
> > >files in our tcon's open list.
> >
> > I think this should be FIND_WR_FSUID_ONLY, yeah.  (IMHO, that should be=
 the
> > default, and FIND_WR_ANY should be renamed something indicating it shou=
ld only
> > be used in specific situations and it's probably not what the caller wa=
nts.)
> >
> > I have a series I need to resurrect and polish that fixes a few problem=
s along
> > these lines, but it doesn't touch the 'writable file' path.
> >
> > >> > +       } else {
> > >> > +               rc =3D cifs_get_readable_path(tcon, full_path, &cf=
ile);
> > >> > +       }
> > >> >         if (rc =3D=3D 0) {
> > >> >                 if (file->f_flags =3D=3D cfile->f_flags) {
> > >> >                         file->private_data =3D cfile;
> > >> > --
> > >> > 2.43.0
> > >> >
> > >> >
> > >>
> > >>
> > >> --
> > >> Thanks,
> > >>
> > >> Steve
> > >>
> > >Other than that one thing to look at, the changes look good to me.
> > >
> > >--
> > >Regards,
> > >Shyam
> >
> > ~Paul
> >



--=20
Thanks,

Steve
