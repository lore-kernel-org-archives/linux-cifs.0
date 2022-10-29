Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAC4FA3741
	for <linux-cifs@archiver.kernel.org>; Sat, 29 Oct 2022 02:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiJ2C3l (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 22:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiJ2C3k (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 22:29:40 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C26B1ED
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 19:29:36 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id x21so9086045ljg.10
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 19:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n8tIfqWEOPRBzho+gVFWuwRL5jdGfDOJGX4WEWNGNsE=;
        b=PncvGDTX9sMpQxR0RyF2w7sheO72+sLHpQHG3d0W9DRB9qLM5dfRPIWyf6SUl73U3W
         coF9/eL4+hfZamD9L9QcwS0bpJFMslJEAnZK1xbD/Ka/nFQjwlltTAHQ6Ond+dj/XO9D
         fdM3j86hiU8yCLP4M2rMtLVaUeuU3yg0bRPIWyX6sgKqr3qZJkW7cx82qK4e9ww3DCPv
         LLVbuauVnVJpf3ItU9Dixre7wgo2iscMPTValcVGd0eRyzPoCyiBbPAnPziLUuDeSA1O
         JRZuv1Umq+4J+okJsSO87dmPC0rJ9bU9e1K1cruINkcBQfJ1HJ4a/q8W6OVKDi2Dkf8D
         oonQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n8tIfqWEOPRBzho+gVFWuwRL5jdGfDOJGX4WEWNGNsE=;
        b=b1VVUDKn452R65cNeEpVHqNB+wWziuUNFNyflV1RNjuB7N1PC4gSKcw6LpEPKvk7Lv
         cs4jKaQ65gGXsOYiz8ZLhdjPJSUJlH5QvcxApf8iYsxoHijepBGIvnXHJtyjYG7jChJQ
         iaWG+O4Umk3e9i7eFWO5ffaHlOuG+DH7RUf/FXz4lC0jxLzt4euMb4O5fJ8xYJ4phNVR
         M50P6DAbKCE2DXy1EJdwd7jp00lVCglUSFiWJljnUq6I48elx4AKbBdbRvtpTv55AQif
         IvGD0x3x//MGzBAbolyUwquFoXeYRwPo7sltzceNZf6ZcPnnl1wOWkDaVuIdJ0dJ1G8B
         3vcw==
X-Gm-Message-State: ACrzQf2dxp6abbCugAcdtiMFKE7gZd/p3W51enp0sv4ho0BPVVsRnMPu
        ANaPvRswtSXFosRmxAHnhoOaOu17ule7D4tWLR8=
X-Google-Smtp-Source: AMsMyM7Xs09p7vEXEXTUdlfmMAJJzGwzoSkUY76sMkG5qlb0flsYJMLYevJsp061gDK0EHnLZzxXPo6OT+gcdm3MHzM=
X-Received: by 2002:a05:651c:199e:b0:26f:e45a:5ece with SMTP id
 bx30-20020a05651c199e00b0026fe45a5ecemr996172ljb.430.1667010574717; Fri, 28
 Oct 2022 19:29:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muCMfv4HuPw6sEgKj3Ude3cz+-NRdxDXpJr3CNtUAnm7A@mail.gmail.com>
 <CAN05THQ_C_mqq-S69f53EZQUxB2Q3rNrnVU-vRH_6kt=M0-Uwg@mail.gmail.com>
 <CAH2r5mu5cTX2gWhoyUBbkLeTtJeVvOH0vn_j_5DNwQ2__Rh38w@mail.gmail.com>
 <CAN05THRpHkXnx8NqjdEb=4BcxwsK7u+jYDSTEHdHXX_c5OZmYg@mail.gmail.com>
 <CAN05THSBzu7fgXSybe4isLGPRYxWLkZDZb_Lmox3TneAQfVP=g@mail.gmail.com> <CAKYAXd8OwkEt=fJZrtooba_OYorBt4kEg68DrLJN=0OjQhkrjQ@mail.gmail.com>
In-Reply-To: <CAKYAXd8OwkEt=fJZrtooba_OYorBt4kEg68DrLJN=0OjQhkrjQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 28 Oct 2022 21:29:23 -0500
Message-ID: <CAH2r5mt08V-RQa8=apT-fAqXxQtKkj_9XNSMFvUBm=da-UMyCg@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] fix oplock breaks when using multichannel
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

thx for testing this  - Shyam's fix for it looks promising (needs
review though and some testing)

On Fri, Oct 28, 2022 at 5:30 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> 2022-10-28 18:19 GMT+09:00, ronnie sahlberg <ronniesahlberg@gmail.com>:
> > On Fri, 28 Oct 2022 at 16:55, ronnie sahlberg <ronniesahlberg@gmail.com>
> > wrote:
> >>
> >> On Fri, 28 Oct 2022 at 16:53, Steve French <smfrench@gmail.com> wrote:
> >> >
> >> > I haven't tried a scenario to windows where we turn off leases and force
> >> > server to use oplocks but with ksmbd that is the default.
> >> > Worth also investigating how primary vs secondary works for finding
> >> > leases for windows case
> >>
> >> Yes. Until we know what/how windows does things and what ms-smb2.pdf
> >> says  we can not know if this is a cifs client bug or a ksmbd bug.
> >
> > So lets wait with this patch until we know where the bug is.
> > I will review it later for locking correctness, but lets make sure it
> > is not a ksmbd bug first.
> We can reproduce it against samba with the following parameters.
>
> server multi channel support = yes
> oplock break wait time = 35000
> smb2 leases = no
>
> >
> >
> >>
> >>
> >> >
> >> > On Fri, Oct 28, 2022, 01:48 ronnie sahlberg <ronniesahlberg@gmail.com>
> >> > wrote:
> >> >>
> >> >> On Fri, 28 Oct 2022 at 16:25, Steve French <smfrench@gmail.com> wrote:
> >> >> >
> >> >> > If a mount to a server is using multichannel, an oplock break
> >> >> > arriving
> >> >> > on a secondary channel won't find the open file (since it won't find
> >> >> > the
> >> >> > tcon for it), and this will cause each oplock break on secondary
> >> >> > channels
> >> >> > to time out, slowing performance drastically.
> >> >> >
> >> >> > Fix smb2_is_valid_oplock_break so that if it is a secondary channel
> >> >> > and
> >> >> > an oplock break was not found, check for tcons (and the files
> >> >> > hanging
> >> >> > off the tcons) on the primary channel.
> >> >>
> >> >> Does this also happen against windows or is is only against ksmbd this
> >> >> triggers?
> >> >> What does MS-SMB2.pdf say about channels and oplocks?
> >> >>
> >> >> >
> >> >> > Fixes xfstest generic/013 to ksmbd
> >> >> >
> >> >> > Cc: <stable@vger.kernel.org>
> >> >> >
> >> >> >
> >> >> > --
> >> >> > Thanks,
> >> >> >
> >> >> > Steve
> >



-- 
Thanks,

Steve
