Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705305C8E3
	for <linux-cifs@vger.kernel.org>; Sat, 10 Feb 2024 16:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707583381; cv=none; b=ocM5xp4NeCHdapOvS4nd8EnYoYeWhtNo09eYnpgdo1nAzA5VuxE6XrGZE35Q7UXeUtrfZfMr0uA92nlU/ihpHgFT8m1c/bPgM/QLUVmUwoCFO9eDt8NKTjVf6QOFN23DMRJr+p6judi3KyhRYGaUwuzJSey/L7Rxomwn4T0h/eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707583381; c=relaxed/simple;
	bh=e+dXZAVWrRrDRcBhm5KNKi3/oCvveqggEEozl65FrGE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zyd3eKax3CVzS1mIgOaTJDvXlPombk0EeXBujZgcG8bNeSplbpYQPl51XRJDvLh65PdjEdOBvmY1v/QmF3cDnAkOyAGMo7UTRz4oEt7W+sqh888GTuVBi0YYwZx0Gc8Ew75yAsQOseOKpcPvBkQjmFPfnP5bvPvd1vWJgBAwhAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ksSaY/rj; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ksSaY/rj"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-51182f8590bso498234e87.0
        for <linux-cifs@vger.kernel.org>; Sat, 10 Feb 2024 08:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707583377; x=1708188177; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zGW1VsyhRzl8BCyDv6+dXT3w4YvrPWeNDzT3yNd6cK4=;
        b=ksSaY/rjmdrlgVnZ4Maxo732l8wJMNmEFPEy7CTRTwu4dS3koVVSJYX9KmBgH3w8OE
         t7Ec7Y38hMrv4B5Lb9JB2zEmefOzsCLnlW1ajRELS7oT/jiMEhcxQph7u9XsbGiO1NUZ
         web/OfwzSmdGLNt8pbdskKUvBCi1H0lHaEwrzVivoMG0PNVEBB8+oeovyYXYEOZ6e+x6
         xogaLuVQ7KvGJDYi4fOyqWyX4QujQatPJcHBWOqTom+Lo91qHeOziwPGmR1GEz2j35Ta
         lL8mT4zMSJ/gCvq0pgGei9Ne3wOr2LAzLX3jVpJs99t0dNJEzwd7lZICrcw5fbBBhJS9
         rzeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707583377; x=1708188177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zGW1VsyhRzl8BCyDv6+dXT3w4YvrPWeNDzT3yNd6cK4=;
        b=Orow/A8zcg+Yz6WJrFpkBpHT54Cc351sYMXnYO06KzCs2pondTcDsBcIWun0Pyjb4j
         L+ht1CuXiR28daUuOfsbXTzgf0sDMV1DFY9Mmxsf1CDA0RbrBsxMc2Z+N/q4ke6CAn5c
         b/utU9ikUu8wfTg5Ayunbg5fTaTiCGjGc61STlRX1gXgvYXGWorVLfLa0EQIN47KQ6vY
         yXt111C5NunVwgExqKWPrZ8Whw/x2R5n0xeWOfcs/5Ez9qOdKHtOGnNbKdFG6tvmEnCs
         bag1f092Vk1YY/BHhTwvYDlDBd7Nk81VLjcmJOIOM7BkeJ7usAfdwi3qAtRZNIppIE9P
         pvVw==
X-Gm-Message-State: AOJu0Yx1uRyT0zQn0TPJeLgeFF3zHdmO10OAuWzyIsiMoFGhMso9x1dO
	HgbTeG9wWA9oXZI/k50G/sG/coH9G0hy/QRo5aM0IEGdzJ8ePBC329XDxhiUaknhCa8/Tz8jOFk
	R6j+AkNaIlrT+uYEC2bW+93Q7tZc=
