Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5DB7FD
	for <linux-cifs@vger.kernel.org>; Mon, 23 Sep 2024 00:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727050363; cv=none; b=c18Ne/sE4yE0VBVQ5h28Uu/1LHSaF2O3IcP3ddx2TEoL8mFd+e/Eyg3RZ6X+62RpBCKLTur2Y3Dh3ca+39HPnfNWHTELrEYqOXHMR1y4LggCQfWd/LlDeNgSCyaCMGfnPWGTI7XEEqCHEf5utmQbQW0JPbayNFYOjQOZaKzEOzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727050363; c=relaxed/simple;
	bh=lwqFYN31qMm2GvW+pWZ+20c0vJJLlrCtMtTj2EaIpME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hea4gqCGP/i41IInL2YDVf3Apv1oaNZW87VlTfljv6z89hqiXNJS146dMvEq5grUbG2iTvtegd2tHXyuGPw1VSnOUm1oeWQNq2A1DZQSZx2XKgH5Dv+OR1ZHKXwI8flW/bSlVfyaPR1NdMU0iLi/CTiLYd21gCPwzIvQZxiYm/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KyK6cfRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KyK6cfRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4828C4CECF
	for <linux-cifs@vger.kernel.org>; Mon, 23 Sep 2024 00:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727050362;
	bh=lwqFYN31qMm2GvW+pWZ+20c0vJJLlrCtMtTj2EaIpME=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KyK6cfRlWXrUtS9adkrsODdkC7v0S+2OVE+4uO4R26+XCH7nBJwE8m6JTEKxSceDs
	 9melMKBL6ph+79wp00BbLcgD0lblYzj10JvX0vRgkIeXOblNDrWAyPjTGu4p96yT7u
	 vkjxHcht5bgQtUwhE5HGH4t61WO2H0gEYOYPubLKtnn3j9RzaMOO58nMbI/w1xjScv
	 y9HIjnpdSWtgaQBEE7L7FgAQYpTEmGtg95bmWA+ZpSUhHW9CtivBqIp86pyhmMGfuS
	 0JVkorcrpEYvGbeKRRHlYVDnr2yqHnm8/TL4SZ7X/gaoKIxmzNDtPd0N0ha+brDTjh
	 M77uo+CVm/xiw==
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5e1b50feb9bso2547128eaf.1
        for <linux-cifs@vger.kernel.org>; Sun, 22 Sep 2024 17:12:42 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy2FbexWIb2uEIadlcJU5JcuAiBoJ02MzonQFlEBq0kYj7uGZu2
	sM6/d+apBwGz3m8LfywoMl6wb+r65bMwt/deSKt/M3f9ZYgwVWM56xVMvIz8sVaXyXq+n1T/QAC
	Zc+AHZRe+xJWeZjoc1+ZWYsFqHy0=
X-Google-Smtp-Source: AGHT+IGBS2SS3JGrEmfwrg4pa2fmoKFBJddX4ArhpMAl/mxP06t8z5fAzKDjvyu2DqpgSgiD8SfL++s/JyDf87s+zCc=
X-Received: by 2002:a05:6870:6126:b0:279:43d1:94fc with SMTP id
 586e51a60fabf-2803d18d4bamr6110769fac.44.1727050362064; Sun, 22 Sep 2024
 17:12:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240814235635.7998-1-linkinjeon@kernel.org> <202409221559.8410BEC@keescook>
In-Reply-To: <202409221559.8410BEC@keescook>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 23 Sep 2024 09:12:31 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8JbxQ+Vnvu+iNAXMwpA+GoBVkbBGmfPN-ve=FYSid5nw@mail.gmail.com>
Message-ID: <CAKYAXd8JbxQ+Vnvu+iNAXMwpA+GoBVkbBGmfPN-ve=FYSid5nw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Use unsafe_memcpy() for ntlm_negotiate
To: Kees Cook <kees@kernel.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	tom@talpey.com, atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2024 at 8:12=E2=80=AFAM Kees Cook <kees@kernel.org> wrote:
>
> On Thu, Aug 15, 2024 at 08:56:35AM +0900, Namjae Jeon wrote:
> > rsp buffer is allocatged larger than spnego_blob from
> > smb2_allocate_rsp_buf().
> >
> > Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> > ---
> >  fs/smb/server/smb2pdu.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> > index 2df1354288e6..3f4c56a10a86 100644
> > --- a/fs/smb/server/smb2pdu.c
> > +++ b/fs/smb/server/smb2pdu.c
> > @@ -1370,7 +1370,8 @@ static int ntlm_negotiate(struct ksmbd_work *work=
,
> >       }
> >
> >       sz =3D le16_to_cpu(rsp->SecurityBufferOffset);
> > -     memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blo=
b_len);
> > +     unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spn=
ego_blob_len,
> > +                     /* alloc is larger than blob, see smb2_allocate_r=
sp_buf() */);
> >       rsp->SecurityBufferLength =3D cpu_to_le16(spnego_blob_len);
> >
> >  out:
> > @@ -1453,7 +1454,9 @@ static int ntlm_authenticate(struct ksmbd_work *w=
ork,
> >                       return -ENOMEM;
> >
> >               sz =3D le16_to_cpu(rsp->SecurityBufferOffset);
> > -             memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, sp=
nego_blob_len);
> > +             unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_b=
lob,
> > +                             spnego_blob_len,
> > +                             /* alloc is larger than blob, see smb2_al=
locate_rsp_buf() */);
> >               rsp->SecurityBufferLength =3D cpu_to_le16(spnego_blob_len=
);
> >               kfree(spnego_blob);
> >       }
>
> Ew, please fix these properly instead of continuing to lie to the compile=
r
> about the struct member sizes. :P
I have fully checked that this warning is a false alarm.
>
> The above, &rsp->hdr.ProtocolId, addresses a single __le32 member, and
> then tries to go past the end of it (i.e. "sz" is larger than 4). The
> struct layout therefore indicates to memcpy that you have no bytes left
> to write ("size 0" in the warning).
>
> It looks to me like you want to be calculating an offset into
> rsp->Buffer instead? Try:
>
>         sz =3D le16_to_cpu(rsp->SecurityBufferOffset) -
>                 offsetof(*typeof(rsp), Buffer);
>         memcpy(&rsp->Buffer[sz], ...)
SecurityBufferOffset is fixed to the value 72 and it points to ->Buffer.
So memcpy(&rsp->Buffer[0], ...)
>
> BTW, what is validating that this:
>
>         sz =3D le16_to_cpu(rsp->SecurityBufferOffset);
>         chgblob =3D
>                 (struct challenge_message *)((char *)&rsp->hdr.ProtocolId=
 + sz);
>
> is within the original data buffer? Shouldn't something check that:
>          sz > offsetof(*typeof(rsp), Buffer)
> and
>         sz <=3D ...size of the buffer... (maybe that happened already ear=
lier)
SecurityBufferOffset is fixed to the value 72. It is set in smb2_sess_setup=
().

int smb2_sess_setup(struct ksmbd_work *work)
...
        rsp->StructureSize =3D cpu_to_le16(9);
        rsp->SessionFlags =3D 0;
        rsp->SecurityBufferOffset =3D cpu_to_le16(72);
        rsp->SecurityBufferLength =3D 0;

So sz and offsetof(*typeof(rsp), Buffer) will be same.
and rsp buffer size is at least 448 bytes,  That's enough space to
contain a chgblob(48) or spnego_blob(249).

Thanks.
>
> --
> Kees Cook
