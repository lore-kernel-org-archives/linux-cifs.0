Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225D3C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Jan 2022 15:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbiAMPUj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Jan 2022 10:20:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236053AbiAMPUi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 13 Jan 2022 10:20:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642087238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2HycJAHhyYvFa4kxg660xxfmXbaTQI9ftjm+vMYQjos=;
        b=dq4r5RkGFZ5jYLbuq6+u6dOyX+Q3OrR+Wx948ABcvDPFvzKtMJxZQFQVQ3tO4zdSii3GFm
        VDzgAsnZt7tqOMDgb3gjcJGA2ozDMs1nyC2bTO/kMLueAJF9577m0H6C5Y2ouQG64h/Nna
        KIl5L5UixkKsZMBBnWL0oH0RoOYazrg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-enFVJpsqPzKypfxhYuDdHA-1; Thu, 13 Jan 2022 10:20:35 -0500
X-MC-Unique: enFVJpsqPzKypfxhYuDdHA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2849283DD21;
        Thu, 13 Jan 2022 15:20:34 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2898184D2C;
        Thu, 13 Jan 2022 15:20:33 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <1828480.1642079920@warthog.procyon.org.uk>
References: <1828480.1642079920@warthog.procyon.org.uk>
To:     smfrench@gmail.com
Cc:     dhowells@redhat.com, Shyam Prasad N <nspmangalore@gmail.com>,
        jlayton@kernel.org, linux-cifs@vger.kernel.org
Subject: Incorrect fallocate behaviour in cifs or samba?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1856456.1642087232.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 13 Jan 2022 15:20:32 +0000
Message-ID: <1856457.1642087232@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> If I do the following:
> =

> 	mount //carina/test /xfstest.test -o user=3Dshares,pass=3Dfoobar,noperm=
,vers=3D3.0,mfsymlinks,actimeo=3D0
> 	/usr/sbin/xfs_io -f -t \
> 		-c "pwrite -S 0x41 0 4096"
> 		-c "pwrite -S 0x42 4096 4096"
> 		-c "fzero 0 4096" \
> 		-c "pread 0 8192" \
> 		/xfstest.test/008.7067
> ...
>    31 0.321638749  192.168.6.2 -> 192.168.6.1  SMB2 206 Ioctl Request FS=
CTL_SET_ZERO_DATA File: 008.7067

So what I see is that Samba does:

	fallocate(24, FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE, 0, 4096) =3D 0

for this... but that's not what cifs was asked to do.  Should Samba be usi=
ng
FALLOC_FL_ZERO_RANGE instead?

Also cifs wasn't given FALLOC_FL_KEEP_SIZE, so the caller expected the fil=
e to
be extended - smb3_zero_range(), however, doesn't seem necessarily to get =
this
right.  It seems to allow for KEEP_SIZE not being set by calling
SMB2_set_eof() - but only if the range ends beyond the *local* i_size (whi=
ch
the server doesn't know about yet).

However, we did two pwrites first, which moved the local i_size over.  Thi=
s
means the server's EOF isn't extended - probably correctly, since we haven=
't
saved the data, but the subsequent reads then fail.

In this case, I wonder if the right thing to do is one of the following
options:

 (1) Flush the pagecache before doing proceeding with the fallocate.

 (2) Modify the local pagecache and don't talk to the server at all unless
     there are gaps in the pagecache.

 (3) Keep separate track of where we think the server's EOF is and skip an=
y
     read that's beyond that.

 (4) Treat a read ending in EOF as a read of blank data if it's below the
     local EOF.  I guess that's what we do now.

David

