Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70607C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Jan 2022 13:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbiAMNSs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Jan 2022 08:18:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42937 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232021AbiAMNSr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 13 Jan 2022 08:18:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642079927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=x4Onut1YUt1KbooDHoSQbdX7VbCiHFAqhr9R7c4lsvA=;
        b=MMK9iOCP3z4cZ0L4CjPcDNZad0NI1VyiK6r7p2MpGxpSwoV701eJFE0u+PnXp5F/Q04idS
        wxUnhrtcfnC3LK6aHelR6Hp5e6UiYoYHY0SNd5OtvBDZ70cFmgTSCd+mEcOxaxLw6DIV9S
        IK9zIUG3mXdzX1jeYQqPR2xMmuTE3XI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-57XIh7TTPUeFzmO37W8Dww-1; Thu, 13 Jan 2022 08:18:44 -0500
X-MC-Unique: 57XIh7TTPUeFzmO37W8Dww-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC1BD1054FB9;
        Thu, 13 Jan 2022 13:18:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBA4684A0B;
        Thu, 13 Jan 2022 13:18:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     smfrench@gmail.com
cc:     dhowells@redhat.com, Shyam Prasad N <nspmangalore@gmail.com>,
        jlayton@kernel.org, linux-cifs@vger.kernel.org
Subject: cifs fallocate doesn't flush writes?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1828479.1642079920.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 13 Jan 2022 13:18:40 +0000
Message-ID: <1828480.1642079920@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

Should cifs fallocate be flushing writes before doing the falloc?

If I do the following:

	mount //carina/test /xfstest.test -o user=3Dshares,pass=3Dfoobar,noperm,v=
ers=3D3.0,mfsymlinks,actimeo=3D0
	/usr/sbin/xfs_io -f -t \
		-c "pwrite -S 0x41 0 4096"
		-c "pwrite -S 0x42 4096 4096"
		-c "fzero 0 4096" \
		-c "pread 0 8192" \
		/xfstest.test/008.7067

The packet trace shows:

   25 0.289099336  192.168.6.2 -> 192.168.6.1  SMB2 414 Create Request Fil=
e: ;GetInfo Request FS_INFO/FileFsFullSizeInformation;Close Request
   26 0.292164924  192.168.6.1 -> 192.168.6.2  SMB2 510 Create Response Fi=
le: ;GetInfo Response;Close Response
   27 0.292444124  192.168.6.2 -> 192.168.6.1  SMB2 174 GetInfo Request FI=
LE_INFO/SMB2_FILE_ALL_INFO File: 008.7067
   28 0.292716736  192.168.6.1 -> 192.168.6.2  SMB2 260 GetInfo Response
   29 0.293018017  192.168.6.2 -> 192.168.6.1  SMB2 414 Create Request Fil=
e: ;GetInfo Request FS_INFO/FileFsFullSizeInformation;Close Request
   30 0.295730538  192.168.6.1 -> 192.168.6.2  SMB2 510 Create Response Fi=
le: ;GetInfo Response;Close Response
   31 0.321638749  192.168.6.2 -> 192.168.6.1  SMB2 206 Ioctl Request FSCT=
L_SET_ZERO_DATA File: 008.7067
   32 0.321862497  192.168.6.1 -> 192.168.6.2  SMB2 182 Ioctl Response FSC=
TL_SET_ZERO_DATA File: 008.7067
   33 0.334313914  192.168.6.2 -> 192.168.6.1  SMB2 183 Read Request Len:4=
096 Off:0 File: 008.7067
   34 0.334772295  192.168.6.1 -> 192.168.6.2  SMB2 143 Read Response, Err=
or: STATUS_END_OF_FILE
   35 0.357622873  192.168.6.2 -> 192.168.6.1  SMB2 183 Read Request Len:4=
096 Off:0 File: 008.7067
   36 0.358040997  192.168.6.1 -> 192.168.6.2  SMB2 143 Read Response, Err=
or: STATUS_END_OF_FILE
   38 0.373614076  192.168.6.2 -> 192.168.6.1  SMB2 1382 Write Request Len=
:4096 Off:4096 File: 008.7067
   40 0.374142468  192.168.6.1 -> 192.168.6.2  SMB2 150 Write Response
   41 0.374485805  192.168.6.2 -> 192.168.6.1  SMB2 158 Close Request File=
: 008.7067
   42 0.375222020  192.168.6.1 -> 192.168.6.2  SMB2 194 Close Response

The first page read (which overlaps with the writes and fzero) returns an =
EOF
error.  Shouldn't the FSCTL_SET_ZERO_DATA have extended the file to 4096?
Also, I wonder what happened to the pagecache: the second read shouldn't h=
ave
happened because fallocate() shouldn't have touched that page.

Also, the writeback happens last - I wonder if fallocate should flush.  No=
t
that it should be necessary if it's just modifying pages already in the
pagecache.

David

