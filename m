Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1456C2BCF68
	for <linux-cifs@vger.kernel.org>; Mon, 23 Jun 2025 17:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750699752; cv=none; b=T/4CrxA9Vey58gcCV3a3OrimfHpj942F5er0tx4z8HdkM+63kRJ/0G1SW3J9WwGT8chZVMlwhS8oGMk3u4Es4T2jc5bwYeqZURJsWSL6KhHpTdOdaosmpPyFWceUwDaLEK5QxdyEmwzcrHdD9MfbKtlIfGVXhpkXnyCv+wNr/Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750699752; c=relaxed/simple;
	bh=44v8KwfJ7eVqF6fq1/JlIiFyJslDnt3ASowogNWlCes=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P/96CIpGhDLMh3ahIh3uGMl6eFIwRPRV6iwpn6MiM3tBRu6C9AqU7SSCHVHcDksIQh9qbNNckysOS4GENFYAblEWc6SXswLip6rdJLT7nBlroN/6GAOIajl+7FHOeuibyVWk5tkVQbbI/0AVXHwn2chSp3GYrpKf2VoOLyJ6b54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bP4N7m6f; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bP4N7m6f"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6faf66905baso67856396d6.2
        for <linux-cifs@vger.kernel.org>; Mon, 23 Jun 2025 10:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750699749; x=1751304549; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5FOi8QiozKqGsHtkVlysu3EKhkFTr/NGiEaQyN3y940=;
        b=bP4N7m6fz5LeK1Vu6AXN3xEb+RzEudn9PspOZcMz9/OBCMtBppYAL15Du23F5yX/Cs
         yujPR9oLPFKaKMLWo1s9crmfm2Zir1dyxjh1vwMM9Y6+z1/FT94b/0JGHI/XZhtVfnHM
         QKaxKYphxZO1wwWHajId3+tZdfScOAH51LdSl8VLs3zIXE9EbNRo4PUjerWwVCSYkBoW
         5rV2Z7re7MaRdxJXBWWYn2iri88UVW5iXTrR0e6wwcLz/efvtLTp4DUeibkSitAnjbKC
         CT1KZfaJwLheZH01gVSfc7TcVIp/f2lDAWGri8Hun+9IHE6geNz5b5EfugiEdHxxjn6Y
         pfWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750699749; x=1751304549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5FOi8QiozKqGsHtkVlysu3EKhkFTr/NGiEaQyN3y940=;
        b=Msyqs99O5nETM4LfpX5ZZzoAO7i3+oEjs0Jm7ePkvmd6azMGJHesF0sL44zNRp/3dX
         rtwu5A2mSWlDrvx00JZBhTMv5aegY+VClgUSAoLx4nVyWbz2JLOEXKj1wVqUDU8Ymd5I
         RCfp9PrFhaFqQnS8SXi0W3bni9IcGr1WnTzX7pEUzBxU/KCTQ4gjPOGHB9h5mi7vwciN
         PgtDGYrCVxrChkTdU+XC1Sf1XZV6CIxa0Wr7vPDG20858Ih3WYVE6lNkPAO/KwEPintf
         w20aT6vfVsrpq0vvY0nRsph1667muDPOXQlf+jx/lw00OkgGVIyEwVhNaMf7d8tpYc9d
         zvzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZ2EUkGCxB900lrrLSxjntV4nJ9TLldOHLs9X+G9AAjtKslsAH9dcpv3COeuOZ+u/MsayV9XnDt8Og@vger.kernel.org
X-Gm-Message-State: AOJu0YwkOWQtCqFciKcq1oOBE7dY9QIlkPRqou//mpEHMowI7P/Bnt5A
	nxxY4WyaaBR0QucNaF2AUvqgfIZQ7CR6BxZH9zQAanUvxrit3To++7t5Fw0InDfkeXWVVo2Uxn8
	APELJOeFpIQ36z0Hx60wDWgufezGRl2Q=
X-Gm-Gg: ASbGnctESKMtbqDGQqU/J3kyLawuA8a097kK7YvssFCcdbCK6wVHEaYoo7zkN5p+brX
	NYexTvUWTIyiy85DIvJuN/9BrMU1+gjfn6VP5q2WDMnH9QxkI7MHtZ7yMiWbmcbRKGz3Pb8Enma
	X7jUoZWNzYhadCIEfhZ17/5SWVw5+GOWuweo+OXw69bPCm9vgP6BYF9xgoZispntIeBgjDwVDLz
	q+KAg==
