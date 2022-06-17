Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE700C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jun 2022 07:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380252AbiFQHwE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Jun 2022 03:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234463AbiFQHwD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Jun 2022 03:52:03 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FF4674FE
        for <linux-cifs@vger.kernel.org>; Fri, 17 Jun 2022 00:52:02 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id w17so4668038wrg.7
        for <linux-cifs@vger.kernel.org>; Fri, 17 Jun 2022 00:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7B+LZ6JsaAFqfcdp4JsurQeoWz3D+hd9ABnCBe4TizM=;
        b=XwAI4K2pITVK1m093BnOkvCFiEwhoqlMEKcZoY1CXBefoCLnm6vrp74RnaENGYkksO
         9jwGXx4toSyM9HO7MB+MGz4KLmmwr+8aYzgmiwFvNPZpPTURyyVGmVmr+dRfZnyoFzvv
         fV0LqR/l5YoemflqpsuJPviNFK8z9YDTIUgHMWkhhz0T/uoj3RtKJYbEAWgnXzwrZa9o
         FaZO9DIsSIm3UgVfqbUoMZxpq1UsaRC384+bofqZJ1hcVhOkM0RiRNM32DB276Hoi/3+
         yo/g9H9V3FBs/DUxbrq1KnxW2MwQETe5G1sadfaIHeo9nBJYNNh6yHfQugwqVfFlVWiN
         h84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7B+LZ6JsaAFqfcdp4JsurQeoWz3D+hd9ABnCBe4TizM=;
        b=y3l5HaTZObpqwiHuPpV3iylmKmgu8E6DIn0HDdrtTI86ePiQ8fXZd5LviPyhRJOd9C
         NCd9/pZ85bfaU2kipVd0i1dSMbc1lLRBzYixnh7X5RMcJSqEICNgzT62BQMNdw79YkAN
         l7U8a8xOZUBHqgf+dvKGx34f5WVbTZmhpfWSj0bHtOzKw9qT8aamF0dON+N5Sk1s7zBt
         xbU9AP8f4cBvgVhLd/i6fo0FgffRlfK7LVd3GLCzrU0DSVnm0FnIKKUH02Wgg3mJslNK
         WBqBIJbE8s7hSH8o0HQO7H0DVTwNZ28gOVNpxRKG3W3u6fcYlh4gVwNDruSMEV5T2SO4
         1BHw==
X-Gm-Message-State: AJIora+k1t52vE6dXlzB1VnIl2pFGQgj78QT9Vwz4OMN2EzJGfLynuas
        N7+Z3SPyZPMhmKYHl7gs9i360q5kJK6jm/XtY3U=
X-Google-Smtp-Source: AGRyM1v/1QVKHEydwPGioO+e8LRc39LJpFV8hQ/ucOf9eQpiOfir604zQn5ttStmmGDKyvSY4SXQEC51RmqvjmmkRSw=
X-Received: by 2002:a5d:59ac:0:b0:218:5b7e:1c1c with SMTP id
 p12-20020a5d59ac000000b002185b7e1c1cmr8195747wrr.621.1655452321021; Fri, 17
 Jun 2022 00:52:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220613230119.73475-1-hyc.lee@gmail.com> <20220613230119.73475-2-hyc.lee@gmail.com>
 <6b74f448-947b-0b42-f22d-8f3e5db10e50@talpey.com> <CANFS6bbNima0zLDWVboq3gd4Szbio7owAs09cesf7SFUHPjWyQ@mail.gmail.com>
 <26e088a7-ddf0-8c18-69c8-49fb53813f8d@talpey.com>
In-Reply-To: <26e088a7-ddf0-8c18-69c8-49fb53813f8d@talpey.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Fri, 17 Jun 2022 16:51:49 +0900
Message-ID: <CANFS6baf4DJj6p1g_yD1f3cqPzc3yjWdbFdcgJWjOjXAOf_Ehw@mail.gmail.com>
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

2022=EB=85=84 6=EC=9B=94 16=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 3:53, T=
om Talpey <tom@talpey.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
>
> On 6/14/2022 10:14 PM, Hyunchul Lee wrote:
> > 2022=EB=85=84 6=EC=9B=94 14=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 8:5=
6, Tom Talpey <tom@talpey.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
> >>
> >>
> >> On 6/13/2022 7:01 PM, Hyunchul Lee wrote:
> >>> After a QP has been disconnected, it stays
> >>> in a timewait state for in flight packets.
> >>> After the state has completed,
> >>> RDMA_CM_EVENT_TIMEWAIT_EXIT is reported.
> >>> Disconnect on RDMA_CM_EVENT_TIMEWAIT_EXIT
> >>> so that ksmbd can restart.
> >>>
> >>> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> >>> ---
> >>>    fs/ksmbd/transport_rdma.c | 1 +
> >>>    1 file changed, 1 insertion(+)
> >>>
> >>> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> >>> index d035e060c2f0..4b1a471afcd0 100644
> >>> --- a/fs/ksmbd/transport_rdma.c
> >>> +++ b/fs/ksmbd/transport_rdma.c
> >>> @@ -1535,6 +1535,7 @@ static int smb_direct_cm_handler(struct rdma_cm=
_id *cm_id,
> >>>                wake_up_interruptible(&t->wait_status);
> >>>                break;
> >>>        }
> >>> +     case RDMA_CM_EVENT_TIMEWAIT_EXIT:
> >>>        case RDMA_CM_EVENT_DEVICE_REMOVAL:
> >>>        case RDMA_CM_EVENT_DISCONNECTED: {
> >>>                t->status =3D SMB_DIRECT_CS_DISCONNECTED;
> >>
> >> Is this issue seen on all RDMA providers? Because I would normally
> >> expect that an RDMA_CM_EVENT_DISCONNECTED will precede the TIMEWAIT
> >> event. What scenarios have you seen this not occur?
> >>
> >
> > There was an issue that ksmbd got stuck after attempting to shutdown.
> > We are trying to reproduce it, but we haven't reproduced it yet,
> > but It seems to be related to the TIMEWAIT event.
>
> I don't think it's appropriate to add this case to SMB. I think it's
> quite unlikely that it will address anything, because an RDMA provider
> must have indicated a CM_EVENT_DISCONNECTED prior to any TIMEWAIT.
> So, the QP (and connection) will already have been torn down by ksmbd
> at the earlier event. Perhaps ksmbd did not properly drain the QP at
> the initial disconnect.
>
>  > And other drivers such as nvme have disconnected on the TIMEWAIT event=
.
>
> NVME is a completely different upper layer, and has different client/
> server transport behavior. The SMB session insulates its peers from
> most transport errors, and should not be requesting timewait for
> its connections, and definitely not waiting for timewait to expire
> before initiating teardown (or recovery). The NFS/RDMA client and
> server ignore this event, btw.
>

Okay, I got it.
I am looking for the cause and have found some clues.

> >> Unless ksmbd wishes to reuse its QP's, which is not currently the
> >> case (right?), there's pretty much no reason to manage QP state and
> >> hang around for TIMEWAIT.
> >
> > Right, ksmbd doesn't reuse QP.
>
> Then there appears to be no good justification for the change. Sorry,
> but it's a NAK from me.
>

Really thank you for the detailed explanation.

> Tom.



--=20
Thanks,
Hyunchul
