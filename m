Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD6E5C7EE23
	for <linux-cifs@archiver.kernel.org>; Fri, 26 May 2023 14:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbjEZOUX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 May 2023 10:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjEZOUW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 May 2023 10:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87FA116
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 07:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 329FB65030
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 14:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55013C4339E
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 14:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685110819;
        bh=sWom9v6wxVkS64eDbly922ALqKqKEtNE1Bk1E+tttXQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=dF4z43k1RD0vEimgZK244l4s6eM8W3VjkmVQxxK26Ll8GcOG8SyIGfnOWhwpR2s3e
         DFg27SoijS/GWuJo5kPsTTNXPVsm4w9eXvBvDGIe7Qy6luyx79JMVBKffL1Gkdjsee
         fO2orOAQL1WovPG5QmJLCGjCLzT3b2K1s2VvB8+7PYyAgwH/lgZa2SwYqwah5cHAIw
         D0Xi4k4JvMNxUgfq/J9MzNh/1D06F6/B0+XHi79xrqIQW6QPBLjY33l/yn/1E7zPMO
         jonYwm9OWQJZIGoflYeB+2KNzs7nNXgK3zBCZsUHkpha/2Vq5luB9otFpVH781WYQn
         oX6Qdoi8jc+BA==
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-19f0e612589so410256fac.2
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 07:20:19 -0700 (PDT)
X-Gm-Message-State: AC+VfDyedXiHJcMG8UuymqTWFcWUsQ1XEp2PskBI01wBf8uwYWk2ccSL
        e8pLpmruL41iHNyENH9GUYDnEKHPXh6PIihURgs=
X-Google-Smtp-Source: ACHHUZ6A+TeppDCkJ4GvlG+o1kqRwhEZpOohQ6bVyjWIyAx7bBB+QMHrUlz78esWOb5ixvZqz4aUdmfKcBEAxnxkptE=
X-Received: by 2002:a05:6870:1aaf:b0:18b:1926:43eb with SMTP id
 ef47-20020a0568701aaf00b0018b192643ebmr830156oab.48.1685110818395; Fri, 26
 May 2023 07:20:18 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:acb:0:b0:4de:afc5:4d13 with HTTP; Fri, 26 May 2023
 07:20:17 -0700 (PDT)
In-Reply-To: <CAAn9K_uc9m-xuOrhCJZ+_q5aYkcwr7=tdm0zK7fxeDe-Wyb=9g@mail.gmail.com>
References: <CAAn9K_vV2RVQSRvVp5q+Ksc6ZzxLhRHhD98LSA-JprxmAWZ49A@mail.gmail.com>
 <CAKYAXd9SZd8n8D3pr0pZQupZy53ku1w7Z5P6ppQOt6BeR79tzQ@mail.gmail.com>
 <CAAn9K_s=xKdj0xny9QYUPm6k7gM5bjG1Ukd8LSZVxo5Fghqw5g@mail.gmail.com>
 <CAKYAXd9OVdSd_Fcc_iwTGcyZZ5=iEn2KZTdFor3NtHScJjiqtQ@mail.gmail.com> <CAAn9K_uc9m-xuOrhCJZ+_q5aYkcwr7=tdm0zK7fxeDe-Wyb=9g@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 26 May 2023 23:20:17 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_r3ohd6unawihFBWZjDf4=48q_q2S3d=V68y5Xi9MapA@mail.gmail.com>
Message-ID: <CAKYAXd_r3ohd6unawihFBWZjDf4=48q_q2S3d=V68y5Xi9MapA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix out-of-bound read in deassemble_neg_contexts
To:     =?UTF-8?B?5by15pm66Ku6?= <cc85nod@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>, tom@talpey.com,
        atteh.mailbox@gmail.com, Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-05-26 11:56 GMT+09:00, =E5=BC=B5=E6=99=BA=E8=AB=BA <cc85nod@gmail.com>=
:
> Hello, Namjae Jeon,
>
> This is my new patch, and I just updated the check to make sure
> `len_of_ctxts` is still large enough after `clen` alignment.
> I also updated the types of some variables that Tom Talpey mentioned
> yesterday.

                pctx =3D (struct smb2_neg_context *)((char *)pctx + offset)=
;
                clen =3D le16_to_cpu(pctx->DataLength);
len_of_ctxts should be checked before accessing pctx and pctx-DataLength ?

-               if (clen + sizeof(struct smb2_neg_context) > len_of_ctxts)
+               if (((clen + 7) & ~0x7) + sizeof(struct
smb2_neg_context) > len_of_ctxts)
                        break;
This patch should be created after applying "ksmbd: fix multiple
out-of-bounds read during context decoding" patch".


