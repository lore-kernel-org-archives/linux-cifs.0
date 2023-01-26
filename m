Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD357C54E94
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Jan 2023 14:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjAZOnU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Jan 2023 09:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjAZOnT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Jan 2023 09:43:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9061268132
        for <linux-cifs@vger.kernel.org>; Thu, 26 Jan 2023 06:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674744133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+HrjPjCFkP0quCRpzn0CJ2FwPlY9p2QBxKdKjOfGKrw=;
        b=bfoR2+9GPOm5DuukakvtlNaHBsrlkIvj0be+s8Wx/E+ZVDLoN5fKDRmfsprSF72NYiHTKM
        E1jzXzCM7Ll8AEguv/zhmjoB9xvnC/7x6hMogcaDaIvHy1t3kXHjTr9T6sHtNLooxWTyYq
        yNejZhw3Qq+u5GIVOaAYV+X536InKbw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-Lw6G9vGwO66fust6V9WW2g-1; Thu, 26 Jan 2023 09:42:09 -0500
X-MC-Unique: Lw6G9vGwO66fust6V9WW2g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7BD1857D0D;
        Thu, 26 Jan 2023 14:42:08 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D3CE1121330;
        Thu, 26 Jan 2023 14:42:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <06b1c12f-7662-d822-4c8d-4f76f7e8ab01@talpey.com>
References: <06b1c12f-7662-d822-4c8d-4f76f7e8ab01@talpey.com> <3006f2ac-c70f-57d0-8286-ffd5892571f7@talpey.com> <fa35788a-c858-11c5-5d9a-1d5c837020b6@talpey.com> <1130899.1674582538@warthog.procyon.org.uk> <2132364.1674655333@warthog.procyon.org.uk> <2302242.1674679279@warthog.procyon.org.uk> <2341329.1674686619@warthog.procyon.org.uk>
To:     Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>
Cc:     dhowells@redhat.com, Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org
Subject: pcap of misbehaving fallocate over cifs rdma
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Date:   Thu, 26 Jan 2023 14:42:06 +0000
Message-ID: <2811906.1674744126@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--=-=-=
Content-Type: text/plain


Hi Tom, Steve,

Could you take a look at the attached and see if you can tell me why it's
going wrong?  It's a server-side packet capture of:

    # rdma link add siw0 type siw netdev enp6s0 # andromeda, softIWarp
    # mount //192.168.6.1/test /xfstest.test -o user=shares,pass=foobar,rdma
    # fallocate -l 1M /xfstest.test/hello
    fallocate: fallocate failed: Resource temporarily unavailable
    # dd if=/dev/zero of=/xfstest.test/hello2 bs=16k count=1 oflag=direct conv=notrunc seek=2
    1+0 records in
    1+0 records out
    16384 bytes (16 kB, 16 KiB) copied, 0.108858 s, 151 kB/s
    # umount /xfstest.test 

I altered the code to only send 16K of data at a time during the fallocate so
that each block should fit within one message, but it fails whilst sending the
first write.

The fallocate starts at frame 74.  There's an Ioctl exchange and then it
starts using "DDP/RDMA Send" to shovel data across (the data looks right), but
the server sends a Terminate packet in frame 90 before the client's Send is
complete.  The Send completes in frame 92 and the wireshark decoder seems to
like it.

For comparison I also did a DIO write with dd.  That starts in frame 125 and
uses a different mechanism (DDP/RDMA Read Request and Read Response) to shovel
the data - and that completes successfully.

I've switched the encryption back to auto, so it's not doing transport
encryption.

Thanks,
David


--=-=-=
Content-Type: application/gzip
Content-Disposition: attachment; filename=cifs-iwarp-falloc.pcap.gz
Content-Transfer-Encoding: base64

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
--=-=-=--

