Return-Path: <SRS0=BNow=DM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B83C4727D
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Oct 2020 02:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D06A2072D
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Oct 2020 02:38:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VDJts2pE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgJECiJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 4 Oct 2020 22:38:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31926 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725845AbgJECiI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 4 Oct 2020 22:38:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601865487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=PLT9xkJZqdA+iq1rxeQzQK/E3lHiHYAB/brP5YuU1qA=;
        b=VDJts2pEHAd93cJY50O9L29iCM3PxhmdR0t4GjoGjouA0hRctt0aQPJIUIqY/IlSOSU7NS
        okMH8zIOnQSLOjHS6iTz2AVs2nvCWjZiTdb7CBGit3nKslM8IpaQ7ovpw/V3qKAYxiYKz7
        2FAMWUoDp4MSyKai2zbg5ETeuX2NQRw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-eNEe0yrvNMK66sAtvrPkqA-1; Sun, 04 Oct 2020 22:38:06 -0400
X-MC-Unique: eNEe0yrvNMK66sAtvrPkqA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36F951074662;
        Mon,  5 Oct 2020 02:38:05 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-124.bne.redhat.com [10.64.54.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BCE15D9CD;
        Mon,  5 Oct 2020 02:38:04 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 0/3 V1] cifs: cache the directory content for shroot
Date:   Mon,  5 Oct 2020 12:37:51 +1000
Message-Id: <20201005023754.13604-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, Aurelien, List

Please find updated version.
With these patches we now server readdir() out of cache for shroot
which eliminates at least three roundtrips:
* the initial Create+QueryDirectory
* the Query_Directory that fails with no more files
* the Close

Since we only cache name, inode and type we will still have the 
Create/GetInfo/Close calls for every direcotry member.
To solve that and eliminate those calls I chatted with Steve
and we could cache all information about those child objects for ~1 second.

That would not plug into cifs_readdir() but in parts different parts of
the cifs.ko code so it should into its own patch for
"fetch stat() data for objects from the directory cache, if available".
That would be a different patch series.


V3:
* always take out shroot on the master tcon
* fix bug where we would still do one FindFirst even if we had everything cached

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

