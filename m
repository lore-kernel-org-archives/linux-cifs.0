Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3868C00140
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Aug 2022 02:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiHICMc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Aug 2022 22:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiHICMa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Aug 2022 22:12:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C8EAF1AD8A
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 19:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660011147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VEn/APsGXW10KYvXMV5Z07gW88PtZc3UvXtmAlpwPls=;
        b=X8Euk1xSIpn84wKOOlg07W6DMKp6ydYGxYyXB0l+Kw9SNRoXI8Ku7QDvUT6ZTxuaPMJbz+
        KN8BfOO+AVVf5mnpbVPTyWG3zjdx/X7Tw5obMe8q3qmn5I3vqY7QJNheGMlAbhJ3F5i6Cb
        f+4hJEUgLtSco6KHG4+sXfgFTZ8lVH4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-xOmZLghCNHWTN2SxvUEuGQ-1; Mon, 08 Aug 2022 22:12:24 -0400
X-MC-Unique: xOmZLghCNHWTN2SxvUEuGQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E2C68037A9;
        Tue,  9 Aug 2022 02:12:24 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-16.bne.redhat.com [10.64.52.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D1E44047D22;
        Tue,  9 Aug 2022 02:12:23 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: WIP: Expand directory handle cache to also cache non-root directories
Date:   Tue,  9 Aug 2022 12:11:47 +1000
Message-Id: <20220809021156.3086869-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, List

Do not apply to the tree, but please review and comment.

Please see a Work-In-Progress patch series for expanding the handle cache
to start caching any directories, not just root.
Currently the limit is arbitrarily set to 16.
The first 8 patches are trivial and mostly just moving some functions
around without affecting behavior. They prepare the cifs module to 
mostly only access the details of struct cached_fid from the file
cached_fid.c

The 9th patch is where the actual meat is and where we now dynamically
create cached directory structures and keep them on a list hanging off
struct cached_fids.

This now means that we can safely, while holding a lease, do "ls /mnt/...
 >/dev/null" and only the first directory listing will result in network i/o.

What is still misisng and what we need to implement before we will get any
major boosts in performance is to also track the "dentry" for the cached dir.
I currently only cached hte dentry for the root, because it is easy to
get this from the superblock. But we will need to walk the dentries and ALSO
get() and use the dentry for all other directories that we cache.
This will be very important to do for performance as this will allow
us to serve attributes for the entries of the cached directory out of cache.
See inode.c:cifs_dentry_needs_reval()

I do not yet do that because "cifs: start caching all ..." is already big enough
as a patch as is, but I will implement walking the dentries and improve this
caching next.



