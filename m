Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD7CC433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 08:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F21A561130
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 08:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbhJFIi2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Oct 2021 04:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237543AbhJFIi2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Oct 2021 04:38:28 -0400
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736E3C061749
        for <linux-cifs@vger.kernel.org>; Wed,  6 Oct 2021 01:36:36 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id 14so859647vkq.10
        for <linux-cifs@vger.kernel.org>; Wed, 06 Oct 2021 01:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KUvYhh4j7bs2FRdHt/q2bKZUEegzulCQ4SXCNGbgfy0=;
        b=TzQXNnoynMqsR9EH8c9fgQ+MM3Ag4wLkWaEnWMvzRgYk1XuosJJg/RDa5dA72Yjanc
         2E+20Y4b0NJ4b9DpWH81q4Vo7dxna5u0cQsPNBl39YWux1l3YDUQap14/0jonNOIjNW+
         qx1zW7S8tMkghLin+ZKnOSDgJStq07dBU6A5SDQAcAna6XNySfMFz1JY1ZDsqewDK034
         3WtskraHf9t3K9z2ig+qLzZFy8pzb+vJu4uzByw41lAx/2HwHCiXTqVSOb8XEzHwv40b
         PXv9VO/hjhgNNAh6AANAujr/vJrlLtjaGirIUnnhmEpLAmzGnzOAyDGUX/NhcOgZH8zA
         sj5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KUvYhh4j7bs2FRdHt/q2bKZUEegzulCQ4SXCNGbgfy0=;
        b=NSsKP9pngSD6272ULkSam65mXbhjHK7o2KIGu+QLOVQW0YBnBmY8cSqe1FMuInGrwZ
         JLFo79imEfm+0PhAcw+PdOlEOe/LRmL09rYhj/hdp5s40I0aqwTmjwCEJBddxsQIiD/f
         v/4Oq/meBoINcbGUVg1yNszFhhQLNXwvm/DYiqQKG7n3RlQBzTripMMjjh4pIVB75slc
         HLC62P1wfq2IfM+NlhxeTqfHqsKRMCDpcQ1jgOwCnUcV1vP+MeN9bNMQ1QM/zmJdugaf
         yfklym3BL65b8j3o/5fHtwqy7Zp1TNFnw90/lSA6NcQkJJXyuq46oqEh/0M1V4s69tO5
         Uvtg==
X-Gm-Message-State: AOAM532rf6k3pjhwOPoQVL2HZpf5+mPBPfkQBlm9Gf8dVoYd4S/aWHJx
        Jbq8DQAVfxDyCpwrSr8q7oAUudViAXEpxb1VAb0CwhhWD1H+yJH5
X-Google-Smtp-Source: ABdhPJw6kJKXa2zLfShR1yDTlr4QPgDplGLBq8603PyWImBKb6r88T41cso/5RkNxi9K8+3dMKCGo370Uek89QcbZj8=
X-Received: by 2002:a1f:1841:: with SMTP id 62mr24132044vky.26.1633509395537;
 Wed, 06 Oct 2021 01:36:35 -0700 (PDT)
MIME-Version: 1.0
References: <20211005100026.250280-1-hyc.lee@gmail.com> <CAKYAXd9KuopMe8B_BrjxXDv+XZe6=_uWXoNXv6_f8YxYMAiTiA@mail.gmail.com>
 <CANFS6baHtcO5gHSC=c76nTHn65ObAACJMq0c5uhxsxPuyEEOiw@mail.gmail.com> <CAKYAXd9_VjDDBAbDZqoM=bpjmxEnhh3Q0QbFaKHT3iLO9Z85nQ@mail.gmail.com>
