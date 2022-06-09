Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CAACCA473
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jun 2022 15:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239620AbiFIPYq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jun 2022 11:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242859AbiFIPYp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jun 2022 11:24:45 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB3C2981A
        for <linux-cifs@vger.kernel.org>; Thu,  9 Jun 2022 08:24:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kfcjtdnmLoAmKCNkst4bgUA36oSbNB0zvy62PGj/08pb8jSSNovy0Jb/Q7WhnJ2wNO0PEP7NOpE/yRLGGBDnSlXtnVn/98pBuYdMyL3Ff7AUU/MyibtUK3Cmg0fz9Z9vKRWGea0Cy86d1jj4ZYiYqlU/b23Io/9uoYrZarB5evE68I9gJd+YfWwCQOSjqfX7hFJL1bedQV4OTHB4gMEQ6yJx5wfy1S/Ti5hyypkdbBbfT4jJsMD5R+adsDFskxzRck+3yMextz1b5SlxMlvXTAq4XgQ/mj64UJ/XoUm4A5I5NVShUUFOoIsncMslvKI4kHcoGtqzHMLbv/fWnAN0RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lnrll5xJpjsnEhR8rfW2yWl+bQTk6bZ/szgc4tg+gdo=;
 b=Hf4qvSr/FEJ5EiJmLsVT6Uy6prNpn+ykVWNskCdMIdZoKnzhyN52rVb0Ur6yq/zMfFahc29KruQ7E7BNbuvr3J3fWNnMinL0LttTfLhp5SMRS94Xr3wkJQ8xuqsCC8DhSMu1o60FORgEidOVCJfWbvqynVzBcOjBevnqB4R/7ieGU65choRVRgwBayRHGeigTOn/7OoAKVqrsvT6VngmXfGz7r1srqRJevW5WXBPrEdCy/fjgS5mITTxvxUwDcuWEN66zCYhKzprDAKV9zAi4q8WERy+rxPWFhH8GV9eTQlA/M3Pv0rlCpY2o19boz5reIlNhyaiWJrGc7+rRQL/Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MN2PR01MB5744.prod.exchangelabs.com (2603:10b6:208:196::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.13; Thu, 9 Jun 2022 15:24:39 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d478:8cfd:21ee:776f]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d478:8cfd:21ee:776f%7]) with mapi id 15.20.5314.019; Thu, 9 Jun 2022
 15:24:38 +0000
Message-ID: <e9cceeb7-ad21-61b8-ed36-ac7820559f07@talpey.com>
Date:   Thu, 9 Jun 2022 11:24:36 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 0/2] Introduce dns_interval procfs setting
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
References: <20220608215444.1216-1-ematsumiya@suse.de>
 <df02056a-3c88-aab3-f90d-2b5ceaa5bd6f@talpey.com>
 <20220609150359.5uioqx4eccfodo6e@cyberdelia>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220609150359.5uioqx4eccfodo6e@cyberdelia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0107.namprd03.prod.outlook.com
 (2603:10b6:208:32a::22) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78238e3b-f93a-4867-7548-08da4a2c2af2
