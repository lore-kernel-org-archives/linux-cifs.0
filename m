Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDAF27F01D
	for <linux-cifs@vger.kernel.org>; Wed, 20 Aug 2025 16:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755708155; cv=none; b=sorvQ5VSiKYmf6dL2yAxtZmjewzPbwRHQKQsJsBelJKiT8nrLQ5cLpCnHS2/s3ZJ+PNxhcb9clTuNs1XHJpXA/UFWltM8r9bxwvN9696vSu5nSGvDwooFh4aE2WkPkkdodxeZ2cYG+RlfR2U2gVPz1pNUl36E/f7M5MbGUmVyb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755708155; c=relaxed/simple;
	bh=ranyu9ElWKF1DkrzGI963BiZl5RzZoSj1CR35AMX1qo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MjuNTRup0VrgLFU+yO10wpI9fT+spKPPeb3ImL7s+y/y3Dy3JShzhLeDZT15k/EEhFan7N1E0uBBrclMlWX67KEkbBx4BmpC4xx4kZkWLuZpESe4WA2xcCPJG1wK6bq27RVxQbiMRNhU0/0yKvV1UuBPp9dbyT/oqXsI4/YsBJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VsCYgaS7; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VsCYgaS7"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-70a88de7d4fso1291236d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 20 Aug 2025 09:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755708153; x=1756312953; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G3d2nwi9sN5VUjMQgo7++bKqmajRwd8bLQm7+o5mppY=;
        b=VsCYgaS75q0++WmrWeNwkKn/b4ECGJq853DzsjTvMnrJ+ZRbxm246GPC81v8J+TEiA
         7eco2EBLWPbP3oCT7MaXr25wsyeTPtdKRWUH/Ac3FDE7wx5R18qLx2BPMquXX2O8x4Nx
         yT5W7Z+cBl68fZ2BhS5kMuwP3vAfvrcw+86+cox8QbWJgGVHkilwFlBEI1x5P113cw1L
         3+DrrhbvUROdKK+3Qci8yg02eKGKYdU4hn1HB3axhqzFL4s5Q7GzS0Ag4EAzbaefYYbe
         XZbM6WZus/geIFI7iJ3YeR4BFEFbas1EUlZmWdLryQEp8QqIgpmDMCsU6XyxT2omYgff
         82ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755708153; x=1756312953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G3d2nwi9sN5VUjMQgo7++bKqmajRwd8bLQm7+o5mppY=;
        b=NjK7eudYHa5ZnRgLz3eBPyTm4qftnZSQxb+mC6hHny2tYnnZX1VvmPbmPiYOKVyN33
         Xu8tOdNtOaQ6zdHV641gDum+IMZBiiVyTQ6VNRlpULo2LtKd07cVr4S62eKUD1BrWujl
         kfkxnrdTNFTWx+dhCyiVPqvig58Yaht5e/SSOweoB8Bi7L0gkpmIDExelsdmwYMmZwb6
         BOz8bN4fCOPbbZptfKswC2IdNxJpoDLZoM1NOJw9LniPiNhLjxQ07igQbg5dYWCztxrJ
         s7N207Rx5wG9Sf9+8NtHIj+x8XYumvYd2pyIR0/aNUAuTO/gNb6tafl1Ufj0qa1rWBwT
         L0og==
X-Gm-Message-State: AOJu0Yw27xQ8INRL0+gTvGH+bBDbo4mBPSbE+orh/x2JRU7FQ/8WFfx6
	CUY0Z5mOW/YN+d+Sz1qiO+n9wiKqrjbrYrALEMv+Y6I8jfrxu3TXeTFOHgjFfaZ9QK2yq8Iv8lu
	ps20C917woncuFImg98fCycxFcLWnW/oHjw==
X-Gm-Gg: ASbGncvLwXKFv3/UgCKUBx4+Zpgylrjf2i9cyUh5UdRRhI26IpvtjdP8xvhfg1XaWMk
	PM8sXFIeXGEABqtVIeeWaPlroOTjshchCEhzW8r17LHx76QbILlbeD7i8kW94Sv/qVfQFrneWZB
	zTr4aQ7iA/bXNSl2EWa4EDiXIFAVtnipH+0OQebDOTOhtItCsZXJK2hTCq7zWum3HOKwvsUiOWl
	oa2EMtIiGeGHkHirhLHzGSEMldl3hHcGN0Msf4F3PU41Ma90RA=
X-Google-Smtp-Source: AGHT+IFk3ofVl0jn+t+76vP2oa38U90BLxbJDx16sg8pejkshTBi804H3x3mFHzEjuRNBB3RpVcjC8Q6G2PBpek03wA=
X-Received: by 2002:a05:6214:1c0f:b0:70b:c8fd:47af with SMTP id
 6a1803df08f44-70d77000414mr45539216d6.30.1755708152959; Wed, 20 Aug 2025
 09:42:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250820142413.920482-1-pkerling@rx2.rx-server.de> <CAH2r5mupCJs6K3Y9N=oUp6oEAMV2S5=_d0nxirk74ZQ24gH7Eg@mail.gmail.com>
