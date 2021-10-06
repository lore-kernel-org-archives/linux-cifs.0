Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB47DC433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 06:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 830D460EC0
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 06:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhJFG33 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Oct 2021 02:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhJFG33 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Oct 2021 02:29:29 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C281BC061749
        for <linux-cifs@vger.kernel.org>; Tue,  5 Oct 2021 23:27:37 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id o124so1761326vsc.6
        for <linux-cifs@vger.kernel.org>; Tue, 05 Oct 2021 23:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=H8xcgOqT9DLv0yZ7RZBuXEvyPr4Zy6BhWGBqgKk/lYA=;
        b=qPA/w0rP1qNafNFkii2BNzjahPKRl+/4Ent97zsobflawQ1DK0OW1eFMpjGzo/jma8
         if1JrULaH6oKMMJWYVuGaot/xC5pHmTlo16/oSEEruXPN4RUTxvlp9UvlatU+mAJhi4r
         Ok/fS8cRWWvwwmAS0ZCNG+dmXCMqLcx2pvReyw/p13OcG0ONctPpupOJuo0nkCioSgqr
         CLTeELdn7wXLaVhjVyb/XNpzRv/zuuDD9A2FMSwqcXgtrGhb6HzkovXzYtDyFCUJMNha
         8LAkCtHNJN55zTqiPt8qzYNCUy3scU7vos+14lGLFsjLf9wZfVBZpzoES1cve5eIV9T1
         yYLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=H8xcgOqT9DLv0yZ7RZBuXEvyPr4Zy6BhWGBqgKk/lYA=;
        b=OyaswA8h3gUW3SKHJ2zcWU2qyIfSgej1mFjL+lwCtvwik4I5UlM/TUFaEyCJbo4mPE
         TCCxoR6HAT2NHPAJbOEL6WwHRx+WuaHsDljmZWS/B4iDP3H0KdDIhWv/H222fuJYw5Kb
         1Cg0uTE17AOoXjOFpCBI294UKSsSj2tzgk+/1+Vn8gBwX5mhiQhG/n3arnOKmYnQ4zVr
         9HxhKUfFgcI3HaNpslAxFAAXyxCiN2ERaR9SwCp7gIP6UMjOC5nA6cM6ZD90QQFRyfbz
         LAIbEr7v73hGgIkaX5XaqR9ex9OhsN+5bwkwkLWtwk6Mohg1MPlUOXBpMqZv8jA1Ec0x
         p7Ow==
X-Gm-Message-State: AOAM530GlY5XMMYhbfjjJDTsHY6DJQ4+khiMbICHBzQR2kKb4Cc37skh
        3rsfd7kS2UakMnK6EurL5dlxyiGdAMtJ7ZFouj4=
X-Google-Smtp-Source: ABdhPJwolsTEP4p2J3bpkQwb7iOtGWkPGJSyID4307JBXU5WtEJ78idLcgAKrUmQ6KTj5frmzMiCeFm7XUZ/TrM2OUU=
X-Received: by 2002:a67:c81a:: with SMTP id u26mr11497976vsk.27.1633501656880;
 Tue, 05 Oct 2021 23:27:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211005100026.250280-1-hyc.lee@gmail.com> <CAKYAXd9KuopMe8B_BrjxXDv+XZe6=_uWXoNXv6_f8YxYMAiTiA@mail.gmail.com>
In-Reply-To: <CAKYAXd9KuopMe8B_BrjxXDv+XZe6=_uWXoNXv6_f8YxYMAiTiA@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Wed, 6 Oct 2021 15:27:25 +0900
Message-ID: <CANFS6baHtcO5gHSC=c76nTHn65ObAACJMq0c5uhxsxPuyEEOiw@mail.gmail.com>
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

