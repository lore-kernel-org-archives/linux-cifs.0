Return-Path: <SRS0=6i8E=DL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA4CC4363C
	for <linux-cifs@archiver.kernel.org>; Sun,  4 Oct 2020 23:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEC72206C3
	for <linux-cifs@archiver.kernel.org>; Sun,  4 Oct 2020 23:37:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b/LUi2qw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgJDXhX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 4 Oct 2020 19:37:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36480 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbgJDXhX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 4 Oct 2020 19:37:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601854642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=P33qi5zLnFtaJfO0OaWHvI9gh/8RrBm/q21OXuEymZ4=;
        b=b/LUi2qwharUhgod79UM8tMCHMADxVKPD6d24z4ekoNIPLkz4YiFqQ5ObWP6PS7gM/TDjm
        Gp04J9/SofXKSFZc+N3rhpyGkzR4Ew/ekEIwHj79MQnfLfdaXFloH1W9JJN59QSbyZhqE1
        zk0n0MVlVedUN6cZYmvp7NtAAZPOzZk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-LZpKA6xCMseDkas6soiyvA-1; Sun, 04 Oct 2020 19:37:20 -0400
X-MC-Unique: LZpKA6xCMseDkas6soiyvA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FAF5801AC4;
        Sun,  4 Oct 2020 23:37:19 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-124.bne.redhat.com [10.64.54.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA3685C1BD;
        Sun,  4 Oct 2020 23:37:18 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 0/3 V2]: cifs: cache directory content for shroot
Date:   Mon,  5 Oct 2020 09:37:02 +1000
Message-Id: <20201004233705.31436-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, Aurelien, List

V2: addressing Aureliens comments
* Fix comment style
* Describe what ctx->pos == 2 means
* use is_smb1_server()


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

