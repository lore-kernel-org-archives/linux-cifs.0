Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E79C04A95
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Sep 2022 21:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbiIWVyl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Sep 2022 17:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiIWVyk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Sep 2022 17:54:40 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02C810FCA
        for <linux-cifs@vger.kernel.org>; Fri, 23 Sep 2022 14:54:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vg9nJ0CdU+axka/OmTBvkZlnkt4GtLmeISltnwXoOlx+X1P4ra4rvGaK2ltteUWqCmGhN4WpizZRxh2LaQlp4uiw4ZvYjWE7wkNp/LtwBLPnIQuiVZaZQt3UNg0kpMRCJtj535nYiy2VLQUCFwCjaU+hD4k21rEpKTyQnlX80d9MH7vU0kY/ag9bdTuc6a9PvBS7dY/AfqfUMVljrtW/DbZMrI/F+/S60OdUSwsFVkjlpZro+TkLp01WzmZ2U+lMpQJGet4sZtPIVYLi3Qu+M4FylP45mmce715iaPgzwbNF1w0jH8Sm0gk6ZA48Rejm40HgjjKqMLrjy60d+iHk5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zt3d8Oy1VfX+ugp+UOthZmnd/5vgHGAh5+SQqKRIXms=;
 b=CvnLaYfeghzHbRImaRr6xLvLgj7vusDeAJM0qnACQrjcFUORcgcwfqNqRmLl2i+qogHjvuvsaz0S8HvfelX/vsrLo1YWy121TdYHDqzZdQpTXKLI1V+gBY66RCHHy/QDDflrFkGdZX20AMC4YIUAsDAbRP9YHCVzZPhOxIsxfViUGy6RV/7bJwFg0AKN0zJmt7DrmlbL9uPjTDq6p/NokaVK6pXnAe9eNCXuiSzqcBEFOEqxhiDB3FeckaKikgCf3GQkk0tvLmt1LJ4Ue8bvjcsaMdsa9GGddrdLLYPVsW5E3Yb9bolnyERUmoYJ73DOCQBAFnBncP60VItMY5AiCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MW2PR0102MB3481.prod.exchangelabs.com (2603:10b6:302:5::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.16; Fri, 23 Sep 2022 21:54:33 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0%3]) with mapi id 15.20.5654.014; Fri, 23 Sep 2022
 21:54:33 +0000
From:   Tom Talpey <tom@talpey.com>
To:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, senozhatsky@chromium.org,
        bmt@zurich.ibm.com, longli@microsoft.com, dhowells@redhat.com,
        Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 3/6] Reduce client smbdirect max receive segment size
