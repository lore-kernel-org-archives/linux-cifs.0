Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D297D3E6
	for <linux-cifs@vger.kernel.org>; Wed, 22 May 2024 23:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716420706; cv=none; b=Glo/BkpdvSts+zdlZ0ldllhL7rS8UI6QhZe/Zgl1CGNbl2i3vBZ4zUHSSnYUDrS1arc4d0vkGvRDp3uvCGbK9iJv9TCRlVJqJIYvwAMt1mDDLwKCAdMjoXnFy9NLidW3QdL9YfTp+PoI8O46NDWm7oZgG5wkD8HMNksBlTSmgp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716420706; c=relaxed/simple;
	bh=I7yXoy7FNFwE95n+b88qrZJWiJpFu9NE5aLgbAYdpeE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jg73n2JGe8eRopqwV6D4i+2M7lB93+g4BrLH2eFLfXMEuqfWO8bhOhXLWY3QGy/n7Kf5KWWAV6oXYHdT6chhlcTWJNfoQbB3QcdacSseGaqkt4zrUgzTLkncchAu2UF+doIPNXeR1Qd8DXoX2wmpdahKE4LSf5mb5KfLex4NWq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oXduSAHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oXduSAHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D430C2BBFC
	for <linux-cifs@vger.kernel.org>; Wed, 22 May 2024 23:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716420705;
	bh=I7yXoy7FNFwE95n+b88qrZJWiJpFu9NE5aLgbAYdpeE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oXduSAHqS6LgyQdoRWxY5D2kj3UiuHJNRBuNtgSfTlC0oP/RZbe6/Han3EFRqe7/P
	 7HaNlMRWAqdbnww3kvrDoAfgSncZ6waVvRDA1VoX39etq64JNFqJEwK1RwKwR7LZ0K
	 9LOof+MLoq6waCU352GPSDDtWPqYSZd0vu/Ni/Q29sGEjKn+DU8eRoA4S4oQp7gr5/
	 K/B3BSnpAOyusi4HjXxcdc2yQhNGTwApng3lQxltMS6/T2dKIvdDXvzeDnFqUXkfoq
	 kMXQDDr3CCndGUKazARHPFKs26unvIrdStEsanSJFNkj6/cjfqtyK9QXGLseYPDigD
	 aEroSI2pVZl6g==
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5b277e17e15so4219503eaf.2
        for <linux-cifs@vger.kernel.org>; Wed, 22 May 2024 16:31:45 -0700 (PDT)
X-Gm-Message-State: AOJu0YzpXWblH7vLB7dqdVMZHA0raJxWzcakLNTgfnRiIehBGL+MZtOs
	8zW42s/amWMv8NkG6WseuTSomK5LDMjPjz3rDc4Juhw6ohl/0/Lh/r0GOzmFU3/C58zS8qT1U5x
	WTFCrEGXISglFFlQJ7d0b3UBFmFI=
X-Google-Smtp-Source: AGHT+IF4aMvSBr+R1aJmzWlOR1pN8Pp+YJHI+EOE8s7aAOwNZLw1umCYGMQG1/J0l1XmypSV9phzt1I00H9zZvKUBZo=
X-Received: by 2002:a05:6820:151a:b0:5a9:cef4:fcea with SMTP id
 006d021491bc7-5b6a0e083d2mr3612229eaf.1.1716420704873; Wed, 22 May 2024
 16:31:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240521135753.5108-1-linkinjeon@kernel.org> <c67c96ed-c9e6-4689-8f68-d56ddab71708@talpey.com>
 <CAKYAXd9iXrmh17gutKYPFGs31vBwN94HOGd-fvVCo66RQnazUw@mail.gmail.com> <14fa6bf0-00e4-4716-8569-a85e411228eb@talpey.com>
