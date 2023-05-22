Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F0E9C7EE23
	for <linux-cifs@archiver.kernel.org>; Mon, 22 May 2023 14:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbjEVOl0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 May 2023 10:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbjEVOlZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 May 2023 10:41:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0A39E
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 07:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684766438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AFW+IZL67Cz0xRBwmMsauHMgB+wZd79K6KlpZee9jmw=;
        b=ZCPgzD33rW6/tdJmb2DzlTNCnt23sQWtPZcw4Jj/cVPcWcJ6SLoQYGCNsOO8ocIpWVwhu/
        02BxsSAXpA2RK8S1AdgKP6p/5owUVhbUsaI8/zvRlWI5dvLxbjnkBgnA+EDSF8u35q9Xmg
        TiCQdRTJKZv+o2yXL4hiO5sdVXSWH0g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-Ig3pnr3WNRKXjMESuYRgaA-1; Mon, 22 May 2023 10:40:33 -0400
X-MC-Unique: Ig3pnr3WNRKXjMESuYRgaA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B189D38025F5;
        Mon, 22 May 2023 14:40:32 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4895C40CFD45;
        Mon, 22 May 2023 14:40:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     Shyam Prasad N <sprasad@microsoft.com>
cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Paulo Alcantara <pc@manguebit.com>,
        Tom Talpey <tom@talpey.com>, Jeff Layton <jlayton@kernel.org>,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Fix cifs_limit_bvec_subset() to correctly check the maxmimum size
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2811950.1684766430.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 22 May 2023 15:40:30 +0100
Message-ID: <2811951.1684766430@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix cifs_limit_bvec_subset() so that it limits the span to the maximum
specified and won't return with a size greater than max_size.

Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather=
 than a page list")
Reported-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <smfrench@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Paulo Alcantara <pc@manguebit.com>
cc: Tom Talpey <tom@talpey.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/cifs/file.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ba7f2e09d6c8..4778614cfccf 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3353,6 +3353,7 @@ static size_t cifs_limit_bvec_subset(const struct io=
v_iter *iter, size_t max_siz
 	while (n && ix < nbv) {
 		len =3D min3(n, bvecs[ix].bv_len - skip, max_size);
 		span +=3D len;
+		max_size -=3D len;
 		nsegs++;
 		ix++;
 		if (span >=3D max_size || nsegs >=3D max_segs)

