Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AE519E992
	for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 04:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776832501; cv=pass; b=A1RVbT/seZ6ay1tunNBwN2p49+U3ioUkM0CuU1rHohVYeHOZDsT/Nf2dItk8EVMMb2BQ4rOSluyEy+YtXYuMmY+orn76t/V8FkmiTtmPF07vz5/YyRT3Ygu3EspmsLpP+2ceMnkHliwYq0aNmohhzl578bTbaaQBX7QLKph06es=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776832501; c=relaxed/simple;
	bh=15DT7UlOT4OME8eMA3mkU/Hfui5nSXa1AmGELyUh8rc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hcgc+4mDVb4pghX7scDDIVuql5KhbHsSvL3g+bPfcSs6AMN/F3Vurs1KFEuh7OtQbj+/hXDOml+Hn5X1ts+rGIRX25yzg2jyuXsaacXwUbruPGQC7k6jf2j50JQxFHehXeB+y/D6yA7yv9u23W1qQ2kAGr2HVHhcEOTjEbHHGO0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fAbc8pIw; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fAbc8pIw"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-671ff4b716cso8305852a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 21:34:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776832498; cv=none;
        d=google.com; s=arc-20240605;
        b=UiBs3qLeZH3VXVBPtzYl0T56qi3xjAxOBGnmqRu+xOz4QAnNkwf5a2DsONhJaFqLaa
         AMv/2q+hjotnJQSw0olf9xU8bsd2dUvwO9Iz1G6ju0WLrssVvdbwvjRzeLmuLlW2bSyy
         Qf/DzMdQXyHLcAiHb0uoR+yWWINoBgbR89pv0cNvWr1DXBiBwNOl75PLwYUIqJe0dsnP
         s9Rg9vMER8bpC0KHsaaG4hPNKFM4XbCufegvWEwih1LzBY1R8m5fN4O5B+yPyubc1gDW
         4dt0pGLs+lvrcfnPRBOCIdjskunwriCtmkAV9zIk/Y2dLaZHOSF14ajlkB+DhD8QCiPH
         vAaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BWOmi7Caq/CAYdl8s698yfPcfzl5FxC73beouIJ7/44=;
        fh=fCLT+amvb4IQX+0OfZDzsJigWZllBdNrYVW+/uU27rQ=;
        b=HznNYxAySAQ+FNzLUKnjNojzNkcdWGZgDh/Zi0OMez5xLeWB3KvZV0BGnt3vYgT9Af
         TSNeKto8QY0ZreW1EfvNgKevdjZMUeQjIgA5s5rgdraqgElU8BdN/qZ6mwko+VwhyGdJ
         8YOZTW7iHgRigBBUk+a98YiluIEg2HUiGgZODWOr3Ul5xZsCj1Hl6f9RvK8nkN+ZQRnC
         KwFy4/tKqL9H8gPrL5QqL2gWP03b7fTfb7tv8MrQPdmSB15J8RZdmwE80DKIYM2IUTKB
         FEsw35u60j4jSv2YtvYM9IVbx/IWbQ9LFxIGbG4gotJURrntpXB56Y+95FoiEwqUM31k
         A24w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776832498; x=1777437298; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BWOmi7Caq/CAYdl8s698yfPcfzl5FxC73beouIJ7/44=;
        b=fAbc8pIwooDq6ofuXZxpPFhwF5m7XlrDZayRBmTgrw5PfhgP0FtatxXo1sfEQvkmMy
         dg4rDQmZXdvyNbB6vIwDvBwVu82h3mtKLgPH2HTLuCNll0amttvUhJTN1TCf03bGDuIS
         cNGrEg8iNDaU5oISfW1xYAjbpNKf2wVbq8p4njkNKWTe7GBpQB3Rv8s7NQprS/TFSSpV
         nLqICl7VVWfQjANwBkXAQW6N/DR5gOBMvW0SZoZIdtlXgm7bUM3I9PSVLyP0ShmUchvt
         coJAZa08oCSSAbIgnnc1IuwgoRp/EGm+Lfsk8ZlANglpNVX2o30j/AY2vYd5TTg2tCw1
         whgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776832498; x=1777437298;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BWOmi7Caq/CAYdl8s698yfPcfzl5FxC73beouIJ7/44=;
        b=D94yc3u6KKTfV1j+J9TifTGCcrXn1xbJWlhP+s+HABzD9/OTP2X1J5IQi+St7ksHFx
         bP1a1jJ3lHxvrFwQHpjncfXdo9G8X4y9v6HR5peSFw+TC+aomfFPf15yGp7NRvgi3MCl
         CraP/b3o5nOEr9WExLoYZMwKHoBr4Zi+Y8Aaz/K1bNP4pkHU/TAdwcMBqh6XSEFMj4VS
         glJpzmMHZbnFbnuS3QhpCx3yIIecDd0OGJJhCB3/45Sb6vWhqse+m8e3AOC8oljjmouR
         BZfrv0bk+MEpqnD/aVwozQO1CT56jL6pcp/L7z4y4qPUkMRwhRn3HltzIZziL09DbIj4
         arIQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Z4mhiMu6mxvAlngWw4Otjnyk5LtTB6PJNvPeo3SLG9+g2N9J//5le6E1wpnl/QoG3XlxAG89qgZlA@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm3/DUjpJaQiYe42E27zez6/qnX7GaczubVCmTx3RDmwreaKa5
	OOCbSaYYTb2AzXaT7a8XTJU02rDRbVdeaElb5eXnwE0RbH4BXVuQxIUBXKP8I6bCw7f6cu2S7Rw
	9zJRVOVa4xmdksZZNrAfuqcfxgwJKwPo=
