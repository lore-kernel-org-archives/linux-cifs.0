Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB259C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Mar 2022 08:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbiCKIUx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 11 Mar 2022 03:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235238AbiCKIUw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 11 Mar 2022 03:20:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 032B61B8C87
        for <linux-cifs@vger.kernel.org>; Fri, 11 Mar 2022 00:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646986789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=tOJrp+MfHelytyXFzxl0wqyMI8isgpyzT8UbICZ1xoU=;
        b=Wy4aR9fnljtj9rXlprqkquwVDsfkTqwdPnr3fDmJe54Lo6K+6i09dDw/KPbQTa+1CioKF3
        t0clDqt2vNfPAdf5CHJBC4F56Jgf8Bm2j9bxw56BrcccxpP3i3XGHxQ75t6MLKWspUMOGG
        BOyLV+9ed5LZhcnAeNzIqMW7UpKDDpY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-EOLR9to0PWGeXVQT3nb1bg-1; Fri, 11 Mar 2022 03:19:43 -0500
X-MC-Unique: EOLR9to0PWGeXVQT3nb1bg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69A6551DF;
        Fri, 11 Mar 2022 08:19:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 978F05E279;
        Fri, 11 Mar 2022 08:19:34 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     Rohith Surabattula <rohiths.msft@gmail.com>
cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, jlayton@kernel.org,
        linux-cifs@vger.kernel.org
Subject: cifs conversion to netfslib
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 11 Mar 2022 08:19:33 +0000
Message-ID: <2314914.1646986773@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Hi Rohith,

Take a look at the patches at the top of my cifs-experimental branch.  I put
in a ->clamp_length() method and used that to chop up read requests into
subrequests according to credits and rsize rather than trying to limit the
size of a read in ->issue_read().  It behaves a lot better now.  I see the =
VM
creating 8M requests that then get broken up into pairs of 4M read RPCs that
then take place in parallel.

I've taken the idea of allowing the netfs to propose larger allocations for
the request and subrequest structs and, in effect, merged the cifs_readdata
struct with the netfs_io_subrequest struct reducing the amount of overhead a
bit.  I moved the cifsFileInfo field out from the subrequest to a wrapper f=
or
the request struct, so that it's carried for all the subreqs in common.

Possibly some other readdata fields could be eliminated too as being
superfluous to the fields in the netfs_io_subrequest struct.  offset,
got_bytes, bytes and result for example.

There are a couple of problems with splice write, though, at least one of
which is probably due to the iteratorisation.  Firstly, xfstests now gets as
far as generic/013 and then gets to a point where one of the threads is just
sitting there sending the same splice write over and over again and getting=
 a
zero result back.  Running splice by hand, however, shows no problem and
because it's in fsstress, I think, it's really hard to work out how it gets=
 to
this point:-/.

The other issue is that if I run splice to an empty file, it works; running
another splice to the same file will result in the server giving
STATUS_ACCESS_DENIED when cifs_write_begin() tries to read from the file:

    7 0.009485249  192.168.6.2 =E2=86=92 192.168.6.1  SMB2 183 Read Request=
 Len:65536 Off:0 File: x
    8 0.009674245  192.168.6.1 =E2=86=92 192.168.6.2  SMB2 143 Read Respons=
e, Error: STATUS_ACCESS_DENIED

Actually - that might be because the file is only 65536 bytes long because =
the
first splice finished short.

David

