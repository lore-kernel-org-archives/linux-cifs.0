Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F70C7EE23
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Jun 2023 13:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbjFENbF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Jun 2023 09:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbjFENbE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 5 Jun 2023 09:31:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86855109
        for <linux-cifs@vger.kernel.org>; Mon,  5 Jun 2023 06:31:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D80F60EFE
        for <linux-cifs@vger.kernel.org>; Mon,  5 Jun 2023 13:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BC2C4339C
        for <linux-cifs@vger.kernel.org>; Mon,  5 Jun 2023 13:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685971861;
        bh=E8MqQKFyI5skgGR7vPWBiA6iUx3Jyw+nXrKwyQcrgdg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=DmnLLTD8UKnAqFwJ2Djbsa5lGtybTWdaTtA0/9nYKrVqlT0TZtXQcs4/1SegxGY2U
         6aCh2K67jQeE6Js4hV/Qesj84lfxavdQQkhtuWBe6oKVo8mbnxbprzZ0lOcKvpy9r9
         gAZBcwnKPqorOn9bnd3dGPb4XLGPnMyVdmG8zB8FoMC5QHaCYyytWT4U4BAdsOPR8j
         tPItuRZAO61lzA0qBplIOfxdAMW9jDhPAd+5lZZoMgI3HsVU5jannhmNDcinKrmyYf
         nn0wJaIxYJ5pxYk34fU+rCFLMnZ/YU3idBZU2j1LhtdpuUhZn4dhJUpoic2gNtBRen
         J3/ovkI3GxLMw==
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-1a1b95cc10eso5011026fac.0
        for <linux-cifs@vger.kernel.org>; Mon, 05 Jun 2023 06:31:01 -0700 (PDT)
X-Gm-Message-State: AC+VfDwHHLeZefS+1soW2K5mnKcSDJ9oAH3n+Rvr0GJCx6oh924VvICv
        JH7RfdUK3SPfXiVwNXEfuAkYkeinbkXOl66ATPQ=
X-Google-Smtp-Source: ACHHUZ7yd6EeCLp3LnOBEF5aM1kSTCU1gCxVubxW1ij0AoRZvb+WzbMy39RVWkS2ZSOEYAk6msbUkTHQTr62ZM0VIfg=
X-Received: by 2002:a05:6870:b285:b0:188:101f:a628 with SMTP id
 c5-20020a056870b28500b00188101fa628mr8741958oao.20.1685971860512; Mon, 05 Jun
 2023 06:31:00 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:5c44:0:b0:4df:6fd3:a469 with HTTP; Mon, 5 Jun 2023
 06:31:00 -0700 (PDT)
In-Reply-To: <CAAn9K_sSK1-D+avjzEB3szsiTA4u_nenW2+kUSgiYxjRt8U0MQ@mail.gmail.com>
References: <CAAn9K_v-z-V-D+pgQzNzRmEDx4Rt03Fd=BkvpevR4OJqa_-F5g@mail.gmail.com>
 <CAKYAXd-7-cWxwx7stFyA9SbHbdbJTKa4RmsWpqXhNcGRj0iWvw@mail.gmail.com> <CAAn9K_sSK1-D+avjzEB3szsiTA4u_nenW2+kUSgiYxjRt8U0MQ@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 5 Jun 2023 22:31:00 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8mKTi5ziS9=SjLbo4x7+NsAx5z=9Lh=zr+7QZ3ErUsFA@mail.gmail.com>
Message-ID: <CAKYAXd8mKTi5ziS9=SjLbo4x7+NsAx5z=9Lh=zr+7QZ3ErUsFA@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds in smb2_sess_setup+0x3ac/0x1a70
To:     =?UTF-8?B?5by15pm66Ku6?= <cc85nod@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-06-05 21:50 GMT+09:00, =E5=BC=B5=E6=99=BA=E8=AB=BA <cc85nod@gmail.com>=
:
> Hello, Namjae Jeon,
>
> After fuzzing for hours, this bug is not triggered,
Thanks for your confirmation!

Let me know if you have any other issues with your fuzzer.
>
> Thanks!
>
> Namjae Jeon <linkinjeon@kernel.org> =E6=96=BC 2023=E5=B9=B46=E6=9C=885=E6=
=97=A5 =E9=80=B1=E4=B8=80 =E4=B8=8A=E5=8D=881:01=E5=AF=AB=E9=81=93=EF=BC=9A
>
>> 2023-06-04 3:44 GMT+09:00, =E5=BC=B5=E6=99=BA=E8=AB=BA <cc85nod@gmail.co=
m>:
>> > Hello, Namjae Jeon,
>> Hi Chih-Yen,
>>
>> Could you please check if your issue is fixed ?
>>
>> Thanks!
>> >
>> > The root cause of this bug is the same as
>> > 3ff6bb18ebaa5458a877b47bf7dbe99100a4ff31 (ksmbd: validate smb request
>> > protocol id), but it occurs in compound requests.
>> >
>> > [    8.912659] BUG: KASAN: slab-out-of-bounds in
>> > smb2_sess_setup+0x3ac/0x1a70
>> > [    8.913081] Read of size 4 at addr ffff88800ac8bb34 by task
>> > kworker/0:0/7
>> > ...
>> > [    8.914963] Call Trace:
>> > [    8.915121]  <TASK>
>> > [    8.915261]  dump_stack_lvl+0x33/0x50
>> > [    8.915498]  print_report+0xcc/0x620
>> > [    8.916242]  kasan_report+0xae/0xe0
>> > [    8.916717]  kasan_check_range+0x35/0x1b0
>> > [    8.916965]  smb2_sess_setup+0x3ac/0x1a70
>> > [    8.918634]  handle_ksmbd_work+0x282/0x820
>> > [    8.918898]  process_one_work+0x419/0x760
>> > [    8.919151]  worker_thread+0x2a2/0x6f0
>> > [    8.919655]  kthread+0x187/0x1d0
>> > [    8.920165]  ret_from_fork+0x1f/0x30
>> > [    8.920397]  </TASK>
>> >
>> > Thanks. Regards
>> >
>>
>
