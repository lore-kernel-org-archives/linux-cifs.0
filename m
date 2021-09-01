Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1989C432BE
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Sep 2021 10:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB30960F6F
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Sep 2021 10:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbhIAKX4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Sep 2021 06:23:56 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5058 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231903AbhIAKX4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Sep 2021 06:23:56 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1819itFa016102;
        Wed, 1 Sep 2021 10:22:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=nJPhp50D4o/55pjLzTPKlyI+jfmBGXToBsj/GGCU/SI=;
 b=vW0go0s7LFkYltwRhdXubXMAaUB8G0M9GHIG0H1lNWag7GHIsqAWSi1elSiLHcb2VtSx
 A2iDGNn1kw1q+p9L7doE1BNwImaHbE/YSLqZ6EEC2N6WV69ZpOw1vfg8/v1YFmkEqa0V
 7S5LdXPtpQKrAk+LItKFoCMav0Q6ZWVgCpfUJupw4jkeLof6TAxAyx/+D28HEwjoG3JT
 lFtGNRUMpv/F24JSq/HbS6ZRdDcy6z2LVVKSDBbSuQik+N1S00J/XCX19f7ToLtLYiek
 YZxwibMxrfOJFAwqEFNk3KuwRFs9PaoQqGr7nN52Tz/1HWAGYxyw/JBTTp+rLKQOI0tx vA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=nJPhp50D4o/55pjLzTPKlyI+jfmBGXToBsj/GGCU/SI=;
 b=mSnmis2Vwu1cfEXqhzbFrv7x4jE5bnadWuZcmhE0glKtTmmp+fkQhVw2+GDSfpOWBjxb
 nNuJbcSW+N6b6HeSyWS7FGoMf7nBderYTkBZdkjYav4VAxa/GHwgyeYGVwXt+GiFWfgU
 UZi2Uv66P8VcKgslnNU0goMJS7QA92AuwNZVYEbXBgEUKNrmIJAOODgt2wPBMr7GNFyH
 Htl9IAnNZtNxQtAroBQs/jBZWxoWVtIvO0KRUdwdfNHatBkxOdECXFMWIaEmfwYF2lOt
 LZy6868/wN/2McuxJ6pwnmvMyQT81W1rNysj2FgHzMu5cijiJCFr9DIOqSP0HqdU3llv wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3asdn1vag3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Sep 2021 10:22:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 181AFmoN146296;
        Wed, 1 Sep 2021 10:22:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by aserp3030.oracle.com with ESMTP id 3aqb6fhqbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Sep 2021 10:22:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m5mZ8+kWqsiRoZiX9Lwqv0dsWaaIH1DjRYmD34S9tLBpjpSuVqRIFrMmei0pooLnciYo84PEqk0v/Kx3CObmauXGGJzy8bzGs3WQWm/BrcBhJ7F537ROD3vWSdyWE37v+nXa32tWPBgnhBocS/rqFkJvkg+rDVu5j9rQP2wuoVg/kQzvuDOHwXAbGyEAbuXProLnrs83vFDn9GBMGiuT/PQgU+lG2BIz7yoTy0FIutDhyAiQ9gKOtj88UzS6SuLakhJ918m3qMJHyhhOH1CI1uVH3hH4StVnRCInalaladwKovv6MP9ZYu2gJit9rCmlmp2Y3Tkq9Q1aldl3vBpsSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nJPhp50D4o/55pjLzTPKlyI+jfmBGXToBsj/GGCU/SI=;
 b=HxxuACmEDV2wNvREJlzSjSZBXHUpkUsrZocALGSyF7GRkUBxWLwuUDsmElSkirY0AM1Y7taPrCEtoX9XCuJpm2o9wrrGVfOgVhqBtjtnBsNHBae2aeDk/9lo5EJxyEYR3MXUPHIilEILWfPuKLxiREel990wciET40eTRhWp+CKQY2FmyI3Jn1toP6Y4bLD2jmDbqoKxE1GLyJ4f5Y7CS7kyje0UjThnCV0VbZfuhkFHNnycu3a7ZTSsO3E4axjJpT2oHzVig+9trfjEkgevljXtvAgvwrUHexeRrltovFiXaUCtoe0aZpYV+j0nhWyhqBKzCUw+7Xovy24hS6HhZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nJPhp50D4o/55pjLzTPKlyI+jfmBGXToBsj/GGCU/SI=;
 b=FrGN2/aUDxDUiLXMqL2lkDR10FPhU2P3YLzkxh82v1u88xdMAInM6eJHQFmlqTiA7M+hhuvUABrJfbA7de6mpqBLYWWrOB6rIasTemHic5ILObLRRKlj86uVEW+YvB8asU2PURodsxuJxweOc/AhO27OjB3dCsVm2/Z+Cyruy0w=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4643.namprd10.prod.outlook.com
 (2603:10b6:303:9c::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Wed, 1 Sep
 2021 10:22:55 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4478.019; Wed, 1 Sep 2021
 10:22:55 +0000
Date:   Wed, 1 Sep 2021 13:22:40 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [PATCH 3/4] ksmbd: add validation for ndr read/write functions
Message-ID: <20210901102240.GA2129@kadam>
References: <20210901004537.45511-1-linkinjeon@kernel.org>
 <20210901004537.45511-3-linkinjeon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901004537.45511-3-linkinjeon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0031.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::19)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JN2P275CA0031.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 10:22:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 751711cc-a9a4-4eb0-fb09-08d96d32766c
