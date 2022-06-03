Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 813E9C43334
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Jun 2022 07:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbiFCHhq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Jun 2022 03:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242591AbiFCHhd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Jun 2022 03:37:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A2A205F2;
        Fri,  3 Jun 2022 00:37:31 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2531DieB007640;
        Fri, 3 Jun 2022 07:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=DblxXmTbzqGNgKduvCDJx5BByFPD4UUzmb5F7BpowR4=;
 b=B/y38Xfa7aBN0fTJBRPfGlub2p4QzpyoGfUFw1yg6wpk0B4uAGvu2xgIbzBLrs7Ph5xY
 rW+fl5uxVfE7T4GD0kESFUuMERoQCXv6hzlT+ablzwvjX+wCL2dXfkn7J7aLxSg48Sg4
 lb5TBMePKK1oCQGIWYxRPZN648yQnBM/hw+hXaJ4o8VJUx5SeI7yq77bqv63/8zuN4PU
 G8oxbqzTEaJUIoj2VU7tsEjWURM5zSww+Vbcuco2VFEE5Yvn05YbwTZ/7I5r8dQGnkI1
 ONuRlKTXCkddikrzoY4m2qJyTU/yYb64wYY4fqfe3REpQtE1Hw4qaP/HWFvHbRNazCs6 yA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc4xva9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 07:37:15 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2537Vrp6036755;
        Fri, 3 Jun 2022 07:37:14 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gc8kjt51p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 07:37:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNazGILuQNa7zqraVl+KKi+ShnYIPifzrCeDb6SQ2MCa1ePEMn2C8WaXEA9XG/MYRnKqwsp0Erqy3Uh+aJNRm++Jsb67ZMd0rDAiEvx7o9Zx0GW2bksw85kU88kF/wt8RektayyGzzXeYYI0ShMhb4F1d4XHZBPO70eboykbGbFrw8Sx0+EXgoRkNDqF/y2X+nj1xP6xM7LRgCkn0J6wMnlcdmxUkGRfsPKcAekkRYSgb0GvCiQ+7jqLVcoLzBv5/B6W/BRUH/0qYYW5YEwq526CBXS9AfdZVDO+QmMdz3TAFVZblprLOU4DcwToEZBJPpGkbhF479aEuT1mhxeD+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DblxXmTbzqGNgKduvCDJx5BByFPD4UUzmb5F7BpowR4=;
 b=VXXLhTdMinrNgllpfWZ2NZwsudKDj9Tiraw/brBLAzhbPuYqUDb0KM1wFK3v7tHxNrk6MPFZatg8tY1NOTYilt9OdtgHwOGQbEdWDSxctLGUenEHroZY25WeGKaGglOoWuKevXKbK8vjsedu5yKW4IeTbNwyrHJNFG08M68BNrs6VMpwM4ToabXxQNCCrFN9/LlzTRXwR9uI27RqGZExwhrHwV+dDRnYFQW3fIXAlgnDPMwcct1SwBiu0SCZkJl29DyqPJPieOv2ocKuXrjVGaLXR2hMbM9bJTnaPl1vjTXJtYZ8avdmVajvMUj80aMgnLhLmkFLxn6z6kqjvTnfAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DblxXmTbzqGNgKduvCDJx5BByFPD4UUzmb5F7BpowR4=;
 b=e1qXQF6SCqIzwBi9WVNcNIXMGJCNXKIAX5/F9TKe7A92mm9Qz3YCQzhaNDl4yjP63QgzmOAu8Jb2tZVApfO7qY0OOPGqkXQWL7yyzDSMwcK1kmAN+BulA7nLnRqLLvXxzE8wgVLEnP/KGc/erVPeY4P8WExiQyQ+0FVpCKf65hM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN0PR10MB4854.namprd10.prod.outlook.com
 (2603:10b6:408:123::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Fri, 3 Jun
 2022 07:37:11 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5314.015; Fri, 3 Jun 2022
 07:37:11 +0000
Date:   Fri, 3 Jun 2022 10:36:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Steve French <sfrench@samba.org>, Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ksmbd: clean up a type in ksmbd_vfs_stream_write()
Message-ID: <20220603073651.GM2168@kadam>
References: <YpiWS/WQr2qMidvA@kili>
 <CAKYAXd_=x-uT8U_2tdbmVxbhyg_pDY03NKP9zzDwQZmm0TxQmg@mail.gmail.com>
 <20220603001021.GL2168@kadam>
 <CAKYAXd9zSCd5d9K2h9EvTbbXea1zMBcDU5Ryi6o5=GRGFQ97ag@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd9zSCd5d9K2h9EvTbbXea1zMBcDU5Ryi6o5=GRGFQ97ag@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0038.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::9)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 194ed5bd-2176-48d7-f598-08da4533deb8
