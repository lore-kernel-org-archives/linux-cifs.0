Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A40EB64D7
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jun 2023 05:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjFZFlI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Jun 2023 01:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjFZFlH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Jun 2023 01:41:07 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35727116
        for <linux-cifs@vger.kernel.org>; Sun, 25 Jun 2023 22:41:06 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4fb7589b187so576806e87.1
        for <linux-cifs@vger.kernel.org>; Sun, 25 Jun 2023 22:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687758064; x=1690350064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4vf3fR6u3CI/8YxGO36YgZM6hu24OQKH60uF6uXDmnY=;
        b=O18hPQqbEYaKvQQ9EZLVzdWvpYD/3PgHKzuToTIGpIFh5/RX3fkPsjaNmaycACxjIy
         OLpWiNKX0SubYc9RV7GB574qMi8WjOjGZIEor6QXH5dxP1yL/5K6gXj+02OQ+0PdpRau
         wdmq0P5aFPKmWnKsUWlJ/by616LQcG2dBgAka2uIewfoZnku8q7jLh0WRG/s4C0Blyqa
         DDgDsSpVuXgRRk68i9ahM9fsN7eUJVODS2Q6IhfBRcnBAl1SsoLkmy2tSTLPB0uuRfqE
         lhx8pA3AyR/3x7I8RE3VcrOHgvw4UluuOT2hX+EMfvrq5oGOrfHMOTIcm/KtwE95S4HR
         Gj5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687758064; x=1690350064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4vf3fR6u3CI/8YxGO36YgZM6hu24OQKH60uF6uXDmnY=;
        b=DIu5reJD/8yn8SlbB/BfQKh3NJS85M9jODdAB9AgcX1QxbvpbaiXzrAUclbSRun/3Q
         pDc1tz0Ld7GxzJNJnR5E1sTA2VKG5ufts/IwZj5N2m/g/PAEcQ7XyVZgScwc8u2bHGBQ
         j/dP28Ze5V4CVc6gxBVGtMQH/qIxv6BN9/Alb1UAFLLJhDAExEfXfPIKXUx+aPPyd5/4
         5n+B2Ms4WjQd+gHZDwbz1QkuzvxzOUK0Rerrm2HfopfPYwEbbcmpBQiIq0WxLk2EMSjt
         PyTWMXobHtFcM+sZjhY9ninAtySv6uhT8Ql80iXTZSJqAoGLBFzd+ZSWPEXHGaYjPWHi
         S8aA==
X-Gm-Message-State: AC+VfDyxpaD0NPUCQuAMCgWcXfjLe7/VNmDf0pdzstZ4guvBR+kwwH/J
        zH7IGecmE11x1q5tENsoQ37FQDg2BiHebbTUBjmvhruZ9aM9Fg==
X-Google-Smtp-Source: ACHHUZ7AxSaB4Y7UXwz6C5chJ1b/6VxgNU1VPawelvcBg8t/7exc/JzbsWwnzCNyFT75jDlMl5EY77pN1N/Ox4+JmB0=
X-Received: by 2002:ac2:5058:0:b0:4f9:5663:584b with SMTP id
 a24-20020ac25058000000b004f95663584bmr9927890lfm.42.1687758064108; Sun, 25
 Jun 2023 22:41:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230609174659.60327-1-sprasad@microsoft.com> <20230609174659.60327-5-sprasad@microsoft.com>
 <b44d580c-6237-bccb-a9e1-2d5bdd2db35f@talpey.com>
In-Reply-To: <b44d580c-6237-bccb-a9e1-2d5bdd2db35f@talpey.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 26 Jun 2023 11:10:53 +0530
Message-ID: <CANT5p=p6rRrUa-vo-3JMC9NwTu5fy6RU4aquQL5CJdLNmHuA3w@mail.gmail.com>
Subject: Re: [PATCH 5/6] cifs: fix max_credits implementation
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        bharathsm.hsk@gmail.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jun 23, 2023 at 9:30=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 6/9/2023 1:46 PM, Shyam Prasad N wrote:
> > The current implementation of max_credits on the client does
> > not work because the CreditRequest logic for several commands
> > does not take max_credits into account.
> >
> > Still, we can end up asking the server for more credits, depending
> > on the number of credits in flight. For this, we need to
> > limit the credits while parsing the responses too.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >   fs/smb/client/smb2ops.c |  2 ++
> >   fs/smb/client/smb2pdu.c | 32 ++++++++++++++++++++++++++++----
> >   2 files changed, 30 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index 43162915e03c..18faf267c54d 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -34,6 +34,8 @@ static int
> >   change_conf(struct TCP_Server_Info *server)
> >   {
> >       server->credits +=3D server->echo_credits + server->oplock_credit=
s;
> > +     if (server->credits > server->max_credits)
> > +             server->credits =3D server->max_credits;
> >       server->oplock_credits =3D server->echo_credits =3D 0;
> >       switch (server->credits) {
> >       case 0:
> > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> > index 7063b395d22f..17fe212ab895 100644
> > --- a/fs/smb/client/smb2pdu.c
> > +++ b/fs/smb/client/smb2pdu.c
> > @@ -1305,7 +1305,12 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *se=
ss_data)
> >       }
> >
> >       /* enough to enable echos and oplocks and one max size write */
> > -     req->hdr.CreditRequest =3D cpu_to_le16(130);
> > +     if (server->credits >=3D server->max_credits)
> > +             req->hdr.CreditRequest =3D cpu_to_le16(0);
> > +     else
> > +             req->hdr.CreditRequest =3D cpu_to_le16(
> > +                     min_t(int, server->max_credits -
> > +                           server->credits, 130));
>
> This identical processing appears several times below. It would be
> very bad if the copies got out of sync. Let's factor these as a
> single function, perhaps inline but it might make sense as a client
> common entry.
>
> Tom.
>