In-Reply-To: <CAH2r5mupCJs6K3Y9N=oUp6oEAMV2S5=_d0nxirk74ZQ24gH7Eg@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 20 Aug 2025 11:42:21 -0500
X-Gm-Features: Ac12FXxGrwEfJ7u_C8ZM-KfcaGzLSgNG3uUSJ2N6T6WDZ-L28AIjrQYT1UeiH58
Message-ID: <CAH2r5muNhfk-CHLYLcKMU+yXGqfiQtrZZ5ogf0PJcTsGTiBAJQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: allow a filename to contain colons on SMB3.1.1
 posix extensions
To: Philipp Kerling <pkerling@casix.org>
Cc: linux-cifs@vger.kernel.org, linkinjeon@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This remapping of colon (and other reserved characters) is done by
default when not mounting with SMB3.1.1 Linux/POSIX extensions, but
presumably would only be needed for colon with the SMB3.1.1
Linux/POSIX extensions (since colon is the only one that is 'required'
by the protocol to mean something different)

On Wed, Aug 20, 2025 at 11:37=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> Samba allows this with POSIX extensions negotiated (creating file with
> : in the name) but I am wondering if a better way to solve this (to
> avoid any confusion with alternate data streams) is to change the
> client to use SFM_COLON (ie the remap in Unicode where colon is
> remapped to 0xF022 instead of 0x003A)
>
> On Wed, Aug 20, 2025 at 9:35=E2=80=AFAM Philipp Kerling <pkerling@casix.o=
rg> wrote:
> >
> > If the client sends SMB2_CREATE_POSIX_CONTEXT to ksmbd, allow the filen=
ame to contain
> > a colon (':'). This requires disabling the support for Alternate Data S=
treams (ADS),
> > which are denoted by a colon-separated suffix to the filename on Window=
s. This should
> > not be an issue, since this concept is not known to POSIX anyway and th=
e client has
> > to explicitly request a POSIX context to get this behavior.
> >
> > Link: https://lore.kernel.org/all/f9401718e2be2ab22058b45a6817db912784e=
f61.camel@rx2.rx-server.de/
> > Signed-off-by: Philipp Kerling <pkerling@casix.org>
> > ---
> >  fs/smb/server/smb2pdu.c   | 25 ++++++++++++++-----------
> >  fs/smb/server/vfs_cache.h |  2 ++
> >  2 files changed, 16 insertions(+), 11 deletions(-)
> >
> > diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> > index 0d92ce49aed7..a565fc36cee6 100644
> > --- a/fs/smb/server/smb2pdu.c
> > +++ b/fs/smb/server/smb2pdu.c
> > @@ -2951,18 +2951,19 @@ int smb2_open(struct ksmbd_work *work)
> >                 }
> >
> >                 ksmbd_debug(SMB, "converted name =3D %s\n", name);
> > -               if (strchr(name, ':')) {
> > -                       if (!test_share_config_flag(work->tcon->share_c=
onf,
> > -                                                   KSMBD_SHARE_FLAG_ST=
REAMS)) {
> > -                               rc =3D -EBADF;
> > -                               goto err_out2;
> > -                       }
> > -                       rc =3D parse_stream_name(name, &stream_name, &s=
_type);
> > -                       if (rc < 0)
> > -                               goto err_out2;
> > -               }
> >
> >                 if (posix_ctxt =3D=3D false) {
> > +                       if (strchr(name, ':')) {
> > +                               if (!test_share_config_flag(work->tcon-=
>share_conf,
> > +                                                       KSMBD_SHARE_FLA=
G_STREAMS)) {
> > +                                       rc =3D -EBADF;
> > +                                       goto err_out2;
> > +                               }
> > +                               rc =3D parse_stream_name(name, &stream_=
name, &s_type);
> > +                               if (rc < 0)
> > +                                       goto err_out2;
> > +                       }
> > +
> >                         rc =3D ksmbd_validate_filename(name);
> >                         if (rc < 0)
> >                                 goto err_out2;
> > @@ -3443,6 +3444,8 @@ int smb2_open(struct ksmbd_work *work)
> >         fp->attrib_only =3D !(req->DesiredAccess & ~(FILE_READ_ATTRIBUT=
ES_LE |
> >                         FILE_WRITE_ATTRIBUTES_LE | FILE_SYNCHRONIZE_LE)=
);
> >
> > +       fp->is_posix_ctxt =3D posix_ctxt;
> > +
> >         /* fp should be searchable through ksmbd_inode.m_fp_list
> >          * after daccess, saccess, attrib_only, and stream are
> >          * initialized.
> > @@ -5988,7 +5991,7 @@ static int smb2_rename(struct ksmbd_work *work,
> >         if (IS_ERR(new_name))
> >                 return PTR_ERR(new_name);
> >
> > -       if (strchr(new_name, ':')) {
> > +       if (fp->is_posix_ctxt =3D=3D false && strchr(new_name, ':')) {
> >                 int s_type;
> >                 char *xattr_stream_name, *stream_name =3D NULL;
> >                 size_t xattr_stream_size;
> > diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
> > index 0708155b5caf..78b506c5ef03 100644
> > --- a/fs/smb/server/vfs_cache.h
> > +++ b/fs/smb/server/vfs_cache.h
> > @@ -112,6 +112,8 @@ struct ksmbd_file {
> >         bool                            is_durable;
> >         bool                            is_persistent;
> >         bool                            is_resilient;
> > +
> > +       bool                            is_posix_ctxt;
> >  };
> >
> >  static inline void set_ctx_actor(struct dir_context *ctx,
> > --
> > 2.50.1
> >
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
