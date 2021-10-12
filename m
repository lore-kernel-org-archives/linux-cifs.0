Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C1EC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Oct 2021 23:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B39D60555
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Oct 2021 23:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbhJLXMP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhJLXMP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Oct 2021 19:12:15 -0400
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54290C061570
        for <linux-cifs@vger.kernel.org>; Tue, 12 Oct 2021 16:10:13 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id s137so419170vke.11
        for <linux-cifs@vger.kernel.org>; Tue, 12 Oct 2021 16:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+tYe6eaBIigDzWYfuy9l9zxJY/O0R3MYg6R12XCfM5E=;
        b=Qdw1HhZ8wFOP2MEDeGO6ulocZ4sMwqS7OooCO5WPYnWaNYeCxiMfxbb1sNcyuMqLtl
         1K0ECoBAUTFLsYwifOqfgwq+sjpNeXBPMsIt840VjGrMVqeKrZln66asc42vYaS+2qaV
         Odqo/+i6Ch1c9QPRWGJSIx07slgTC9kQnaz6HMXXOpcP7omWL7KPagGgC5hv2ohxgFmA
         Jgvug9QUTUiG2aw2cT5HXmQYY301GfvRqpoDAKJEl5AQKBlePwTMydgvnfT8+PsCjXoH
         aa819zEgmWFAFDjkVwRYZo2PCIpuUiwq/do/53rgETQobE6XB9hUiTENiiL2UziLIvSO
         bMPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+tYe6eaBIigDzWYfuy9l9zxJY/O0R3MYg6R12XCfM5E=;
        b=ThUuPDnDi6xXTPlOKwudJaK2dqtUAzKguKHGuwONa75vhgfOOhP2/d89pvC4YxSDKB
         3YOa2DsB0cOFROB22xB431qTGTweJHNNmWrk4y1NTda1YgjnHpy5l8nxOohB3oQRBQ7m
         yYcGVR31kTIu15D9m7OXSuhQmxevATxNdsP9QxhIM6/5ZBzqT5Y/Uvi3SnheJ/9rnJWu
         fLV6hKudJGqTw7/2jCirnfZSeP7yRkz34DP3aHIp8jUXqPh8MXP42B4TvvLdiPv7joix
         4B6OqRyEaSwy/kL+GgA655/v29BAV2pvpYj5ZIH1eynEcSc25jzleLqGI4zUh2PN6CKO
         EDWA==
X-Gm-Message-State: AOAM530rHjlnYkUsdqKg7l0miHSDIa5N4a4QM5pPesnp0Ty3EI0dUvH1
        1fZNdzwZcEJDpAylAGFfohZJ+CPr8jwAC9oedC0=
X-Google-Smtp-Source: ABdhPJyXpnFj+Y4u7S5LbcfRnkn+knh4jxY0XRG9uIt2UrtCj+kRnrv4NH52T8id41CX8hK/kWewlvkmnzAeD8nKyA0=
X-Received: by 2002:a67:ca96:: with SMTP id a22mr21360016vsl.44.1634080212428;
 Tue, 12 Oct 2021 16:10:12 -0700 (PDT)
MIME-Version: 1.0
References: <20211011121404.26392-1-hyc.lee@gmail.com> <CAKYAXd_5a7As-g+YBZve76bgyp=-axQyHt67d-B0Zy3EcyShJQ@mail.gmail.com>
In-Reply-To: <CAKYAXd_5a7As-g+YBZve76bgyp=-axQyHt67d-B0Zy3EcyShJQ@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Wed, 13 Oct 2021 08:10:01 +0900
Message-ID: <CANFS6bZv6Qds+F8pVXREfpMNzVKf9azrXCpjL4EK7_tM_WSeLw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: add buffer validation for smb direct
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

2021=EB=85=84 10=EC=9B=94 12=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 5:01, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2021-10-11 21:14 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > Add buffer validation for smb direct.
> >
> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> > ---
> >  fs/ksmbd/transport_rdma.c | 15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> > index 3a7fa23ba850..18f50e06ad15 100644
> > --- a/fs/ksmbd/transport_rdma.c
> > +++ b/fs/ksmbd/transport_rdma.c
> > @@ -549,6 +549,10 @@ static void recv_done(struct ib_cq *cq, struct ib_=
wc
> > *wc)
> >
> >       switch (recvmsg->type) {
> >       case SMB_DIRECT_MSG_NEGOTIATE_REQ:
> > +             if (wc->byte_len < sizeof(struct smb_direct_negotiate_req=
)) {
> > +                     put_empty_recvmsg(t, recvmsg);
> > +                     return;
> > +             }
> >               t->negotiation_requested =3D true;
> >               t->full_packet_received =3D true;
> >               wake_up_interruptible(&t->wait_status);
> > @@ -556,9 +560,18 @@ static void recv_done(struct ib_cq *cq, struct ib_=
wc
> > *wc)
> >       case SMB_DIRECT_MSG_DATA_TRANSFER: {
> >               struct smb_direct_data_transfer *data_transfer =3D
> >                       (struct smb_direct_data_transfer *)recvmsg->packe=
t;
> > -             int data_length =3D le32_to_cpu(data_transfer->data_lengt=
h);
> > +             int data_length;
>                 int data_length =3D le32_to_cpu(data_transfer->data_lengt=
h);
>
> >               int avail_recvmsg_count, receive_credits;
> >
> > +             if (wc->byte_len < offsetof(struct smb_direct_data_transf=
er, padding) ||
> > +                 (le32_to_cpu(data_transfer->data_length) > 0 &&
> > +                  wc->byte_len < sizeof(struct smb_direct_data_transfe=
r) +
> > +                  le32_to_cpu(data_transfer->data_length))) {
> 32bit overflow is possible here?

Yes, type casting is needed.

>
> > +                     put_empty_recvmsg(t, recvmsg);
> > +                     return;
> > +             }
> > +
> > +             data_length =3D le32_to_cpu(data_transfer->data_length);
> this can be moved to the above to avoid redundant le conversion.

Okay, I will move this.
Thank you for your comments.

>
> Thanks!
> >               if (data_length) {
> >                       if (t->full_packet_received)
> >                               recvmsg->first_segment =3D true;
> > --
> > 2.25.1
> >
> >



--=20
Thanks,
Hyunchul
