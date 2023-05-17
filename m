Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E38C77B7F
	for <linux-cifs@archiver.kernel.org>; Wed, 17 May 2023 13:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbjEQNYm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 May 2023 09:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjEQNYa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 May 2023 09:24:30 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD2C76BF
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 06:24:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOf52Db/O87sbGXZOuea9JbHZ1gpUaPapstMd+kCIcTYUd5ewEsfVAOAG44OGqCdZsw/3UVRo+j3pLCDqeD/TeEU3PDS/DEONePn/EATUZzidWoEu/K9qV9Za2L/8tDV6a8lqLhoB5I8t9tih2do7N3F/0nGDzpX1Co9qZRIxEk+YhRlFpAB1XihWWIhKxaP7XeLwocxxaN0DUdCawv6XxKLdlTER0vJ3UpQLXXqA8fcOjqvuc+jNHQz+PuopFx9M9542KLZihlJdZnn0Qw1YRJA00nd+5ylqnIGxhXvuXeftYgCKLX9C4JHuMZP+U7sOBwXUJpStvmPR06OEDwIMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PATtYC89sdpRdPDWFNvxSzESGX8ybG753yIZ5KIMl9A=;
 b=YzWen9V54JE1RsYB9O7UMseeffypVRwLYq3XEk84wu1CkPO+FCGcaUv98Kw5VrCuHcjvAjpIWGHmjK6ZKXmPrm8kjfeZyeyCyJoWQvBbkrn7KQ4jkZLs4vONF5JIFF6WNBElP22M+a08FyRiut2NOcUtGocnt2ozcja+GHUm0fmxkEZWv5mYyz9kbu2eWp2DjTiSbEFS8EmrW/lrAaNMnjNPfN2hur/HrvF+Po6JvPZttAC4/M2pDtmZkoZeRmLzDp2nbzLZfnP5P9XnjtsHDO0DgtTWpeQTuRGrVEl8yWdeJxl3K/x8rVixcp6QW6yBA+RKFQrhas1+X5uwYZpWRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MWHPR01MB2496.prod.exchangelabs.com (2603:10b6:300:40::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.17; Wed, 17 May 2023 13:24:20 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::ef26:464c:ccdf:ee6b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::ef26:464c:ccdf:ee6b%6]) with mapi id 15.20.6387.029; Wed, 17 May 2023
 13:24:20 +0000
Message-ID: <193b610a-32b2-fe39-2cec-47724ad7d608@talpey.com>
Date:   Wed, 17 May 2023 09:24:18 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] cifs: Close deferred files that may be open via hard
 links
Content-Language: en-US
To:     Ralph Boehme <slow@samba.org>,
        Ross Lagerwall <ross.lagerwall@citrix.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Cc:     Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Rohith Surabattula <rohiths@microsoft.com>
References: <20230516150153.1864023-1-ross.lagerwall@citrix.com>
 <55740ab3-e020-df8c-07bc-02386486539f@talpey.com>
 <DM6PR03MB5372810EDDBE8C9A5192B1F3F07E9@DM6PR03MB5372.namprd03.prod.outlook.com>
 <8c79fa5a-d84b-13dc-73d6-27dbbd21dbfa@samba.org>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <8c79fa5a-d84b-13dc-73d6-27dbbd21dbfa@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0428.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::13) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|MWHPR01MB2496:EE_
