Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913C2C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 02:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F6B16103E
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 02:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbhIGC63 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Sep 2021 22:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbhIGC63 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Sep 2021 22:58:29 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B89C061575
        for <linux-cifs@vger.kernel.org>; Mon,  6 Sep 2021 19:57:23 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id jg16so16826023ejc.1
        for <linux-cifs@vger.kernel.org>; Mon, 06 Sep 2021 19:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RWza2asXfN/shod2w+f5W6J/UE+Sj19kyLl8+tHlyXU=;
        b=RLfHy6RG2eRwIDOnpToop+qR0KtpmPgtR3uIu0cw6IgE200k75AbEth48AmvFrcUDc
         +qOSBkebp1OaaA5+k4xySZdcZ5XLjxvT96clEqsZqj6gbXSAxxVBsKJkcuvRN61Xpufa
         BBozPUhwgFWr6JX+hVqwcnUqFerZrLcMNYmonumilKtui/ry8kZ60zlQRRpa7EExzsN+
         ftRSEuWI5Fg/+LyVjrcmhRFld69cfbWQks85P2uideWDrN6pH9KZIFNM2BfhioPpbA1Z
         hUh8Vc4FmwxCC2oIm7C0OOolz8XFOdNU3wqsNyRBevA/O/ChiPQUFi5SjxrwmbdEsnNX
         heyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RWza2asXfN/shod2w+f5W6J/UE+Sj19kyLl8+tHlyXU=;
        b=cKTbsQRVPr+2lpixDU3UPBWnb/iJcL4W4nGuXgwTTdYb7ughHJzHmavsvgK2q+p/xX
         FYh17TCTui+9CCAFKOKMIKw5nV44USFeHCti/r6LmRJFwGsxu+f7UehbipB+JGMQ1wXy
         ML2UudQ8ffXH80Ju2cdRA6QJrGpUGe93gCJCuqEMfQ74jEyAao2NWT4k73r9LiPMjszA
         GH/1pebuPh0N+j7ue50ckoDnr/KpJ7xqIXRh+8xRRFdumXFoJ7V0Z+WHLxOLvgmOZadh
         uMyXwZGHF4dPc2vox+vW4u5WiTpRqn2f9/KAQCykamqMU3PogD2xASgaiYP3mZ2L0mLI
         vJJw==
X-Gm-Message-State: AOAM532TRvTqEcIEYyDcSYERLU+BV7oHibhGmyJd9NW5vtrdsK3husxX
        qCvxVvwQH/7Y+8qVPkWnB494nIy2T9xcoVMF6tw=
X-Google-Smtp-Source: ABdhPJxAB3Ijmv/ily5pXe8QKTTqYo3O3qoUTCbGiLmabIPag+BEAVtxF0kLb3W/f7kbeto2n6lbC0Q16dMpXHkz+L4=
X-Received: by 2002:a17:906:fa10:: with SMTP id lo16mr15903122ejb.342.1630983441927;
 Mon, 06 Sep 2021 19:57:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210906224648.2062040-1-lsahlber@redhat.com> <CAKYAXd_9VSQsiG0KgGWRJ=UkCLBDGrw5+z8vqxLeSWiw4-uYLw@mail.gmail.com>
In-Reply-To: <CAKYAXd_9VSQsiG0KgGWRJ=UkCLBDGrw5+z8vqxLeSWiw4-uYLw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 7 Sep 2021 12:57:10 +1000
Message-ID: <CAN05THTAueSnLc=iSt=W5ioWcPJXXKOw3-256HUqJ2SgPC1AJg@mail.gmail.com>
Subject: Re: [PATCH 0/4] Start moving common cifs/ksmbd definitions into a
 common directory
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Sep 7, 2021 at 11:04 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> Hi Ronnie,
> 2021-09-07 7:46 GMT+09:00, Ronnie Sahlberg <lsahlber@redhat.com>:
> > Steve, Namjae,
> >
> > Here is a start of work to share common definitions between the cifs client
> > and the server.
> > The patches build ontop of Namjaes patch to rework the smb2_hdr structure
> > that he recently sent to the list.
> >
> > It creates a new shared smb2pdu.h file and starts moving definitions over.
> > The two copies of smb2pdu.h, in cifs/ and ksmbd/ have diverged a bit
> > so some things are being renamed in these patches.
> > NegotiateProtocol is in two separate patches since for this funciton the
> > changes are a little more than just renames, for example I change several
> > arrays at the tail of structures from [number] to simply []
> > so that needs careful review.
> >
> > Two patches are for cifs and cifs_common and two patches are for ksmbd.
> > The ksmbd patches depend on the cifs patches so the cifs patches have to go
> > in first.
> When I try build test with sparse, I can see build warnings.
> I will test more.

Thanks.  I have fixed the sparse warning and resent.

