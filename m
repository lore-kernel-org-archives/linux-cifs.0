Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44707C07E9D
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Sep 2022 21:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbiIWVyo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Sep 2022 17:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232514AbiIWVyl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Sep 2022 17:54:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C828193F1
        for <linux-cifs@vger.kernel.org>; Fri, 23 Sep 2022 14:54:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JeiLbJn726sNNgG+rAQq6TS4LVk8xVYA8QlI22bD47TTX54yMd7O/0A1aOpEqqG6kntyWomPMtaxruwPJl3qksjeRumGa1qemGoZYXO5u/6VrfrXzzAhqmCe8utH5/q12br92OvPczOSo1w8cCW8iroZVBcjpkVl1RGxmsxye6REGCpOLlZqDl/MugQ0Z5YH+vZehKtEdrsRC4wzTXqduSzm+b1XJ8NwVOJ2o6wFoa1UEgaLdIu1/qMWgGtA20VrndpZoacaGqzVwBo4tCk6/gpsi/JVOwcS5KlLyFSnltXKNoZs8e+qXnwd42cJcW/X6K/4QRf03+OAyff87UlqgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phnMl4ugC+e8OyWUA6WiuLa8GoD33pQPA9NWUYMuASQ=;
 b=PY2KRAfUzq6PoMhpAgT8728uKnIOvn+EaMmyq21wHcWKFpXc3TZS2YYLVDBE3KwhlwtwX7AUAXXY5MhS57t0MtLBXN+0iXTA+CCwBV8kdeVqckqOJzU01IN0Df1yTn12FobKIOoISK5UFJ8LsjYmEHpGvmPMf85AIltc6TpLp7zxC6ErUNe605pUzwHGk9S5FA6nKqoiJLVOdll+g0pI+ZdP8Qp7ZuwEoj7ehJQ7tKzX2H90+/BSAQDbeuR0Cvd8mOjZO9wDF460FomFh94tyQX+MVmlr/nFYUIWZUPoqvU2cHdq41oR2jboLxNrEdn//aO5zXp8qk1q0o5i9znx1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MW2PR0102MB3481.prod.exchangelabs.com (2603:10b6:302:5::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.16; Fri, 23 Sep 2022 21:54:34 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0%3]) with mapi id 15.20.5654.014; Fri, 23 Sep 2022
 21:54:34 +0000
From:   Tom Talpey <tom@talpey.com>
To:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, senozhatsky@chromium.org,
        bmt@zurich.ibm.com, longli@microsoft.com, dhowells@redhat.com,
        Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 4/6] Reduce server smbdirect max send/receive segment sizes