X-MS-TrafficTypeDiagnostic: CO1PR10MB4643:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB46431D421505E506253FD35F8ECD9@CO1PR10MB4643.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yyvBWiKzZRDSffRXBOZTWpCAxHWv3fTovNim+UxvWanaJAV19i6RjgE7EYTb17OvTEw4CFoUm8ekfeq+ta9h/jlwC5ntsiWhOXK5lyDriG15D111HmIFtv9NPv9+mKwB9+WTHeUCbaz+BVpvPq9DKpbws7Vfs7HCrbHiM4ADELL1wIk1h5C0jE/j4KoPsyQZ8ZZvQOHZlzlxGGE+z07XKXAo6ff4xr4HLomegYDq91nVrBAUqP6IMN4mtC6Bo0GWtMyuity/bivKoBzGdkR1DOTVm6EQ+U8MbStGuPnrMBI+GCLTHThagAXYxH6keeCJX9+FTJEVF7KoN3pJzkrC/CMZj9fzCDfBz7gl4WGLUK9tBkMhoF3/+n/fqqrYaTUGPVE/I7CIogo4t2IsJsPptm8c+wQYQIxm1XDBxx1pAs/yx/BcdNMV6GONpDQUq76enl65VuJn8lJCjwimxwV9vFJ+VP23z/poeSeLHS9ra9ygpEH67ihZgvOi8jT523MyWUDPyaCH4E5ck9z/Jgh5tFeREPvcOkvBeMBc5GVxdVKR96WLVyQaDcY2fyD7RgUYsRl/EmsH7zY+p8xNylwh31ZuDFUpHfD8JZaUU1TSssNvdlglVkXncrO5TgRXQPxH+sqLHzLgzmGT9QON/zg4JC8ZXC9Iz3y8GnuVwI/m+/8aE9HdoH5l1+1Ciazueg7WBCgHYETZw6/kMHHuoBcq9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(366004)(39860400002)(376002)(6916009)(86362001)(1076003)(956004)(8676002)(9576002)(44832011)(33656002)(6666004)(38100700002)(33716001)(316002)(4326008)(55016002)(478600001)(9686003)(2906002)(66946007)(6496006)(52116002)(66556008)(66476007)(38350700002)(4744005)(186003)(5660300002)(26005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BYLm6N2ZdktHFuYqyPu3zg0YKDAFD3ZCmZyWTFBKvmK9kvLOmO4aVYcRd4I1?=
 =?us-ascii?Q?zPtkKFzoEzpVK8qvXf6tUMVWxOW7e8t1VJpITyDrRDgVIpQa4Kru2MurA/zJ?=
 =?us-ascii?Q?Q1LwhZFhunVM/jk4mPXmT0XnCxkIC1SDC0HiOWLXI18si6g3uGMq/9SA6GOY?=
 =?us-ascii?Q?+n3IEzJtHpgIFiko5iUxg7+/4Ob9GnRkhFSkvcz14kgJFc3d3oJyrApqssrA?=
 =?us-ascii?Q?isArxLaZgI0zPF5FiU/eJdUvIQsAbJaVvVH2oMk2AM2+2Z1V1L47Y5decGU8?=
 =?us-ascii?Q?0xN4mx39GUmlgECxdIwoI7EvEc5ZZ7yGx/vsxqJS1sowYi/b013rzEKJxy/g?=
 =?us-ascii?Q?L4PzUmZWJLJYWNp1CiKNgKm0DODdbxLLltYdTln8bBcihozHoS6mozRf0tnh?=
 =?us-ascii?Q?3N7tvvJZ3p8wBI6VHAnad17lbdgIaORrEadaHo6P9mVvd8W36yloxbK/ZXhR?=
 =?us-ascii?Q?IrBERq8XRnkcKQMi8WKugMEVcb9/bj6ev6xi4oigsuGuZFiFPl9fq73Znzia?=
 =?us-ascii?Q?gZwYFpuFjpkkSqiPWi2Osyd1Q7FOq+dbz7726jg1JWiS+zDNodsgR7eeU6zF?=
 =?us-ascii?Q?MLTDJqffjp7uYZdUuuGQE9nGp6cY/aB9abm3IGDfHBunZAZ6XrosesucvM32?=
 =?us-ascii?Q?eoiWLeENUAIPNAvVK/basc/XNehU3KAQAXjytCYH9QurN22RC2ArVAzNZFfO?=
 =?us-ascii?Q?TzuTDk8hLtuHjL9KJPS+uuvWkjV/hH76xmPgb+97rMJV5MhtgLBHCmrfMoVM?=
 =?us-ascii?Q?1K/kp1SHjxERFWQmapr+4ctjTK+G/WJUdZZEBe+4zHr9XCt9llsUnsKVtVsR?=
 =?us-ascii?Q?O1FQNL3S+SSWDd7Q5pHsxGKD3khcvNlIvycijSBtX1dkrZnSpNDewA7Hkh2w?=
 =?us-ascii?Q?/B2Ikp0NuHzctpFJz54gwXo7XGxpTTaoyhoTpk9cYklERzZMQKyQGM2+AUsn?=
 =?us-ascii?Q?2aocjkayAsW8YGkv3nm6lAVHINFpi2xLcbQPbgdcgnI6PteY+4UXimKXC4na?=
 =?us-ascii?Q?F+3NahGaF9ZAEIwrqAQE2zq529nlGGz2HVNejJNno6vy1qoqPQ5HJ7M5nYaU?=
 =?us-ascii?Q?Aww1NLRf9lrCQiaZw42FMRaZvTrntnQkwGIYrUMIxSen/WnVqNzFY8ToPXua?=
 =?us-ascii?Q?lmBlC53EKbq8LBu9Qn+ltoofg1Ic2MD9G5kOomrsVxuzksqWyWX16RsXxO6Z?=
 =?us-ascii?Q?evm5PcxWjZcHzhP1mBv+gPeN2axiU9OYzMfNLOLB+e2X3KC4kg4ptcxtlsqR?=
 =?us-ascii?Q?AIhOjwGWUuAcvMeKhxUcI2RQ7p/5U+/KH2vPOFSDODgdv5zpLQIUJU3ZV+VZ?=
 =?us-ascii?Q?sxWAFp7ZyKUxBYi65Fnn47Kn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 751711cc-a9a4-4eb0-fb09-08d96d32766c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 10:22:55.3661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9g36+waAhi9lP7g/SolkeXdfdGA+cuj7W0TX8X8OLwjtZBdP6MMmT3aqOMJRrN0hl+xpvG1ercZUaABkrZnAcrJvcmWgkTU/Yt+3XjigFiE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4643
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10093 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2109010060
X-Proofpoint-ORIG-GUID: hgt6J-ALgwVKNdzT2XKXJkHqeNZ7DqAq
X-Proofpoint-GUID: hgt6J-ALgwVKNdzT2XKXJkHqeNZ7DqAq
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Sep 01, 2021 at 09:45:36AM +0900, Namjae Jeon wrote:
>  int ndr_decode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da)
>  {
> -	char *hex_attr;
> -	int version2;
> -
> -	hex_attr = kzalloc(n->length, GFP_KERNEL);
> -	if (!hex_attr)
> -		return -ENOMEM;
> +	char hex_attr[12];
> +	unsigned int version2, ret;

"ret" should be int.  It doesn't affect runtime but for correctness it
should be int.

>  
>  	n->offset = 0;
> -	ndr_read_string(n, hex_attr, n->length);
> -	kfree(hex_attr);
> -	da->version = ndr_read_int16(n);
> +	ret = ndr_read_string(n, hex_attr, sizeof(hex_attr));
> +	if (ret)
> +		return ret;

regards,
dan carpenter

