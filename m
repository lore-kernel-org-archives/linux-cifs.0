Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434B7C38A02
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 10:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbiJ1KxE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 06:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiJ1Kw6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 06:52:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A0696213
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 03:52:57 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29S9YvHw021128;
        Fri, 28 Oct 2022 10:52:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=dn8N/t/U/6SgkTN54z5WccWwAGi+VskSBTijj6qW8WM=;
 b=Z3j7mmip+my60O1qjW9icrwgrIGw3nnW0PMuSkFLf366Nm744lRco7+kzxtMDBgu0wGp
 DczJk5WQG/RSfr17n0OwiEWOeAp3/LiwEZDGpUJFyZjTSOwIusdolCG4Rrt1bW1A31dH
 joApD6HVNGaZ7I6uIAOX4t16WAvE1U5fniQ3p5j3b8L1m3wjQ9bZgyvcp8sP/TP8DBsq
 w7iEJ1iHfuJz26Nlbm3pj9VuArG/45CT9z04YqwyP8z40sCwT2txXhDSBM1yAVEpHnZV
 QlVcUbUKnoXcZI7+ghLjB2jACdPQz6ykgMZscMvRRXDJiMjkWGuFbEcSxoV/idK9O2kP 3Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfagv4t0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 10:52:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29S9xWm8026273;
        Fri, 28 Oct 2022 10:52:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagr00q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 10:52:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1zQKhGYsNHu5GrgIV+jPWsQsmJcTuy72wjuv6vJuGWC6HJNG9snkhh/QZg6EJn/CzIgGmJLW1TpkdOGfLnJsrQUry/OfhfjF1baIT2SPSJJI+oJrkRQcSkzBlFjQQRq2FUQtDka69tSOs9x2O+3L2kqxxTuFdqqWq0gW+4E0AuCq/YbMqTTa8O7/8U26hxarMSQQu6aujMZrM6h8fpnNgxyOJiLvaqDnC4xv/3gS2PyGAZzWd0Qyu0smSJ2HN/YZ60rWx7x7zSy4foq04WId0HhxLsKaxJWOjHFFNa/9biiGuYdEIHdsOt1DrwH7909nMgPxbqR61hrcf8DOF3TMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dn8N/t/U/6SgkTN54z5WccWwAGi+VskSBTijj6qW8WM=;
 b=gUBIbVG1ZixYJdzvSCMEtdvQ3D9B+Xv3R2VuTHORM4ZjD55fxAj2EtsmfCUQp64Xo89MYk46JPEJ0LTCsVGc1ZBUou0unoT+ntt+juy4ZosCPmAF7jsVr5lN37bl0KAjzwNun1faBOLjy033eSiHud8k3h1zBPh1Aoig/B8CTj02o+THByrktEdc9WxzbStBpKsqLWqXfn75YIWRZWHdF1OYPQiCBWFIsIk7Jjg/RsVLVufKhKFEMmaqVNI2D6xVmbGJVAEuiqefyFxN/4iJnyknFcPkpbdDxpwzwxefhRTQuNxi60Kz2ovW3Li10a1s2Rxe+yNJ8s5Fiz+cSjJ2aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dn8N/t/U/6SgkTN54z5WccWwAGi+VskSBTijj6qW8WM=;
 b=xN/6otgvr4cMNKlxbsCpKxN81pXM6OJMIKySQDDRTKf048f+0VUlC/A20AS/vCiLO6bUN3AM49qFnWZeNAFbUJX/1eFkmo2Z3ebPV6IdSGrx9P5OKe7WbO5PFHSFVhpHhaCn4LmTHdYcMSScaLCfQVdloSYsmqvUjipg2kb5rdE=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH2PR10MB4182.namprd10.prod.outlook.com
 (2603:10b6:610:7a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 10:52:51 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e%7]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 10:52:50 +0000
Date:   Fri, 28 Oct 2022 13:52:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christian Brauner <brauner@kernel.org>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [bug report] cifs: implement set acl method
Message-ID: <Y1u0dezFmP7K6baS@kadam>
References: <Y1uxJVwln0+gTaFz@kili>
 <20221028104916.cwrghgnjy7ocjeju@wittgenstein>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028104916.cwrghgnjy7ocjeju@wittgenstein>
