Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC0B7C48BCF
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Jun 2021 18:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FC2B613AC
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Jun 2021 18:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhFISqv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Jun 2021 14:46:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48981 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230084AbhFISqv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Jun 2021 14:46:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623264296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=COFT0JFfRWs7TJRRnzls/RjLXk8ioI+l530lDj0TJDM=;
        b=YjAmdJjgQTY2cTr8xF87IDijxQYruEtq8tmz/lBGKjmIrU4ZadKIOwtf7/fuRt8W7Sx6Va
        omgdVrtPo5eJMNSjLNXHnya3c6lQ/59zwJYB8nHVf3xVew0iosesYQdoOB/u+z/1Le6ozQ
        UL1/fseoJ2J8j5V8Pc89rS8zfBO/mvo=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-zOiGa7hhMZGBflZQOcQPSA-1; Wed, 09 Jun 2021 14:44:52 -0400
X-MC-Unique: zOiGa7hhMZGBflZQOcQPSA-1
Received: by mail-io1-f72.google.com with SMTP id p2-20020a5d98420000b029043b3600ac76so15407517ios.22
        for <linux-cifs@vger.kernel.org>; Wed, 09 Jun 2021 11:44:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=COFT0JFfRWs7TJRRnzls/RjLXk8ioI+l530lDj0TJDM=;
        b=kp7ggZHGt33s0Q3twCXzsQftLKCcQxzKDlkyUbVFRfXh++SoOIv2Nt1H6SrLOF0vgH
         72TbZxi+LCc6jpzxuv2UDFkVRm0NgSc5a3ZMbc3gOeZR2PVGzcC9w3eYX+4U/yViWCV9
         t7CHgWc25zBe8U1DbuhVKz+VDj8mEM/BpylRjTryftBbwDODM8OwR9VArQXZj0rWaugb
         ZVS0AP2ddwSY6bm9TMrjdwD2wagkxo5SFUMdkOUq8+EdalWSXcj4ggz8dqFonqjw2Es7
         IvPhLSpwfyiW67Ffdqn+/sTlTg9kPivEH7pJzg6ZV7ZCduaps8IU2M4MZ6xUO2EShc0v
         CRFA==
X-Gm-Message-State: AOAM5315NcHO4O+RqKAawLJqNd9vKptn4Y4erhNFoMWVeNOOR9GOIUY7
        Q/4rqAeYVZEVTSOnLKt2TXjt+D7g8Lu7V93bC5hUI3x9H3H0WTcAaKyJP+82PkpiRi8ZLM1yCWt
        KsC6q9Rm4fwSw6RxsSXmUgg9eXg5kbd/3EHp0kQ==
X-Received: by 2002:a6b:4105:: with SMTP id n5mr649275ioa.148.1623264291375;
        Wed, 09 Jun 2021 11:44:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZ+savptdB2kxGXVAGpAMLcZdJCrUk1mouz8zP+dDPSxSvaCrdaD02IdMvxg/B3aiBaMhQmEHcKkPIgIresHY=
X-Received: by 2002:a6b:4105:: with SMTP id n5mr649269ioa.148.1623264291154;
 Wed, 09 Jun 2021 11:44:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
 <87pmwxsjxm.fsf@suse.com> <CAH2r5msMBZ5AYQcfK=-xrOASzVC0SgoHdPnyqEPRcfd-tzUstw@mail.gmail.com>
 <35352ef0-86ed-aaa5-4a49-b2b08dc3674d@samba.org> <CAK-6q+g3_9g++wQGbhzBhk2cp=0fb3aVL9GoAoYNPq6M4QnCdQ@mail.gmail.com>
 <20210608153349.0f02ba71@hermes.local> <20210609094818.7aaf21bd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210609094818.7aaf21bd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 9 Jun 2021 14:44:40 -0400
Message-ID: <CAK-6q+g8gsot9s0z8HcdA91_QZjWqML4WTfkgcJuF_ea+kRGUQ@mail.gmail.com>
Subject: Re: quic in-kernel implementation?
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>,
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

On Wed, Jun 9, 2021 at 12:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 8 Jun 2021 15:33:49 -0700 Stephen Hemminger wrote:
> > On Tue, 8 Jun 2021 17:03:16 -0400
> > > > With having the fuse-like socket before it should be trivial to switch
> > > > between the implementations.
> > >
> > > So a good starting point would be to have such a "fuse-like socket"
> > > component? What about having a simple example for that at first
> > > without having quic involved. The kernel calls some POSIX-like socket
> > > interface which triggers a communication to a user space application.
> > > This user space application will then map everything to a user space
> > > generated socket. This would be a map from socket struct
> > > "proto/proto_ops" to user space and vice versa. The kernel application
> > > probably can use the kernel_FOO() (e.g. kernel_recvmsg()) socket api
> > > directly then. Exactly like "fuse" as you mentioned just for sockets.
> > >
> > > I think two veth interfaces can help to test something like that,
> > > either with a "fuse-like socket" on the other end or an user space
> > > application. Just doing a ping-pong example.
> > >
> > > Afterwards we can look at how to replace the user generated socket
> > > application with any $LIBQUIC e.g. msquic implementation as second
> > > step.
> >
> > Socket state management is complex and timers etc in userspace are hard.
>
> +1 seeing the struggles fuse causes in storage land "fuse for sockets"
> is not an exciting temporary solution IMHO..

What about an in-kernel sunrpc client which forwards "in-kernel proxy
socket syscall functions" to a user server who executes those on a
user socket? Does this sound like a better approach?
Sure there may be more problems, but maybe we could try it with
something simple at first to discover all those problems.

- Alex

