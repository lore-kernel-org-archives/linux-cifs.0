Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AF3C05027
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Jan 2023 20:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjAZUtM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Jan 2023 15:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjAZUtL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Jan 2023 15:49:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B362F1BD8
        for <linux-cifs@vger.kernel.org>; Thu, 26 Jan 2023 12:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674766088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QOa1f6eDeA/kW0lQNCHenMzIgi8GWue4frugwTASAHI=;
        b=DK+zjFPCpAestBUySHkpILiA+yyWwHMF2jMpHLnUjuQxlu6EneHHyckeDrBgQwcQC4gGIq
        jXtn/GFryvidTjRieCtfyfSDMcYhem2YGJ5f2JDM+rETXT2iVREoadu+1Ac04m28pl5tCZ
        6OXGUYG7WDQbzrBkYgCgkBHdGdD5QqQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-Yb31RANPP-ChQKOJ3tSVxQ-1; Thu, 26 Jan 2023 15:47:57 -0500
X-MC-Unique: Yb31RANPP-ChQKOJ3tSVxQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E64A380450C;
        Thu, 26 Jan 2023 20:47:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C28384014EBE;
        Thu, 26 Jan 2023 20:47:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <104c2782-4d9a-22ce-d680-08d01733fb4e@talpey.com>
References: <104c2782-4d9a-22ce-d680-08d01733fb4e@talpey.com> <CAH2r5mupuFEw4hY7uOYjeHi08pS9vv3n30KppR_CTrKZ4xAdnw@mail.gmail.com> <3006f2ac-c70f-57d0-8286-ffd5892571f7@talpey.com> <fa35788a-c858-11c5-5d9a-1d5c837020b6@talpey.com> <1130899.1674582538@warthog.procyon.org.uk> <2132364.1674655333@warthog.procyon.org.uk> <2302242.1674679279@warthog.procyon.org.uk> <2341329.1674686619@warthog.procyon.org.uk> <06b1c12f-7662-d822-4c8d-4f76f7e8ab01@talpey.com> <2811906.1674744126@warthog.procyon.org.uk> <2896646.1674762874@warthog.procyon.org.uk>
To:     Tom Talpey <tom@talpey.com>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org
Subject: Re: pcap of misbehaving fallocate over cifs rdma
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 26 Jan 2023 20:47:55 +0000
Message-ID: <2899394.1674766075@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tom Talpey <tom@talpey.com> wrote:

> That's a really large SMBDirect Send operation, it looks like it's
> trying to send the entire write in one message and it overflows
> the receive buffer.
>=20
> I'm still fighting with wireshark and can't decode the layers
> above TCP. Can you look at the SMBDirect negotiation at the
> start of the trace, and tell me what the max send/receive
> values were set by each side?

Frame 8: 110 bytes on wire (880 bits), 110 bytes captured (880 bits) on int=
erface enp2s0, id 0
Ethernet II, Src: IntelCor_bb:e6:30 (00:1b:21:bb:e6:30), Dst: IntelCor_bb:e=
6:ac (00:1b:21:bb:e6:ac)
Internet Protocol Version 4, Src: 192.168.6.2, Dst: 192.168.6.1
Transmission Control Protocol, Src Port: 50018, Dst Port: 5445, Seq: 33, Ac=
k: 33, Len: 44
iWARP Marker Protocol data unit Aligned framing
iWARP Direct Data Placement and Remote Direct Memory Access Protocol
SMB-Direct (SMB RDMA Transport)
    NegotiateRequest
        MinVersion: 0x0100
        MaxVersion: 0x0100
        CreditsRequested: 255
        PreferredSendSize: 1364
        MaxReceiveSize: 1364
        MaxFragmentedSize: 1048576

Frame 9: 122 bytes on wire (976 bits), 122 bytes captured (976 bits) on int=
erface enp2s0, id 0
Ethernet II, Src: IntelCor_bb:e6:ac (00:1b:21:bb:e6:ac), Dst: IntelCor_bb:e=
6:30 (00:1b:21:bb:e6:30)
Internet Protocol Version 4, Src: 192.168.6.1, Dst: 192.168.6.2
Transmission Control Protocol, Src Port: 5445, Dst Port: 50018, Seq: 33, Ac=
k: 77, Len: 56
iWARP Marker Protocol data unit Aligned framing
iWARP Direct Data Placement and Remote Direct Memory Access Protocol
SMB-Direct (SMB RDMA Transport)
    NegotiateResponse
        MinVersion: 0x0100
        MaxVersion: 0x0100
        NegotiatedVersion: 0x0100
        CreditsRequested: 255
        CreditsGranted: 254
        Status: STATUS_SUCCESS (0x00000000)
        MaxReadWriteSize: 524224
        PreferredSendSize: 1364
        MaxReceiveSize: 1364
        MaxFragmentedSize: 173910

