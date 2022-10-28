Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED4AECAAA1
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 10:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiJ1Ka7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 06:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiJ1Ka5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 06:30:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0312017A959
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 03:30:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 865E662745
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 10:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8780C433D6
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 10:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666953053;
        bh=adAOG3UrJy6ebwBAhsiN8jjE3bIqGFJMiCgUR+DYihE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=p5Vw0FVj33V6BImGXEjVmnX+gz4PtyUQ6gk+QvQ9M13gMTZ8AiEiM8uFh4HUmfvpM
         Kazv2k/x1bostAibxVgWyu16NEogHd/5cRjiD8aOmYma46q8gFaQAk74hUznD2pzWJ
         tlTHHIBeras3g0pZwhpS5ArRW4idjsSvjZnm69124KeddnqaFtmlIjG+45Jnw/4gzt
         j6UFlNre9vUI3EdeK13eGMtpGDPuD3hLiX+0JifOMGDAsK2szdeYl9FP4RDqGeX2KY
         W3OtwtDpGFZJ/TL8IxoE6GQu9CgX0CjyrqW/fSlrd2DVqFoXTA3UxlgEkjyYkxPOWu
         Ec4Xv48fhG6tA==
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-1322d768ba7so5821655fac.5
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 03:30:53 -0700 (PDT)
X-Gm-Message-State: ACrzQf1jatv1TSbA1tKfzIVD+zSMZNJMLRPQ/5UPqqt6NkdfVmA7ZxpC
        pt0gUJ0kVM5fM4Qunvv5ayvaxR5otWCiraCEYFc=
X-Google-Smtp-Source: AMsMyM40EzIR3UuYgyaWrGjIAhqxSWBxAkue4OVkuOJuFhMO8VFEoYFsuZOFmKEy9NMJPrcf8lGzt/a98EbSCqXNALY=
X-Received: by 2002:a05:6870:818c:b0:13b:8a11:82ed with SMTP id
 k12-20020a056870818c00b0013b8a1182edmr8753188oae.8.1666953053102; Fri, 28 Oct
 2022 03:30:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:4424:0:0:0:0 with HTTP; Fri, 28 Oct 2022 03:30:52
 -0700 (PDT)
In-Reply-To: <CAN05THSBzu7fgXSybe4isLGPRYxWLkZDZb_Lmox3TneAQfVP=g@mail.gmail.com>
References: <CAH2r5muCMfv4HuPw6sEgKj3Ude3cz+-NRdxDXpJr3CNtUAnm7A@mail.gmail.com>
 <CAN05THQ_C_mqq-S69f53EZQUxB2Q3rNrnVU-vRH_6kt=M0-Uwg@mail.gmail.com>
 <CAH2r5mu5cTX2gWhoyUBbkLeTtJeVvOH0vn_j_5DNwQ2__Rh38w@mail.gmail.com>
 <CAN05THRpHkXnx8NqjdEb=4BcxwsK7u+jYDSTEHdHXX_c5OZmYg@mail.gmail.com> <CAN05THSBzu7fgXSybe4isLGPRYxWLkZDZb_Lmox3TneAQfVP=g@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 28 Oct 2022 19:30:52 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8OwkEt=fJZrtooba_OYorBt4kEg68DrLJN=0OjQhkrjQ@mail.gmail.com>
Message-ID: <CAKYAXd8OwkEt=fJZrtooba_OYorBt4kEg68DrLJN=0OjQhkrjQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] fix oplock breaks when using multichannel
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-10-28 18:19 GMT+09:00, ronnie sahlberg <ronniesahlberg@gmail.com>:
> On Fri, 28 Oct 2022 at 16:55, ronnie sahlberg <ronniesahlberg@gmail.com>
> wrote:
>>
>> On Fri, 28 Oct 2022 at 16:53, Steve French <smfrench@gmail.com> wrote:
>> >
>> > I haven't tried a scenario to windows where we turn off leases and force
>> > server to use oplocks but with ksmbd that is the default.
>> > Worth also investigating how primary vs secondary works for finding
>> > leases for windows case
>>
>> Yes. Until we know what/how windows does things and what ms-smb2.pdf
>> says  we can not know if this is a cifs client bug or a ksmbd bug.
>
> So lets wait with this patch until we know where the bug is.
> I will review it later for locking correctness, but lets make sure it
> is not a ksmbd bug first.
We can reproduce it against samba with the following parameters.

server multi channel support = yes
oplock break wait time = 35000
smb2 leases = no

>
>
>>
>>
>> >
>> > On Fri, Oct 28, 2022, 01:48 ronnie sahlberg <ronniesahlberg@gmail.com>
>> > wrote:
>> >>
>> >> On Fri, 28 Oct 2022 at 16:25, Steve French <smfrench@gmail.com> wrote:
>> >> >
>> >> > If a mount to a server is using multichannel, an oplock break
>> >> > arriving
>> >> > on a secondary channel won't find the open file (since it won't find
>> >> > the
>> >> > tcon for it), and this will cause each oplock break on secondary
>> >> > channels
>> >> > to time out, slowing performance drastically.
>> >> >
>> >> > Fix smb2_is_valid_oplock_break so that if it is a secondary channel
>> >> > and
>> >> > an oplock break was not found, check for tcons (and the files
>> >> > hanging
>> >> > off the tcons) on the primary channel.
>> >>
>> >> Does this also happen against windows or is is only against ksmbd this
>> >> triggers?
>> >> What does MS-SMB2.pdf say about channels and oplocks?
>> >>
>> >> >
>> >> > Fixes xfstest generic/013 to ksmbd
>> >> >
>> >> > Cc: <stable@vger.kernel.org>
>> >> >
>> >> >
>> >> > --
>> >> > Thanks,
>> >> >
>> >> > Steve
>
