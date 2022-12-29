Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AFF1C3DA79
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Dec 2022 22:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiL2WE7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Dec 2022 17:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiL2WE6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Dec 2022 17:04:58 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64789BC3F
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 14:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672351498; x=1703887498;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:to:cc;
  bh=rdXt2PZHBXw2YWMOphhjUm6XadC8g7OTuNG/wCex40c=;
  b=DnXNy1OWQwx9ZPFk33vfQl92Zw2qzpMxZqRBmLWoYrTWFEVWqGnFSIVq
   ALAT7iBeDi4okAFClp0LsNQ32C4WLqEURy721+jOlIkl5OFOxXFjFlF7M
   4nCEmsMteCcyp6e9XTRAI6sd9k9t2Qx32YBmEDSk7kMIQJD4yauC8znqU
   CmaonrkYwam1NphE1ZI4A4AgzLL/ifDyFKEZmpbtuB3fhlp2mh3H3NmZl
   EshoZSy8VZyq6WR5FdB5imgIuFXiAhq//4kpL/CZbfZfVKAwwcHCuq8jj
   I7Gv3nXrfDyrmeJS0odmTHGuovEvbDQFG1X2dLG8j4EyuoAZj2AHOxtTr
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10575"; a="385545716"
X-IronPort-AV: E=Sophos;i="5.96,285,1665471600"; 
   d="scan'208";a="385545716"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2022 14:04:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10575"; a="899093226"
X-IronPort-AV: E=Sophos;i="5.96,285,1665471600"; 
   d="scan'208";a="899093226"
Received: from iweiny-desk3.amr.corp.intel.com (HELO localhost) ([10.212.27.114])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2022 14:04:57 -0800
From:   Ira Weiny <ira.weiny@intel.com>
Date:   Thu, 29 Dec 2022 14:04:46 -0800
Subject: [PATCH] cifs: Fix kmap_local_page() unmapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221229-cifs-kmap-v1-1-c70d0e9a53eb@intel.com>
X-B4-Tracking: v=1; b=H4sIAP4OrmMC/x2NQQqDQAxFryJZNzBm0VKvIl1kZjI1iKMkpQji3
 Tt2+fjv8w5wMRWHoTvA5Kuua23Q3zpIE9e3oObGQIGoJ3pi0uI4L7zh/RFC5sgl5QLNj+yC0bim
 6Xos7B+xa9hMiu7/yPg6zx/QunWldAAAAA==
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, Steve French <sfrench@samba.org>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
X-Mailer: b4 0.11.0-dev-e429b
X-Developer-Signature: v=1; a=ed25519-sha256; t=1672351497; l=1502;
 i=ira.weiny@intel.com; s=20221222; h=from:subject:message-id;
 bh=rdXt2PZHBXw2YWMOphhjUm6XadC8g7OTuNG/wCex40c=;
 b=GNTMMJHJ6K//3TLb4zIn1TVx5mdU/2vVLxwXQfqoW/UQSsHm4K4PxlbftKJrn6gTGEmXi7K8M5x6
 8rNaPZHCC0asw5R3KcnaFHxEJe+TR+HLjMZx6yNnbEFM+TV4FCxe
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=brwqReAJklzu/xZ9FpSsMPSQ/qkSalbg6scP3w809Ec=
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

kmap_local_page() requires kunmap_local() to unmap the mapping.  In
addition memcpy_page() is provided to perform this common memcpy
pattern.

Replace the kmap_local_page() and broken kunmap() with memcpy_page()

Fixes: d406d26745ab ("cifs: skip alloc when request has no pages")
Cc: Paulo Alcantara <pc@cjr.nz>
Cc: Steve French <sfrench@samba.org>
Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/cifs/smb2ops.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index dc160de7a6de..0d7e9bcd9f34 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4488,17 +4488,12 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 
 		/* copy pages form the old */
 		for (j = 0; j < npages; j++) {
-			char *dst, *src;
 			unsigned int offset, len;
 
 			rqst_page_get_length(new, j, &len, &offset);
 
-			dst = kmap_local_page(new->rq_pages[j]) + offset;
-			src = kmap_local_page(old->rq_pages[j]) + offset;
-
-			memcpy(dst, src, len);
-			kunmap(new->rq_pages[j]);
-			kunmap(old->rq_pages[j]);
+			memcpy_page(new->rq_pages[j], offset,
+				    old->rq_pages[j], offset, len);
 		}
 	}
 

---
base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
change-id: 20221229-cifs-kmap-6700dabafcdf

Best regards,
-- 
Ira Weiny <ira.weiny@intel.com>
