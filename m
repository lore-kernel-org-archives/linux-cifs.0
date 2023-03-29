Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9266C74A5B
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Mar 2023 20:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjC2UOn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Mar 2023 16:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjC2UOm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Mar 2023 16:14:42 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A5430C7
        for <linux-cifs@vger.kernel.org>; Wed, 29 Mar 2023 13:14:41 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1680120880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BEJhsKVZeUmeNNn/UZQ/VeSRgg2sJxpZrzuIpDMTNaY=;
        b=kIBkhh5ik7Rz+uQzni7QndNp3btnF76OhdxfuJL6NO/gRP+gy4vA40/UqkJ7C8r5LyFuXj
        ajAat9YyjWcuGvHLzOvfqe1O2BGqyNft6qz4Hm+dMquwEa7nn06IlQ31xAz7TligUOS8iv
        ZG9Rxu6vQYrexMKLFOdSRjjh4qCIsV3BXkkwQqjvvEFYGRYNLx6MH5Cvv/E8ay+preN2Bh
        7ztOGgPccIy+hlmFnQsmvi2vx4I0ubppteGMipS8TtuLj9+YqTBIjQYArKmSB53I33MAsE
        D/oeKgxZ/Txi1CoUVz4QZXYvmVLe2C6W05jqv/C0PVmLD7N+fGED3czdKwfAMw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1680120880; a=rsa-sha256;
        cv=none;
        b=NQJvJwTTdxVcpAe0ynbcXiV+PS7D32l/TXL5dNSeJPLTjoG4x335tlD+1EN4AXi5K/o5iz
        bvYdkULpIFKyDV7XDapHZwPyTmr2mrkZrzZYNnuMnzxpI5piIC2ekqUjfJyN9P9gWCr2dp
        PenB61rvfD60qYIAouXkOl/G9XP7gmkniX8XH0Q/CP49Cc1v8R/TNMHG+/UbztVcxUM3L6
        VUwqzz/QSdn1xuvLVrq0gr+3wEwAq726Sjs/OcVrCYM7jt2HXFgkoxeRiQc5V0x9387GTy
        maH7P5AIDqjNcAlYy2HURrTenVH+QDq9u0OS4BQgmhiKVSCtCDmNJmoVjaziaQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1680120880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BEJhsKVZeUmeNNn/UZQ/VeSRgg2sJxpZrzuIpDMTNaY=;
        b=BCpAFBD6MJ/UGKLmzTplxex5mX0vR/BY/PlsA/+LBEv7RIKOd6B1p313wgAoFXEgkOK7Eg
        XNkeZOinJUphdGnyTL0/lBeJZX0YZtoyPhhBbOxwKup5AacXEC3yS9v6UGXd1Ih6Rn08Ki
        OA5tn54MBxOBJ3fiklNRX29n8BQ1qYAvz4S661Z39TAqjd34sE/s3B5eeX/fm6WyzN0aZQ
        V3enVK12cfZpjq0Jbah4eTKitzG3/JUcZnf/r8vcviyqMsIa4IY+shWQ5bZ47kO2EKSk/n
        Imn6WRYkjcrFA8IZ/bAN2+8tmqaPUTrtrQzWiX54NyDhVKhJQ3C1we3XkKqD5g==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 2/5] cifs: get rid of unnecessary ifdef
Date:   Wed, 29 Mar 2023 17:14:20 -0300
Message-Id: <20230329201423.32134-2-pc@manguebit.com>
In-Reply-To: <20230329201423.32134-1-pc@manguebit.com>
References: <20230329201423.32134-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

No need to ifdef around TCP_Server_Info::{origin,leaf}_fullpath as
they're declared regardless CONFIG_CIFS_DFS_UPCALL.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/cifs/connect.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ef50f603e640..7c3e090a0f13 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -993,10 +993,8 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		 */
 	}
 
-#ifdef CONFIG_CIFS_DFS_UPCALL
 	kfree(server->origin_fullpath);
 	kfree(server->leaf_fullpath);
-#endif
 	kfree(server);
 
 	length = atomic_dec_return(&tcpSesAllocCount);
-- 
2.40.0

