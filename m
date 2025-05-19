Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3C64431
	for <linux-cifs@vger.kernel.org>; Mon, 19 May 2025 22:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747694725; cv=none; b=twAA9d76Z2sHbOzkHuA+8beZ4KH0TGNAbIbiO0fGXfDjdY7KkUqnnYYXiOsLh2edFahKdyhv7z/UW3uLPN/b0cl3ppzh5RMFL65aRVTc0UMZivc3Qzg7HXkp8aZRqA7Rw6ZmIiO0wg2fyNAshJJLJyZkQ7rgxd6lelsHVxBPKtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747694725; c=relaxed/simple;
	bh=sSM4x8jc+fcP7+FMVx55T8Qdsx6/vmtxt1KgcmPYWhM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I7a8SMl9JB0uT0rAOlcZMQHsIS7us8Z1PZRqajIxIX/HJdgX9HLGgWtPbIIr1TCfcMuUbWAjdgIOc9sPuqo4rwqmJadFWEL/woXVVtfbUHLRJfwydJDIpabNUNMabg9go+0+dUs5uJcxu/Itdhj8BJfBhxgOVr1MFGt+hsiyiPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sq/Mw/8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sq/Mw/8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D24FC4CEE4
	for <linux-cifs@vger.kernel.org>; Mon, 19 May 2025 22:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747694725;
	bh=sSM4x8jc+fcP7+FMVx55T8Qdsx6/vmtxt1KgcmPYWhM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sq/Mw/8E6Sipim1yfvhVJtRvKmhDXLXXuBgzVGWM7nVRW7Rbf1rnF7sTdkCr/1+mJ
	 OUiWuPYxKuf513+Wg0x/Ol4DF6u5GHKVcOPOAaRb8JHgODDaH1oem5kNm4UMEoYbY/
	 cWuR6vD4GSIdvaNw5uXBeLLv2VX/BBeCJRkoVkPdk4JNituMxlhoc/xJOJUMB8HaVD
	 Mn5rPmbuDNrAZB0GreX9+jTkq52om94+hO+akJFmVbfYPyHMBFSPmP9G6PjW5cs3Hx
	 rMwJpWd3kALT33ZTYtH4SP0aJomMeMZ26etldcfaNVkmzota2JJKeGqVa/ARMPaRAO
	 JM/ecxlra7nAQ==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ad1d1f57a01so866901466b.2
        for <linux-cifs@vger.kernel.org>; Mon, 19 May 2025 15:45:25 -0700 (PDT)
X-Gm-Message-State: AOJu0YwVgFTQic2WQOI6Nq8+Pt6GlQb7xGMoUAjtwSOBnPaPLxLU5jLk
	VFK5yp0DB8OKKYonalH2fTIvV5OiQIYXI8MqPjuTn7de4G262EtMDSH7Cj2ocail5ohhBsuZBVo
	J3YsTQYCtGlL+RYRmekyc0wAkfd+iD98=
X-Google-Smtp-Source: AGHT+IHIp8SbkHAR+x8FzPtLVbGoyxP4gTfuhNqoai5QOLB0B3muWK32tRCivXhTz+RQDy1prQPd0wTwWIDb8olDSAY=
X-Received: by 2002:a17:907:8690:b0:ad5:4fdb:a2d6 with SMTP id
 a640c23a62f3a-ad54fdbb14fmr995790266b.43.1747694723870; Mon, 19 May 2025
 15:45:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKYAXd9COYLK-jagbrFu5uSMb4NEYF8YqkhqH5CzVYCBQ9PBnw@mail.gmail.com>
 <d1ba8e76-9912-4f62-9274-1b6c1158a07e@talpey.com>
In-Reply-To: <d1ba8e76-9912-4f62-9274-1b6c1158a07e@talpey.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 20 May 2025 07:45:12 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8W7fAN+H4j0Sp6DfQPiDuzex-fQHgyGozxO1k_-LzkYg@mail.gmail.com>
X-Gm-Features: AX0GCFvaBxMH_U4MI1jrHbnDrVwempXj2mNa_MEe8in-Daj4QY2X5VEXlunQbfA
Message-ID: <CAKYAXd8W7fAN+H4j0Sp6DfQPiDuzex-fQHgyGozxO1k_-LzkYg@mail.gmail.com>
Subject: Re: ksmbd: use list_first_entry_or_null for opinfo_get_list()
To: Tom Talpey <tom@talpey.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2025 at 8:20=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 5/18/2025 8:33 PM, Namjae Jeon wrote:
> > The list_first_entry() macro never returns NULL.  If the list is
> > empty then it returns an invalid pointer.  Use list_first_entry_or_null=
()
> > to check if the list is empty.
> >
> > Reported-by: kernel test robot <lkp@intel.com <mailto:lkp@intel.com>>
> > Reported-by: Dan Carpenter <dan.carpenter@linaro.org
> > <mailto:dan.carpenter@linaro.org>>
> > Closes: https://lore.kernel.org/r/202505080231.7OXwq4Te-lkp@intel.com/
> > <https://lore.kernel.org/r/202505080231.7OXwq4Te-lkp@intel.com/>
> > Signed-off-by: Namjae Jeon <linkinjeon@kernel.org
> > <mailto:linkinjeon@kernel.org>>
> > Signed-off-by: Steve French <stfrench@microsoft.com
> > <mailto:stfrench@microsoft.com>>
> > ---
> >   fs/smb/server/oplock.c | 10 ++++++----
> >   1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
> > index 03f606afad93..c20f3aa03157 100644
> > --- a/fs/smb/server/oplock.c
> > +++ b/fs/smb/server/oplock.c
> > @@ -146,12 +146,14 @@ static struct oplock_info *opinfo_get_list(struct
> > ksmbd_inode *ci)
> >   {
> >          struct oplock_info *opinfo;
> >
> > -       if (list_empty(&ci->m_op_list))
> > +       down_read(&ci->m_lock);
> > +       if (list_empty(&ci->m_op_list)) {
>
> I don't understand why this is still testing list_empty().
> Isn't that the point of the new list_first_entry_or_null() below?
I will remove list_empty(), Thanks for your review!

>
> Tom.
>
> > +               up_read(&ci->m_lock);
> >                  return NULL;
> > +       }
> >
> > -       down_read(&ci->m_lock);
> > -       opinfo =3D list_first_entry(&ci->m_op_list, struct oplock_info,
> > -                                       op_entry);
> > +       opinfo =3D list_first_entry_or_null(&ci->m_op_list, struct
> > oplock_info,
> > +                                         op_entry);
> >          if (opinfo) {
> >                  if (opinfo->conn =3D=3D NULL ||
> >                      !atomic_inc_not_zero(&opinfo->refcount))
> > --
> > 2.34.1
>
