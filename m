Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68796C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 03:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 467B76103E
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 03:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbhIGDCf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Sep 2021 23:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhIGDCe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Sep 2021 23:02:34 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBA6C061575
        for <linux-cifs@vger.kernel.org>; Mon,  6 Sep 2021 20:01:29 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id m28so16691776lfj.6
        for <linux-cifs@vger.kernel.org>; Mon, 06 Sep 2021 20:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cUR6FOvbUAaPOuE8MP8Yd1r7Q1ikKj9mUL7+FL286jE=;
        b=YMar4DqUNgTK2J/+/20nEc3ExODRWk7O5RdoEQrpcEnszgttLNqz3yR6+/3ftcrbma
         sg7TV3+hEN30klnyR5h7+vAHj6m4ifx73+66GuvDFRn2PUwr7nmYByyWiPbv8jEaTzAJ
         +fad9X+rbh75KPRIWUFaRllvbuPtDVIj4F18eQPyi5/+tQ7igww6oy7mZtPg+S9NMG+H
         2EM4odRHA3SOMBZFpgJKy0jpNcK98CYdgJiaWE0YFcAaUXYF30EBJ4/TzLh/Snqzzbn4
         RK94D3fX7SFUtH2NzBbN6P9AuZhULWXr/dRAlft9oce8SC0j8r7iAz51Yhpcs2Cm67de
         o/bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cUR6FOvbUAaPOuE8MP8Yd1r7Q1ikKj9mUL7+FL286jE=;
        b=kpnlNgzhDjUmepfvhKv67rm1m4V3/LyHSMmooCqTqviYkmh+z74vpcqdGW59YbzYyK
         HiDAYaKeJ9vy/vQ5NsO7iTX8GjQvD42xIO7jaxZ6fhb2HiCB31xO4bDf/mL3omT0FoM6
         WYgI+rUQguxnm43UvLaCC4NFNQU5/3hzFBxR3BZBEPXtrLcgmMxPlSJ1IVG6DmGDG/P6
         cc0M/4gEzBsEDv6IAlyfca8wJjXn/3CEFBfGkODVdc2/RbFwRcNbjPEgDxRzr5xPEflm
         sFDuYSa/qH8vXf8RLqEJ3KirZ3GgewOnAZ6lIuTgx6A1GTZqSEufBV9hjGu32XafXJ+9
         Iexg==
X-Gm-Message-State: AOAM532+r3MbO12xO+XgVKaK1rv23UUU4spMHJd/4J8GbS0OmMvE+Bxl
        +rbAffUjvuVyYQ1YB92sYf8E2wLAKI0AaWEDhFc=
X-Google-Smtp-Source: ABdhPJxAUbRLDn1RIs5I9trp4J4QDpkrEPZOvHjiUtYEDFETr/G0gL0EakIt9XLc2tQ6P9dWB9zKlUthz7PuZaJ625k=
X-Received: by 2002:a05:6512:3d8c:: with SMTP id k12mr11591745lfv.545.1630983687268;
 Mon, 06 Sep 2021 20:01:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210906224648.2062040-1-lsahlber@redhat.com> <CAKYAXd_9VSQsiG0KgGWRJ=UkCLBDGrw5+z8vqxLeSWiw4-uYLw@mail.gmail.com>
 <CAN05THTAueSnLc=iSt=W5ioWcPJXXKOw3-256HUqJ2SgPC1AJg@mail.gmail.com>
In-Reply-To: <CAN05THTAueSnLc=iSt=W5ioWcPJXXKOw3-256HUqJ2SgPC1AJg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 6 Sep 2021 22:01:16 -0500
Message-ID: <CAH2r5mvcXf4TrAeSsiurwMV1gkqm5ucbo=bwSjkjH86oVZ9E5w@mail.gmail.com>
Subject: Re: [PATCH 0/4] Start moving common cifs/ksmbd definitions into a
 common directory
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Will review and merge tonight or tomorrow morning.

