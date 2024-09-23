Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6151B747F
	for <linux-cifs@vger.kernel.org>; Mon, 23 Sep 2024 00:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727051268; cv=none; b=n1wSuxIhBW0/bnT/qybdfL/eYwjcwlxRADgMDiXxR3yQPWA0Cj0bP1iJZduS9Wq/JHcMzhNZ/NXXNn87si+ld93nCbxb5Uc6A0py1WZdPYbFYDl7Ky2pPiDDjyPfktaTJfr0o/521y+oQ0Rouvw94UAgksiXeYTqfGQJFYqp1Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727051268; c=relaxed/simple;
	bh=S57W2P1jf5zIQXHOY2Y7MVTIil1bzik81k2cB/ibmEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+lkwKhhq0Z7SZbuivD60DZKt+Kj7aKVHepGPN0HfSIO7r7Bfjcyn62s5O7YwpfWxXI8XrTVrYeryjr06fGI773X24+vx9Fu/dXDgG9bVRn379Zfa0QUbtv8tI4Aj6joAW6vS5tF2CkbNOIB2ZmwhbNBZDASM+eTTFO8tn8X50Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tV0B4RpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tV0B4RpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6A5C4CEC3;
	Mon, 23 Sep 2024 00:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727051267;
	bh=S57W2P1jf5zIQXHOY2Y7MVTIil1bzik81k2cB/ibmEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tV0B4RpXbusRkeJfEDCBBMGqmQE7FUN4bLryzTA8cuKes8R7kqDYi7lkAdMvezA+T
	 Y4ujc3M4AuqiehaiEQM1C3b+iJ/7D9Ju/FoPHTUdha1DCNl8jrGgOVKJjsSa39iHNk
	 NITemvnT6rfgD+x3/Krz05/mS7wHKSLilCGzvpxq5cbnTpY9jXohAsjBhvEqBc6KWA
	 87X+ecaR+D2avH/EYvYVxQlSWUY2rphOLIA/vod+5CuPWSlTYcIUgRBzh5K2VoO8Or
	 Wtc82ZuIh4/zSCbCthQk7zAVfNXCK663/7+BUoo0B3D8vPwLsmTQWB/8aNHaVkNn6Q
	 ajwk9XBztC70w==
Date: Sun, 22 Sep 2024 17:27:47 -0700
From: Kees Cook <kees@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com,
	senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com
Subject: Re: [PATCH] ksmbd: Use unsafe_memcpy() for ntlm_negotiate
Message-ID: <202409221727.3BD5041C0@keescook>
References: <20240814235635.7998-1-linkinjeon@kernel.org>
 <202409221559.8410BEC@keescook>
 <CAKYAXd8JbxQ+Vnvu+iNAXMwpA+GoBVkbBGmfPN-ve=FYSid5nw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKYAXd8JbxQ+Vnvu+iNAXMwpA+GoBVkbBGmfPN-ve=FYSid5nw@mail.gmail.com>

On Mon, Sep 23, 2024 at 09:12:31AM +0900, Namjae Jeon wrote:
> On Mon, Sep 23, 2024 at 8:12 AM Kees Cook <kees@kernel.org> wrote:
> >
> > On Thu, Aug 15, 2024 at 08:56:35AM +0900, Namjae Jeon wrote:
> > > rsp buffer is allocatged larger than spnego_blob from
> > > smb2_allocate_rsp_buf().
> > >
> > > Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> > > ---
> > >  fs/smb/server/smb2pdu.c | 7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> > > index 2df1354288e6..3f4c56a10a86 100644
> > > --- a/fs/smb/server/smb2pdu.c
> > > +++ b/fs/smb/server/smb2pdu.c
> > > @@ -1370,7 +1370,8 @@ static int ntlm_negotiate(struct ksmbd_work *work,
> > >       }
> > >
> > >       sz = le16_to_cpu(rsp->SecurityBufferOffset);
> > > -     memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_len);
> > > +     unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_len,
> > > +                     /* alloc is larger than blob, see smb2_allocate_rsp_buf() */);
> > >       rsp->SecurityBufferLength = cpu_to_le16(spnego_blob_len);
> > >
> > >  out:
> > > @@ -1453,7 +1454,9 @@ static int ntlm_authenticate(struct ksmbd_work *work,
> > >                       return -ENOMEM;
> > >
> > >               sz = le16_to_cpu(rsp->SecurityBufferOffset);
> > > -             memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_len);
> > > +             unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob,
> > > +                             spnego_blob_len,
> > > +                             /* alloc is larger than blob, see smb2_allocate_rsp_buf() */);
> > >               rsp->SecurityBufferLength = cpu_to_le16(spnego_blob_len);
> > >               kfree(spnego_blob);
> > >       }
> >
> > Ew, please fix these properly instead of continuing to lie to the compiler
> > about the struct member sizes. :P
> I have fully checked that this warning is a false alarm.
> >
> > The above, &rsp->hdr.ProtocolId, addresses a single __le32 member, and
> > then tries to go past the end of it (i.e. "sz" is larger than 4). The
> > struct layout therefore indicates to memcpy that you have no bytes left
> > to write ("size 0" in the warning).
> >
> > It looks to me like you want to be calculating an offset into
> > rsp->Buffer instead? Try:
> >
> >         sz = le16_to_cpu(rsp->SecurityBufferOffset) -
> >                 offsetof(*typeof(rsp), Buffer);
> >         memcpy(&rsp->Buffer[sz], ...)
> SecurityBufferOffset is fixed to the value 72 and it points to ->Buffer.
> So memcpy(&rsp->Buffer[0], ...)
> >
> > BTW, what is validating that this:
> >
> >         sz = le16_to_cpu(rsp->SecurityBufferOffset);
> >         chgblob =
> >                 (struct challenge_message *)((char *)&rsp->hdr.ProtocolId + sz);
> >
> > is within the original data buffer? Shouldn't something check that:
> >          sz > offsetof(*typeof(rsp), Buffer)
> > and
> >         sz <= ...size of the buffer... (maybe that happened already earlier)
> SecurityBufferOffset is fixed to the value 72. It is set in smb2_sess_setup().
> 
> int smb2_sess_setup(struct ksmbd_work *work)
> ...
>         rsp->StructureSize = cpu_to_le16(9);
>         rsp->SessionFlags = 0;
>         rsp->SecurityBufferOffset = cpu_to_le16(72);
>         rsp->SecurityBufferLength = 0;
> 
> So sz and offsetof(*typeof(rsp), Buffer) will be same.
> and rsp buffer size is at least 448 bytes,  That's enough space to
> contain a chgblob(48) or spnego_blob(249).

Okay, in that case, please just use:

	memcpy(rsp->Buffer, ...)

and the "unsafe" usage can be removed. :)

-- 
Kees Cook
