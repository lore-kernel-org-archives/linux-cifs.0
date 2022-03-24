Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B65B4C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Mar 2022 18:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345835AbiCXSuB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 24 Mar 2022 14:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiCXSuA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 24 Mar 2022 14:50:00 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B007C38A2
        for <linux-cifs@vger.kernel.org>; Thu, 24 Mar 2022 11:48:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hogJGKPWhdn2dLqqihmO1APKkjAi/fw5WBIsNmai92zf2ehYXkFUGDOp0eujG/inPV6+Cl6ji502GLkjEXkci2HcYC6kNB6w9AfOW+5/+vsG9lb9gHyPZ8ULqQl+JApSD4vKCymetQm8M23VKJjlVGxV2mao5yr9qQPI5doHBL6mTAJHnbruRSGK4Vbph2DM8B+LBj8wZ90+smvB+4u4O+eciXLmeA+8X+KXC3+xpxRN9X+6gnfcxZqaWvcmNm7o1RRtRKs6DXcTluZCPQD0naEKEEOpPj8P53wEsngd2x5gY9KO2DGAl8NTYiS/RkznzCYRS6iuOpOFqUBj7mAlnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZB3AvNbq1GKsGi4GL1f/RhZ7SW0bOIm9aVjO3fg4kgg=;
 b=NUi/pv/0gInW9aRd7dupUjtbUvhGR9Fag02VirzVLY4ItEf1iFLxiGKNgc+RQMUMONXPHj6MZbY8eLFfUvRJlr3PLqzItY2aoK1EP5DkuTvfVWzU2HLF2f7SYGWAhTk/QEtYFCDhafUiCv9K73qnZgb2pAei5KoLE8BOkZ2KSEoClMwr1ayBDwR3nNjuvAhfIDD1wsCNgExHg2yWQC7HE8h88d4VnmsjLaexIKDmqRrCDtb+HX7rzFZwtzqIFfcKj3Xxcy4UH55kfyMnOMlQ9z4is0OuIdGAZw6IaODJPIplx6SbTmioLHYkZoDLBVjM42QIiGGQO2tKVOSkROvbxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB5063.prod.exchangelabs.com (2603:10b6:a03:76::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.18; Thu, 24 Mar 2022 18:48:26 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d%4]) with mapi id 15.20.5081.024; Thu, 24 Mar 2022
 18:48:25 +0000
Message-ID: <beaa2c31-96d3-7697-7dad-44585817ae46@talpey.com>
Date:   Thu, 24 Mar 2022 14:48:22 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Signature check for LOGOFF response
Content-Language: en-US
To:     Jeremy Allison <jra@samba.org>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        samba-technical@lists.samba.org, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
References: <20220319032012.46ezg2pxjlrsdlpq@cyberdelia>
 <a0972fb5-38d3-5990-7c8e-0b7dd61d1abb@talpey.com>
 <20220323172913.56cr2atzfcunv5kf@cyberdelia>
 <e23752b1-b610-98f9-c338-5faea047494c@talpey.com>
 <YjybF0CDEIkXmVov@jeremy-acer>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <YjybF0CDEIkXmVov@jeremy-acer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:208:91::22) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80e3d723-0c46-4cd2-2ef8-08da0dc6e0fa
