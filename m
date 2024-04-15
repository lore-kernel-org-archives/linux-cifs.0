Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4441F200D5
	for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 10:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713178280; cv=none; b=D0SHGJ0Yg8F07q4bNM5iPcXSIV/WMKme9wZp+bmUX0dFhkptJyhiweNTT3NXKhm0BbVRoxOHdHtNOnviQG1sRJB7khD82cCkYn88aPwjNkNWMFwQlIMnBrrOQBRqe1wEPGQyevz4Iq3HEnm87ISbKhPC3opPAolHD9SEngr5p9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713178280; c=relaxed/simple;
	bh=CRff6P4EGmVT9WeLQJHKK0IVprUSjbOYsE/+MDUpYgY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Oghek892c8Vo5nxwOdfhCp+d2gYeTTXViau8zc5I+KML2DFKg/clrL9/oOcw/R025jgE3OL5HfT/DyGfHpdhLivXUAPQzlzOjhX+6YwJTBkp3gSTXH/P0yFEp3MQNYIeKnDjK9fF0Ecm/e+o8FUET2kdF1dI0GzW0n+DCo8JtKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qw4LNzoT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qw4LNzoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11A7C2BD11
	for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 10:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713178280;
	bh=CRff6P4EGmVT9WeLQJHKK0IVprUSjbOYsE/+MDUpYgY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qw4LNzoT0qcvsFCUjkjhWdjSBwMbjKm26kZqK+n7D0BV7Ql7G6v60g/Q/y6sAwio7
	 DfXlETCxFh+16Y49p5jIJtJI6puUJYCzT5ef9EViJyQaKQ24ZcmJU3IBAIlHDdroaL
	 OZo9W5PkRIOwQ/CaEDWWmg9rfHMPraIMBhjrMaqpknIzGo7+yF7a9iqxgAyT/jdv04
	 YIRp8nNmAm/phLASjgzNvDNXHRvidh4eWv7IEvrgPSOwK3RTDreem6ui+kf9dCjY3I
	 1g19VT9D6iNNQWrSUO9KZYtyyyneKt6mHlx4V9zsLRJeBxg3tx2ES/qvnfW0i/cXwD
	 cIj1cZptH3mzw==
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6ea2436de79so2128216a34.1
        for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 03:51:19 -0700 (PDT)
X-Gm-Message-State: AOJu0YyHwA3OPbDhQH4aPhPIxcjF7RvuApvrpqJ3gsSwBICKG57HAKAp
	DB7WerN//peUvlqaev5eryejCngutDpadkOR7KT/fC5CPJCJSp8qpKyE0c3FDXwIFXp0ghcOSOk
	4xjDRuURgsSfUMxjGjx24Gn2f8NY=
X-Google-Smtp-Source: AGHT+IHNPgP6bDem9lm6d/8oGS8C6eRH4YLP/ZUa/cJT4uFGtAN/wpgqCKfHSeclA9EBdCct9/G3FdkTp/dWJLKahdw=
X-Received: by 2002:a05:6870:c095:b0:22e:d2b2:25fe with SMTP id
 c21-20020a056870c09500b0022ed2b225femr11122744oad.1.1713178279288; Mon, 15
 Apr 2024 03:51:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240313130708.2915988-1-mmakassikis@freebox.fr> <CAF6XXKVNTF2yZK=QdKi-YNZC5N93x-NrN7a=hDGZNNCUfxTAwA@mail.gmail.com>
In-Reply-To: <CAF6XXKVNTF2yZK=QdKi-YNZC5N93x-NrN7a=hDGZNNCUfxTAwA@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 15 Apr 2024 19:51:08 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9o2d0Ky-242+UV3DcHWs1ZMYd+ErP8Ueqn3nvucMQtJA@mail.gmail.com>
Message-ID: <CAKYAXd9o2d0Ky-242+UV3DcHWs1ZMYd+ErP8Ueqn3nvucMQtJA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: clear RENAME_NOREPLACE before calling vfs_rename
To: Marios Makassikis <mmakassikis@freebox.fr>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2024=EB=85=84 4=EC=9B=94 15=EC=9D=BC (=EC=9B=94) =EC=98=A4=ED=9B=84 6:01, M=
arios Makassikis <mmakassikis@freebox.fr>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> On Wed, Mar 13, 2024 at 2:07=E2=80=AFPM Marios Makassikis
> <mmakassikis@freebox.fr> wrote:
> >
> > File overwrite case is explicitly handled, so it is not necessary to
> > pass RENAME_NOREPLACE to vfs_rename.
> >
> > Clearing the flag fixes rename operations when the share is a ntfs-3g
> > mount. The latter uses an older version of fuse with no support for
> > flags in the ->rename op.
> >
> > Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> > ---
> >  fs/smb/server/vfs.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
>
> Bumping this as I haven't received any feedback.
> Are there any issues with the patch ?
Sorry for missing this patch. Please cc me when submitting the patch
to the list next time.
I didn't understand why it is a problem with ntfs-3g yet.
Is it just clean-up patch ? or this flags cause some issue with ntfs-3g ?
Could you please elaborate more ?

Thanks!