Date:   Fri, 23 Sep 2022 21:53:57 +0000
Message-Id: <695ca86038c26eb1c806050c365e22f5e8464f4e.1663961449.git.tom@talpey.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1663961449.git.tom@talpey.com>
References: <cover.1663961449.git.tom@talpey.com>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: BL1PR13CA0074.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::19) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|MW2PR0102MB3481:EE_
X-MS-Office365-Filtering-Correlation-Id: a6f4ebb7-aeda-4f63-9808-08da9dae2f28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Inl66A6JG9FC06CuVoivWYrQhZnnUciI45jGaosq6ztqm5fmSuTjuCwEDbCH4EMrw4bvp/upcItfWwIn/02EtyvUWsjAXo6PSi3LTmB8AT32Q6kDrizD2eolbClNSI3JPAIOGsV3CkEdWKs5uadISvElnuO6v6qFJUGKUbnF1B0sTYlibU61Ry6IBAGOt7ccMo4Sn8ktspwv90ZbTizbAn8xqWL9ZTc1Ja/b8qeQYrC0DyPmZmmmQW2jArhI6+GALZ/jvrST/Cz587UCwW1bhLOkpbVn/HZs48XeELloCn6ao1s+HsxIwUQosQdUPMQPKUmtMKCAWzrtOvdZIxvJA2OVho9MPO4ZwIK1B/a08W0cX+IpfUDBAU2uUVTeJSdei538OhPVQjJtOQvM8gH68DeMm3aQXZRIYoRGa222YgEbcf9hjKx8WZA3UlJX4Zu6O2tBNaI667fuYMhr/gJi10yr1+7L/f8iuKliswCYgG6YlKgH/o4B6J3/y8qimotCLAWu7ItD4y//aVyq1Rb/f/juVqZJHXB/45W6zK4Bwo+e8+9IWaQ9h1k57iMZBKCvtZ8qc44AvD/g7FBuoJp4YuV6qjQKsZAETyrSltXsi9B4FYAnPJ9Py1PRjDi1qVxe01BBhdLOXbjUyrn1zlY5GKTqa+Dm5kHeyDKJ0lra0YSyB4piqvTLMhCGatvU4jDWiTo4f0dYG6VBDC7sHOcSJbd/dM5lRqw+8mBeuEAcXChHTNZCW3Ms1j2gWiZwVvqqVb5KZfxLVQx7kHU1RaBG7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(366004)(39830400003)(136003)(451199015)(8936002)(38100700002)(41300700001)(66556008)(8676002)(38350700002)(66946007)(66476007)(36756003)(4744005)(5660300002)(2906002)(26005)(6512007)(6506007)(52116002)(4326008)(186003)(478600001)(6486002)(107886003)(6666004)(2616005)(316002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Vzn6nfJnC8Yfw4rrP/GV2EH64kgZcACnp6sZZbrPQLhEaWHKXvyD95xRZwX?=
 =?us-ascii?Q?GxbUhByFAg2mWka/UfveDwXYMZvIUmKgN/Oj/T2LcpSXphzDgMx0q97l/nPa?=
 =?us-ascii?Q?33+1oQg0veM7PRkfXtr8N4Rwuw/60el33xmpSD3V8rYgObcYPkjEhVNJVYZq?=
 =?us-ascii?Q?Npd9Ut0PxICneOC0KxS+gmF2Cf1ZklMRBqCvz6syW6j1aZ2yzPPvNi07B/p4?=
 =?us-ascii?Q?FUjpBNuRhkKxuMMawYHdr6I5RLk3NgzjbjiedvzJKtpm2Uyfx1ovEreyUEho?=
 =?us-ascii?Q?wtRHBAylJfGxt2MwKC2jQ1Tp1+JFnzhXnuSRPJME2pRgcCjVj/kd3daSHTVy?=
 =?us-ascii?Q?dUpIjN1hQbmDN8k6wRVeSnK9XJeALCUbTfmzAr1SswBS3cF4vQG3t+YzSBIH?=
 =?us-ascii?Q?Z/niIxEMRKabW/UNRDlMhKh8cuSVS+FWXv2rK9AyCyDZKVJGjBthPytZeOgL?=
 =?us-ascii?Q?ECuYcNZgTthEUtyNrqNS82athbWodGiPJkIJz6M40zMnVHUbTfCRCdZXKgl5?=
 =?us-ascii?Q?Q01lR9uN+5tQsckjp5iRa+6cRj8ubAT051gnlC7CAnqigh0y+v9jwX6zfOIQ?=
 =?us-ascii?Q?RIWPdZSay0Q8EV0um6GYMaAslvTTATZIe3zAr2E/eCU2UHqwpHEAWqUHgeDu?=
 =?us-ascii?Q?8lLV/XsJU/470+N44Wl9qnmIXaz48WnpeGx6zPHO3a6P98I5oEwv4hHtc9LR?=
 =?us-ascii?Q?8rzNdnzGH9rhu3Ya/BZnkm/Q0EyoFL0OrbDte0LZu3OR60GiE/PKxZ07z4q2?=
 =?us-ascii?Q?ovAKg/8p08VM7AaQWf4m//96En/a2O0OnxWKYhE/nP5L0FMP67+fBoptiZRX?=
 =?us-ascii?Q?IOSknQlVzSx1T8ZwisGPA4Zr6PxNzFDP1mVdxob44Jt9WRUnF4I82E1Gvanc?=
 =?us-ascii?Q?9S6wo8FmeQpyJoeBUCcuk5dH3clZY8D04SyLKUtPvq6TlhxJJ87jk/7E1sS9?=
 =?us-ascii?Q?zbdxV32dtDIjKgzzwhNx5F100+mSVeNJ4cU0uYyDk61agoBAVj3pkSLjc0Us?=
 =?us-ascii?Q?TZ5G5znculMrOIvJ8IE8ItNAobhXKcboz3FP66XyAz2vZ0wIBXgStJ9tnKhm?=
 =?us-ascii?Q?W4vAXXYs6U9/43+9dc2hNI3egIui+HawTlMB0lrF1YpiirTjYtUyQZXe3gpg?=
 =?us-ascii?Q?UKWUKWFwrmzOH2r8OB1vcS3ODD3PdtzkglGfvbS9Z0Yc8kGmIGD2MWnB0pD6?=
 =?us-ascii?Q?SjsFa1hoWjTFSuRCKhhyw3ULBZIQ4lIt2gdb2G6SpYJGG+Zo/N/VvT4oAn4Q?=
 =?us-ascii?Q?IeaB+DOpgzKGyWr8YdYOuMwEJDJF1tposEpoz9YZfjFWocr/C7W2eCjFc04a?=
 =?us-ascii?Q?tQnBzpyQv8NbD3M1xlV66SYm3MLegZIs/30JYT931TDh8JlTH+qLOmhA3TFg?=
 =?us-ascii?Q?5LUUipPEnj7s2uK7Ubp1k7/ERzvQxBsfcjnSQhhhM7TRv+Zj3mNY/BrkwXWd?=
 =?us-ascii?Q?hS5oD6YJEn0HRPPgUUXtgrM7tEC5E87aeI1jabmisrEJQD3P0/xWGwog1aRm?=
 =?us-ascii?Q?51TdWhsDVqcjdS6HTPiC4rR9wvAGkal6uXrkHmhjlDhYzmYltIasFRJzGaqB?=
 =?us-ascii?Q?W5kIyLg1sxO9wgnCvP3+iD5nCWnJJewLz+Ra0JZy?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6f4ebb7-aeda-4f63-9808-08da9dae2f28
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:54:26.9281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DcFu/YZxJg1kvC2D/YL/lvpplDFPBz4Y4oHEinxyY0JP3Zs+A+hSgWVjWNHFskQc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR0102MB3481
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reduce client smbdirect max segment receive size to 1364 to match
protocol norms. Larger buffers are unnecessary and add significant
memory overhead.

Signed-off-by: Tom Talpey <tom@talpey.com>
---
 fs/cifs/smbdirect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index f81229721b76..4908ca54610c 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -90,7 +90,7 @@ int smbd_max_send_size = 1364;
 int smbd_max_fragmented_recv_size = 1024 * 1024;
 
 /*  The maximum single-message size which can be received */
-int smbd_max_receive_size = 8192;
+int smbd_max_receive_size = 1364;
 
 /* The timeout to initiate send of a keepalive message on idle */
 int smbd_keep_alive_interval = 120;
-- 
2.34.1

