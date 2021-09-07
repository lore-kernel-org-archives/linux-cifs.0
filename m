Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C1CAC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 08:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AAFE60F45
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 08:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243065AbhIGIl5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Sep 2021 04:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243103AbhIGIly (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 7 Sep 2021 04:41:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3C1360F45
        for <linux-cifs@vger.kernel.org>; Tue,  7 Sep 2021 08:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631004044;
        bh=srYURh0Ul6W50zq48vgnYheaC33vYUxgzbT46wajMc0=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=T6AJLXoN1uxgm17/LLmp+BINBBXNyz12vuFdwqv3JS1nLY2f+th6P5vM2pLCTuZwc
         mGl81kCxl/LFZ3IB9ij4ZR5EAYtreouSJ4tGrPmO/M33mD7tPQypSW98BR7/XCe2ki
         q84dUKDgVdJz/+HBcbTg8iMPP2jw+yyLmGaXxFP4N3WlmzbqZFsGRATBz888eKoGan
         ZMLahbqS3oYg4wgyKSYBnMIMfJJ3tzznyEKAEbFZdMW9ohZtLXfjhBzELyLVayfG2B
         +6E4ZU8SgSe08Y0yg+oEJUxcPoIR4vfY+8/s/29HI0bd04LxWx/LAAbHQ70OWcLupG
         xEh+gA2hCPJbg==
Received: by mail-ot1-f47.google.com with SMTP id l7-20020a0568302b0700b0051c0181deebso11848029otv.12
        for <linux-cifs@vger.kernel.org>; Tue, 07 Sep 2021 01:40:44 -0700 (PDT)
X-Gm-Message-State: AOAM5329fpatVcQBMABkq4ZjcSZBHBgeDrI3O7Z17p+7FZ1OIxfHLIDl
        WkPsQffr1q0HdGBZjGYuEu0qwDK/SoG4NKP+BX0=
X-Google-Smtp-Source: ABdhPJwCBuQTIsfVxwe1/XglQxJMQNk0F7LdeqgFwmXgZywihTejClQtGPWsZHMSNW08DjVjZ2teuBhD/izWvzs8O0s=
X-Received: by 2002:a9d:6c04:: with SMTP id f4mr13829953otq.185.1631004044294;
 Tue, 07 Sep 2021 01:40:44 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:74d:0:0:0:0:0 with HTTP; Tue, 7 Sep 2021 01:40:43 -0700 (PDT)
In-Reply-To: <CAN05THTAueSnLc=iSt=W5ioWcPJXXKOw3-256HUqJ2SgPC1AJg@mail.gmail.com>
References: <20210906224648.2062040-1-lsahlber@redhat.com> <CAKYAXd_9VSQsiG0KgGWRJ=UkCLBDGrw5+z8vqxLeSWiw4-uYLw@mail.gmail.com>
 <CAN05THTAueSnLc=iSt=W5ioWcPJXXKOw3-256HUqJ2SgPC1AJg@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 7 Sep 2021 17:40:43 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8tfJ94oh5hs3JBpnEswNepLuJ6PgNhc-BAqOixwgD6CQ@mail.gmail.com>
Message-ID: <CAKYAXd8tfJ94oh5hs3JBpnEswNepLuJ6PgNhc-BAqOixwgD6CQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] Start moving common cifs/ksmbd definitions into a
 common directory
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-07 11:57 GMT+09:00, ronnie sahlberg <ronniesahlberg@gmail.com>:
> On Tue, Sep 7, 2021 at 11:04 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>>
>> Hi Ronnie,
>> 2021-09-07 7:46 GMT+09:00, Ronnie Sahlberg <lsahlber@redhat.com>:
>> > Steve, Namjae,
>> >
>> > Here is a start of work to share common definitions between the cifs
>> > client
>> > and the server.
>> > The patches build ontop of Namjaes patch to rework the smb2_hdr
>> > structure
>> > that he recently sent to the list.
>> >
>> > It creates a new shared smb2pdu.h file and starts moving definitions
>> > over.
>> > The two copies of smb2pdu.h, in cifs/ and ksmbd/ have diverged a bit
>> > so some things are being renamed in these patches.
>> > NegotiateProtocol is in two separate patches since for this funciton
>> > the
>> > changes are a little more than just renames, for example I change
>> > several
>> > arrays at the tail of structures from [number] to simply []
>> > so that needs careful review.
>> >
>> > Two patches are for cifs and cifs_common and two patches are for ksmbd.
>> > The ksmbd patches depend on the cifs patches so the cifs patches have to
>> > go
>> > in first.
>> When I try build test with sparse, I can see build warnings.
>> I will test more.
>
> Thanks.  I have fixed the sparse warning and resent.
It work fine, and looks good to me.
I will apply ksmbd's patches to my queue. and send them to Steve after
cifs's patches are applied first.