In-Reply-To: <14fa6bf0-00e4-4716-8569-a85e411228eb@talpey.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 23 May 2024 08:31:33 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_NBDSmirpO45T0tgu9XCGr4MSK+DW=NCqGFLSe8uY06A@mail.gmail.com>
Message-ID: <CAKYAXd_NBDSmirpO45T0tgu9XCGr4MSK+DW=NCqGFLSe8uY06A@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: avoid reclaiming expired durable opens by the client
To: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2024=EB=85=84 5=EC=9B=94 23=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 4:47, T=
om Talpey <tom@talpey.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On 5/22/2024 1:13 AM, Namjae Jeon wrote:
> > 2024=EB=85=84 5=EC=9B=94 22=EC=9D=BC (=EC=88=98) =EC=98=A4=EC=A0=84 12:=
10, Tom Talpey <tom@talpey.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
> >>
> >> On 5/21/2024 9:57 AM, Namjae Jeon wrote:
> >>> The expired durable opens should not be reclaimed by client.
> >>> This patch add ->durable_scavenger_timeout to fp and check it in
> >>> ksmbd_lookup_durable_fd().
> >>>
> >>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> >>> ---
> >>>    fs/smb/server/vfs_cache.c | 9 ++++++++-
> >>>    fs/smb/server/vfs_cache.h | 1 +
> >>>    2 files changed, 9 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
> >>> index 6cb599cd287e..a6804545db28 100644
> >>> --- a/fs/smb/server/vfs_cache.c
> >>> +++ b/fs/smb/server/vfs_cache.c
> >>> @@ -476,7 +476,10 @@ struct ksmbd_file *ksmbd_lookup_durable_fd(unsig=
ned long long id)
> >>>        struct ksmbd_file *fp;
> >>>
> >>>        fp =3D __ksmbd_lookup_fd(&global_ft, id);
> >>> -     if (fp && fp->conn) {
> >>> +     if (fp && (fp->conn ||
> >>> +                (fp->durable_scavenger_timeout &&
> >>> +                 (fp->durable_scavenger_timeout <
> >>> +                  jiffies_to_msecs(jiffies))))) {
> >>
> >> Do I understand correctly that this case means the fd is valid,
> >> and only the durable timeout has been exceeded?
> > Yes.
> >>
> >> If so, I believe it is overly strict behavior. MS-SMB2 specifically
> >> states that the timer is a lower bound:
> >>
> >>> 3.3.2.2 Durable Open Scavenger Timer This timer controls the amount
> >>> of time the server keeps a durable handle active after the
> >>> underlying transport connection to the client is lost.<210> The
> >>> server MUST keep the durable handle active for at least this amount
> >>> of time, except in the cases of an oplock break indicated by the
> >>> object store as specified in section 3.3.4.6, administrative actions,
> >>> or resource constraints.
> >> What defect does this patch fix?
> > Durable open scavenger timer has not been added yet.
> > I will be adding this timer with this next patch. Nonetheless, this
> > patch is needed.
> > i.e. we need both ones.
>
> So this code has no effect until then? And presumably, the scavenger
> will be closing the fd, so it won't have any effect later, either.
Not at all. We can first take steps to prevent the timeout of durable v2
open from being used. There is absolutely no harm in this.

Thanks.
>
> The patch should not be applied at this time, and the full change
> should be reviewed when it's ready.
>
> Tom.
>
> > Thanks!
> >>
> >> Tom.
> >>
> >>
> >>>                ksmbd_put_durable_fd(fp);
> >>>                fp =3D NULL;
> >>>        }
> >>> @@ -717,6 +720,10 @@ static bool session_fd_check(struct ksmbd_tree_c=
onnect *tcon,
> >>>        fp->tcon =3D NULL;
> >>>        fp->volatile_id =3D KSMBD_NO_FID;
> >>>
> >>> +     if (fp->durable_timeout)
> >>> +             fp->durable_scavenger_timeout =3D
> >>> +                     jiffies_to_msecs(jiffies) + fp->durable_timeout=
;
> >>> +
> >>>        return true;
> >>>    }
> >>>
> >>> diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
> >>> index 5a225e7055f1..f2ab1514e81a 100644
> >>> --- a/fs/smb/server/vfs_cache.h
> >>> +++ b/fs/smb/server/vfs_cache.h
> >>> @@ -101,6 +101,7 @@ struct ksmbd_file {
> >>>        struct list_head                lock_list;
> >>>
> >>>        int                             durable_timeout;
> >>> +     int                             durable_scavenger_timeout;
> >>>
> >>>        /* if ls is happening on directory, below is valid*/
> >>>        struct ksmbd_readdir_data       readdir_data;
> >
