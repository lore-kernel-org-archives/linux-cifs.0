Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACD3C77B7C
	for <linux-cifs@archiver.kernel.org>; Sun, 28 May 2023 19:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjE1T3I (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 28 May 2023 15:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbjE1T3E (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 28 May 2023 15:29:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F691A3;
        Sun, 28 May 2023 12:29:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1BF161D08;
        Sun, 28 May 2023 19:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDF7C433EF;
        Sun, 28 May 2023 19:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1685302139;
        bh=XMCKPmmB6wR8ZK8G4zPaMYL3vfjAWABXK/vt+P7ewBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2OnuL5HwUpTdulaenZxVghXNIZ2/GLNRrTMpQSOr6oOqaRakdDSYMO5rGFV11983P
         eMePQgUcPNOQUuGycAb655/a4t6Qqw2giFY1jgLi4BALnq6F0I/ML1J0cPoXLtPzqF
         i0fFuqvOlx4w4n6NhCSopWg4P5U/Ymr6h7heVC3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shyam Prasad N <sprasad@microsoft.com>,
        David Howells <dhowells@redhat.com>,
        Steve French <smfrench@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Paulo Alcantara <pc@manguebit.com>,
        Tom Talpey <tom@talpey.com>, Jeff Layton <jlayton@kernel.org>,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.3 015/127] cifs: Fix cifs_limit_bvec_subset() to correctly check the maxmimum size
Date:   Sun, 28 May 2023 20:09:51 +0100
Message-Id: <20230528190836.719803586@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 4ef4aee67eed640064fff95a693c0184cedb7bec upstream.

Fix cifs_limit_bvec_subset() so that it limits the span to the maximum
specified and won't return with a size greater than max_size.

Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
Cc: stable@vger.kernel.org # 6.3
Reported-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <smfrench@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Paulo Alcantara <pc@manguebit.com>
cc: Tom Talpey <tom@talpey.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ba7f2e09d6c8..df88b8c04d03 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3353,9 +3353,10 @@ static size_t cifs_limit_bvec_subset(const struct iov_iter *iter, size_t max_siz
 	while (n && ix < nbv) {
 		len = min3(n, bvecs[ix].bv_len - skip, max_size);
 		span += len;
+		max_size -= len;
 		nsegs++;
 		ix++;
-		if (span >= max_size || nsegs >= max_segs)
+		if (max_size == 0 || nsegs >= max_segs)
 			break;
 		skip = 0;
 		n -= len;
-- 
2.40.1



