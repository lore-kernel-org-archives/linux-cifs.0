Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45AC6C3065C
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 15:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352655AbjHQPfn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353245AbjHQPff (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 11:35:35 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4685E30C6
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 08:35:34 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b4G8IX/C+szWZEC+eyjEy6RY7fSFjat6ysiasaBDFw0=;
        b=YulqEpCILganxHpw/yjtIbB4LF0vMhXc465dhc9ZvZ+Ut3p5jRfmDW8UUInt4/xlzdw6H4
        hjzeZ3fNGL7DaPuIlHDCWtxBd1rMJ5B9zLARfsaVHCVOZUj+tEYrSuT57M0mc3uSHVRaV/
        c1ndsW48yuAvQeyHF8+pdgfuJExboaaZc5HELpEssCNjqclQj+d/EUgIHXeomxnxxpXbpq
        +GBOEDNh1NsmX+CSpcAUw2PupQthtYVPO/r3sFTKx5FF192Qt7HCyhcGW2TPOeUz67YFSh
        tu24PFKaNC+mcu7kU4QON8WcnAbCDITVKvTufuKhbFFWj+oHnPuifCMKYlO1Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b4G8IX/C+szWZEC+eyjEy6RY7fSFjat6ysiasaBDFw0=;
        b=ByyJRoTvRWtkZce4qO5eSOsl1iC7ziWbW8sy+tEeLFi/a82OtpX4ZOMRSq7rwNB4XBy49m
        Un+HuStEBbX5A5t3QHwaVxP56mwzo6OyTlhvUx1X/kBPQFxhaGeUmwJg1DqhbJl/5HYFWy
        7sO7oiLQ1j/5qEVLSe8LTkgbo+AjcPJzJkWpOYTZpJHCP28IA0wyz4/tPCYo+M7Nq7I84q
        5mPZ3GZ6RPQY4CYjbg/v6udzZh5DKobpbHmX1/N84L11eYZAog6j2ASOBUmhaWg/yhHs5c
        1eJhJibzkAFUmkBKC/bTdZ78GN9+B+BVT65lHnXysDNwEZMy8LSzbNR6oJrmXA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692286532; a=rsa-sha256;
        cv=none;
        b=qMWZnqr7UpXOCmXRHsFJCU8TbSBXsB9iBBD7AG+fIKNGx1EQspv0xOWhQ8AsMV4K9KoQgf
        fFheIrr+5zjaaE2LLWA98lGqN5tSezgAmeuzYUIpp1ccIT2GLHl8aA/SYuEr884lzA3pdL
        BeWE72xaHMvTb+LCBcY8BA5rAACd/5SaW8K32UUj5ZWLeeP7X6dlc3m9vWHRCUclPTZR3D
        ln6GKaxaD0GgQcUDzPasZWu4qJTBN9jOMQGrEEP/ml54dFmwoRa6AjCpucltkWCpMwE+2Z
        2Qoejmoz0OF+6Zmj6yoe6ZRQZqRk356J3dpYGOrW5SfY6ARPqNgyxRKQp8EtjA==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 05/17] smb: client: rename cifs_dfs_ref.c to namespace.c
Date:   Thu, 17 Aug 2023 12:34:03 -0300
Message-ID: <20230817153416.28083-6-pc@manguebit.com>
In-Reply-To: <20230817153416.28083-1-pc@manguebit.com>
References: <20230817153416.28083-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The automount code will handle both DFS links and reparse files that
are mount points.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/Makefile                        | 2 +-
 fs/smb/client/{cifs_dfs_ref.c => namespace.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename fs/smb/client/{cifs_dfs_ref.c => namespace.c} (100%)

diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
index 304a7f6cc13a..851e6ba65e9b 100644
--- a/fs/smb/client/Makefile
+++ b/fs/smb/client/Makefile
@@ -21,7 +21,7 @@ cifs-$(CONFIG_CIFS_XATTR) += xattr.o
 
 cifs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o
 
-cifs-$(CONFIG_CIFS_DFS_UPCALL) += cifs_dfs_ref.o dfs_cache.o dfs.o
+cifs-$(CONFIG_CIFS_DFS_UPCALL) += namespace.o dfs_cache.o dfs.o
 
 cifs-$(CONFIG_CIFS_SWN_UPCALL) += netlink.o cifs_swn.o
 
diff --git a/fs/smb/client/cifs_dfs_ref.c b/fs/smb/client/namespace.c
similarity index 100%
rename from fs/smb/client/cifs_dfs_ref.c
rename to fs/smb/client/namespace.c
-- 
2.41.0

