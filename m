Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B72C07E9D
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Sep 2022 21:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiIWVyg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Sep 2022 17:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIWVyf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Sep 2022 17:54:35 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C7326EA
        for <linux-cifs@vger.kernel.org>; Fri, 23 Sep 2022 14:54:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AKCC3Th69AEorOv37Z8cpFDEpusIUwMlzzshBKFEdFqBefj7xlSL5HQkx8kudjRyahcRL6wTrRe7jgdS8KpfK3ZvLraITSkJxemEP4DVipIv+nqBW0DrQNue4ESFS3ku7kwEzh64dqpxfrn7GBv9nPMlvz0XuvbI9z9Pk6BxDGYvpxoVNX0P/xW5ssL8+utSncdfLpH1mxfVrGbISKMAvkEa7HjkzGV4t2Seiyxl89OV5oDwyB8KzC0qvaM/Hk4X8xa2ca8rsOo/bfcqqRSOXeJPp6yllcbAW38iQ+YNft4QSJrZ/pg7S8awNNxz4Z/jan+PJb78BE1aJNtXYGjxyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A1iSrmnBcqlokubU+hMlHCetYuRQmPIKMhO72f3H74s=;
 b=LrKOCk93bDdaED+OINz4ZUABpxmvtHFjaaDQMBVHleWAGe+n2aW0Uen6S+YC2gZapWHZFwdfZo//5npcUIHdj4PbXPwaCzkDfP1C8OG8U0ty1TAdfn38Htd5w9ETCQl7FcgJZAbh5cSNbxHan+lCdz8drLfpjd6HOSg4LlgDkEk22u1IKpaVqZ3eAsNgIzmkjyzwX9tF0wE68so5F2IcrZlN08GJejMMwKrVKTH9RZp32s8q4uxj5uyFTz2u8awgO2lV2mT1RZ14D2Vu0dRzbr09hsfYrxIwDtqU2BCO26JtE8+SrT7JM61duHMbn1xGs95TpNUO1XGOCWY7IQ9muQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MW2PR0102MB3481.prod.exchangelabs.com (2603:10b6:302:5::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.16; Fri, 23 Sep 2022 21:54:20 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0%3]) with mapi id 15.20.5654.014; Fri, 23 Sep 2022
 21:54:20 +0000
From:   Tom Talpey <tom@talpey.com>
To:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, senozhatsky@chromium.org,
        bmt@zurich.ibm.com, longli@microsoft.com, dhowells@redhat.com,
        Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 0/6] Reduce SMBDirect RDMA SGE counts and sizes
