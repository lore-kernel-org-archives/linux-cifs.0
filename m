Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E51FC48BDF
	for <linux-cifs@archiver.kernel.org>; Sun, 13 Jun 2021 18:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 059F0610A2
	for <linux-cifs@archiver.kernel.org>; Sun, 13 Jun 2021 18:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhFMSKi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 13 Jun 2021 14:10:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231997AbhFMSKi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 13 Jun 2021 14:10:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623607716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3pYZS7x7b04VP8FNau30s2/Cq5LtjA4+buK1KVo4qzw=;
        b=ax661Ege8lwDSlcFfl0dtgvGhe5l4XHhGSF6b140UTmFk4m8RQZG3bUfL8FAG9E/2IqtN/
        5Wa2h4spS6pYZsnlahyw/JE+/oOXI9OH7UHqVv31ut2rz/w2isu2P4ufloGcWwhqhWQsq1
        uFVgDuNtLUnIOdMYwAR8rLlzyzf02n8=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-Zenoxa2VNoSBbCATXtajkA-1; Sun, 13 Jun 2021 14:08:35 -0400
X-MC-Unique: Zenoxa2VNoSBbCATXtajkA-1
Received: by mail-io1-f70.google.com with SMTP id d17-20020a0566021851b02904c0de164d44so11708416ioi.18
        for <linux-cifs@vger.kernel.org>; Sun, 13 Jun 2021 11:08:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3pYZS7x7b04VP8FNau30s2/Cq5LtjA4+buK1KVo4qzw=;
        b=os8OwKKz5LHEk3WzXUH8CAha3y6QFBXTayNLaAzcXaQaqCp85p15B++K8wqDfQJSPM
         wwzQqU1IEXkk5LCvrcy5xQPf39O1G5YurXSdgDVjbNd/xxysJHg/LYAbUA/xEieEB6S/
         8OpAScIsKtVsyc/xHnY+2kxGT7dQZelJzIFNM2YjOOeTfoZVTKfQo1QOr/ZINPgQ0kEC
         7jAFfD1IY1pWS29d7GJWDgQzLUTd6ddavkDGpn18i9433u/EMAAMwhRg8+5iFT/saWwn
         FszU/qYc77LjiDqgwUupkdsfNQiNO17UBr3oMYB0TfUdGtFtdz9SQQEjKlHAMsDCqc/R
         Mksg==
X-Gm-Message-State: AOAM531O0uAZHzmJre5t76V9Xt6bRDzWb2FimNyzuoOtxzvYkfP3d6y2
        IbeTTGNdsAbjh/7vmq33ua9IZwK/nV7pxP75nIHJx/cmT2lfDPuuyt8M0JpNUI0kJfncGmxN2Lu
        1lIX1xiDoLsLRJ9akHfwEZWEJ2Sz0PDoLVKbQyQ==
X-Received: by 2002:a92:c7b0:: with SMTP id f16mr11144721ilk.169.1623607714607;
        Sun, 13 Jun 2021 11:08:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIi9hotsCKR1PI95T0JBy1nXBb8+3YoxdXbzCEHQKONUHmAfhjykePgLXlW5o0SNudp+NlmbTdS6VPl4DECjg=
X-Received: by 2002:a92:c7b0:: with SMTP id f16mr11144704ilk.169.1623607714374;
 Sun, 13 Jun 2021 11:08:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
 <87pmwxsjxm.fsf@suse.com> <CAH2r5msMBZ5AYQcfK=-xrOASzVC0SgoHdPnyqEPRcfd-tzUstw@mail.gmail.com>
 <35352ef0-86ed-aaa5-4a49-b2b08dc3674d@samba.org> <CAK-6q+g3_9g++wQGbhzBhk2cp=0fb3aVL9GoAoYNPq6M4QnCdQ@mail.gmail.com>
 <20210608153349.0f02ba71@hermes.local> <20210609094818.7aaf21bd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <166ca5b32a9d4576bc02cd8972a281e9@AcuMS.aculab.com>
In-Reply-To: <166ca5b32a9d4576bc02cd8972a281e9@AcuMS.aculab.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 13 Jun 2021 14:08:23 -0400
Message-ID: <CAK-6q+id+CJgoSHaMGMs=d1Lr81bukrdjbszhujVEYnimtnq8w@mail.gmail.com>
Subject: Re: quic in-kernel implementation?
To:     David Laight <David.Laight@aculab.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
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

On Sun, Jun 13, 2021 at 8:17 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Jakub Kicinski
> > Sent: 09 June 2021 17:48
> ...
> > > > I think two veth interfaces can help to test something like that,
> > > > either with a "fuse-like socket" on the other end or an user space
> > > > application. Just doing a ping-pong example.
> > > >
> > > > Afterwards we can look at how to replace the user generated socket
> > > > application with any $LIBQUIC e.g. msquic implementation as second
> > > > step.
> > >
> > > Socket state management is complex and timers etc in userspace are hard.
> >
> > +1 seeing the struggles fuse causes in storage land "fuse for sockets"
> > is not an exciting temporary solution IMHO..
>
> Especially since you'd want reasonable performance for quic.
>
> Fuse is normally used to access obscure filesystems where
> you just need access, rather than something that really
> needs to be quick.
>

or you have library dependencies like sshfs. That is the case in quic
for some parts of TLS (see TLS socket API). Sure it will not be the
final solution, that was never the intention. It is to establish a
kernel-API which will be replaced for a final in-kernel solution later
and not trying to solve all problems at once.

- Alex

