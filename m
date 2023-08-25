Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 098FBC3DA6F
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Aug 2023 04:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjHYEzX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 25 Aug 2023 00:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240527AbjHYEzR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 25 Aug 2023 00:55:17 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25F61FEB
        for <linux-cifs@vger.kernel.org>; Thu, 24 Aug 2023 21:55:14 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 38308e7fff4ca-2bcb0b973a5so7203241fa.3
        for <linux-cifs@vger.kernel.org>; Thu, 24 Aug 2023 21:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692939313; x=1693544113;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2of40hskuudI9R+5wCTL6pTuY9gu4K0w/i4Ps6dXiKs=;
        b=PoF7nZtY8Ia3CjLcjdEU9Rj9UIVmslszWMdfs3K5WoTY6NQewwyW65pm/silPK7O0a
         4CSb+oE0jE9SVaEn/oA9IfvC2drD7OxpjLSKS1fNTMJR32V5RHD8TCjRoSYEn7fKJosz
         VvoegRYMISq9/RHJNVjKQxFO/yVs2WOw4bwMcO5f09mh67SDnjobj8KEeOK95eKFlUzM
         fPWmK8GZtGMXAFNjDU53vXu4/N5vB9/hNb6KGi4L/wJUgRfPXIdRvgipPZ99ACYNUOUH
         knKJJN0YnnMPcrXOq/VSQaMk0yqxPmkZem+r7YNO+U3Yo6d2n+cechaiTLsWEDIWkPWA
         LfCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692939313; x=1693544113;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2of40hskuudI9R+5wCTL6pTuY9gu4K0w/i4Ps6dXiKs=;
        b=c7E6+jEQVoSeRROQ8g6hWJJZrejNdbWiWdScZFICRdHngspD3OSmNu6zzTNr8e3HW0
         XNxE+tgn5yfGPMfZNTtDpCh2huENaDM1HKDqeSGsoLdKSa2pzPrlM8BVxcXkBFi1Djhk
         xc6Wyi/ptVtcWi/7Aw/9tnNTKGEAsM1pIikk4fB1IXxjlrqen17Fd3GVNdykd5ZUVpyU
         KwsNFI+ksQKr3RT7M4E6+DmRfWuLUY/QyS+8a6/IR03bwRl2FJS0i7+qsNgQH6AFSoNo
         IdFIsmQU7/kzyACoXPiCF5W6BwGo2+OfaxngbkyynxPoFG+hkNXvvxNNu0qvMQWj9fms
         +SdA==
X-Gm-Message-State: AOJu0YwVe5RFNaNUlGUf/5bfDOx+FiG1O0tBrQVrYxNNoDqTOdJcEc6V
        oDT9+z8R03Jjd8Q52bkD24P2vfnpYRF10LZByD9SsJOAzvMd2Opv
X-Google-Smtp-Source: AGHT+IEQh4VXX+4sfq4HIgCClAvFKD3N0BiwmXUaBcr70zK2Zm9TEi0MqLqJ7uSEsu3do4bwajeQBHa3NfzTclYr1u8=
X-Received: by 2002:a2e:3310:0:b0:2bc:ed80:46e with SMTP id
 d16-20020a2e3310000000b002bced80046emr1903577ljc.31.1692939312620; Thu, 24
 Aug 2023 21:55:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mucC=YxgaQV5nAPCfduAmjyEyxYw+XdToOwELezqe=e0g@mail.gmail.com>
 <CAH2r5mu75kYDVGPqe135pjZRjCS1SvdXqjOax+nyG9aTXmoJJw@mail.gmail.com>
In-Reply-To: <CAH2r5mu75kYDVGPqe135pjZRjCS1SvdXqjOax+nyG9aTXmoJJw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 24 Aug 2023 23:55:01 -0500
Message-ID: <CAH2r5mvb=Bz3dW+yoS0WJk7oJuteCiGqgu=sRzVQN5C-Rn2JMA@mail.gmail.com>
Subject: Re: [PATCH][SMB client] send ChannelSequence number after reconnect
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> How have you tested this? Seems like some significantly random
> connection fault injection is needed, when doing active multichannel
> load testing to a Windows server sku.

I tested this to Windows by pausing the Windows server VM in HyperV to
force timeout, then resumed the VM to see reconnect (I also tried this
with the Windows client to see how it updated the ChannelSequence).
I also tried this to Samba by dropping the network interface and
letting the requests time out ("ifconfig lo down") and then doing
"ifconfig lo up" and letting it reconnect

On Thu, Aug 24, 2023 at 11:51=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> The ChannelSequence field in the SMB3 header is supposed to be
> increased after reconnect to allow the server to distinguish
> requests from before and after the reconnect.  We had always
> been setting it to zero.  There are cases where incrementing
> ChannelSequence on requests after network reconnects can reduce
> the chance of data corruptions.
>
> See MS-SMB2 3.2.4.1 and 3.2.7.1
>
> Note that (as Tom Talpey pointed out) a macro  "CIFS_SERVER_IS_CHAN"
> used by this patch is confusing (has a confusing name) since
> multichannel is not supported for older dialects like CIFS.  I will
> fix that macro name in a followon patch.
>
> --
> Thanks,
>
> Steve
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
