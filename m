Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C12C47082
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Jun 2021 22:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B458461351
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Jun 2021 22:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhFHWgK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Jun 2021 18:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhFHWgJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Jun 2021 18:36:09 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6B6C061789
        for <linux-cifs@vger.kernel.org>; Tue,  8 Jun 2021 15:33:58 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id x10so11485774plg.3
        for <linux-cifs@vger.kernel.org>; Tue, 08 Jun 2021 15:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mxRqjs0kWAV8d5/8DGxZ+Wcw0XYiesjOQ1RKA/CGQGw=;
        b=RVeVFXZ/7X8SIagOorHGY0ZqE9VqdwQjcTdONY5B6RgOYMf26cSPv6RRcVku68hND1
         e/Q9uc+lCR6p6mUkEnkvJerjatKgImUB39lpoLvChPaq8N4mttvR/SxnG8abL/nQrLJL
         wvTenLHHSlQdV+1CaH0r9CxJ9onWNrd4/K5wPhNVevZZ+HnYWlXdQTMwaG/8+Kh49qCG
         o7xjmrOUfm0qitkRy4V6BhsDKZEiI9msIi26LB4GL0kwNVQjiQu/sMzcVNtgekP/HIBI
         YLVMxqMoLrnqbpzMSYL5KCpZCaTP3K2CrVO89f0koEvAlukBgGM615X5HjGHj8kaiTCT
         Wy0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mxRqjs0kWAV8d5/8DGxZ+Wcw0XYiesjOQ1RKA/CGQGw=;
        b=HwXaEL7kSH3G45JUtpNK5e3NFF3S60V1vii2rIU1aQ9TsSimGMXogP1mJOZKeoWAbC
         /y/Rv/j86KKonWZFgtp+p8uJIQPBEi6eAXTBvzONITFYdtgF2Fswm7Q7/FqpiTeUcrin
         U5+Nu+yi8UNCsDvsQy54DC0KZWkOEofZTno2xZmD/0Fqrf+wj83z2e78d15t3SXS/Brh
         Qa0CdkMbr1LL/w1/vVFcI3mhE1d35midXamzYvnLLj/IMbCRxUbhOpqFQVTET0mGglnL
         xaGWR1JX/BKLUGzHKkJmh/OWxdMJJ7v1k8UIbldH2pbmVvt+u8DKe8/50O1jeaFWXqNr
         M6xw==
X-Gm-Message-State: AOAM530bFUfe4kxoFUFi4szNmrfw+3jGKYCdcP5ZIf7QCDyx2eLecxyo
        I0+CPXZyOSI86VKUrjv+7WXeijbmMk7H+dFd
X-Google-Smtp-Source: ABdhPJwqBL12sg0BApJh90/sdHc4bkJNdticyc6nbP9qs3SX6TgBSnUG3+xZMiFMeR/KKj6xWxUp3g==
X-Received: by 2002:a17:90a:8581:: with SMTP id m1mr28547951pjn.47.1623191637974;
        Tue, 08 Jun 2021 15:33:57 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id fy16sm3130338pjb.49.2021.06.08.15.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 15:33:57 -0700 (PDT)
Date:   Tue, 8 Jun 2021 15:33:49 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>,
        =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Leif Sahlberg <lsahlber@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: quic in-kernel implementation?
Message-ID: <20210608153349.0f02ba71@hermes.local>
In-Reply-To: <CAK-6q+g3_9g++wQGbhzBhk2cp=0fb3aVL9GoAoYNPq6M4QnCdQ@mail.gmail.com>
References: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
        <87pmwxsjxm.fsf@suse.com>
        <CAH2r5msMBZ5AYQcfK=-xrOASzVC0SgoHdPnyqEPRcfd-tzUstw@mail.gmail.com>
        <35352ef0-86ed-aaa5-4a49-b2b08dc3674d@samba.org>
        <CAK-6q+g3_9g++wQGbhzBhk2cp=0fb3aVL9GoAoYNPq6M4QnCdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, 8 Jun 2021 17:03:16 -0400
Alexander Aring <aahringo@redhat.com> wrote:

> Hi,
> 
> On Tue, Jun 8, 2021 at 3:36 AM Stefan Metzmacher <metze@samba.org> wrote:
> ...
> >  
> > > 2) then switch focus to porting a smaller C userspace implementation of
> > > QUIC to Linux (probably not msquic since it is larger and doesn't
> > > follow kernel style)
> > > to kernel in fs/cifs  (since currently SMB3.1.1 is the only protocol
> > > that uses QUIC,
> > > and the Windows server target is quite stable and can be used to test against)> 3) use the userspace upcall example from step 1 for
> > > comparison/testing/debugging etc.
> > > since we know the userspace version is stable  
> >
> > With having the fuse-like socket before it should be trivial to switch
> > between the implementations.  
> 
> So a good starting point would be to have such a "fuse-like socket"
> component? What about having a simple example for that at first
> without having quic involved. The kernel calls some POSIX-like socket
> interface which triggers a communication to a user space application.
> This user space application will then map everything to a user space
> generated socket. This would be a map from socket struct
> "proto/proto_ops" to user space and vice versa. The kernel application
> probably can use the kernel_FOO() (e.g. kernel_recvmsg()) socket api
> directly then. Exactly like "fuse" as you mentioned just for sockets.
> 
> I think two veth interfaces can help to test something like that,
> either with a "fuse-like socket" on the other end or an user space
> application. Just doing a ping-pong example.
> 
> Afterwards we can look at how to replace the user generated socket
> application with any $LIBQUIC e.g. msquic implementation as second
> step.
> 
> - Alex
> 

Socket state management is complex and timers etc in userspace are hard.
