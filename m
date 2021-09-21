Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82CD2C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 20:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6592760F4C
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 20:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbhIUUiF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 16:38:05 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25992 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234921AbhIUUiE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Sep 2021 16:38:04 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18LJIqrE011115
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 20:36:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=FPg3EzKhP9eiAK4EOHGVDBpAEEjxZp1gaE9c7FGhAR0=;
 b=BehBkNEbGeFWAKmtGdQCa0Za4IBGZa7Kkn0dvCKEdtWrom3Ta6RmLi31Yz4Q8VGMp4JD
 xJ0K6FgFAIbipQZaNEelFMPOOrxZHkJCozzwlThQ+rYJwxeCouG7WvJv5C58IPm7Z0/v
 02foFWB2mvvCkVXEMfSZQnwcyxSkOT0CvzX7L+U5KCNOC/NcebTnSz6ZpjiZBK0rtbji
 SOGD4KINrQJQXJdzlhaAfR95qdTUnDB4stNqc7u18WPPoR5qCeJoV4Q38LoDJEs0z1wY
 0wjLj7AT4Ec49IndGA8LSYUQYFF1aEC/sVlTF1IKanzEWM493mE8K4//eS4mMKZTB3rQ 1w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b78fwm36p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 20:36:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18LKUoRn012300
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 20:36:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3020.oracle.com with ESMTP id 3b57x6266t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 20:36:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lt6+NnjW46uskOhOQNu4DrFEnRsfM3Eg8zIFs8/Y4HUmzUKaiFSTvxhBpVMPbbUMm1s2ZUjAl/l7ofqi5iblHUePT7H0qWthChyjACe2Udrcigpk4LhnZ0bc421eRfrA3vIGmhvtFwyxM0gFtlgCxORtyrfz+dd4+0q2SnU/hqdW24ddOP9CIH6MuXzV5ONoBoZbsytp9sX/7mdQhwjwOW0nksJ7Noy5Riv9PrQGK7HZH1FepQEFEYdeLbI65HFKeH8ivPzOasDPav+b0ICGKjYpc38qgdl/Q1TqzX6J93limD3QZZ7DBJBUi5dfK0dgxXgHEJ/TyRYRBoMZvYD2tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=FPg3EzKhP9eiAK4EOHGVDBpAEEjxZp1gaE9c7FGhAR0=;
 b=GOYk7UseNNXflg+0ddPlf5qtlbw8FO0MfjKXF1tB53dkuScG1LI0O1AyO47U3xlKEW9wKjqOB2c5ov3Kn96H7TVJ96Dy5Aira5pp9i7TB8/jaCgGwoe/pbVNxBgMhhxYWBjSYLi4lthj6qVW9jvt6LTGKBIJ2ZiFSTCoOJX39z7DtSxJFTsq+53tNnT9JO/u9BbHrdB6X8E+VOtwzurlqmTHH1bbu4LzIf74F7EfwsWjUo1AHIIiuSt7dtl9OaFcaAk1FMC0+RGvyFnDKrAObicGL8M9xtW4fHZq6OSr9dcdS1oOcRhFmmrZAhr9RL5Tpy2k2TZl7bgyrEJj41mO+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPg3EzKhP9eiAK4EOHGVDBpAEEjxZp1gaE9c7FGhAR0=;
 b=ChLTHUlxYZGe9KhTrYbX6nl3cUaA2u//RdG5AizhObUl+Xmc4Q+FH1vkcbihIAhQrx1aTHAkvFikUV6iVD6PRzNMx5wCGOmXtqdLutyVQqUwjsCFXct2TOdIfAQUYtixM6X5z3imJY5hnXWb58RcP3i1SR3in3sRoHyr1FW1CEA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4724.namprd10.prod.outlook.com
 (2603:10b6:303:96::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 21 Sep
 2021 20:36:11 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4523.018; Tue, 21 Sep 2021
 20:36:11 +0000
Date:   Tue, 21 Sep 2021 23:36:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     linux-cifs@vger.kernel.org
Subject: [bug report] CIFS: Migrate to shared superblock model
Message-ID: <20210921203600.GC16529@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0044.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::13) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by ZR0P278CA0044.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Tue, 21 Sep 2021 20:36:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6904cf1c-3021-4509-6a9c-08d97d3f7286
X-MS-TrafficTypeDiagnostic: CO1PR10MB4724:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4724A674EF8C3B942CE799798EA19@CO1PR10MB4724.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hYZLQIWsG85tPkCTJ3l0LNTF3fIc9fvn09raE/9FVraws3W9W9gib5Qs0prnLd0TwbgHLW855KCUpyPhNkN9LSCNNVj3LPqeggcykjiYxfgCphICosWLl4iMY3dyRPJm/6cVGV50UQ+WjIjPnp3aBd/WdIhEbrIIieCbLBUVVeDoDiK6p5zoqJW2Utjk2oP1Wief330Q5emdQBf/OBBbfZz6YXb4xJtOor5YLLyhsQ3o0VVseKh35w6Xg1v6RFVmabcsLASEGTr1AkPi2FZAPllHqTFO/mmkgei65tlpkztXCuyjueJXq1BnaeRPgs/Km5DVRiPeAqZdhNkyoLBDmwNjXgffdSq1QUwkIF1icxcgoJ7KESmRqmIAFElwJn3YBXvBE+olaXEQz9ryjAIWdIw8hTi7fhsI+b9uVNw6GWO+bGrnveM1k+VYfonb4ORR/qvZI5QqM6op2ttZ4F/jUHoanlcQAg5DEkrc0Edd/n8+2qXIYnqjgp9oG2dNuSaSy54D71mCiZbrsSULr2iPqxXvJeDRhf0uNx11buWAKeWEMI2XsVX5LtqDgsvPBsXiJHG5Dwt4dqfQeXBCfWrLIbEOcMVaelH/ILrqa/n5s1da2VNcUI9BfB+xIy869lNSvkENlV2qugTAiNyX2eAChDG/I/chbDYitOOvUg+c9QBhE8i8eSJbEA2UiZeW64RtfxElK8ZDCuV5RoO/pZxzsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(44832011)(33716001)(9576002)(316002)(38100700002)(38350700002)(2906002)(26005)(33656002)(83380400001)(1076003)(186003)(55016002)(5660300002)(9686003)(8676002)(6916009)(508600001)(6666004)(66476007)(52116002)(8936002)(66946007)(66556008)(86362001)(6496006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rpQxLciAih0xGJfhv3Bq2zI1MgjtNu9t0EPITxZeQz/WTn+rolRFWx97b4rS?=
 =?us-ascii?Q?q+mHuMjvu43r8XwDexwpCNu6rLzova/PviR0+NuMJAa9hYQnvCHd6yVhAg/l?=
 =?us-ascii?Q?V+vllNLkp4ag55GrdzRUWGrqK8ZW8PBwOnJr1uiryuriNvM7he0gdWjBeeGM?=
 =?us-ascii?Q?+yvr7Q3ExxlSY2KFqa5vTPJCycNvP61USACBCIaWIBpxTaWjYK025/k4a0mw?=
 =?us-ascii?Q?H8KoQ5LGcp7Z2Yo8IHy/oB3joOTGBojlR4A76HowRap+JIMU3YtBacKWos/s?=
 =?us-ascii?Q?OkiBD9moTu2Hjjk0Vv5S5jqKhhZx9oBcpIZdynQf3NAGoSnOBggFTsO/WPWB?=
 =?us-ascii?Q?eMrtDKnEepMmQWcGZ02NVS/AIuX+4CXZxnvN2cDXdxDnTZA1XHMA9wV+Pjj/?=
 =?us-ascii?Q?DcrTEelK7BmYxOKMaFXznouE2+nC7ms0uOymXiZNNIDXGOzqLYfs5yLp56cz?=
 =?us-ascii?Q?g3JOobH5WalVf1nnMrjjerHjwmAQz+ak6su2vQQmDpC55PEq+QFBNFaE4r6A?=
 =?us-ascii?Q?LA2mouB4uqaRQUHIEGcdMeefE3/2sMURBKFokCnMwCj+LSs2B0an6/xsS+/N?=
 =?us-ascii?Q?Y8tguadiqhmjI89DstwLSrBXiNuJTeFDriujwctkHuLku4LC56rnOoxu4qSv?=
 =?us-ascii?Q?KCVCOblAn9PaINTlaZ1yb+qzy8RA2bYbmk5DX3SetOKe04AAbeDR/HS2Pipw?=
 =?us-ascii?Q?kUtdAuMeNqRbrmr8KebQw/l7hwdlMSlAvLQ6xuTIiBtC+ui0ojqfVljLvJvF?=
 =?us-ascii?Q?fkEOnS06JuMIHYIZUvx/SG/Jd6F3zGB2f2lb6BgISC77qG82gX11P/GdNA1V?=
 =?us-ascii?Q?m7FOnkpnquiWcEBGMfrAvaT1i930U7wqpHHLabdVJ8S/+dawhv+iAdnmVg87?=
 =?us-ascii?Q?jQ8EnK/ns0Jgm2vfG+lC50w3Lw1aiHQWuRSMBhlGQ8if10YffwwMo5tl0VSj?=
 =?us-ascii?Q?8VSxqMTNtQiW9kjrrexaDsqJWdCJJm/U8B1YwbwguQFB4JRv6bJNq/Jqfc/V?=
 =?us-ascii?Q?Mc2tjt8SNnYyTThwmdJ1EFIRKtg4MG0fNOR5UmRWO0mDCvM5qcvUjfcPVgSC?=
 =?us-ascii?Q?xafZXGATa7kbG4sMjIH1NgcGmbw46mHkZRAnd/LVX5SGVf91Ayx3TBD4N6+h?=
 =?us-ascii?Q?mMPWAxcBLf/T56u2HU9aBscqiDSCS0QRc9VEhGbna4HbQ3sTXN3ut9lEa6I9?=
 =?us-ascii?Q?oS/ZfmL25sAi9wq2D5odYOW7mUwotlzzWKwJyXrqbNH8F4TBvrApnOJcMHG/?=
 =?us-ascii?Q?ugrowQ0Jkqi3MPdtilJWy5bsyWJXHS+mY/x6EafkBbkoI/8a2BhV5/H+Le8o?=
 =?us-ascii?Q?bGtVOecbNwd2InHgXlzwsTL/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6904cf1c-3021-4509-6a9c-08d97d3f7286
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 20:36:11.0257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p3h/IMPviy85Efsdie1S8DBpYLBb69vTjidBVPp20V/KYrDvyYctQ73wpBAmGEd8FujPq+/x3Ap77KPU5yB9xTIUpmmPFtbaGCED272ARh0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4724
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=556 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109210121
X-Proofpoint-GUID: jdcqCKSUiV1bfl5vpsPN5BZmUcKyMIjC
X-Proofpoint-ORIG-GUID: jdcqCKSUiV1bfl5vpsPN5BZmUcKyMIjC
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

[ Ancient code before of the rename ]

Hello Samba devs,

The patch 25c7f41e9234: "CIFS: Migrate to shared superblock model"
from May 26, 2011, leads to the following
Smatch static checker warning:

	fs/smbfs_client/connect.c:2392 cifs_match_super()
	warn: 'tlink' isn't an ERR_PTR

fs/smbfs_client/connect.c
    2377 int
    2378 cifs_match_super(struct super_block *sb, void *data)
    2379 {
    2380         struct cifs_mnt_data *mnt_data = (struct cifs_mnt_data *)data;
    2381         struct smb3_fs_context *ctx;
    2382         struct cifs_sb_info *cifs_sb;
    2383         struct TCP_Server_Info *tcp_srv;
    2384         struct cifs_ses *ses;
    2385         struct cifs_tcon *tcon;
    2386         struct tcon_link *tlink;
    2387         int rc = 0;
    2388 
    2389         spin_lock(&cifs_tcp_ses_lock);
    2390         cifs_sb = CIFS_SB(sb);
    2391         tlink = cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
--> 2392         if (IS_ERR(tlink)) {

cifs_sb_master_tlink() doesn't return error pointers.  Smatch thinks it
might return NULL though.  Hard to tell.  NULL would crash.

    2393                 spin_unlock(&cifs_tcp_ses_lock);
    2394                 return rc;
    2395         }
    2396         tcon = tlink_tcon(tlink);

regards,
dan carpenter
