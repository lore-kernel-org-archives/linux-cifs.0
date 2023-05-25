Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D100C77B7A
	for <linux-cifs@archiver.kernel.org>; Thu, 25 May 2023 12:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbjEYM7k (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 May 2023 08:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241188AbjEYM7j (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 May 2023 08:59:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476541B4
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 05:59:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65F4D64224
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 12:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4527C4339B
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 12:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685019502;
        bh=KYGPkYhffaswnr4b2nXiARVDR61sB3zY+qrbpssWHQM=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=ZJi8gS5durZNJwukM/ghqQzwxH2hzKKTao6taRWVkUFar4z0YoVP9cbN2T4Dmvai+
         OMu38KmUh9EV8ODguvPAhG7djyctnHXeVgeR1yc8hiErdYNRKnqUeUTm9AaN74js8u
         cupgjwVHGNP1QLf/aXCNvrlBDhkuso4/YipsSA3hSWFDY45hvUnK+G0rkiglz0OId3
         6+FDaxitDNTuWKXDI0z1Z7MkQ5uLMpj2yzXfW099o19RY59TKu1Mdra7BbkeYv3lFD
         UF/3j5gBq5N/6fmLXNRLucSIc0LsGTa5xfkD7iW/A7L5bSL1ie93Ex9qWylAI/5zc8
         nnRqgAyvo/J8Q==
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3943fdc59f9so890993b6e.0
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 05:58:22 -0700 (PDT)
X-Gm-Message-State: AC+VfDyJaIg9lZOhHhQOwiS9uuhlZ67H6JiZCaRIeGP0rAr+puM9KO0r
        umU181S11I8m00R67BsS8p2DzB28mjms9fJqv8Q=
X-Google-Smtp-Source: ACHHUZ6Ao9dZza3c42kO/FvXtgkPMyG3af47GaZEtfw+PId6yt1hJfsZy9nfOOq56gZkBL0frRR7EH4F4CmUbp2FTV8=
X-Received: by 2002:a05:6808:2d2:b0:398:59a5:ddf with SMTP id
 a18-20020a05680802d200b0039859a50ddfmr1493355oid.3.1685019501817; Thu, 25 May
 2023 05:58:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:acb:0:b0:4de:afc5:4d13 with HTTP; Thu, 25 May 2023
 05:58:21 -0700 (PDT)
In-Reply-To: <CAAn9K_s=xKdj0xny9QYUPm6k7gM5bjG1Ukd8LSZVxo5Fghqw5g@mail.gmail.com>
References: <CAAn9K_vV2RVQSRvVp5q+Ksc6ZzxLhRHhD98LSA-JprxmAWZ49A@mail.gmail.com>
 <CAKYAXd9SZd8n8D3pr0pZQupZy53ku1w7Z5P6ppQOt6BeR79tzQ@mail.gmail.com> <CAAn9K_s=xKdj0xny9QYUPm6k7gM5bjG1Ukd8LSZVxo5Fghqw5g@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 25 May 2023 21:58:21 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9OVdSd_Fcc_iwTGcyZZ5=iEn2KZTdFor3NtHScJjiqtQ@mail.gmail.com>
Message-ID: <CAKYAXd9OVdSd_Fcc_iwTGcyZZ5=iEn2KZTdFor3NtHScJjiqtQ@mail.gmail.com>
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

2023-05-25 21:18 GMT+09:00, =E5=BC=B5=E6=99=BA=E8=AB=BA <cc85nod@gmail.com>=
:
> `len_of_ctxts` is signed and 4 bytes (int), and `sizeof(struct
> smb2_neg_context)` is unsigned and 8 bytes (unsigned long).
>
> When comparing values with different size and different sign, first
> compiler will add instruction cdqe to extend small one to 8 bytes,
> then casting signed one to unsigned, which is `len_of_ctxts` in this case=
.
> So a negative `len_of_ctxts` will be viewed
> as a large unsigned value, which is totally larger than `sizeof(struct
> smb2_neg_context)`.
Okay, Can you update this check instead of adding new check ?

>
> I use program below to verify my guess:
>
> ```
> #include <stdio.h>
>
> int main()
> {
>     int a =3D -4;
>     unsigned long b =3D 0x8;
>
>     if (a < b)
>         printf("expected\n"); // will not print
> }
> ```
>
> Namjae Jeon <linkinjeon@kernel.org> =E6=96=BC 2023=E5=B9=B45=E6=9C=8825=
=E6=97=A5 =E9=80=B1=E5=9B=9B =E4=B8=8B=E5=8D=887:49=E5=AF=AB=E9=81=93=EF=BC=
=9A
>
>> 2023-05-25 14:31 GMT+09:00, =E5=BC=B5=E6=99=BA=E8=AB=BA <cc85nod@gmail.c=
om>:
>> > From 16b1d22ae886206def5fc71b26584c329755c81c Mon Sep 17 00:00:00 2001
>> > From: Chih-Yen Chang <cc85nod@gmail.com>
>> > Date: Thu, 25 May 2023 13:17:27 +0800
>> > Subject: [PATCH] ksmbd: fix out-of-bound read in
>> > deassemble_neg_contexts
>> >
>> > The check in the beginning is
>> > `clen + sizeof(struct smb2_neg_context) <=3D len_of_ctxts`,
>> > but in the end of loop, `len_of_ctxts` will subtract
>> > `((clen + 7) & ~0x7) + sizeof(struct smb2_neg_context)`, which causes
>> > integer underflow when clen does the 8 alignment.
>> >
>> > [   11.671070] BUG: KASAN: slab-out-of-bounds in
>> > smb2_handle_negotiate+0x799/0x1610
>> > [   11.671533] Read of size 2 at addr ffff888005e86cf2 by task
>> > kworker/0:0/7
>> > ...
>> > [   11.673383] Call Trace:
>> > [   11.673541]  <TASK>
>> > [   11.673679]  dump_stack_lvl+0x33/0x50
>> > [   11.673913]  print_report+0xcc/0x620
>> > [   11.674671]  kasan_report+0xae/0xe0
>> > [   11.675171]  kasan_check_range+0x35/0x1b0
>> > [   11.675412]  smb2_handle_negotiate+0x799/0x1610
>> > [   11.676217]  ksmbd_smb_negotiate_common+0x526/0x770
>> > [   11.676795]  handle_ksmbd_work+0x274/0x810
>> > ...
>> >
>> > Signed-off-by: Chih-Yen Chang <cc85nod@gmail.com>
>> > ---
>> >  fs/ksmbd/smb2pdu.c | 3 +++
>> >  1 file changed, 3 insertions(+)
>> >
>> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> > index cb93fd231..2d2a2eb96 100644
>> > --- a/fs/ksmbd/smb2pdu.c
>> > +++ b/fs/ksmbd/smb2pdu.c
>> > @@ -1030,6 +1030,9 @@ static __le32 deassemble_neg_contexts(struct
>> > ksmbd_conn *conn,
>> >   clen =3D (clen + 7) & ~0x7;
>> >   offset =3D clen + sizeof(struct smb2_neg_context);
>> >   len_of_ctxts -=3D clen + sizeof(struct smb2_neg_context);
>> > +
>> > + if (len_of_ctxts < 0)
>> > + break;
>>
>> There is a condition to check len_of_ctxts in this loop. How is this
>> check not making a break ?
>>                 if (len_of_ctxts < sizeof(struct smb2_neg_context))
>>                         break;
>> Thanks.
>> >   }
>> >   return status;
>> >  }
>> > --
>> > 2.39.2 (Apple Git-143)
>> >
>>
>
