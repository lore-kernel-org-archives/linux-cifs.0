Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3852C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 13:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D42C0611C1
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 13:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241617AbhJGNiR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Oct 2021 09:38:17 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40244 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241635AbhJGNiQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Oct 2021 09:38:16 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 197CYPQv004077;
        Thu, 7 Oct 2021 13:36:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=MI7j9KduKcMCgVCQfZfmzxrhguZglNb3QMxpLI55EhI=;
 b=KIRzZaetzQwfWEnnL5HFtLslflEx/FwzG2KNr+dYreWf4aZ0htjPDcUHh7mAb3DCzRu2
 u5lZ8c0WmjtRZ2Ciqb0WnWtJS5AkS8kwmeQl2GGg4rtDJuS8v6S28ua0QMKhtbt7Dfbq
 pTNqfeHNFZCgHgl4NE5RXl6nIdxEZcLovN3++kleKO5fvBI+0f11TKKeCCnq82lleG/Z
 Ce71W4kobKO+laJJRNVrhKW/iCzD+VyZizVwyMl7wYeqRk9YSClGjPHs7TVqoKITygBh
 /NdXkNryjeJvCariCnpX+QN2qIL2OareRPGUQqnDQWOjxSrzSVqp4QPGdDmmjbzEV6Ki lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bhxbs19f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Oct 2021 13:36:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 197DYlM4092443;
        Thu, 7 Oct 2021 13:36:03 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3030.oracle.com with ESMTP id 3bf0sa86xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Oct 2021 13:36:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NxWctUZ8+yBveYeIrh8lNv+JqfS6NC8gKVEXJOvKMlyxza2f/iemFpgQiWZbfYF2a3M61wzIEk3M9q37Ifcyh0aViiJ9WpieXEeLKuKKby0HkLer1Dbp0z3Gg61BQpdRk5Dy+bsBRdB+hC6E57/P1NQfzwa8eRsUWl8sj+EweYHzGy6rT7M3knUJJbMTs2EA+6b/C10Mv5OQstzE62a+vCMnEuxwlp8MIETXSIT986lGeIgoIYzjljnDtri5SnxappcGS5aQd8rcn5MllSnAycgl8jBSnZDqIrpsZzehZf0PKl4PxYLBeNJVccaVCXfKmQ2Ni9MWVQEopRjPFaocuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MI7j9KduKcMCgVCQfZfmzxrhguZglNb3QMxpLI55EhI=;
 b=V5jYPPE299aXBm6SWndcXE1oplq5tqM1bpJ5an6ra7Xob04Qrwll8wgRPhNvo3lpKHjG7fFES1TDthHMhfn0j/osqoIQNjOXa5Ve4XQHjs0SYZnHkvK7Rk35LxGx5UdXEsXe+sAVeZ1+qA4QtXlQzvP7sDze07+XRMseLbc4+EV5d8TqXrQ0atY5AycfCKsW2u0ppNsdS+EXq2HdSxf8kOBJXaovTcngfZY8Tpm7dCfZ5KwEqfvxwrhyxdHQXKBRp7GHVq4GWRLRCMbCsmOvi/3irENbOKPieWMt/NMEb1bjAieX66WuZG/FOV5NwNK4J4q+wiKQg3PiSavP2FZwYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MI7j9KduKcMCgVCQfZfmzxrhguZglNb3QMxpLI55EhI=;
 b=DwwTzysHhd/5pcIxxaSp80ku+4MEv2IZHUm+lcRU+11eIr8gSj6k7FCJh//2EmXA9oI3Q34S8ZWqreT+DbsbGGlkM2ua8GqXBGQeq06bhJpfdemJpqL+o1qKPLcUyNGbdb6CqNfUCaXPeT0PDyoHHkzndRHCgn4pzE/B5uhDeWs=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1488.namprd10.prod.outlook.com
 (2603:10b6:300:23::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Thu, 7 Oct
 2021 13:36:00 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4566.022; Thu, 7 Oct 2021
 13:36:00 +0000
Date:   Thu, 7 Oct 2021 16:35:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Colin King <colin.king@canonical.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] cifsd: Fix a less than zero comparison with the
 unsigned int nbytes