X-ClientProxiedBy: JN2P275CA0011.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::23)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|CH2PR10MB4182:EE_
X-MS-Office365-Filtering-Correlation-Id: bd0de279-9f8e-40d0-afe0-08dab8d28efe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YhwQLzsZkbTCwiqv+W/MqjaCPVmJ669U6FJn17hvET15zdMjERlb3wNV9uDnpaoG4o6Nsmse818jbdGNVWV8i6rMFKHjH2vtQVshNC63eFukS0+dauuGZHdIM9uzwVSg5Ml6ureH0JMsNIkKeHVby7Gq8z7PSURXHg5UWqlj+HF0O9msKA0azN7f1J4Tt7mu3wH4dU552UH7QuHlljIRNsNDmxfq9IXMjduDtJE4KrkNoDQQM7YKQZLMssMH7VKlso8+eaISW+9H+NJ0hVonWbitqnibG3nAVbYqTmo/Y4FDDW4dQhcQo3esp95KH92zPcJ9jAKKOhFvI6F+rVE8ACt9RT3UZpsXqINyQUHbgePkPTDbQ5yGbnoiZfnzRwooTt0IxgHisw8pjvczYQtBm9TXONo65gDjnbzK5vPzhH1G3lGXzRO5ipLt0Y0oVw7gdcq00o3Kih5zgMBrTLGEOWr3kDGSt6MyWjbQPsWvLjVgQaphFige7zS4SMebKjPCJ4w1jDnRUL6zV5xcdqW1Xuy4KFByFoPSqhIJGiHMRAY4ticByk8enRI03HJf0AJyIiHAchrJCvTy4jDbd/yHAlgG58JWjb5QljbR/InOJD3E+xxzpUdJFJRevMDK/t172+u7APda73s143kKzyk3v4z8KlWdOIhj8ckzeTSFhHNURix3CIeFO2ma+7ntsGkfD5+pdmYis0flAQLkDf03Tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(39860400002)(346002)(396003)(366004)(136003)(451199015)(86362001)(38100700002)(4744005)(5660300002)(44832011)(2906002)(66946007)(66556008)(66476007)(8676002)(4326008)(41300700001)(8936002)(33716001)(6506007)(26005)(6666004)(6512007)(9686003)(186003)(316002)(6916009)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tn6o5CeA6BCKIdmsLNAX2yqHHcDIj1Rr0EbfcX2o3TMUMU3MWSb7mYL0d7Ft?=
 =?us-ascii?Q?Bw0MvLgczl4gqE7NSO1RTa69er0d5n4GaCvX6LL3qzrHIfSNGKLKrlnxJ3et?=
 =?us-ascii?Q?NRZXCWO0x5DKJW3y4FhCAMYkNjuMZ8oOlRC4veU3hoaL96bThqvzjfDvw2Rq?=
 =?us-ascii?Q?hfKku4NkQq6zMrOzGNlcNb4/7tgBepWzI07+m2U5rmMiC1NB78W1tV1g9+cF?=
 =?us-ascii?Q?GLLwRrmO3tmsIqCf2serdcLdlcbCJwdXPMIv1JaHDfAsFBPZdfdvxgGtfJyq?=
 =?us-ascii?Q?I5F6kxZRJFCGWBcB+SEFaSnPz8Z5JRxJb2LwlqXlCVGAcWSbDthxCKoLoxLv?=
 =?us-ascii?Q?qYj3zQb+R+SrLwBBwSBwdRKyYzoBmW8mOQ4pFqp7v7pYqfM2Jn4j/YClif1/?=
 =?us-ascii?Q?99+pvrqsQRfqw06mdDHFpzYZnvITNvfnFxk9Fp1a2vW0e2vMbRHeubSAeid/?=
 =?us-ascii?Q?GN1wlfo7dfLK9CYtXqksLdORkLQCe0tzYkRnasBAShu1JvL/k63yqz0YT9ZS?=
 =?us-ascii?Q?SQU9jEYdxNPQgqD+5q9AofuiFd8hdyNw/h6ax9Mvvvwa5rPOsFPt4DwoU9W2?=
 =?us-ascii?Q?G8LSWUOJiTNu7dQurZ2dgnNru2VZshUHfUXgAVatDNGADbo2MXY2Kz/75anM?=
 =?us-ascii?Q?XnjJAJA2xY5up/BcjcQxXt1JwqE4Wb59QvMlsLq9BaJYuXvenCqfmhOhnRF8?=
 =?us-ascii?Q?shMAouM6wA5inTEcpf9DsvIq3n0YErJ4ldQKY/WhwdVq19CePmjTP9om2jrJ?=
 =?us-ascii?Q?b0lWGmKJlMega4E4bvIY8u7/onuR6hZkAOD8fuGNC8+5oyCVpi/N679RxWmC?=
 =?us-ascii?Q?jCvy7JzdLySMfCuEzgrcc3KV2VhD9ZlC6wsGPnIE+4hjM3MKU8iOMoczMjFg?=
 =?us-ascii?Q?/H6h+WXjEHrIyr4Y0jxCn0YtcLC//Upl5Qoz+B94DfUV4TVdls5EqpfGswNV?=
 =?us-ascii?Q?4lo/X018YenYaFISsnnhRdvhRg+mGWpl+JWa04G8zoV4+ea7WzEjNYUarihI?=
 =?us-ascii?Q?AcdIYnbh6Dl+UnwgeNBSbnyXyaZn5LCzN+knVmQ8s58zz77FhH3f12bTkjcI?=
 =?us-ascii?Q?Jiv6POzh3kToqJ/ApGfnWJ7MOH2Aj53T/7DBJO9w28IqpVLm/htUSRmMOZQr?=
 =?us-ascii?Q?03gHrSLB91PJ5WgiS6ruXZi0wIROJLvo3TItbrAcj3So18fzKTpSNOl7/t4g?=
 =?us-ascii?Q?zGZTKh0fucdbzcFBmuIPWOTx7rKkdvrW7E8ZErHCkLIPVmRajBOwEQzJmYKT?=
 =?us-ascii?Q?4ij/J71rnkD9seUpe+BhxkLZVkOvSrTb/HCHJ39Gp6I0kcwJeBzXGpz26i4F?=
 =?us-ascii?Q?VuEj5NYCaS+l1feFjx5wa+hBYWqX6TMscYtwwepRf8MnXGiWScnoc4qSNGlg?=
 =?us-ascii?Q?Z8h3c2yGZZ4wd2fZxzPYDzN6hvmrWblbrb7X//TK6B+LoI7zigMyHls7LUNf?=
 =?us-ascii?Q?wGODBrUvOiEbQVxGNj0OQqEjoKVqTtvo2A+9KvqFaCLj+g0gQEwWRlca+eck?=
 =?us-ascii?Q?u66tqhzcbLcAMG2AM3EyB8qT5ODjdO1d2CiRb5QVW1ywKkmm46ueQztz6bX6?=
 =?us-ascii?Q?D3hnFCF1LBzMQrW5ak94hwQHgSgcOsLHNCkjkDe5ZcV0M1zlR0lxln6Vfb1V?=
 =?us-ascii?Q?mw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd0de279-9f8e-40d0-afe0-08dab8d28efe
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 10:52:50.9138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xtgr2fQ71h2mCo7Gjmkn+mEOTvm2YNNW6e85k/RKNYEV8ypbrQZbXz8C80YnIc3r6+Tu/0hfrH5Cv7PR6zz3u02nV5EqQvg8FuHzvYF/stM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4182
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_05,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210280067
X-Proofpoint-ORIG-GUID: 3lB4fd-GHtbYYCsloQH1RbjRD0ksk8BE
X-Proofpoint-GUID: 3lB4fd-GHtbYYCsloQH1RbjRD0ksk8BE
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Oct 28, 2022 at 12:49:16PM +0200, Christian Brauner wrote:
> On Fri, Oct 28, 2022 at 01:38:29PM +0300, Dan Carpenter wrote:
> > 
> > regards,
> > dan carpenter
> 
> Thanks for the report, Dan. I added the following fix on top. If that
> work out I'll likely fold it into the original commit though given that
> we're very still pre -rc4:
> 

Sounds good.  Thanks!

regards,
dan carpenter

