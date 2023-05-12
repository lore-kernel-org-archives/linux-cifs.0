Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F570C7EE26
	for <linux-cifs@archiver.kernel.org>; Fri, 12 May 2023 14:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241259AbjELOOo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 May 2023 10:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240231AbjELOOn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 May 2023 10:14:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5EFA8A5E
        for <linux-cifs@vger.kernel.org>; Fri, 12 May 2023 07:14:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D10C861137
        for <linux-cifs@vger.kernel.org>; Fri, 12 May 2023 14:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6E4C433D2
        for <linux-cifs@vger.kernel.org>; Fri, 12 May 2023 14:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683900881;
        bh=+I8ipYyuzujnitY+41X63A3h8LxBjizI2XQFHX4HkdI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=a+353Yof5xiNUTRqNN/uytMLhXzBf+hWEkpaicI6+pZ7hCjrCY9BDcX62/eikLhaf
         f3C37TedvglZdN1rK+lELb1LpF5W8Iu//jmxF+copfRh6OOdPoivlQ1KS8Gn4BFw2V
         ReLb/QWJyMP106aujqmeNEC17nEzuZ6g638zpU+UAC4nfvuXGj8wWeWLZWX5hDhZzg
         SnlZu2sNyZBZpeumfVbAisi8os33PXMxijGtGPWwJ0bAYXK05NR33fuAqQ1HxrPovH
         Y6eNh0kLKHY7om/fwaVQAiZqHcdCr5RWx/qXpMs8vixmAv1/Z0NxiTtFDNJuX7UJpQ
         Ac0gYXw0c2mSw==
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-394c7ba4cb5so211839b6e.1
        for <linux-cifs@vger.kernel.org>; Fri, 12 May 2023 07:14:41 -0700 (PDT)
X-Gm-Message-State: AC+VfDyIuViojXGqXC5dl+TDC5V0v4w/peVeAbo0fjtJIruMApL4Sv1s
        /WI0h0DnYfqfPx266n5wr97y9bwAwyD+4k/Fj2I=
X-Google-Smtp-Source: ACHHUZ6OEXJDLP3Ax7PFDHp3x5dbWLiTYOOCfAyuKPuNWr4rX4MsgRkFvCaS9UCDJRtETffjIUpcHHVUB8qmSnBjv7k=
X-Received: by 2002:a05:6808:e8f:b0:395:1c09:1e1b with SMTP id
 k15-20020a0568080e8f00b003951c091e1bmr896884oil.39.1683900880365; Fri, 12 May
 2023 07:14:40 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:290:0:b0:4da:311c:525d with HTTP; Fri, 12 May 2023
 07:14:39 -0700 (PDT)
In-Reply-To: <CAAn9K_vRCOtYZXRBDKY4GzPA-TyrQ_Zh-qssu51Vr6sTwg5w4w@mail.gmail.com>
References: <20230505151108.5911-1-linkinjeon@kernel.org> <20230508010506.GA11511@google.com>
 <CAKYAXd-upEqLP8zSqZbR0FcznGfWLejkqQ6QKLh=taxb0mMiLQ@mail.gmail.com>
 <20230509030551.GE11511@google.com> <CAAn9K_vRCOtYZXRBDKY4GzPA-TyrQ_Zh-qssu51Vr6sTwg5w4w@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 12 May 2023 23:14:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-v=Aujh4Bg5ObboV1eMASHXhAchBK1TESH1zXUhVYJqA@mail.gmail.com>
Message-ID: <CAKYAXd-v=Aujh4Bg5ObboV1eMASHXhAchBK1TESH1zXUhVYJqA@mail.gmail.com>
Subject: Re: [PATCH 1/6] ksmbd: fix global-out-of-bounds in smb2_find_context_vals
To:     =?UTF-8?B?5by15pm66Ku6?= <cc85nod@gmail.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com,
        atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-05-10 20:04 GMT+09:00, =E5=BC=B5=E6=99=BA=E8=AB=BA <cc85nod@gmail.com>=
