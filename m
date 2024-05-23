Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B2C1DFF0
	for <linux-cifs@vger.kernel.org>; Thu, 23 May 2024 14:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716472818; cv=none; b=aVhF04nrCPVxUXIp1ew4Wnvj2EZecC7m+2R0lZ93HmBzFp0tyWrC6iJR3xMwhmMEa0vmH0/0xjVUBSIfoo2OoIEwnYjYiussAoZdd06nKqqvGA7pJwKVztailuq5z2Itdr3hiKyXwc++Ym+JZoDinCNd+vPxN/P9S2I0YjB104w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716472818; c=relaxed/simple;
	bh=7iDWotPTk6wvYwZz/b+pigjXxsUDcaeRmlyiLNJq17I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PPpwesJsP1sSBq4WvN7jytNV+Qmd0t4+GbOfTmjOORpnxbzi34Pe5FwOdxYZMEWX2avQSjYyzC7TAt7smo6t7XeLHhzz+l8JdBDufDzUaxFuLsXdAlrBHML9TTrHSTWqq9U+Cnba8DrRTMOqM09WVC0CqfY3NMvUBRxZR/BvGg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUac5bMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUac5bMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90222C3277B
	for <linux-cifs@vger.kernel.org>; Thu, 23 May 2024 14:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716472818;
	bh=7iDWotPTk6wvYwZz/b+pigjXxsUDcaeRmlyiLNJq17I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HUac5bMOl+BLlsai9RycSyVfNC7w9BtFKJJytDKOvIFHY0pO3PtnRTi+4bP8D31mA
	 EosvdIWqcs3SZHUB6crZN8vHVcR1G0VDf4Ha41vYXVyp3FJ2XqcSE7dQ0szfywzYqN
	 m3kiEh4iofPQxS6NMy4f2TD+SCw591xUXmgHBmyPv7PnaJnCYCGjMvCOGYKi/haLqm
	 vnZ1CLKcrZ9yCyihuu43tQpIFbNI0IwpZRCozDgMjWGdpruQcGcgb6PAuVRE+W5EDR
	 1G2nZaETGFDKYzrpxsFkFPUkTw/Ssf5ImBkl6PYHFjNinpIMFvoba6hr+bXKEKppfv
	 dC/en0PUw2H9g==
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5aa3f0fcd46so4241831eaf.1
        for <linux-cifs@vger.kernel.org>; Thu, 23 May 2024 07:00:18 -0700 (PDT)
X-Gm-Message-State: AOJu0YxMKpUSPvQjMtUKDQ7ad1UEnXLGfiNsb3Zf2u9dx9jMzg3qZbDu
	7TJdAF+avpdsmQa9JOQS9VdkaB7BzCw0l/hcc5xxxzT9Np/M/dKhno/1tvcIpZLuCLtsVbk2HAg
	s/EBfu4sOM/KXxzFj32+JPPdnvWc=
X-Google-Smtp-Source: AGHT+IEX1l19TdUXl6tDG+XhfezXRyBLNCZhK8c3R9SPZJ2czb5l8KG8QtoTQ5K01OKqj5uAcvh8IGbhvGa2eN6lnXc=
X-Received: by 2002:a05:6820:168a:b0:5af:73b5:eb4c with SMTP id
 006d021491bc7-5b69e0e91f0mr5438114eaf.0.1716472817670; Thu, 23 May 2024
 07:00:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240521135753.5108-1-linkinjeon@kernel.org> <c67c96ed-c9e6-4689-8f68-d56ddab71708@talpey.com>
 <CAKYAXd9iXrmh17gutKYPFGs31vBwN94HOGd-fvVCo66RQnazUw@mail.gmail.com>
 <14fa6bf0-00e4-4716-8569-a85e411228eb@talpey.com> <CAKYAXd_NBDSmirpO45T0tgu9XCGr4MSK+DW=NCqGFLSe8uY06A@mail.gmail.com>
 <dd393a75-667e-4c5e-8f00-060b8a78da69@talpey.com>
