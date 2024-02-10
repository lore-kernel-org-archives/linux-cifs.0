Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F24F5DF32
	for <linux-cifs@vger.kernel.org>; Sat, 10 Feb 2024 19:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707592133; cv=none; b=FrZwiPRBhyCnYlORFhQVhY2MIf0gte0ZzTN1gzhKewfZz6bziDzGjz+OfbZ1DS3kjNo/iyav3y+RzICI3RVe1A/HjRgtvkcKvzudoFPasQGZ0LRlWrxjmv7VssGDMJUl/8zE6plhWsS9gYLlLtl/splCh1mvzdkds1Jp1Q4pJWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707592133; c=relaxed/simple;
	bh=TirlQcVtEDr93tEPCdcNjnMioZ8E0xVGRmP9wcJcR3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m2LFckLXzVwV7czVh4CYOtpvc/G+kQvOS4Pzy9nrsXVJ/zJe4kpQMzSSVf38eyAA9J3fdn4AgV1b+pb8Xx0sVe9yzBubYquTRCC3T5aAbkvRQPuZsSI5Bh9MS+M1MqzysSYHtf2cYuetKJODa/BSFMsLalA1bS7+zvd4N9fJP1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kPpYA8gX; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kPpYA8gX"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2d094bc2244so22394371fa.1
        for <linux-cifs@vger.kernel.org>; Sat, 10 Feb 2024 11:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707592129; x=1708196929; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y4fBoOIBnRdPjE4jrQ++UGp220aNqdNsKUjaGSdi2a4=;
        b=kPpYA8gXKshTkURWVUkKhjVb6Ga4mSvS4kvg5rJzTPvvEmhm7dNMxt5DIFNL1tF+6Y
         KhxxWZiSV/xOO/lj/roF3V3gk+XtU6wD0EWPH3j3VkTQ6EPlQzGGQcenJ3FvXcpdiTud
         VQmS5qg7dNsIQq1U1+QjvKqBR+cZgwRReAD5QtWEvpdkC3GtgC1mM0rWixhuWxaSB+Xv
         rKndKESXpD/KzJT4+ySwy8lzS9jJvI5ldJwrlkGIQog1dR4e/p/D+pHFNhCFXUTRI9x4
         HTobTrjnTUULEwANnonwBpLS+4vWR575/mY1qot36RIUlhb/n2wgrP4CXHLeFMa1PWmN
         j3AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707592129; x=1708196929;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y4fBoOIBnRdPjE4jrQ++UGp220aNqdNsKUjaGSdi2a4=;
        b=EJivAhmKBq/gEmNyMv2M6F9OzgYZ5AqO0z/B8RlGO0Uy3AkNaR9qeFwAd/qgrQzt3L
         Z5IhcPXDN/cdIZe1C46aBuDMqgYW+f+7YKIS5AWzIp3bEqZgUhAZlOVMjdXaAtIJPaJD
         it4qGgpP4EOUGcouNjffu7osyx9oI3eaxh/tJLLZxM8pVs6j/dbF1rnlDUT0/t2QSsdv
         2AJ6zgXFrfLRc7dWEhzS7zc+bQ8Ekh3fBlSCnUMgCshdkQCcT4rl9I2Y8OpJNG1DV05M
         z4xd6y8wOypUoq8r+v8Kjz2em+obSFVP3PjBzRb0KDv4sYnGfcWXeeIA9QfTBkZ2qpzk
         nhHQ==
X-Gm-Message-State: AOJu0YwHINAA+cjjqib0xnkMdJeNe+kISYMyJZ43131AkJFiMtH/8Rub
	qb/uiDnwarRKmSdbwv5PFbJ4+IpkHrzZEtvMXCvgP/nfBc+V8lkakMTc96cVP9b/6IOGNGyAEIR
	q9maHUc3gYNKq5ZnPmZ5to08zraM=
X-Google-Smtp-Source: AGHT+IFeW2ag5Br+6/mZmc7JaGIQ5kBtyiC90+uRkR58Ek23+Ouh4839sW8k6jtZnyLzKKMQXcyJTDOl/lcEZvIF6Nw=
X-Received: by 2002:a2e:b0f7:0:b0:2d0:aafa:6f7e with SMTP id
 h23-20020a2eb0f7000000b002d0aafa6f7emr1621944ljl.39.1707592129177; Sat, 10
 Feb 2024 11:08:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240209112542.55690-1-sprasad@microsoft.com> <CAH2r5muugdPoB1O0+PdPZcm2WFbL=VWS+t6OqNCpeUy2gyVVeA@mail.gmail.com>
 <CANT5p=q4PH-YPpabFrUjkUSVV-_stcd_upJQosJCHvji=a9Qog@mail.gmail.com>
