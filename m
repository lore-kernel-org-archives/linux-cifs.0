Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06413372
	for <linux-cifs@vger.kernel.org>; Mon, 23 Sep 2024 00:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727051539; cv=none; b=CRwSS9lc8QeS7lNkbqAb1+LKWYaSpNPBe4nAmhm70lwdlP4ocVXbRlEOe0ct97ny3PDShreQRZ8h1RpzUK7j4tXH6yhqGZm77FT5bv8euvwU9j+q1Z9LsQ+OFxZg7t3inD4uhRI4UQPYN1i+UlDb0DwXVQeUpncqHhkAIgJINT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727051539; c=relaxed/simple;
	bh=OygLFAsoSeO+V/0O9EC6/d50NqC6aNFipL2Cnj6rTXo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tVlylskaaFJYZVTRvrqdgbw0ILaV2XWLEKQtTeEHtaUhq7kY8nRauidY3FIraG4LzlCtsncYmG/Owb8R23a2G8nvrmPLB/HjqP7bpCq9/7um6LQL7wGD7ULlS6iZTsyqurItJpltzpbI3Hel1pWxS/fl24Yei+cw66k+BiwFODQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DJ3MxayH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DJ3MxayH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95493C4CEC3
	for <linux-cifs@vger.kernel.org>; Mon, 23 Sep 2024 00:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727051538;
	bh=OygLFAsoSeO+V/0O9EC6/d50NqC6aNFipL2Cnj6rTXo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DJ3MxayHqaCC/f5XdZ9TqWVCi+h6xM9rY0WTYrFgBbm+Ozaa1g5WoFgJ2iAsIQfYe
	 Bc+jBoyoHyA14HyiOEbusDLI2fdB+8O8vTDQrptrFj1xozgwn0uhp02b4DqcuTc40O
	 WvLUTouGqrBLkolmBcituReZG/ts0AnJdKpOgTUskGwo8RR8Z58i+6eBMJMAnlnCyN
	 ubPI6SVVxKuJEsnSJZ8/L4kBZFJEbtqwI0d/83Y94Mxz/REgpm9yq+dWTdkA6GXokh
	 czYNcmsZL+TwbF47YnF+oHkxPnF4mQfwCfIA5jsyxK7YA6YOyT+1xPnLkJ1l+4SfLw
	 DvIrq20N0dFbA==
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5e1c63c9822so2114154eaf.0
        for <linux-cifs@vger.kernel.org>; Sun, 22 Sep 2024 17:32:18 -0700 (PDT)
X-Gm-Message-State: AOJu0YyoThJLwx3pPHGbXuEEIoaMMSbLYbi11qrYvs4uTLEcJPz0da/7
	YyxTVLMGwD8p/dSJUGjimyawuGYJpitFgA+XmyAuy8tenm3/eTuyW05oDdDlSmyfqVdq2812DAN
	gHI/GpsaDVT5Lws3oMg4WhNcBzeQ=
X-Google-Smtp-Source: AGHT+IE4V9BqqR1+Bj8Wclq08k7oPgC+VHJJ0tATEJCn81jjgOcLOLzYF94saeIdDfXzxf0vgq7BWLRfEcm45KF3WL0=
X-Received: by 2002:a05:6870:46ab:b0:277:bf1c:da4a with SMTP id
 586e51a60fabf-2803d156c6amr5073253fac.45.1727051537861; Sun, 22 Sep 2024
 17:32:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240814235635.7998-1-linkinjeon@kernel.org> <202409221559.8410BEC@keescook>
 <CAKYAXd8JbxQ+Vnvu+iNAXMwpA+GoBVkbBGmfPN-ve=FYSid5nw@mail.gmail.com> <202409221727.3BD5041C0@keescook>
