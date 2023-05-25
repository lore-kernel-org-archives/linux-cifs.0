Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E096C77B7A
	for <linux-cifs@archiver.kernel.org>; Thu, 25 May 2023 11:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236182AbjEYLtT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 May 2023 07:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjEYLtS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 May 2023 07:49:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5489C
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 04:49:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D92CA64509
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 11:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD2AC433EF
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 11:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685015356;
        bh=32PjOWc8DA4LC1qdtB/VZllFzomb1SVqhT8a20AGRdM=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=a2KaPf/9g3inA80l0hdTN+j6mqeyHIUNiDyZEZWqf3OdylLiewkYC9nIitA0oLQCO
         17u1WjGx/V2tNoDMifga4TmLP75wAUNOQC5zcczVASgBRYW2MgKIAeX86T0qNt/ueS
         1AJjy9BUqB/PtjMw2qqTM8pl4fYj3nJO+f7Tdhb3+2FVzvoaCyno9s1ViPv4MAU8xE
         j17Ub1Dugz/BaGdXwdF9YIxhZTEKmJWXY5SYzxF6sYmUdXTaF2zCooWEdZS4OkJSgu
         SJa8V+V/dKM9dg0wbKSCt1XAWcKw8BDMabWhCqtwFRVF179onapOCPYT9o0HrwZSBa
         qvlSp+BpEz/wQ==
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-55517975c5fso219181eaf.2
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 04:49:16 -0700 (PDT)
X-Gm-Message-State: AC+VfDwkcTicDZ84lFXkPcuG2A6MkTKqoWXRn1w432PN89KxKMP9+ClA
        8xyUYIl/PcQUVUwE0Z+GjFR+ndn4/UdzpJZE06g=
X-Google-Smtp-Source: ACHHUZ7YY833DndOrZYOu/a5bnMptHxhqBfAFIinVjYZ4jbwoPdaoML2dz0WUeOcHpZsSwlWDzkyFF4EgWRjc/GsjSA=
X-Received: by 2002:a54:488c:0:b0:398:5473:89b9 with SMTP id
 r12-20020a54488c000000b00398547389b9mr2033905oic.19.1685015355126; Thu, 25
 May 2023 04:49:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:acb:0:b0:4de:afc5:4d13 with HTTP; Thu, 25 May 2023
 04:49:14 -0700 (PDT)
In-Reply-To: <CAAn9K_vV2RVQSRvVp5q+Ksc6ZzxLhRHhD98LSA-JprxmAWZ49A@mail.gmail.com>
References: <CAAn9K_vV2RVQSRvVp5q+Ksc6ZzxLhRHhD98LSA-JprxmAWZ49A@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 25 May 2023 20:49:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9SZd8n8D3pr0pZQupZy53ku1w7Z5P6ppQOt6BeR79tzQ@mail.gmail.com>
Message-ID: <CAKYAXd9SZd8n8D3pr0pZQupZy53ku1w7Z5P6ppQOt6BeR79tzQ@mail.gmail.com>
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

2023-05-25 14:31 GMT+09:00, =E5=BC=B5=E6=99=BA=E8=AB=BA <cc85nod@gmail.com>=
:
> From 16b1d22ae886206def5fc71b26584c329755c81c Mon Sep 17 00:00:00 2001
> From: Chih-Yen Chang <cc85nod@gmail.com>
> Date: Thu, 25 May 2023 13:17:27 +0800
> Subject: [PATCH] ksmbd: fix out-of-bound read in deassemble_neg_contexts
>
> The check in the beginning is
> `clen + sizeof(struct smb2_neg_context) <=3D len_of_ctxts`,
> but in the end of loop, `len_of_ctxts` will subtract
> `((clen + 7) & ~0x7) + sizeof(struct smb2_neg_context)`, which causes
> integer underflow when clen does the 8 alignment.
>
> [   11.671070] BUG: KASAN: slab-out-of-bounds in
> smb2_handle_negotiate+0x799/0x1610
> [   11.671533] Read of size 2 at addr ffff888005e86cf2 by task
> kworker/0:0/7
> ...
> [   11.673383] Call Trace:
> [   11.673541]  <TASK>
> [   11.673679]  dump_stack_lvl+0x33/0x50
> [   11.673913]  print_report+0xcc/0x620
> [   11.674671]  kasan_report+0xae/0xe0
> [   11.675171]  kasan_check_range+0x35/0x1b0
> [   11.675412]  smb2_handle_negotiate+0x799/0x1610
> [   11.676217]  ksmbd_smb_negotiate_common+0x526/0x770
> [   11.676795]  handle_ksmbd_work+0x274/0x810
> ...
>
> Signed-off-by: Chih-Yen Chang <cc85nod@gmail.com>
> ---
>  fs/ksmbd/smb2pdu.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index cb93fd231..2d2a2eb96 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -1030,6 +1030,9 @@ static __le32 deassemble_neg_contexts(struct
> ksmbd_conn *conn,
>   clen =3D (clen + 7) & ~0x7;
>   offset =3D clen + sizeof(struct smb2_neg_context);
>   len_of_ctxts -=3D clen + sizeof(struct smb2_neg_context);
> +
> + if (len_of_ctxts < 0)
> + break;

There is a condition to check len_of_ctxts in this loop. How is this
check not making a break ?
                if (len_of_ctxts < sizeof(struct smb2_neg_context))
                        break;
Thanks.
>   }
>   return status;
>  }
> --
> 2.39.2 (Apple Git-143)
>
