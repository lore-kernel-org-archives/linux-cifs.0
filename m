Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68576C32774
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Aug 2022 15:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242764AbiHYPaV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Aug 2022 11:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242785AbiHYP3w (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Aug 2022 11:29:52 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87215B9FBA
        for <linux-cifs@vger.kernel.org>; Thu, 25 Aug 2022 08:29:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mb1OWso3hAF53pTn/XHPUatVE2CQBt7EdorSqsGbIQLS4niXx3geYC1TQUBVQhNqPjRy322b64dgMsMpALfzUDA3NKRcZ8mZsW1j6ACZhnWbticCl0l4QW3pYgs1E0QTIgCM57AUhzTB4+M9Ogd1i5hiaztGdh9Pb9eO0DPKRDxpfDO4gNmtgojPB/euL1UEyCHjhBFZYzEuOj8fILnYdrFR4kW4TN63z/P8RHZnWhtIbKH+GT9Kw7vOARbzJ/sBislYR+S7H9W9jZ2K7a9fgZQUyLMUQUWxR4qS6FJ1MiUXf/iXzkBsOVXMmjEBg+TShGgNC1lNdVqMneMpHb0ekA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8/5ZxeOHCjYLrU5nj+QRxLzd9/s3JEgiDNY9k0YckE=;
 b=RA1VZpOcwxYIKuzbFxyRGPNlAvLq3WLNoz0QnysleKwIC2iNvVN5Gw52MT632Hx4GhCnaU+2lqM1W3y/oi/7uGA8CIXQsoIBxN+L/LSBSuswDXopp3Or77E5bXzWdn1gjJUaDNp+7nr1Z5TcWYPisH0DPt81akLYVDxFOAYdjdHYQ35ww31Cv6BimI90YxNc/bH+EJ7JxF63Fyac8CxUsoLyRgJjtWFs05twz1fdyOGnOR9ps1rzVnZocZUd8KbbNcx4Gb5mMUhhgTg7Xm9hPz06X7f+fGT+9eaYE31psGjnV6TI2opcGzlng+Lh1Ztpiullesuss7AxtcmPYfEGpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM5PR01MB2283.prod.exchangelabs.com (2603:10b6:3:14::19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.21; Thu, 25 Aug 2022 15:29:25 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5546.019; Thu, 25 Aug 2022
 15:29:24 +0000
Message-ID: <83e8820f-8ea4-5ca4-d902-109980254206@talpey.com>
Date:   Thu, 25 Aug 2022 11:29:22 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH 6/6] cifs: do not cache leased directories for longer than
 30 seconds
Content-Language: en-US
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
References: <20220824002756.3659568-1-lsahlber@redhat.com>
 <20220824002756.3659568-7-lsahlber@redhat.com>
 <2cc221b2-6292-ffe0-5f47-5dfd9dacc95a@talpey.com>
 <CAN05THQ9Dev9s44M_XfmxOr3HZxuC_L-FWC5pOa-qxnOeVfxDQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAN05THQ9Dev9s44M_XfmxOr3HZxuC_L-FWC5pOa-qxnOeVfxDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0129.namprd03.prod.outlook.com
 (2603:10b6:208:32e::14) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39851ee0-7297-471c-0bd7-08da86ae9723
X-MS-TrafficTypeDiagnostic: DM5PR01MB2283:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eo/KL6pwMbBmpI6nWuHu1Xa/m8QAxkom0gv1EiNxP10VHJEeEi6d0tLIQcOg0WW4Niw8tduJXm0RfZRon/+nV2PeV+4rNda9KIQ/XmGiwmHPSarbaf1oChaQRhsI3f2sp+6c2l/MNJyN9i1OKCWvGOABKEpLbnXNtt0Lo76a9GnMvVUhCceO6PRsjPzWbaX49eIG/b5fz3+wX50cPW6yB00a3Yc6EJrB81pib2843D81JQR5GLzIWc3IrB327nVGzzivF0CRe7kquCZaYl3F5v4lkIHFwEIZrmN9BHnLKki8GhHt5vh4ka9Tpv12vJoTcjcvnZEBD9EJewFT25Ddg3yFlu0Wdim6re4GzKi4KwUaPWIVAfe4E8Gjt1kwK7/P3S8tPFFJvEINBGIuO8ZjBx3x4hq2RrDiPDRpZwVOabJ53npv6lRrc+OSVkbe5YFvx0ulelHpODRm1GyyhevlUaAytHFbZlhbcQyq7MRoBjPMfpeeA7aScO0IPhxCUgenpyo6SGi7G2B613nXy0WTHiwHN3fNMTqmJ29L50jUMWZvWUEQbVwphk0VFlBWIm+XxZiZ1wccOjhngNqazYoDcAWFQdw4pAdNpWIms1jYUEs7TxQj9yNc3779czXr9Su4rvpQVURbJRINLS4tNfqamU1VfCh9IxJI8aWGKNU54KLj/lk2vNUoy9QgPdBVYnhanRToibeWUx2mkzISSU0/UgPVEcFCTjP2rAMIfpSERIEJ1qLcoB+zOhe4j5Q06WlzsJvBm3AAUjRLZYxjHRhe4TV0fEM7r0EXT9uSR6r/hTWB4uUunnrXDEplo4gAX2Bo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(39830400003)(136003)(376002)(346002)(52116002)(41300700001)(86362001)(31696002)(2616005)(38100700002)(186003)(38350700002)(83380400001)(6916009)(4326008)(8676002)(66946007)(66476007)(66556008)(54906003)(36756003)(31686004)(478600001)(2906002)(316002)(6512007)(26005)(6506007)(8936002)(6486002)(53546011)(5660300002)(148743002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUc4WE9Id3Y2ODk3Z01pZmM2QUNvTEwrSUpWMUlVSU00YWwva2pCcXJ5TVJ1?=
 =?utf-8?B?a3NEZ2JzOHl4ZHhRL3dXdHBLUUNjbFlVcjZjOVJvSkswSisrN2I4ZUViZm1D?=
 =?utf-8?B?VU9KU0VuV0N2bHhpRGU5S1k1N0ZIWHRkWW5rNk5CRkFoZzlaaExsRXRXaW5J?=
 =?utf-8?B?cmJvM0tMYy96Z05ncHluMUtiOHJvb3lLQ1M5ZGRZRmljMGs4Ui9QZXR2Mmd5?=
 =?utf-8?B?UlU4TkVOKzJ4Wm1pRDdQcnlnMHBxTlZVS3NQV0JoY1RWQmFSbGFIMVJFYnhm?=
 =?utf-8?B?Unk3aklhdGRhVmxzTUVzZmFwUEhacEI2VG1kNWJ5MGZvR2JuNWN0R2p6NDgx?=
 =?utf-8?B?VjFHbDF4SDBwZnBFTnhabkUwdlFSakdFejdEclg4SlVaaVBBUnRnV2tjdUhW?=
 =?utf-8?B?b3E4QVF2c3hZWmEwOG5aMHNQaTlvc2dBclRtL2d6RWlPSDY2WWxaeTQzbDU4?=
 =?utf-8?B?NVhUVVhTc01jWHkzOWpxRFhnLytWWElKekgzSW9GK05rVlhZYm1SYlJKckVx?=
 =?utf-8?B?WVc5RHdzS3R1K2lXNEpMc0VVRE5yd0JScVhpMkhDRkZhMGhuOFdlVENpZ1R4?=
 =?utf-8?B?cE9LbjRWSUplZTVIWkl0cGFiM0tsejFGMWUrODlDcTk1OTlOQXVlbFNZc3RZ?=
 =?utf-8?B?TFRIWlhKelJDZkdnR0NaaUJrNm8yZTBBWVA4a3lJZVVvd0dJTUN5a013bitP?=
 =?utf-8?B?OUZ2NjIvdURMa29XN0s2YXFnaW0vRWhCSW1OaHlYTGVLdythQVA3bDMwRWpm?=
 =?utf-8?B?NWZVY2hoU3lyOFgrazVqUDVnL1k4bjlmdzhsazdXbVBFVWdBc0MydkpKZmx5?=
 =?utf-8?B?azFPdHNCVkhKQ3JYNUxFYzNVU0FsdnlFSnNWcGFGR3NJQUk3N3ZuQUtIdGxO?=
 =?utf-8?B?QzZHT29ucnRPOXBDZnE4bXdOSHo5SXFJSGphMWlUTkNIYURvY1JoRDA0TjB2?=
 =?utf-8?B?QmQ2YTh5V1dUZXd2cnN5RGprK3d6QzRCNUNqelBVWkNCeUtLOXp2bjBlaWVO?=
 =?utf-8?B?aTZxc1BQdEQwMXdRWlB4cWdadFg0enU3OHhjU1FkZzRhY0RvVW5yU0tJeTZM?=
 =?utf-8?B?MHk5cHBQcGFGYkNVcW5KRWNHekZEaXhTM09NVi9BTFpCREZiT2VsRi9vWjBq?=
 =?utf-8?B?M2YxTk1hVHYrNVhtOGE0WjVHQWI4NzczeXVaeVFmUmw2ZEtIRDhnamhUMmZ6?=
 =?utf-8?B?YTdkTnZqdTBHZjUwNTNQMnY1RWp2bjdNdi9DVWxMNWlDb0VvU0xiNUIvSjVI?=
 =?utf-8?B?NzhHa1J0dzBOdlBQVW5yU3ByVUdZLzVjS3lLVG1UVGhHTy8wRFcxODUzejlQ?=
 =?utf-8?B?Ums2MmlybjNWeGpleHNxMmNMUWh0VElqSXVvbzFxb2dYZlFobndwMm5mVVBn?=
 =?utf-8?B?NnNQUFJkaVh0SW1QOXp1dFdGbm5kYVA1SVJBaXVTdTJwbFN3LzVjQ2VLVGJq?=
 =?utf-8?B?OGpxMGxyRjdPWThUZ1dyTGpiNkNRejMxRG5helNjcVJaVlA1R2l0a2NpenZD?=
 =?utf-8?B?d2tSVFprTFpscUVPa1FVOEozYXN2RGk4ZTcwN3ViZHpySUZoeEJmR2c1QVpk?=
 =?utf-8?B?V3AzZGdKSWtKKzFIdm5KcnR6anFtTGFrNEd0VVJCbmdtamN5SGhmUG9vYTcv?=
 =?utf-8?B?eXg3bDhJTXlTNTdZa3FEbGpCL1JtWUZzZTFRS2dWblVadFdqLzNEZytSdU95?=
 =?utf-8?B?T3YrQWI5c2tRNjZQMnpjemxyWktLNVFtZ1hvbDhRS1gyNDRYTUVhbmFrMm5a?=
 =?utf-8?B?Lzg1b3hTWnYrMTJ5akloRTgySHhyV2d4ZmtXZlNhSmw0YWQ0VzJ2OGYrRnFY?=
 =?utf-8?B?V3gxdmNhdzV3enQzYlhvSFcwSjF4cHU2MVhWU2R3TDJQRGViNkMrT0NSd0ly?=
 =?utf-8?B?dFJ0WmoxT0NhZGhtbXRnRWhuTm5CdURJM3BPa092VlJGeXBsekVURzV2dUZI?=
 =?utf-8?B?a05abk4xbmVTVzBFanFZNTAzL2NtUXZXQksyVnk0WGRRKzhpenhONlBML0pQ?=
 =?utf-8?B?ekFsbmgrN3libitRSlBaNTRPSUREWmxvRFdJQzVoMXA1Q1Fkd1gwQUZjNFZh?=
 =?utf-8?B?ZjEyOWVTWGpoQk1jMG0rWmtjRUd2NEVmYVdLdGo1WExhdU9SNW1INU12RGNh?=
 =?utf-8?Q?ov3A=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39851ee0-7297-471c-0bd7-08da86ae9723
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 15:29:24.7559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cnuYZBhQq/r0SVsPBBtQM5sFmVGbyrOQgTM2APbUZ+f2YBthE3hc6R5z8b26U7XH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR01MB2283
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/25/2022 12:39 AM, ronnie sahlberg wrote:
> On Wed, 24 Aug 2022 at 23:58, Tom Talpey <tom@talpey.com> wrote:
>> Is it worth considering making HZ*30 into a tunable?
> 
> Maybe. I can add that when I re-spin this patch.
> Recinding leases is super hard to get right. Recind them too quickly
> and you miss out on potential performance.
> Recind them too late and you hurt performance, at least for other clients.
> 
> Right now the caching is binary. It is either enabled, or fully disabled.
> I would like to have timeouts like this to be auto-adjusted by the
> module itself, because setting it "correctly"
> or "optimally" will probably be super hard, to impossible, for the
> average sysadmin.
> Heck, I don't think I could even set a parameter like this correctly.
> And that is even not taking into account that workloads change
> dynamically over time so any fixed value will only
> be "correct" for some/part of the time anyway. Sometimes these changes
> occur over just a few minutes/hours so a fixed value is impossible to
> come up with.
> 
> I think it would be possible to have this to be automatically and
> dynamically adjusted.
> I want to measure things like "how often do we re-open a directory
> while holding a lease",   "how often is the lease broken by the
> server"
> and try to keep the first as high as possible while also have the
> second as low, or zero.
> And have this adjust automatically at runtime.

Unfortunately I think the problem is that the lease behavior is
dependent on the workload, and whether the app is sharing files.
If the lease is never recalled, obviously the caching can be
"forever". But apps banging heads over a set of shared files in
a shared directory will be nearly pointless. I'm not sure how
you can sanely automate that detection.

However, it seems to me that 30 seconds is pretty arbitrary.
It might help speed up a "tar x" or "tar c" but is it broadly
worthwhile? Would 5 seconds do the same? Dunno.

Tom.
