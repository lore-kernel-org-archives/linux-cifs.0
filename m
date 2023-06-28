Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F6FEB64DC
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Jun 2023 00:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjF1AZR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Jun 2023 20:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbjF1AZQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Jun 2023 20:25:16 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621022728
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jun 2023 17:25:15 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1687911911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vjpwrEwjGLoRuhV3Dp39DD6epcioRRaNILQC+qjWAbg=;
        b=fY/6409GVJGY/G1ndOMMz8EtYzpQ7WAB3Sz3ZwolocrrF0WF/wwtW1U9bt+KBBDHxC1YAf
        WaaxynBUNp0WHVsEv7Ts8O6xalnC/ypo0ntb2dqn9yceN2/pj9IwIiSojo1U6E7Xc7AI3c
        2gw6dR/YNqO+9zukdeJUavmXIqJtNhj9hzbGajWRpgCokR4b7y4oM3+0TtCPz0+LmPyN9Q
        xkALjy7tg/mfOA/i68m/O6+TXmnXWu1g8oJ73WmcL3Y9OAiORosbqb/1B96OxMdwZJDTb4
        pfd0+osF6RrKcGzv62vgiI0Y6c5OkAJoKPr3I9+TAmMCuI9YfvbuKo55E3N3Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1687911911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vjpwrEwjGLoRuhV3Dp39DD6epcioRRaNILQC+qjWAbg=;
        b=lDXC4DdNqfLdnw/j89gY4qB1BxwUtn5cS/Re5rbcJKD3Qo3l3CafQ/7V3pfPsa/gGEuORo
        EVILYOQ6xANHeGdZ6kSUCxPRF/fuALIMqg0OeqEaRnudrT5Al6aDcKVa8BcHGLkEOIDMk8
        jHkL+YxYX7ndxxQgYLVXvgmWTjEnZgh/vWfylGV/IApTPqhHZwDuDeCrFtvcI7/PoAOlZB
        UpGgjVmv7IOOAK/kTtpS1o6b7EtDQ/JGmjghSLes0+RJxREG0kbctpDK/KCWB8i9/RKheq
        c8KIc13C1Rpt66sMNdWyr+Y8I9QulQwwjxjjvKCpMqn7I6fN1CbDgJxlBps57Q==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1687911911; a=rsa-sha256;
        cv=none;
        b=s/BGicgR8Z1ikIiCbETvscvIu00VXtDpjV22cmKpIz4jQHwG6X+plR4xrLVxB2AemHoOH9
        Zj/prW/hk19R58ca65HnhI93ZQmkIdxYLmD4Y0yA24ITtsQ46oaEQz9ogwfHa85p8MixPE
        38Pwml0FYthsEzF7j3ZRyNm2ABCe2VQ49okh1/IEdCbeSkhanPTUAToK1TzVMbEAnRdwuX
        8qnv93YVDfzMeZ1IT2sUeYsbF+ElCpaDO7Vaxk5dP60+mN8UEadMYskh8+LtNJh4ylnm8T
        EdwgugUFJpqNZ8NK41/D+wEPn3zlkAN5+Hhed9+cUQ76UKXd6WUargGzz/SSJQ==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 3/4] smb: client: fix broken file attrs with nodfs mounts
Date:   Tue, 27 Jun 2023 21:24:49 -0300
Message-ID: <20230628002450.18781-3-pc@manguebit.com>
In-Reply-To: <20230628002450.18781-1-pc@manguebit.com>
References: <20230628002450.18781-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

*_get_inode_info() functions expect -EREMOTE when query path info
calls find a DFS link, regardless whether !CONFIG_CIFS_DFS_UPCALL or
'nodfs' mount option.  Otherwise, those files will miss the fake DFS
file attributes.

Before patch

  $ mount.cifs //srv/dfs /mnt/1 -o ...,nodfs
  $ ls -l /mnt/1
  ls: cannot access '/mnt/1/link': Operation not supported
  total 0
  -rwxr-xr-x 1 root root 0 Jul 26  2022 dfstest2_file1.txt
  drwxr-xr-x 2 root root 0 Aug  8  2022 dir1
  d????????? ? ?    ?    ?            ? link

After patch

  $ mount.cifs //srv/dfs /mnt/1 -o ...,nodfs
  $ ls -l /mnt/1
  total 0
  -rwxr-xr-x 1 root root 0 Jul 26  2022 dfstest2_file1.txt
  drwxr-xr-x 2 root root 0 Aug  8  2022 dir1
  drwx--x--x 2 root root 0 Jun 26 20:29 link

Fixes: c877ce47e137 ("cifs: reduce roundtrips on create/qinfo requests")
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/smb2inode.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 7e3ac4cb4efa..8e696fbd72fa 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -609,9 +609,6 @@ int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 			if (islink)
 				rc = -EREMOTE;
 		}
-		if (rc == -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) && cifs_sb &&
-		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
-			rc = -EOPNOTSUPP;
 	}
 
 out:
-- 
2.41.0

