Return-Path: <SRS0=hquX=DI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 361E2C4727E
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Oct 2020 20:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E402720739
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Oct 2020 20:50:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LjVpROiK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgJAUum (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Oct 2020 16:50:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726515AbgJAUum (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Oct 2020 16:50:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601585441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=UIYGy3s1XXOKmSpbD0+kA4gvNWh/00LyBhFEArl0reY=;
        b=LjVpROiKEUQ8RmX2L+r5kcT5abtnMh/YILjdc8JVtmp4m7ifbvVP8cV3+3YFXLea8hDJC3
        kO4JNYbe+LvcnxU0pLPOkLlaXbH9uetXN4bh+/0XQjzbiIUL4rMjxs4S9cFq3XgU+lqQGE
        Fz3EkGBW3KCurqINjf9muBR/4ELImc8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-t0ZAafjqOpWK1APUph6DSg-1; Thu, 01 Oct 2020 16:50:39 -0400
X-MC-Unique: t0ZAafjqOpWK1APUph6DSg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7A81188C122;
        Thu,  1 Oct 2020 20:50:38 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-124.bne.redhat.com [10.64.54.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 454A578807;
        Thu,  1 Oct 2020 20:50:38 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 0/3] cifs: cache directory content for shroot
Date:   Fri,  2 Oct 2020 06:50:23 +1000
Message-Id: <20201001205026.8808-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, List

See initial implementation of a mechanism to cache the directory entries for
a shared cache handle (shroot).
We cache all the entries during the initial readdir() scan, using the context
from the vfs layer as the key to handle if there are multiple concurrent readir() scans
of the same directory.
Then if/when we have successfully cached the entire direcotry we will server any
subsequent readdir() from out of cache, avoinding making any query direcotry calls to the server.

As with all of shroot, the cache is kept until the direcotry lease is broken.


The first two patches are small and just a preparation for the third patch. They go as separate
patches to make review easier.
The third patch adds the actual meat of the dirent caching .


For now this might not be too exciting because the only cache the root handle.
I hope in the future we will expand the directory caching to handle any/many direcotries.