X-Gm-Gg: AeBDietQGsamtjepyRnhWKL4D4rU6v+N5EArAJYn/NPIbeLz7KpMHD7r0nB4yWPbpPF
	1wYRo+ewNw9IoObuTIs/guyANVl7slWYNrNRhspqS3TqFgpKLOc6BgpMUBeseQlRu9diJB9gqsX
	WrtYeNNhY/nlf/EvRXbAqcSS9Rqvih3No1WktHGV8qBTEe4UYi7+95WF9PhUW34mOLmKxiwHd3z
	r6454VANe+2IvsH77wmkTGvTqG8musIHgEMFmRQ1IMzWHfpyTF/5z7wrbS2NnHiunTH2TazJuZ9
	jb+BssI9QokWG4mthCP1OOr3Q/0=
X-Received: by 2002:a05:6402:40c6:b0:676:c01f:8a75 with SMTP id
 4fb4d7f45d1cf-676c01f8ce5mr2060119a12.21.1776832498046; Tue, 21 Apr 2026
 21:34:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260409095926.905020-1-rajasimandalos@gmail.com>
 <20260409095926.905020-7-rajasimandalos@gmail.com> <CAFTVevVLJg59YjUPu8HBA4+emN_eUVJe8H9UCUCswY1ui6cnVw@mail.gmail.com>
In-Reply-To: <CAFTVevVLJg59YjUPu8HBA4+emN_eUVJe8H9UCUCswY1ui6cnVw@mail.gmail.com>
From: RAJASI MANDAL <rajasimandalos@gmail.com>
Date: Tue, 21 Apr 2026 21:34:45 -0700
X-Gm-Features: AQROBzAYpXEcyAsqmgwtJw5HxAtQDSbgZbpiruhdFEXG4Tjj6MG7_P-0ForvYRg
Message-ID: <CAEY6_V3SEV-38f6q3BgA1OnX36yLSkJvir1yxTL_M2fhr2qx4g@mail.gmail.com>
Subject: Re: [PATCH 7/9] smb: client: block cache=ro and cache=singleclient on remount
To: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	metze@samba.org, bharathsm@microsoft.com, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Handled in updated Patch 1

On Mon, Apr 13, 2026 at 7:10=E2=80=AFPM Meetakshi Setiya
<meetakshisetiyaoss@gmail.com> wrote:
>
> Hey Rajasi,
>
> I guess this is not handling remounts where cache=3Dsingleclient/ro is
> not specified i.e. preserving previous behaviour.
>
> To reproduce, mount with cache=3Dro and remount without providing cache=
=3Dro.
>
> sudo mount -t cifs //server/winshare /mnt/mainshare -o
> remount,username=3Ddemouser
> mount error(22): Invalid argument
>
> On Thu, Apr 9, 2026 at 3:07=E2=80=AFAM <rajasimandalos@gmail.com> wrote:
> >
> > From: Rajasi Mandal <rajasimandal@microsoft.com>
> >
> > cache=3Dro and cache=3Dsingleclient are mount-time environment declarat=
ions
> > where the admin promises that the share is read-only or exclusively
> > accessed.  The client bypasses server-based coherency (oplocks/leases)
> > and caches aggressively based on this promise.
> >
> > These modes were intentionally excluded from smb3_update_mnt_flags()
> > when it was introduced in commit 2d39f50c2b15 ("cifs: move update of
> > flags into a separate function") =E2=80=94 only cache=3Dstrict, cache=
=3Dnone and
> > cache=3Dloose were made reconfigurable.  However, remount currently
> > silently accepts cache=3Dro and cache=3Dsingleclient without actually
> > applying them, which is confusing.
> >
> > Add explicit checks in smb3_verify_reconfigure_ctx() to reject
> > attempts to change these options during remount with a clear error
> > message.
> >
> > Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> > ---
> >  fs/smb/client/fs_context.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> > index ce4842e778c4..2be72733ef2e 100644
> > --- a/fs/smb/client/fs_context.c
> > +++ b/fs/smb/client/fs_context.c
> > @@ -1180,6 +1180,14 @@ static int smb3_verify_reconfigure_ctx(struct fs=
_context *fc,
> >                 cifs_errorf(fc, "can not change rdma during remount\n")=
;
> >                 return -EINVAL;
> >         }
> > +       if (new_ctx->cache_ro !=3D old_ctx->cache_ro) {
> > +               cifs_errorf(fc, "can not change cache=3Dro during remou=
nt\n");
> > +               return -EINVAL;
> > +       }
> > +       if (new_ctx->cache_rw !=3D old_ctx->cache_rw) {
> > +               cifs_errorf(fc, "can not change cache=3Dsingleclient du=
ring remount\n");
> > +               return -EINVAL;
> > +       }
> >
> >         return 0;
> >  }
> > --
> > 2.43.0
> >
> >
