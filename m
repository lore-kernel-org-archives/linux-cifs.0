Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 881BFC64EC7
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Feb 2023 22:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjB1Wjx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Feb 2023 17:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjB1Wjm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Feb 2023 17:39:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2AF18A91
        for <linux-cifs@vger.kernel.org>; Tue, 28 Feb 2023 14:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677623930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z7FA4u5OEaOHBPNiC2hIVPgejHilk/uios9I41rqplk=;
        b=CzRmoelDBaqV1enla5vINEDFqltBxaRHNmeMGB6DNgczrFunfJKjqNZpxziWVSnA6A/fp7
        fNDKbbJiNZ1Gr8TcIvSA/ITouirIY7ZrdogS4i3hAUP2sPpDxIIoSSy+ztNudDrybmOK3O
        nX2EHu5UvJop/xJKNFD6t4waDS5Knt0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-mMt7URXXMLm1FQOaVjr3hA-1; Tue, 28 Feb 2023 17:38:45 -0500
X-MC-Unique: mMt7URXXMLm1FQOaVjr3hA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8419E3810B07;
        Tue, 28 Feb 2023 22:38:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7A4D40C6EC4;
        Tue, 28 Feb 2023 22:38:42 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Tom Talpey <tom@talpey.com>,
        Stefan Metzmacher <metze@samba.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Murphy Zhou <jencce.kernel@gmail.com>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 1/1] cifs: Fix memory leak in direct I/O
Date:   Tue, 28 Feb 2023 22:38:38 +0000
Message-Id: <20230228223838.3794807-2-dhowells@redhat.com>
In-Reply-To: <20230228223838.3794807-1-dhowells@redhat.com>
References: <20230228223838.3794807-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When __cifs_readv() and __cifs_writev() extract pages from a user-backed
iterator into a BVEC-type iterator, they set ->bv_need_unpin to note
whether they need to unpin the pages later.  However, in both cases they
examine the BVEC-type iterator and not the source iterator - and so
bv_need_unpin doesn't get set and the pages are leaked.

I think this may be responsible for the generic/208 xfstest failing
occasionally with:

	WARNING: CPU: 0 PID: 3064 at mm/gup.c:218 try_grab_page+0x65/0x100
	RIP: 0010:try_grab_page+0x65/0x100
	follow_page_pte+0x1a7/0x570
	__get_user_pages+0x1a2/0x650
	__gup_longterm_locked+0xdc/0xb50
	internal_get_user_pages_fast+0x17f/0x310
	pin_user_pages_fast+0x46/0x60
	iov_iter_extract_pages+0xc9/0x510
	? __kmalloc_large_node+0xb1/0x120
	? __kmalloc_node+0xbe/0x130
	netfs_extract_user_iter+0xbf/0x200 [netfs]
	__cifs_writev+0x150/0x330 [cifs]
	vfs_write+0x2a8/0x3c0
	ksys_pwrite64+0x65/0xa0

with the page refcount going negative.  This is less unlikely than it seems
because the page is being pinned, not simply got, and so the refcount
increased by 1024 each time, and so only needs to be called around ~2097152
for the refcount to go negative.

Further, the test program (aio-dio-invalidate-failure) uses a 32MiB static
buffer and all the PTEs covering it refer to the same page because it's
never written to.

The warning in try_grab_page():

	if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
		return -ENOMEM;

then trips and prevents us ever using the page again for DIO at least.

Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
Link: https://lore.kernel.org/r/CAH2r5mvaTsJ---n=265a4zqRA7pP+o4MJ36WCQUS6oPrOij8cw@mail.gmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Paulo Alcantara <pc@cjr.nz>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
---
 fs/cifs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ec0694a65c7b..4d4a2d82636d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3612,7 +3612,7 @@ static ssize_t __cifs_writev(
 
 		ctx->nr_pinned_pages = rc;
 		ctx->bv = (void *)ctx->iter.bvec;
-		ctx->bv_need_unpin = iov_iter_extract_will_pin(&ctx->iter);
+		ctx->bv_need_unpin = iov_iter_extract_will_pin(from);
 	} else if ((iov_iter_is_bvec(from) || iov_iter_is_kvec(from)) &&
 		   !is_sync_kiocb(iocb)) {
 		/*
@@ -4148,7 +4148,7 @@ static ssize_t __cifs_readv(
 
 		ctx->nr_pinned_pages = rc;
 		ctx->bv = (void *)ctx->iter.bvec;
-		ctx->bv_need_unpin = iov_iter_extract_will_pin(&ctx->iter);
+		ctx->bv_need_unpin = iov_iter_extract_will_pin(to);
 		ctx->should_dirty = true;
 	} else if ((iov_iter_is_bvec(to) || iov_iter_is_kvec(to)) &&
 		   !is_sync_kiocb(iocb)) {

