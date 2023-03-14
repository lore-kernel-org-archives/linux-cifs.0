Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF0CC6FD1D
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Mar 2023 23:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjCNXdQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Mar 2023 19:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjCNXdO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Mar 2023 19:33:14 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B7E2CFCE
        for <linux-cifs@vger.kernel.org>; Tue, 14 Mar 2023 16:33:12 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1678836791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ji5w3vP0ehw4Hubuf+4CIYaxb0XuD6cSbxUdz1KdVM=;
        b=ag/BRs3McIQZYzFj4jHwXIir9rL5rdmZO301su74/9TCkEcpn/HIXQOitE1jvgT9kSHaGm
        bh/aTBoZM4mzqIwIelZESOHCDoA/6wc/yUTyQQl10tqtFNlFUGBe6bf4G59BIIhkrJ5N+0
        iXAWoYSJIDoGHIWsO/0hn1ppcdLbyYhBx1gaegPuu7DyaDloeVpMzxpOG8SrI5BLNvQCST
        FpHbdgL5KDxu8rIPyT3F2QVpI1n6+jkC/hGN848gbknrhhfflfcsdcyVC9S07hSgtHOvHU
        Y766tyQ5KA7Rbu6fF92lY38zfsZi6LWOGEtAQCXhL6TQTea7YbZHuooA0qFCLw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1678836791; a=rsa-sha256;
        cv=none;
        b=gkF0ghob4Nfpx7ZFtG32igiq3gIk1yc7ULS8fL9B1thYpCrIVd+PA7AvirXrAw9Q20+F+V
        8cTlujveR7vgmVTxz+Zbp1xOBfIcwPQgBu4QhjQhC9GG1A0yk8JFcvetCMFNaeMIMZWHgu
        Ylb8tUZeseAs69sIzsRBGd1Ne5z2lpa+orXKqvUfkyYnBRxKdTSMVMzarQZCP2fXbsu/6V
        pzQlfi665Rp6vtiqoLExSzNBuDrXnDX3EA74GWkpSayKhv+x2Lf6wyuf6dpIG4REk/HwvD
        sa4zAzwL2IxKXxapduKQPj2C0t2bfSIBFOkcjCruxLBPjDaDxLCtYZEbkTW5zQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1678836791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ji5w3vP0ehw4Hubuf+4CIYaxb0XuD6cSbxUdz1KdVM=;
        b=jJIGx8Wje0jgAVlxiRjyO0aoP9/qEalOTy8ekTflIqsVjKriYZMIJ3UgqdI31/pZGsx712
        nXLEraqUaPKu3hZ7cwf7fnIGb+qAXQj5ZsPufoeNk+QiXd6RIu08r7zAw607hrnjNBynxY
        tkuq4sNpJtj5OAFl2Dco+ofaZSixDCFG63Z+oqZL1F9TLUXCsOuB2PdTj6ZIbGp2VO5PKB
        EAIs3iWhfblpGwR3J3ttOvWvfxtsML66qsgReS51zhHJvRiBQ0ztNR82kPlhwHLd66KjQ5
        WrAXYvQqaTREN2xTzF8F8W0pWcOgbB12Q7B8YL1k8LtW7IbQu17cmZPDQ8UOZw==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 4/4] cifs: use DFS root session instead of tcon ses
Date:   Tue, 14 Mar 2023 20:32:56 -0300
Message-Id: <20230314233256.16468-4-pc.crab@mail.manguebit.com>
In-Reply-To: <20230314233256.16468-1-pc@manguebit.com>
References: <20230314233256.16468-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use DFS root session whenever possible to get new DFS referrals
otherwise we might end up with an IPC tcon (tcon->ses->tcon_ipc) that
doesn't respond to them.  It should be safe accessing
@ses->dfs_root_ses directly in cifs_inval_name_dfs_link_error() as it
has same lifetime as of @tcon.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/cifs/misc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 6f9c78650528..b44fb51968bf 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1262,6 +1262,7 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
 		 * removing cached DFS targets that the client would eventually
 		 * need during failover.
 		 */
+		ses = CIFS_DFS_ROOT_SES(ses);
 		if (ses->server->ops->get_dfs_refer &&
 		    !ses->server->ops->get_dfs_refer(xid, ses, ref_path, &refs,
 						     &num_refs, cifs_sb->local_nls,
-- 
2.39.2

