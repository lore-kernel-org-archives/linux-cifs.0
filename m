Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E0EEECAAA6
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Aug 2022 16:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiHZQ4k (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Aug 2022 12:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiHZQ4j (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Aug 2022 12:56:39 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DA06F553
        for <linux-cifs@vger.kernel.org>; Fri, 26 Aug 2022 09:56:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mjwjI7KZz3zTS78sqdenieeoqxkUbwrOdsmPMzYVhEWy8eHjA2oWh9kMaNYzL7g/u5WS33U6SpCSEPp5tCq7icCspcs8r2wqewTsrNZkv4Co6m/Ily9/iTQNxC2Q9V3iD2b+3Axpc7l2xQmAzJt4AEjybpP6TnDYsmFDhnCRSTQzuw4F9nLrGUJ/EuJnTRWkcY/kre54z9f3dRy6xZ1MxU9HkMODk5WCeUyKsfwGq10u6d4MNM65HlraYCadFPHmysTypfZ1uIqq7P915IOTmCReGdN+AsvMIXPm7ZZL63eXBo3UwRgfOFDSKanNOggV5jMqmKLKyxFd6BBcO0dGnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7+SH9oQxXyzkFncWOMeT9571VwiniOlh1NW05e8zpjU=;
 b=I3EkgeFZ465DwcKTGOYifDTLTS8QOBZMQdG6JFY5zA5o3UcexmUiki05Tn2Ie/DJjsRxmO6gPuey8ORdfzPwUMxmwj75qhGmr2GlMAmgpM/1HaFRnvxAjIAp3NoCyR1kTUtdp1h+YwVymS5HojMwUv1xCiYu7a00Pwt9Jys42MVvg+t8WacpYMKTHtoexUtRlphd3M1pxpW6y29fByOkWxgcwUZR6uG7gLaicYvCtn0GinE5ePvVOJlauqHpP8VZSBFWo7n5pjWjIqx3foaTJxDNFHvjo6OHVHWmQ/ixikApzr13G7UWSjuQIEQlCdvvaQHHSTd8u09E1cMVz5QV8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB4566.prod.exchangelabs.com (2603:10b6:a03:a4::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.20; Fri, 26 Aug 2022 16:56:36 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5546.019; Fri, 26 Aug 2022
 16:56:36 +0000
Message-ID: <165e9b10-2f3e-dc88-029a-c8157a98f095@talpey.com>
Date:   Fri, 26 Aug 2022 12:56:34 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: SMB client testing wiki
Content-Language: en-US
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org
References: <8bcbba74-d6ce-3c40-4655-e67bf75f3b3f@talpey.com>
 <878rnb3vkw.fsf@cjr.nz> <93e55661-ea4e-7205-d310-59105bc767ed@talpey.com>
 <8735dj3sem.fsf@cjr.nz>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <8735dj3sem.fsf@cjr.nz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR11CA0030.namprd11.prod.outlook.com
 (2603:10b6:208:23b::35) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d486e76-8b72-46cb-c727-08da8783efcf
X-MS-TrafficTypeDiagnostic: BYAPR01MB4566:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mHPQgTBw8A656zJQv9TEcDYyR0/vXRNCefy3A+mFbZi1gtW3iJdeioCTlraciTMKnQnJ3ASQCLMfEz+lBBH5ARSG6e+ArXq7aOT9qZ1KBPd3SH2C8stNDexs8gdIeiuaNHgcYn37lMdITgfgDozG9uloYJOo/gOfQXkpgvYzXKIa9F4JK9lXAgtbAVuqMkCzdQNz7pXK4ht8xzprLMx9rt4ECLSLtFtlxpsrkysnZB7V+3nnY7fl9u6Hc6BOBP6yH+K3WYXTgonHRrwwRgrxC+tqqcCQvIF+F3/n4c7spyOcp0vuJrkpT1mmhqfjVWVcusdskQWJfWT3sE5MoFUyK9SLhHAPDMs02DEx8sLfuYG71IJp955B5qgSs4SClJMa+JMj0FjadQTZNU1G9pXlkz9088ugvWb6hLy0lxg6vljbWaRigt3dDU6byoCB2nUxobTN8OUuYKejYHZQdQcMiQhrEH7ssQLC/36lN03EHURGGor1a0NWrUpJed3ku+Dp3vApj50V0EUb5dDjuRZwD9Kxx8zASULR8dhsv+ha4FyflsK0myt3lTFpMBXNL8wJm+fh0B2G2wgEuAd3Ts35QTfhxbpU2YUxednGXRYp3og7QtIexu8jko1HwmG0bHljkkNyhOgXRngYewA8SYwLeKnh0PDWvhYj+3E+csb5f3uKnz8/63L1a3n6llJ3nk/Q/Tsoovq81+XQrXsVL5savT6ExJYJOswlflu14htLs5NdY6jlAAk/sSeZfmduS+bgbCzhXbqYIinf+lYjz1OllgisoIO1/S7aLmhccEomXaU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(396003)(346002)(39830400003)(366004)(52116002)(8936002)(4744005)(36756003)(66556008)(316002)(66946007)(66476007)(53546011)(8676002)(26005)(5660300002)(478600001)(2906002)(6506007)(6512007)(41300700001)(31686004)(6486002)(186003)(2616005)(31696002)(86362001)(38100700002)(38350700002)(3480700007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akQybnFuQW1HSXB4QXZCN3dmTytObTNuVkJmWmliL2xRa0NGQzh4b1pYYnYy?=
 =?utf-8?B?dTJHKzBiMldEM0ZlOVhKamZRNWVWRGo3R1ZTZDdDejc5RDZWYnlzYTlLVTRa?=
 =?utf-8?B?Q2M4U0tHVGVPRGFpaWNRTngrYjRiNlY4ZmRubkFTTy9odTlobUxkSzY3NVpN?=
 =?utf-8?B?RVh0SkkyTXVyVEdSMnF1QUlCNTZXcFNYNURaVkIrY1pwanZHYW05K3hYSlAw?=
 =?utf-8?B?UmtwNkJwWU1NaFVSNGVuMXJMZ0Q1Y1hWT3VrYTg5ZmNoQk93M01RZllvMU1p?=
 =?utf-8?B?K3hYZ21mNjVpbnFRTFpXaU9XQjdRcnltUS94VFlYemdZbWMvQktwWkdWVjJN?=
 =?utf-8?B?cSs1Qm80aml2WDZCdy9oZnFoVm9QK0lzblEwYnpLMVpmNmRaakZQbSs4aTRj?=
 =?utf-8?B?OUJjN2EyQk1aVS93Zm9EVmpDS3ozak5Ld0pGa2ZEQ3lDY2VPMlV0ZG9KZXJW?=
 =?utf-8?B?NHJuNkxUL0FTczViNXhLbmIxWTg5UTQ0OXRLZ0krdll5Ymh2dXoybXpvdGVO?=
 =?utf-8?B?VGRFVnJUUkM2Y3g1NEtsMU4xSTlTVGtCUE1iR3E5VWdrbHVyUUYxd3pvbGtx?=
 =?utf-8?B?ZnNQWGZCOHJ0RElwMGl6ZWd1V2k4Z2NGN2o5MW1abnM5b214Kzl5VTFVZktm?=
 =?utf-8?B?Zk9Rb0xjK2o4dk9lNWYzb25MTExKSDhzMDZhZVBsTDNBR2xRY3NsbkQ4M1po?=
 =?utf-8?B?aTVCMWxZK2RXM0xmalZnMnM3TG1xSzJBM2N3YnFXaEQ5dmRGOFY4aFA5RHpR?=
 =?utf-8?B?T2tPZFZjTE1Md2hzR3IyTEdsZHVpWGxUVkt4VlBEOHpDM09rL0tGVnViSmpR?=
 =?utf-8?B?K21JV1lNb0dtb2krU0owVGJDZDZtdFd0WlFBZUxJbzVxL3MrcXBGWU02a09i?=
 =?utf-8?B?ZEhhdnRjc0RZamt1NUo5YzdBdG1SdjhkWUhkZGE4ZlRUbW5UZW9QQVQxZUpY?=
 =?utf-8?B?NHJuNGRkV0g2RE1wSEVmbEl0OGVQRkYrdlM5cU53cVY1byt1RjAva25XM2s4?=
 =?utf-8?B?SFZNcVZpaWNidXdIT1Z1V0VQSTFqZ2Y4ZTFQbzU0ZFovRUQwTEFHVnRjWmgy?=
 =?utf-8?B?a0tSeVpvN2ZOOHZCZHFZRWpYeVR4TFR4aVpoQzRLUmIyOHhyZ0FxMENKVnd4?=
 =?utf-8?B?THlYTThNNGN2M2luenJON0VQVDVvMFZua1ArcTFuS0IyMnlKSFFuaGh1a0My?=
 =?utf-8?B?eTRMZWhSNlVCQzY4UmRvZGFCSjA1UllpY2RUZDg2aVUvWHhOMkJZUGR5RVQw?=
 =?utf-8?B?WFo5U1pWL014TmxkUURtVjdzaHBOanVqMGt6SXJPajZwajFyVFJDZW5sSFFK?=
 =?utf-8?B?YWgzRW9TY3M0TzdKcDRNallvOFFRSHVHWG5FVko2cGZGc1hVZGVPenhrL2ts?=
 =?utf-8?B?dDlSYjk3bkZiME5TN0dMWElPdU5Ea2QvaHBDYlNBWWVQbFlSUjExdU9XRDk0?=
 =?utf-8?B?ZUFidC9rUVFhWDBYMklyeUtEYlNxaDhDUHJZQ250cU15cEFXOS83aFpQTlRr?=
 =?utf-8?B?bjBzWXJVVlYraEtlRXNsYmlKeXRzeURRNjdNUXlNcmkzUTgxNnJXZ2UvTEow?=
 =?utf-8?B?NldoYkN6Z1IxRW53QkJoMW8xbkYwTnVtVlhEbW9KUUYrd2ZNV0dzbDZRMEFD?=
 =?utf-8?B?bHVERGpwaDNFZTFmZTNHdkVIQU5OdkMwOXM3UzY4R3ZBNWQ5WFYwVlI2Mm9L?=
 =?utf-8?B?V0srQTcrcVFWRnBWdDJWY2Uzd3c2Q0VwcDZoRlVucnVWd1Q1Wnptb0R4eStJ?=
 =?utf-8?B?clZXZU0zWXAyUDA4SG1rc0hVaVFCYnVEcXlwY0tPUzJrTk5JQ2hEVVMvOXBn?=
 =?utf-8?B?Q09ZNVBqM01HYTArZEMxa1phTmhWa0tJLzdNTTVZUjRNWkJOMk50V0duUmRn?=
 =?utf-8?B?YVU3am9SYUpIRDdWUUViMUFva3V3UzNaRks3bkZVZTRaT1FoM2EzSWVJeUtD?=
 =?utf-8?B?VHh5bXowYUs4WTlhd3hIYmJ2SWdnWFJUQVpFbjNCL1htLzRFNGQ4enpWN1pI?=
 =?utf-8?B?dCtPQ1pDL01tUG5YRm9yQUNRdjQ2aENnVDNHbHJlZnhFN1VZMUlrQUZZMUw2?=
 =?utf-8?B?NHc1MzVNQlJNbTZpM04zUHpzeDB4WkN2ZGUrSXJlZlhmc2dOSDlIOXdxVnZD?=
 =?utf-8?Q?amCE=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d486e76-8b72-46cb-c727-08da8783efcf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 16:56:36.1589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WG0N4FdBC1/Ictm2wuZjjQXhOHz8stnHhmyXfU6aNaP32ge8vIyHcLeksLtkBKkM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4566
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/26/2022 12:01 PM, Paulo Alcantara wrote:
> Tom Talpey <tom@talpey.com> writes:
> 
>> Easy enough! How do I know if it "passes" though? My understanding
>> is that a bunch of tests are expected to fail, or at least warn.
>> Do I need to test a clean client, then compare results? Or am I
>> misunderstanding, and FSTYP=cifs is taking care of it?
> 
> That's a really good question.  We have a pre-defined list of tests that
> get run by a specfic SMB version, server, if multichannel, etc.

Yeah, there are a few exclusion files on the wiki, but they look
really old. Also, I cannot believe that "vers=3.0" is the proper
default, as linked there!!!

> Steve might send you the list of pre-defined tests that get run on our
> buildbot so you can try it out.  He usually keeps those lists
> up-to-date.

The buildbot doesn't do RDMA, or I'd consider that. But it's a lot
more convenient to have a local harness either way.

Thanks!

Tom.
