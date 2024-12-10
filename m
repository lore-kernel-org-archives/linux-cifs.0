Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F397C233123
	for <linux-cifs@vger.kernel.org>; Tue, 10 Dec 2024 07:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733817204; cv=none; b=DMhvxE76+eNmaEK87Pf7eOgnZCVX03BccbWR2k5njbywH6TAZz9rpCBIYaDw0Anu7fOXOqwxS6e+E2ILvaJONmGA/OAcYdJwnyL9lFeleKPUZnvUmvNKA7hEwUXhH2NCb77e043MvlLRisXztMpmpdRk8C4PXOpxQ1aEvyxCtGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733817204; c=relaxed/simple;
	bh=tEb4au79VZcsnxDfp8FzsQ7K24qS4TEK7t7xtbRrxqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fn/gcXCm0sgPxdL+Zrb30GOBhzFj8jg7FlS8ppK+mzV3ot2vA9Mt//KKvklXxlMmBXbJS48ezT6qM4nvf2xqYXewkTSN0Qg8+6M8gS5WcEEs+suQMFZEx7m6uZnmQwOWiS8FBd2ZImNPRGmCdXqbkvHptwmbtfh2hLaNxjf95Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aIeYxQ8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aIeYxQ8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BD8C4CEE0
	for <linux-cifs@vger.kernel.org>; Tue, 10 Dec 2024 07:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733817203;
	bh=tEb4au79VZcsnxDfp8FzsQ7K24qS4TEK7t7xtbRrxqM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aIeYxQ8lf/agUvJtFfrsLn5kPVtOzDk+d6c9Y3dwOQK6WNsvIFvUhMJrfqPS7hvwC
	 GzuJP7mH7mLGzPXxBd8+bA648aGt2dHB9G8yrHGh4ANa3m4y9yWSiF7I1bLsNErmVf
	 R2nhyYgWcL55IDu13KfMUAX77z47a9ClNSjrLnk8d53H1wRP5F24q1FWlDqTMywDS7
	 kWgEA6kiXMIcISomRwa8bAySh64PQmJB/ZvVfeSZineErp6GzXhofMA8nf8JmKEmRH
	 +GBLien923LoO9wWm4MECoExkqo2LK30jJZqsjQPaF5ackv3Ow6dWZl4kIyIc1CeQg
	 zEFGZYBOphYkg==
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-5f2be1430d2so486492eaf.0
        for <linux-cifs@vger.kernel.org>; Mon, 09 Dec 2024 23:53:23 -0800 (PST)
X-Gm-Message-State: AOJu0Yxbxwef0TCwHMfXm6W0DkGPgDisJT3YpKHLHgYAHh6ejYQl2W+R
	4VYYdYv8dyHysKxZ6xzp1CSNWvdbwyxV+2lCV3P4N6qG/A+ZlD/0ChDl74hyUB/FLJafdKMKhhX
	9v8D3Xff6cy0QM7x7bojm35YsMcI=
X-Google-Smtp-Source: AGHT+IFRFr+Z0V3f3YRFjUQEIv1RPt9Vr+SrBb2/z6HSke5VxEKto3qDfRV5Tkq6S62qAvY1DFtjUNOSpQ6eKvUmuGE=
X-Received: by 2002:a05:6820:1c8e:b0:5f2:c035:9d25 with SMTP id
 006d021491bc7-5f2c8aa5b21mr2362661eaf.0.1733817202695; Mon, 09 Dec 2024
 23:53:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241206153858.12505-1-linkinjeon@kernel.org> <20241210160230.5318c4a9.ddiss@suse.de>
In-Reply-To: <20241210160230.5318c4a9.ddiss@suse.de>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 10 Dec 2024 16:53:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9+101dK+_6ASBiMa45yr++hfe5tdTZe5v33BtkZvLhZw@mail.gmail.com>
Message-ID: <CAKYAXd9+101dK+_6ASBiMa45yr++hfe5tdTZe5v33BtkZvLhZw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: set ATTR_CTIME flags when setting mtime
To: David Disseldorp <ddiss@suse.de>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	tom@talpey.com, atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2024 at 2:02=E2=80=AFPM David Disseldorp <ddiss@suse.de> wr=
ote:
>
> Hi Namjae,
>
> On Sat,  7 Dec 2024 00:38:58 +0900, Namjae Jeon wrote:
> ...
> >  fs/smb/server/smb2pdu.c | 10 +++-------
> >  1 file changed, 3 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> > index 5a70df87074c..803b35b89513 100644
> > --- a/fs/smb/server/smb2pdu.c
> > +++ b/fs/smb/server/smb2pdu.c
> > @@ -6026,15 +6026,13 @@ static int set_file_basic_info(struct ksmbd_fil=
e *fp,
> >               attrs.ia_valid |=3D (ATTR_ATIME | ATTR_ATIME_SET);
> >       }
> >
> > -     attrs.ia_valid |=3D ATTR_CTIME;
>
> This will mean that we now only call through to notify_change() on atime
> or mtime updates, which doesn't seem right. Can we get here with a valid
> file_info->ChangeTime only (i.e. no atime/mtime change)?
As you know, there is no ATTR_CTIME_SET to set ctime with given time.
And ctime is only updated to current time if ATTR_CTIME is set.
I couldn't find the way to update only ctime with given time.

And when setting mtime by this change, ctime will also be updated to
the current time.
This is also a problem. Let me know if you have idea.

Thanks.
>
> >       if (file_info->ChangeTime)
> > -             attrs.ia_ctime =3D ksmbd_NTtimeToUnix(file_info->ChangeTi=
me);
> > -     else
> > -             attrs.ia_ctime =3D inode_get_ctime(inode);
> > +             inode_set_ctime_to_ts(inode,
> > +                             ksmbd_NTtimeToUnix(file_info->ChangeTime)=
);
> >
> >       if (file_info->LastWriteTime) {
> >               attrs.ia_mtime =3D ksmbd_NTtimeToUnix(file_info->LastWrit=
eTime);
> > -             attrs.ia_valid |=3D (ATTR_MTIME | ATTR_MTIME_SET);
> > +             attrs.ia_valid |=3D (ATTR_MTIME | ATTR_MTIME_SET | ATTR_C=
TIME);
> >       }
> >
> >       if (file_info->Attributes) {
> > @@ -6076,8 +6074,6 @@ static int set_file_basic_info(struct ksmbd_file =
*fp,
> >                       return -EACCES;
> >
> >               inode_lock(inode);
> > -             inode_set_ctime_to_ts(inode, attrs.ia_ctime);
> > -             attrs.ia_valid &=3D ~ATTR_CTIME;
> >               rc =3D notify_change(idmap, dentry, &attrs, NULL);
> >               inode_unlock(inode);
> >       }
>
