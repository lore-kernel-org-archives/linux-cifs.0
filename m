Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D09C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 09:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A098C61101
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 09:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244756AbhIGJPt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Sep 2021 05:15:49 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49726 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243373AbhIGJPs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Sep 2021 05:15:48 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1876HKYj017560;
        Tue, 7 Sep 2021 09:14:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=BBY5HdMoPmS1rNfPQTwF9NHTsMjbFxYB1LK2FZazGak=;
 b=qFrgUd0ntw9bMkdTjyPFcbns/J8ZBpXv/ykrFlW92QEZXjMKum6Cif721/Sl1Tt2gCJE
 MbHTs7N8pZvtsztt3r/fQG9AiL7KhUU9pXSlaVKUWNgIQiT5l3RtCGFbuDt/hzVqXyy1
 mUMxS2RUdf5n/eeOWUkE3HZy92y3wDmtL3DEjN9oqpnt++50oiypUQCEwfAvK4MBmz6B
 k2ErErYGf4GLFEuwG227vD6b64KStOOE9A7VpuM2aglFw8J5uJJ7JNz1TbfChbj7KbMt
 I4RNVcPEI0XBnNefN2x8aafU2TrjmxTMEPOpu584HYDCN9t3UzRIcqkVFlN3TBtJn0Wz hw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=BBY5HdMoPmS1rNfPQTwF9NHTsMjbFxYB1LK2FZazGak=;
 b=CWH8Im+JKjTLxrdcUbxAM+8ZJvTpRO1x6+WRSSiu18y/6+29lUObYiCBpFyihH3ehgg4
 ZBmqLVMvsz7U5XxhmtdCvqc8Pl0aVM9XhPtABva46RytE0fOEni9heUShMGw6ZDuz57A
 jlsSst5+WLB4jTfH5bceHJaazxhHOvnAtBa/G8T56Rm+EGY1XmMwu2xw+isq94vaRCYk
 5AquxzvX2Sr911gW+TNsCmB5zcEcA00aDSPjilmF8m+uk1HcAxeZDXEcTvypkeZije74
 YiZEyziHXkQ2r0SlDL08vixPjp9zPElbAvtlbHhp3xr1s7rxqEnmGrI7Y1PBRfGFuc5H WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3awq29h801-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Sep 2021 09:14:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1879A0HN065239;
        Tue, 7 Sep 2021 09:14:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by aserp3020.oracle.com with ESMTP id 3av0m48bxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Sep 2021 09:14:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XbCNBTSs9Dkkhs+e1axwlqH7woUvfhzx5RaQ3wDszcJSk4VTEmEevnTda8JjQ/xgBzVRm3InfKMrRn7DN1X46Hxm/L4TOSmU9XF+uFdM+UPnKN6IiHsZMAdxYIXzq4uX/i1J790cFrw78P70wkTcFyDsjZ/8Rqr8DCuokxardt6kWLhBS4gGwSa8I+iPrZfOPbhTHb9fUHhI1wx0eQCqR4+s+Qv7h10SSG7ONakYUKUeQrZjxaJhDEjynuGKLBxKQUmbnAWVTMl8W5nMHs25WsszjLSY+ICrScrYBkBUZLF5DZMCeQvVNbgHHrt1NejBt44tt0xYj7UbYY17qKMKQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BBY5HdMoPmS1rNfPQTwF9NHTsMjbFxYB1LK2FZazGak=;
 b=bYDMb8jFyzmo1wATMwVd8KKLfefYe6WDYTSH5sLhscEIcglsVesC3bOo7Z6IrSubVjjqvJgZybZlpr12bSRk0iqpEHRLURPNpR+jNl5z4LyhOsz/lrzJqHftcB1TJhbrXHsKr+caGur7MY2YowtwwwySJp5+7ccLpUYGPhHvDA40TIXuOIV7OiGRgW+ITnZQrWMhJzP6jFv2GOeUwMhYKRZq3i+y1l2OKKH4wCPNi29xHSdhoqnJvj4nVnETaOco9HX8ojs5g45T6u0Nyp0GnEFaZEbh3qlJhD365fB/fEiOs7wL+WGfm5Gbx7ymgxrYR4r7RQZ5MFeqxrniHVzGnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BBY5HdMoPmS1rNfPQTwF9NHTsMjbFxYB1LK2FZazGak=;
 b=lWMEAo/jcu51gsBUfWN3a+04ZDS9jbeDkIPj811H7+cEmQKFWzT/ge+VBfFdR1i1C2WTz96SGXhvU8ER/LuuMQ3UjNh+2gDMgqCyFAUVTtZa3A+4NCBqooAghOwtYGEsyOYbFP54+zX7Fl5+DxkYZqsPyvoYC4xAQfkj1Zhrhqs=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1486.namprd10.prod.outlook.com
 (2603:10b6:300:24::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Tue, 7 Sep
 2021 09:14:30 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 09:14:30 +0000
Date:   Tue, 7 Sep 2021 12:14:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ksmbd: remove unnecessary conditions
Message-ID: <20210907091411.GG1935@kadam>
References: <20210907073428.GD18254@kili>
 <YTcdbOgmB7758K+/@google.com>
 <20210907085430.GM1957@kadam>
 <YTcrA2U2n5QAUkt5@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTcrA2U2n5QAUkt5@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0043.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::31)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JN2P275CA0043.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Tue, 7 Sep 2021 09:14:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3bb6f5f-3608-4b10-a4dc-08d971dfe62d