In-Reply-To: <dd393a75-667e-4c5e-8f00-060b8a78da69@talpey.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 23 May 2024 23:00:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-d4hZjHRXSugrTmAM5ownxVRpWvePK641yyP-vhiyTrw@mail.gmail.com>
Message-ID: <CAKYAXd-d4hZjHRXSugrTmAM5ownxVRpWvePK641yyP-vhiyTrw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: avoid reclaiming expired durable opens by the client
To: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2024=EB=85=84 5=EC=9B=94 23=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 10:36, =
Tom Talpey <tom@talpey.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On 5/22/2024 7:31 PM, Namjae Jeon wrote:
> > 2024=EB=85=84 5=EC=9B=94 23=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 4:4=
7, Tom Talpey <tom@talpey.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
> >>
> >> On 5/22/2024 1:13 AM, Namjae Jeon wrote:
> >>> 2024=EB=85=84 5=EC=9B=94 22=EC=9D=BC (=EC=88=98) =EC=98=A4=EC=A0=84 1=
2:10, Tom Talpey <tom@talpey.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
> >>>>
> >>>> On 5/21/2024 9:57 AM, Namjae Jeon wrote:
> >>>>> The expired durable opens should not be reclaimed by client.
> >>>>> This patch add ->durable_scavenger_timeout to fp and check it in
> >>>>> ksmbd_lookup_durable_fd().
> >>>>>
> >>>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> >>>>> ---
> >>>>>     fs/smb/server/vfs_cache.c | 9 ++++++++-
> >>>>>     fs/smb/server/vfs_cache.h | 1 +
> >>>>>     2 files changed, 9 insertions(+), 1 deletion(-)
> >>>>>
> >>>>> diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
> >>>>> index 6cb599cd287e..a6804545db28 100644
> >>>>> --- a/fs/smb/server/vfs_cache.c
> >>>>> +++ b/fs/smb/server/vfs_cache.c
> >>>>> @@ -476,7 +476,10 @@ struct ksmbd_file *ksmbd_lookup_durable_fd(uns=
igned long long id)
> >>>>>         struct ksmbd_file *fp;
> >>>>>
> >>>>>         fp =3D __ksmbd_lookup_fd(&global_ft, id);
> >>>>> -     if (fp && fp->conn) {
> >>>>> +     if (fp && (fp->conn ||
> >>>>> +                (fp->durable_scavenger_timeout &&
> >>>>> +                 (fp->durable_scavenger_timeout <
> >>>>> +                  jiffies_to_msecs(jiffies))))) {
> >>>>
> >>>> Do I understand correctly that this case means the fd is valid,
> >>>> and only the durable timeout has been exceeded?
> >>> Yes.
> >>>>
> >>>> If so, I believe it is overly strict behavior. MS-SMB2 specifically
> >>>> states that the timer is a lower bound:
> >>>>
> >>>>> 3.3.2.2 Durable Open Scavenger Timer This timer controls the amount
> >>>>> of time the server keeps a durable handle active after the
> >>>>> underlying transport connection to the client is lost.<210> The
> >>>>> server MUST keep the durable handle active for at least this amount
> >>>>> of time, except in the cases of an oplock break indicated by the
> >>>>> object store as specified in section 3.3.4.6, administrative action=
s,
> >>>>> or resource constraints.
> >>>> What defect does this patch fix?
> >>> Durable open scavenger timer has not been added yet.
> >>> I will be adding this timer with this next patch. Nonetheless, this
> >>> patch is needed.
> >>> i.e. we need both ones.
> >>
> >> So this code has no effect until then? And presumably, the scavenger
> >> will be closing the fd, so it won't have any effect later, either.
> > Not at all. We can first take steps to prevent the timeout of durable v=
2
> > open from being used. There is absolutely no harm in this.
>
> I disagree with "no harm".
>
> As I said, the new behavior is more strict than MS-SMB2, and therefore
> also stricter than Windows behavior.
>
> Additionally, in the absence of a yet-to-be-written scavenger, this
> means that fd's will remain cached and unclosed by ksmbd. The client,
> in turn, will reopen the file, which seems like a source of sharing
> violations, which become unrecallable in fact.
Okay, I understood your point. I will apply this patch with durable
scavenger timer.

>
> Finally, from a code standpoint, I still don't see why it's being
> added before the scavenger functionality is even ready to review.
Okay. Thanks for pointing this out:)

>
> Tom.
>
> > Thanks.
> >>
> >> The patch should not be applied at this time, and the full change
> >> should be reviewed when it's ready.
> >>
> >> Tom.
> >>
> >>> Thanks!
> >>>>
> >>>> Tom.
> >>>>
> >>>>
> >>>>>                 ksmbd_put_durable_fd(fp);
> >>>>>                 fp =3D NULL;
> >>>>>         }
> >>>>> @@ -717,6 +720,10 @@ static bool session_fd_check(struct ksmbd_tree=
_connect *tcon,
> >>>>>         fp->tcon =3D NULL;
> >>>>>         fp->volatile_id =3D KSMBD_NO_FID;
> >>>>>
> >>>>> +     if (fp->durable_timeout)
> >>>>> +             fp->durable_scavenger_timeout =3D
> >>>>> +                     jiffies_to_msecs(jiffies) + fp->durable_timeo=
ut;
> >>>>> +
> >>>>>         return true;
> >>>>>     }
> >>>>>
> >>>>> diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
> >>>>> index 5a225e7055f1..f2ab1514e81a 100644
> >>>>> --- a/fs/smb/server/vfs_cache.h
> >>>>> +++ b/fs/smb/server/vfs_cache.h
> >>>>> @@ -101,6 +101,7 @@ struct ksmbd_file {
> >>>>>         struct list_head                lock_list;
> >>>>>
> >>>>>         int                             durable_timeout;
> >>>>> +     int                             durable_scavenger_timeout;
> >>>>>
> >>>>>         /* if ls is happening on directory, below is valid*/
> >>>>>         struct ksmbd_readdir_data       readdir_data;
> >>>
> >
