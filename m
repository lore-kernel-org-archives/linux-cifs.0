Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1700C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Mar 2022 15:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351101AbiCXPGO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 24 Mar 2022 11:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245471AbiCXPGN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 24 Mar 2022 11:06:13 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3C93FBD0
        for <linux-cifs@vger.kernel.org>; Thu, 24 Mar 2022 08:04:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNtPq2pGq9dFvZPe+K5dpWqEA3UqJxFUrHODsXtgkUSGBaJTTI/YKXuEif5Zn1eALuXVcX+4FRdJxJvj0SxJobJp5R633tnM9BXm3CS+MYklym4NqDLSi1aVfSw3HZsCAKgzTT13BNCpvsNqNgc/mUMjI56yFTfq0Xpq9EyxgocLnliTsU/8wyzrpMRw6OFpSBOKO04mjVyJDJBs5xejDGh294gjp4/dqrUbmjLH5veT+w/vVPhddE8lBo2lgl8f0i4OTQ3HkfFFHiz6GtDDKJwKqOjk/1mmBXlK3O2hkel8kMSSgUyysImRxZaeyLjVMNvcLu+NTqaTq1fqgiVLfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xndBW+JNoW9fr6rbnaMKxppD9I3iPdM/vbgioWbk+wI=;
 b=i7t2/4aEX5iejPT9ig4oH/PnbrgfYLW5xZ1CqyTlFSRu9Cy1flqC5wzqm5THSWyIV0hhIir6V2vBNGi2l+Z1ZjSlww5nwiMhl/lCmjPo+bvlJDXDOfq/Ce8X49bGOAf3Z77LvVejbuxjYo7gSRxayxk/fsgVahIHvwnH8kHMht2E+gVksbgmHPjl/AdhzkF1ohZzUu21LhDTYZm10/KiK7LkjVbnf034uCsem+M2PT0WSd66eDjrwWNNXKJT1sUme3jpnCJSqLrEacj42K26SyvEf6nXjsxSdeIpT2V0djnxveI43M2r8EZqhKNrMsD01fUnZmjM8lzG15GrdlDQ1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL0PR01MB4211.prod.exchangelabs.com (2603:10b6:208:48::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.23; Thu, 24 Mar 2022 15:04:32 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d%4]) with mapi id 15.20.5081.024; Thu, 24 Mar 2022
 15:04:31 +0000
Message-ID: <e23752b1-b610-98f9-c338-5faea047494c@talpey.com>
Date:   Thu, 24 Mar 2022 11:04:30 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Signature check for LOGOFF response
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     samba-technical@lists.samba.org, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
References: <20220319032012.46ezg2pxjlrsdlpq@cyberdelia>
 <a0972fb5-38d3-5990-7c8e-0b7dd61d1abb@talpey.com>
 <20220323172913.56cr2atzfcunv5kf@cyberdelia>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220323172913.56cr2atzfcunv5kf@cyberdelia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR12CA0024.namprd12.prod.outlook.com
 (2603:10b6:208:a8::37) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f4ae936-09f4-4053-d11e-08da0da799ad