On Mon, Sep 6, 2021 at 9:57 PM ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>
> On Tue, Sep 7, 2021 at 11:04 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
> >
> > Hi Ronnie,
> > 2021-09-07 7:46 GMT+09:00, Ronnie Sahlberg <lsahlber@redhat.com>:
> > > Steve, Namjae,
> > >
> > > Here is a start of work to share common definitions between the cifs client
> > > and the server.
> > > The patches build ontop of Namjaes patch to rework the smb2_hdr structure
> > > that he recently sent to the list.
> > >
> > > It creates a new shared smb2pdu.h file and starts moving definitions over.
> > > The two copies of smb2pdu.h, in cifs/ and ksmbd/ have diverged a bit
> > > so some things are being renamed in these patches.
> > > NegotiateProtocol is in two separate patches since for this funciton the
> > > changes are a little more than just renames, for example I change several
> > > arrays at the tail of structures from [number] to simply []
> > > so that needs careful review.
> > >
> > > Two patches are for cifs and cifs_common and two patches are for ksmbd.
> > > The ksmbd patches depend on the cifs patches so the cifs patches have to go
> > > in first.
> > When I try build test with sparse, I can see build warnings.
> > I will test more.
>
> Thanks.  I have fixed the sparse warning and resent.
>
> >
> > $ make fs/ksmbd/ksmbd.ko C=1 CHECK=/home/linkinjeon/sparse-dev/sparse
> > CF=-D__CHECK_ENDIAN__
> >
> > ...
> >   CC [M]  fs/ksmbd/unicode.o
> >   CHECK   fs/ksmbd/unicode.c
> >   CC [M]  fs/ksmbd/auth.o
> >   CHECK   fs/ksmbd/auth.c
> > fs/ksmbd/auth.c:1267:39: warning: cast to restricted __le64
> >   CC [M]  fs/ksmbd/vfs.o
> >   CHECK   fs/ksmbd/vfs.c
> >   CC [M]  fs/ksmbd/vfs_cache.o
> >   CHECK   fs/ksmbd/vfs_cache.c
> >   CC [M]  fs/ksmbd/server.o
> >   CHECK   fs/ksmbd/server.c
> >   CC [M]  fs/ksmbd/ndr.o
> >   CHECK   fs/ksmbd/ndr.c
> >   CC [M]  fs/ksmbd/misc.o
> >   CHECK   fs/ksmbd/misc.c
> >   CC [M]  fs/ksmbd/oplock.o
> >   CHECK   fs/ksmbd/oplock.c
> >   CC [M]  fs/ksmbd/connection.o
> >   CHECK   fs/ksmbd/connection.c
> >   CC [M]  fs/ksmbd/ksmbd_work.o
> >   CHECK   fs/ksmbd/ksmbd_work.c
> >   CC [M]  fs/ksmbd/crypto_ctx.o
> >   CHECK   fs/ksmbd/crypto_ctx.c
> >   CC [M]  fs/ksmbd/mgmt/ksmbd_ida.o
> >   CHECK   fs/ksmbd/mgmt/ksmbd_ida.c
> >   CC [M]  fs/ksmbd/mgmt/user_config.o
> >   CHECK   fs/ksmbd/mgmt/user_config.c
> >   CC [M]  fs/ksmbd/mgmt/share_config.o
> >   CHECK   fs/ksmbd/mgmt/share_config.c
> >   CC [M]  fs/ksmbd/mgmt/tree_connect.o
> >   CHECK   fs/ksmbd/mgmt/tree_connect.c
> >   CC [M]  fs/ksmbd/mgmt/user_session.o
> >   CHECK   fs/ksmbd/mgmt/user_session.c
> >   CC [M]  fs/ksmbd/smb_common.o
> >   CHECK   fs/ksmbd/smb_common.c
> >   CC [M]  fs/ksmbd/transport_tcp.o
> >   CHECK   fs/ksmbd/transport_tcp.c
> >   CC [M]  fs/ksmbd/transport_ipc.o
> >   CHECK   fs/ksmbd/transport_ipc.c
> >   CC [M]  fs/ksmbd/smbacl.o
> >   CHECK   fs/ksmbd/smbacl.c
> >   CC [M]  fs/ksmbd/smb2pdu.o
> >   CHECK   fs/ksmbd/smb2pdu.c
> > fs/ksmbd/smb2pdu.c:781:29: warning: incorrect type in assignment
> > (different base types)
> > fs/ksmbd/smb2pdu.c:781:29:    expected unsigned int [usertype] Reserved
> > fs/ksmbd/smb2pdu.c:781:29:    got restricted __le32 [usertype]
> > fs/ksmbd/smb2pdu.c:783:26: warning: incorrect type in assignment
> > (different base types)
> > fs/ksmbd/smb2pdu.c:783:26:    expected unsigned int [usertype] Flags
> > fs/ksmbd/smb2pdu.c:783:26:    got restricted __le32 [usertype]
> > fs/ksmbd/smb2pdu.c:794:29: warning: incorrect type in assignment
> > (different base types)
> > fs/ksmbd/smb2pdu.c:794:29:    expected unsigned int [usertype] Reserved
> > fs/ksmbd/smb2pdu.c:794:29:    got restricted __le32 [usertype]
> > fs/ksmbd/smb2pdu.c:8320:47: warning: cast to restricted __le64
> > fs/ksmbd/smb2pdu.c:8322:17: warning: cast to restricted __le64
> >   CC [M]  fs/ksmbd/smb2ops.o
> >   CHECK   fs/ksmbd/smb2ops.c
> >   CC [M]  fs/ksmbd/smb2misc.o
> >   CHECK   fs/ksmbd/smb2misc.c
> >   ASN.1   fs/ksmbd/ksmbd_spnego_negtokeninit.asn1.[ch]
> >   CC [M]  fs/ksmbd/ksmbd_spnego_negtokeninit.asn1.o
> >   CHECK   fs/ksmbd/ksmbd_spnego_negtokeninit.asn1.c
> >   ASN.1   fs/ksmbd/ksmbd_spnego_negtokentarg.asn1.[ch]
> >   CC [M]  fs/ksmbd/ksmbd_spnego_negtokentarg.asn1.o
> >   CHECK   fs/ksmbd/ksmbd_spnego_negtokentarg.asn1.c
> >   CC [M]  fs/ksmbd/asn1.o
> >   CHECK   fs/ksmbd/asn1.c
> >   CC [M]  fs/ksmbd/transport_rdma.o
> >   CHECK   fs/ksmbd/transport_rdma.c
> >   LD [M]  fs/ksmbd/ksmbd.o
> >
> > Thanks!
> > >
> > >
> > >



-- 
Thanks,

Steve