Thanks!
>
>>
>> $ make fs/ksmbd/ksmbd.ko C=1 CHECK=/home/linkinjeon/sparse-dev/sparse
>> CF=-D__CHECK_ENDIAN__
>>
>> ...
>>   CC [M]  fs/ksmbd/unicode.o
>>   CHECK   fs/ksmbd/unicode.c
>>   CC [M]  fs/ksmbd/auth.o
>>   CHECK   fs/ksmbd/auth.c
>> fs/ksmbd/auth.c:1267:39: warning: cast to restricted __le64
>>   CC [M]  fs/ksmbd/vfs.o
>>   CHECK   fs/ksmbd/vfs.c
>>   CC [M]  fs/ksmbd/vfs_cache.o
>>   CHECK   fs/ksmbd/vfs_cache.c
>>   CC [M]  fs/ksmbd/server.o
>>   CHECK   fs/ksmbd/server.c
>>   CC [M]  fs/ksmbd/ndr.o
>>   CHECK   fs/ksmbd/ndr.c
>>   CC [M]  fs/ksmbd/misc.o
>>   CHECK   fs/ksmbd/misc.c
>>   CC [M]  fs/ksmbd/oplock.o
>>   CHECK   fs/ksmbd/oplock.c
>>   CC [M]  fs/ksmbd/connection.o
>>   CHECK   fs/ksmbd/connection.c
>>   CC [M]  fs/ksmbd/ksmbd_work.o
>>   CHECK   fs/ksmbd/ksmbd_work.c
>>   CC [M]  fs/ksmbd/crypto_ctx.o
>>   CHECK   fs/ksmbd/crypto_ctx.c
>>   CC [M]  fs/ksmbd/mgmt/ksmbd_ida.o
>>   CHECK   fs/ksmbd/mgmt/ksmbd_ida.c
>>   CC [M]  fs/ksmbd/mgmt/user_config.o
>>   CHECK   fs/ksmbd/mgmt/user_config.c
>>   CC [M]  fs/ksmbd/mgmt/share_config.o
>>   CHECK   fs/ksmbd/mgmt/share_config.c
>>   CC [M]  fs/ksmbd/mgmt/tree_connect.o
>>   CHECK   fs/ksmbd/mgmt/tree_connect.c
>>   CC [M]  fs/ksmbd/mgmt/user_session.o
>>   CHECK   fs/ksmbd/mgmt/user_session.c
>>   CC [M]  fs/ksmbd/smb_common.o
>>   CHECK   fs/ksmbd/smb_common.c
>>   CC [M]  fs/ksmbd/transport_tcp.o
>>   CHECK   fs/ksmbd/transport_tcp.c
>>   CC [M]  fs/ksmbd/transport_ipc.o
>>   CHECK   fs/ksmbd/transport_ipc.c
>>   CC [M]  fs/ksmbd/smbacl.o
>>   CHECK   fs/ksmbd/smbacl.c
>>   CC [M]  fs/ksmbd/smb2pdu.o
>>   CHECK   fs/ksmbd/smb2pdu.c
>> fs/ksmbd/smb2pdu.c:781:29: warning: incorrect type in assignment
>> (different base types)
>> fs/ksmbd/smb2pdu.c:781:29:    expected unsigned int [usertype] Reserved
>> fs/ksmbd/smb2pdu.c:781:29:    got restricted __le32 [usertype]
>> fs/ksmbd/smb2pdu.c:783:26: warning: incorrect type in assignment
>> (different base types)
>> fs/ksmbd/smb2pdu.c:783:26:    expected unsigned int [usertype] Flags
>> fs/ksmbd/smb2pdu.c:783:26:    got restricted __le32 [usertype]
>> fs/ksmbd/smb2pdu.c:794:29: warning: incorrect type in assignment
>> (different base types)
>> fs/ksmbd/smb2pdu.c:794:29:    expected unsigned int [usertype] Reserved
>> fs/ksmbd/smb2pdu.c:794:29:    got restricted __le32 [usertype]
>> fs/ksmbd/smb2pdu.c:8320:47: warning: cast to restricted __le64
>> fs/ksmbd/smb2pdu.c:8322:17: warning: cast to restricted __le64
>>   CC [M]  fs/ksmbd/smb2ops.o
>>   CHECK   fs/ksmbd/smb2ops.c
>>   CC [M]  fs/ksmbd/smb2misc.o
>>   CHECK   fs/ksmbd/smb2misc.c
>>   ASN.1   fs/ksmbd/ksmbd_spnego_negtokeninit.asn1.[ch]
>>   CC [M]  fs/ksmbd/ksmbd_spnego_negtokeninit.asn1.o
>>   CHECK   fs/ksmbd/ksmbd_spnego_negtokeninit.asn1.c
>>   ASN.1   fs/ksmbd/ksmbd_spnego_negtokentarg.asn1.[ch]
>>   CC [M]  fs/ksmbd/ksmbd_spnego_negtokentarg.asn1.o
>>   CHECK   fs/ksmbd/ksmbd_spnego_negtokentarg.asn1.c
>>   CC [M]  fs/ksmbd/asn1.o
>>   CHECK   fs/ksmbd/asn1.c
>>   CC [M]  fs/ksmbd/transport_rdma.o
>>   CHECK   fs/ksmbd/transport_rdma.c
>>   LD [M]  fs/ksmbd/ksmbd.o
>>
>> Thanks!
>> >
>> >
>> >
>
