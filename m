Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36FE4C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 01:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12C33610FC
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 01:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhJGBNR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Oct 2021 21:13:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230252AbhJGBNQ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 6 Oct 2021 21:13:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDF8361152
        for <linux-cifs@vger.kernel.org>; Thu,  7 Oct 2021 01:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633569083;
        bh=d01GXaDBKDTpgJzafHrTyRcdJBJHyqLDDl11lJ4hCLk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=BKLZ7px4wc86ZYkIJmtRze6vVj+IDm+mGGUO9m+CfqSV5itkmsmmn8UhxWaaaByIr
         HwawbLBZ7Qm7NNnHnNOPA64c/6z0sJNl3tZ8dmyaOs0A5QDhskAyM1mE9uOZp52Gx5
         hkqK2onENHNREe5ir+f43VQjzIAh102lXL3Klsv7EO5hh+ReeOcJ9F9I1bAoR+0Pkf
         n7pOgzL1dcL+vCW4HMPa/DPRvTv2Xelz0erdPFpgrC7d3V8JSh4vWzxPnLOCfB12b4
         tH/iuN4VeaKC0LlLrk1b6G8N87FtZDFZHZ/iag9/l2HtE0jGdhbC6ZwbEfRH2c1njz
         y1o4AnERxbs5Q==
Received: by mail-oi1-f174.google.com with SMTP id n64so6688889oih.2
        for <linux-cifs@vger.kernel.org>; Wed, 06 Oct 2021 18:11:23 -0700 (PDT)
X-Gm-Message-State: AOAM533Uoe9mSpzTVFLE8Rhx5npybpz81UdJrCG22YwctA18aofg62jC
        rO/To1ZjJfCsSfv6s42Wv1m6XRuJEd8lVs6At+A=
X-Google-Smtp-Source: ABdhPJytirFVXh9pqeF/4GSSOWNke/0Phj9VslR7ApddNJV4SbEDraYTVHrBYfB5vfCkEn5F0ZznIfweKE2Fr7hvfdo=
X-Received: by 2002:a05:6808:287:: with SMTP id z7mr1076419oic.8.1633569083137;
 Wed, 06 Oct 2021 18:11:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Wed, 6 Oct 2021 18:11:22 -0700 (PDT)
In-Reply-To: <CANFS6basCNTcN7Myz0bAd_LTXEji43HiqLE0B8McpaemUjSp8Q@mail.gmail.com>
References: <20211005100026.250280-1-hyc.lee@gmail.com> <de0ecb81-0313-266e-cc5b-94ec40201141@samba.org>
 <CANFS6basCNTcN7Myz0bAd_LTXEji43HiqLE0B8McpaemUjSp8Q@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 7 Oct 2021 10:11:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8sxyq+wegtuVMfrahf43y1T+gRogR9r7EfitwA+30ccQ@mail.gmail.com>
Message-ID: <CAKYAXd8sxyq+wegtuVMfrahf43y1T+gRogR9r7EfitwA+30ccQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: improve credits management
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     Ralph Boehme <slow@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-06 17:43 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> 2021=EB=85=84 10=EC=9B=94 6=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 4:15,=
 Ralph Boehme <slow@samba.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> Am 05.10.21 um 12:00 schrieb Hyunchul Lee:
>> > * For an asynchronous operation, grant credits
>> > for an interim response and 0 credit for the
>> > final response.
>>
>> fwiw, Samba also does this but this can cause significant problems as it
>> means the server looses control over the receive window size. We've seen
>> aggressive client go nuts about this overwhelming the server with IO
>> requests leading to disconnects (iirc). So this may need careful
>> checking how Windows implements this server side.
>>
>
> Okay, I will drop this in the patch. And could you elaborate
> on the situation that clients cause the problem?
>
> Namjae, What do you think about Ralph's comment?
Let's remove async codes in this patch. I would like to know how I
verified this code.
i.e. not xfstests, Client attack that runs out of credits of ksmbd...
Should it be tested by change the credit management of the cifs client
or libsmb2?

Thanks!
>
> Thank you for your comments!
>
>> Cheers!
>> -slow
>>
>> --
>> Ralph Boehme, Samba Team                 https://samba.org/
>> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
>
>
> --
> Thanks,
> Hyunchul
>
