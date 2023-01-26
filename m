Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72EAFC54EAA
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Jan 2023 19:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbjAZTza (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Jan 2023 14:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjAZTza (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Jan 2023 14:55:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8159F4C36
        for <linux-cifs@vger.kernel.org>; Thu, 26 Jan 2023 11:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674762882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DefNH5gSiUqzgQDwPTMxzu4FZPfQWsnNvQOYofxvDbA=;
        b=O52ui67Wwj0Bu9cWnyyvgqUz94Qk+gkVfHZPiU4jD6bCU1GQJt7MPg/cxnVfSeEmpNjFJT
        vcC9SDaH7SDLDjV9pkh+7YctzaurVadArJ/+xzbNrLu6/i0O+ETuRftbC3qT9wKKey3XPg
        w7vC2bBiByMzc59spBYxaugQVUG6Xcc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-wjApQnzHOYO_scWTVISaEQ-1; Thu, 26 Jan 2023 14:54:37 -0500
X-MC-Unique: wjApQnzHOYO_scWTVISaEQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 767743C0E45B;
        Thu, 26 Jan 2023 19:54:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 253842026D4B;
        Thu, 26 Jan 2023 19:54:35 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5mupuFEw4hY7uOYjeHi08pS9vv3n30KppR_CTrKZ4xAdnw@mail.gmail.com>
References: <CAH2r5mupuFEw4hY7uOYjeHi08pS9vv3n30KppR_CTrKZ4xAdnw@mail.gmail.com> <3006f2ac-c70f-57d0-8286-ffd5892571f7@talpey.com> <fa35788a-c858-11c5-5d9a-1d5c837020b6@talpey.com> <1130899.1674582538@warthog.procyon.org.uk> <2132364.1674655333@warthog.procyon.org.uk> <2302242.1674679279@warthog.procyon.org.uk> <2341329.1674686619@warthog.procyon.org.uk> <06b1c12f-7662-d822-4c8d-4f76f7e8ab01@talpey.com> <2811906.1674744126@warthog.procyon.org.uk>
To:     Steve French <smfrench@gmail.com>
Cc:     dhowells@redhat.com, Tom Talpey <tom@talpey.com>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org
Subject: Re: pcap of misbehaving fallocate over cifs rdma
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2896645.1674762874.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 26 Jan 2023 19:54:34 +0000
Message-ID: <2896646.1674762874@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> wrote:

> I am puzzled ... you show the fallocate failing but why do you mention
> it sending data, sending writes

smb3_simple_fallocate_write_range() sends data.

> - when I try the fallocate you pasted above I see what is in the attache=
d
> screenshot go over the network (no writes) - and your example looks like=
 it
> simply doesn't send anything then resets the session at frame 93

Look at frame 92.  That's the concluding packet of the write performed by
smb3_simple_fallocate_write_range().

  74 4.568861795  192.168.6.2 -> 192.168.6.1  SMB2 250 Ioctl Request FSCTL=
_QUERY_ALLOCATED_RANGES File: hello
   75 4.569429926  192.168.6.1 -> 192.168.6.2  SMB2 242 Ioctl Response FSC=
TL_QUERY_ALLOCATED_RANGES
   77 4.680495774  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 =
Send [more DDP segments]
   78 4.680496219  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 =
Send [more DDP segments]
   79 4.680496364  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 =
Send [more DDP segments]
   80 4.680496552  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 =
Send [more DDP segments]
   81 4.680496698  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 =
Send [more DDP segments]
   82 4.680496844  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 =
Send [more DDP segments]
   83 4.680496989  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 =
Send [more DDP segments]
   84 4.680497177  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 =
Send [more DDP segments]
   88 4.680638842  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 =
Send [more DDP segments]
   89 4.680639016  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 =
Send [more DDP segments]
   90 4.680704523  192.168.6.1 -> 192.168.6.2  DDP/RDMA 114 5445 > 50018 T=
erminate [last DDP segment]
   91 4.680735089  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 =
Send [more DDP segments]
   92 4.680735359  192.168.6.2 -> 192.168.6.1  SMB2 946 Write Request Len:=
16384 Off:204800 File: hello

David