X-Google-Smtp-Source: AGHT+IHO2cMsjZX/fabEtujZE+3+DIAJ1c+1l54+s3ruN7UBMOKGXo1MNHPxvlwJyt/zFVan1ZOcYrpXoPRa/+5oL18=
X-Received: by 2002:ac2:58ed:0:b0:511:4b58:3bfa with SMTP id
 v13-20020ac258ed000000b005114b583bfamr1318206lfo.67.1707583377084; Sat, 10
 Feb 2024 08:42:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240209112542.55690-1-sprasad@microsoft.com> <CAH2r5muugdPoB1O0+PdPZcm2WFbL=VWS+t6OqNCpeUy2gyVVeA@mail.gmail.com>
In-Reply-To: <CAH2r5muugdPoB1O0+PdPZcm2WFbL=VWS+t6OqNCpeUy2gyVVeA@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Sat, 10 Feb 2024 22:12:45 +0530
Message-ID: <CANT5p=q4PH-YPpabFrUjkUSVV-_stcd_upJQosJCHvji=a9Qog@mail.gmail.com>
Subject: Re: [PATCH] cifs: update the same create_guid on replay
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com, 
	tom@talpey.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 10, 2024 at 11:52=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> It needed a small rebase to work around one of Paulo's patches which
> it depended on (which is for 6.9-rc) but was wondering if you want
> this patch in before 6.9 because its change to smb2_compound_op below
> has a dependency on another patch - can that change be safely removed?
>
It will be good to have this in 6.8-rc4, if it will be accepted. It's
the same small change made in several places.
It avoids a possible handle leak on the server.