In-Reply-To: <202409221727.3BD5041C0@keescook>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 23 Sep 2024 09:32:07 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9gtG0y1DoZqMuwx1WP6QpcPjB_eMbA02sG=keo=vwg2Q@mail.gmail.com>
Message-ID: <CAKYAXd9gtG0y1DoZqMuwx1WP6QpcPjB_eMbA02sG=keo=vwg2Q@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Use unsafe_memcpy() for ntlm_negotiate
To: Kees Cook <kees@kernel.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	tom@talpey.com, atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2024 at 9:27=E2=80=AFAM Kees Cook <kees@kernel.org> wrote:
>
> On Mon, Sep 23, 2024 at 09:12:31AM +0900, Namjae Jeon wrote:
> > On Mon, Sep 23, 2024 at 8:12=E2=80=AFAM Kees Cook <kees@kernel.org> wro=
te:
> > >
> > > On Thu, Aug 15, 2024 at 08:56:35AM +0900, Namjae Jeon wrote:
> > > > rsp buffer is allocatged larger than spnego_blob from
> > > > smb2_allocate_rsp_buf().
> > > >
> > > > Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> > > > ---
> > > >  fs/smb/server/smb2pdu.c | 7 +++++--
> > > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> > > > index 2df1354288e6..3f4c56a10a86 100644
> > > > --- a/fs/smb/server/smb2pdu.c
> > > > +++ b/fs/smb/server/smb2pdu.c
> > > > @@ -1370,7 +1370,8 @@ static int ntlm_negotiate(struct ksmbd_work *=
work,
> > > >       }
> > > >
> > > >       sz =3D le16_to_cpu(rsp->SecurityBufferOffset);
> > > > -     memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego=
_blob_len);
> > > > +     unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob,=
 spnego_blob_len,
> > > > +                     /* alloc is larger than blob, see smb2_alloca=
te_rsp_buf() */);
> > > >       rsp->SecurityBufferLength =3D cpu_to_le16(spnego_blob_len);
> > > >
> > > >  out:
> > > > @@ -1453,7 +1454,9 @@ static int ntlm_authenticate(struct ksmbd_wor=
k *work,
> > > >                       return -ENOMEM;
> > > >
> > > >               sz =3D le16_to_cpu(rsp->SecurityBufferOffset);
> > > > -             memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob=
, spnego_blob_len);
> > > > +             unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spne=
go_blob,
> > > > +                             spnego_blob_len,
> > > > +                             /* alloc is larger than blob, see smb=
2_allocate_rsp_buf() */);
> > > >               rsp->SecurityBufferLength =3D cpu_to_le16(spnego_blob=
_len);
> > > >               kfree(spnego_blob);
> > > >       }
> > >
> > > Ew, please fix these properly instead of continuing to lie to the com=
piler
> > > about the struct member sizes. :P
> > I have fully checked that this warning is a false alarm.
> > >
> > > The above, &rsp->hdr.ProtocolId, addresses a single __le32 member, an=
d
> > > then tries to go past the end of it (i.e. "sz" is larger than 4). The
> > > struct layout therefore indicates to memcpy that you have no bytes le=
ft
> > > to write ("size 0" in the warning).
> > >
> > > It looks to me like you want to be calculating an offset into
> > > rsp->Buffer instead? Try:
> > >
> > >         sz =3D le16_to_cpu(rsp->SecurityBufferOffset) -
> > >                 offsetof(*typeof(rsp), Buffer);
> > >         memcpy(&rsp->Buffer[sz], ...)
> > SecurityBufferOffset is fixed to the value 72 and it points to ->Buffer=
.
> > So memcpy(&rsp->Buffer[0], ...)
> > >
> > > BTW, what is validating that this:
> > >
> > >         sz =3D le16_to_cpu(rsp->SecurityBufferOffset);
> > >         chgblob =3D
> > >                 (struct challenge_message *)((char *)&rsp->hdr.Protoc=
olId + sz);
> > >
> > > is within the original data buffer? Shouldn't something check that:
> > >          sz > offsetof(*typeof(rsp), Buffer)
> > > and
> > >         sz <=3D ...size of the buffer... (maybe that happened already=
 earlier)
> > SecurityBufferOffset is fixed to the value 72. It is set in smb2_sess_s=
etup().
> >
> > int smb2_sess_setup(struct ksmbd_work *work)
> > ...
> >         rsp->StructureSize =3D cpu_to_le16(9);
> >         rsp->SessionFlags =3D 0;
> >         rsp->SecurityBufferOffset =3D cpu_to_le16(72);
> >         rsp->SecurityBufferLength =3D 0;
> >
> > So sz and offsetof(*typeof(rsp), Buffer) will be same.
> > and rsp buffer size is at least 448 bytes,  That's enough space to
> > contain a chgblob(48) or spnego_blob(249).
>
> Okay, in that case, please just use:
>
>         memcpy(rsp->Buffer, ...)
>
> and the "unsafe" usage can be removed. :)
Okay, I will update it:)

Thanks!
>
> --
> Kees Cook
