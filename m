Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0ACC43334
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Jul 2022 08:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbiGAIo1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Jul 2022 04:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbiGAIo0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Jul 2022 04:44:26 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7E473587
        for <linux-cifs@vger.kernel.org>; Fri,  1 Jul 2022 01:44:25 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id g6so1289848qvt.5
        for <linux-cifs@vger.kernel.org>; Fri, 01 Jul 2022 01:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+6i3B+owZQXgNdjh0a4O4nZBThCZpdULniveZ6+glpQ=;
        b=BbTDGriiIfueJlwVXb3cpLUN7kKC2pRsFJeMMhv4qFDT53A6mTgWfdPyio2VPkzJJE
         tWYg8iU7lnxVxFCbn0wVd0c9YUdci4dfAOVWJ+z0teQ98srb4/ptbJCedi+AWRdQqxBd
         MUHN44nEB9PUvNyOuZc6s5VrW4NmDHPERl53q5TyBN+uOVxUVyZ/sj9u5xtHPmDmuhLB
         KSy0n2t9ZHVf5uE+spaSTtR5HTrijD0p4fS5DG6R+zFfT+V06TcmecsEKDkdYmhSV8sq
         LCARE0RXgLF7dlEkxqQn6GFPguh737tT4tGH1EtmnZG26Gby6deDEemlfTJ3W4iX6toC
         DDdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+6i3B+owZQXgNdjh0a4O4nZBThCZpdULniveZ6+glpQ=;
        b=EO/UIGnb+dAXbs4+jWEjMWWiqtz66x8uJtS6VOBhjXmEyH3ckfZtzab5tG+/QlyiHE
         SMtg4FeRDfUDJmnysPHTLLIPCac5iY43vgGa8o36+4Ft2sRszRWt/cBuotk5SJNxaTxE
         a+Qc2Soc6pRqzuQ6937w5GDWHlEubgd8J1sE7Oyq6EmbJFJkXo1yDnr9Y9TWrr2BXiXX
         ztM655JZ4aeynncAuhfyCzxS/GutniKG57mWmZFbAjcT/tii7AglfHihPpmT6gtH8r+2
         wiFlZnqyG1JUp69pLiokQnAhActNGkLD5CUhbKwK8F8+lG3KPLSFRL/JWtWwRbYNkkw+
         h7tQ==
X-Gm-Message-State: AJIora9hsP06d7FZrTBKio+d7ZNILUGPw87jUQBVqIn8rwDMTSovWtph
        VEF2MK9+kiAlj9t0Pv8IsdZCee0vOk2NQwAgU0E=
X-Google-Smtp-Source: AGRyM1u+R8EVmAsckvTJ0OKRXqAlseF8bBHqs9Upcqoe5jcDY5JZAK/mKHs4oCwSAFo1xyCOtMvhv+im/vXp+TVRMXg=
X-Received: by 2002:a05:6214:509e:b0:470:3fdb:3ebe with SMTP id
 kk30-20020a056214509e00b004703fdb3ebemr15024714qvb.81.1656665064738; Fri, 01
 Jul 2022 01:44:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAGypqWyKzYL+MKwsmStP=brsxYCE9MNq=2o-8QoywFX4oPSdTw@mail.gmail.com>
 <75e51680-f6b1-d83e-0832-bc384b7157be@talpey.com> <CANT5p=rhUvsrveJDA+AsJ6=j=sWC97LiTH+HcTFxbqRtFKqkAw@mail.gmail.com>
 <CAN05THSaD5JbdkjfEzQDtNOL-M+ZQhm-yrz6n1ystJKXOsJArw@mail.gmail.com>
In-Reply-To: <CAN05THSaD5JbdkjfEzQDtNOL-M+ZQhm-yrz6n1ystJKXOsJArw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 1 Jul 2022 14:14:13 +0530
Message-ID: <CANT5p=pXXfou2H0pTX+yorFTkJ-AryhhDeaAuVzxoDb4-=U69Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add mount parameter to control deferred close timeout
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm.hsk@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        rohiths msft <rohiths.msft@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jul 1, 2022 at 12:07 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Fri, 1 Jul 2022 at 16:03, Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > On Fri, Jul 1, 2022 at 3:23 AM Tom Talpey <tom@talpey.com> wrote:
> > >
> > > Is there a justification for why this is necessary?
> > >
> > > When and how are admins expected to use it, and with what values?
> > >
> >
> > Hi Tom,
> >
> > This came up specifically when a customer reported an issue with lease break.
> > We wanted to rule out (or confirm) if deferred close is playing any
> > part in this by disabling it.
> > However, to disable it today, we will need to set acregmax to 0, which
> > will also disable attribute caching.
> >
> > So Bharath now submitted a patch for this to be able to tune this
> > parameter separately.
>
> Ok,  will the option be removed later once the investigation is done?
> We shouldn't add options that are difficult/impossible to use
> correctly by normal users.
We didn't intend to. We thought that this could be a useful tunable
parameter that the basic users need not even worry about, but advanced
users / developers could suggest changing it to tune / troubleshoot
specific scenarios.
>
>
> >
> > > On 6/29/2022 4:26 AM, Bharath SM wrote:
> > > > Adding a new mount parameter to specifically control timeout for deferred close.
> >
> >
> >
> > --
> > Regards,
> > Shyam



-- 
Regards,
Shyam
