Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C698AC27C76
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Jan 2023 20:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbjAYUnT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Jan 2023 15:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbjAYUnS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Jan 2023 15:43:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E91E5DC21
        for <linux-cifs@vger.kernel.org>; Wed, 25 Jan 2023 12:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674679283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MOmI9Fj3K4ooX/CBSGbueaaFfga6QnMCqAHyVVJnNLY=;
        b=i9OJc98WPY7vcZccye7dviX5Dhnxoe64/HGpZTPdVFEcvxPibBCoe4dMvVWnxeWndwfGGb
        Z5+a94NiF185vflJ9kFHo3G5mMWCSZ8sFFF7ENXX/qYBE8SyZcY5VL2Ox8VM45d0x05k7u
        vqxZGtdwN4RXJiF0sNEkc+6XyM1QRLg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-9Tb0Q360O3mXiGM7qbeOWA-1; Wed, 25 Jan 2023 15:41:21 -0500
X-MC-Unique: 9Tb0Q360O3mXiGM7qbeOWA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07C2F183B3C0;
        Wed, 25 Jan 2023 20:41:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 931CA1121330;
        Wed, 25 Jan 2023 20:41:19 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <fa35788a-c858-11c5-5d9a-1d5c837020b6@talpey.com>
References: <fa35788a-c858-11c5-5d9a-1d5c837020b6@talpey.com> <1130899.1674582538@warthog.procyon.org.uk> <2132364.1674655333@warthog.procyon.org.uk>
To:     Tom Talpey <tom@talpey.com>
Cc:     dhowells@redhat.com, Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix oops due to uncleared server->smbd_conn in reconnect
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2302241.1674679279.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 25 Jan 2023 20:41:19 +0000
Message-ID: <2302242.1674679279@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Tom,

Steve suggested I should ask you about this.

I have IWarp RDMA mostly working with my iteratorisation patches - certain=
ly
better than without them, but I think that's mostly due to the patch that
Stefan Metzmacher so dislikes ("cifs: Fix problem with encrypted RDMA data
read").

However, fallocate doesn't work:

   # rdma link add siw0 type siw netdev enp6s0 # andromeda, softIWarp
   # mount //192.168.6.1/test /xfstest.test -o user=3Dshares,pass=3Dfoobar=
,rdma
   # fallocate -l 1M /xfstest.test/hello
   fallocate: fallocate failed: Resource temporarily unavailable

Because smb3_simple_fallocate_write_range() calls SMB2_write(), which call=
s
cifs_send_recv() then compound_send_recv() and thence to smb_send_rqst().

smb_send_rqst() encrypts the buffer it is given and smbd_send() attempts t=
o
shovel it to the server using Direct Data Placement - which I think might =
fail
because the data is encrypted.

In one run of the above commands, the data in the kvec array looked like:

fe534d42400001000000000009000a0000000000000000001600000000000000a013000002=
00
00000000000000000000000000000000000000000000000000000000000000000000000000=
00

before the smb_send_rqst() gets to ->init_transform_rq() and like:

98eddc1bc31da7c55c00341e4dc769fa4c8b2b0ecdacbad33eb31855ec162fa2458b8437ed=
c7
88ee0a033c84aa857b65ab31ce553594d412719cc3daf925e873e80062ec16b97c855721a4=
2d

after.  The encrypted data is seen on the wire in DDP/RDMA packets.

Any thoughts as to how to fix this?

Does it need to pass a flag down to suppress the encryption or suppress th=
e
use of direct data placement?  Or should it perhaps go through something l=
ike
->write_iter()?

Note also that it encrypts the buffer in place and then
smb3_simple_fallocate_write_range() reuses the buffer multiple times witho=
ut
clearing it.

I've pushed my cifs iteratorisation patches to:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log=
/?h=3Diov-cifs

I can post them by email a bit later.

David