X-MS-TrafficTypeDiagnostic: BN0PR10MB4854:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB4854AA9743FAA33F911C65B58EA19@BN0PR10MB4854.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QiSzTOSNZH1zctkkY9uEeNmIpTa1y0u1capUOPQCJhce9KoNf2zgjxkqKLC2ly8RHyw71D0Q3oRVaMxXBsyyjg4d2oyKoPEI9vZ4dxS8IKcW8mgzPZ8cOUArECefZJdlbYBhZT4J9W/MSo2QLixGAYt8cfwM9S3UBUk9pBra+QMq8y0MxNmLvpLCF/BP6JVPC4TiykbVW+RXS/kP3Q7oVOXs2aWqXc/gIsLFvQPgc7cRNwNCC8kq8h8jlJnANt+DUL1QlZmDKTzgp3Y9Mi5sxYxjElVKVqJl28rkC6k4Qe7cxDPNPpF04ZZFy+rIUuEElhvspnBddFnadDQkpUJREkD/E09enuuTDSSe18aoE0WOO+HBQ7vGqlJGct/ufrOiyArGkmGfDUU9+to/PSZzaHFFtJm3OdCHYhIVydF0+9tYsohSvmwUgA2izSJo3gwnltoDYyrZKQWKLKYfzgvQHufnBmrb9lJJwRe09mWK/0652nv+o3tZA0dVHCJ4RekCEeCOTrT4Z9INZECRAFq4qQZkflAJddidz1M0XG45UiP9KS6uBuX67ZpQ5HMGJjAD/83dwEuWYwLJy4nhWvFIsTBxO22Yl2Ieqr3cK7hdrVyutQGEISf4ZkUmcJSq1lyGY2Wvn90Suh3ZxE601xdA3f5toLURFXcGT71t0eDCMaW4jpfP3Hl5NkqbhiwEqqK3DapJrcY0RmaSMiNF/+DqtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6666004)(33716001)(1076003)(44832011)(6506007)(508600001)(26005)(9686003)(6512007)(186003)(86362001)(8936002)(66476007)(38100700002)(66946007)(33656002)(66556008)(5660300002)(4326008)(8676002)(38350700002)(54906003)(52116002)(316002)(2906002)(6916009)(83380400001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W+QrOs2FGFflEbul05QDykEkY9wVCe+quUaa3FFWCzU5YCk12KCF3Ph5oHvK?=
 =?us-ascii?Q?RA0/pYer3RCgp/0NFSyDSS4o7ZjSAg8eFPnun0lAWQr99hSeYRNR8TP6pYcI?=
 =?us-ascii?Q?L4v5DLg0why0S/A7FX0tbiC+a6UCpIfHLGVu6/6FFjCMVNTGuVOK+sOpk8vC?=
 =?us-ascii?Q?eczW2q6VaJUW1H1mZx01SkwOT0oscFw4esiP/wyOKKQ5TlELBBv6D1yAdOP6?=
 =?us-ascii?Q?Or1R6RwgxlrqOgRJVjO4oWCjTKp/YfWtUkjF/DP4sbeyuyqoEsi0bFZS63P1?=
 =?us-ascii?Q?Kg+vrm7CqZdXChUWq8GjeLeYoikgM7fwYKgHcVGIlWVbJpH/FcY1+UlLJjh/?=
 =?us-ascii?Q?xMGwF5uTG/13WVf0gcED/2MX6mHde5GdIGyuOVq48fpxO53e9vHMlbolDe7D?=
 =?us-ascii?Q?dmk2oSLxOXmJ5ugveq33WykqjnXZAEqbBhvaCB95DRJXpg6Vv382zGHPCFZ7?=
 =?us-ascii?Q?MLI+tAx0vEmPh9Mau6qoX6cdlphsO37aMreMEf5eF3H02d6cmR7awpWNLOS5?=
 =?us-ascii?Q?rJTBBCew7UXkN4hJ/G9/3v3CQ2N7Qv5N7vS74AZqDebD/ncciUUO0JA5NLMG?=
 =?us-ascii?Q?sWnL0DqKu8Ltm6Mzk8WeKOROQcP7RxzwQKHqtLS5o5zpFgeV6ZVfP0h0I49T?=
 =?us-ascii?Q?5jozmFqnB5fcLdMwLCFvaBuCu0O6qToDvWxc3k0Dxs3Ex+m6SwMybI38say7?=
 =?us-ascii?Q?T5vvdzBxt384lnrdXftYHLEM7ZRK1ywXaLknRw0bhT3gnpfeWVKROSBSRiBo?=
 =?us-ascii?Q?NrKrGPSIkXeZCO/6H22NuyjaW853ffz6CrPT/Vq8xz9UlMKgAHink/E0zN4c?=
 =?us-ascii?Q?VTcJGP1Gnq7b2QaqQJO5I4oXGlbeeyM6j2C8o6eBpUd8J6hY1wTt31FBQT8L?=
 =?us-ascii?Q?fctA787xLFyd5180yOFpayyn0awirCVmngHYeboFHpaYFqzkfutmH/3iyJEL?=
 =?us-ascii?Q?FCCuQvRj7vx63qZajwYDBL/lNq6/5IU1sUPzxLPl0If/gW8gJNDkmFk7qRbO?=
 =?us-ascii?Q?z1ial0RTOCppMLP9Wvz5qjU65jf02ClpR3z26pUyQ1EhxCddwftsno/i/DXN?=
 =?us-ascii?Q?utGEjZZYmZ88NZQFkHYQPp+kzUHAJdaKknyoy48nOCBBbFgY3UAsBWLfdbXN?=
 =?us-ascii?Q?El0tu4aXclXfPftTkaMG/lzckg4AIMHYgEASeOe2f6LoQiucToOQ/RF2RYjl?=
 =?us-ascii?Q?xgfaARA4Xq64vx/W1k3BXpzN2Fi0LXgAe0ZFkUoIRHxfksVWEp/7yyKCd76b?=
 =?us-ascii?Q?T5ex2CVwBTdkb3Gngr1F5WZGbSc4oqN1zCYuNY6/uHn6WnJMX3pn9O8zKBVk?=
 =?us-ascii?Q?q2zUcxLvc16dqF1mMQpPuEWbViMvYqNlfao468402z6FLIQHitzf/u4/1gUO?=
 =?us-ascii?Q?sjglGLCkAMvaY/hLyUxs4SfN/Wlz2SdlL2wJACZ1G2tKbtJa3tDv4APYHli/?=
 =?us-ascii?Q?lQyaZagYd+BaYDRQXk5+oGT080jxMyeb1JZub9aV8muwBkwYiMVYWYiBqXLt?=
 =?us-ascii?Q?5OhXCTda6cpwJlr0ikFI5n+PyOTB2ESHL1za1+8qb1A7YiUWNFIQPlOJOcE7?=
 =?us-ascii?Q?xiFWMQrgLJrkuX74GUFAqDCzd4OeRx3PaQyCkOPr9aODne3DE/VEncFQfSM4?=
 =?us-ascii?Q?Mp2FmDEaYltqJzX59oe2AtV0hPs28iNsgT5y25OvJUbALxOP1zn9ngODvcpC?=
 =?us-ascii?Q?wv/CMUhgj1pUVeoozeNktjg2QlziV6Zpv5uuupQ1M0QdOzQoeP3/ER6Pzo9K?=
 =?us-ascii?Q?35Y3zgjU4NkhfrLb4GjvDEiQDClxmE0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 194ed5bd-2176-48d7-f598-08da4533deb8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 07:37:11.1002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4y0uSAAOD8T2Jf1XMN3nATr9ZmYEcl6Xhpax3ew/inDFCTkryIcJrKRVNPde9VcTuiNFXF2E4DO3jmX/ZtTHqlMbch5+Z3/eSLp6UDBK68U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4854
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-03_02:2022-06-02,2022-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206030032
X-Proofpoint-GUID: t96XVP7PI5r4aUt6yLvLrljmgwdp_35R
X-Proofpoint-ORIG-GUID: t96XVP7PI5r4aUt6yLvLrljmgwdp_35R
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jun 03, 2022 at 09:45:21AM +0900, Namjae Jeon wrote:
> 2022-06-03 9:10 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> > On Fri, Jun 03, 2022 at 08:18:19AM +0900, Namjae Jeon wrote:
> >> 2022-06-02 19:51 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> >> > @@ -428,9 +429,9 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file
> >> > *fp,
> >> > char *buf, loff_t *pos,
> >> >  				       fp->stream.name,
> >> >  				       fp->stream.size,
> >> >  				       &stream_buf);
> >> > -	if ((int)v_len < 0) {
> >> > +	if (v_len < 0) {
> >> >  		pr_err("not found stream in xattr : %zd\n", v_len);
> >> > -		err = (int)v_len;
> >> > +		err = v_len;
> >> Data type of ssize_t is long. Wouldn't some static checker warn us
> >> that this is a problem?
> >
> > None that I know of.
> >
> > To a human reader, the cast isn't needed because when a function returns
> > ssize_t the negatives can only be error codes in the (-4095)-(-1) range.
> > No other negative sizes make sense.
> >
> > On the other hand, the "if ((int)v_len < 0) {" line really should
> > trigger a static checker because there are times when sizes could be
> > over 2GB.  I will write down that I need to create that checker.
> Okay, And there is a similar type casting in ksmbd_vfs_stream_read().
> Is it not necessary to change together?

The motivation for this change was that I was looking for places which
save negative error codes in a positive value.  Since the ksmbd_vfs_stream_read()
is using ssize_t then it didn't trigger that warning.  But
ksmbd_vfs_stream_read() has some minor issues.

	if ((int)v_len <= 0)
This cast is "buggy".  Harmless though.

		return (int)v_len;
This is fine, but unnecessary.

	if (v_len <= *pos) {
		count = -EINVAL;

I feel like this should return 0 bytes instead of -EINVAL;  It probably
doesn't matter.

I am going to try write a static checker that complains specifically
about casting size_t (not long) to int.  I will make it complain about
ssize_t as well, but that's kind of unusual because ssize_t can already
store negatives.

regards,
dan carpenter