Date:   Fri, 23 Sep 2022 21:53:54 +0000
Message-Id: <cover.1663961449.git.tom@talpey.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: BL1PR13CA0074.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::19) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|MW2PR0102MB3481:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d6ee08e-1206-44e7-fc9c-08da9dae2b4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6McRaqNQ+qDzvJcliWtbcEeZB9eyH3PFmSpFJXzofW9u0OOVR6Zk0K8akfgY9fXVtoMWk7m9/COaC6CfqCUJKH7SSVPY9X9oi6pjRMth2zRiFXD5XvyweKzRaVwr2TFVRasFOXfHHgZZSjxsi2HwiXMKV7WhSv0WRQ3bgiR82OUYd2LIRKSPZdAK7O1UnOSpFgFlvO+NRS2jARAOjPJtosTGdnEzsqLOsiXx1aTJDN8ILhx6YH0qbjcEc+6rEf6y7/IAqut8p7TldYWGbjAItgVr4K49UhpsJWf/LT3RovdNiOJke1vsMgT42DxJNb+TnLngifX+AZrpb2tz+hvrQQVcDd/xuRKsK2Xx4SCjfgYeQQdNZb+Rwl9MKNlfACh+yFnKPBolPdAxxTWocbBmrnF3s6cR2eaqeydhdSgwcGukuCaxq9cyN3YE5MkBfS/hk4lAeScvjN7KM3aNXXZp0l4MCBuGJBILncsL8lR8ygB3A8ZanwaexvwUOYaa8zk7bg9/GqLYmN9hJklKY7rZ0HBCfy3ArmU7SQWeFSZ8M+iNbokTH6OmM4cWU+if7KBTDg6r92RQ8AAnAjldlDbI0vtLvsz4eMFcjzqn3obY4QJDHQ3Yn4smv2Y63mRm59+WIUKvuTu3JuP+zzpvz9JMtR9ip0cG35SUS467j+VuJ9SH5ai6BVwbGsv74Mmw1IP/1PmrIwNMtA9YtKtXsJ539sxY+TIN6OZjLMEQbA5c4qwILE6NddvXDDqjaPc/faet
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(366004)(39830400003)(136003)(451199015)(8936002)(38100700002)(41300700001)(66556008)(8676002)(38350700002)(66946007)(66476007)(36756003)(5660300002)(2906002)(26005)(6512007)(6506007)(52116002)(4326008)(186003)(478600001)(6486002)(107886003)(6666004)(2616005)(316002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?igj+YVMOfNV64SJ27MDF9for4MAAaUC+58G6MtW7iG9xal2lrVXPA85aZMfN?=
 =?us-ascii?Q?XNE3gDxA43CGgnwhjAfM4eYJjL6crlQ2npLL+1uIcgd6gIn5UkQHkTy8nMbc?=
 =?us-ascii?Q?vg/dmWQKML2EEP2Vo/hRpMFh+AgTbkmWav8/zFro4O8kfDcfXPcqfcQtjX8w?=
 =?us-ascii?Q?ldcFnTePqpgqYE6MOAvVJmXUqiHPhYjJaqkGNgal5pZxkpFYHLkSTW3NIxn2?=
 =?us-ascii?Q?JgWEQIsB9XDy3QM3ai01agiT+iq67qAicFNrPZVPsohQjMael16eR5dlK0iE?=
 =?us-ascii?Q?16v9zDSrQprk45lLvSbTJDWdDHMRp21vfxqaCmMj32m1UwqOXwzsUvFkhP5G?=
 =?us-ascii?Q?Y4kUJd9PUBMveIY0eUXRQE8WLg8iIROOMOxNNODDpLJ/Ps6chZAGqrMgoqHI?=
 =?us-ascii?Q?0T193yPwk5b3++g7bAMPFRaOEFKX2p91cPUuY7ZqBJE/vcPru03e7WmrKQcB?=
 =?us-ascii?Q?YGqbc3d7poz7vgxgJbqk9sihWmKbVjlb8fzPbA40t6hVExB4Dh8KxYWHx1/p?=
 =?us-ascii?Q?j6WLkcOaj69/xiLhUAWzdI07ehyRrk8eMw3p2aGBC5FYVfPIUIYAh5h1monm?=
 =?us-ascii?Q?ktosxS/9T0m6cdZYaKLkQ2q1g0iaWOiIEhohNj5IHwSdJSgddsBAtkKQz6p/?=
 =?us-ascii?Q?XobEt7wgRn7TblmaTxi5nApo2aJnXm3c/Hj1KnH04munVKa1bIGbll0tsQVf?=
 =?us-ascii?Q?ymPyMYVYu3dSk6KnCaPZgLg7lvhfRzROYkLeGwaCd86ncyhf4jlGByQYFREn?=
 =?us-ascii?Q?z0MNzZdaQTgfDk/qL//sZHZyDRPFbJnDBlT5iFy0JZ5NXEySLpPANdcPk88Z?=
 =?us-ascii?Q?xTrmeO894Gfs7/KiGMQ38SBr9jTlR3B5mxQviwlXhE+80efXeV9IfhDeSEKV?=
 =?us-ascii?Q?vKD3+/FRO54N7rCt3fK4FmRkmMwjW/u/efE3aoQbobLzv066phYHquRZUuQ0?=
 =?us-ascii?Q?fD6Tbjb+u9G+3Xf6CxoCIfSE1i588VJ0Pxk0J3Sxf/IETjXB82TukLPsX/m+?=
 =?us-ascii?Q?i/zKTyDcpID75CfKdIwQlfCxTt0c92voWOI9xBEuPBt2Q57wHMlw7Puh28Ng?=
 =?us-ascii?Q?1didSpIeQ5AMV6/KRWDT15/ScwRNXw8nhb73dpwrqMxlMUpC4fu/kq4lvMon?=
 =?us-ascii?Q?S+gPy/7cOLIoCx8NZk+ETwWZQvZQuwo0wvxtxDAr4b1xqZ6SUpVOg8xHD+rD?=
 =?us-ascii?Q?hZ9n2gsmCw7eSR3F5OtDyH3TLfFDMZEZ4OPEE+e1nIbpNgWjj5Eig/Da/Fgs?=
 =?us-ascii?Q?z8/acZdOz2sbjacVXUJ0aUlFRrjDAZ0xCjY2L3B3Sya/AxVTxdX8gsgau6OR?=
 =?us-ascii?Q?oZRXX0n0912CTgJr7Bcqjt8UKblh50KW4SZXvSqmRrZ4y2cMAM2+9ZC1i3C6?=
 =?us-ascii?Q?e4VnALIk3sqzyYFCROdeGx7ypUOuxJVSp23BiWL9hsij+NtfwWJ7pYiR77a0?=
 =?us-ascii?Q?vT2x2OUUqvqwgo3MbBwyvXabDPpkkuoTe2CFfUdfRrQ6PrMx7t5OEmW8sKoh?=
 =?us-ascii?Q?zeLjSBX/+ypjRs9NS+tyBEO+RZAfOO7Ti9/U4ROhoTvbIktokw0NdM+1vQlf?=
 =?us-ascii?Q?ZhjyBpU1KXk90Puc9ObRnbg+ag21lKfZNIFmh/sb?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d6ee08e-1206-44e7-fc9c-08da9dae2b4f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:54:20.4910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BNJ/HaiBIj5qbayZlKh462OhmD6I9mzWociihr6WNlq2FORzUluF7QrfBmhE5Mdp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR0102MB3481
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Allocate fewer SGEs and standard packet sizes in both kernel SMBDirect
implementations.

The current maximum values (16 SGEs and 8192 bytes) cause failures on the
SoftiWARP provider, and are suboptimal on others. Reduce these to 6 and
1364. Additionally, recode smbd_send() to work with as few as 2 SGEs,
and for debug sanity, reformat client-side logging to more clearly show
addresses, lengths and flags in the appropriate base.

Tested over SoftiWARP and SoftRoCE with shell, Connectathon basic and general.

v2: correct an uninitialized value issue found by Coverity

Tom Talpey (6):
  Decrease the number of SMB3 smbdirect client SGEs
  Decrease the number of SMB3 smbdirect server SGEs
  Reduce client smbdirect max receive segment size
  Reduce server smbdirect max send/receive segment sizes
  Handle variable number of SGEs in client smbdirect send.
  Fix formatting of client smbdirect RDMA logging

 fs/cifs/smbdirect.c       | 227 ++++++++++++++++----------------------
 fs/cifs/smbdirect.h       |  14 ++-
 fs/ksmbd/transport_rdma.c |   6 +-
 3 files changed, 109 insertions(+), 138 deletions(-)

-- 
2.34.1

