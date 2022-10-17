Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB014C4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Oct 2022 21:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiJQV2z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Oct 2022 17:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiJQV2y (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Oct 2022 17:28:54 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5508D7C32F
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 14:28:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JW8N3qRGDKKmdbfAknqjveKtiWyzypv/hDXdNizf3ySYExweVvGe8WYtfgiRLrd+PMjQ2r5eMNMcqGVp9tUG6FHUmGm0NmqLKmrckgt2VbQLk1Jh6AE2My0uCAy7gFgj67PmO+HMKO81OSPie0hg30oBG++ADPozIci1Q3LBhGxZ8kyWXRq1PoIV41M9fdENryUk0TP2KRE8XXKV3T1bicOyU0W6XI3CTxIJhGhWqLmjSKHzun6A9zSjSfZ7xS90NbWvq0pBA1n/oMlREOnm/NnrOehyoCdFMBzqDbWIaehshIFAW71w8Na7yqbXSozchbADE9p/yg3kEihXcu6qUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M9T/bjqrg3zCm4c2DjDCqDK0ht0JrHbRy5/k4l7zHyA=;
 b=XVYfXiQklJUNHWgYxq+RkDW+VCdCkDsT1UWZBqBAb2XAliS7xDJg57t1iiNTDmLUvpgNFIp2WHxr1uiJcggrZ3xs0ggaG6Zb9O18qwRceTTXcCZmk/3c0P/TZPK9hULh7OouQESFa+pMJP0Jj4KeX+Syo1AtnoDwS2Wteib9megkni/EWE9gQN8U6DVz3D26kMYfEDs5CaIFJ5TNlLyoaujadQnz0ZhpZzDyGp1uRNjIGFZf/17HErvyL82NSCvv7eCX1EtDVomWepqJwpYM+o4+Gf9dko4u7fNnpAMoP/phR3vfLII0LHHX03Yp439ggdyogX7A7Jx22DPa44XeuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN6PR01MB4174.prod.exchangelabs.com (2603:10b6:805:b2::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Mon, 17 Oct 2022 21:28:51 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef%5]) with mapi id 15.20.5723.032; Mon, 17 Oct 2022
 21:28:51 +0000
Message-ID: <ed5577b5-3fc2-cfac-8ea8-e8f425a47069@talpey.com>
Date:   Mon, 17 Oct 2022 17:28:50 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH][SMB3 client] Server interface count incorrectly
 calculated
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>
References: <CAH2r5mvf3zjMb3=ceL9wknZhMwp6CrOQEyzZ7HaXDNidYpLCBQ@mail.gmail.com>
 <bc73fcd9-3a30-75f1-5745-94f0e2509cf4@talpey.com>
 <CAH2r5muH+n6TYS3_O9pbwREWJ_GYuva_PvOLd88pxG+t9kVeCA@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5muH+n6TYS3_O9pbwREWJ_GYuva_PvOLd88pxG+t9kVeCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR01CA0008.prod.exchangelabs.com (2603:10b6:208:71::21)
 To SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SN6PR01MB4174:EE_
