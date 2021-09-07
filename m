Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7BE6C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 08:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4A1560F70
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 08:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243468AbhIGI4G (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Sep 2021 04:56:06 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:57442 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242828AbhIGI4F (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Sep 2021 04:56:05 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1876HH6D001550;
        Tue, 7 Sep 2021 08:54:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=pdpjYAjXpT7PoQae1fApaP9zrs+O3GE9JZWZSOz1sfI=;
 b=zK7GCYMadN0R2VxgWm9KllHktxYNxGdL1I8ys8bQUvBKT45ESBxpnNQx+cdlgZhifBY1
 nvP2oMY/tRYOO1f4D69R4trZcrfvrCgY+ToSjHMhSznUU3KqNTi+3Je6pip0O2irawLG
 b26HHRU8IfvfR6SOZ2oDeOf/b7JRZfDAUmksdAhYafb8Yi9Zi0hvflyIeHuQiMcd3njv
 215X7UZwgLhTncHL2JB07hDcPbW2Jlcoy8YlSovTToGwDpyf7MK0AtvlK9eWNsEGVbNL
 uw34xehUA9TDcqTEe87NlD1pgY69HIlkU/7VPfaqwtis9U7ojh/YwDuzl3PVKWgdDYD6 eA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=pdpjYAjXpT7PoQae1fApaP9zrs+O3GE9JZWZSOz1sfI=;
 b=R1wYCrPIXgvjth0UWgVxukTHWF5qu84sSuHDLYYLKjsyKYD9KUPtk7pMqVFKdHoH87nq
 tJ18yhg4XNIESTGnJo7wodEMnr7MGTJLzKx5swWOUjqb8MQTT+CW2S79htiibWJvATW6
 MHUbF0bRL69syOOtHYSMVTv++2XM3jO4jd8xw2EIhBBxHqY010/1mZMSiaD4xfPDs7pF
 ivZB/rDOiw2LMgiYyR15H0BJEiCPFT7dAnbpLXugi7LVezMDz8B0zIvHdAsv2bHnGnXm
 46jGzca21d6aqu1vQO4+VVaAlHivEpCqKZiW+Vz4ho/hrBzvEFR7WIriMpjrIcHhojYn og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3awq1895dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Sep 2021 08:54:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1878o8eO130748;
        Tue, 7 Sep 2021 08:54:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by aserp3030.oracle.com with ESMTP id 3auxudafq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Sep 2021 08:54:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGFpS5JKaR3BG8pAbmy41nlrj8EEnW2o6N+UypXZ2tJv2AFLgzmGdVuAjAGsHP61wpCTBIKBubOK2t1IunvH6wHL4JdQIHVRCt6dBkNtLcYXU4hRT+efU3aFfgrGmVfxjNAIxIvzl3+a69cMwgZXz4JjQyF1/4RA+enDGAJkf2x6/TZeQkrcaMDZXFphJfbvS2uNpcIDYTesriz6Ff291jr4P9TM9omSLEVVR4zUgjViTuyqh6kT/3NRSJF0OMgu7N3sYbif28wTptybbkozhoX01NFcth9ELhzu/Aj3zf3myJdXhJgX5X77VSSenPn2Yr68mhOWq8ionoZZmdYfnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=pdpjYAjXpT7PoQae1fApaP9zrs+O3GE9JZWZSOz1sfI=;
 b=h9WoEtntwtZTHGU7vCUTWLRZKsb+1S2xt4YQX/aj65e4FBnRBvXZgL53GFG3hpUsd/ijM+019ZCmr1/UYkRDPuN9WM2apbayXGtuGfftoIGQxuKYiUNfoRdC7qtIWFWigD3YQDEemRxxnTaUj+C6igB2JfZv3j4+Y87DEyHViMjPS+i35yxLbJWtTDYckNhTm6HpneVU/W7rrZqC2fUxaMNJB7MZlkBZHF1u7hEgS991qrfqb3KivfbDN4f6+ymz/jwn+HSPAhynbWxHuwm0ylb7N2k5/E/XlHkmPlad7tRFLLqd6MDJEKr1r4vY5xJTQIRC5DhFNRfw6j6qBfa/Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdpjYAjXpT7PoQae1fApaP9zrs+O3GE9JZWZSOz1sfI=;
 b=L6bMSWvl/1LPTEgunq0nT+Q1cW9LkqZgDorXAy78i6/ZuZTBBULphQBKe4qUbkVL87MfFIbYiy7BaQWZm3UF/ienZKer2nNIFB0vWcj9Uyy4Xon/cuupHRMVw/PCxCluHyiAgbw+v8xt8JBwK0O0zlPckJ7XMD7Sw9M9/ghACew=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1296.namprd10.prod.outlook.com
 (2603:10b6:300:1f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Tue, 7 Sep
 2021 08:54:47 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 08:54:47 +0000
Date:   Tue, 7 Sep 2021 11:54:30 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ksmbd: remove unnecessary conditions
Message-ID: <20210907085430.GM1957@kadam>
References: <20210907073428.GD18254@kili>
 <YTcdbOgmB7758K+/@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTcdbOgmB7758K+/@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0011.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::23)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JN2P275CA0011.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21 via Frontend Transport; Tue, 7 Sep 2021 08:54:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ea2b645-72c4-4a0b-3780-08d971dd24af
X-MS-TrafficTypeDiagnostic: MWHPR10MB1296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB12968D6014669298D629C63D8ED39@MWHPR10MB1296.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CRTVJBdaJo+K+Lp6szf32ZpqPCawMWoI0+J1o/83yr7e/E3sE2ewEs3B5AyEn7TKML/lW1iVen4HXU6dLZ+HHp63XyjqhhTeNlrQ2Ry/51w/k/ofQGIG42O3SI5VvQPAs7sfYDJ8YrhmAViezyOx6QfhaZIkezpltybhk4EOjvhqQN5b1EQp9VFFTpYgYBadFkyf8c7vgPBzcpCqmKh9Ma5vyN2dNW9MTxc72HRbEY96nEfTAWCAJxdE8d3vXS437iF5iH5HJ2JgenFyi66x5x216emgBuls/U5ivHfm9Fc4mhmHVjg0jpqlASXHv/P/RJxTPkIyML1pDfdM+nDb6VQhSBYofMh9z/FGQBa9/y4oX1987DjPn+5qu8uKTOO0LGO2o3B5QlqyJ6IOVFXZkIuxhkiF1hPRjdkQ3IjMJf9OtZWiqTACN4t21mUAgyqMIqXyfrdXuCKSBmD68cxZbua5jkai80A2O8Ds7PVpJ+bVBvA4cu3vxQ+gnKTpxm1C6ox8YddXWnTjUKtHTjJug3KHoYIGCzHcDBu9M1KnNA2Oc8K9+9zjMpvvfkLrzzB02XKBmV13kqaBdz+N+ajPHnNLZwuiaNdzBYhIxW9eg+zMZ399RvyGuJ4vFWJlgKElp9YeW3RTII+nTo6tpShXGKpfdvQ+Z+eMgjag4a2rATphtINrezPLeKZ+iVUwShsPSsgFiSke3fBjxeiH9wHvIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(346002)(376002)(956004)(54906003)(66946007)(66556008)(55016002)(4326008)(186003)(86362001)(9576002)(5660300002)(52116002)(8676002)(1076003)(66476007)(316002)(6496006)(6916009)(6666004)(4744005)(2906002)(478600001)(38350700002)(38100700002)(8936002)(44832011)(33716001)(33656002)(9686003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mrj4xsMFYojeW7zQw4rUc3wnJmPCgeCZi7UhBOHOGRg0XvkEhDtBzp4zIHHO?=
 =?us-ascii?Q?KAjxpv/j9GsbTYiDr4ELmHuu8lFht+LP6fUU03LimaK60TJCtKxA0UTec+3o?=
 =?us-ascii?Q?epNu49j3vMKdgMOoNNXOOvuHlDv8tAUeFM4lbJZtUAxES78gtyROe8OxSdPN?=
 =?us-ascii?Q?XmiJB15FLOs+GgxwxqZsZUUa0H5iohEUXWpvXxv1ZgDmEHzzjTJZ5OLpqnAC?=
 =?us-ascii?Q?dFwPPCoSs28Bb+BSmqc7qBSlJ3tnedwtUlya4Wt/5Jb9lpXuGXDCVNIHiaX5?=
 =?us-ascii?Q?xpdQTKghPfl8lp/Xt9/vep9K1bL1JeAbt60qCYTuAx7IjvTXlVYkwO9k5QN7?=
 =?us-ascii?Q?Tixbvk1/wAGWsPok9RmGxiKtVcXAhDoCpZcTHCmozNGb9Va1NoW+8aFwKRYe?=
 =?us-ascii?Q?G95Xf2tu8mxmwDCK8s1TL0ByDTJRuj2uUOOqlpuqVpzN385IXjxeSYtzC40C?=
 =?us-ascii?Q?JioeMB2daECTKjaPHqgIAjaEcGIvltKbZHMhPutXDoRokWTGSSb8ZGk7k6UY?=
 =?us-ascii?Q?rFLCvvoiG3y8aOxKm37ENU5EMdTuD102pw0e/KErnjTyPNdZmZu4K/6Qt+NH?=
 =?us-ascii?Q?wth/+Sk3XVo6eFmzDnFNcgEX3FqgzbIqerDXW4J58R+3qwPtE5OZBjN5MWAd?=
 =?us-ascii?Q?lO5JAGDGcxgU2W5NxAHYdQGfeVIn8a6I5/HCke35QDamEu1WTQE/stsTlUAM?=
 =?us-ascii?Q?GI9BQHcRplwz+Q99AhC/9ZYkfXN+yRRMWKyEK4H0e6d9PFCN7QGJi9WqONxJ?=
 =?us-ascii?Q?bW+uBLOuA5xfYCOtaZBJ21A4pYxllkyGaJorG7WeITV264tR0QWf38fIMPp4?=
 =?us-ascii?Q?89QK04ndN8mh4z+Q9g1eQpGiZo2/KAsZ1y3zy2C+n1I9AYkT7PwZy0YbyFPA?=
 =?us-ascii?Q?DZR5FvJORltvLxpFAvnLiOW4lwxhJSr8PFHUfehEHJIZm++j+gn1ofXk5meK?=
 =?us-ascii?Q?uoDqbpPG+zBI4QxWCbn40Tbe685SUHYku+m0IDK3DMM4Ofh6GEe8oj+P09l/?=
 =?us-ascii?Q?pUVLdBHtQZga+R3hHaigCAzZ4S0BkNA2gEoPyrD7YLubYuhgfIGI9IVW0TGa?=
 =?us-ascii?Q?6NwIemMqbrNAPTotWb//fB8YmrDUCWqvBrs2q+tdvT2UZU7BeUnVKYyDnlmx?=
 =?us-ascii?Q?WUTUhRSqJ0hS88E7eAbbBNau/kjJUYIk0MfJAkLlMoxNEVCYFVoYZhVKkGAL?=
 =?us-ascii?Q?YXG5Syg+fCW3pQDYqxaMARIDz2ndhQvNQ7DXOreWncAQ4aFa0sg+DkWOqEwc?=
 =?us-ascii?Q?i5JXyIylvyB26vFU1uocFCB+LHDo3FO4Ki7+wgxb+IXCVc+oHWdby545mk0S?=
 =?us-ascii?Q?WN92y37od/FrEUqSbxLa+ptv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ea2b645-72c4-4a0b-3780-08d971dd24af
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 08:54:47.0967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RgyRG4RBMNUp+wu81m5Yewf0NEOGrHnDnUwwh+4OuEraeT8FE/4IDW2o7l4592PCemFpVNmv4vG0mXmAUZefv/ZUOsnNbYErJifDNxwZdyU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1296
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10099 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109070058
X-Proofpoint-GUID: VK5tT_IImf_MmVq9EvhQ1q7BWhYOMFAg
X-Proofpoint-ORIG-GUID: VK5tT_IImf_MmVq9EvhQ1q7BWhYOMFAg
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Sep 07, 2021 at 05:06:04PM +0900, Sergey Senozhatsky wrote:
> On (21/09/07 10:34), Dan Carpenter wrote:
> >  
> >  		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
> > -		if (id >= 0) {
> > -			/*
> > -			 * Translate raw sid into kuid in the server's user
> > -			 * namespace.
> > -			 */
> > -			uid = make_kuid(&init_user_ns, id);
> > -
> > -			/* If this is an idmapped mount, apply the idmapping. */
> > -			uid = kuid_from_mnt(user_ns, uid);
> > -			if (uid_valid(uid)) {
> > -				fattr->cf_uid = uid;
> > -				rc = 0;
> > -			}
> > +		/*
> > +		 * Translate raw sid into kuid in the server's user
> > +		 * namespace.
> > +		 */
> > +		uid = make_kuid(&init_user_ns, id);
> 
> Can make_kuid() return INVALID_UID? IOW, uid_valid(uid) here as well?

No need to check twice.  We're going to check at the end.

> 
> > +
> > +		/* If this is an idmapped mount, apply the idmapping. */
> > +		uid = kuid_from_mnt(user_ns, uid);
> > +		if (uid_valid(uid)) {
                    ^^^^^^^^^^^^^^
The check here is sufficient.

regards,
dan carpenter