X-Google-Smtp-Source: AGHT+IGa6wNW+m7s3C4PiXr0LxEFxdoUGxkYd1W/8KgS2TvPp/Yaipyb1ENcCE59/V0da+Hrwgb3hHLIa4fRzNdg/yI=
X-Received: by 2002:a05:6214:5b81:b0:6f2:d45c:4a35 with SMTP id
 6a1803df08f44-6fd0a5c09ddmr245470916d6.37.1750699748654; Mon, 23 Jun 2025
 10:29:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1750264849.git.metze@samba.org> <8ecf5dc585af7abb37f3fabac6eb0f9f3273da85.1750264849.git.metze@samba.org>
 <e07c9bab-5750-4a50-8b38-4ce8c1a214d6@talpey.com> <a3073003-7f07-449d-8abf-dbe125ca3779@samba.org>
In-Reply-To: <a3073003-7f07-449d-8abf-dbe125ca3779@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 23 Jun 2025 12:28:56 -0500
X-Gm-Features: Ac12FXwYr_1xbFBj1liBVf1AuVMyhgglJZL45MNOGn5Vih5vwgfzL4pfOuq04qs
Message-ID: <CAH2r5mtqRX_pC+dCCFf44=m58vujkDJJLnZBGypycNfRSbj4DQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb: client: let smbd_post_send_iter() respect the
 peers max_send_size and transmit all data
To: Stefan Metzmacher <metze@samba.org>, Sasha Levin <sashal@kernel.org>
Cc: Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Checkpatch will complain if you put a diff in the description so I
suspect a link in the mainline patch description to the stable
backported version of the patch is better than a diff in the
description.

Sasha,
What is your preference for how to send a patch to mainline, that will
not apply to stable, but a rebased version of patch is available for
stable? Should the upstream patch have link to the stable rebased
version? or just handle it as followup on the stable mailing list?

