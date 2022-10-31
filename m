Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5AFECAAA1
	for <linux-cifs@archiver.kernel.org>; Mon, 31 Oct 2022 14:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbiJaOui (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 31 Oct 2022 10:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbiJaOui (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 31 Oct 2022 10:50:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D846F037
        for <linux-cifs@vger.kernel.org>; Mon, 31 Oct 2022 07:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667227778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=23/Ctdek4ocKr3zevsCvoojIOyWc1W2ha5J7gbSO9ns=;
        b=SV7PYHZI4Jfoaq+CRjrVSFso2o0ohCR6IzLsuCT+HHFzZEarF+j6xU9VWBG8tCJG527Yll
        /RT46EAGdBd8tkZJu04h3VzkQ5G03Liza2i7ZXXnM9BSTIWhiXuJgIlUg1pX0p8HS8xUQa
        LuVaVaUPuMqGgGM05eGyVqgPdFF62ic=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-Dv51oDBhOISZEQG849O3jw-1; Mon, 31 Oct 2022 10:49:35 -0400
X-MC-Unique: Dv51oDBhOISZEQG849O3jw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87BA1811E7A;
        Mon, 31 Oct 2022 14:49:34 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D4D0140EBF5;
        Mon, 31 Oct 2022 14:49:33 +0000 (UTC)
Subject: [RFC PATCH 0/2] iov_iter: Provide a function to extract/pin/get pages
 from an iteraor
From:   David Howells <dhowells@redhat.com>
To:     viro@zeniv.linux.org.uk
Cc:     linux-mm@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>, dhowells@redhat.com,
        smfrench@gmail.com, torvalds@linux-foundation.org,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 31 Oct 2022 14:49:32 +0000
Message-ID: <166722777223.2555743.162508599131141451.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Hi Al,

Here's a patch to provide a function to extract a list of pages from an
iterator, getting pins of refs on them as appropriate.

I added a macro by which you can query an iterator to find out how the
extraction function will treat the pages (it returns 0, FOLL_GET or FOLL_PIN
as appropriate).  Note that it's a macro to avoid #inclusion of linux/mm.h in
linux/uio.h.

I've added another crude, incomplete patch to make cifs use it a bit as an
example.  Note that cifs won't work properly with this under all
circumstances, particularly if it decides to split the rdata or wdata record -
but it seems to work for small I/Os.

David
---
David Howells (2):
      iov_iter: Add a function to extract a page list from an iterator
      cifs: Test use of iov_iter_extract_pages() and iov_iter_extract_mode()


 fs/cifs/cifsglob.h  |   2 +
 fs/cifs/file.c      |  93 +++++++++----
 include/linux/uio.h |  26 ++++
 lib/iov_iter.c      | 333 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 427 insertions(+), 27 deletions(-)