> replay_again:
>         /* reinitialize for possible replay */
>         flags =3D 0;
>         oplock =3D SMB2_OPLOCK_LEVEL_NONE;
>         num_rqst =3D 0;
>         server =3D cifs_pick_channel(ses);
>         oparms->replay =3D !!(retries);
>
> On Fri, Feb 9, 2024 at 5:25=E2=80=AFAM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > File open requests made to the server contain a
> > CreateGuid, which is used by the server to identify
> > the open request. If the same request needs to be
> > replayed, it needs to be sent with the same CreateGuid
> > in the durable handle v2 context.
> >
> > Without doing so, we could end up leaking handles on
> > the server when:
> > 1. multichannel is used AND
> > 2. connection goes down, but not for all channels
> >
> > This is because the replayed open request would have a
> > new CreateGuid and the server will treat this as a new
> > request and open a new handle.
> >
> > This change fixes this by reusing the existing create_guid
> > stored in the cached fid struct.
> >
> > REF: MS-SMB2 4.9 Replay Create Request on an Alternate Channel
> >
> > Fixes: 4f1fffa23769 ("cifs: commands that are retried should have repla=
y flag set")
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/cached_dir.c |  1 +
> >  fs/smb/client/cifsglob.h   |  1 +
> >  fs/smb/client/smb2inode.c  |  1 +
> >  fs/smb/client/smb2ops.c    |  4 ++++
> >  fs/smb/client/smb2pdu.c    | 10 ++++++++--
> >  5 files changed, 15 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> > index 1daeb5714faa..3de5047a7ff9 100644
> > --- a/fs/smb/client/cached_dir.c
> > +++ b/fs/smb/client/cached_dir.c
> > @@ -242,6 +242,7 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
> >                 .desired_access =3D  FILE_READ_DATA | FILE_READ_ATTRIBU=
TES,
> >                 .disposition =3D FILE_OPEN,
> >                 .fid =3D pfid,
> > +               .replay =3D !!(retries),
> >         };
> >
> >         rc =3D SMB2_open_init(tcon, server,
> > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > index cac10f8e17e4..efab4769de4e 100644
> > --- a/fs/smb/client/cifsglob.h
> > +++ b/fs/smb/client/cifsglob.h
> > @@ -1373,6 +1373,7 @@ struct cifs_open_parms {
> >         struct cifs_fid *fid;
> >         umode_t mode;
> >         bool reconnect:1;
> > +       bool replay:1; /* indicates that this open is for a replay */
> >         struct kvec *ea_cctx;
> >  };
> >
> > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> > index 63485078a6df..22bd01e7bf6e 100644
> > --- a/fs/smb/client/smb2inode.c
> > +++ b/fs/smb/client/smb2inode.c
> > @@ -203,6 +203,7 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
> >         oplock =3D SMB2_OPLOCK_LEVEL_NONE;
> >         num_rqst =3D 0;
> >         server =3D cifs_pick_channel(ses);
> > +       oparms->replay =3D !!(retries);
> >
> >         vars =3D kzalloc(sizeof(*vars), GFP_ATOMIC);
> >         if (vars =3D=3D NULL)
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index 8d674aef8dd9..c0da1935b0bd 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -1205,6 +1205,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_t=
con *tcon,
> >                 .disposition =3D FILE_OPEN,
> >                 .create_options =3D cifs_create_options(cifs_sb, 0),
> >                 .fid =3D &fid,
> > +               .replay =3D !!(retries),
> >         };
> >
> >         rc =3D SMB2_open_init(tcon, server,
> > @@ -1570,6 +1571,7 @@ smb2_ioctl_query_info(const unsigned int xid,
> >                 .disposition =3D FILE_OPEN,
> >                 .create_options =3D cifs_create_options(cifs_sb, create=
_options),
> >                 .fid =3D &fid,
> > +               .replay =3D !!(retries),
> >         };
> >
> >         if (qi.flags & PASSTHRU_FSCTL) {
> > @@ -2296,6 +2298,7 @@ smb2_query_dir_first(const unsigned int xid, stru=
ct cifs_tcon *tcon,
> >                 .disposition =3D FILE_OPEN,
> >                 .create_options =3D cifs_create_options(cifs_sb, 0),
> >                 .fid =3D fid,
> > +               .replay =3D !!(retries),
> >         };
> >
> >         rc =3D SMB2_open_init(tcon, server,
> > @@ -2682,6 +2685,7 @@ smb2_query_info_compound(const unsigned int xid, =
struct cifs_tcon *tcon,
> >                 .disposition =3D FILE_OPEN,
> >                 .create_options =3D cifs_create_options(cifs_sb, 0),
> >                 .fid =3D &fid,
> > +               .replay =3D !!(retries),
> >         };
> >
> >         rc =3D SMB2_open_init(tcon, server,
> > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> > index 2ecc5f210329..1ce9be3a7ca7 100644
> > --- a/fs/smb/client/smb2pdu.c
> > +++ b/fs/smb/client/smb2pdu.c
> > @@ -2406,8 +2406,13 @@ create_durable_v2_buf(struct cifs_open_parms *op=
arms)
> >          */
> >         buf->dcontext.Timeout =3D cpu_to_le32(oparms->tcon->handle_time=
out);
> >         buf->dcontext.Flags =3D cpu_to_le32(SMB2_DHANDLE_FLAG_PERSISTEN=
T);
> > -       generate_random_uuid(buf->dcontext.CreateGuid);
> > -       memcpy(pfid->create_guid, buf->dcontext.CreateGuid, 16);
> > +
> > +       /* for replay, we should not overwrite the existing create guid=
 */
> > +       if (!oparms->replay) {
> > +               generate_random_uuid(buf->dcontext.CreateGuid);
> > +               memcpy(pfid->create_guid, buf->dcontext.CreateGuid, 16)=
;
> > +       } else
> > +               memcpy(buf->dcontext.CreateGuid, pfid->create_guid, 16)=
;
> >
> >         /* SMB2_CREATE_DURABLE_HANDLE_REQUEST is "DH2Q" */
> >         buf->Name[0] =3D 'D';
> > @@ -3156,6 +3161,7 @@ SMB2_open(const unsigned int xid, struct cifs_ope=
n_parms *oparms, __le16 *path,
> >         /* reinitialize for possible replay */
> >         flags =3D 0;
> >         server =3D cifs_pick_channel(ses);
> > +       oparms->replay =3D !!(retries);
> >
> >         cifs_dbg(FYI, "create/open\n");
> >         if (!ses || !server)
> > --
> > 2.34.1
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Regards,
Shyam