X-MS-TrafficTypeDiagnostic: BYAPR01MB5063:EE_
X-Microsoft-Antispam-PRVS: <BYAPR01MB5063DA53E79A71B5C273085CD6199@BYAPR01MB5063.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1/VEbmeqq/cQjlc76+/ChCiKUmbltlx9CYpMX6mOoFyepWcL8w446WeujDzf8mgGePIrOUg6BfCj/w0GSAQ+0p2yZ8ofx5/ZACl7jQRlI8XCxnwbjwv1MVU5O5uXumysKOaY9d4fYSB5sSegGLOTnFwf+gDvdlw+AirvSjwGNekAkA5nCPAO+WOzy2YiIQDjZTRmUgsV4+OKU4Ykas8CPBkXdY+ttZL7izsFm1lnda7tJq5DnJrN0V0PHc6N5cPlYltaA8WNcwmrzetoYSWYXDdOaDkN3rEBmhBN4KXqZTjW+xqbbkk7xfd/AfKJrBNaj3bs56g9GAhhuDexHRU7C9KdWWXRLEcYkJ6uL9hSxN7AA3G/KAzA2bc12QO142CkxCIYp2Uf1ymf/OroO2xmhb0+XBvxbmcZXRO20ovA4nxk/8GGeNkdqDfUc9WI9H5JPcTKboHJzJTnNp4Rrk5Hzb85pIbSWQizFIRxEkclxTb1UEWw3pR8HzDqdNsv/ur0mifZhKiMAUpdq4pAdAin7NwsPPYmcpcL/cjrU5tMwLQUElcgUp8iu6LnJBIsXaZuzTl7RRuidN/VHDnYrgaF8uL7Hit3DyoG/UP+esHWfH1f1jBrHx3DtB6zY7lV2+FTw0YcHgMN/xYxYITu9toQoRKVbeuVLCUrXmfRhr/AlfM7j/oZGkz2okzXnJYow33GIUXACifsFHIqeyCAQeUJ/tiYVoKkNSdPcpwEvQwgY0M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(396003)(136003)(366004)(346002)(39830400003)(6512007)(53546011)(186003)(6506007)(83380400001)(52116002)(26005)(31696002)(2616005)(38100700002)(86362001)(38350700002)(6666004)(508600001)(66476007)(2906002)(8676002)(66946007)(5660300002)(66556008)(4326008)(8936002)(31686004)(36756003)(6486002)(6916009)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUtkZ0FCMDdNamw4TGlmMEtURW80T09UTUlnejB2OWFrRitUTm9reDBKWWlQ?=
 =?utf-8?B?aHZFZ1hQdUxCSThPRno4WGRXRGpNSHNDem02cXU4OStvazUxNlUza1dZdW1F?=
 =?utf-8?B?TVl6M1hxMGZhS0xpMnNJU3J6aGVpZzFQWCs1bFYrL2dNeTJoeE5BOGs0MHQ5?=
 =?utf-8?B?R0dGZDlRZm95Uld2SnozM0lQaDRqYy9sMTdUenVTaEdyR01RdHZvK2Zxei8z?=
 =?utf-8?B?aERtOG8xMyt3dE5KMkx4Ly91RlFDeE1HUGtKU01FSDFIaDYyeVpGRDh1NGg4?=
 =?utf-8?B?Wjg4NnQyZzJIY2dFRE1wUitDSFc3bDJ3a0JuODB4WXZSR3BHUDdWMGlxUDNp?=
 =?utf-8?B?M0kxT25pbW9qMVUzU1JYWXlyRVdJZndDdVhrYXpQdmF4UG1ncEkzT0ZwTEov?=
 =?utf-8?B?d0lWRWJEcHRNZy90dlRKMzBrWVdCTzczajI0VnFqbnJjY1kvbFZDQ2lwVitp?=
 =?utf-8?B?SE1kVlRnTlZUajVvNzI2SXYxN2FGOWIySG9WSGJpYktHdDFsYUJ5UzN2Rm04?=
 =?utf-8?B?R1lqdkZBL05oUDlheGlILy91WTFVU1grM0dlNlpPd1BWUGRpa3FrQnJIcWV0?=
 =?utf-8?B?eDVTdjRVcWNXSE1ubE8zT0pHRWJhNlozRWZOd0VEeVlxOHY5ZFJRczFndzht?=
 =?utf-8?B?ekh1T2FWSHd2a0hoSHB0c2hKSVVub3QwRlJ6eE9kMUNLNk1CMkZrRGxPekx3?=
 =?utf-8?B?RVozcmdMLzZxSXNmdittUElBakg3ZEtYUjRkMGNOUmtJVXgyZlJxeFhpUXpw?=
 =?utf-8?B?SFRMUGNWd0RhSkdTSFB1WnJXaEplOVVBbWc5WEtsWUE1NzhLQjFsaW1aSG5y?=
 =?utf-8?B?a2FzUUhWRHJ1V3RkUnRzU0JPWDBWbWFySkk4aktGeDQzSy9OeFlzNndLZUVU?=
 =?utf-8?B?aTJOdTB2MDFoTkt5NkF6K0k4RWU2ZElqKzRpV2RLNVllMUJyOEpiemYyZTQ2?=
 =?utf-8?B?N0dma3pRc0JiUlhOUjkyaWNOMENkRGVvUGNObUZXZTBhckJrV0tTaHIxeUJM?=
 =?utf-8?B?eFZNci9LTFdNMUJmMFZlU1I4aWF0T2xya1VJQ1VSS2hNcWVyM0dNNVVGQlVC?=
 =?utf-8?B?NVBWeGI0bFc0UmgycFRnZHFvNmhRcTdmLzFycDNyTGdxRU1sNU9maC9vMUlj?=
 =?utf-8?B?emZ6ejlweERuRGFUdXVqbDlWcWdsZjMvOEl1OFVrd2hZaUNPbGJCTFVmc0d6?=
 =?utf-8?B?MzNRS3FkK3ZvUVBhWWg0ODJVNnltUlJ5MHlhd2d3bkgyaXRJYW8yMkxvVGV5?=
 =?utf-8?B?L1B2Qy9FczIrV2RFV3U1RDNOcThPeG1IalhOMGI5bmYvanN3ejNMVnFyRWh2?=
 =?utf-8?B?ZkdjWTRZdjY1M012QzVXY3ZBR3V2aTZtK2VNLzBZUDBndDlZRWZtb3ZOMHIv?=
 =?utf-8?B?aEd4Wm51MVJtRmpWZ1c3eXVrdWRGU1Z6cnZNYVBKOFJVVlRxNlEra1RaV2dS?=
 =?utf-8?B?dFIxNTFMdTNYRFpLNndhQzNaM1dvYUlKUHBWQzg2Rm9rNlNtWkM5bGhGWm45?=
 =?utf-8?B?aXloMmpHd3FjZUpKUWFQdWlXbmx0K2I0cDFNT2VzZU1Ob2pxbG1YWnRlanlH?=
 =?utf-8?B?UllqY2lzMlBRZGdGQXhDTzA3ZE5tK3hWWGdxV3lpNTF1RGo2L21FZE5rczl6?=
 =?utf-8?B?Tm42K2lTN3Fyb3kvemZHOCtpVnpGczlhOHgzbGVIeFExUFVoK0lkalhaNWVj?=
 =?utf-8?B?RDVmNmpUYWJUdjd6OGFOd3B6dDhZSlFzY3lVOVAza1F6YTV0dnVzMlI2d3dz?=
 =?utf-8?B?OUM2bHlLQ085Vmd0ODZnbkp0SDFSRWh1M1NBZXRrc2hJSHJibHdWNkxtQzRl?=
 =?utf-8?B?SWtwUWhLaVRWZVU1RjAwR2RhSjZaVmk4V3JRT0hRTDZDdHRURzNGQkY5VTNo?=
 =?utf-8?B?eDRDSXZGUkxjT05YVUlCTUJQODhhTDdKVlZuOVVkSURWZEZ4bVFhek1yM0g4?=
 =?utf-8?Q?RonU46cmJTQ=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80e3d723-0c46-4cd2-2ef8-08da0dc6e0fa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 18:48:25.7399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WFBcLbDeBNjaaWpdnzJm3/hsg9kSO9JSo60ziDfODYwUuTKG2eXZXVc0K0e6xrPq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB5063
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 3/24/2022 12:23 PM, Jeremy Allison wrote:
> On Thu, Mar 24, 2022 at 11:04:30AM -0400, Tom Talpey wrote:
>> On 3/23/2022 1:29 PM, Enzo Matsumiya wrote:
>>> Hi Tom,
>>>
>>> On 03/19, Tom Talpey wrote:
>>>> What server is returning this unsigned response? Assuming it's Windows,
>>>> that is either a doc bug or (arguably) a server bug, and should be
>>>> reported before deciding how to address it here.
>>>
>>> It's a NetApp ONTAP 9.5P13. We've identified it's also setting wrong
>>> signatures on READ responses with STATUS_END_OF_FILE.
>>>
>>> Our tests against Windows Server 2019 showed it to behave ok, so it
>>> looks like something on NetApp side.
>>
>> In this case I don't think it is appropriate to apply the suggested
>> patch. Allowing unsigned or invalidly signed responses will greatly
>> reduce security. I'll be interested if NetApp provides any information.
> 
> Welcome to our world :-). Doing:
> 
> git log|grep -i NetApp|wc -l
> 
> shows 32 instances (some are commit messages with NetApp in
> them two or more times so the number is probably a little
> smaller than 32) of commits in Samba especially to
> deal with NetApp bugs :-).
> 
> That's a lot of client bugfixes :-).

Well, it could be argued that this is prolonging the bad behavior.
The NFS client maintainer's approach is the opposite - if the server
is violating the protocol, he holds the line and will not change
the client. I know, I know, it's all in how each person sees it. :)

Tom.