X-MS-TrafficTypeDiagnostic: BL0PR01MB4211:EE_
X-Microsoft-Antispam-PRVS: <BL0PR01MB42118DB43583C8D877AD1188D6199@BL0PR01MB4211.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TVWqCb8RUjstisPuqkCXNcFULUxSr7FqdL9/nll5DvjE3zDA3MZ7+qejl4xrPJsLj8Hnq2bW0WBLrgnIpEr6RW6vG3LyilbVsg+eT0mQ9ugLbRBZOtKZcH2GweLWvcSio1kzBYNM3Rl/kQjEgtFlKAYELjLp/tq3ajejjMOhYD/nfQNGwTIwsC5riZKzLLO1ELkrgpHWtYkj7inufDBD6mta8uxQgRirRwy2bY5336Y6ssTE0x1ETCjHK2NjJYzRCIx3UtaDuW2bEIGY1wlrl/JTFgb5NbQueIz8TZcu+Olrpkm+njlAICNqr5kAsslbFdBJcmB14blYdQFFi3Jid5VJsmzHQqoIRDGyt38mR+/2cvlwjAcjCL9O/cj4BnDC6UXKZTeGOOEbjof0jGRpKwoReJln7q1eVOCtNTvLGGMexCRd551pKt+TRsvY/5MaJRmiteS7EoT54Zq0c/aOBOvf5e7y8IYS8h/HbQ0hDBocDf4egLq1lXotkeT/vbOQ2EgBul79YJ6XvF5cWQwyaN8RHySANrnwrBlm3nV61dawRpZSIXO5rIxVFF/bW4ZYtJ0JavH11p8f/Ed44L0yRk+o9DSdXNeTfo+Erh3PFFoL4EqBbl7azAavXmptjWXOocXCzoUfp3xkFj9sKLugVN6hPWTR4//UYKu7kJ+K95REZS5N/XqPbwv8rJuHbSUjOmFYNGnUJlCc07ouPqgcITAQd3MUXGNs8WXqKQ2QN0I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(39830400003)(366004)(346002)(376002)(136003)(4744005)(38350700002)(31696002)(186003)(26005)(5660300002)(508600001)(36756003)(86362001)(2906002)(8936002)(2616005)(6486002)(83380400001)(52116002)(66556008)(66946007)(66476007)(4326008)(53546011)(38100700002)(6512007)(316002)(6506007)(8676002)(31686004)(6916009)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3BxKyt5V3BrbGl2OXNtRldhUU9iU2NUT2daOUZXQWhGVVJITC9yRjdpWHZS?=
 =?utf-8?B?WVhQTHIxM2tFU1Nkbi8rSUpVOVdGY1psd01LTDdkUFg5OXFEYWRSMjNEemVI?=
 =?utf-8?B?ZEU5c3JmSWlnWHlXdXdDTHdObmZxcXlGVlFXVm1zS2tCLytXM1B3Y01UalBv?=
 =?utf-8?B?TG05YW55U2VyMEMvWjJ3SkdPTVNDUFpUZlpQQjMrTTZCMDJ1RENKOEJlV3ZO?=
 =?utf-8?B?YTZpOWk3ajlGSlU2UVdLSC9qUXE4d2lRNVBPdGhDTmI1MFVDcTcyZ0dJODdH?=
 =?utf-8?B?RVo0bGtJbVh4dDNoUmQ0VzZuZHU5VVd1SktNTURCT0V2S1cyOXRvNFFlT09o?=
 =?utf-8?B?ZThGKzRtSkVkZTJlVDFoL0hRYlAxQ3RoK051V0Z2WHJYSTVXemwwTXNBSHVO?=
 =?utf-8?B?REg4b0tQZGFjbWRPWHNpMVVCWXM1QmFITWtCWm0vOEpDbFhXcmxaaUlYRGs3?=
 =?utf-8?B?VnIxQkIvVXRzMFlVQStQQVNJM1RMb1hGamdQa0xVS3hxSGtRTTZoL0NTVktF?=
 =?utf-8?B?bkkvS090SGRDZm5OelRRY3pNVGJTTTRFaEtDQlNMQmJSU2ZMYmF6bHY4MEw1?=
 =?utf-8?B?eXNrWG1wNmtDM1k3MHBpTGx5SjV6WnZVODB4SzhRU3lQSUFjMmtDekNqS3RM?=
 =?utf-8?B?dGlsR0t0ZEVVVTJGTytBVkNDS3NJTXBIaVRCcFNmUjhqL3ZXQVpjVTM4cHAv?=
 =?utf-8?B?YXFncUxqR2oyS0xabWdRbGZsUFp4QmNXYm9hR1d3dlM3VUJrenU2TlhiVy9X?=
 =?utf-8?B?NlJSWkVLS3VTTmF6VFEwSExFdHgxNnYyS29nQmhvaGgyNEpNcHFRRTMwNElM?=
 =?utf-8?B?RGx3L1l5MVlMcFNxTnZSZC9UT2g5a1BMeUZIRGJscUh0bHMzMkJSdGthRmJL?=
 =?utf-8?B?a1Y4Si9BUWFmWm5hRERHMjZMTEhycmFxMkp4dWs2SkJFV0g4WExsSGMvUjZj?=
 =?utf-8?B?YXhuT3Z0V0dKRk5CNDRmNlZYSDRXZkc0eDlrR3ErZTRiVzBlb201c1RLaXMz?=
 =?utf-8?B?cCtSdm5PbS9BTHAvTHBIUmtMNzBEVnRsN1l0cE1Da1FiUWJvanYwRlptTFpF?=
 =?utf-8?B?cGgwanQxdlM4cCs2L1l1dXZVZlE3aWEzYlVBaEJRa1dWeERmUytSRm15K1FC?=
 =?utf-8?B?OUhmTEVVREVCTCtETGtXR1hqRGhudGRraDhDZVIzSHNtNkh1T2VSYS8vdW1F?=
 =?utf-8?B?dVkwTjN5Zk5yQXRudnV4YmZ3cTEyalErQ3ZKK2FhSUJ3ZTFIS2QxdktNVmRL?=
 =?utf-8?B?MHFhdzFtSzF3SDRKOUNybjlUa0hYTWdSZk5aVlRaMjhtVStxMDFJSFlGUklP?=
 =?utf-8?B?a3BQa1pZUGduYmFlK3NaclpOMlR6dUIrT25uZ1ltWW90SVpKaWlqbEZVMUlk?=
 =?utf-8?B?QlFKdHNWWkh3aDZ2N3Bqc1ZpMFRkS1NwRGQyTVM2eHhCREt3eC9GRnEvdS9P?=
 =?utf-8?B?a3BIeFQyZmdzT2p5SUxkbmlYSnVsTEtmR0s0czJuMkNkZ01hbkhjaW56Wm9K?=
 =?utf-8?B?WnVYVy92dndrbWU2MkFkWUFha2xraWQrQzkxc3daUnFTd0lRZXFMSHp3T1Fr?=
 =?utf-8?B?YjJQOTc5YjZLWitxVERpaHFDNWZLWnpWOWp3ZFh2ckU1cWxRRVNWT2JYaVZu?=
 =?utf-8?B?bE5jd3V3VThkVFNpNHB3MFBlRjVTRU1xQlNPRU5WQm9mQllqbGFCSWF0aGhL?=
 =?utf-8?B?L0lqU0JtZFltZ21FVnZjUlVtdXhlWmdmU3Fxc3hGUFJJZkFuZkpVQ3kxaWZs?=
 =?utf-8?B?RGd6bVZEOFlxOEplWkMvY2ZUdTRzdFlORktGYi9USDNXSUptb1doa21MbHNi?=
 =?utf-8?B?bFdJZnFXVDUrS1FjdHdza1BTVzF3aWhJcnJNOFhCZXBsMGRaS3pNdFg2d1Fp?=
 =?utf-8?B?MUZ2dEEzNjZBbk5Qc2Y3L0h4NTByZmx0ZUI0VU5CeWMyYTBLT1RwVVBnQlZL?=
 =?utf-8?Q?Wu3WCqCO3vM=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f4ae936-09f4-4053-d11e-08da0da799ad
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 15:04:31.7851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G5z1GMc5lJur3u3u/XrRaY7IS2ijTqnkP6AjJFZ88OXXVCBnvFMaEvKx08le9ZNe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB4211
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 3/23/2022 1:29 PM, Enzo Matsumiya wrote:
> Hi Tom,
> 
> On 03/19, Tom Talpey wrote:
>> What server is returning this unsigned response? Assuming it's Windows,
>> that is either a doc bug or (arguably) a server bug, and should be
>> reported before deciding how to address it here.
> 
> It's a NetApp ONTAP 9.5P13. We've identified it's also setting wrong
> signatures on READ responses with STATUS_END_OF_FILE.
> 
> Our tests against Windows Server 2019 showed it to behave ok, so it
> looks like something on NetApp side.

In this case I don't think it is appropriate to apply the suggested
patch. Allowing unsigned or invalidly signed responses will greatly
reduce security. I'll be interested if NetApp provides any information.

Tom.
