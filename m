Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A16DC433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Jan 2022 21:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244223AbiAFVcF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Jan 2022 16:32:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51480 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239110AbiAFVcF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Jan 2022 16:32:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641504724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=OVSngt0Bi4mpL3l3todec873GmIFbib/HFumeLRJuOY=;
        b=dXtwlRutGni8NgbQoxPOw/Pcm57B2jb7s2JfINBh0iNzpIB9eAmix7o3p+nRcjtIkzV0rG
        oP/fpWFiyqFv3FPFoxOSY923q3E6AKpWASrvJI4O3VcFkP/DWlDOx0qe83MKQROH1knhKi
        3dvM3sARrgoDJBZUAm2SQUgFzcMAxvA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-s4oARPBKNqiyrc8Ta8V65w-1; Thu, 06 Jan 2022 16:32:03 -0500
X-MC-Unique: s4oARPBKNqiyrc8Ta8V65w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 181B5107B280;
        Thu,  6 Jan 2022 21:32:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6083E16A39;
        Thu,  6 Jan 2022 21:31:55 +0000 (UTC)
Subject: [RFC][PATCH v2 0/3] cifs: In-progress conversion to use iov_iters
 instead of page lists
From:   David Howells <dhowells@redhat.com>
To:     smfrench@gmail.com
Cc:     nspmangalore@gmail.com, dhowells@redhat.com, jlayton@kernel.org,
        linux-cifs@vger.kernel.org, linux-cachefs@redhat.com
Date:   Thu, 06 Jan 2022 21:31:54 +0000
Message-ID: <164150471440.2994594.16990036181824162931.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Hi Steve,

For your illumination, here's where I'm currently at with making cifs use
netfslib more fully.  I ended up delving into the realms of converting it
to use iov_iter instead of page lists and doing partial foliation.

It isn't complete yet and some of the patches don't compile, but if you
want a look at what I've been doing...

David
---
David Howells (3):
      cifs: Use netfslib
      cifs: Reverse the way iov_iters are used in reading
      cifs: Eliminate pages list from cifs_readdata, cifs_writedata and smb_rqst


 fs/cifs/cifsencrypt.c |   40 +-
 fs/cifs/cifsfs.h      |    3 +
 fs/cifs/cifsglob.h    |   28 +-
 fs/cifs/cifsproto.h   |    8 +-
 fs/cifs/cifssmb.c     |  219 ++++++---
 fs/cifs/file.c        | 1041 +++++++++++++----------------------------
 fs/cifs/misc.c        |  109 -----
 fs/cifs/smb2ops.c     |  188 ++++----
 fs/cifs/smb2pdu.c     |   12 +-
 fs/cifs/transport.c   |   41 +-
 include/linux/uio.h   |    7 +
 lib/iov_iter.c        |  136 ++++++
 12 files changed, 746 insertions(+), 1086 deletions(-)


