Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A41C4332F
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Nov 2022 09:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiKIJJh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Nov 2022 04:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiKIJI7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Nov 2022 04:08:59 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C77C760
        for <linux-cifs@vger.kernel.org>; Wed,  9 Nov 2022 01:08:45 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id q5so8728611ilt.13
        for <linux-cifs@vger.kernel.org>; Wed, 09 Nov 2022 01:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4fuqBfUDpwbJSS1YTBb2sb3R76KOM+qqR5i/fWaXCdc=;
        b=e3TAB2rddXol5nUUKyazl2feRaQcxrhR13wbeRnEge2Me6g8RojXBdCY627ZGmjk6w
         peYzzOvTSIRNMwTSwlOVLXGuijDd2f+Kt2CW450VaWD+sxjK2Ne+cRTBRz0lK8ghgcJi
         NYVvr6qrwDYK62j0DQCFoocnghvVjXnXyKu9+G9oPvBCkJIKuMJWlgmkc0quYLt0k2tt
         /Vw7k+UbHKUh/Z8rhRR4/5npuzn4EniVQ5KK14sgfDx+fselrGdlsSzfTUTTMJcQANCo
         24gS2WQkSu1lDvTEiP6e6Yz8VHRaVu1Li/8JDY55/GaUt3GgXp0JYTWYIFtLQa4cv4YG
         VY7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4fuqBfUDpwbJSS1YTBb2sb3R76KOM+qqR5i/fWaXCdc=;
        b=u8Ovc+sNPr6Efo16OraSdovK9fZis0hRqcwnzzHzXV0p4LseNt9iCKwMXRpQslzkvv
         uIj/EDZamqxY9pA8YtpT6FYdLaRzZm+KiJlZajIwavPnUJeXS1//fHWZwPpRS/ufF/bU
         TCZFeDJ6hR4DnRdKuiolcwy37NCrlXOHJnyMJAMKVSm7WZclD6yRBeMjDraUIXD6JHM5
         6aiAJAYsnb88sxVEfUdgWE70ENi0xIwRIpRntytGBiqlPNp0eNIEJM4E1psDItDwZSv7
         MeB7DNVvinndBsTiyRcpSmmh0abbH03SE7iwitxbCLVcD/D7u54X7MxOOXekh2dIbsSk
         /riQ==
X-Gm-Message-State: ACrzQf3gadDLsgIA/EU9temU+BCImnoE8XJjBJ5eqYRF8wgLudzvbYbP
        RWLThudOEahVBnA7JvXaNhILSc3iFQbEM+IIjzg=
X-Google-Smtp-Source: AMsMyM6ip9MBz5HWpbTLWBc4ZHlRflYxuqlrG3Gou4KXVKUx69GS/waUoxA3pdW1q74w9rK8egW40dnqUAXXHKkLQbw=
X-Received: by 2002:a92:6912:0:b0:300:c48d:19cd with SMTP id
 e18-20020a926912000000b00300c48d19cdmr23715458ilc.216.1667984924326; Wed, 09
 Nov 2022 01:08:44 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5muCMfv4HuPw6sEgKj3Ude3cz+-NRdxDXpJr3CNtUAnm7A@mail.gmail.com>
 <CAN05THQ_C_mqq-S69f53EZQUxB2Q3rNrnVU-vRH_6kt=M0-Uwg@mail.gmail.com>
 <CAH2r5mu5cTX2gWhoyUBbkLeTtJeVvOH0vn_j_5DNwQ2__Rh38w@mail.gmail.com>
 <CAN05THRpHkXnx8NqjdEb=4BcxwsK7u+jYDSTEHdHXX_c5OZmYg@mail.gmail.com>
 <CAN05THSBzu7fgXSybe4isLGPRYxWLkZDZb_Lmox3TneAQfVP=g@mail.gmail.com>
 <CAKYAXd8OwkEt=fJZrtooba_OYorBt4kEg68DrLJN=0OjQhkrjQ@mail.gmail.com>
 <CAH2r5mt08V-RQa8=apT-fAqXxQtKkj_9XNSMFvUBm=da-UMyCg@mail.gmail.com>
 <abbe9909-5bf6-23d0-3c86-4c7e98e8eea9@talpey.com> <CANT5p=qEWs8WTJQ1h0Wgrs3D5KVL3V_T0+p=yo4X=gOD1jvKfg@mail.gmail.com>
In-Reply-To: <CANT5p=qEWs8WTJQ1h0Wgrs3D5KVL3V_T0+p=yo4X=gOD1jvKfg@mail.gmail.com>
From:   =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>
Date:   Wed, 9 Nov 2022 10:08:33 +0100
Message-ID: <CA+5B0FNuZFX01jin63f06nszYsVm7gWL_1vk1S+HUn2-wBuasw@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] fix oplock breaks when using multichannel
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>, Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It's been a while since I worked on this and I'm not sure what exactly
you are referring to but:

There is a fundamental problem with intern linked lists (the way they
are used in cifs and in the kernel in general).
One element cannot be part of multiple lists.
Within each element, you need to add a list_head field per list its part of.

I didn't want to introduce cycles or redundant pointers (each new
pointer is a pointer that has to be updated along with all its copies
at the same time, can go stale, need to think about refcount, etc)

In MS-SMB2, the channel list is an attribute of the session, so that's
where I put it.

Cheers,