In-Reply-To: <CAKYAXd9_VjDDBAbDZqoM=bpjmxEnhh3Q0QbFaKHT3iLO9Z85nQ@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Wed, 6 Oct 2021 17:36:24 +0900
Message-ID: <CANFS6bY8p=S7+VvZUrcuZ1PV-eLsVyo9ti1TstCGheP1-+W7+w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: improve credits management
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Ralph Boehme <slow@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021=EB=85=84 10=EC=9B=94 6=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 3:52, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2021-10-06 15:27 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > 2021=EB=85=84 10=EC=9B=94 6=EC=9D=BC (=EC=88=98) =EC=98=A4=EC=A0=84 11:=
06, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
> >>
> >> [snip]
> >> >
> >> > -     if (credits_requested > 0) {
> >> > +     /* We must grant 0 credit for the final response of an
> >> > asynchronous
> >> > +      * operation.
> >> > +      */
> >> > +     if ((hdr->Flags & SMB2_FLAGS_ASYNC_COMMAND) && !work->multiRsp=
) {
> >> Can you elaborate what is this check ? especially this !work->multiRsp=
..
> >
> > According to 3.3.4.2 Sending an Interim Response for an Asynchronous
> > Operation
> > in MS-SMB2,
> > For the request that will be handled asynchronously,  a server should s=
end
> > an interim response, and grant credits to the interim response.
> > on the other hand, a server should grant 0 credit to the final response=
 for
> > the
> > request.
> >
> > "hdr->Flags & SMB2_FLAGS_ASYNC" means that a response is an interim
> > or final, and "work->multiRsp =3D=3D 0" means that a response is final.=
 So in
> > this
> > case, a server should grant 0 credit.
> Okay.
> >
> >> > +             credits_granted =3D 0;
> >> > +     } else {
> >> > +             /* according to smb2.credits smbtorture, Windows serve=
r
> >> > +              * 2016 or later grant up to 8192 credits at one.
> >> > +              */
> >> >               aux_credits =3D credits_requested - 1;
> >> > -             aux_max =3D 32;
> >> >               if (hdr->Command =3D=3D SMB2_NEGOTIATE)
> >> >                       aux_max =3D 0;
> >> > -             aux_credits =3D (aux_credits < aux_max) ? aux_credits =
:
> >> > aux_max;
> >> > -             credits_granted =3D aux_credits + credit_charge;
> >> > +             else
> >> > +                     aux_max =3D conn->max_credits - credit_charge;
> >> > +             aux_credits =3D min_t(unsigned short, aux_credits,
> >> > aux_max);
> >> > +             credits_granted =3D credit_charge + aux_credits;
> >> > +
> >> > +             if (conn->max_credits - conn->total_credits <
> >> > credits_granted)
> >> > +                     credits_granted =3D conn->max_credits -
> >> > +                             conn->total_credits;
> >> >
> >> > -             /* if credits granted per client is getting bigger tha=
n
> >> > default
> >> > -              * minimum credits then we should wrap it up within th=
e
> >> > limits.
> >> > -              */
> >> > -             if ((conn->total_credits + credits_granted) >
> >> > min_credits)
> >> > -                     credits_granted =3D min_credits -
> >> > conn->total_credits;
> >> >               /*
> >> >                * TODO: Need to adjuct CreditRequest value according =
to
> >> >                * current cpu load
> >> >                */
> >> > -     } else if (conn->total_credits =3D=3D 0) {
> >> > -             credits_granted =3D 1;
> >> >       }
> >> >
> >> >       conn->total_credits +=3D credits_granted;
> >> > @@ -371,7 +358,6 @@ int smb2_set_rsp_credits(struct ksmbd_work *work=
)
> >> >               /* Update CreditRequest in last request */
> >> >               hdr->CreditRequest =3D cpu_to_le16(work->credits_grant=
ed);
> >> >       }
> >> > -out:
> >> >       ksmbd_debug(SMB,
> >> >                   "credits: requested[%d] granted[%d]
> >> > total_granted[%d]\n",
> >> >                   credits_requested, credits_granted,
> >> > @@ -692,13 +678,18 @@ int setup_async_work(struct ksmbd_work *work,
> >> > void
> >> > (*fn)(void **), void **arg)
> >> >
> >> >  void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
> >> >  {
> >> > -     struct smb2_hdr *rsp_hdr;
> >> > +     struct smb2_hdr *rsp_hdr =3D work->response_buf;
> >> > +
> >> > +     work->multiRsp =3D 1;
> >> > +     if (status !=3D STATUS_CANCELLED) {
> >> > +             spin_lock(&work->conn->credits_lock);
> >> > +             smb2_set_rsp_credits(work);
> >> Can you explain why this code is needed in smb2_send_interim_resp() ?
> >>
> >
> > As I wrote above, a server should grant credits to an interim
> > response.
> Okay.
> >
> >> > +             spin_unlock(&work->conn->credits_lock);
> >> > +     }
> >> >
> >> > -     rsp_hdr =3D work->response_buf;
> >> >       smb2_set_err_rsp(work);
> >> >       rsp_hdr->Status =3D status;
> >> >
> >> > -     work->multiRsp =3D 1;
> >> >       ksmbd_conn_write(work);
> >> >       rsp_hdr->Status =3D 0;
> >> >       work->multiRsp =3D 0;
> >> > @@ -1233,6 +1224,7 @@ int smb2_handle_negotiate(struct ksmbd_work
> >> > *work)
> >> >
> >> >       conn->srv_sec_mode =3D le16_to_cpu(rsp->SecurityMode);
> >> >       ksmbd_conn_set_need_negotiate(work);
> >> > +     conn->total_credits =3D 0;
> >> This line is needed ?
> >
> > Yes, conn->total_credits becomes 0 when receiving a SMB2_NEGOTIATION
> > request. But init_smbX_X_server functions are called many times and
> > conn->total_credits is set to 1 in these functions while negotiation.
> If so, can we move conn->total_credits =3D 1 in  init_smbX_X_server() to
> ksmbd_conn_alloc() ?

Okay, I will move this into ksmbd_conn_alloc().
Thank you for your comments!

> >
> >>
> >> Thanks!
> >> >
> >> >  err_out:
> >> >       if (rc < 0)
> >> > --
> >> > 2.25.1
> >> >
> >> >
> >
> >
> >
> > --
> > Thanks,
> > Hyunchul
> >



--=20
Thanks,
Hyunchul