In-Reply-To: <CANT5p=q4PH-YPpabFrUjkUSVV-_stcd_upJQosJCHvji=a9Qog@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 10 Feb 2024 13:08:37 -0600
Message-ID: <CAH2r5mvPMSmTSgnph+NOkgrj76-m_t3xFXeDXvzPihDv+jH7QQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: update the same create_guid on replay
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com, 
	tom@talpey.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="00000000000047fe0c06110bc6f7"

--00000000000047fe0c06110bc6f7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated patch attached - rebased to work around Paulo's change and
removed the update to smb2inode.c compounding due to dependency on a
later patch, and tentatively merged to cifs-2.6.git for-next pending
testing

On Sat, Feb 10, 2024 at 10:42=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail=
.com> wrote:
>
> On Sat, Feb 10, 2024 at 11:52=E2=80=AFAM Steve French <smfrench@gmail.com=
> wrote:
> >
> > It needed a small rebase to work around one of Paulo's patches which
> > it depended on (which is for 6.9-rc) but was wondering if you want
> > this patch in before 6.9 because its change to smb2_compound_op below
> > has a dependency on another patch - can that change be safely removed?
> >
> It will be good to have this in 6.8-rc4, if it will be accepted. It's
> the same small change made in several places.
> It avoids a possible handle leak on the server.
>
> > replay_again:
> >         /* reinitialize for possible replay */
> >         flags =3D 0;
> >         oplock =3D SMB2_OPLOCK_LEVEL_NONE;
> >         num_rqst =3D 0;
> >         server =3D cifs_pick_channel(ses);
> >         oparms->replay =3D !!(retries);
> >
> > On Fri, Feb 9, 2024 at 5:25=E2=80=AFAM <nspmangalore@gmail.com> wrote:
> > >
> > > From: Shyam Prasad N <sprasad@microsoft.com>
> > >
> > > File open requests made to the server contain a
> > > CreateGuid, which is used by the server to identify
> > > the open request. If the same request needs to be
> > > replayed, it needs to be sent with the same CreateGuid
> > > in the durable handle v2 context.
> > >
> > > Without doing so, we could end up leaking handles on
> > > the server when:
> > > 1. multichannel is used AND
> > > 2. connection goes down, but not for all channels
> > >
> > > This is because the replayed open request would have a
> > > new CreateGuid and the server will treat this as a new
> > > request and open a new handle.
> > >
> > > This change fixes this by reusing the existing create_guid
> > > stored in the cached fid struct.
> > >
> > > REF: MS-SMB2 4.9 Replay Create Request on an Alternate Channel
> > >
> > > Fixes: 4f1fffa23769 ("cifs: commands that are retried should have rep=
lay flag set")
> > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > ---
> > >  fs/smb/client/cached_dir.c |  1 +
> > >  fs/smb/client/cifsglob.h   |  1 +
> > >  fs/smb/client/smb2inode.c  |  1 +
> > >  fs/smb/client/smb2ops.c    |  4 ++++
> > >  fs/smb/client/smb2pdu.c    | 10 ++++++++--
> > >  5 files changed, 15 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> > > index 1daeb5714faa..3de5047a7ff9 100644
> > > --- a/fs/smb/client/cached_dir.c
> > > +++ b/fs/smb/client/cached_dir.c
> > > @@ -242,6 +242,7 @@ int open_cached_dir(unsigned int xid, struct cifs=
_tcon *tcon,
> > >                 .desired_access =3D  FILE_READ_DATA | FILE_READ_ATTRI=
BUTES,
> > >                 .disposition =3D FILE_OPEN,
> > >                 .fid =3D pfid,
> > > +               .replay =3D !!(retries),
> > >         };
> > >
> > >         rc =3D SMB2_open_init(tcon, server,
> > > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > > index cac10f8e17e4..efab4769de4e 100644
> > > --- a/fs/smb/client/cifsglob.h
> > > +++ b/fs/smb/client/cifsglob.h
> > > @@ -1373,6 +1373,7 @@ struct cifs_open_parms {
> > >         struct cifs_fid *fid;
> > >         umode_t mode;
> > >         bool reconnect:1;
> > > +       bool replay:1; /* indicates that this open is for a replay */
> > >         struct kvec *ea_cctx;
> > >  };
> > >
> > > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> > > index 63485078a6df..22bd01e7bf6e 100644
> > > --- a/fs/smb/client/smb2inode.c
> > > +++ b/fs/smb/client/smb2inode.c
> > > @@ -203,6 +203,7 @@ static int smb2_compound_op(const unsigned int xi=
d, struct cifs_tcon *tcon,
> > >         oplock =3D SMB2_OPLOCK_LEVEL_NONE;
> > >         num_rqst =3D 0;
> > >         server =3D cifs_pick_channel(ses);
> > > +       oparms->replay =3D !!(retries);
> > >
> > >         vars =3D kzalloc(sizeof(*vars), GFP_ATOMIC);
> > >         if (vars =3D=3D NULL)
> > > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > > index 8d674aef8dd9..c0da1935b0bd 100644
> > > --- a/fs/smb/client/smb2ops.c
> > > +++ b/fs/smb/client/smb2ops.c
> > > @@ -1205,6 +1205,7 @@ smb2_set_ea(const unsigned int xid, struct cifs=
_tcon *tcon,
> > >                 .disposition =3D FILE_OPEN,
> > >                 .create_options =3D cifs_create_options(cifs_sb, 0),
> > >                 .fid =3D &fid,
> > > +               .replay =3D !!(retries),
> > >         };
> > >
> > >         rc =3D SMB2_open_init(tcon, server,
> > > @@ -1570,6 +1571,7 @@ smb2_ioctl_query_info(const unsigned int xid,
> > >                 .disposition =3D FILE_OPEN,
> > >                 .create_options =3D cifs_create_options(cifs_sb, crea=
te_options),
> > >                 .fid =3D &fid,
> > > +               .replay =3D !!(retries),
> > >         };
> > >
> > >         if (qi.flags & PASSTHRU_FSCTL) {
> > > @@ -2296,6 +2298,7 @@ smb2_query_dir_first(const unsigned int xid, st=
ruct cifs_tcon *tcon,
> > >                 .disposition =3D FILE_OPEN,
> > >                 .create_options =3D cifs_create_options(cifs_sb, 0),
> > >                 .fid =3D fid,
> > > +               .replay =3D !!(retries),
> > >         };
> > >
> > >         rc =3D SMB2_open_init(tcon, server,
> > > @@ -2682,6 +2685,7 @@ smb2_query_info_compound(const unsigned int xid=
, struct cifs_tcon *tcon,
> > >                 .disposition =3D FILE_OPEN,
> > >                 .create_options =3D cifs_create_options(cifs_sb, 0),
> > >                 .fid =3D &fid,
> > > +               .replay =3D !!(retries),
> > >         };
> > >
> > >         rc =3D SMB2_open_init(tcon, server,
> > > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> > > index 2ecc5f210329..1ce9be3a7ca7 100644
> > > --- a/fs/smb/client/smb2pdu.c
> > > +++ b/fs/smb/client/smb2pdu.c
> > > @@ -2406,8 +2406,13 @@ create_durable_v2_buf(struct cifs_open_parms *=
oparms)
> > >          */
> > >         buf->dcontext.Timeout =3D cpu_to_le32(oparms->tcon->handle_ti=
meout);
> > >         buf->dcontext.Flags =3D cpu_to_le32(SMB2_DHANDLE_FLAG_PERSIST=
ENT);
> > > -       generate_random_uuid(buf->dcontext.CreateGuid);
> > > -       memcpy(pfid->create_guid, buf->dcontext.CreateGuid, 16);
> > > +
> > > +       /* for replay, we should not overwrite the existing create gu=
id */
> > > +       if (!oparms->replay) {
> > > +               generate_random_uuid(buf->dcontext.CreateGuid);
> > > +               memcpy(pfid->create_guid, buf->dcontext.CreateGuid, 1=
6);
> > > +       } else
> > > +               memcpy(buf->dcontext.CreateGuid, pfid->create_guid, 1=
6);
> > >
> > >         /* SMB2_CREATE_DURABLE_HANDLE_REQUEST is "DH2Q" */
> > >         buf->Name[0] =3D 'D';
> > > @@ -3156,6 +3161,7 @@ SMB2_open(const unsigned int xid, struct cifs_o=
pen_parms *oparms, __le16 *path,
> > >         /* reinitialize for possible replay */
> > >         flags =3D 0;
> > >         server =3D cifs_pick_channel(ses);
> > > +       oparms->replay =3D !!(retries);
> > >
> > >         cifs_dbg(FYI, "create/open\n");
> > >         if (!ses || !server)
> > > --
> > > 2.34.1
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Regards,
> Shyam



--=20
Thanks,

Steve

--00000000000047fe0c06110bc6f7
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-update-the-same-create_guid-on-replay.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-update-the-same-create_guid-on-replay.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lsgg8vr10>
X-Attachment-Id: f_lsgg8vr10

RnJvbSA4YjM5Y2ZhNGI5NzA2NzRhNzcwZjZmNGMzN2UyZDAwYzgzNTlkYWViIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBGcmksIDkgRmViIDIwMjQgMTE6MjU6NDIgKzAwMDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiB1cGRhdGUgdGhlIHNhbWUgY3JlYXRlX2d1aWQgb24gcmVwbGF5CgpGaWxlIG9wZW4gcmVx
dWVzdHMgbWFkZSB0byB0aGUgc2VydmVyIGNvbnRhaW4gYQpDcmVhdGVHdWlkLCB3aGljaCBpcyB1
c2VkIGJ5IHRoZSBzZXJ2ZXIgdG8gaWRlbnRpZnkKdGhlIG9wZW4gcmVxdWVzdC4gSWYgdGhlIHNh
bWUgcmVxdWVzdCBuZWVkcyB0byBiZQpyZXBsYXllZCwgaXQgbmVlZHMgdG8gYmUgc2VudCB3aXRo
IHRoZSBzYW1lIENyZWF0ZUd1aWQKaW4gdGhlIGR1cmFibGUgaGFuZGxlIHYyIGNvbnRleHQuCgpX
aXRob3V0IGRvaW5nIHNvLCB3ZSBjb3VsZCBlbmQgdXAgbGVha2luZyBoYW5kbGVzIG9uCnRoZSBz
ZXJ2ZXIgd2hlbjoKMS4gbXVsdGljaGFubmVsIGlzIHVzZWQgQU5ECjIuIGNvbm5lY3Rpb24gZ29l
cyBkb3duLCBidXQgbm90IGZvciBhbGwgY2hhbm5lbHMKClRoaXMgaXMgYmVjYXVzZSB0aGUgcmVw
bGF5ZWQgb3BlbiByZXF1ZXN0IHdvdWxkIGhhdmUgYQpuZXcgQ3JlYXRlR3VpZCBhbmQgdGhlIHNl
cnZlciB3aWxsIHRyZWF0IHRoaXMgYXMgYSBuZXcKcmVxdWVzdCBhbmQgb3BlbiBhIG5ldyBoYW5k
bGUuCgpUaGlzIGNoYW5nZSBmaXhlcyB0aGlzIGJ5IHJldXNpbmcgdGhlIGV4aXN0aW5nIGNyZWF0
ZV9ndWlkCnN0b3JlZCBpbiB0aGUgY2FjaGVkIGZpZCBzdHJ1Y3QuCgpSRUY6IE1TLVNNQjIgNC45
IFJlcGxheSBDcmVhdGUgUmVxdWVzdCBvbiBhbiBBbHRlcm5hdGUgQ2hhbm5lbAoKRml4ZXM6IDRm
MWZmZmEyMzc2OSAoImNpZnM6IGNvbW1hbmRzIHRoYXQgYXJlIHJldHJpZWQgc2hvdWxkIGhhdmUg
cmVwbGF5IGZsYWcgc2V0IikKU2lnbmVkLW9mZi1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRA
bWljcm9zb2Z0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNy
b3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5jIHwgIDEgKwogZnMvc21i
L2NsaWVudC9jaWZzZ2xvYi5oICAgfCAgMSArCiBmcy9zbWIvY2xpZW50L3NtYjJpbm9kZS5jICB8
ICAxICsKIGZzL3NtYi9jbGllbnQvc21iMm9wcy5jICAgIHwgIDQgKysrKwogZnMvc21iL2NsaWVu
dC9zbWIycGR1LmMgICAgfCAxMCArKysrKysrKy0tCiA1IGZpbGVzIGNoYW5nZWQsIDE1IGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jYWNo
ZWRfZGlyLmMgYi9mcy9zbWIvY2xpZW50L2NhY2hlZF9kaXIuYwppbmRleCAxZGFlYjU3MTRmYWEu
LjNkZTUwNDdhN2ZmOSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jYWNoZWRfZGlyLmMKKysr
IGIvZnMvc21iL2NsaWVudC9jYWNoZWRfZGlyLmMKQEAgLTI0Miw2ICsyNDIsNyBAQCBpbnQgb3Bl
bl9jYWNoZWRfZGlyKHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJ
CS5kZXNpcmVkX2FjY2VzcyA9ICBGSUxFX1JFQURfREFUQSB8IEZJTEVfUkVBRF9BVFRSSUJVVEVT
LAogCQkuZGlzcG9zaXRpb24gPSBGSUxFX09QRU4sCiAJCS5maWQgPSBwZmlkLAorCQkucmVwbGF5
ID0gISEocmV0cmllcyksCiAJfTsKIAogCXJjID0gU01CMl9vcGVuX2luaXQodGNvbiwgc2VydmVy
LApkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oIGIvZnMvc21iL2NsaWVudC9j
aWZzZ2xvYi5oCmluZGV4IGM4NmE3MmM5ZDllYy4uNTNjNzVjZmIzM2FiIDEwMDY0NAotLS0gYS9m
cy9zbWIvY2xpZW50L2NpZnNnbG9iLmgKKysrIGIvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oCkBA
IC0xMzc4LDYgKzEzNzgsNyBAQCBzdHJ1Y3QgY2lmc19vcGVuX3Bhcm1zIHsKIAlzdHJ1Y3QgY2lm
c19maWQgKmZpZDsKIAl1bW9kZV90IG1vZGU7CiAJYm9vbCByZWNvbm5lY3Q6MTsKKwlib29sIHJl
cGxheToxOyAvKiBpbmRpY2F0ZXMgdGhhdCB0aGlzIG9wZW4gaXMgZm9yIGEgcmVwbGF5ICovCiB9
OwogCiBzdHJ1Y3QgY2lmc19maWQgewpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9zbWIyb3Bz
LmMgYi9mcy9zbWIvY2xpZW50L3NtYjJvcHMuYwppbmRleCA3NTVmMWM2NmI1NzMuLjZiM2MzODRl
YWQwZCAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9zbWIyb3BzLmMKKysrIGIvZnMvc21iL2Ns
aWVudC9zbWIyb3BzLmMKQEAgLTEyMDQsNiArMTIwNCw3IEBAIHNtYjJfc2V0X2VhKGNvbnN0IHVu
c2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCS5kaXNwb3NpdGlvbiA9
IEZJTEVfT1BFTiwKIAkJLmNyZWF0ZV9vcHRpb25zID0gY2lmc19jcmVhdGVfb3B0aW9ucyhjaWZz
X3NiLCAwKSwKIAkJLmZpZCA9ICZmaWQsCisJCS5yZXBsYXkgPSAhIShyZXRyaWVzKSwKIAl9Owog
CiAJcmMgPSBTTUIyX29wZW5faW5pdCh0Y29uLCBzZXJ2ZXIsCkBAIC0xNTY5LDYgKzE1NzAsNyBA
QCBzbWIyX2lvY3RsX3F1ZXJ5X2luZm8oY29uc3QgdW5zaWduZWQgaW50IHhpZCwKIAkJLmRpc3Bv
c2l0aW9uID0gRklMRV9PUEVOLAogCQkuY3JlYXRlX29wdGlvbnMgPSBjaWZzX2NyZWF0ZV9vcHRp
b25zKGNpZnNfc2IsIGNyZWF0ZV9vcHRpb25zKSwKIAkJLmZpZCA9ICZmaWQsCisJCS5yZXBsYXkg
PSAhIShyZXRyaWVzKSwKIAl9OwogCiAJaWYgKHFpLmZsYWdzICYgUEFTU1RIUlVfRlNDVEwpIHsK
QEAgLTIyOTUsNiArMjI5Nyw3IEBAIHNtYjJfcXVlcnlfZGlyX2ZpcnN0KGNvbnN0IHVuc2lnbmVk
IGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCS5kaXNwb3NpdGlvbiA9IEZJTEVf
T1BFTiwKIAkJLmNyZWF0ZV9vcHRpb25zID0gY2lmc19jcmVhdGVfb3B0aW9ucyhjaWZzX3NiLCAw
KSwKIAkJLmZpZCA9IGZpZCwKKwkJLnJlcGxheSA9ICEhKHJldHJpZXMpLAogCX07CiAKIAlyYyA9
IFNNQjJfb3Blbl9pbml0KHRjb24sIHNlcnZlciwKQEAgLTI2ODEsNiArMjY4NCw3IEBAIHNtYjJf
cXVlcnlfaW5mb19jb21wb3VuZChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190
Y29uICp0Y29uLAogCQkuZGlzcG9zaXRpb24gPSBGSUxFX09QRU4sCiAJCS5jcmVhdGVfb3B0aW9u
cyA9IGNpZnNfY3JlYXRlX29wdGlvbnMoY2lmc19zYiwgMCksCiAJCS5maWQgPSAmZmlkLAorCQku
cmVwbGF5ID0gISEocmV0cmllcyksCiAJfTsKIAogCXJjID0gU01CMl9vcGVuX2luaXQodGNvbiwg
c2VydmVyLApkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9zbWIycGR1LmMgYi9mcy9zbWIvY2xp
ZW50L3NtYjJwZHUuYwppbmRleCA0MDg1Y2UyN2ZkMzguLjYwOGVlMDU0OTFlMiAxMDA2NDQKLS0t
IGEvZnMvc21iL2NsaWVudC9zbWIycGR1LmMKKysrIGIvZnMvc21iL2NsaWVudC9zbWIycGR1LmMK
QEAgLTI0MDQsOCArMjQwNCwxMyBAQCBjcmVhdGVfZHVyYWJsZV92Ml9idWYoc3RydWN0IGNpZnNf
b3Blbl9wYXJtcyAqb3Bhcm1zKQogCSAqLwogCWJ1Zi0+ZGNvbnRleHQuVGltZW91dCA9IGNwdV90
b19sZTMyKG9wYXJtcy0+dGNvbi0+aGFuZGxlX3RpbWVvdXQpOwogCWJ1Zi0+ZGNvbnRleHQuRmxh
Z3MgPSBjcHVfdG9fbGUzMihTTUIyX0RIQU5ETEVfRkxBR19QRVJTSVNURU5UKTsKLQlnZW5lcmF0
ZV9yYW5kb21fdXVpZChidWYtPmRjb250ZXh0LkNyZWF0ZUd1aWQpOwotCW1lbWNweShwZmlkLT5j
cmVhdGVfZ3VpZCwgYnVmLT5kY29udGV4dC5DcmVhdGVHdWlkLCAxNik7CisKKwkvKiBmb3IgcmVw
bGF5LCB3ZSBzaG91bGQgbm90IG92ZXJ3cml0ZSB0aGUgZXhpc3RpbmcgY3JlYXRlIGd1aWQgKi8K
KwlpZiAoIW9wYXJtcy0+cmVwbGF5KSB7CisJCWdlbmVyYXRlX3JhbmRvbV91dWlkKGJ1Zi0+ZGNv
bnRleHQuQ3JlYXRlR3VpZCk7CisJCW1lbWNweShwZmlkLT5jcmVhdGVfZ3VpZCwgYnVmLT5kY29u
dGV4dC5DcmVhdGVHdWlkLCAxNik7CisJfSBlbHNlCisJCW1lbWNweShidWYtPmRjb250ZXh0LkNy
ZWF0ZUd1aWQsIHBmaWQtPmNyZWF0ZV9ndWlkLCAxNik7CiAKIAkvKiBTTUIyX0NSRUFURV9EVVJB
QkxFX0hBTkRMRV9SRVFVRVNUIGlzICJESDJRIiAqLwogCWJ1Zi0+TmFtZVswXSA9ICdEJzsKQEAg
LTMxNDIsNiArMzE0Nyw3IEBAIFNNQjJfb3Blbihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1
Y3QgY2lmc19vcGVuX3Bhcm1zICpvcGFybXMsIF9fbGUxNiAqcGF0aCwKIAkvKiByZWluaXRpYWxp
emUgZm9yIHBvc3NpYmxlIHJlcGxheSAqLwogCWZsYWdzID0gMDsKIAlzZXJ2ZXIgPSBjaWZzX3Bp
Y2tfY2hhbm5lbChzZXMpOworCW9wYXJtcy0+cmVwbGF5ID0gISEocmV0cmllcyk7CiAKIAljaWZz
X2RiZyhGWUksICJjcmVhdGUvb3BlblxuIik7CiAJaWYgKCFzZXMgfHwgIXNlcnZlcikKLS0gCjIu
NDAuMQoK
--00000000000047fe0c06110bc6f7--