:
> Hi  Sergey Senozhatsky,
> Let me take an example to make sure what condition we should add.
>
> Before patching, if the tag is "ExtA" and the values of create_context
> fields are following:
> - next - 24
> - name_len - 8
> - name_off - 16
> In this situation, the large `if` condition will be passed:
> ```
> if ((next & 0x7) !=3D 0 ||
>     ...
>     ((u64)value_off + value_len > cc_len))
>     return ERR_PTR(-EINVAL);
> ```
> But when we are doing `memcmp`, the ksmbd will out-of-bound access the
> memory of the tag.
>
> However, after applying your patch, which is "name len !=3D context len",=
 the
> large `if` condition
> is still passwd, and the ksmbd still triggers the oob-read bug.
>
> So if we don't want to change `memcmp` to `strcmp`, what we do in the lar=
ge
> `if` condition is
> make sure that the name length of create_context is equal or less than th=
e
> length of tag, but
> we only can get the length of tag by `strlen`.
>
> Is my analysis correct? And do you have any ideas?
Yes, we need to compare length also, And we should not use strlen() to
get tag length. create context tag doesn't include null terminator.
tag length is 4 or 16. We can add tag_len argument in
smb2_find_context_vals(). So we change caller like this.

context =3D smb2_find_context_vals(req,

SMB2_CREATE_TIMEWARP_REQUEST, 4);

and then, In the comparison part, length is also checked.

  if (name_len =3D=3D tag_len && !memcmp(name, tag, name_len))
                return cc;

Thanks.
>
> Thanks.
>
>
> Sergey Senozhatsky <senozhatsky@chromium.org> =E6=96=BC 2023=E5=B9=B45=E6=
=9C=889=E6=97=A5 =E9=80=B1=E4=BA=8C =E4=B8=8B=E5=8D=8812:05=E5=AF=AB=E9=81=
=93=EF=BC=9A
>
>> On (23/05/08 21:58), Namjae Jeon wrote:
>> > 2023-05-08 10:05 GMT+09:00, Sergey Senozhatsky
>> > <senozhatsky@chromium.org
>> >:
>> > > On (23/05/06 00:11), Namjae Jeon wrote:
>> > >> From: Pumpkin <cc85nod@gmail.com>
>> > >>
>> > >> If the length of CreateContext name is larger than the tag, it will
>> > >> access
>> > >> the data following the tag and trigger KASAN global-out-of-bounds.
>> > >>
>> > >> Currently all CreateContext names are defined as string, so we can
>> > >> use
>> > >> strcmp instead of memcmp to avoid the out-of-bound access.
>> > Hi Chih-Yen,
>> >
>> > Please reply to Sergey's review comment. If needed, please send v2
>> > patch after updating it.
>>
>> Chih-Yen replied privately, but let me move the discussion back to
>> public list.
>>
>> > >> +++ b/fs/ksmbd/oplock.c
>> > >> @@ -1492,7 +1492,7 @@ struct create_context
>> *smb2_find_context_vals(void
>> > >> *open_req, const char *tag)
>> > >>                    return ERR_PTR(-EINVAL);
>> > >>
>> > >>            name =3D (char *)cc + name_off;
>> > >> -          if (memcmp(name, tag, name_len) =3D=3D 0)
>> > >> +          if (!strcmp(name, tag))
>> > >>                    return cc;
>> > >>
>> > >>            remain_len -=3D next;
>> > >
>> > > I'm slightly surprised that that huge `if` before memcmp() doesn't
>> catch
>> > > it
>> > >
>> > >             if ((next & 0x7) !=3D 0 ||
>> > >                 next > remain_len ||
>> > >                 name_off !=3D offsetof(struct create_context, Buffer=
)
>> > > ||
>> > >                 name_len < 4 ||
>> > >                 name_off + name_len > cc_len ||
>> > >                 (value_off & 0x7) !=3D 0 ||
>> > >                 (value_off && (value_off < name_off + name_len)) ||
>> > >                 ((u64)value_off + value_len > cc_len))
>> > >                     return ERR_PTR(-EINVAL);
>>
>> So the question is: why doesn't this `if` catch that problem?
>> I'd rather add one extra condition here, it doesn't make a lot
>> of sense to strcmp/memcmp if we know beforehand that two strings
>> have different sizes. So a simple "name len !=3D context len" should
>> do the trick. No?
>>
>