>
> Thanks.
>
> Namjae Jeon <linkinjeon@kernel.org> =E6=96=BC 2023=E5=B9=B45=E6=9C=8825=
=E6=97=A5 =E9=80=B1=E5=9B=9B =E4=B8=8B=E5=8D=888:58=E5=AF=AB=E9=81=93=EF=BC=
=9A
>
>> 2023-05-25 21:18 GMT+09:00, =E5=BC=B5=E6=99=BA=E8=AB=BA <cc85nod@gmail.c=
om>:
>> > `len_of_ctxts` is signed and 4 bytes (int), and `sizeof(struct
>> > smb2_neg_context)` is unsigned and 8 bytes (unsigned long).
>> >
>> > When comparing values with different size and different sign, first
>> > compiler will add instruction cdqe to extend small one to 8 bytes,
>> > then casting signed one to unsigned, which is `len_of_ctxts` in this
>> case.
>> > So a negative `len_of_ctxts` will be viewed
>> > as a large unsigned value, which is totally larger than `sizeof(struct
>> > smb2_neg_context)`.
>> Okay, Can you update this check instead of adding new check ?
>>
>> >
>> > I use program below to verify my guess:
>> >
>> > ```
>> > #include <stdio.h>
>> >
>> > int main()
>> > {
>> >     int a =3D -4;
>> >     unsigned long b =3D 0x8;
>> >
>> >     if (a < b)
>> >         printf("expected\n"); // will not print
>> > }
>> > ```
>> >
>> > Namjae Jeon <linkinjeon@kernel.org> =E6=96=BC 2023=E5=B9=B45=E6=9C=882=
5=E6=97=A5 =E9=80=B1=E5=9B=9B =E4=B8=8B=E5=8D=887:49=E5=AF=AB=E9=81=93=EF=
=BC=9A
>> >
>> >> 2023-05-25 14:31 GMT+09:00, =E5=BC=B5=E6=99=BA=E8=AB=BA <cc85nod@gmai=
l.com>:
>> >> > From 16b1d22ae886206def5fc71b26584c329755c81c Mon Sep 17 00:00:00
>> >> > 2001
>> >> > From: Chih-Yen Chang <cc85nod@gmail.com>
>> >> > Date: Thu, 25 May 2023 13:17:27 +0800
>> >> > Subject: [PATCH] ksmbd: fix out-of-bound read in
>> >> > deassemble_neg_contexts
>> >> >
>> >> > The check in the beginning is
>> >> > `clen + sizeof(struct smb2_neg_context) <=3D len_of_ctxts`,
>> >> > but in the end of loop, `len_of_ctxts` will subtract
>> >> > `((clen + 7) & ~0x7) + sizeof(struct smb2_neg_context)`, which
>> >> > causes
>> >> > integer underflow when clen does the 8 alignment.
>> >> >
>> >> > [   11.671070] BUG: KASAN: slab-out-of-bounds in
>> >> > smb2_handle_negotiate+0x799/0x1610
>> >> > [   11.671533] Read of size 2 at addr ffff888005e86cf2 by task
>> >> > kworker/0:0/7
>> >> > ...
>> >> > [   11.673383] Call Trace:
>> >> > [   11.673541]  <TASK>
>> >> > [   11.673679]  dump_stack_lvl+0x33/0x50
>> >> > [   11.673913]  print_report+0xcc/0x620
>> >> > [   11.674671]  kasan_report+0xae/0xe0
>> >> > [   11.675171]  kasan_check_range+0x35/0x1b0
>> >> > [   11.675412]  smb2_handle_negotiate+0x799/0x1610
>> >> > [   11.676217]  ksmbd_smb_negotiate_common+0x526/0x770
>> >> > [   11.676795]  handle_ksmbd_work+0x274/0x810
>> >> > ...
>> >> >
>> >> > Signed-off-by: Chih-Yen Chang <cc85nod@gmail.com>
>> >> > ---
>> >> >  fs/ksmbd/smb2pdu.c | 3 +++
>> >> >  1 file changed, 3 insertions(+)
>> >> >
>> >> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> >> > index cb93fd231..2d2a2eb96 100644
>> >> > --- a/fs/ksmbd/smb2pdu.c
>> >> > +++ b/fs/ksmbd/smb2pdu.c
>> >> > @@ -1030,6 +1030,9 @@ static __le32 deassemble_neg_contexts(struct
>> >> > ksmbd_conn *conn,
>> >> >   clen =3D (clen + 7) & ~0x7;
>> >> >   offset =3D clen + sizeof(struct smb2_neg_context);
>> >> >   len_of_ctxts -=3D clen + sizeof(struct smb2_neg_context);
>> >> > +
>> >> > + if (len_of_ctxts < 0)
>> >> > + break;
>> >>
>> >> There is a condition to check len_of_ctxts in this loop. How is this
>> >> check not making a break ?
>> >>                 if (len_of_ctxts < sizeof(struct smb2_neg_context))
>> >>                         break;
>> >> Thanks.
>> >> >   }
>> >> >   return status;
>> >> >  }
>> >> > --
>> >> > 2.39.2 (Apple Git-143)
>> >> >
>> >>
>> >
>>
>