On Mon, Jun 23, 2025 at 10:52=E2=80=AFAM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> Hi Tom,
>
> > On 6/18/2025 12:51 PM, Stefan Metzmacher wrote:
> >> We should not send smbdirect_data_transfer messages larger than
> >> the negotiated max_send_size, typically 1364 bytes, which means
> >> 24 bytes of the smbdirect_data_transfer header + 1340 payload bytes.
> >>
> >> This happened when doing an SMB2 write with more than 1340 bytes
> >> (which is done inline as it's below rdma_readwrite_threshold).
> >>
> >> It means the peer resets the connection.
> >
> > Obviously needs fixing but I'm unclear on the proposed change.
> > See below.
> >
> >> Note for stable sp->max_send_size needs to be info->max_send_size:
> >
> > So this is important and maybe needs more than this comment, which
> > is not really something that should go upstream since future stable
> > kernels won't apply. Recommend deleting this and sending a separate
> > patch.
>
> I can skip it, but I think it might be very useful for
> the one who needs to do the conflict resolution for the backport.
>
> Currently master is the only branch that has 'sp->',
> so all current backports will need the change.
>
> @Steve what would you prefer? Should I remove the hint and
> conflict resolution diff? In the past I saw something similar
> in merge requests send to Linus in order to make it easier for
> him to resolve the git conflicts.
>
> As it's preferred to backport fixes from master, I don't
> think it's a good idea to send a separate patch for the backports.
>
> >>    @@ -895,7 +895,7 @@ static int smbd_post_send_iter(struct smbd_conn=
ection *info,
> >>                            .direction      =3D DMA_TO_DEVICE,
> >>                    };
> >>                    size_t payload_len =3D min_t(size_t, *_remaining_da=
ta_length,
> >>    -                                          sp->max_send_size - size=
of(*packet));
> >>    +                                          info->max_send_size - si=
zeof(*packet));
> >>
> >>                    rc =3D smb_extract_iter_to_rdma(iter, payload_len,
> >>                                                  &extract);
> >>
> >> cc: Steve French <sfrench@samba.org>
> >> cc: David Howells <dhowells@redhat.com>
> >> cc: Tom Talpey <tom@talpey.com>
> >> cc: linux-cifs@vger.kernel.org
> >> Fixes: 3d78fe73fa12 ("cifs: Build the RDMA SGE list directly from an i=
terator")
> >> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> >> ---
> >>   fs/smb/client/smbdirect.c | 18 ++++++++++++++----
> >>   1 file changed, 14 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> >> index cbc85bca006f..3a41dcbbff81 100644
> >> --- a/fs/smb/client/smbdirect.c
> >> +++ b/fs/smb/client/smbdirect.c
> >> @@ -842,7 +842,7 @@ static int smbd_post_send(struct smbd_connection *=
info,
> >>   static int smbd_post_send_iter(struct smbd_connection *info,
> >>                      struct iov_iter *iter,
> >> -                   int *_remaining_data_length)
> >> +                   unsigned int *_remaining_data_length)
> >>   {
> >>       struct smbdirect_socket *sc =3D &info->socket;
> >>       struct smbdirect_socket_parameters *sp =3D &sc->parameters;
> >> @@ -907,8 +907,10 @@ static int smbd_post_send_iter(struct smbd_connec=
tion *info,
> >>               .local_dma_lkey    =3D sc->ib.pd->local_dma_lkey,
> >>               .direction    =3D DMA_TO_DEVICE,
> >>           };
> >> +        size_t payload_len =3D min_t(size_t, *_remaining_data_length,
> >> +                       sp->max_send_size - sizeof(*packet));
> >> -        rc =3D smb_extract_iter_to_rdma(iter, *_remaining_data_length=
,
> >> +        rc =3D smb_extract_iter_to_rdma(iter, payload_len,
> >>                             &extract);
> >>           if (rc < 0)
> >>               goto err_dma;
> >> @@ -970,8 +972,16 @@ static int smbd_post_send_iter(struct smbd_connec=
tion *info,
> >>       request->sge[0].lkey =3D sc->ib.pd->local_dma_lkey;
> >>       rc =3D smbd_post_send(info, request);
> >> -    if (!rc)
> >> +    if (!rc) {
> >> +        if (iter && iov_iter_count(iter) > 0) {
> >> +            /*
> >> +             * There is more data to send
> >> +             */
> >> +            goto wait_credit;
> >
> > But, shouldn't the caller have done this overflow check, and looped on
> > the fragments and credits? It seems wrong to push the credit check down
> > to this level.
>
> At least for the caller I guess we want a function that sends
> the whole iter and smbd_post_send_iter() only gets the iter as argument
> with an implicit length.
>
> To avoid this 'goto wait_credit', we could something like this in
> the caller:
>
>   fs/smb/client/smbdirect.c | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index 3a41dcbbff81..e0ba9395ff42 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -2042,17 +2042,24 @@ int smbd_send(struct TCP_Server_Info *server,
>                         klen +=3D rqst->rq_iov[i].iov_len;
>                 iov_iter_kvec(&iter, ITER_SOURCE, rqst->rq_iov, rqst->rq_=
nvec, klen);
>
> -               rc =3D smbd_post_send_iter(info, &iter, &remaining_data_l=
ength);
> +               while (iov_iter_count(&iter) > 0) {
> +                       rc =3D smbd_post_send_iter(info, &iter,
> +                                                &remaining_data_length);
> +                       if (rc < 0)
> +                               break;
> +               }
>                 if (rc < 0)
>                         break;
>
> -               if (iov_iter_count(&rqst->rq_iter) > 0) {
> +               while (iov_iter_count(&rqst->rq_iter) > 0) {
>                         /* And then the data pages if there are any */
>                         rc =3D smbd_post_send_iter(info, &rqst->rq_iter,
>                                                  &remaining_data_length);
>                         if (rc < 0)
>                                 break;
>                 }
> +               if (rc < 0)
> +                       break;
>
>         } while (++rqst_idx < num_rqst);
>
>
> But to me that also doesn't look pretty.
>
> Or we rename the current smbd_post_send_iter() to smbd_post_send_iter_chu=
nk()
> and implement smbd_post_send_iter() as a loop over smbd_post_send_iter_ch=
unk().
>
> I think currently we want a small patch to actually fix the regression.
>
> >> +        }
> >> +
> >>           return 0;
> >> +    }
> >>   err_dma:
> >>       for (i =3D 0; i < request->num_sge; i++)
> >> @@ -1007,7 +1017,7 @@ static int smbd_post_send_iter(struct smbd_conne=
ction *info,
> >>    */
> >>   static int smbd_post_send_empty(struct smbd_connection *info)
> >>   {
> >> -    int remaining_data_length =3D 0;
> >> +    unsigned int remaining_data_length =3D 0;
> >
> > Does this fix something??
>
> I guess if I use umin() (as proposed by David) we don't strictly need tha=
t
> change.
>
> So I'd prefer to go with skipping the int vs unsigned change and use
> umin() and keep the of the patch as is.
>
> Thanks!
> metze
>


--=20
Thanks,

Steve
