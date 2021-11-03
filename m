Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD63C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Nov 2021 13:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 631E560F5A
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Nov 2021 13:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhKCNVy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Nov 2021 09:21:54 -0400
Received: from mail-eopbgr1300097.outbound.protection.outlook.com ([40.107.130.97]:36463
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230152AbhKCNVx (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 3 Nov 2021 09:21:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRMvWMcAiJcBV3HcYZ1kQ59xfrwtSzz9njYaWV7uEIY9BMi5NHRybe0VbYCORhwFHg5aKosJ6D5ukzjp0A9oDsdKhd1V5SuHBcZX/o7XSQsItoStQJGdnskshNr7nt/2RD3zdujAdMULZPw4hJDhMffGsGbnm+uqpbnpcUCeHDDyKU8P+ZLGW2U4aEqBoPEbWlT0+LEG07X4TK9OaH2EqUbUt4E4ZkV2wYl5nw+dZcUct1JvYzhMxlQvLlCvcsRW0r1v9gzyrdi84de3dunpBEw71UtT+dbeIbMV/5zercGoWKnS0c7QroG1Qle0Rk0dDpexqBpm+7Dcjce3L4fHNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d9PSloAzfnntEa1U26xudPYwxUxK8CsNR+s0o0mD5p0=;
 b=lTMt0zMugOIhxsLK3g9qGlpeoaa/MVDjpnDsCf0Nad2QZKq41LLIpmAn3Q43JWvYcTrmjQl4FRDjvPYRTnzUHJNqwEnRnPcm5mLFgUmW/3XXlKcUlQx0l3P21GUUHDnfsDuNYFLWKVCF71zwERpXY/fk9H3tm1sICGC4VugfMoT5lFh8FrDwLWmlp7BHFlHSDyYzT9oEl5vSIhsEw/PN44iY/UPDqfpKv4tQok5bkzVfFW3+Z28ojzcpiiNJxN5GHk65VstGfEgrzIipFcFNppPtWZJtVsFM6NaNFkX1yka3tRmM0V0tGZ8+lY3WTNRCnO61SVWuiuFBnAdyifgswA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9PSloAzfnntEa1U26xudPYwxUxK8CsNR+s0o0mD5p0=;
 b=moRKUT5LGwR3NSweE12q66MRn+atF7bJshbOD95e3EWRncGP8Dbe9XpfB09mWLJcmCPvc2jSIr62F3sgUPH5AxLTZ97P+nPkmQduWFejIxbsx2hE53k6I1GbBCXcJ4cU2ANjCoTLyUEoJPVf0hduolzNmzxOLCXKCROF+Q2dfks=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=vivo.com;
Received: from PS2PR06MB3493.apcprd06.prod.outlook.com (2603:1096:300:63::20)
 by PS2PR06MB2534.apcprd06.prod.outlook.com (2603:1096:300:53::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Wed, 3 Nov
 2021 13:19:14 +0000
Received: from PS2PR06MB3493.apcprd06.prod.outlook.com
 ([fe80::74dc:dad1:27f5:5249]) by PS2PR06MB3493.apcprd06.prod.outlook.com
 ([fe80::74dc:dad1:27f5:5249%5]) with mapi id 15.20.4669.011; Wed, 3 Nov 2021
 13:19:14 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Guo Zhengkui <guozhengkui@vivo.com>
Subject: [PATCH] ksmbd: fix flexible_array.cocci warnings
Date:   Wed,  3 Nov 2021 21:19:01 +0800
Message-Id: <20211103131901.28695-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HKAPR03CA0008.apcprd03.prod.outlook.com
 (2603:1096:203:c8::13) To PS2PR06MB3493.apcprd06.prod.outlook.com
 (2603:1096:300:63::20)
MIME-Version: 1.0
Received: from localhost.localdomain (203.90.234.87) by HKAPR03CA0008.apcprd03.prod.outlook.com (2603:1096:203:c8::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.6 via Frontend Transport; Wed, 3 Nov 2021 13:19:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 553f769a-8e61-463b-03ca-08d99ecc87ee
X-MS-TrafficTypeDiagnostic: PS2PR06MB2534:
X-Microsoft-Antispam-PRVS: <PS2PR06MB253465499A806B66596AE8CCC78C9@PS2PR06MB2534.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nFTTj2qMoqLRKfgpXN8ax/FiTRCYipHNoSZmhjWZu4V0oOAumZC2lTk4MzTjROnQIUcUXHGt+mHdqjB5jF6S+vuBK9ON6kMIZ/C+DCsQPoEyIZIigiuZTBPS55fTWOs3DY0RV61CBoq5GEfP2xiG54ehOKsCZCljv9tzLJYSHg/q/y54z16Tr9IoX52potIHqfOwsUf1NNrBbxz+yQ6aQKW2noA5jS3iOE28TjoYaJVS8UoI+B01cbRQRy22vRLD8/nvPbdgQFuV5hXJ2QYgE+5N8+AGg1wCigViZwBKiDA/0rZ4vTugUzMGlBSCZYCoWPr4lA/RjeNk3oihqGBvkZ+KAFtJbmRpd/6i51Y96t1y0pIJR37qSUmgXbkNz9pktyGgTLVkV+xBGrMKRaLpHnl/Cl9MkvFxMSP3iOXnW6XcGsbu5FynFnmniFrh+SW6frTxjExNzPVSkg9nX1ziYG9Vq0YXCleMWT3IUD3Qg9oantKvH7QaoRZUZ4uCuG2ja2radC43tv1T3CPkYxf53MffwmBYFvFbKb7v9udRcjWAKmOfKaacTqWzOdpe01RybJIDM5lOeLE4ZFxVxchNJf6iENy3bFV3CRgVxeDS7Xg6O7eZoDid61CNe60roLTVM9fOeDYt4y7auh801ScAqDRu03FiD9P/6YBi3TKAJcC3EYqAYFae7JGD8LvbB59QmKxXvtiCyux7kNOEdpq67Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS2PR06MB3493.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(6506007)(6486002)(86362001)(316002)(52116002)(83380400001)(508600001)(66946007)(66556008)(66476007)(1076003)(6512007)(107886003)(4326008)(4744005)(110136005)(36756003)(6666004)(38350700002)(956004)(2616005)(8936002)(26005)(8676002)(38100700002)(2906002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UNY9r1tWpntpGL8NUYDD7f5ZZiPTgvuhDw6ykuJrOUjfX9qDiOvW+v5R0Px9?=
 =?us-ascii?Q?KKi/JIe5eWrdHV5vmZUXF9FCHvw0H/wjk4pbqC7bxOF/5rHvsErCFhd9oJj4?=
 =?us-ascii?Q?L4JMLg1qNHlyh4/9KN9LF/Jk3EGPLAHQcp8wrLfAT0wBU6IsvqJx/GTanWId?=
 =?us-ascii?Q?P4XJUnEiuw2Tu6Oz/NnayrSWOcLHRvoRaWwMB4tA83+7vE4+etG68vSsZ8Fl?=
 =?us-ascii?Q?F57KRmaEc/5eYQHDc9DPpMlL60HHrrtZpq12I9cTQ/mRNI1AHHPTB4XTr6um?=
 =?us-ascii?Q?t09nsirzIt6ZsUVEOA4hb/pEW/Dkxm67+DSq/CC83QhdtnzsIsQwRm2ayVro?=
 =?us-ascii?Q?ro8Nyebm2qPARmpEE+f1utph26iJ1EAr7lpbR1aeKxebq9IHv8TNOItwbQCj?=
 =?us-ascii?Q?uKBTSsgVIG00SrCq4eCsNOI6MeMzGqCuYD8VskpDf/X6m6CiycjuTdlvUbIP?=
 =?us-ascii?Q?DaBvuB9mk5WosfK4v/z/OibEj1eSVmYYR/4Es+To2epoFQ4f7FmcKbRpigL1?=
 =?us-ascii?Q?t5uQymV4MVqRZubCCWyhin+dDYZotZkjFukSoHF3N3Nvyl8s0r/UMuESFWDV?=
 =?us-ascii?Q?Iyjvqt7tUmWh/3tc4Rhyw+KwcOnXm6BZK6+C/xm2zCd379KHM4Ac7fA6aE7N?=
 =?us-ascii?Q?hR61djQFK7VxBXkrktxgczAzBEZHdsZkIDzLubzn8JilHOWMcFXcxUaXevK+?=
 =?us-ascii?Q?9BVF22q8q/7JpNXSklZn8Tepjt4FkZXnKAAEKB4DVZTzVUHGRZk/XUZarqZG?=
 =?us-ascii?Q?QLUiEnBjahyi2ADwMAvHbgZinsejT0aCCT6OgnZuHZcLPOJsb2wjL8/pdPQ5?=
 =?us-ascii?Q?5SZP1ifovUdXsZoO9xuANvhQe8FB7XyOKwul7LqUfae5RCLphUXnv38mUFkL?=
 =?us-ascii?Q?ITYHcgczXMs/JLVLeaX0rYhzc7FXKgkF9d8ybcKOjEatai9lVqDixHX9bFnm?=
 =?us-ascii?Q?atHszPMkSV+8XlG5MynBmiyOOCG2rES6R7ytFgYI8LPidklejrfxMPGRnCgr?=
 =?us-ascii?Q?4k3uToV5dW9QnM+sOkSbWl5LxiYZg8NQOtwI4d7cxSbgrtkPs2AkB9z5NYUC?=
 =?us-ascii?Q?1w0cGozXRsS4kNiM8hZGFcKgBR5VMr6WoZ5O/SxkVQB5h2GqFXxv+HgAaRrW?=
 =?us-ascii?Q?1uX7orOiZ0RbqirS7IlkpOjMsGjmDCeABcfk4qDylxtFsDvxYaWkfBtwdMAq?=
 =?us-ascii?Q?yqas8WEgfQvcWTAZM1w6Sv33NRzLJz20yTpgtXr3/IriAkFPOwhcU3W8CsiA?=
 =?us-ascii?Q?dQ07j8ZcymNw3QVa9Sj6RjPC29HLbnp4ZZbia1j/Gs2RoNdfLNM2niLCoxCx?=
 =?us-ascii?Q?sN9MZuqtImdVzW2vrQEd/jFz4vbmvruRJnK6sGKbG8TVqDuXwRfP1uH6Rc+V?=
 =?us-ascii?Q?o0CFR65Jh0w1/RKHYDsLRceTFpYs4OeyiIldlMh3w5chaKGLTgDc8RgbhUpe?=
 =?us-ascii?Q?+HtNge+XRBbRSGsTYzyWAMRHBOjYwVr6WXr11ezSvP4z3ecX6brR/hiWPS+4?=
 =?us-ascii?Q?KqCD+0atbfU/7ISARpevX6Ari23AO96cDytbM+JhxO54QLIyIo8uXxZJwGoc?=
 =?us-ascii?Q?TIa+3AHFArKVkYSP9nwZhR5xc9RLuRRFYcV25tCKQJtrUMGQqEskNQqmufyH?=
 =?us-ascii?Q?Fno3Ue2LvkCIhK27gnlQu9k=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 553f769a-8e61-463b-03ca-08d99ecc87ee
X-MS-Exchange-CrossTenant-AuthSource: PS2PR06MB3493.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 13:19:14.2624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z0X1fYuPA9KM6u1cTyMruy736ZUJ7BOd3bA2lMMtV8aQXAL1jv56iznoq0VBHfW6x+HxxKkAPcOxyz7o44sPAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS2PR06MB2534
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix following coccicheck warning:
./fs/ksmbd/transport_rdma.c:201:20-27: WARNING use flexible-array
member instead.

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 fs/ksmbd/transport_rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 6330dfc302ff..ca62060acd2b 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -198,7 +198,7 @@ struct smb_direct_rdma_rw_msg {
 	struct completion	*completion;
 	struct rdma_rw_ctx	rw_ctx;
 	struct sg_table		sgt;
-	struct scatterlist	sg_list[0];
+	struct scatterlist	sg_list[];
 };
 
 static inline int get_buf_page_count(void *buf, int size)
-- 
2.20.1

