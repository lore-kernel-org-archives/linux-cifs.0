Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E671AC433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Jan 2022 17:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241764AbiAFR63 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Jan 2022 12:58:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48881 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241753AbiAFR63 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Jan 2022 12:58:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641491908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PT9ey7hZx8cRSUsGa96WlhWve6b1NE4HPbJbyeLjnMk=;
        b=izmvUUBFgEZ5lN2DOMQsm91O1hvdceWuXqsM8/ENKCpXTSGYfvEBRXE7Q8yYMOTrHPROCf
        75F5kTIf9t1Jg1mrS3N9uIiVuDEqJuXX+93sevQxJXnEzaOZSV+74Fdn8TqWiHznRq5QkF
        5xayyj0HOwIUd+lZGXuSDJ7YuJ2vwVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-ctdbpef8NvS4DpJI91OUXA-1; Thu, 06 Jan 2022 12:58:25 -0500
X-MC-Unique: ctdbpef8NvS4DpJI91OUXA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F63781EE64;
        Thu,  6 Jan 2022 17:58:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C5381091EF6;
        Thu,  6 Jan 2022 17:58:20 +0000 (UTC)
Subject: 
From:   David Howells <dhowells@redhat.com>
To:     smfrench@gmail.com
Cc:     nspmangalore@gmail.com, dhowells@redhat.com, jlayton@kernel.org,
        linux-cifs@vger.kernel.org, linux-cachefs@redhat.com
Date:   Thu, 06 Jan 2022 17:58:19 +0000
Message-ID: <164149189935.2867367.12096515579793121868.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

[RFC][PATCH 0/3] cifs: In-progress conversion to use iov_iters instead of page lists
Date: 


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
      cifs: Eliminate cifs_readdata::pages


 fs/cifs/cifsfs.h    |    3 +
 fs/cifs/cifsglob.h  |   28 +-
 fs/cifs/cifsproto.h |    8 +-
 fs/cifs/cifssmb.c   |  219 +++++----
 fs/cifs/file.c      | 1041 ++++++++++++++-----------------------------
 fs/cifs/misc.c      |  109 -----
 fs/cifs/smb2ops.c   |  132 +++---
 fs/cifs/smb2pdu.c   |   12 +-
 fs/cifs/transport.c |   41 +-
 include/linux/uio.h |    3 +
 lib/iov_iter.c      |   94 ++++
 11 files changed, 647 insertions(+), 1043 deletions(-)


