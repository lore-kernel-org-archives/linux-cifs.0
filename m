Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F2C4C32789
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 16:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244975AbiHWQiw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 12:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245097AbiHWQiA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 12:38:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC5A44571
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 06:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661260048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5XBOIH3pNVedUwFsOXAIjq4Jvv7g7DjLTpjlFUvS39Y=;
        b=gFa9x3HCQnpF6hKjg78Ms8IkMpxnUWqkJhENO5IPnLPqhQMld5nq/yf8D4pEuQtgI3TNrg
        rp5HJj/OkSbO5cxj1wX6JrCZehKcjQ1oEcur2QRK1DkYjt1uVE5G2VYk9fY6C8rJXCoy9l
        mQconhCyu3/EuPPIyH+LplVdCmQJ/O8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-tNCRk7prMsyJhm6rhXGLfg-1; Tue, 23 Aug 2022 09:07:23 -0400
X-MC-Unique: tNCRk7prMsyJhm6rhXGLfg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3EAE80A0BC;
        Tue, 23 Aug 2022 13:07:22 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84A1DC15BB3;
        Tue, 23 Aug 2022 13:07:21 +0000 (UTC)
Subject: [PATCH 0/5] smb3: Fix missing locks and invalidation in fallocate
From:   David Howells <dhowells@redhat.com>
To:     sfrench@samba.org, linux-cifs@vger.kernel.org
Cc:     lsahlber@redhat.com, jlayton@kernel.org, dchinner@redhat.com,
        willy@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org
Date:   Tue, 23 Aug 2022 14:07:20 +0100
Message-ID: <166126004083.548536.11195647088995116235.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Here are some patches to fix locking and invalidation in the smb3/cifs
fallocate, in particular in zero_range, punch_hole, collapse_range and
insert_range.

Those four operations were, for the most part, missing calls to inode_lock(),
filemap_invalidate_lock() and truncate_pagecache_range(), the last of which
was causing generic/031 to show data corruption.

David
---
David Howells (4):
      smb3: Move the flush out of smb2_copychunk_range() into its callers
      smb3: missing inode locks in zero range
      smb3: missing inode locks in punch hole
      smb3: fix temporary data corruption in insert range

Steve French (1):
      smb3: fix temporary data corruption in collapse range


 fs/cifs/cifsfs.c  |   2 +
 fs/cifs/smb2ops.c | 131 ++++++++++++++++++++++++++--------------------
 2 files changed, 75 insertions(+), 58 deletions(-)


