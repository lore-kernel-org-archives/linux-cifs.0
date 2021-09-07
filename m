Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A99C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 10:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54C6A61103
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 10:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245415AbhIGKSr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Sep 2021 06:18:47 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:18124 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245377AbhIGKSq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Sep 2021 06:18:46 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1878gPr0014966;
        Tue, 7 Sep 2021 10:17:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=NBxp+cf0SWDkPb5AOJ3g9x8BT5NakeiQGWZ1hg6Mlf4=;
 b=iIFZdcAURqBhEbFOZwW+ZCXi3mvymjgTgcRn9cvkr3FL+XY7BJwdUqGHJqfW0xprVRXH
 K7gjde3o/yQIkO9eUyYzj3J7aFi5sQeu8rabVemlG6Ma9EvWIYPBPCGk9/0fGBby8eZw
 x7JVVqZ35JSskhBELkP1J8du8+jddcloklX+nrLa9tVI6UHeWxcVh4wFsLzJjc1exn0B
 RfpZ/MQqgb/R6eijFpwx0cRlRCQb+AiOnoAjwtYezZ+lmY7bG/bR5RUiBMmjhi1HMdsF
 PuAyI85kf5OfgIdyqa24yJhxlht6xsp56Ha+kBMQtJNatfKAiy3lhD25/BijtI0EHRo5 qA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=NBxp+cf0SWDkPb5AOJ3g9x8BT5NakeiQGWZ1hg6Mlf4=;
 b=GzjEk8jr83k7LaJ+U3JihB1QRhotH/ebVg2J5QiyFUxoksrcmCp336M99SDffcK5/VbV
 2yx5OuZ8ahQ7bLIUPHqUr+HkzWus/vQ2RQ2Hh4h8zXbIfofCOv9wBbWJNgdGX/6tBqUc
 DwY2cjBNniJShxprpzY6AwfxGyFHRtpflRo1jFLQJFQ5s8WzdTLAtHpeEPUpJ55ZjrEr
 vAI5BBKuz//e1XHSF+4+O6zziA1+l7kVcxpvmVDUaXOtQBUp7hONJMwGN11vzIkg68DL
 vrqkvJA7evfHPdALx5BiChxSXxQwnaSGSE/PcM+/rVPaRr3u1UxgWdeuT5dGIireefn/ FQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ax1de8rx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Sep 2021 10:17:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 187AG13P080116;
        Tue, 7 Sep 2021 10:17:25 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by aserp3020.oracle.com with ESMTP id 3av0m4atug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Sep 2021 10:17:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSxfEvAIuc2isgtmO+Z9Lk+Tq47khPLp8M91nGtmLeT+88es6VF6+ildXdzZ4U8JMrTQoSHmdg3fka8Fy2YH63wsPBF/3ctRQFlzuF487v4fCxGFDCwSYH8UUM/OsZUhTZ3PhQ2ragLAhtamDVnCtqO9Hg4P91cyAgtdElmNSDXD/U3ilbvzZkRBKx5Qlgdisd/wFLpZVxG5SbnymHL0rbjlaEktxQ49kEnUHFAJwuHijP49vIhXtFPg9AP548WSNODeDzGEkp0mtk0k+Ol4O7Ms40LbKSqRewo/Wb5IEB5zVydTRHVQnITZDjt+hS2VKOQVy1YNp4eDWhjQaySEeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=NBxp+cf0SWDkPb5AOJ3g9x8BT5NakeiQGWZ1hg6Mlf4=;
 b=S6KbGOsvgMAu2AMX/EU/D/3w9b28Fz24r2E1FpQ82niSFFM4CtG7tPInEXCAL8N5Wuv80DiLZYMwlIceuprrCkfWH8yFTQzi6orjCngEbPHsRZpRx8NtgG5ULFJk0wXo0fP5mlETzsViMcTuoyau8a4Z5V1jYnOaW6QYt8GqwfAvUcb3MQCDUg+9EXoqRhxF3z2vxbpz/9U+rsEop7YRcZ1JKJm4N9vPrIRqdD37raBDgv8ZH5QDUNRCisitKOBgCRpnqMDnGeJXDivkddG/+wGpq2iIVyKluNMWZYEZ9bImfdrV6zdnPtxV28O3dwfLHpUHkFpqJd4HmPgKGlT5sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBxp+cf0SWDkPb5AOJ3g9x8BT5NakeiQGWZ1hg6Mlf4=;
 b=WRmbqy7OwOVMNEipdMPcIwEAnoUBaSIAMQKq7tF2rS/X/Lvck/4DQHVzNZV/l/DOnFN+FgusBrzEikinFw8+sZ/pJjB7DHthQfimcYy7Np+BO+uV0zcJN6MkLjS0f7QythS4IX75G9lJaQwcj/Rv1ri1ZrgLG974NHw1zGwsMDM=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2400.namprd10.prod.outlook.com
 (2603:10b6:301:33::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Tue, 7 Sep
 2021 10:17:23 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 10:17:23 +0000
Date:   Tue, 7 Sep 2021 13:17:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ksmbd: remove unnecessary conditions
Message-ID: <20210907101705.GH1935@kadam>
References: <20210907073428.GD18254@kili>
 <YTcdbOgmB7758K+/@google.com>
 <20210907085430.GM1957@kadam>
 <YTcrA2U2n5QAUkt5@google.com>
 <20210907091411.GG1935@kadam>
 <YTc4ClL0EwuHsPXP@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTc4ClL0EwuHsPXP@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0014.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::26)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JN2P275CA0014.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Tue, 7 Sep 2021 10:17:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4676fccc-8895-46aa-8ca8-08d971e8ae9d
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2400:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2400A241A4F07D58E700CD918ED39@MWHPR1001MB2400.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2bb1k7H3/itzaN2iWdB1v1KlVi6zAk6mrnYe/XBCqEjPJGJ2VnNIvTis5/9sQ0C8s63tlSRDFtqaNPYEVI9p0SlSkprJQqTOx8zovbVTPIXzZPsTDhLC0UCghP/cLYC3K+5MA9W5fWLvLLCqJDguvoR0aJyjjI9cfSGPfwlJyzoHZ8xXOUhjbOnckk8oxEjusFn0GgZUka/+l6PkQnmAvL6XNXuZRWixEnqOo9AMFT1jMa5qHifz/mXIaPBQvUgPJr+6vgs1RrTA1iBsFe4VhDginItgNwLRrrU76T6qfgCyC8DkimUaWMQ4MnAgtTFUC1myy6VZ9rutffrQg6muw73npa+HPptDm+aceaOOeHNhzwBzOWrpsvnnPfuyJpVtgAO8eABP3/RUS9Qok9O1UoWZt9d7Kll4xRleBZn3Jm5OBy0G46aCtUuo0861FWi7DO03IIwAY/SkG+rzvhqME5lhkMF00OWXbCc6rwaQOEk6ZNk2ZWTtnq2VW0KdkSr9+895NBHqA3CVlsr+av+Hz3GD8B+oYXyN8PRFw7lWEGEYEe+bRKSYfQ9/ZBNw+5ccadNifhp3Df63k09U1PxYXNbGc8uFCbDTri6zyNowcwI8XliCxAu7UEpLAWn37cRYsw7AuxaE6BKAiOCQtRxk2vfDG3GlxeczfAV5oF7LQm4gNKU/UVJdriHYNxQQK/2YanrHT2rI/tQdMxBrKtXMzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(316002)(186003)(26005)(956004)(54906003)(2906002)(6916009)(5660300002)(4326008)(1076003)(33656002)(66946007)(55016002)(66556008)(9686003)(6666004)(66476007)(44832011)(86362001)(33716001)(9576002)(6496006)(38100700002)(38350700002)(52116002)(8676002)(83380400001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6r+eivDgt24zz3nrCT3cF53xXqRPtxUXnsKGitqmEBXQE4eE/kqGHux4IOb0?=
 =?us-ascii?Q?nFlLKjTpKeFG8SpxSKKT0niCW9ohkOXTTdHGcNTOsuVPDnApOb3mWrrSR4LA?=
 =?us-ascii?Q?Xf0qkNxxoSePjay9e19CEc94B15Fcv65XqO2BrDKj2EckVOz05hAtSr5a/RM?=
 =?us-ascii?Q?s9R2abRRSbhcEB6GZJDiOsyBK8XgkejUv9agLyC6eQiVS4AsFvANi3Ei7rsU?=
 =?us-ascii?Q?kU1roCHn+UWoVOERJCl+rjQjgrMtMIDGfPl++vGyuRWrhchB4YrCNa/GAZMq?=
 =?us-ascii?Q?r2m1MVVcX57/xdoAHQvwueJ/ETh91dsSaJhMei/SwaS1aska9yBTqItTEAvt?=
 =?us-ascii?Q?qY9KtZrw0e1t1CrDtPQY910rE7lXIhFshMJ5MTY2UpDUeDqJb3uhX/ZOmxz7?=
 =?us-ascii?Q?RIVTW9oztt9McaQgLyQNZWN5GFlein9NcI6A+NkG8WzcOeQm84HG+mFWs7lz?=
 =?us-ascii?Q?/unKdgNDx9+o8ErgebGBvnePGVit18WsaZUt5xWm0UxddEbEJvBDTDRqY+9k?=
 =?us-ascii?Q?VbkMRBmvKoEtHSqb/LvrzmYyLTeDTW/Iscb3elQEMTZZY9ZlBf7aOFLoDQZR?=
 =?us-ascii?Q?1HY371x4TEx1bhFezbwiazBDYff+KGN8HdDJgHYkVWyZ7Ae4t/dcVNNK0WLk?=
 =?us-ascii?Q?Dx/VLm9EyrxIrxLC4YXl43AeNBhy8vB0QjA9BmSkWXfiMiGMqoCVRibrzdwB?=
 =?us-ascii?Q?TKgPr64rLjxDizl6yUlcGZAZRh0kawz/AZaHlUXnq1hdJ1hfabZP8H5sIC4y?=
 =?us-ascii?Q?7BZ02CoQvI59ZHn3Hqp6BGfCQ9oWCvJvEyixn5Q86rgs0gNF2dU/GEz4OsaH?=
 =?us-ascii?Q?bYm0ucz2NuuDeUk46HQcXkGuYU30/PUkB16nAXTT+LEImi4h7EraxJvX2BGv?=
 =?us-ascii?Q?giOvse/n0V3ue5Z8ciRjGEGhd48n15yww3YItcJxBVMut1lOZFolFBuqDqcQ?=
 =?us-ascii?Q?SzPyvR2TTUZ6s/71B0sAbOY8FsUkiwIPzAJYFcX8UpQ/oHK2l4tCNcl+ImV/?=
 =?us-ascii?Q?0ycR010Xn/sAPEd++V6qEZIiHWQuNCqK4EXP0c3aj9vi+XXcO45r+ljNsaC+?=
 =?us-ascii?Q?Qz4hZcIlvow5/JET7TkkVstVE+RFmeK02j/kBufBL5VZ+oA4f8lRDGLLyczq?=
 =?us-ascii?Q?iWha09/WM2OrpGtkg/c9puA2tmvZG+EbdU3Qkf2oIU1L8BuDD3xkg7yQT7w1?=
 =?us-ascii?Q?7xndxewEgtpy4U1g005AMW1Q2IOsnNxAxKvV8nPo1Xp7jpi7C0M7VyNVU+Ji?=
 =?us-ascii?Q?g+u+Txwpq49/xLUUm8vg4A0YjjAWgTibJY42U0lPtbB9FIdzkjcLmd7w3X3Y?=
 =?us-ascii?Q?JRQXaHdhHsbSLhYeXpJV9lOl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4676fccc-8895-46aa-8ca8-08d971e8ae9d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 10:17:23.0085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a8OHc0G0s71B/mdNLd5HiGW0dOvsJMyBq7PUdIco0lG+20sEX5xlo3FQBCsG1nVtrs5GPb3ZEOSA5CwMiKfsCmrWurJzNSouM6C4tObMadU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2400
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10099 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=987 adultscore=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109070068
X-Proofpoint-GUID: GgrbKVLaeA_XFUpWy8upVKO2BT4iWflk
X-Proofpoint-ORIG-GUID: GgrbKVLaeA_XFUpWy8upVKO2BT4iWflk
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Sep 07, 2021 at 06:59:38PM +0900, Sergey Senozhatsky wrote:
> On (21/09/07 12:14), Dan Carpenter wrote:
> [..]
> > > > > 
> > > > > Can make_kuid() return INVALID_UID? IOW, uid_valid(uid) here as well?
> > > > 
> > > > No need to check twice.  We're going to check at the end.
> > > > 
> > > > > 
> > > > > > +
> > > > > > +		/* If this is an idmapped mount, apply the idmapping. */
> > > > > > +		uid = kuid_from_mnt(user_ns, uid);
> > > > > > +		if (uid_valid(uid)) {
> > > >                     ^^^^^^^^^^^^^^
> > > > The check here is sufficient.
> > > 
> > > My point was more that a potentially invalid UID is passed to kuid_from_mnt()
> > > and kgid_from_mnt(). I don't see map_id_up(), for example, checking that
> > > passed UID is valid. So decided to double check.
> > 
> > But you've seen it now, right?
> 
> A linear search in array of 5 elements or a binary search in array of 340
> elements? Yea, I saw it. I'd prefer one extra uid_valid(), if you'd ask
> me - why call the function if we already know that it'll fail.

It's a failure path.  Hopefully people will only give us valid data.

We would normally only optimize the failure path if we thought that it
could be used as a DoS vector.

regards,
dan carpenter
