Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF70C43334
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Jul 2022 08:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbiGDINW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Jul 2022 04:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233689AbiGDIM4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 4 Jul 2022 04:12:56 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD9BB1F7
        for <linux-cifs@vger.kernel.org>; Mon,  4 Jul 2022 01:12:29 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id b125so6293294qkg.11
        for <linux-cifs@vger.kernel.org>; Mon, 04 Jul 2022 01:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UiPF0OIqf8wIuf1y2jucoukNZOToXZFbFuFVLlpvGSw=;
        b=RuOn2wMmq9FH0H2hx9TlrJfxt2AjLWH5OOSq2myBwPJ0k4lGxwik7MmAK+4powvfhV
         FJI8JY31iuH2r4O+CUo9vkPJCbnGFB/Pm3NbRTw6zwmb/XaapzXSJhNAh0BJxzT59bCH
         AJVN70jNKDZjdmd0UEMBVws5NxYWFINx+6UveA+ONANgqlbZwqAPMorzSETCHFOSkcN0
         hgaWpb4dFkNWDA5kLSsun7PHLJIq8GFwY6Yohw/E/9OBto6TXu6cLWZ7/6B2bkX/nbT2
         T0egA9dCWXqqjiJN4XgOLGnjxuJYjK9rB2mQ2J26JHnpET8BCMjcqajn2NnwWwakTmMo
         NtSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UiPF0OIqf8wIuf1y2jucoukNZOToXZFbFuFVLlpvGSw=;
        b=KBERND+tVYSlJiqx0XEisgjY02afIIgqZ+C2R3OmZtrMQ0s5QXCeUjjqnuYOQErW8Y
         al+tyCBPUv7cTt6L2U4OKRONS3EvqsBI+xeGTmmfXWdEM1zXM7seugJj6iqmtO2Iv5DB
         BsHPISYnRI6XHGRLxtALuHBFR1nGQP2Z+3mlWypYC5NC+sTUNj408jm7gc9nfVDcEYPe
         HEBbxDOp+NqVXsE8b3/FF1FtnhAngG8cVFGHTxB0NVpNjfV19eiR3F150S4CpkGzvBav
         LZLzpiWUbwgMTs1sKtsjehRDDqdXIzOC8XULbpZhoAJQO3zg+oJXJqObveppPOdZx0A8
         Aqkw==
X-Gm-Message-State: AJIora+202IoAufZOxv3UrbpK+tIoPV8sKlhj26qg3kZpjnFAk+doCKc
        JT9/1oo8XTLgzncd9Za5jauGW11JihS3JV1m174=
X-Google-Smtp-Source: AGRyM1tyCfIiRhKC/uS56Dtt1blZxee7nidRshP3/XrWMMh1LZyfes49mOyOCLePklcxs9HxqNdj71JJaPQD5VJLNP0=
X-Received: by 2002:a05:620a:bcb:b0:6a9:8f2a:ecf9 with SMTP id
 s11-20020a05620a0bcb00b006a98f2aecf9mr19182658qki.351.1656922348488; Mon, 04
 Jul 2022 01:12:28 -0700 (PDT)
MIME-Version: 1.0
References: <211885e7-1823-9118-836b-169c7163d7c2@gmail.com>
 <CAN05THTbuBSF6HXh5TAThchJZycU1AwiQkA0W7hDwCwKOF+4kw@mail.gmail.com>
 <fee59438-7b4a-0a24-f116-07c2ac39a3ad@gmail.com> <87h7423ukh.fsf@cjr.nz>
 <10efd255-16ea-6993-5e58-2d70e452a019@gmail.com> <87edz63t11.fsf@cjr.nz>
 <4c28c2f8-cda6-d9b4-d80f-1ffa3a3be14c@gmail.com> <20220630203207.ewmdgnzzjauofgru@cyberdelia>
In-Reply-To: <20220630203207.ewmdgnzzjauofgru@cyberdelia>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 4 Jul 2022 13:42:17 +0530
Message-ID: <CANT5p=oSgvPeQLLYC=JHbc6EAoqmW8x9Jysf00KG93-djHthEw@mail.gmail.com>
Subject: Re: kernel-5.18.8 breaks cifs mounts
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Julian Sikorski <belegdol@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jul 1, 2022 at 2:07 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> On 06/30, Julian Sikorski wrote:
> >>>Openmediavault 6.0.30 running on top of armbian bullseye. The samba
> >>>package version is 4.13.13+dfsg-1~deb11u3.
>
> [ ... ]
>
> >16d5d9100927 smb3: use netname when available on secondary channels
> >
> >initally, and reverting it did not help. Reverting
> >
> >ca83f50b43a0 smb3: fix empty netname context on secondary channels
> >
> >makes the mounts work again.
>
> It's possible that server is not discarding/ignoring SMB2_NETNAME_NEGOTIATE_CONTEXT_ID
> negotiate context as it should, and rather treating it as an error.
>
> I took a quick look in SLE15-SP3 samba 4.15 code and I didn't spot any
> obvious mishandling there (it seems it's not supported yet). Also I
> couldn't reproduce the issue with that server.
>
> Maybe it's possible it's a vendor modification?
>
>
> Cheers,
>
> Enzo

I tried mounting a samba share, and it seems to work fine.

From the network capture attached, I see that the netname is not
empty, and seems fine.
Negotiate Context: SMB2_NETNAME_NEGOTIATE_CONTEXT_ID
    Type: SMB2_NETNAME_NEGOTIATE_CONTEXT_ID (0x0005)
    DataLength: 30
    Reserved: 00000000
    Netname: odroidxu4.local

Julian,
Will you be able to capture network traces with the two changes
reverted? i.e. when it works for you?

-- 
Regards,
Shyam
