Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6160C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Jan 2022 23:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238516AbiAQXd1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Jan 2022 18:33:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54806 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235399AbiAQXd0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Jan 2022 18:33:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71A8161214
        for <linux-cifs@vger.kernel.org>; Mon, 17 Jan 2022 23:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B55C36AEC
        for <linux-cifs@vger.kernel.org>; Mon, 17 Jan 2022 23:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642462405;
        bh=VmBWN2H3E22ZoxRcEW7nmBkKMnNB0ZPO/rXDNFPOAuI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=L1KzUD5aCBL1mKusQGO64oIctme0OOjx47o8axDtvSWQalrSTG2Xorfk5R0UAFJcK
         1BmW41Jt14CUTu3sB6pFTlGuhK9aW0SY4WAqaqRF8GuA2jAZZh2orlIaLdjCdhk+yF
         A0IdNpf/jC58+f4tVie/G2Pu4JMkd0ET0ocbAZst5h6YbfHtFecAWy45CtvXSB5xF+
         2tUfEt0vaeAp2Wx+AF+x0RwgZiRLuwTlJj/S8AeQnfOLR1E5mxvtVOrZ3YDv3jNo6j
         fzWNHFtnSxOuqsgjCf+Lc3gFnG4GUFpdZrwK5j9+eQm3Mt9UEKC5h8UVG21Me25nRw
         s5TfdPdzXnBEQ==
Received: by mail-yb1-f177.google.com with SMTP id g81so50400971ybg.10
        for <linux-cifs@vger.kernel.org>; Mon, 17 Jan 2022 15:33:25 -0800 (PST)
X-Gm-Message-State: AOAM530f8Bo+MqcW2llKBl83F3Z2wWyS/iHDUTVZr4LUTkb7pghaMwvW
        ZbCjtFWNtrMnlO8cIBkwhjR5JKRed/1GdywylwI=
X-Google-Smtp-Source: ABdhPJw0rpa74x+4pOfad4LpoDkJrp3llH+rXiuP665mNT5j/5e8RvX7TXT6rIPVi2z2GRwBLTiR4A0BChtOo7BmUGY=
X-Received: by 2002:a5b:244:: with SMTP id g4mr30357796ybp.507.1642462404940;
 Mon, 17 Jan 2022 15:33:24 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:5011:b0:123:6c39:8652 with HTTP; Mon, 17 Jan 2022
 15:33:24 -0800 (PST)
In-Reply-To: <CANFS6baREfEidN+FqZROiF+6QtOQ6FXae6f0L9EVKaUFK2L3hg@mail.gmail.com>
References: <20220107054531.619487-1-hyc.lee@gmail.com> <20220107054531.619487-2-hyc.lee@gmail.com>
 <CAKYAXd9qYgpf9oGhK5bdE2M6nbfpeTEAOg+zDGGXomOLaNmR9Q@mail.gmail.com>
 <CAH2r5mtTs5bxF9+_M0-3a7YkZB4zqBCm4_kL_QpHAPhEVAG-WA@mail.gmail.com>
 <CAKYAXd9ndasXA3q2F05f9JMXHPT6cQRf0M8owP-dwdv_LWggwQ@mail.gmail.com> <CANFS6baREfEidN+FqZROiF+6QtOQ6FXae6f0L9EVKaUFK2L3hg@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 18 Jan 2022 08:33:24 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8uQ4MG=y8_GqhAwPX0CVfk9EoEu=WZuO7+UCCYJ2RBDw@mail.gmail.com>
Message-ID: <CAKYAXd8uQ4MG=y8_GqhAwPX0CVfk9EoEu=WZuO7+UCCYJ2RBDw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: smbd: change the default maximum read/write,
 receive size
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-01-10 10:37 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> 2022=EB=85=84 1=EC=9B=94 9=EC=9D=BC (=EC=9D=BC) =EC=98=A4=ED=9B=84 9:56, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> 2022-01-09 15:44 GMT+09:00, Steve French <smfrench@gmail.com>:
>> > Do you have more detail on what the negotiated readsize/writesize
>> > would be for Windows clients with this size? for Linux clients?
>> Hyunchul, Please answer.
>>
>
> For a Linux client, if connected using smb-direct,
> the size will be 1048512. But connected with multichannel,
> the size will be 4MB instead of 1048512. And this causes
> problems because the read/write size is bigger than 1048512.
> It looks like a bug. I have to limit the ksmbd's SMB2 maximum
> read/write size for a test.
>
> For Windows clients, the actual read/write size is less than
> 1048512.
In the case of my Chelsio device, Need to set it to about
512K(512*1024 - 64) for it to work.
The 1048512 value seems insufficient to cover all devices. Is there
any other way to set the minimum read/write value? Calibrate this
minimum value by looking at
the device information? For example variables in ib_dev->attrs.

>
>> >
>> > It looked like it would still be 4MB at first glance (although in
>> > theory some Windows could do 8MB) ... I may have missed something
>> I understood that multiple-buffer descriptor support was required to
>> set a read/write size of 1MB or more. As I know, Hyunchul is currently
>> working on it.
>> It seems to be set to the smaller of max read/write size in smb-direct
>> negotiate and max read/write size in smb2 negotiate.
>>
>> Hyunchul, I have one question more, How did you get 1048512 setting valu=
e
>> ?
>> >
>
> I remember when the size was 1MB, Windows clients requested read/write wi=
th
> 1048512 and 64.
>
>> > On Sat, Jan 8, 2022 at 8:43 PM Namjae Jeon <linkinjeon@kernel.org>
>> > wrote:
>> >>
>> >> 2022-01-07 14:45 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
>> >> > Due to restriction that cannot handle multiple
>> >> > buffer descriptor structures, decrease the maximum
>> >> > read/write size for Windows clients.
>> >> >
>> >> > And set the maximum fragmented receive size
>> >> > in consideration of the receive queue size.
>> >> >
>> >> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
>> >> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
>> >
>> >
>> >
>> > --
>> > Thanks,
>> >
>> > Steve
>> >
>
>
>
> --
> Thanks,
> Hyunchul
>
