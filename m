Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E499C4332F
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Oct 2022 18:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiJDSMy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Oct 2022 14:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiJDSMx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Oct 2022 14:12:53 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6CC3ED7F
        for <linux-cifs@vger.kernel.org>; Tue,  4 Oct 2022 11:12:52 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 8E8988079F;
        Tue,  4 Oct 2022 18:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1664907171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CA3gSeST++gzDQ+2eYEm2lpX5LJ4jqanAmPWFRIuzkg=;
        b=fZ42YL7fD2yTadO1oGKAdZM0cLkkTghjVv5sElhV1vlSJpcYmn2Ddqhb6h4Jaw14KDuxgU
        MssyplF/EyQEsV0eZp/lIZ8n6FtfkfAmOp6gqD0D+UmQhUhPfHpwx1Urwl/Fasfdie7eYV
        KusmNeETF8dJPADYePeKH5QUkWQDbeMgDlnTvssA2dfFu2GFBqMwitOkIBVt6lC05sURJH
        uuAo8twVaGzXZB3BCwic2Ie9y31xYhqu2l+EDP13qKpW8PzjZA89r21QNMxTBBRfh+druC
        5WWeWod9icYNmI0yXJEOcVU4rWP6ml4KZElPffrpvHWCi8bPfBScAD+DobEdpQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2 2/2] cifs: fix uninitialised var in smb2_compound_op()
Date:   Tue,  4 Oct 2022 15:13:25 -0300
Message-Id: <20221004181325.15207-2-pc@cjr.nz>
In-Reply-To: <20221004181325.15207-1-pc@cjr.nz>
References: <20221004181325.15207-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix uninitialised variable @idata when calling smb2_compound_op() with
SMB2_OP_POSIX_QUERY_INFO.

Fixes: 5079f2691f73 ("cifs: improve symlink handling for smb2+")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/smb2inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index adf71b328f32..a6640e6ea58b 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -415,6 +415,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 						tcon->tid);
 		break;
 	case SMB2_OP_POSIX_QUERY_INFO:
+		idata = ptr;
 		if (rc == 0 && cfile && cfile->symlink_target) {
 			idata->symlink_target = kstrdup(cfile->symlink_target, GFP_KERNEL);
 			if (!idata->symlink_target)
-- 
2.37.3