Frame 10: 110 bytes on wire (880 bits), 110 bytes captured (880 bits) on in=
terface enp2s0, id 0
Ethernet II, Src: IntelCor_bb:e6:30 (00:1b:21:bb:e6:30), Dst: IntelCor_bb:e=
6:ac (00:1b:21:bb:e6:ac)
Internet Protocol Version 4, Src: 192.168.6.2, Dst: 192.168.6.1
Transmission Control Protocol, Src Port: 50018, Dst Port: 5445, Seq: 77, Ac=
k: 89, Len: 44
iWARP Marker Protocol data unit Aligned framing
iWARP Direct Data Placement and Remote Direct Memory Access Protocol
SMB-Direct (SMB RDMA Transport)
    DataMessage
        CreditsRequested: 255
        CreditsGranted: 255
        Flags: 0x0000
            .... .... .... ...0 =3D ResponseRequested: False
        RemainingLength: 0
        DataOffset: 0
        DataLength: 0

Frame 11: 346 bytes on wire (2768 bits), 346 bytes captured (2768 bits) on =
interface enp2s0, id 0
Ethernet II, Src: IntelCor_bb:e6:30 (00:1b:21:bb:e6:30), Dst: IntelCor_bb:e=
6:ac (00:1b:21:bb:e6:ac)
Internet Protocol Version 4, Src: 192.168.6.2, Dst: 192.168.6.1
Transmission Control Protocol, Src Port: 50018, Dst Port: 5445, Seq: 121, A=
ck: 89, Len: 280
iWARP Marker Protocol data unit Aligned framing
iWARP Direct Data Placement and Remote Direct Memory Access Protocol
SMB-Direct (SMB RDMA Transport)
    DataMessage
        CreditsRequested: 255
        CreditsGranted: 0
        Flags: 0x0000
            .... .... .... ...0 =3D ResponseRequested: False
        RemainingLength: 0
        DataOffset: 24
        DataLength: 232
SMB2 (Server Message Block Protocol version 2)
    SMB2 Header
        ProtocolId: 0xfe534d42
        Header Length: 64
        Credit Charge: 0
        Channel Sequence: 0
        Reserved: 0000
        Command: Negotiate Protocol (0)
        Credits requested: 10
        Flags: 0x00000000
        Chain Offset: 0x00000000
        Message ID: 0
        Process Id: 0x000013c5
        Tree Id: 0x00000000
        Session Id: 0x0000000000000000
        Signature: 00000000000000000000000000000000
        [Response in: 13]
    Negotiate Protocol Request (0x00)
        [Preauth Hash: 81cd52dea94ed363a171b7effe222c0003574f5c54f6c7a1cbb0=
41676ea9ddf15245b2a4=E2=80=A6]
        StructureSize: 0x0024
        Dialect count: 4
        Security mode: 0x01, Signing enabled
        Reserved: 0000
        Capabilities: 0x00000077, DFS, LEASING, LARGE MTU, PERSISTENT HANDL=
ES, DIRECTORY LEASING, ENCRYPTION
        Client Guid: c494649a-e636-d94c-a55e-be00d5a02a30
        NegotiateContextOffset: 0x00000070
        NegotiateContextCount: 4
        Reserved: 0000
        Dialect: SMB 2.1 (0x0210)
        Dialect: SMB 3.0 (0x0300)
        Dialect: SMB 3.0.2 (0x0302)
        Dialect: SMB 3.1.1 (0x0311)
        Negotiate Context: SMB2_PREAUTH_INTEGRITY_CAPABILITIES=20
            Type: SMB2_PREAUTH_INTEGRITY_CAPABILITIES (0x0001)
            DataLength: 38
            Reserved: 00000000
            HashAlgorithmCount: 1
            SaltLength: 32
            HashAlgorithm: SHA-512 (0x0001)
            Salt: 1d6e14b44264b6cc1db622478c3826c4cd09df1dc70abf73f13b92617=
24d4181
        Negotiate Context: SMB2_ENCRYPTION_CAPABILITIES=20
            Type: SMB2_ENCRYPTION_CAPABILITIES (0x0002)
            DataLength: 8
            Reserved: 00000000
            CipherCount: 3
            CipherId: AES-128-GCM (0x0002)
            CipherId: AES-256-GCM (0x0004)
            CipherId: AES-128-CCM (0x0001)
        Negotiate Context: SMB2_NETNAME_NEGOTIATE_CONTEXT_ID=20
            Type: SMB2_NETNAME_NEGOTIATE_CONTEXT_ID (0x0005)
            DataLength: 22
            Reserved: 00000000
            Netname: 192.168.6.1
        Negotiate Context: SMB2_POSIX_EXTENSIONS_CAPABILITIES=20
            Type: SMB2_POSIX_EXTENSIONS_CAPABILITIES (0x0100)
            DataLength: 16
            Reserved: 00000000
            POSIX Reserved: 93ad25509cb411e7b42383de968bcd7c

