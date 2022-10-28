Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A9DAC38A02
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 06:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiJ1G4Y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 02:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiJ1G4U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 02:56:20 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D436E8B2
        for <linux-cifs@vger.kernel.org>; Thu, 27 Oct 2022 23:56:16 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id r12so6821292lfp.1
        for <linux-cifs@vger.kernel.org>; Thu, 27 Oct 2022 23:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VTDGfE6EmUH4aNOrVbMDtEfqg8suC7rHpQ0PmTmAkJE=;
        b=LLUNwWSFLpmx6ZF5Wn5CUODp9+XSFjCFBUlDMfV45omRxb2TR6cJO/Sxaibr5E+QGs
         MQ1cmpT1FmPBUl4dJcktkXjHNadVLFT6Ga5jXs+JgoC+1xR1DXvb7ut2p2xgefwx3F2I
         KFz7/EG1MRbUtvkplquwTUlWU3mU/bepxehEc444DV7HSkFTZM/4I8gS/QaLJ5YMOjH5
         2ro710riTcHYn5Y9wlBkZig4VLb2zZqY4tNPd1XbgOuN83Gn8+7+y3tM0y6Cu8MhIQAh
         +w0o4fRystp6nlImFMnLV6KeOMOys415gCqgnZWLH9vwyI+9UAT+re2FXpKv90EIU7Jn
         WcJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VTDGfE6EmUH4aNOrVbMDtEfqg8suC7rHpQ0PmTmAkJE=;
        b=uc87dbQzp8ikRAk/qUWyRydo3cuxMQCUbpiATmZVeMWYGimI6cJo10OHTVpZdmZXER
         dlt46SAT7q/kJF8zs8MJOajqTLlNHcg3cQLuVQ+35z8IZFgp+fjWTSQbWqFiOAdv51W1
         htqGDO8onl5pdJuHc4p6A6038fzAvQY38730liO6W9Jy1+cIt95IOYQAEcro6vbYvNfn
         vcJAoMM7DvD4C17i1dN9IA3i/UL0Vr2IkcLy8xEa9MlWhpuS1FLVOFjNRqKHU2HI9hsn
         yOoeY1+DP4PzqpmXcXsw2TG4n+cxVMxw+xxbj/K3OYDi5RY8lgNe8RPasHP3ERpsWNCJ
         LZ9g==
X-Gm-Message-State: ACrzQf0+ryEBnERwFfACETCC6fxJt9mgNEawSkfY6rZ7RxZ3sfLyv7/p
        fbCam8+t+iozHV5RERMnIgwPauIojefLLFv1cyxZW5tj
X-Google-Smtp-Source: AMsMyM6atkseEvQK0WKdtqVjEzCH+sD5y7gGjc/JxIEJEC02haCPjALAX9ixXFl570y+UH3sei72c7/Rz4h6q+pClzQ=
X-Received: by 2002:a17:907:9717:b0:78d:9fb4:16dd with SMTP id
 jg23-20020a170907971700b0078d9fb416ddmr46643579ejc.720.1666940164619; Thu, 27
 Oct 2022 23:56:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muCMfv4HuPw6sEgKj3Ude3cz+-NRdxDXpJr3CNtUAnm7A@mail.gmail.com>
 <CAN05THQ_C_mqq-S69f53EZQUxB2Q3rNrnVU-vRH_6kt=M0-Uwg@mail.gmail.com> <CAH2r5mu5cTX2gWhoyUBbkLeTtJeVvOH0vn_j_5DNwQ2__Rh38w@mail.gmail.com>
In-Reply-To: <CAH2r5mu5cTX2gWhoyUBbkLeTtJeVvOH0vn_j_5DNwQ2__Rh38w@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 28 Oct 2022 16:55:52 +1000
Message-ID: <CAN05THRpHkXnx8NqjdEb=4BcxwsK7u+jYDSTEHdHXX_c5OZmYg@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] fix oplock breaks when using multichannel
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, 28 Oct 2022 at 16:53, Steve French <smfrench@gmail.com> wrote:
>
> I haven't tried a scenario to windows where we turn off leases and force server to use oplocks but with ksmbd that is the default.
> Worth also investigating how primary vs secondary works for finding leases for windows case

Yes. Until we know what/how windows does things and what ms-smb2.pdf
says  we can not know if this is a cifs client bug or a ksmbd bug.


>
> On Fri, Oct 28, 2022, 01:48 ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>>
>> On Fri, 28 Oct 2022 at 16:25, Steve French <smfrench@gmail.com> wrote:
>> >
>> > If a mount to a server is using multichannel, an oplock break arriving
>> > on a secondary channel won't find the open file (since it won't find the
>> > tcon for it), and this will cause each oplock break on secondary channels
>> > to time out, slowing performance drastically.
>> >
>> > Fix smb2_is_valid_oplock_break so that if it is a secondary channel and
>> > an oplock break was not found, check for tcons (and the files hanging
>> > off the tcons) on the primary channel.
>>
>> Does this also happen against windows or is is only against ksmbd this triggers?
>> What does MS-SMB2.pdf say about channels and oplocks?
>>
>> >
>> > Fixes xfstest generic/013 to ksmbd
>> >
>> > Cc: <stable@vger.kernel.org>
>> >
>> >
>> > --
>> > Thanks,
>> >
>> > Steve