2021=EB=85=84 10=EC=9B=94 6=EC=9D=BC (=EC=88=98) =EC=98=A4=EC=A0=84 11:06, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> [snip]
> >
> > -     if (credits_requested > 0) {
> > +     /* We must grant 0 credit for the final response of an asynchrono=
us
> > +      * operation.
> > +      */
> > +     if ((hdr->Flags & SMB2_FLAGS_ASYNC_COMMAND) && !work->multiRsp) {
> Can you elaborate what is this check ? especially this !work->multiRsp..

According to 3.3.4.2 Sending an Interim Response for an Asynchronous Operat=
ion
in MS-SMB2,
For the request that will be handled asynchronously,  a server should send
an interim response, and grant credits to the interim response.
on the other hand, a server should grant 0 credit to the final response for=
 the
request.

"hdr->Flags & SMB2_FLAGS_ASYNC" means that a response is an interim
or final, and "work->multiRsp =3D=3D 0" means that a response is final. So =
in this
case, a server should grant 0 credit.

> > +             credits_granted =3D 0;
> > +     } else {
> > +             /* according to smb2.credits smbtorture, Windows server
> > +              * 2016 or later grant up to 8192 credits at one.
> > +              */
> >               aux_credits =3D credits_requested - 1;
> > -             aux_max =3D 32;
> >               if (hdr->Command =3D=3D SMB2_NEGOTIATE)
> >                       aux_max =3D 0;
> > -             aux_credits =3D (aux_credits < aux_max) ? aux_credits : a=
ux_max;
> > -             credits_granted =3D aux_credits + credit_charge;
> > +             else
> > +                     aux_max =3D conn->max_credits - credit_charge;
> > +             aux_credits =3D min_t(unsigned short, aux_credits, aux_ma=
x);
> > +             credits_granted =3D credit_charge + aux_credits;
> > +
> > +             if (conn->max_credits - conn->total_credits < credits_gra=
nted)
> > +                     credits_granted =3D conn->max_credits -
> > +                             conn->total_credits;
> >
> > -             /* if credits granted per client is getting bigger than d=
efault
> > -              * minimum credits then we should wrap it up within the l=
imits.
> > -              */
> > -             if ((conn->total_credits + credits_granted) > min_credits=
)
> > -                     credits_granted =3D min_credits - conn->total_cre=
dits;
> >               /*
> >                * TODO: Need to adjuct CreditRequest value according to
> >                * current cpu load
> >                */
> > -     } else if (conn->total_credits =3D=3D 0) {
> > -             credits_granted =3D 1;
> >       }
> >
> >       conn->total_credits +=3D credits_granted;
> > @@ -371,7 +358,6 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
> >               /* Update CreditRequest in last request */
> >               hdr->CreditRequest =3D cpu_to_le16(work->credits_granted)=
;
> >       }
> > -out:
> >       ksmbd_debug(SMB,
> >                   "credits: requested[%d] granted[%d] total_granted[%d]=
\n",
> >                   credits_requested, credits_granted,
> > @@ -692,13 +678,18 @@ int setup_async_work(struct ksmbd_work *work, voi=
d
> > (*fn)(void **), void **arg)
> >
> >  void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
> >  {
> > -     struct smb2_hdr *rsp_hdr;
> > +     struct smb2_hdr *rsp_hdr =3D work->response_buf;
> > +
> > +     work->multiRsp =3D 1;
> > +     if (status !=3D STATUS_CANCELLED) {
> > +             spin_lock(&work->conn->credits_lock);
> > +             smb2_set_rsp_credits(work);
> Can you explain why this code is needed in smb2_send_interim_resp() ?
>

As I wrote above, a server should grant credits to an interim
response.

> > +             spin_unlock(&work->conn->credits_lock);
> > +     }
> >
> > -     rsp_hdr =3D work->response_buf;
> >       smb2_set_err_rsp(work);
> >       rsp_hdr->Status =3D status;
> >
> > -     work->multiRsp =3D 1;
> >       ksmbd_conn_write(work);
> >       rsp_hdr->Status =3D 0;
> >       work->multiRsp =3D 0;
> > @@ -1233,6 +1224,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work=
)
> >
> >       conn->srv_sec_mode =3D le16_to_cpu(rsp->SecurityMode);
> >       ksmbd_conn_set_need_negotiate(work);
> > +     conn->total_credits =3D 0;
> This line is needed ?

Yes, conn->total_credits becomes 0 when receiving a SMB2_NEGOTIATION
request. But init_smbX_X_server functions are called many times and
conn->total_credits is set to 1 in these functions while negotiation.

>
> Thanks!
> >
> >  err_out:
> >       if (rc < 0)
> > --
> > 2.25.1
> >
> >



--=20
Thanks,
Hyunchul
