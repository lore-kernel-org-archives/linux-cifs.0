Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F216AC64E7C
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 03:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CD4A208A9
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 03:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgLCDjQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Dec 2020 22:39:16 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:34709 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727449AbgLCDjP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Dec 2020 22:39:15 -0500
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201203033834epoutp01fddd3d9c88a7d55b4243be7ef819032b~NF7ZaJ0_a2692226922epoutp01o
        for <linux-cifs@vger.kernel.org>; Thu,  3 Dec 2020 03:38:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201203033834epoutp01fddd3d9c88a7d55b4243be7ef819032b~NF7ZaJ0_a2692226922epoutp01o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1606966714;
        bh=a8dyW+RvKaxdeJypkQi3io5tkQJjlX67BbEByU7p5Ag=;
        h=From:To:Cc:Subject:Date:References:From;
        b=X3xXWWAr8KzMq5K9wGRg+8+TZ1Vjw5iQvZ5/MoTypMdOL4aE0X2MzgzUGiVdKB4n3
         NA7ETO0GQLaqjGD/h7hPGGYr2jiy4NG6p2Ou2Ns8DnkPrghajiK42ic7Dn8GamSpGP
         aH0S86GytISJSh+NkR7wZmNfd5XPfxRmUOE8hlic=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201203033833epcas1p1e0b0f58c45c956aa9cacae362f144e11~NF7Y_x1dV0778007780epcas1p10;
        Thu,  3 Dec 2020 03:38:33 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.160]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4CmhQ02GDFzMqYkd; Thu,  3 Dec
        2020 03:38:32 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        81.19.63458.7BD58CF5; Thu,  3 Dec 2020 12:38:31 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20201203033831epcas1p4c69684156cd4e393f048472a24238e6c~NF7XLYbVl0652106521epcas1p4f;
        Thu,  3 Dec 2020 03:38:31 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201203033831epsmtrp1ac84970e702b68f67e877f30670f9393~NF7XK0NS40264702647epsmtrp1-;
        Thu,  3 Dec 2020 03:38:31 +0000 (GMT)
X-AuditID: b6c32a36-6c9ff7000000f7e2-ab-5fc85db743b9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D7.40.08745.7BD58CF5; Thu,  3 Dec 2020 12:38:31 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20201203033831epsmtip219d0b180b3d4077c431e33b4f80b0c48~NF7W-FIq62288122881epsmtip2i;
        Thu,  3 Dec 2020 03:38:31 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     linux-cifs@vger.kernel.org
Cc:     aaptel@suse.com, ronniesahlberg@gmail.com, smfrench@gmail.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH] smb3: set COMPOUND_FID to FileID field of subsequent
 compound request
