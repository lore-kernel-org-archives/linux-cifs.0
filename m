Return-Path: <SRS0=Z3Qp=AY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA56C433FB
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Jul 2020 16:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1A02206F5
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Jul 2020 16:37:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ib3epCml"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbgGMQhA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Jul 2020 12:37:00 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35971 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730618AbgGMQg7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 13 Jul 2020 12:36:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594658218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uZSAC2c/5STKCGTu7EeIJThZsT3GakeWwbaSwr2NVJA=;
        b=ib3epCml4NzNeTkRYxEhwebrhwCpuYeOXWD9S6VCU9sJV0M7jX2FHwZeOvS3n+hU5cO0rU
        JmBJswwQ1Ohs6UXXzX8rKD3/D9xDB71JIpYDzb5vnscK6hcGfKORMNPN4NoRzCZSDMpDBq
        qERLepmbKBgGfityBcGLdKMehCH+8Zg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-cCgsEntoP_uuTEMIWfAmgw-1; Mon, 13 Jul 2020 12:36:54 -0400
X-MC-Unique: cCgsEntoP_uuTEMIWfAmgw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E82D107ACCA;
        Mon, 13 Jul 2020 16:36:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-113.rdu2.redhat.com [10.10.112.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02DF960CD0;
        Mon, 13 Jul 2020 16:36:49 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 32/32] cachefiles: Shape write requests
From:   David Howells <dhowells@redhat.com>
To:     Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Dave Wysochanski <dwysocha@redhat.com>, dhowells@redhat.com,
        linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        ceph-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 13 Jul 2020 17:36:49 +0100
Message-ID: <159465820921.1376674.16898427212445252830.stgit@warthog.procyon.org.uk>
In-Reply-To: <159465784033.1376674.18106463693989811037.stgit@warthog.procyon.org.uk>
References: <159465784033.1376674.18106463693989811037.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In cachefiles_shape_extent(), shape a write request to always write to the
cache.  The assumption is made that the caller has read the entire cache
granule beforehand if necessary.

Possibly this should be amended so that writes will only take place to
granules that are marked present and granules that lie beyond the EOF.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/content-map.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/cachefiles/content-map.c b/fs/cachefiles/content-map.c
index 3e310fd58497..592fc426500b 100644
--- a/fs/cachefiles/content-map.c
+++ b/fs/cachefiles/content-map.c
@@ -69,7 +69,8 @@ static void cachefiles_shape_single(struct fscache_object *obj,
 
 	shape->dio_block_size = CACHEFILES_DIO_BLOCK_SIZE;
 
-	if (object->content_info == CACHEFILES_CONTENT_SINGLE) {
+	if (!shape->for_write &&
+	    object->content_info == CACHEFILES_CONTENT_SINGLE) {
 		shape->to_be_done = FSCACHE_READ_FROM_CACHE;
 	} else {
 		eof = (shape->i_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -127,14 +128,20 @@ void cachefiles_shape_request(struct fscache_object *obj,
 	if (end - start > max_pages)
 		end = start + max_pages;
 
-	/* If the content map didn't get expanded for some reason - simply
-	 * ignore this granule.
-	 */
 	granule = start / CACHEFILES_GRAN_PAGES;
-	if (granule / 8 >= object->content_map_size)
-		return;
+	if (granule / 8 >= object->content_map_size) {
+		cachefiles_expand_content_map(object, shape->i_size);
+		if (granule / 8 >= object->content_map_size)
+			return;
+	}
 
-	if (cachefiles_granule_is_present(object, granule)) {
+	if (shape->for_write) {
+		/* Assume that the preparation to write involved preloading any
+		 * bits of the cache that weren't to be written and filling any
+		 * gaps that didn't end up being written.
+		 */
+		shape->to_be_done = FSCACHE_WRITE_TO_CACHE;
+	} else if (cachefiles_granule_is_present(object, granule)) {
 		/* The start of the requested extent is present in the cache -
 		 * restrict the returned extent to the maximum length of what's
 		 * available.