X-MS-TrafficTypeDiagnostic: MWHPR10MB1486:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1486B1E3247CA29FC40150D68ED39@MWHPR10MB1486.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SamlXYyJweek/qj6YGNpn0kv/QpKRXSs3A5K9pk/gqWSggAYxXiEiwvwwZQHXrrKzpTG5wQ2HhzFi2koRw4IdXPRMyfVk1t7G3vhImfGVBlFYE53Efhvxpq3wRb2H9p3YWpBvhqm3q6lHR0vqkcIebLnMUdONEjPl+ef6iSFNq3AN87aEmB4dI6GvcbmfTC5PVdXx+ooInXyodWFdFdXCpYYnSP/BKI1Xrks7k2szhUPAmGMJH9UxVyky+dgV3GPArxDkxlMDowTNrG7bdqYOlA0EOtIaRnNWMj2OCQCXibX+07y8rp3HkwQYYMWENYYXt1qGC9qNyvEjANqLAg2Xh6kExxqQ1V5aV1vs5NQ6Oj4h0HLRwIZZ6E2D5UguJQbeeUkrl4tBIM2/WqueQBcuSL6O7m/YdzkAvxSoAPMumqmzgcbR05UhR8CaptOG42gwl+DQjxJKYK0A5G8q/4xT/Kf4l9DyGYDA1W3jZ6UlAaefHwO0Fjh82jU76clbhNdqm5qy459wA2NnIp8DjmM+V0c10+uHf3MViUXkDnEKDEEpRVuN02oDyq57Ld1+971l83LqH7QOMAqT5uav6XuWW7rE0B3olL4FMjdwlv6k+8KBzu3P00UCZJfDICecYKDdRHezKczWOTLQ0kNL+suMj7OO5hZenJaDw6BVbmhuN/CDrilZvuQWTtMeiPD+/iMXzPBsVX4RD48sR/uxezDTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(39860400002)(396003)(346002)(55016002)(478600001)(6916009)(26005)(33656002)(33716001)(4326008)(186003)(66476007)(44832011)(9686003)(956004)(6496006)(86362001)(2906002)(52116002)(8676002)(38100700002)(38350700002)(8936002)(1076003)(5660300002)(316002)(9576002)(66556008)(66946007)(6666004)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fi2dnneb7sH+i8pm3nEX32Fg2BGfUvisW6O3JUZeioBVcvV4IH81A5y0GZjr?=
 =?us-ascii?Q?5a984ECec0j4SwUBlCMTfUdOygSu5hFxFL+IIdGXRjnPblt6YezIXzK+BSa3?=
 =?us-ascii?Q?BSbIHwqxzF1Tvv7zcd4BZvWf13RD4dDycBUE/Lmi5WB2UxOq/UBeED8ExUNg?=
 =?us-ascii?Q?K61vhUrRDs2BDv2BAw5HRCWnX3c6SQcdSOm66sKhNIc/6NZtd69xPljGroCA?=
 =?us-ascii?Q?B3xBzaZvXn09Y8pmxwmX/KHnU2sryyZjclo1am0qosD1Wp2ImUGXrDSmWkO9?=
 =?us-ascii?Q?3yI2J6cllQF+IXiJGsFRWutYWFl7JEfBVkKIq6nTCr3E/0WfSX3lJwpf/BN5?=
 =?us-ascii?Q?WhiEbDHogi8GwLGxYtPt0quweQ0qLfCXB2mNNIfxODBRnjPzbHk5FvTP84s4?=
 =?us-ascii?Q?oxgQRVJB7N3kVK3WiTNaoVgQPxNNmxn5sUuxktYPD+D76ruOn40mmEad6H83?=
 =?us-ascii?Q?MemNUKOYNEnq3a9gwaVfA5j5Y2w0dEZinc7nNkI9MKR3RAljiQn5c4S3zUBY?=
 =?us-ascii?Q?/nqPYcRkJ6YQmbT12wdUR99TbtFNW0Gt1j/b2qlLkouUYMA14Gsz5ce0TP0m?=
 =?us-ascii?Q?EXlv7T5z/sh02NFoVGscMbt6SeiwDVMdgbUjvBe2aJuXmMVmjCCn5jk2Xsgb?=
 =?us-ascii?Q?jm+3/uXWhxa5NxAqb2qJFEf3rrdeihzM/IqCkmwqybDL08PB/CAJ3pqpS6/V?=
 =?us-ascii?Q?BOcpidu+M6VzEqIVY8j0BNAPFOXiVkDTMWms8qoR3170Cmu8nk4aMDZHwUjB?=
 =?us-ascii?Q?Tq/RYSrtuKpzE6Q4sYi3PrDaveZV/GgfsEDftDO0kkBctBU1Rjv/+NPZ/WwR?=
 =?us-ascii?Q?rjUwQhBehcdHAFFzp0zmhrGRF+TW8ybbv4wxtIaLZZYTXd+yY90BiYeeMgKx?=
 =?us-ascii?Q?8LhPpsuLAm8LwJv23UZhx2sFIV0xtIRWfAfVPhAFSqFe9/U1LLFSj2TKR2Ar?=
 =?us-ascii?Q?rzc5tF+yQbl+Y6vHuzOy5Kn4T1O4BQ/ol/1DHXMTFbpfoUDnH/Dl6VhtWH67?=
 =?us-ascii?Q?8wPUiGcs7FItT9RWX4I6FdP2GXWRIRJA3j6qmHXs3YXnqbQ8giGIVclaYnrT?=
 =?us-ascii?Q?ECp1aEGxcCAGsp+SCqddVJEnnt4YwumqDsAT3A6+Pn74z9EWQmpgpHiQe8uL?=
 =?us-ascii?Q?yWpqbftQg5If4sW6okLWjjyOYfdRa7+znsfvXNv0SOTqkiVaFT6zc7xH0vnP?=
 =?us-ascii?Q?rLKZRcXrTj855neghsM47W5FjDh1PxE8HG2pxpb/TJoUh/UG15RuqR3WpQqq?=
 =?us-ascii?Q?sq44pfWZezcsv5Lp1HUIvA8hpMs6Vz9IIUj7r+1uRv/3lpnPo21px5ujCDYu?=
 =?us-ascii?Q?UhPpjW0LTjOCavaK20anr2Gl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3bb6f5f-3608-4b10-a4dc-08d971dfe62d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 09:14:30.7969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QXmuI1uSmjPRFMoeHUKcZe2zgvAFLJ+u6TBbre9OSfjl8KprTZRor80GGN6wH+qh7AKsF5gsCKiZEU/FATBLQnEUKHWYBehI+t6wRxNTQzI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1486
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10099 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109070061
X-Proofpoint-ORIG-GUID: 5RZUk_WSnwcBE2xNIXWrJwDm-veNUtC4
X-Proofpoint-GUID: 5RZUk_WSnwcBE2xNIXWrJwDm-veNUtC4
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Sep 07, 2021 at 06:04:03PM +0900, Sergey Senozhatsky wrote:
> On (21/09/07 11:54), Dan Carpenter wrote:
> > On Tue, Sep 07, 2021 at 05:06:04PM +0900, Sergey Senozhatsky wrote:
> > > On (21/09/07 10:34), Dan Carpenter wrote:
> > > >  
> > > >  		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
> > > > -		if (id >= 0) {
> > > > -			/*
> > > > -			 * Translate raw sid into kuid in the server's user
> > > > -			 * namespace.
> > > > -			 */
> > > > -			uid = make_kuid(&init_user_ns, id);
> > > > -
> > > > -			/* If this is an idmapped mount, apply the idmapping. */
> > > > -			uid = kuid_from_mnt(user_ns, uid);
> > > > -			if (uid_valid(uid)) {
> > > > -				fattr->cf_uid = uid;
> > > > -				rc = 0;
> > > > -			}
> > > > +		/*
> > > > +		 * Translate raw sid into kuid in the server's user
> > > > +		 * namespace.
> > > > +		 */
> > > > +		uid = make_kuid(&init_user_ns, id);
> > > 
> > > Can make_kuid() return INVALID_UID? IOW, uid_valid(uid) here as well?
> > 
> > No need to check twice.  We're going to check at the end.
> > 
> > > 
> > > > +
> > > > +		/* If this is an idmapped mount, apply the idmapping. */
> > > > +		uid = kuid_from_mnt(user_ns, uid);
> > > > +		if (uid_valid(uid)) {
> >                     ^^^^^^^^^^^^^^
> > The check here is sufficient.
> 
> My point was more that a potentially invalid UID is passed to kuid_from_mnt()
> and kgid_from_mnt(). I don't see map_id_up(), for example, checking that
> passed UID is valid. So decided to double check.

But you've seen it now, right?  The kuid_from_mnt() will return
INVALID_UID if you pass it any unknown uid (including INVALID_UID).

regards,
dan carpenter
