Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94950C4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Nov 2021 11:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhK3L6R (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Nov 2021 06:58:17 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:16708 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233080AbhK3L6P (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 30 Nov 2021 06:58:15 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AUAUn2u026595;
        Tue, 30 Nov 2021 11:54:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=8DMHX69vVsuf1PPkyMohSLaUcIjCjbRKdqM6zhgk0eM=;
 b=SRa07cu3GBAaqnwtMiXxxl7asoGD/8hkddS4Fm1IuIglJNQrqHyeCnVIkIgPuEF6uDsA
 rIwsVbSvBFSHwoKxgl9LDrCaY7+4JYbETIfTaPprLciBG/sNgkIu8WhhW86XnM+JnT5V
 3LqPCQ9Z1wmkgjbBwohhOKBIVARIcvd2NhM/2xePHynw8Jgj0WIeTq1hLxGHrA875O93
 8SHaTWQ084GZz8/l4qUU+o9ynPj809IXkWJ3LEzhuDjll3Ffn4wN37v2uwXD/t3NUfNS
 Vwr5duDzIm55HTkEBZ+3mmNhRoLD3mo4CdEeik5DlB4rU9IOReicpiQ2zbDF4eY5bWnv RQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cmt8c8bg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 11:54:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AUBpgDu091107;
        Tue, 30 Nov 2021 11:54:52 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by aserp3020.oracle.com with ESMTP id 3cnhvcm4d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 11:54:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2adbbwwQBy/qVo1KdAWIZDxYPmhiuA3H8+N8FFXKvz/sdc+k8909YbD1qEN4McMi7+75yqUqnId0FTiBSz20SApVqFgEZXk7jRM5P4VZmVOYl0NlzbSNN2fhcIak/GNeaBSMZB3w9No7AWIxYqXOb5T43dn+gB00bDuHajQGdiOAJdgzI5Ccd3Dik4KphqJBQKuiLg4N4mBsfLhSU5vYeIpo6RAukG0sXa4EQHTw/whXcJEnWpXHy7X6PXvgrmQRwgBiS03mMB0FhRlIiU+mqsuKjdGJXOxwxhJM7CJF7khmnbaqxtUHagM6QRu5o5t6ffHSeerDFyssnQvmhcvWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8DMHX69vVsuf1PPkyMohSLaUcIjCjbRKdqM6zhgk0eM=;
 b=KmmtfBANfu1aEmNOWvbMlrFUkCLONoJ24r9hL+YtXRpRi6j0yIYBcG+S9Em+DmBafOYLGkXBCh46ZU0M4CB3eg9tamVz1sYfHq0j7bluy9IQyy6d5ZaJDvCIoMLP40F3QRdXF48MllArWle6Qb38SqJ3ybPWIES2NxQiYGSMnUYMe0/y3pF/iP7nQ3WmpwPBiSrHzhMcrWqLCNuhCngIvdsS+pZdlgM62wahmvPJs7ZIfYfzVMPdY+6k1n0gKeV+uLxAcTKUY27ybq7seTT3/LCU6sXtHg7d16vMVGVy9WAzxCQXkRo+4WGCb3qMeF6ZcEHIEjpmwxIXQ/wSR7gH1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DMHX69vVsuf1PPkyMohSLaUcIjCjbRKdqM6zhgk0eM=;
 b=d8IkRKy6OueG1rY95T5ny5g7+RBUYiO3r91w7MajziFOIvhkhTLlxCrOhrIHlyR5xTleNKjPRQle7mtUk+2lXFIBqlhkReZEMGbcI8egazTkycKPUuM6W8vrQ+f0v6libooce2pIvpB02n0Uma+azee423FvXwtQ8PyRVtrOHek=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1550.namprd10.prod.outlook.com
 (2603:10b6:300:25::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
 2021 11:54:50 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 11:54:50 +0000
Date:   Tue, 30 Nov 2021 14:54:30 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     namjae.jeon@samsung.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifsd: add server-side procedures for SMB3
Message-ID: <20211130115430.GA16669@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM6PR10CA0044.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:80::21) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by AM6PR10CA0044.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:80::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21 via Frontend Transport; Tue, 30 Nov 2021 11:54:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71cc8e83-c43a-4653-8d0e-08d9b3f83694
X-MS-TrafficTypeDiagnostic: MWHPR10MB1550:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1550EE3A97DD4FD23316E3CC8E679@MWHPR10MB1550.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xmK/1rwB4GkxdwDbztMXEKpCBZ9nJvoQrMx2pwcZUvjvfWH2Sgn0KeMc6eVnpY9mlZqysTwx/67IFJSerdJXQP7Deq8gnKpQxBW2xzu+9TTlItGnjew9WvgLQ/gaNJTraivFoNbCRs13g9BpEPxkN5feROUtiOL6p9jGCUzmQmgSCgBbkYzWP9ZhFJO3vr3xJN4dsHPkl9GdI45ZykrYn+PBtvSzCa56DpaNWILHRAsKAgdbWb/Gl+s/edfvWXdYQJ8qKrYu9792yUL+jbmFsWF3K9lsNdTplKmMHKr5kdj/QHZd+Oc2JZyb0ZuxtV6Zxb2wzP3q043uKuweeCVsVRq923pT9VixHmemdHHhPVPpLCZ+s7cyh8AidPTtjRKHCXX/oGt9D7v+ITGQVfXFNwAzRWarI1mnB4ua8EmGrH31bQfEBh4pKXmKyPI034nCbWJdpCA52lv/MAIRkvFTTz7hBAFPNC+wAoob5ITMNEpigSCvkUGR9mHwvmk5Xf2qMOJ6I8QshLSUrrRffgcwZ0CIaU+1MyPGCf2T4lH8KDy9gX6qM4WoVprYilxFbwUjcYE3Ev8AHvFJDJyMZMAo9XIckZjcHg8T5GVzj/hjBfieN8vIbG8KVbT+DZQxyicmRzRM9g/FkN8l/AiL9F19l6snW0mCwkhh0XSi1pjBdBrATGoKGq3cNk5ZZhnFCHuJxspGIeMhzK3owvePUzv86Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(956004)(26005)(6666004)(55016003)(9686003)(6496006)(8676002)(38350700002)(4326008)(44832011)(33656002)(5660300002)(83380400001)(86362001)(33716001)(508600001)(316002)(6916009)(8936002)(9576002)(66556008)(66476007)(38100700002)(52116002)(2906002)(66946007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VLedNngFPrFOwS5BOviDZffMbzQJq1/9oEtg1gexag+cV5iKpxuh6ptuewIf?=
 =?us-ascii?Q?bEZSNSjZa8QzhRjegLgAa62i2+iooxcHrvEC5hK8n8UdSt289hOsaAq4Gcch?=
 =?us-ascii?Q?BAxQdeUdCa921uJAFmLlJmY/XrYb7tTjqDERkYbdLx4ndbF2AbUziEp4gxkr?=
 =?us-ascii?Q?Cm0n7q67+lb2si9iR0fjciNdrK7Li4dGeTWw6JyJadzEKzmw8HoX4RpZDu5u?=
 =?us-ascii?Q?36mTqLaEu3m+r3LEqGfC9dfU7g5hI8UmCB8rgCfCo51WW7xGPlEDfaZHSsyv?=
 =?us-ascii?Q?PIsURlHylVY33dLdfPSVxwzvOtXSF78ErXKfv0/MhVhhoJ77t/EWrUDzlvGJ?=
 =?us-ascii?Q?ZFf6SfGO1UNB1otkYNAk8B7R8IhXvYm14xJhiax1nOUNyebuJH2aZKJoCV/j?=
 =?us-ascii?Q?/+BCKiv8Q6RAPY+rEscOYPRwEm4qyKvG7JrbcBhdqQ2uvAWyihtQwxAuxtOl?=
 =?us-ascii?Q?UFmYNU7c3vkBy9rBFdflUahSEi/buAYqWHI1F462VLBWohsEPse5KwK8YLzV?=
 =?us-ascii?Q?ZT0WUdk2C/fa8UsxWx9lx6tyqH81UjIuTyZVXgtfvjSTen1DVjLTtEZ7jUg7?=
 =?us-ascii?Q?7SGx8Y8K+ynmNhHthoeRIDZ3/tMZ32P8CRhnANz/0vBIA+qFWY5sRiAh+Np0?=
 =?us-ascii?Q?cKaABdon7WM6sOevkoJUCPvGDgzkoO/CcrNJuMKzibwZkf1TgLLEp9vFf022?=
 =?us-ascii?Q?TZKK4KwFHkLTq0xaYpcfVYC4C20o+m5Pb7WEBMR2N2iNyowI+7k6xYI97bLs?=
 =?us-ascii?Q?ZxvtobjPKUKULG9zP6f27KwefjgMy5B7EBbU3wRUkkqskQSDFiwjxTK0p4id?=
 =?us-ascii?Q?YylrVv4Tt+s8VHuBnaw488Vush+nsZQpcGM2e45NMWqqSMQpX238PaglwTmt?=
 =?us-ascii?Q?K9KzA/7r71FdZJQckArO7/ZyaIqMBayoeVBUNDeoTQHXdC2fKwrEfmz5fTSF?=
 =?us-ascii?Q?SoUyeCueCEnuMGawYnNf3Lf2p4TqKWusZLkGborDdhbUcbNIo14FmRaleVj4?=
 =?us-ascii?Q?Cu9nB4jDzI5tw9CoBGOKEBDbkb8sdHKkO+oTKhNVUVAB23BfyeuwosBD52xh?=
 =?us-ascii?Q?ce/VIK+PJKN3B/BIV8PZuklSYMCT1a3tg+ouyDgZ4Ug0iYZKn+un0YkinENC?=
 =?us-ascii?Q?TTPnGr46t0jCRc98L/kqwLh23Ntrwr+k924YLHdg25cO8Jdbh0NJRaxB/itR?=
 =?us-ascii?Q?FG+ds9bp4XRORR/fkVRkWd9LqgK7QCWT8MWU9SF10JleRW9Ja4lhiz//d8j+?=
 =?us-ascii?Q?5hWEPEjqMdkwffh++TANJsDppXnv4493fO076ySn1VoQQrZSsE0X0Sl3aNGw?=
 =?us-ascii?Q?7oqWsuVYFl7MTQhmtVf6/152GWqMH/v3W/GHHTY5y9Pb+qgCgE/qKJvF0ISX?=
 =?us-ascii?Q?UEYnz63i/sM+BjgZtgrFUdZ3jHt7g0EF4HGrn/aq7ZsT/7QolLUFpAz6GhcG?=
 =?us-ascii?Q?TZfp5MrmRd50FV1aEr5ybqT4f57kPt2q7a4aSJrcb4/84n93fJvPi3VkJg8A?=
 =?us-ascii?Q?cP/5U2hhkZ7wwoOVTdJbcNdf9sjtU7xL7SQhX9Nd0XJSpa9MZvohk8Ta2dm5?=
 =?us-ascii?Q?0pwWlR7DEQcAEAlJzXvOfVkGpSh9RZt+3Y/4xSt9tyM8+CqCCgb4lPS7tZ7j?=
 =?us-ascii?Q?YKgJPGLU+WMC6/nY+IdH1Mgku9L7xNTd39d3zp/k+wsDlJp56V4R34DgTkCX?=
 =?us-ascii?Q?6U4pM37m8yHFZDGE1ewj+PRhWpg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71cc8e83-c43a-4653-8d0e-08d9b3f83694
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 11:54:50.2440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3+0b7lQ5lViDfRrYiqAhXLGmCo/boK3THb5st4WIoO6i9OxnIP7kK7AOLuGWh+yn2he3z/BW4m1dXDLtJF18XoQR8LIZwJ+2B3Y5XrEbw1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1550
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10183 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=894 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111300068
X-Proofpoint-ORIG-GUID: jC2bJmz3kHBArvZ43jcqBD6PDS0Bf2WE
X-Proofpoint-GUID: jC2bJmz3kHBArvZ43jcqBD6PDS0Bf2WE
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Namjae Jeon,

The patch e2f34481b24d: "cifsd: add server-side procedures for SMB3"
from Mar 16, 2021, leads to the following Smatch static checker
warning:

	fs/ksmbd/smb2pdu.c:2970 smb2_open()
	error: uninitialized symbol 'pntsd_size'.

fs/ksmbd/smb2pdu.c
    2930                 if (rc) {
    2931                         rc = smb2_create_sd_buffer(work, req, &path);
    2932                         if (rc) {
    2933                                 if (posix_acl_rc)
    2934                                         ksmbd_vfs_set_init_posix_acl(user_ns,
    2935                                                                      inode);
    2936 
    2937                                 if (test_share_config_flag(work->tcon->share_conf,
    2938                                                            KSMBD_SHARE_FLAG_ACL_XATTR)) {
    2939                                         struct smb_fattr fattr;
    2940                                         struct smb_ntsd *pntsd;
    2941                                         int pntsd_size, ace_num = 0;
    2942 
    2943                                         ksmbd_acls_fattr(&fattr, user_ns, inode);
    2944                                         if (fattr.cf_acls)
    2945                                                 ace_num = fattr.cf_acls->a_count;
    2946                                         if (fattr.cf_dacls)
    2947                                                 ace_num += fattr.cf_dacls->a_count;
    2948 
    2949                                         pntsd = kmalloc(sizeof(struct smb_ntsd) +
    2950                                                         sizeof(struct smb_sid) * 3 +
    2951                                                         sizeof(struct smb_acl) +
    2952                                                         sizeof(struct smb_ace) * ace_num * 2,
    2953                                                         GFP_KERNEL);
    2954                                         if (!pntsd)
    2955                                                 goto err_out;
    2956 
    2957                                         rc = build_sec_desc(user_ns,
    2958                                                             pntsd, NULL,
    2959                                                             OWNER_SECINFO |
    2960                                                             GROUP_SECINFO |
    2961                                                             DACL_SECINFO,
    2962                                                             &pntsd_size, &fattr);

No check for if "rc" is an error code.

    2963                                         posix_acl_release(fattr.cf_acls);
    2964                                         posix_acl_release(fattr.cf_dacls);
    2965 
    2966                                         rc = ksmbd_vfs_set_sd_xattr(conn,
    2967                                                                     user_ns,
    2968                                                                     path.dentry,
    2969                                                                     pntsd,
--> 2970                                                                     pntsd_size);
                                                                             ^^^^^^^^^^

    2971                                         kfree(pntsd);
    2972                                         if (rc)
    2973                                                 pr_err("failed to store ntacl in xattr : %d\n",
    2974                                                        rc);
    2975                                 }
    2976                         }
    2977                 }
    2978                 rc = 0;
    2979         }

regards,
dan carpenter