Message-ID: <20211007133541.GC2048@kadam>
References: <20211007114716.13123-1-colin.king@canonical.com>
 <CAKYAXd_aOawm4MkBtkTxnLfeEk+F5VgrJHjyH8GSaeHjQbLtGQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd_aOawm4MkBtkTxnLfeEk+F5VgrJHjyH8GSaeHjQbLtGQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0036.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::24)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNXP275CA0036.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 7 Oct 2021 13:35:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bd9ac87-fb07-4e6f-6af5-08d989976642
X-MS-TrafficTypeDiagnostic: MWHPR10MB1488:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1488553B229C1948A389CDD58EB19@MWHPR10MB1488.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gfHpUc1RHlRa0yP+iITu+ZGUw8cw4NgaQwllfXYS1OYmOAva8g+lwaFFcb4NHW7u7DjPr6/u7sgRlp4Oi9DCl7+a0AvbDkK2YanIeasHOeXkh4gIiMHWxaJGzNyu5NzN08hg9NfFAusHaPghjbP3OybXdD/bpef6OfCfqCPcED0gvto34v2kkcx0bdPVfj1AAxQg1/ra2LH7QwnS4QTGP63hgNBZuYOc61UnI2NiITfJfZWCqihdGyQ55qu/2iNe1m6aSd+PcJx2C2ySS5vtBwGqN4IYpdukA3dLQglorT11t1eKZ0frq2B449o9MilZQEnUTdfkWmAuUAh7ceUO7OOKNgkE2JBNViHFo1bUMLq+/IuBmVGunZK7JN71B+IWpWT2siPJFfnpFWKXMjd2lfqW/w+wsyCXyD6DZPVOkXpyaBoNs0Wtt6NmNaUFQDt+mQfd0+YGKgYUfX0s5eyvhgHvuqj6WvaDr6ozMtS0rUotpVXkhPINvjFmIqBkWSIW6dHIb08pmsEj0qLZYkJr27zDvFQY8qCjB5J0dDBkzcbVVifK/vDCMvn0ob54WLmxEq0eeBbdfbw7i4KSPChFN6kTU20w1vZWJuyL08V2Q4YdTozEynKAWUxxwFOIVn+cEVpaNG/8rN3XjKN8BOYCkD6of4aR7cP37y+xy0+jAAlVHWGjWBBQO+gzXAor3D02fPsyChjjFUiamG/IQ08dcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(6916009)(33656002)(6496006)(33716001)(1076003)(5660300002)(6666004)(52116002)(956004)(316002)(54906003)(26005)(38100700002)(44832011)(186003)(9576002)(55016002)(38350700002)(508600001)(9686003)(66476007)(8936002)(4326008)(66556008)(2906002)(66946007)(8676002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Rn6ENOzSqO6MLUshQDcj29iXzuRmHjt8Fs+DUWG/IreqWz5x+ypWg2ZtuCI?=
 =?us-ascii?Q?pufCCx9BUGRFjg+io+Pin9UZ8pBMWd8D7hIZzeNqYn7bD0cOieKHVyTcRXeC?=
 =?us-ascii?Q?I6YjRfby+s942zzPC3NgKY0gBFwdITwAXLcYr5e5gEJUyPcOcsvVc7z2eb+6?=
 =?us-ascii?Q?Ven1uFoCpee3EYxlTgLMeZc3wnz9VThaJIvO1qSpx8hwoHJuw5CcNXSNG2AD?=
 =?us-ascii?Q?HV1MZIPI7opbOKVBMSP6QSwkp26GmE5B4FWm6GkLtSsOlPLJBueFHqEotTLJ?=
 =?us-ascii?Q?MlDyqF9xXreE5mnGscnBxvImnTJb2kkfqz8ZKZPqwlwhSQXADWXFHK37pxIJ?=
 =?us-ascii?Q?yFyIv2zXgvBUwcEuz7IfNRN/wS87wmmNHJMKH+Nl9+D9O6mABoR0GI3CJ+2K?=
 =?us-ascii?Q?WEBXgpXYaI5ldtmUCJ6iDI7FTT8fSx4ujnl4YM7LKKNTqxN9hptnP5I06HzU?=
 =?us-ascii?Q?SwABK7qmsuW7TqPaI20/umbIQ7sx6GE3FCt1OWwX5i3RNQFCDRxAWnLDsN72?=
 =?us-ascii?Q?Yc/TWHcUkDHG1J9kEZi/mmoczUMfVohw1V0H0OBCZDHv/c21B9PgwgirrQH1?=
 =?us-ascii?Q?z01XIEIMQwBlQrpmFTZJV8lZ0gPfrCAFBZVtUYVefeZg0xXI4gjt4nX4Welp?=
 =?us-ascii?Q?W4bT7CRIi1p/xN9Gjzx7clS8vSu/uLnunsbTQcIlp6wJPRTFw/7H35AYhUOx?=
 =?us-ascii?Q?jg2/saMmZF7eMd3Gt9uRCTM59F7wX7Lsq8cPSKk051ebbL1EE75TjOe6eYDk?=
 =?us-ascii?Q?MMFv+Wo4cnoy1z42ePpS1Qn6q04v9hwujtACcy2uABVKy46PkvobXuD8gXdV?=
 =?us-ascii?Q?65BkNL5zlMQgC0xPcD379v/q1WJvSd4hn8fUPntTV4MmfwQQ6Rl+H3S8aZFh?=
 =?us-ascii?Q?ugI+KUmQM3War85hIm9tSeY50MPZwDNE8ZpJUXOA3CvKxS0FUhCYU2dFYx+K?=
 =?us-ascii?Q?dZCez2a2XkbW20rI3wTgPixfCX4wto0EJHTQ7DTqSS+VwL27LYzmi7PZHNAM?=
 =?us-ascii?Q?EmR5KFf5cbMArm2Ei8q+c8I1vcUW77yl9ZxtDU2KTvXlbioaX29i/yItVmNC?=
 =?us-ascii?Q?Rt6+/AiJ9eGdwvcbXOQO6W6agf+lqBEceqQOyfz3TP6cIXAHMaO0wpnXTsus?=
 =?us-ascii?Q?gxCxm8xAofpANw1Neht4JfFKiISzEtnwQ5xuKo6TxDHOBfvtNfY68+ciC1Ib?=
 =?us-ascii?Q?bAMWIds0hSeTa3sSURcurwrjlNJIrOvPs43m7eer5Y65tOf7z2WslPvQVvcq?=
 =?us-ascii?Q?QNYJNrQGfY7tuuOkNPrJEGVtXtjzpQzCSOWCD/9sXG8g6qc6RbwUo339C192?=
 =?us-ascii?Q?jMQC68N/aT8ljhaWLvpcF/vR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bd9ac87-fb07-4e6f-6af5-08d989976642
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 13:36:00.5177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GJVMzSACVa97nNc5BjFQY0To/PpMxpVcuWx/6P3SDA7+ti/cHHD/d672Q5xNTk9X+V6eHhkx39P3oJh8nVO3d2uNhStDKf0hPhtpHkImPb8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1488
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10129 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=925 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110070092
X-Proofpoint-GUID: hSGvKxeEwL8gzODw2yTm5-GHe-kpgSFK
X-Proofpoint-ORIG-GUID: hSGvKxeEwL8gzODw2yTm5-GHe-kpgSFK
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Oct 07, 2021 at 09:37:04PM +0900, Namjae Jeon wrote:
> 2021-10-07 20:47 GMT+09:00, Colin King <colin.king@canonical.com>:
> >
> > Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> I think that this alarm is caused by 	b66732021c64 (ksmbd: add
> validation in smb2_ioctl).
> Fixes tag may be not needed. Because b66732021c64 patch is not applied
> to Linus' tree yet ?

If you are going to modify the commit to include this fix then that's
fine.  Otherise if you are going to apply this commit then the Fixes
tag is still required.

The fixes tag saves time for backporters because they can automatically
rule out that this patch needs to be backported.  Or if they backport
commit b66732021c64 then they know they have to backport the fix as
well.

Also the Fixes tag is used for other purposes besides backporting.
It helps review.  It's also an interesting metric to measure how long
between the bug is introduced and the fix is applied.

regards,
dan carpenter

