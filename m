Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A99C4743F
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Jun 2021 21:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3078761352
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Jun 2021 21:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbhFHVFY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Jun 2021 17:05:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47130 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234005AbhFHVFY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Jun 2021 17:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623186210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wgwzQeYzF2U3DxVcbwq7elji6MiiyMu51zrQBJinESg=;
        b=iqZP0IosOiopGTHE3uVc/njVZz5oq3YMHajMaczjzhUCn9gIvBe4p+rRsnvPKINqqKAiYK
        zNJNKj0MPvG+CfbtcQ/vZnJWWcLtHW1y0RHZwLYc4j640zWXduyjeFV8TQPJ/srLo8uORa
        CKVd5ZU2hqPs0JLIcyihXe815Kr8ZNI=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-h72C24FiPR6ZXRqvz8MQqQ-1; Tue, 08 Jun 2021 17:03:29 -0400
X-MC-Unique: h72C24FiPR6ZXRqvz8MQqQ-1
Received: by mail-il1-f199.google.com with SMTP id y6-20020a92d0c60000b02901e82edc2af9so9263825ila.13
        for <linux-cifs@vger.kernel.org>; Tue, 08 Jun 2021 14:03:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wgwzQeYzF2U3DxVcbwq7elji6MiiyMu51zrQBJinESg=;
        b=K9iCk3/YBZsscDXJPz4iyanGbuPjEPCyuzeoWW8eCplCk670h8ufRWsXhZfI27WDJ9
         kV0Db2KIfALePzMlkVMj1RinDWK0inhq7tzLcnrX4nyvX0HiSmoJqvZZjsGTVFCnN5FE
         luLQb7f3lXfj6FTFeaq0Qi49dE1OuzFX27t6YNmTE6tz5dBGC/dqDQuYTiYGkspj1h0r
         a8MSD0BYO4gJQ09cybmsitQlhxQ+UoIlsoddpAex/IRkW2rSJGOB0oZz6tMKe0hfwhPL
         F37cuIHcufWk4BcheAgX2YPaywxoHYBOLWbHsyczoyYueTIIBAOTvs1wXYDqnRC1UlyE
         XdxA==
X-Gm-Message-State: AOAM530kHhdEaFvhi4uJhoO1y13taZnoYPESnRGxEOsS942mpQUWukn/
        J4eE86ASL01GUK4pTfVXJ89ioTXUV10fMc9QhcULC1xhu2BpgPd3BhC8KI+hSGF1+2Oucjy80an
        L+09tm2NPZUEKwdNe0kLeXXhvq5vjm9LhxnNYmQ==
X-Received: by 2002:a5d:948f:: with SMTP id v15mr20684490ioj.28.1623186207676;
        Tue, 08 Jun 2021 14:03:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwfNmW3upGXJ5Dve4Ej9WBccBXA4QinwdWTxjQZOfwjWS64lkmPpJPrRs/IwQ0cW8sqNkKdXyXf3uAs6HhDcY=
X-Received: by 2002:a5d:948f:: with SMTP id v15mr20684477ioj.28.1623186207488;
 Tue, 08 Jun 2021 14:03:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
 <87pmwxsjxm.fsf@suse.com> <CAH2r5msMBZ5AYQcfK=-xrOASzVC0SgoHdPnyqEPRcfd-tzUstw@mail.gmail.com>
 <35352ef0-86ed-aaa5-4a49-b2b08dc3674d@samba.org>
In-Reply-To: <35352ef0-86ed-aaa5-4a49-b2b08dc3674d@samba.org>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 8 Jun 2021 17:03:16 -0400
Message-ID: <CAK-6q+g3_9g++wQGbhzBhk2cp=0fb3aVL9GoAoYNPq6M4QnCdQ@mail.gmail.com>
Subject: Re: quic in-kernel implementation?
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Leif Sahlberg <lsahlber@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

On Tue, Jun 8, 2021 at 3:36 AM Stefan Metzmacher <metze@samba.org> wrote:
...
>
> > 2) then switch focus to porting a smaller C userspace implementation of
> > QUIC to Linux (probably not msquic since it is larger and doesn't
> > follow kernel style)
> > to kernel in fs/cifs  (since currently SMB3.1.1 is the only protocol
> > that uses QUIC,
> > and the Windows server target is quite stable and can be used to test against)> 3) use the userspace upcall example from step 1 for
> > comparison/testing/debugging etc.
> > since we know the userspace version is stable
>
> With having the fuse-like socket before it should be trivial to switch
> between the implementations.

So a good starting point would be to have such a "fuse-like socket"
component? What about having a simple example for that at first
without having quic involved. The kernel calls some POSIX-like socket
interface which triggers a communication to a user space application.
This user space application will then map everything to a user space
generated socket. This would be a map from socket struct
"proto/proto_ops" to user space and vice versa. The kernel application
probably can use the kernel_FOO() (e.g. kernel_recvmsg()) socket api
directly then. Exactly like "fuse" as you mentioned just for sockets.

I think two veth interfaces can help to test something like that,
either with a "fuse-like socket" on the other end or an user space
application. Just doing a ping-pong example.

Afterwards we can look at how to replace the user generated socket
application with any $LIBQUIC e.g. msquic implementation as second
step.

- Alex

