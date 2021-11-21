Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E82C433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 21 Nov 2021 11:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238117AbhKUL3Q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 21 Nov 2021 06:29:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232729AbhKUL3Q (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 21 Nov 2021 06:29:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C01360E75;
        Sun, 21 Nov 2021 11:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637493971;
        bh=22UmVfopvnDXaeJMkQaZz5Oy5qzXLVCC0UkVrMFJy2U=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=igI7i4tXAtsLHCxljrzGxP0LhNVxbS5GMbBh7F9nSGY3dxigmH9vhmUEXWpoFlRa8
         2k42lmk1XaFX/DfjVpDfqRWlr4aHJhdIDRE4Ceu5cWhIAFQI/ZWQMaB0qyq68yzn7y
         Mh91gewvXprZ6VzYF1AZ8VcG7zA/Vm4XfeYYjvqUbl5LBrZPB71IL1Guv3+2E3WEG8
         SpJfZWcJWNH8UTE8gnSUNDumECkR2P5vE2a4i/OZAK/n8Yf+FH0bESutQyB7RHnY3U
         1b9FccOtMjjRs7mxmC83Pku1uQm8//PsbmKOxIpujCV6qvv/vA9Sdd0ZwvgqOM7QuD
         Wm4PO0MqHGPow==
Received: by mail-ot1-f51.google.com with SMTP id v15-20020a9d604f000000b0056cdb373b82so24289263otj.7;
        Sun, 21 Nov 2021 03:26:11 -0800 (PST)
X-Gm-Message-State: AOAM533O7Tbbya2tT0gBMfJDxTLxvgwcoj+4cSqP4bJHG1BPuvkmdGYU
        P67w7lhI6OmmSIP7++kq+CiLbcGSJT0WryCblRM=
X-Google-Smtp-Source: ABdhPJw6WxTHIfz9R4IRmne715fdSz80V4AbDlgXYlltEsKz14bTzUr7FwDpXECjEWccCAOuWXuzGPj2FojiC6ISgGs=
X-Received: by 2002:a9d:6653:: with SMTP id q19mr17657650otm.116.1637493970744;
 Sun, 21 Nov 2021 03:26:10 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:4448:0:0:0:0:0 with HTTP; Sun, 21 Nov 2021 03:26:10
 -0800 (PST)
In-Reply-To: <5892347.VCoq2IW8ci@natalenko.name>
References: <5831447.lOV4Wx5bFT@natalenko.name> <CAKYAXd_mf9DFQsyzvow=VC6o4xDOn_nncJeo_7gOyG77WfCNqw@mail.gmail.com>
 <CAKYAXd-bi-pgFurDF3dfQ0dSZjT0KEDSWK7FtwN5V-Z+FkVgoQ@mail.gmail.com> <5892347.VCoq2IW8ci@natalenko.name>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 21 Nov 2021 20:26:10 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8D2F=5EZWsJKhnz+KER5y98Kk893sjX1HkToRcXqu_3Q@mail.gmail.com>
Message-ID: <CAKYAXd8D2F=5EZWsJKhnz+KER5y98Kk893sjX1HkToRcXqu_3Q@mail.gmail.com>
Subject: Re: [Test Request] Re: ksmbd: Unsupported addition info
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-11-21 18:11 GMT+09:00, Oleksandr Natalenko <oleksandr@natalenko.name>:
> Hello.
>
> On ned=C4=9Ble 21. listopadu 2021 2:27:12 CET Namjae Jeon wrote:
>> I attached the patch to fix this issue.
>> You need to apply this patch to ksmbd-tools.
>>
>> Please check if your issue is fixed or not. :)
>
> I can confirm that with patched ksmbd-tools the issue is fixed. Thanks!
>
> As applicable,
>
> Reported-by: Olha Cherevyk <olha.cherevyk@gmail.com>
> Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
The problem was fixed in an unexpected place. :)
I can not fix this issue without your help.
Really thank you very much!

I will add your tags to the patch.

