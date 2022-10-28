Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD41FA373D
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 02:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236276AbiJ1CeS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 27 Oct 2022 22:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235425AbiJ1CeO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 27 Oct 2022 22:34:14 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C77BBD67F;
        Thu, 27 Oct 2022 19:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=kzyTYTJeAc6AOpvZ22JHhqezuz/9wtVh9FvveO4qOg4=; b=eV98wKmFuLFkFM+/KnyDfHCsvr
        H37W32LXblfeTUoUWvBngu65g1Nhz1fh3roppUyJoYyplosWxfTnrj5iw4KNCXOUYJeuHU/oK/yhr
        kVvmwTQcGkGgSX8kXJc6a3bohvC0BkfAJY6ZtPsfDAtkmk/S0ObyD/YOPTzsuky2y6OT6t69Ht6zL
        7UfCSE27fIYJ6n+4P7j0Chi31JZ5iifh60IaMaaIXx7jwl/OezkDERHri91ePEV1J7yELKuYhYdhR
        W8Z8OnkWmngZ8iyP0+8eOU5o+VgW7Tl6o/bc/TSjtl9377O829h+Vi98fKSZjD+p8DbZHbLeGuyQO
        65p7QurA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1ooFBx-00EorL-16;
        Fri, 28 Oct 2022 02:33:53 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     David Howells <dhowells@redhat.com>, willy@infradead.org,
        dchinner@redhat.com, Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ira Weiny <ira.weiny@intel.com>, torvalds@linux-foundation.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/12] [s390] memcpy_real(): WRITE is "data source", not destination...
Date:   Fri, 28 Oct 2022 03:33:47 +0100
Message-Id: <20221028023352.3532080-7-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221028023352.3532080-1-viro@zeniv.linux.org.uk>
References: <Y1btOP0tyPtcYajo@ZenIV>
 <20221028023352.3532080-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/s390/mm/maccess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index 1571cdcb0c50..753b006c8ea5 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -128,7 +128,7 @@ int memcpy_real(void *dest, unsigned long src, size_t count)
 
 	kvec.iov_base = dest;
 	kvec.iov_len = count;
-	iov_iter_kvec(&iter, WRITE, &kvec, 1, count);
+	iov_iter_kvec(&iter, READ, &kvec, 1, count);
 	if (memcpy_real_iter(&iter, src, count) < count)
 		return -EFAULT;
 	return 0;
-- 
2.30.2

