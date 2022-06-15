Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A65C43334
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jun 2022 02:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbiFOCOl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Jun 2022 22:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiFOCOk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Jun 2022 22:14:40 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F434132B
        for <linux-cifs@vger.kernel.org>; Tue, 14 Jun 2022 19:14:39 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id o16so13444006wra.4
        for <linux-cifs@vger.kernel.org>; Tue, 14 Jun 2022 19:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qxVAMwBQGlTSnxz70d+NalLBKMNrdUAgqmI7Nida2iw=;
        b=hZT45ekqUVKnybhUNj98ypbTXMgYMc12o/fCVUxp2hM6ArzOmgZBQ6zFxNTR71nRTU
         mzVUhG9iX/yq90qtyYU9uRrjJfqPTguSTU5ouwsPxnwfw8sijikNfoOdY452uLqJj/G+
         XF0uG9jJZQt0Rfgtlk5awNEN2hZJti2JxGjacMeXdPhDcQuhCCaV4Wim/vtplXqtMx1L
         ceh0SZW+dbOcngCYuXJ9Fja3kZMk6JkrSU5Fc0T4k5F4UtorSSkTODgkAgvar9Y9/ONT
         U74LCzfu6P+VoqMIG7doueC8SqYPdeatITu29VOg4Qr1kI2YvnbTqaqr35sAw2zKqAtU
         eZjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qxVAMwBQGlTSnxz70d+NalLBKMNrdUAgqmI7Nida2iw=;
        b=JfIg6/fQB6QKtwv76yMiWCW/1GdgyQVwH6Ve4EIZqzvAiHk9/uIN7k0L6qKofsR2vp
         ugmsVMdW6sBNwkPb1ckP39F+32BR+CZb1mQQGU6dGhrrO10sx2p8JmhavaF7cesbGRJ+
         A+bpj6BLXEXw+98c9nf5mgSNTN8vg9lA25MMm6DNBoX1RXNrgo95Sw4CutdyL1v8a1ji
         YpbxocroKVZenyszW6lvf4MUmX2BKI9SXsguxGxlgrtEumFsztopu/gflZbGfQc702Yh
         aOYrfYPoV1/CU/N86B9nQuOX26z5eYKVfc2nxPa6DvQapfUdg8oapw8tBnVxMoB7ltPI
         /psw==
X-Gm-Message-State: AJIora+DmaE5Be83ktpfHeXp1JB5R1EeAbN3NBBl451yBQK9DgUJwbXb
        d+ASIqumqBmSBcJswT900+reppDcSfjFOAKNEbY=
X-Google-Smtp-Source: AGRyM1vFFS4Kk2W9neOAqfNDIRQ71S7EDkZMdnVgbdRqXwlHZ0czc6jzeyAAPLVlobQe8zwC770E1SiL+ZG72puPdSA=
X-Received: by 2002:a05:6000:242:b0:210:354e:c89a with SMTP id
 m2-20020a056000024200b00210354ec89amr7443528wrz.136.1655259277792; Tue, 14
 Jun 2022 19:14:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220613230119.73475-1-hyc.lee@gmail.com> <20220613230119.73475-2-hyc.lee@gmail.com>
 <6b74f448-947b-0b42-f22d-8f3e5db10e50@talpey.com>
In-Reply-To: <6b74f448-947b-0b42-f22d-8f3e5db10e50@talpey.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Wed, 15 Jun 2022 11:14:26 +0900
Message-ID: <CANFS6bbNima0zLDWVboq3gd4Szbio7owAs09cesf7SFUHPjWyQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: smbd: handle RDMA CM time wait event
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 6=EC=9B=94 14=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 8:56, T=
om Talpey <tom@talpey.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
>
> On 6/13/2022 7:01 PM, Hyunchul Lee wrote:
> > After a QP has been disconnected, it stays
> > in a timewait state for in flight packets.
> > After the state has completed,
> > RDMA_CM_EVENT_TIMEWAIT_EXIT is reported.
> > Disconnect on RDMA_CM_EVENT_TIMEWAIT_EXIT
> > so that ksmbd can restart.
> >
> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> > ---
> >   fs/ksmbd/transport_rdma.c | 1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> > index d035e060c2f0..4b1a471afcd0 100644
> > --- a/fs/ksmbd/transport_rdma.c
> > +++ b/fs/ksmbd/transport_rdma.c
> > @@ -1535,6 +1535,7 @@ static int smb_direct_cm_handler(struct rdma_cm_i=
d *cm_id,
> >               wake_up_interruptible(&t->wait_status);
> >               break;
> >       }
> > +     case RDMA_CM_EVENT_TIMEWAIT_EXIT:
> >       case RDMA_CM_EVENT_DEVICE_REMOVAL:
> >       case RDMA_CM_EVENT_DISCONNECTED: {
> >               t->status =3D SMB_DIRECT_CS_DISCONNECTED;
>
> Is this issue seen on all RDMA providers? Because I would normally
> expect that an RDMA_CM_EVENT_DISCONNECTED will precede the TIMEWAIT
> event. What scenarios have you seen this not occur?
>

There was an issue that ksmbd got stuck after attempting to shutdown.
We are trying to reproduce it, but we haven't reproduced it yet,
but It seems to be related to the TIMEWAIT event.

And other drivers such as nvme have disconnected on the TIMEWAIT event.

> Unless ksmbd wishes to reuse its QP's, which is not currently the
> case (right?), there's pretty much no reason to manage QP state and
> hang around for TIMEWAIT.

Right, ksmbd doesn't reuse QP.

>
> Tom.


--=20
Thanks,
Hyunchul