X-MS-Office365-Filtering-Correlation-Id: 85413357-c987-4837-cc39-08db56da05a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ulVSzsKavzbrRYS/TO/9wueDRcGgozJwyoYNa7ASYs15YItMbSpiCW/HlmQf8T+TotURfP9QoKVAS+14jM3TIVlB5z0tMBAOiazkJzQQX/LMQIAGpumhTKp/ubghjzwSoXq2R7XTRaI/o8roEofDnechLtgrfYWestlOtSNl1SOy9r3vbfsIYIIH52IcU3EKgD7YYeeWFENMTxABd4JrJ0lcPXSKLB4aKYN1jarT3RD61GWm/Mv1g9CzObq8Mel2b21+m1ti991ojKnv4QXWDEezr+LniBcKynWsZND/OdW6myPHj+UXcWGmOlE6C01hY1soJDw2r7KycWARnUn9U95pxePbClrV/IJfv+3LZulvx7qKTO8JLlfWEEhgOKsQg0IkvUoOnL2wM/cHM4aM4a3edj5BSWWMXSz37e1gL1E8agX/zaYT9TUZLhaD6FCO7kFnOSm3W58j1pQgLEE5JjubGZAS6EseeS6LmQVmoMR4x5p1nw5jkbtQx9k8daDRGM9R1bQFgxlku0NOYhI0ncn5kPApOdH5dlr+VxJGuipZufSIZH6mnI21UhvzVwO9WdwQJZeQFEJmmtZvVHlqk8DIFlHUp7p7GAjBC0Sg+6YFf7uzSpZmj85QRJcCtMBHE1UtuqyLvQON4GX3XvkdCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(136003)(366004)(39830400003)(346002)(451199021)(83380400001)(52116002)(478600001)(6486002)(110136005)(54906003)(2616005)(53546011)(6512007)(6506007)(26005)(186003)(2906002)(8936002)(8676002)(5660300002)(36756003)(41300700001)(38350700002)(38100700002)(4326008)(66476007)(66556008)(66946007)(86362001)(316002)(31696002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aENtb29HR3BxVkRNNDhOUlpwSHJmT25qckRmUXAycnFWVzkrcGJ0aEhxN3hI?=
 =?utf-8?B?WlFVQ0pzV2I0VzRUMFJkenNteFcrMjhvMlZ4YTh5RGN0S1FOS1VycjNwQzJ6?=
 =?utf-8?B?YkNYMURKSTV0S0o1ME15K0RleFd6Q1dBYVh5eU5OSjJ0V0RQcEJhbDJhbG5k?=
 =?utf-8?B?Y0lVaDlrcEx3VkF1M21RQU9CamEwMEpLTDRVa2NlZmJ0SzdObEswS1hzYy9I?=
 =?utf-8?B?ZlpMVWQ3WTZMZjZxTTdXYjhoNU1oaFJNbVNYYlRhbVk4OHdteVhxcVhtK1ox?=
 =?utf-8?B?MXhZcUtMQXdqQUtWUGJBUGlaRjFNbDYyRmExZTE4RUZIS2dDZG9JNklhdWo3?=
 =?utf-8?B?R2g1dXJpbHptZUsrK1JaV3lkaDRzWGtjYTBjUFJuREJ4RE5sVnI5WmlDZURj?=
 =?utf-8?B?V09DMjhwQWo1bmdKUWpvRms2TXVLYTVrQjc0c3dEd1VWQUVLL2l3b1ZiWmNl?=
 =?utf-8?B?bmlNbU96eG4rUzNyUVJBeGR1cjVNc0xTMG9QNnJQTXlZQjhLczkxUmZxeXB2?=
 =?utf-8?B?b2Z5a01NN1ZPd0E3QklDMjgyblhWb0xVUUc4bEErb3BPa0E2dzZxczV6TmVV?=
 =?utf-8?B?RDV5c1pITWsrMXhpNlBJL0hFZUtjQW8vSzdtWTRvdmlPMnpQNmxXUmg3L3dV?=
 =?utf-8?B?K1cyY2Q3cW9WaW91cWdEaWcxazArbUU4M0gxZ0hmalE1K3p3VGIvRkc2Nksv?=
 =?utf-8?B?ME9wenBXYU5Ud2NTM3B4NTFQZjg4QU11c0JTdno2RVBFUFhyZTlCT3ZOYjFZ?=
 =?utf-8?B?bFJvZFlTaG5HYTdYUFNTcnl3dWxvUWJGVkZkYkVvZE93Nm9NdENZRHdadVJM?=
 =?utf-8?B?NmdMZDVJY25ETmJ3amd1VFVNbU12N0R2N1NKOFNWU1IvakN6NHdyb0Rqd2Yv?=
 =?utf-8?B?MERDL3ZOSjhhVzd4Tys0K3RHVGs0ak4vZmFNa01tL0c3V1FUaWFpS0VwdSs5?=
 =?utf-8?B?ZFNrTkVlQ3JoTkxSbHdBY0h3dDAwZkYwekVFbEM4blNickNIWnV1SUZEcWMz?=
 =?utf-8?B?K1JxT2luZDZtK215WnhZZFZSaEEvc2djdmJwUWhUbEtIbWRydUcwL24rdGRv?=
 =?utf-8?B?Zk5zVDlwdjAxQjVQRHJ3TlcycC9NeUdqaXZzUDdJL203MFFLeGNhTktQNEVP?=
 =?utf-8?B?elE1VFdZdUJiTTA3ay85VDYwaUY0SmhtSkRIR3B4N3BsZnJ1eGhsS1FCcnNt?=
 =?utf-8?B?MExLdGV6V3d4UkRtL3ZpRitwelJSV2xpNXZSdVdEalpvQ29Nak82aGpndFVQ?=
 =?utf-8?B?TFVIMTBHY3Z0Mjg1bFhEL2MrOGFhNTZBaGZKb0F0RWlwdkFEUkZRQ2VvWXlR?=
 =?utf-8?B?SmNrVUI1UHR2bkJHVG5sNXBtVmFtQy9aa1B3bTV6eHlRN2pZSmJzaWlTejdM?=
 =?utf-8?B?SnFKcE9XWWpvQ3JLZWlaK2dFTDNBTEZzSy85VTJ1S2d1d243VEVsSE94VlF4?=
 =?utf-8?B?bDV4cnh6ZmVqMWpQQ0tHaklmWmNTRkw5L2tIMjZhUGZEK0N0MWVxMXJ4S2hV?=
 =?utf-8?B?SVV4TjhzNjhiY2hIV1NCMkEvM2VwNk5kaFBRSjF0YldsNHlKdUIxcXFneGVi?=
 =?utf-8?B?RTNSRHBQa3ZGc1paMDc0OUE2VDUwSjdCak9DNmNUL0grSEtIdWwvY2Y3YXhH?=
 =?utf-8?B?YVNXK3kwZjdnTE5YSklFdlAwVmtDZ1daOHJSeWNhL0RMWnFQUUEzZkJRam5I?=
 =?utf-8?B?WUpIbHArQ0xzRUQ5ejBPVmxuaXJlNlFiZG95RTFWUlh2OEtjZzhQV1dKNGxY?=
 =?utf-8?B?a0cxSllhZndhZW43S3M3YW1VYmkxMGVscTRnRG5SeUsvdTZLZEw5bm5JTVJv?=
 =?utf-8?B?QjVNaG5RMGI2a2RlcUZmYlBMalNzay9NRXhGcThIb3V2QU9JK05vYTlCZ0xX?=
 =?utf-8?B?NkJZOVh2RURMOEVLMVY4Q0RQY3RSNFhET09YZWJqUE9IR29mclB5RXRMbWFE?=
 =?utf-8?B?N2tmeWVzTGNuSlVPeFZXWjd4MlF5ODdOK0NBakp6LzBlRzNwQlozLzJTTjd2?=
 =?utf-8?B?Vk1UditIUGhISCt3WXdZeEtmQW9SS3ZvSmQyaWdDQ0ozWU1KbmYwYkJmZWxG?=
 =?utf-8?B?VFo2OVptR1N6dnVPYmxCNXRhK0wrTzJnQWZsNVhCRUtsMkRSMkJnVG1NUmxU?=
 =?utf-8?Q?SKFwlmHt7kwqVdwvXfGzd4+MO?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85413357-c987-4837-cc39-08db56da05a4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 13:24:20.3144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ThjVXD4142FmQJ433tdd8hzqnKNncftproW4e0t3Jn/Lu+8ATGfcDxtpWYDuMNT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR01MB2496
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 5/17/2023 6:50 AM, Ralph Boehme wrote:
> On 5/17/23 10:27, Ross Lagerwall wrote:
>> In any case, I have attached a packet trace from running the above
>> Python reproducer.
> 
> afaict the STATUS_INVALID_PARAMETER comes from the lease code as you're 
> passing the same lease key for the open on the link which is illegal afair.
> 
> Can you retry the experiment without requesting a lease or ensuring the 
> second open on the link uses a different lease key?

Indeed, the same lease key is coming in both opens, first in
packet 3 where it opens "test", and again in packet 18 where
it opens the link "new". So it's triggering this assertion in
MS-SMB2 section 3.3.5.9.11

> The server MUST attempt to locate a Lease by performing a lookup in the LeaseTable.LeaseList
> using the LeaseKey in the SMB2_CREATE_REQUEST_LEASE_V2 as the lookup key. If a lease is found,
> Lease.FileDeleteOnClose is FALSE, and Lease.Filename does not match the file name for the
> incoming request, the request MUST be failed with STATUS_INVALID_PARAMETER

Steve/Rohith, is this new behavior in the client code?

Tom.
