Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C18C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 01:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3DEF6108F
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 01:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237897AbhIGBEV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Sep 2021 21:04:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231728AbhIGBEV (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 6 Sep 2021 21:04:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F23706054F
        for <linux-cifs@vger.kernel.org>; Tue,  7 Sep 2021 01:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630976596;
        bh=tzvIQveUs3zAMV5ezRj48lCFXSJvlahWEGc0i4Lxbm4=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=TawFrJ8KIyBQSV3oM86MXNC5Gsx6coMbteUBUxibqbPX87KdUAfUMA8Rdkcly424D
         DXYWG35Rdxwfxo+xTT+7T2nmqSVVW0+F4izOOQ5QennGPeJ8uWWDmlIzI/MtEZUBTG
         YK3Ur/tSbMiFHexstbpoMpDgMa1PIpQKj2xaSirKHqTGsBCPDik+m0/+vq2roJZPdf
         z/CJ6avdGMFfPUYZHSs4zCEv20C6H1+4TjhpkKjrMiF4FlfSb30U2X6ccmuF4lAgLt
         mxyBWxrnY80YcmGNgc8UyZn2GUB0MWX+e5cRDdEcMOJTC0kLFLS8ZNSQJ58UhyeIyS
         FbQIbFUaPCtzQ==
Received: by mail-ot1-f50.google.com with SMTP id c19-20020a9d6153000000b0051829acbfc7so10736411otk.9
        for <linux-cifs@vger.kernel.org>; Mon, 06 Sep 2021 18:03:15 -0700 (PDT)
X-Gm-Message-State: AOAM532U0+NXANF/J7a1e1L09jGHqzugvQPNKqSHzzx51qKamxvXA/nj
        vmuZSqlKk3i1TZ8nkxL/50yj0a4J2yn0N1lMZx4=
X-Google-Smtp-Source: ABdhPJwU4BGCJf0LKTpGwGhSnXwz3jhUxCy0HEPl+6f5yVlZNHWiAUii8C9gVtFFZ/m1/Ekpml68CP7W/an43pEAZSk=
X-Received: by 2002:a9d:5e05:: with SMTP id d5mr12637236oti.61.1630976595285;
 Mon, 06 Sep 2021 18:03:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:74d:0:0:0:0:0 with HTTP; Mon, 6 Sep 2021 18:03:14 -0700 (PDT)
In-Reply-To: <20210906224648.2062040-1-lsahlber@redhat.com>
References: <20210906224648.2062040-1-lsahlber@redhat.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 7 Sep 2021 10:03:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_9VSQsiG0KgGWRJ=UkCLBDGrw5+z8vqxLeSWiw4-uYLw@mail.gmail.com>
Message-ID: <CAKYAXd_9VSQsiG0KgGWRJ=UkCLBDGrw5+z8vqxLeSWiw4-uYLw@mail.gmail.com>
Subject: Re: [PATCH 0/4] Start moving common cifs/ksmbd definitions into a
 common directory
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Ronnie,
2021-09-07 7:46 GMT+09:00, Ronnie Sahlberg <lsahlber@redhat.com>:
> Steve, Namjae,
>
> Here is a start of work to share common definitions between the cifs client
> and the server.
> The patches build ontop of Namjaes patch to rework the smb2_hdr structure
> that he recently sent to the list.
>
> It creates a new shared smb2pdu.h file and starts moving definitions over.
> The two copies of smb2pdu.h, in cifs/ and ksmbd/ have diverged a bit
> so some things are being renamed in these patches.
> NegotiateProtocol is in two separate patches since for this funciton the
> changes are a little more than just renames, for example I change several
> arrays at the tail of structures from [number] to simply []
> so that needs careful review.
>
> Two patches are for cifs and cifs_common and two patches are for ksmbd.
> The ksmbd patches depend on the cifs patches so the cifs patches have to go
> in first.
When I try build test with sparse, I can see build warnings.
I will test more.

$ make fs/ksmbd/ksmbd.ko C=1 CHECK=/home/linkinjeon/sparse-dev/sparse
CF=-D__CHECK_ENDIAN__

...
  CC [M]  fs/ksmbd/unicode.o
  CHECK   fs/ksmbd/unicode.c
  CC [M]  fs/ksmbd/auth.o
  CHECK   fs/ksmbd/auth.c
fs/ksmbd/auth.c:1267:39: warning: cast to restricted __le64
  CC [M]  fs/ksmbd/vfs.o
  CHECK   fs/ksmbd/vfs.c
  CC [M]  fs/ksmbd/vfs_cache.o
  CHECK   fs/ksmbd/vfs_cache.c
  CC [M]  fs/ksmbd/server.o
  CHECK   fs/ksmbd/server.c
  CC [M]  fs/ksmbd/ndr.o
  CHECK   fs/ksmbd/ndr.c
  CC [M]  fs/ksmbd/misc.o
  CHECK   fs/ksmbd/misc.c
  CC [M]  fs/ksmbd/oplock.o
  CHECK   fs/ksmbd/oplock.c
  CC [M]  fs/ksmbd/connection.o
  CHECK   fs/ksmbd/connection.c
  CC [M]  fs/ksmbd/ksmbd_work.o
  CHECK   fs/ksmbd/ksmbd_work.c
  CC [M]  fs/ksmbd/crypto_ctx.o
  CHECK   fs/ksmbd/crypto_ctx.c
  CC [M]  fs/ksmbd/mgmt/ksmbd_ida.o
  CHECK   fs/ksmbd/mgmt/ksmbd_ida.c
  CC [M]  fs/ksmbd/mgmt/user_config.o
  CHECK   fs/ksmbd/mgmt/user_config.c
  CC [M]  fs/ksmbd/mgmt/share_config.o
  CHECK   fs/ksmbd/mgmt/share_config.c
  CC [M]  fs/ksmbd/mgmt/tree_connect.o
  CHECK   fs/ksmbd/mgmt/tree_connect.c
  CC [M]  fs/ksmbd/mgmt/user_session.o
  CHECK   fs/ksmbd/mgmt/user_session.c
  CC [M]  fs/ksmbd/smb_common.o
  CHECK   fs/ksmbd/smb_common.c
  CC [M]  fs/ksmbd/transport_tcp.o
  CHECK   fs/ksmbd/transport_tcp.c
  CC [M]  fs/ksmbd/transport_ipc.o
  CHECK   fs/ksmbd/transport_ipc.c
  CC [M]  fs/ksmbd/smbacl.o
  CHECK   fs/ksmbd/smbacl.c
  CC [M]  fs/ksmbd/smb2pdu.o
  CHECK   fs/ksmbd/smb2pdu.c
fs/ksmbd/smb2pdu.c:781:29: warning: incorrect type in assignment
(different base types)
fs/ksmbd/smb2pdu.c:781:29:    expected unsigned int [usertype] Reserved
fs/ksmbd/smb2pdu.c:781:29:    got restricted __le32 [usertype]
fs/ksmbd/smb2pdu.c:783:26: warning: incorrect type in assignment
(different base types)
fs/ksmbd/smb2pdu.c:783:26:    expected unsigned int [usertype] Flags
fs/ksmbd/smb2pdu.c:783:26:    got restricted __le32 [usertype]
fs/ksmbd/smb2pdu.c:794:29: warning: incorrect type in assignment
(different base types)
fs/ksmbd/smb2pdu.c:794:29:    expected unsigned int [usertype] Reserved
fs/ksmbd/smb2pdu.c:794:29:    got restricted __le32 [usertype]
fs/ksmbd/smb2pdu.c:8320:47: warning: cast to restricted __le64
fs/ksmbd/smb2pdu.c:8322:17: warning: cast to restricted __le64
  CC [M]  fs/ksmbd/smb2ops.o
  CHECK   fs/ksmbd/smb2ops.c
  CC [M]  fs/ksmbd/smb2misc.o
  CHECK   fs/ksmbd/smb2misc.c
  ASN.1   fs/ksmbd/ksmbd_spnego_negtokeninit.asn1.[ch]
  CC [M]  fs/ksmbd/ksmbd_spnego_negtokeninit.asn1.o
  CHECK   fs/ksmbd/ksmbd_spnego_negtokeninit.asn1.c
  ASN.1   fs/ksmbd/ksmbd_spnego_negtokentarg.asn1.[ch]
  CC [M]  fs/ksmbd/ksmbd_spnego_negtokentarg.asn1.o
  CHECK   fs/ksmbd/ksmbd_spnego_negtokentarg.asn1.c
  CC [M]  fs/ksmbd/asn1.o
  CHECK   fs/ksmbd/asn1.c
  CC [M]  fs/ksmbd/transport_rdma.o
  CHECK   fs/ksmbd/transport_rdma.c
  LD [M]  fs/ksmbd/ksmbd.o

Thanks!
>
>
>