Date:   Thu,  3 Dec 2020 12:31:36 +0900
Message-Id: <20201203033136.16375-1-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsWy7bCmge722BPxBpO6bCwa355msXjxfxez
        xY/p9Ra9fZ9YLd68OMzmwOqxc9Zddo++LasYPdZvucri8XmTXABLVI5NRmpiSmqRQmpecn5K
        Zl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBaJYWyxJxSoFBAYnGxkr6dTVF+
        aUmqQkZ+cYmtUmpBSk6BoUGBXnFibnFpXrpecn6ulaGBgZEpUGVCTsafl38ZC1rYK77tbmVq
        YDzP2sXIySEhYCIx8/oOIJuLQ0hgB6NEx552KOcTo0Rb70oWCOczo0Tv3BlMMC0tUzayQSR2
        MUpcW7KPCa5lyfVbQA4HB5uAtsSfLaIgDSICchJrN51kAbGZBbIk9l/ZzgxiCwtESEz89B/M
        ZhFQlXj6vpcFpJVXwEbiyGxRiF3yEqs3HGAGGS8hMJ1dYunfS1B3u0hcuPAAyhaWeHV8CzuE
        LSXxsr+NHWSOhEC1xMf9zBDhDkaJF99tIWxjiZvrN7CClDALaEqs36UPEVaU2Pl7LiPElXwS
        7772sEJM4ZXoaBOCKFGV6Lt0GBoK0hJd7R+glnpItB+YxQZiCwnESjyc38Q8gVF2FsKCBYyM
        qxjFUguKc9NTiw0LjJCjaBMjOCFpme1gnPT2g94hRiYOxkOMEhzMSiK8LP+OxAvxpiRWVqUW
        5ccXleakFh9iNAWG1kRmKdHkfGBKzCuJNzQ1MjY2tjAxMzczNVYS5/2j3REvJJCeWJKanZpa
        kFoE08fEwSnVwFRjFbP7z2KVYz+5v0j7BUTMtXg1W6k9MmFribq78YuyZTqJ2t0s/2X4jnNd
        SXTg+KJ4Ozj0vMrxrU/FNy6wmXp76qenWwt97udN6/df5Fy3RDlj9Xvh+YbvRQ7IG1itn2vZ
        cva1wIorTR9+JqrO9l0fXtCjqvNARnQ1b+on1yiO+/GRk/vPfui4uylgwfaT0rL+msfYqvZ3
        uMya0vIvkq9JzaFI7plJZF7DhzMpEQW3zx5I7Wf9tPWm6Ymr3x5LPjMSWZ4Q+eX0s4t86lWb
        ZiavDmd/FG/Ld6nlsKxYck8Ay+WnLSWmyxZ7nLFnn7xe19TWuNPXqmOfxgWjK+Kzbtwt2dYt
        ISXhHcsY6Krup8RSnJFoqMVcVJwIAICu8dfRAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsWy7bCSvO722BPxBr8nK1g0vj3NYvHi/y5m
        ix/T6y16+z6xWrx5cZjNgdVj56y77B59W1YxeqzfcpXF4/MmuQCWKC6blNSczLLUIn27BK6M
        Py//Mha0sFd8293K1MB4nrWLkZNDQsBEomXKRrYuRi4OIYEdjBKnW04wQySkJY6dOANkcwDZ
        whKHDxdD1HxglOj+PIENJM4moC3xZ4soSLmIgJzE2k0nWUDCzAJ5El1z7UHCwgJhEr8XLWMB
        sVkEVCWevu8FK+EVsJE4MlsUYpG8xOoNB5gnMPIsYGRYxSiZWlCcm55bbFhglJdarlecmFtc
        mpeul5yfu4kRHB5aWjsY96z6oHeIkYmD8RCjBAezkggvy78j8UK8KYmVValF+fFFpTmpxYcY
        pTlYlMR5v85aGCckkJ5YkpqdmlqQWgSTZeLglGpgunxj8YSEiTu6mvxe/lBT/RB6qOi68lGF
        q/8W/JxRrVQsd9zWbf8t15D4ztcSehdtz5Rt3aW66t+cCa+Tjn09l3Z1hsHlYqfeO7kl8bJF
        K5/P0rKtrV70gXVyhNHU3FnyJZ4PHv4/Ijxdzs7t9baLVUur73mnrgieoLRpx7r2FfqMixdK
        vTzA0RPvNX1XmxSTImfLj9upT7dbZRzOmndl48v1zqv1ZIN+HfvUPllq9vuTFxZlxjnPNL6s
        3NKx9lFXx1d3dwXtTGbWtJ9FJ8RKfN1rWGe2WJ+4rbkp9r3DbMUb1dIXTTfHz/i79OIURsMX
        B38KHW+YsyVU8HHdFW5Lvcudz27Wxx0oX7nu4vVFCyyUWIozEg21mIuKEwGETri1fgIAAA==
X-CMS-MailID: 20201203033831epcas1p4c69684156cd4e393f048472a24238e6c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201203033831epcas1p4c69684156cd4e393f048472a24238e6c
References: <CGME20201203033831epcas1p4c69684156cd4e393f048472a24238e6c@epcas1p4.samsung.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

For an operation compounded with an SMB2 CREATE request, client must set
COMPOUND_FID(0xFFFFFFFFFFFFFFFF) to FileID field of smb2 ioctl.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/cifs/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 504766cb6c19..3ca632bb6be9 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3098,8 +3098,8 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
 
 	rc = SMB2_ioctl_init(tcon, server,
-			     &rqst[1], fid.persistent_fid,
-			     fid.volatile_fid, FSCTL_GET_REPARSE_POINT,
+			     &rqst[1], COMPOUND_FID,
+			     COMPOUND_FID, FSCTL_GET_REPARSE_POINT,
 			     true /* is_fctl */, NULL, 0,
 			     CIFSMaxBufSize -
 			     MAX_SMB2_CREATE_RESPONSE_SIZE -
-- 
2.17.1

