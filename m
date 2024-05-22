Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B9D22086
	for <linux-cifs@vger.kernel.org>; Wed, 22 May 2024 05:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716354830; cv=none; b=WxZFNpqBmwyc14bBot6IB6JAwmy2vhltCwgf/f9LllWfsz4wjLKxZE7ccgH9XdfcGjVbK6Hwy8I+kRK9cLRiIWq1lZV3IwWjzGi1wCr7xWrSUvE1gjtUNR7OjkkINhSY7DkGFwTlWgGCxcGUSJlRC2/huqc1t1Vufowx8fAzOG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716354830; c=relaxed/simple;
	bh=RebkF30i6qikjvKm0BWWXOLqUQ6I2CDKexDO4uDVMdI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qzhUUpo7QimPtI6iRSveaSiy8YwexVYLmrrcSkWEk9s5HodRyOKZdcXVUm9gk61K36+HmWNChyEjZkWVEK8Y9zTYhWzOxLclOt210hzoad/TTg6UXB7VEXxp0e3MogO/T3eszrGfbl/fDF2aOuWUZ/xLsLEA01KXtRCwLyZ5CzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J6wR5/sJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J6wR5/sJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1FEC32781
	for <linux-cifs@vger.kernel.org>; Wed, 22 May 2024 05:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716354829;
	bh=RebkF30i6qikjvKm0BWWXOLqUQ6I2CDKexDO4uDVMdI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=J6wR5/sJ3FFzCvNxmlwdxtFx64X5/HTfxyRf2QodEEHH9sJNLcaN2RmUEmLRqHXJm
	 29ViMbsGZiVRY+nVOL3vsmidXzzne+U5yJZ1z8wBOlxVndqi5oW0HNM2YRpli5x2XB
	 vlpejSwO4Ts4sNDmYy6+nxIgb1pQEeWqR+z2mr7poufAlXT11dBvCQlbRELZlcCZPV
	 6wTS8yk/Wv838A/ahIBmhVDohwjZ3c3+CUS0gqd/4Ia0JwtwuRp05F1X9Aa2BsZMIB
	 sAnb0lhrd2EqiUj/CS5T9IpYcoxOYxyrVFv+lLRbKsR86Zu+wqpOBtsASMF4jxiAyv
	 MKmHeiofPVgGg==
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6f10092c8c7so3072105a34.1
        for <linux-cifs@vger.kernel.org>; Tue, 21 May 2024 22:13:49 -0700 (PDT)
X-Gm-Message-State: AOJu0YxMuhZN3m0hcatEHRrxIGBHpQw5mv+me2cY2X7xpRv4m5dOFbO0
	NWeSyJn1BsV+d2lN20IP0AT8Iy3jHLUSt4AESEWMcAA3ONdJd+z0mpDk5/5xjgNzSsawcKiRyil
	05NPaAtVNKVPSCrsKIBuWGL0sJik=
X-Google-Smtp-Source: AGHT+IFXh0WNqwXngPgTdnV+y2eQzuvfHXeWebguegevXqVkYJGG7t98/a7HUrdrEufukgH7chW1wJWgdQjZZkCJbr0=
X-Received: by 2002:a05:6830:1490:b0:6ef:9156:c814 with SMTP id
 46e09a7af769-6f66a59e3f3mr1475194a34.32.1716354828578; Tue, 21 May 2024
 22:13:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240521135753.5108-1-linkinjeon@kernel.org> <c67c96ed-c9e6-4689-8f68-d56ddab71708@talpey.com>
In-Reply-To: <c67c96ed-c9e6-4689-8f68-d56ddab71708@talpey.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 22 May 2024 14:13:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9iXrmh17gutKYPFGs31vBwN94HOGd-fvVCo66RQnazUw@mail.gmail.com>
Message-ID: <CAKYAXd9iXrmh17gutKYPFGs31vBwN94HOGd-fvVCo66RQnazUw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: avoid reclaiming expired durable opens by the client
To: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2024=EB=85=84 5=EC=9B=94 22=EC=9D=BC (=EC=88=98) =EC=98=A4=EC=A0=84 12:10, =
Tom Talpey <tom@talpey.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On 5/21/2024 9:57 AM, Namjae Jeon wrote:
> > The expired durable opens should not be reclaimed by client.
> > This patch add ->durable_scavenger_timeout to fp and check it in
> > ksmbd_lookup_durable_fd().
> >
> > Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> > ---
> >   fs/smb/server/vfs_cache.c | 9 ++++++++-
> >   fs/smb/server/vfs_cache.h | 1 +
> >   2 files changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
> > index 6cb599cd287e..a6804545db28 100644
> > --- a/fs/smb/server/vfs_cache.c
> > +++ b/fs/smb/server/vfs_cache.c
> > @@ -476,7 +476,10 @@ struct ksmbd_file *ksmbd_lookup_durable_fd(unsigne=
d long long id)
> >       struct ksmbd_file *fp;
> >
> >       fp =3D __ksmbd_lookup_fd(&global_ft, id);
> > -     if (fp && fp->conn) {
> > +     if (fp && (fp->conn ||
> > +                (fp->durable_scavenger_timeout &&
> > +                 (fp->durable_scavenger_timeout <
> > +                  jiffies_to_msecs(jiffies))))) {
>
> Do I understand correctly that this case means the fd is valid,
> and only the durable timeout has been exceeded?
Yes.
>
> If so, I believe it is overly strict behavior. MS-SMB2 specifically
> states that the timer is a lower bound:
>
> > 3.3.2.2 Durable Open Scavenger Timer This timer controls the amount
> > of time the server keeps a durable handle active after the
> > underlying transport connection to the client is lost.<210> The
> > server MUST keep the durable handle active for at least this amount
> > of time, except in the cases of an oplock break indicated by the
> > object store as specified in section 3.3.4.6, administrative actions,
> > or resource constraints.
> What defect does this patch fix?
Durable open scavenger timer has not been added yet.
I will be adding this timer with this next patch. Nonetheless, this
patch is needed.
i.e. we need both ones.
Thanks!
>
> Tom.
>
>
> >               ksmbd_put_durable_fd(fp);
> >               fp =3D NULL;
> >       }
> > @@ -717,6 +720,10 @@ static bool session_fd_check(struct ksmbd_tree_con=
nect *tcon,
> >       fp->tcon =3D NULL;
> >       fp->volatile_id =3D KSMBD_NO_FID;
> >
> > +     if (fp->durable_timeout)
> > +             fp->durable_scavenger_timeout =3D
> > +                     jiffies_to_msecs(jiffies) + fp->durable_timeout;
> > +
> >       return true;
> >   }
> >
> > diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
> > index 5a225e7055f1..f2ab1514e81a 100644
> > --- a/fs/smb/server/vfs_cache.h
> > +++ b/fs/smb/server/vfs_cache.h
> > @@ -101,6 +101,7 @@ struct ksmbd_file {
> >       struct list_head                lock_list;
> >
> >       int                             durable_timeout;
> > +     int                             durable_scavenger_timeout;
> >
> >       /* if ls is happening on directory, below is valid*/
> >       struct ksmbd_readdir_data       readdir_data;