Thanks for the review, Tom.
I'll prepare an updated patch.

>
> >       /* only one of SMB2 signing flags may be set in SMB2 request */
> >       if (server->sign)
> > @@ -1899,7 +1904,12 @@ SMB2_tcon(const unsigned int xid, struct cifs_se=
s *ses, const char *tree,
> >       rqst.rq_nvec =3D 2;
> >
> >       /* Need 64 for max size write so ask for more in case not there y=
et */
> > -     req->hdr.CreditRequest =3D cpu_to_le16(64);
> > +     if (server->credits >=3D server->max_credits)
> > +             req->hdr.CreditRequest =3D cpu_to_le16(0);
> > +     else
> > +             req->hdr.CreditRequest =3D cpu_to_le16(
> > +                     min_t(int, server->max_credits -
> > +                           server->credits, 64));
> >
> >       rc =3D cifs_send_recv(xid, ses, server,
> >                           &rqst, &resp_buftype, flags, &rsp_iov);
> > @@ -4227,6 +4237,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
> >       struct TCP_Server_Info *server;
> >       struct cifs_tcon *tcon =3D tlink_tcon(rdata->cfile->tlink);
> >       unsigned int total_len;
> > +     int credit_request;
> >
> >       cifs_dbg(FYI, "%s: offset=3D%llu bytes=3D%u\n",
> >                __func__, rdata->offset, rdata->bytes);
> > @@ -4258,7 +4269,13 @@ smb2_async_readv(struct cifs_readdata *rdata)
> >       if (rdata->credits.value > 0) {
> >               shdr->CreditCharge =3D cpu_to_le16(DIV_ROUND_UP(rdata->by=
tes,
> >                                               SMB2_MAX_BUFFER_SIZE));
> > -             shdr->CreditRequest =3D cpu_to_le16(le16_to_cpu(shdr->Cre=
ditCharge) + 8);
> > +             credit_request =3D le16_to_cpu(shdr->CreditCharge) + 8;
> > +             if (server->credits >=3D server->max_credits)
> > +                     shdr->CreditRequest =3D cpu_to_le16(0);
> > +             else
> > +                     shdr->CreditRequest =3D cpu_to_le16(
> > +                             min_t(int, server->max_credits -
> > +                                             server->credits, credit_r=
equest));
> >
> >               rc =3D adjust_credits(server, &rdata->credits, rdata->byt=
es);
> >               if (rc)
> > @@ -4468,6 +4485,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
> >       unsigned int total_len;
> >       struct cifs_io_parms _io_parms;
> >       struct cifs_io_parms *io_parms =3D NULL;
> > +     int credit_request;
> >
> >       if (!wdata->server)
> >               server =3D wdata->server =3D cifs_pick_channel(tcon->ses)=
;
> > @@ -4572,7 +4590,13 @@ smb2_async_writev(struct cifs_writedata *wdata,
> >       if (wdata->credits.value > 0) {
> >               shdr->CreditCharge =3D cpu_to_le16(DIV_ROUND_UP(wdata->by=
tes,
> >                                                   SMB2_MAX_BUFFER_SIZE)=
);
> > -             shdr->CreditRequest =3D cpu_to_le16(le16_to_cpu(shdr->Cre=
ditCharge) + 8);
> > +             credit_request =3D le16_to_cpu(shdr->CreditCharge) + 8;
> > +             if (server->credits >=3D server->max_credits)
> > +                     shdr->CreditRequest =3D cpu_to_le16(0);
> > +             else
> > +                     shdr->CreditRequest =3D cpu_to_le16(
> > +                             min_t(int, server->max_credits -
> > +                                             server->credits, credit_r=
equest));
> >
> >               rc =3D adjust_credits(server, &wdata->credits, io_parms->=
length);
> >               if (rc)



--=20
Regards,
Shyam