X-MS-TrafficTypeDiagnostic: MN2PR01MB5744:EE_
X-Microsoft-Antispam-PRVS: <MN2PR01MB5744ADC94088213835F5A1FFD6A79@MN2PR01MB5744.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IltNCSpCzT+CQgE4Qpau1UXTsRS1gbJiUoeXY89AX0mW/tiAgbRFHm3mVkXBHs1I8PCxE5AKzMWRQJ7A5j+Jff0DmtJJAuqu3UrJjwxSuQ+zTsDqoqM9sIThcQef7tydOBo07MwSP4Sbi3K76L+sHmBsVcWomA+GdT9p6UKWI8p8agTYs4y1CNkN4Z0CfsJaN6q18VPUVLFObmfNtxUey+XcDt/YxK5CO912Gt9Var98fYXNAbdBkoDq8vIML0Rel8xSictTqP2pkzEcUvPYhqyjrTcn5q8MfFrmvRK4pKdLt5B+45uJfj8NUKjegC/RvEw5liaicQM1s9tV+zpvz2vL+MxqgaBYw6mbBu6mvz+Rd6z0Td4s0VMGBpjEklhO8UZxIg5L4i04XNgWmqz97QYCIMILSJMA5aOtq74Ab2Nkm9WAn4r3T1VVf4TuSVo5i49MG5eNNxCq+PMF38DCzpK8Aeh9dboTRdvovWHxJnbEritEuX5AfCwBqK2HLyqiWqgMdY6XCHn0J7MV1Oypy8etFUN5ueDMelHepGYvxJVkbWZFtwX8eJHib+h3wHH28MFstCIGg87swmGx+3qCprQtAtwJAzCxs9TnWzpyLBnVmArqJ2iTRvW6sysKEP85bkcq5VR0fqhCn1oL3/akyHobjeQuMZEeO+Wbyb16uE3IXXXodWB+NB73ViAvz9Phh9DO3OxxmQ/ZDI5EvwlgMbYss53S+rJ5pxBgujkOwcE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(39830400003)(136003)(366004)(346002)(2616005)(31696002)(6506007)(86362001)(508600001)(6512007)(6486002)(26005)(53546011)(52116002)(41300700001)(186003)(2906002)(66946007)(66556008)(31686004)(5660300002)(36756003)(316002)(38350700002)(6916009)(38100700002)(4326008)(8676002)(66476007)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1c5R3JjZ1VSaUkvYzhtTmpYUWR2SDR3RkhNRkN5aGkyRlhDaTdqZG1mVSt5?=
 =?utf-8?B?SHcrcnhvbFp0UzdiSG1nRmYrZEZ4SVBOckg0R2tEMFRpM2dZZzFUU3lLVXhZ?=
 =?utf-8?B?ZGdtV05tNzdGY2FnT2Z3T05KeURvZTU5dXVjQXhaZXpkL25NMkh1RzdUSGtD?=
 =?utf-8?B?c20vbnNRNTR2a0pONVFOODgwdUw5czZ0WU1kRVdEdVFOb2hUbkFSSStkTHVU?=
 =?utf-8?B?Z1RWSUE2Y01Rczl2VDVDbzFxN0lJQjBLcHM0Kzg1VC9kdHowZk5ud281OGJr?=
 =?utf-8?B?R1RBeENjZ2F5VGlycmpNWU9sU3NjTXh0VmRlb3JFYy9zWmhONUxYSnhTbXdz?=
 =?utf-8?B?aitUVUxDTklZc0FUQ3B5M2NzS3c4WDlzdnZaZFI1YnpBdWNrOXkyR0RVTTl1?=
 =?utf-8?B?cnFOcU55U0dEQ1lGSmZxemRBU0JNMFd1eFgzRDZsZEJSUDUrdy8vamNPcERM?=
 =?utf-8?B?bHJWYVJTSWEyNjlnc1YxcTJSdUlmbkloWkxTdFBMRVhmdHl1K3Fkc2lJbnNu?=
 =?utf-8?B?Z0hCMXNMUW5VUUlYdFRhTEFhT2ZWc0JZclBzdHNYcEpXeU1KczYwbm1Hc3NM?=
 =?utf-8?B?ZmtPcXptWkNLQTl1RWJMRXlucXJaZDBjaXdTY1JNT0tVN201c3h0Y1pPT0Zs?=
 =?utf-8?B?c3l3cHBHbVV6TnJGb0VWTk9EZDVsSXRzaDNUZXl5S09ham9iblM1RFVSNkYz?=
 =?utf-8?B?Z3FzSlpTMzJKY3N4VmI0N2pRT0JsTWxoSWJFT0JzS2daNStObVRVZFR5YlR4?=
 =?utf-8?B?MDMvL3BnbXVjb3VYKzZZNVVvbThEdjN6K3plY3F0V2ZaakNrS1lqVTg2VWdE?=
 =?utf-8?B?Wi8zaTJrcFgrcWRDZ2RtUE9ndmdNUHZacFhjU3l5aThMdzNwbExlTUVZUHVV?=
 =?utf-8?B?M0tHV3drL2Y0RHduMmtORWtUMzFnTmR6VjNuNzJyQkdXMktMcVRVNGZna0tr?=
 =?utf-8?B?b1pxSHJqRGZnMmx0S1dPcitwc2x1eHNsNTNnUGRBc2pVbVBmOGQ0RklQRHYv?=
 =?utf-8?B?bnZYWHR4MVAwZWV6LzNtZmpMT3dPZkY1OU85aFZyZVVDZWpFbWdhZDdGTC9T?=
 =?utf-8?B?dFJxT1VlZHBoR3JkWFJoNWdiZ2VKaWZzUlZwdk1sclM3dnh4ejdKbm9nYXgw?=
 =?utf-8?B?c2dMbFB1U1E4N0ZHQ1h4c294U0RkQXBvaGZENThpVi9nalhGYWp0U0IyVkNt?=
 =?utf-8?B?QUxoTWU0WUFvZTJnRGkwOGZ1QmRZWWI4WTJGQ1BESG5yWnU2aldINUdtb25i?=
 =?utf-8?B?ZElsOTUrV2ora080Zkt1ZkpQTFZPMWFLNWFRQS9nY2p4MVBxL3QyTFJOSkkx?=
 =?utf-8?B?YnFJYkNSejdjWUpPQkhodW1lZHdQeFI3cktGWDVqN0pmQ2d5NWY4UW5lalN1?=
 =?utf-8?B?RnZpak9FaUlkNzhlanBWbU1uYVNkZ3Q5UitGb3FPa0QzR0FDS2JmeStacThG?=
 =?utf-8?B?WjhBMlp5NXV4YlAwWC9Xa1VGb2twZWREL0pWU05VckpvQVo5dFdyc0NSc3A2?=
 =?utf-8?B?VzloZnJxVlFsaHp3dkFML0liV2tMbFBENmVNQk4yVllOb0tHeFZvQi9XdlFM?=
 =?utf-8?B?MExONXF0ZVhBanpvL3hNbUUxY3NkMC9RQWllM1FEYXI5ZEpiTkJJMWMzSlNS?=
 =?utf-8?B?MHo4bDlJVXRxaE4wbC9KSVRRQStwbDVnOXh2aHdqL1dlT0hTTjVMQlo2ck1F?=
 =?utf-8?B?RWhKTzk2UU1XY0EwcmpWa0VwWkhpZWR1WE5Pa2hzelFZVDhBTkNrYjBpSmdI?=
 =?utf-8?B?dEovaFhLdTV2WUVVOXI2VVFVYmJNd2kraGtDbitXYWJNZVcrVlBrTVFyaHQ0?=
 =?utf-8?B?OWNRUlJRbGtvRWpGN3VkOVFGU2RuV3RwVDBSa2JoUE5lblBhM2w5TU1YT0E3?=
 =?utf-8?B?QllscytQT2Q5K1Y4MXh5T2JucEQyVEIrWVdQMjdyNTRSYitnQ25rVlpOZ2VK?=
 =?utf-8?B?blNMdm1mM2ZZbjN6U0VXK1dDSVBlSldTSFNtcW5NV3BjZFJYanMxUk8weFRX?=
 =?utf-8?B?ZElzMEpPTDNCbzhpWGJVU3BMR0ZXR01MUXFDNExXZi9UM2V4c0lXU21PRnNU?=
 =?utf-8?B?K2J4Q1ozcW8xZ2hvenl0UkhNaEl3RDBQZWQ2TWUzVXBHMTZ5WE5FNHVLMmdG?=
 =?utf-8?B?MGhuNWdORFBpSGxJVzh6NEEzNy9KYlFuVGVRU0o3UFNYQ25IbEhQbVZ1N282?=
 =?utf-8?B?NmhyK21IMzdFU2lQOEJOSG94YUY4Ung0R1NQanR5ZkFsNTNkRGl6dGQ4NmpD?=
 =?utf-8?B?MjYxSldnMDhMWC9iY3hKemtOaHZXMUFRV25yZnE0UFQvTktFV2hxejY3WnZm?=
 =?utf-8?Q?hzlzhC5pQo0m7/31Hc?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78238e3b-f93a-4867-7548-08da4a2c2af2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 15:24:38.8083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kChPYAS6rnJofY4gdo+mt/I2Ui4SFmU6WKzXRSE6xT/ukDUTUxwohpr34DJWMg1/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR01MB5744
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/9/2022 11:03 AM, Enzo Matsumiya wrote:
> On 06/09, Tom Talpey wrote:
>> On 6/8/2022 5:54 PM, Enzo Matsumiya wrote:
>>> Hi,
>>>
>>> These 2 patches are a simple way to fix the DNS issue that
>>> currently exists in cifs, where the upcall to key.dns_resolver will
>>> always return 0 for the record TTL, hence, making the resolve worker
>>> always use the default value SMB_DNS_RESOLVE_INTERVAL_DEFAULT
>>> (currently 600 seconds).
>>>
>>> This also makes the new setting `dns_interval' user-configurable via
>>> procfs (/proc/fs/cifs/dns_interval).
>>>
>>> One disadvantage here is that the interval is applied to all hosts
>>> resolution. This is still how it works today, because we're always using
>>> the default value anyway, but should someday this be fixed, then we can
>>> go back to rely on the keys infrastructure to cache each hostname with
>>> its own separate TTL.
>>
>> Curious, why did you choose a procfs global approach? Wouldn't it be
>> more appropriate to make this a mount option, so it would be applied
>> selectively per-server?
> 
> I tried to stick to the current behaviour, while also fixing the issue
> of getting a TTL=0 from key.dns_resolver upcall.
> 
> A mount option looks indeed better initially, and that was also my
> initial approach to this. But in a, e.g. multi-domain forest, with
> multiple DFS targets, the per-mount setting starts to look irrelevant
> again as well. So I took the "per-client" approach instead.

Ok, I guess. It seems like kicking the can down the road, a little.
I agree that rearchitecting the DNS cache might be extreme, but many
distros consider procfs to be a user API, and they'll require it to
be supported basically forever. That would be unfortunate...

Tom.