>
> $ make fs/ksmbd/ksmbd.ko C=1 CHECK=/home/linkinjeon/sparse-dev/sparse
> CF=-D__CHECK_ENDIAN__
>
> ...
>   CC [M]  fs/ksmbd/unicode.o
>   CHECK   fs/ksmbd/unicode.c
>   CC [M]  fs/ksmbd/auth.o
>   CHECK   fs/ksmbd/auth.c
> fs/ksmbd/auth.c:1267:39: warning: cast to restricted __le64
>   CC [M]  fs/ksmbd/vfs.o
>   CHECK   fs/ksmbd/vfs.c
>   CC [M]  fs/ksmbd/vfs_cache.o
>   CHECK   fs/ksmbd/vfs_cache.c
>   CC [M]  fs/ksmbd/server.o
>   CHECK   fs/ksmbd/server.c
>   CC [M]  fs/ksmbd/ndr.o
>   CHECK   fs/ksmbd/ndr.c
>   CC [M]  fs/ksmbd/misc.o
>   CHECK   fs/ksmbd/misc.c
>   CC [M]  fs/ksmbd/oplock.o
>   CHECK   fs/ksmbd/oplock.c
>   CC [M]  fs/ksmbd/connection.o
>   CHECK   fs/ksmbd/connection.c
>   CC [M]  fs/ksmbd/ksmbd_work.o
>   CHECK   fs/ksmbd/ksmbd_work.c
>   CC [M]  fs/ksmbd/crypto_ctx.o
>   CHECK   fs/ksmbd/crypto_ctx.c
>   CC [M]  fs/ksmbd/mgmt/ksmbd_ida.o
>   CHECK   fs/ksmbd/mgmt/ksmbd_ida.c
>   CC [M]  fs/ksmbd/mgmt/user_config.o
>   CHECK   fs/ksmbd/mgmt/user_config.c
>   CC [M]  fs/ksmbd/mgmt/share_config.o
>   CHECK   fs/ksmbd/mgmt/share_config.c
>   CC [M]  fs/ksmbd/mgmt/tree_connect.o
>   CHECK   fs/ksmbd/mgmt/tree_connect.c
>   CC [M]  fs/ksmbd/mgmt/user_session.o
>   CHECK   fs/ksmbd/mgmt/user_session.c
>   CC [M]  fs/ksmbd/smb_common.o
>   CHECK   fs/ksmbd/smb_common.c
>   CC [M]  fs/ksmbd/transport_tcp.o
>   CHECK   fs/ksmbd/transport_tcp.c
>   CC [M]  fs/ksmbd/transport_ipc.o
>   CHECK   fs/ksmbd/transport_ipc.c
>   CC [M]  fs/ksmbd/smbacl.o
>   CHECK   fs/ksmbd/smbacl.c
>   CC [M]  fs/ksmbd/smb2pdu.o
>   CHECK   fs/ksmbd/smb2pdu.c
> fs/ksmbd/smb2pdu.c:781:29: warning: incorrect type in assignment
> (different base types)
> fs/ksmbd/smb2pdu.c:781:29:    expected unsigned int [usertype] Reserved
> fs/ksmbd/smb2pdu.c:781:29:    got restricted __le32 [usertype]
> fs/ksmbd/smb2pdu.c:783:26: warning: incorrect type in assignment
> (different base types)
> fs/ksmbd/smb2pdu.c:783:26:    expected unsigned int [usertype] Flags
> fs/ksmbd/smb2pdu.c:783:26:    got restricted __le32 [usertype]
> fs/ksmbd/smb2pdu.c:794:29: warning: incorrect type in assignment
> (different base types)
> fs/ksmbd/smb2pdu.c:794:29:    expected unsigned int [usertype] Reserved
> fs/ksmbd/smb2pdu.c:794:29:    got restricted __le32 [usertype]
> fs/ksmbd/smb2pdu.c:8320:47: warning: cast to restricted __le64
> fs/ksmbd/smb2pdu.c:8322:17: warning: cast to restricted __le64
>   CC [M]  fs/ksmbd/smb2ops.o
>   CHECK   fs/ksmbd/smb2ops.c
>   CC [M]  fs/ksmbd/smb2misc.o
>   CHECK   fs/ksmbd/smb2misc.c
>   ASN.1   fs/ksmbd/ksmbd_spnego_negtokeninit.asn1.[ch]
>   CC [M]  fs/ksmbd/ksmbd_spnego_negtokeninit.asn1.o
>   CHECK   fs/ksmbd/ksmbd_spnego_negtokeninit.asn1.c
>   ASN.1   fs/ksmbd/ksmbd_spnego_negtokentarg.asn1.[ch]
>   CC [M]  fs/ksmbd/ksmbd_spnego_negtokentarg.asn1.o
>   CHECK   fs/ksmbd/ksmbd_spnego_negtokentarg.asn1.c
>   CC [M]  fs/ksmbd/asn1.o
>   CHECK   fs/ksmbd/asn1.c
>   CC [M]  fs/ksmbd/transport_rdma.o
>   CHECK   fs/ksmbd/transport_rdma.c
>   LD [M]  fs/ksmbd/ksmbd.o
>
> Thanks!
> >
> >
> >
