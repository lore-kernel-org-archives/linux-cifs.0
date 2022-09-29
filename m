Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 612BBC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 15:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbiI2P2G (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 11:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235808AbiI2P15 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 11:27:57 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C3615D67C
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 08:27:51 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id k6so1914927vsc.8
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 08:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=MLp7Pz6Uyszxp22Nblj41UxYES6x7b0WsNjxlCaP/Dw=;
        b=Aep1ToHscHxCQOrmEWnRigqGUDhxPb6PCeVfbzCw8Do2lVrnbrIkDb3xQOAVSDcg+U
         /LBpY0KptesKXIjq4wZKdfepWWl2PrDCL5K9MdG96Ik2mNqGrmd19AlsOeitDKo9mP0T
         fBOCNVMN5P7svKQcwpmj9UrLXSrv0O3KPRBrhlelvVBCsFEkkXkkpEP8lyxZc5tguzFz
         T6hqyLp44RwZ1Q9J7QoIbMuRfRVx81ZxRl5dam8smTyKuDvOeBkfp1ZxLJh5Ca8Y6gB1
         FNW6CRd43EmG44+8Dc0ivlRw1SuzaWN/oIeOFvU8B6W3KKP6NP0bFwhum4waARmaUMoO
         E2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=MLp7Pz6Uyszxp22Nblj41UxYES6x7b0WsNjxlCaP/Dw=;
        b=3EMyhsCKTOmuCwAsLPFsrd92WdYUzL+QayIZKP79ngQZIXBYMzpWoEQFTSbLplfyl1
         tdVmYibppeAfQJeVdRMkDM9EEDory7HWeexZeWOq8dPr3FORjFUFw62x+WAwGkJXIMjP
         vX5GLuwsPJBuQg05ZYVANwz9wqbYksA3coZhNBgnNSYCqqNz148r7N3VWLyLUgQ/kZGN
         erOQf5KyaSRJyQz3qB8frqLX6vgDIrdinIX59+Z5fQ4UeBKM2bzqfW1kHaNM5ssAtTSM
         MOkW/HQVwtq3W9N03DgFhIb4X32dOYuqUZSuJFfdvz/no9lolWE6IZpO24puh3qHdD5c
         Dj9Q==
X-Gm-Message-State: ACrzQf3UTBGj+3zd1n0Xt5StJVHleqqWuOSDLRcZphB7bw8SNITpvmij
        AFZ7oUy3Y8laIahF/KBxYDOPb/4sSYp0c6WFoxk=
X-Google-Smtp-Source: AMsMyM7LKG+5kcOlNg2qAVKcaWkboVbW0QQw8A+yuFwfAUv6Ml7FhC8KqcSlWw25w6F+rHkPViHeKa6xlFKhVeOE/68=
X-Received: by 2002:a67:f705:0:b0:39b:ff07:108d with SMTP id
 m5-20020a67f705000000b0039bff07108dmr1750343vso.60.1664465270544; Thu, 29 Sep
 2022 08:27:50 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1663961449.git.tom@talpey.com> <CAH2r5msZ85dBBU=rPyzgBOPJmMrJ2ACCG+DhrJJprvDJcr9QPg@mail.gmail.com>
 <c4273f7e-6024-8f1d-5514-39501fa9943c@talpey.com>
In-Reply-To: <c4273f7e-6024-8f1d-5514-39501fa9943c@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 29 Sep 2022 10:27:39 -0500
Message-ID: <CAH2r5mtw3QYxufa_CNf+YHRP9BU2Ydw90gsbj4c21AyrGnDYnw@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Reduce SMBDirect RDMA SGE counts and sizes
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, linkinjeon@kernel.org,
        senozhatsky@chromium.org, bmt@zurich.ibm.com, longli@microsoft.com,
        dhowells@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I can add the Acked-bys if you send them to me (for the cifs.ko ones)

The client for server (cifs vs ksmbd prefix) in the title is more of
an issue for email threads and patch review.

On Thu, Sep 29, 2022 at 10:15 AM Tom Talpey <tom@talpey.com> wrote:
>
> I need to add the "cifs" and "ksmbd" prefixes, and a couple of
> Acked-by's. I'm still pretty ill so not getting much done just
> now though. I'll try to get on it later today.
>
> On 9/29/2022 1:02 AM, Steve French wrote:
> > merged patches 1, 3, 5, 6 of this series into cifs-2.6.git for-next
> > (will let Namjae test/try the server patches, 2 and 4) pending
> > additional testing.
> >
> > Let me know if any Reviewed-by to add
> >
> > On Fri, Sep 23, 2022 at 4:54 PM Tom Talpey <tom@talpey.com> wrote:
> >>
> >> Allocate fewer SGEs and standard packet sizes in both kernel SMBDirect
> >> implementations.
> >>
> >> The current maximum values (16 SGEs and 8192 bytes) cause failures on the
> >> SoftiWARP provider, and are suboptimal on others. Reduce these to 6 and
> >> 1364. Additionally, recode smbd_send() to work with as few as 2 SGEs,
> >> and for debug sanity, reformat client-side logging to more clearly show
> >> addresses, lengths and flags in the appropriate base.
> >>
> >> Tested over SoftiWARP and SoftRoCE with shell, Connectathon basic and general.
> >>
> >> v2: correct an uninitialized value issue found by Coverity
> >>
> >> Tom Talpey (6):
> >>    Decrease the number of SMB3 smbdirect client SGEs
> >>    Decrease the number of SMB3 smbdirect server SGEs
> >>    Reduce client smbdirect max receive segment size
> >>    Reduce server smbdirect max send/receive segment sizes
> >>    Handle variable number of SGEs in client smbdirect send.
> >>    Fix formatting of client smbdirect RDMA logging
> >>
> >>   fs/cifs/smbdirect.c       | 227 ++++++++++++++++----------------------
> >>   fs/cifs/smbdirect.h       |  14 ++-
> >>   fs/ksmbd/transport_rdma.c |   6 +-
> >>   3 files changed, 109 insertions(+), 138 deletions(-)
> >>
> >> --
> >> 2.34.1
> >>
> >
> >



-- 
Thanks,

Steve