X-MS-Office365-Filtering-Correlation-Id: 49aaec53-cec6-4de0-79b0-08dab08695e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PZbXnT0q115ATAtx6mBIJ5DcYwdCSRr8mB65cn42K/y4H2RF3vdoap3WdWiS1aox2YfyGVeNp/12z7gwjN/XuyzRH3jzyVnLPXxuQImcNACE9w09PSseuOShK7qSh6vDp111sZoSn/odvT4CiQ86tOhEYAy0K44NV18SlzcUG4Cdl+UfoEXZhYXbANkmxSidYX1ThCEDm/WqE+VaS4+iUSqFA4YwZRaRYwcCvUZr9nypeEQRrIi1N0WSdoOUqC9nts+Ds241CInfBjMt3VzlERDIu3QZP5DtyGb3FMA/RNky+hYNZn7fOa4aNg+4DIwsusqa5Ez+deZurzS/x+mardcK/vWCjmd7imqya7O/ppULpZnQ0CLizeph+3e58pU5m3IkW8fnTDpQZue/RuJy+eO40KSBf14EN8mPYqtbb5mvVWVwk+ICL+izWnNFnorbkXU9ytVH7oH4pXljhizFrs7CLoSkM//ROWIytUCb2C4Fwqv716AADx8SB5svtWr/S4FRNO198Nxbn30ZNoJ4+MwYdXgV2j8IvAnMlXejc15/5mBaso4ecntWYZ7UvJdlqL5nuInBitPf9DJ/GuNKJaqzz+Sabd0MtTNk8n6rBxHmON0U3JXZzpWYjD1BttIoDwM4pGpSp1hvEPUwYmEOq7UKDXnr/jiGTmW1qofZ9sUgWlw4mR/6y23x/ljffOOkPC43fZwYkt41PGzx4KBUHfudW9mNkpMhmtAJ09SGA/n0b4EMnIPDaAcE0SLSg4x3R/Sc94tdG+WCg6aQujQu6oYN5X2rCfjKy8NIsr1IrUM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(396003)(136003)(366004)(39830400003)(451199015)(41300700001)(5660300002)(2906002)(8936002)(31686004)(36756003)(316002)(54906003)(6916009)(66476007)(52116002)(53546011)(478600001)(6506007)(6486002)(66556008)(66946007)(4326008)(8676002)(26005)(6512007)(31696002)(86362001)(83380400001)(38100700002)(38350700002)(2616005)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2laN1FibU8wc3U1ay9KZEVFTE5FQmdwTlg3TlovK3lKdndYQmlPUko2M3RT?=
 =?utf-8?B?SFZ0QXViQW8zTFBVcURwNnJ2NXZRam5nVDIwblFrWEtrVkxvZitMeVM3cG90?=
 =?utf-8?B?bWJJSFNyRmduZVUzYTN4QkhTekpLOURBdDlnQmVGOGtoT1BOL21SVHhiMnhN?=
 =?utf-8?B?N1NWZ1MwdldFZ2ZDVkh1UmZ5RWdiS0xhcjBoOUVNVWxKWFFEYTNBVzFFejdU?=
 =?utf-8?B?N0crSE5lMSt1T0lwTEZBY2laNFQ2VExYbW1UUVJVZXYwNFpGZnNkK205VHpK?=
 =?utf-8?B?eXVEQzhFeER2RTZmdWhRdUp0TW9KNElWdHlPVXlvbVYxY1U2MEZQK1E1S3RJ?=
 =?utf-8?B?VkxUTXFKdDhxbnhHejlZTitHQVkzU2RkODlxSVFFNDNhUFdqa3FPbzYwNGtp?=
 =?utf-8?B?L216ZS8wbUEvb25LaitDanR4RGN3NkxSTFhIbWZVUG1COGdST1JOdEtXUURD?=
 =?utf-8?B?WXlvelhxa01QbnZrdWJFWXlqRGlEWlNjOC90SUcweGlrbmx6Zkk0b2pEeXpK?=
 =?utf-8?B?OE50WWExRnRreWtGUzFPaDBkeGNINU5IQzhXOGFyZzkwdVE4VXVlTnIvWEZS?=
 =?utf-8?B?Y0NzSDU5akprVGR4UG8wTU53UXRzbldtdzdBNW0zb0RsT09JYU56R3ZhZEo1?=
 =?utf-8?B?YWFXRDhWcmtiUjZFaGNPKytINnMrbC9EbUdoblZlNUhTVnp2S2FvcnVhTTFk?=
 =?utf-8?B?OXpuWjIzOU5pcG8zUUk4UXNBYnk0NEtFN1ErQ2lZVFhBZGtta3VDdHNzb1JS?=
 =?utf-8?B?Z0lvNVB6U09OSllYakxUbE04YWxYZEtjQTZVOElsM2M1RndGZ1g2SmJ6WFpo?=
 =?utf-8?B?NEdTeEhsc09YUDhJSGcwMVhLdVMyc3hGL3F1RnY2c1FOS0EybFNjaGYvYUNx?=
 =?utf-8?B?NW0ybklLZEtVT25scUZkWUhaMnpUc2VKVzQvd1FJQVhqWFhvbDZNbkROeFA1?=
 =?utf-8?B?MXdUak5BSE0vcFV3eXVja2pES2tYUkh0bDA3QlZUOUovQys1WDZRSUtHVEhk?=
 =?utf-8?B?ekZrT1FvdDZENEVYRVRUUExXZ1A4SmQ0Qyt3SmdyMFdseGVEcVR4NEQxZm5W?=
 =?utf-8?B?YlhCMUowVkxnSHN0U2haVVlPdEc2WGlBTFBkWURpeU9DbUdqQVN5S0VPT2F6?=
 =?utf-8?B?aEVUeFBsdXRsdnhHck9KUkdmMFl6d0s0Sm5BalozTHZYQ0NoWVVldUMvN3ha?=
 =?utf-8?B?UzljNHdqWHl3Q280Q0xuSDhSSElQanYrZUd6Zi8rVkR0a2I1TUlIQld0YjFQ?=
 =?utf-8?B?UGhBUk1TVVhIRWpkRjczMTc2ZnVQcHlFcHVMWngrRFhwQk04UmFvM0dtQWUv?=
 =?utf-8?B?dVpOL3hOV0tveEZXY0pQQWIySUNXSnR2aXo1ZzdkbVBWSWdiV3A1Z1hCSXFy?=
 =?utf-8?B?WkZ6YllPakw5ZlZWbmtIZWVrRDZSQi9OQzZJTzQrT0ZlWUVDSkhnTWVmRGRz?=
 =?utf-8?B?emRTdFR1d1BwaXdWU0s3eHB2cGFRL05RaG8yUmpVYzQzQWl5M3orYlpod1Mw?=
 =?utf-8?B?YUN0SHRORVQ5TUhDZzh0cDFrTmlYYmE3cE1zN1QzK3F4cTVWdCtuZzM4MVZI?=
 =?utf-8?B?eGxodzNIcTJwUG9QL0JmOXcvaHQxNmdPdDFucVdpRnhsUXlHMGNDT0cvK0lj?=
 =?utf-8?B?VzNJRWp2Zm9xdWcyN1lqVFhTaURsNmppYkF5L2w2R2haY3RMNFV4bnJMdG1Q?=
 =?utf-8?B?UmlYL1U3L3JQVSs1L2krYmNnNHpEL3VMaDFhbXFHOHE1dzNEVnVpT3RlbUpG?=
 =?utf-8?B?aWZIRFd6N0NGbVlTQW1pRndqRUx6RjkwR3ErMzdtOWpoQkl1aGJPanlJY2dq?=
 =?utf-8?B?QjhLZjFKcHY4UnNEL0pwL2lLbXltaWFENStQNzZuZ20rTVd5cndqMTU1bXAr?=
 =?utf-8?B?a3Nua0V5cGNTT1J0QnJkQ2RCSjdzeG53RzdrTDdjYlpSL1pDRnF6enlWT29R?=
 =?utf-8?B?b05sSldKYzFmVnptNTBFbkJhQ0Z5MlVXU2dFTWI2SzRSS3NKUEpVZS8rOHM2?=
 =?utf-8?B?Y0U4UU9Sbm55cEJOWnhKYVU0d2VzU2dqRXdTWFZEamswS3dtcjVrTXU0K09U?=
 =?utf-8?B?VjVNd1EyTFVVNVpHdEs1akV4TXN3MllzSThVRnF0Nzg4Vll1ZndhS2lTZFJu?=
 =?utf-8?Q?S3Uw=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49aaec53-cec6-4de0-79b0-08dab08695e7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 21:28:51.4990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jCm2JwYtCLfJwlMPvusWAHvfoOFXH5cTt0UnaEZZC3XAuFnt4LYgbmQH28s5KTY6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB4174
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/17/2022 5:26 PM, Steve French wrote:
> 
> 
> On Mon, Oct 17, 2022, 16:03 Tom Talpey <tom@talpey.com 
> <mailto:tom@talpey.com>> wrote:
> 
>     On 10/15/2022 6:10 PM, Steve French wrote:
>      > smb3: interface count displayed incorrectly
>      >
>      > The "Server interfaces" count in /proc/fs/cifs/DebugData increases
>      > as the interfaces are requeried, rather than being reset to the new
>      > value.  This could cause a problem if the server disabled
>      > multichannel as the iface_count is checked in try_adding_channels
>      > to see if multichannel still supported.
>      >
>      > Cc: <stable@vger.kernel.org <mailto:stable@vger.kernel.org>>
>      >
>      > See attached
>      >
> 
>     This zeroes the ses->iface_count under the lock, but the whole
>     routine is dropping and re-taking the same lock many times,
>     and finally sets the iface_count without holding the lock at
>     all.
> 
> 
> I updated the patch earlier today to fix that existing issue as well 
> (served into same patch). If I missed something let me know

I was just looking at the patch attached to the message I replied to.
I'll look again, but it will have to be tomorrow.

Tom.