Thanks again!
>
>> 2021-11-21 9:18 GMT+09:00, Namjae Jeon <linkinjeon@kernel.org>:
>> > I have reproduced this issue!
>> > If you change share name from "Shared" to "shared", problem is improve=
d
>> > ?
>> > Please try it after rebooting your windows PC.
>> >
>> > 2021-11-21 8:41 GMT+09:00, Namjae Jeon <linkinjeon@kernel.org>:
>> >> I have attached one more patch.
>> >>
>> >> Please apply it on the top of previous patches :)
>> >>
>> >> 2021-11-21 8:14 GMT+09:00, Oleksandr Natalenko
>> >>
>> >> <oleksandr@natalenko.name>:
>> >>> On sobota 20. listopadu 2021 23:51:39 CET Namjae Jeon wrote:
>> >>>> Thanks for your test and help:)
>> >>>> I have attached 2 patches. you can apply them on the top of previou=
s
>> >>>> patch. please don't revert previous patches.
>> >>>>
>> >>>> no need to send tcpdump, please just check if problem is improved o=
r
>> >>>> not.
>> >>>
>> >>> The issue is still there after applying new 3 patches on top of old =
3
>> >>> patches.
>> >>>
>> >>> Just in case, I've also collected the dump: [1].
>> >>>
>> >>> [1] https://natalenko.name/myfiles/misc/ksmbd-4.pcap.gz
>> >>>
>> >>>> 2021-11-20 23:50 GMT+09:00, Oleksandr Natalenko
>> >>>>
>> >>>> <oleksandr@natalenko.name>:
>> >>>> > On sobota 20. listopadu 2021 14:07:45 CET Namjae Jeon wrote:
>> >>>> >> I probably found why default stream is not included in response.
>> >>>> >> Please revert previous patches and apply attached patches.
>> >>>> >>
>> >>>> >> no need to check print log. if problem is still reproduced,
>> >>>> >> please
>> >>>> >> give me a tcpdump one more.
>> >>>> >
>> >>>> > Still no luck. The traffic dump is here: [1].
>> >>>> >
>> >>>> > The only difference I've noticed is that in those "Unsupported
>> >>>> > addition
>> >>>> > info"
>> >>>> > messages there's 0x20 only, and 0xf has disappeared.
>> >>>> >
>> >>>> > [1] https://natalenko.name/myfiles/misc/ksmbd-3.pcap.gz
>> >>>> >
>> >>>> >> 2021-11-20 21:46 GMT+09:00, Oleksandr Natalenko
>> >>>> >>
>> >>>> >> <oleksandr@natalenko.name>:
>> >>>> >> > On sobota 20. listopadu 2021 1:46:16 CET Namjae Jeon wrote:
>> >>>> >> >> >> >  1. ksmbd get stream info doesn't include default stream=
.
>> >>>> >> >>
>> >>>> >> >> ksmbd doesn't still include default stream(::DATA) in get
>> >>>> >> >> stream
>> >>>> >> >> info
>> >>>> >> >> response. very stranged..
>> >>>> >> >>
>> >>>> >> >> So I attached test patch that added print info in mail. Could
>> >>>> >> >> you
>> >>>> >> >> please check it and share print info to me ?
>> >>>> >> >
>> >>>> >> > Do I need to apply this patch only, or some previous patches
>> >>>> >> > have
>> >>>> >> > to
>> >>>> >> > be
>> >>>> >> > applied as well? If I apply this patch only, there's no extra
>> >>>> >> > info
>> >>>> >> > printed
>> >>>> >> > in
>> >>>> >> > the kernel log when I copy files from the share.
>> >>>> >> >
>> >>>> >> >> 2021-11-20 7:41 GMT+09:00, Oleksandr Natalenko
>> >>>> >> >>
>> >>>> >> >> <oleksandr@natalenko.name>:
>> >>>> >> >> > On p=C3=A1tek 19. listopadu 2021 11:29:35 CET Namjae Jeon w=
rote:
>> >>>> >> >> >> Could you please give a tcpdump me after applying attached
>> >>>> >> >> >> patch
>> >>>> >> >> >> ?
>> >>>> >> >> >
>> >>>> >> >> > It's here: [1]. The problem is still there with the patch
>> >>>> >> >> > you've
>> >>>> >> >> > sent
>> >>>> >> >> > me
>> >>>> >> >> > recently.
>> >>>> >> >> >
>> >>>> >> >> > [1] https://natalenko.name/myfiles/misc/ksmbd-2.pcap.gz
>> >>>> >> >> >
>> >>>> >> >> >> 2021-11-19 10:48 GMT+09:00, Namjae Jeon
>> >>>> >> >> >>
>> >>>> >> >> >> <linkinjeon@kernel.org>:
>> >>>> >> >> >> > Really thanks for your help!
>> >>>> >> >> >> >
>> >>>> >> >> >> > I found two difference.
>> >>>> >> >> >> >
>> >>>> >> >> >> >  1. ksmbd get stream info doesn't include default stream=
.
>> >>>> >> >> >> >  2. samba return access denied error if addtion_info
>> >>>> >> >> >> > contain
>> >>>> >> >> >> >
>> >>>> >> >> >> > SACL_SECINFO.
>> >>>> >> >> >> >
>> >>>> >> >> >> > Could you please check attached patch ?
>> >>>> >> >> >> >
>> >>>> >> >> >> > 2021-11-19 8:10 GMT+09:00, Oleksandr Natalenko
>> >>>> >> >> >> >
>> >>>> >> >> >> > <oleksandr@natalenko.name>:
>> >>>> >> >> >> >> On =C4=8Dtvrtek 18. listopadu 2021 21:00:52 CET you wro=
te:
>> >>>> >> >> >> >>> Thank you for your test!
>> >>>> >> >> >> >>>
>> >>>> >> >> >> >>> Could you please give me a tcpdump against samba ?
>> >>>> >> >> >> >>> I would like to find any clue at that.
>> >>>> >> >> >> >>
>> >>>> >> >> >> >> Sure [3].
>> >>>> >> >> >> >>
>> >>>> >> >> >> >> [3] https://natalenko.name/myfiles/misc/samba.pcap.gz
>> >>>> >> >> >> >>
>> >>>> >> >> >> >>> 2021-11-18 22:33 GMT+09:00, Oleksandr Natalenko
>> >>>> >> >> >> >>>
>> >>>> >> >> >> >>> <oleksandr@natalenko.name>:
>> >>>> >> >> >> >>> > On =C4=8Dtvrtek 18. listopadu 2021 14:26:44 CET Olek=
sandr
>> >>>> >> >> >> >>> > Natalenko
>> >>>> >> >> >> >>> >
>> >>>> >> >> >> >>> > wrote:
>> >>>> >> >> >> >>> >> On =C4=8Dtvrtek 18. listopadu 2021 13:53:53 CET Nam=
jae
>> >>>> >> >> >> >>> >> Jeon
>> >>>> >> >> >> >>> >>
>> >>>> >> >> >> >>> >> wrote:
>> >>>> >> >> >> >>> >> > I am trying to reproduce this issue on my setup.
>> >>>> >> >> >> >>> >> > can't..
>> >>>> >> >> >> >>> >> >
>> >>>> >> >> >> >>> >> > Could you please check attached patch again ?
>> >>>> >> >> >> >>> >> > I remove AdditionalInformation flags check code
>> >>>> >> >> >> >>> >> > not
>> >>>> >> >> >> >>> >> > to
>> >>>> >> >> >> >>> >> > happen
>> >>>> >> >> >> >>> >> > "Unsupported addition info" error message.
>> >>>> >> >> >> >>> >>
>> >>>> >> >> >> >>> >> No luck, sorry, the issue is still there. The
>> >>>> >> >> >> >>> >> messages
>> >>>> >> >> >> >>> >> are
>> >>>> >> >> >> >>> >> gone
>> >>>> >> >> >> >>> >> from
>> >>>> >> >> >> >>> >> the
>> >>>> >> >> >> >>> >> kernel log on the server side though (as expected),
>> >>>> >> >> >> >>> >> but
>> >>>> >> >> >> >>> >> apparently
>> >>>> >> >> >> >>> >> those
>> >>>> >> >> >> >>> >> are
>> >>>> >> >> >> >>> >> not directly related to the issue.
>> >>>> >> >> >> >>> >
>> >>>> >> >> >> >>> > And just to be on the safe side, I've re-tested it
>> >>>> >> >> >> >>> > with
>> >>>> >> >> >> >>> > Samba,
>> >>>> >> >> >> >>> > and
>> >>>> >> >> >> >>> > with
>> >>>> >> >> >> >>> > Samba
>> >>>> >> >> >> >>> > it just works.
>> >>>> >> >> >> >>> >
>> >>>> >> >> >> >>> > For reference, my Samba config is:
>> >>>> >> >> >> >>> >
>> >>>> >> >> >> >>> > ```
>> >>>> >> >> >> >>> > [global]
>> >>>> >> >> >> >>> > workgroup =3D WORKGROUP
>> >>>> >> >> >> >>> > server string =3D Samba Server %v
>> >>>> >> >> >> >>> > netbios name =3D defiant
>> >>>> >> >> >> >>> > name resolve order =3D host
>> >>>> >> >> >> >>> > domain master =3D no
>> >>>> >> >> >> >>> > load printers =3D no
>> >>>> >> >> >> >>> > show add printer wizard =3D no
>> >>>> >> >> >> >>> > printing =3D bsd
>> >>>> >> >> >> >>> > printcap name =3D /dev/null
>> >>>> >> >> >> >>> > disable spoolss =3D yes
>> >>>> >> >> >> >>> > socket options =3D TCP_NODELAY SO_KEEPALIVE
>> >>>> >> >> >> >>> > valid users =3D __guest
>> >>>> >> >> >> >>> >
>> >>>> >> >> >> >>> > [Shared]
>> >>>> >> >> >> >>> > path =3D /mnt/shared
>> >>>> >> >> >> >>> > force user =3D _shared
>> >>>> >> >> >> >>> > force group =3D _shared
>> >>>> >> >> >> >>> > browsable =3D no
>> >>>> >> >> >> >>> > writeable =3D yes
>> >>>> >> >> >> >>> > veto files =3D /lost+found/
>> >>>> >> >> >> >>> > ```
>> >>>> >> >> >> >>> >
>> >>>> >> >> >> >>> > I fail to see any substantial difference here, so th=
e
>> >>>> >> >> >> >>> > issue
>> >>>> >> >> >> >>> > must
>> >>>> >> >> >> >>> > be
>> >>>> >> >> >> >>> > hidden
>> >>>> >> >> >> >>> > somewhere inside ksmbd.
>> >>>> >> >> >> >>> >
>> >>>> >> >> >> >>> > I'm still open for further testing, of course!
>
> --
> Oleksandr Natalenko (post-factum)
>
>
>