Date:   Fri, 23 Sep 2022 21:53:58 +0000
Message-Id: <f5fab678eedae83e79f25e4385bc1381ed554599.1663961449.git.tom@talpey.com>
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
X-MS-Office365-Filtering-Correlation-Id: 687f566b-9978-40bf-4085-08da9dae2fb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uMhU/cMldhJciwWfz4bgDr0Dys4nvRFuexBhqO6jeBnGdtCKLUjPnu5Nevk1PNA+SAf97n46ApJxRYeaHPjMURCnyUHaq6IieGYpbx4KkBQy9v+SAF1PLbZe1KmgZNQuyxgS+fIngO3HcIDrRK0xGLZeSiSkr5QrXlEMgBYW+GnlBGDV78lRHTsfMpMs0XYrptMyJaOuh+3DHrgDjrplMwi0fZAo1KuZJ2NvAH2/DLbe2+ErvrefCMSayoanJQykt7IXOCot1lAWJV7EZO0+5FNrGXxk8CoFhDqwYMVa37feRFGwlHncjUsW/DRfGVGAa/VQ3iZpKCji435m6SMZvmYHmYUFpCK0JSfatdhEbey9WrWvQ1P8nt4T4aOyLebVEdIjYfwJ7qczkGXvtj678qtB/UeruDUC/cBHWJUs8iF7xJS9p1b3BipKIQMPqtZWWn/eYTe4Zp/wsaXWCbCJ3Oyx6/b6Fr0i4qTCkqEP8m1jn5Akw+vkKadg/F70KfUn0AK5PiH91rH0jCCY/Si9J3hdgqJPgx0KoQRY44Cvdh7pzOvMmMfSSOxJ6SVsPtIDf3RCbSt4iAB88YgIzG7sUJlSHdSWdaEZsGXHns+MrEoSSDGrTfdONEZ2GkkeFrzg8wBI+EyGaKr+TdE46CJrksNP98OOX7MWM2eP7UJhpdzQoWr+ogmMqwAeFcXesm8YXVIl07zVjQupCuvM2RBMu4JuxFZQsYIYb2I/t102P6nWk7Tw1AZ5g/zMVIEwiU4fbjU8lRWLQ1rURuYQDfkdWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(366004)(39830400003)(136003)(451199015)(8936002)(38100700002)(41300700001)(66556008)(8676002)(38350700002)(66946007)(66476007)(36756003)(5660300002)(2906002)(26005)(6512007)(6506007)(52116002)(4326008)(186003)(478600001)(6486002)(107886003)(6666004)(2616005)(316002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7Vc+skfA0FOr6ZioazM2uk7/2POBIZt1dPzQkspBxzhLAEym7qGEcf9Al2bi?=
 =?us-ascii?Q?sz6bHVfj+ReJORbzv8o0zG8TTcwUfPlO2wWDNPILhTYp25Td5sfJIXapFr95?=
 =?us-ascii?Q?M1QzeAwaNnjs52xSiGn4WGWWWvmEKFGNrpRXO8ylTa3vPlZdL9qx+RjxlkPc?=
 =?us-ascii?Q?vkcH2csLEvPDeqRLHERRj3aPbwtUkflW3WErYI12I1nYupjFUaE0y4bAdg6t?=
 =?us-ascii?Q?usUbdnxYFtHFC9J3tzuMa6GdlAC4LQfkaT7k+nEH5Cu3+T+9goaC7m0DoBCI?=
 =?us-ascii?Q?xmdJYFt/7khOnfE63NboozQE+VpCrXpngSvldjo/HvbI7l4aLfk5LO5XXxmy?=
 =?us-ascii?Q?46zo0eBXAhfMX3ZK/Gl5lfINjvEhFHTNpUWa/FaRQJhBppZIAGJ1Q3yc7mnP?=
 =?us-ascii?Q?sJ+NX2OcCXq6F1Tr2I0hZoaIorZq9uuPSU+p7KTaLCDpkaUokhyBl7Qylr3a?=
 =?us-ascii?Q?uywnAQf5hsAgFVvsoRiUg1jrkyatJvg2uvlWsefzrTxjDS1IHitUv3w6d+Jw?=
 =?us-ascii?Q?1Ve5qOb0qE47cX5cLeKTToNhmsvrXM9z/7eVTwsZMy7Z6u5rcRmzKL59+d3a?=
 =?us-ascii?Q?E2bbEQ/q1MBeJSE+ucOjMFKZA2vudy5q5Flw3cJPKqVPofVQ+cmNrUNqoBnZ?=
 =?us-ascii?Q?SoVEC28rUtbQHe0yCn8O8kSOp1PIh61/GBW3x/9Ddkx4qEE98WnlvUkxpZuA?=
 =?us-ascii?Q?633xHulgd8O7+5s34bh0JtRUZsupiXYZD8fIldLQ99uvhhLeYTVk1sPAJh3s?=
 =?us-ascii?Q?WO4o264IFvfdGRQ3vD1gOKeEQ/1/BS0/eLq0LHBjA/cbifRcQAEJ5++AaQnf?=
 =?us-ascii?Q?wE8FZwhpQNoSGmITwKZvbLRZS7RwUv4g+b8ht/Ct2dFTN9lvyn0RLa71cKqj?=
 =?us-ascii?Q?1kz7L79ZBqs0p8FJSwzh0IKYFUuYIHr6/wMD7G+vXW4XVchR+q3k2GGkxoGw?=
 =?us-ascii?Q?rOt7ZKrUX8hJklGK79KSD+Lt/rOAaOxdLFoSCPqRVxK9osXbjIiqtn7M7be4?=
 =?us-ascii?Q?3NB2bKM1NUNBymlNLtYVSGy1kBoHO19As7KsSPM+VhzMF8smQPee/ODA/pJ+?=
 =?us-ascii?Q?oHfCtZ8YXZtJnmgBLiCDp/kAgEJBYrS6nzYGu2VAHpBSuBsubXlGkAWLp+kl?=
 =?us-ascii?Q?YWK2QCOEsVhbY3ikZeteOspqmBblDKVvNzr7JE6gYN8xTIIRZ67MILYIgvd0?=
 =?us-ascii?Q?HtkIJYl2UKJE84E8bgaUQn31GUW73AuWUoY8BgAW0hvaAUMrTm0ng45Wd5p+?=
 =?us-ascii?Q?TRXJEgdJDHhrt6IwY66UdU8TGLK6Vk6SjpafBNIo1iwXzszGwERJAM5A9us9?=
 =?us-ascii?Q?fiSXbRUd/2UhuRr5BLo68nS5RSu69OVq/a3yqyP/ynrhYyCE78OJdi61xQ8r?=
 =?us-ascii?Q?qtYX1QvmtSCDUZohtQUMRj1u9/kWxt0KYkB+JISj4NY0m6831x+OUI8wFsfg?=
 =?us-ascii?Q?B8FeC2+Ed08c5ezZN8cORv1r8ivaPP6fTrkAI1tI7Lv37f+N88dO8QiCkVb6?=
 =?us-ascii?Q?JLeX1LKC7fJVO8wuwgrTIQmhnoWU+ZfM0rHMfORcplJOAvnTC+rO0PUlDj4h?=
 =?us-ascii?Q?kNMKmLiRFGg76Cs5m5T8tJ9cJJDMIdC25rNwsXyt?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 687f566b-9978-40bf-4085-08da9dae2fb5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:54:27.8343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wqwVKg6pMNdo53OETgXJiJqa6kS5QH7yDclrjiTIqJo3x4L13IE/e3Ur95IPXr58
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR0102MB3481
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reduce ksmbd smbdirect max segment send and receive size to 1364
to match protocol norms. Larger buffers are unnecessary and add
significant memory overhead.

Signed-off-by: Tom Talpey <tom@talpey.com>
---
 fs/ksmbd/transport_rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 494b8e5af4b3..0315bca3d53b 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -62,13 +62,13 @@ static int smb_direct_receive_credit_max = 255;
 static int smb_direct_send_credit_target = 255;
 
 /* The maximum single message size can be sent to remote peer */
-static int smb_direct_max_send_size = 8192;
+static int smb_direct_max_send_size = 1364;
 
 /*  The maximum fragmented upper-layer payload receive size supported */
 static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
 
 /*  The maximum single-message size which can be received */
-static int smb_direct_max_receive_size = 8192;
+static int smb_direct_max_receive_size = 1364;
 
 static int smb_direct_max_read_write_size = SMBD_DEFAULT_IOSIZE;
 
-- 
2.34.1

