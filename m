Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1811C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Apr 2022 16:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236004AbiDAQVW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Apr 2022 12:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353063AbiDAQSb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Apr 2022 12:18:31 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D12D20DB00
        for <linux-cifs@vger.kernel.org>; Fri,  1 Apr 2022 08:42:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gb3L/W7EflgbfOcmNNwDCmzoB0D858c1GBlyJHyYprUUu8lgmOUKE+W5PbCpr9rD4SghKSVBqKdScfIp93dvPMsl+8NLCmXekJMMomFt2omWPy2FUEttD0z5iGzgHK70tmemBHfEJecIKKeEqobVsBOF1o/LppBjasOwePJIL7Q0KupJ9TCYHqlp29bjS0AwpPnoXDm/NPx/pK1BJblwUbIERsu1dsMkDV/4PLgE/YGah5flocTNpvmgNlKrwxYu1t8z1bZSDTBNhvGNoKmPOdF9lnRIf3afvK0SEeB/kyMpwUEgZl2+EnL/iZbsSqWfnUFTY2ZHvb6qb0cSco3c6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJCMTBRbpmDYBo1avl3pa78pE96HKxd2i1fartZkMqY=;
 b=Rgb4hr/PShcEGeeotE6kKcOqDBWF8NcfRPK1R2dQ0m7Zh0mNUw37sJ8DuESQ8ff3zKWRvGb+Ha21MFeqeVouwS+zbm6oVL7UqFBFezXAJ3LNhcPQz7V4WLXtuNO4s4uoXZfc/mAQNCkZWTZ3cULMycDMp6z3HSbf1wIJH9FW2jWE3dCqUKVqv5nEXK0lNku/i4l5L19McggWZ43MiF4MFJhZWQKaZm3sKUUSm1WSwqGvyFOYGtelTvlsY0hvzfKDE4RT8k1cSiPtShk8JboPNsEKKPv5UST/J5elHg7WSbKbDr4w4Q/YxfEWEku1CGXKWS8gDUySqP9lcY+1wa+DgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN6PR0102MB3486.prod.exchangelabs.com (2603:10b6:805:e::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.21; Fri, 1 Apr 2022 15:42:52 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d%4]) with mapi id 15.20.5123.024; Fri, 1 Apr 2022
 15:42:52 +0000
Message-ID: <d5648e12-c5b9-07de-a20b-afd49adc5f56@talpey.com>
Date:   Fri, 1 Apr 2022 11:42:50 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] mount.cifs.rst: add FIPS information
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, pshilovsky@samba.org,
        smfrench@gmail.com, pc@cjr.nz
References: <20220331235251.4753-1-ematsumiya@suse.de>
 <efb1d822-4fcf-dc3b-2861-8394f50aedbe@talpey.com>
 <20220401152508.edovgwz5pxn6gnhn@cyberdelia>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220401152508.edovgwz5pxn6gnhn@cyberdelia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0138.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::23) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96296dff-08b6-4c07-2e8d-08da13f64821
X-MS-TrafficTypeDiagnostic: SN6PR0102MB3486:EE_
X-Microsoft-Antispam-PRVS: <SN6PR0102MB348646663B08B439AD5A3C67D6E09@SN6PR0102MB3486.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ZMFx5C+NpCSFr+dv7DA+3kkz3PQYaEDPzXZlFDTUD2jZa3UlXAJIG0faX2FKHA3r71j9IGkPtFsIo2tgZPpZgJwZSznMXTbgFehzP+VYCBf2/EUoVbbpD5pkPyJ/uG4b4lRRuupcNu6MEb+5dmrWmqJlH4bavW+et5FLDVOu29VxaCx2g4A0GTDKPwGkAOy7b9S2xXiwGnkItABPVTJ5HqstH296mXNlYC/joeh1mb7Jphm30ESNdWd9PRr3IYLwLaTP/yIM7Dstd94YtlP13GZAxBdIq4dqKf9BRxl7h7FY3mUe/odtX/GeneBZ6FrC3tIAuPLcn0yek8b6pPTfk8OAIZeSHnaBAS/8oQk80K1BraQhLsq88GvNSetDe805aAKz3ofxfh8dB/+reRz/lowi+vTEGvZnrRgapW0L7b+d7zL5owtBO0oMvkkaXJIVHG7XC/HzQII7BWhbaV+QMWdFXPVs+qK2N/4oOfzmp6OwUuyPZlswFBZByOLg+br6eOszo4NFO8Bou3Zg3RMpLZvIdgJhXoiufUd4mJaJYcW5rJbp/LVrYPZC5QwVD7tChsmEFZck6aA3DSG4FRVzhfqIiJDKysAZPlQsmtP0jehVRCUZ1L7O7TDEw5kW9YLoxamk1jhhHguw4YyUd66CNGsZpRoMW9u66fLKcrgl49N2XVL3VJ3MNo+/JVpIaTo1M9etqG94sF99W5qH0bFt0VM2uwIv+NIm4OV35d2/JnUK2HxRKsjVkJYRpNknMrdmWMOV6p0lXWddKww7KGg0sgOS96hwj44BDv9uFzYFg8eV2PiCrytTSVI4TmEtcX5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(346002)(136003)(396003)(376002)(366004)(6512007)(966005)(53546011)(36756003)(4326008)(508600001)(52116002)(66556008)(31686004)(45080400002)(6506007)(6916009)(83380400001)(316002)(66476007)(6486002)(66946007)(5660300002)(8676002)(2906002)(86362001)(26005)(186003)(31696002)(38100700002)(38350700002)(2616005)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alN1Z1k3U0RkS1dndGJVTmQvVEd4LzBobDMxVDFScHNITzhkTnlRYnlyUEcr?=
 =?utf-8?B?T24rTlkwQlRpU2w0Y0FQTGdlQXR1b2lhVDBXSkNoL2dEaUxudVlhWXZMd1pt?=
 =?utf-8?B?TnVmdGxXTUJZWEx3azE4dHVOdDBHRk9VQVZzTS9UMlB0dFpvaTZ2NEZaZC9j?=
 =?utf-8?B?aXpHZ1ZMSjEybVhmeTY1bUgvcjR4T3NmOURaM3M5Ulc1OVMwUXliYW5HSVI2?=
 =?utf-8?B?dDQ0aTJuU29abEU5cTRQbUtVS3JNdURFeEFmdnlhNWxvTFh3TTZPQWFnYlBV?=
 =?utf-8?B?bHczK216MnZnTlk4UVV3WU9FSExrejRZSDA1R05tV0tHSWg3dS84bjUxZEpU?=
 =?utf-8?B?cVZqeWxDZGNhZGRjMldna0hHKzUyRjlKT1ZmVS94TUcvbW1IRTg0M1VIb3V5?=
 =?utf-8?B?M3g1Y2U2Y2VtdDJtYkJyVjZaQnhTVWNLcklZa3FiTmpWOXA0T1ZQMndlcHpt?=
 =?utf-8?B?U2pFbGtRM20zLysvcngyUTRKcTdNSDBqUlZacnd0b2hENmwycmdhWENtTU10?=
 =?utf-8?B?YmNyZGZ5MDFibWNFYW1QeU51SjVFMkpMakRuVUF6Nlc3QUEzbUJvMGcvbGtZ?=
 =?utf-8?B?d3k2UWlybkdxQ0RqY2ViMDhNQ2tpR0VINWJvRlcrbGxtd1lNOVcxMzAxWW9X?=
 =?utf-8?B?TnFWdHZJNTRYTmlYaHdNSDh0M3FRWEQzV2Uxc1FHWE02UGRNdGQ2RkVJS09V?=
 =?utf-8?B?dS92MmUxamo5UVd2dnp3SDFHdmFxUDBxcUdGaWwyL295WHJReTZPcit6LzA4?=
 =?utf-8?B?TGMxaEx1NC9XL0pweXFucS9Nd3hmc0UwWklJSHBHVGZDQzN4KzhrNUd1eEFm?=
 =?utf-8?B?c3lCOGRzSFJ2Z0EyU0ZINTRFc1NQSVI4U2pXdVo0UG9kRVZqWURHcnJSZUlY?=
 =?utf-8?B?d3BXS2Q0VFY1N0FZZmV1MEJJS1pzcjBVLzY4ZDYvWkxrUTZSaEVrZjY5cU0w?=
 =?utf-8?B?RnBxV1lkY2F4MnhYcVdSSlFBbWR5OEtuN2haRGNmdEpnM01yZTZrZU9rbWZz?=
 =?utf-8?B?ZXpRblczd3FSd25mRUpHWjJOMHZORCtMVlI5WTJXeU82YUd3S0RRUDI2Q1ll?=
 =?utf-8?B?NGRuc1JnK1c5bGlUd2tCNWJyclc1OHU0OXRSQStZcThmOWxFN0J6WkVjcnNk?=
 =?utf-8?B?UVNQK2YwV1BHUEx0TnM0TGJ5T29FV1dmNG1Ka01sMm0xMUdLMWV5dFN4cXhN?=
 =?utf-8?B?b0Q2ZjJmbFFtcU11WUx3blVZbUNYSWgxbS93dHdHbmt0MzNPQ05vTnNTb1ZV?=
 =?utf-8?B?Tnk2ZFBZc1pDRmRCY0JiV1diUHd6M0hyRzFSeEVmZ3RZZ0poL1ZURTZLbFVz?=
 =?utf-8?B?emgvSkw3aUpzQ3BwQUYwcDhxZmdqZVpnU1hUK0trTVovRmFiMjltbmZxNUpL?=
 =?utf-8?B?MEZjTDRvYWl0ckNoZk1uam9ISzdoT0xkT0lDLzZyL3JFSGhPNDdxbExlbzJX?=
 =?utf-8?B?QkZRdVN2TjlEVmw4SnRtYVBKTG9QMlVXQzBnWjVqRXFQbU1nNjZzbHVJRC9B?=
 =?utf-8?B?cDZkQ0crbVM0RHhZSHNDY0hBQXhtMk9jUzFodFdraVhvTUl4K2p6OGNVbHkx?=
 =?utf-8?B?enZrQ28rcnJpMEJtTnRKZGZOL1JMdzdjRHY4b3lGNWI3dzFpQU5WUmdjYko3?=
 =?utf-8?B?ZWRGa2t6N2I2cnRpQkR5RElNRmRaazdLWGRKQmM1Z3FnVG05SFEwV0hHTEsr?=
 =?utf-8?B?emp2THpXMVBCNnhKcVJPdS9iT0ZraG83TUk3ZXNSTThDUWNkdzVUYk5NTXV0?=
 =?utf-8?B?bVBiZzNlSXFVYlVwa0VMeStMbXUxYlJpd0RJOUZrVWEvaFJGWnNFbUFYRWpH?=
 =?utf-8?B?YldKQ3lxK3ovMDlGeXZjS1RYMnBvWG5idmJ6aCs5emhnbWxsT2xFWkVPMkF4?=
 =?utf-8?B?M2pSM3EzR3oyU3BDTFQ4bklONDU5aElTM0VNZHlCd3o1dmJmYjNaYk1UUmpw?=
 =?utf-8?B?MDc2VGVJZ1JuU2lobDNYY2haRURPa2pkTkNTWVhvakxHN2l1anozUGJxM1VO?=
 =?utf-8?B?L0swN3R1N1NEMEZ0Q0NsL2RWWDlCUU9oU2hFNHY0R0hOamlWWk04N3ZsZ0Ey?=
 =?utf-8?B?U1ZsODY2dGhPUUxhK3l4R0J2amtjckwwN0FmSHFTSWRWbU1SajZ5U3l3WmF6?=
 =?utf-8?B?SVJ1d2RydGo1aWV1eCt2WEIxeWtpYVhqdEloRWRFY21ER3JuQVQ1YnhKbWFx?=
 =?utf-8?B?VTRDZURaN2doeGp4UjdiTi8raHBsSWk1aVNwbG5ZUkZMZXRkY080N2pRNmFJ?=
 =?utf-8?B?TlRiNjFMQkU3am8rRVVzMnU1dkE1VEVaZkZsd0NkWVpVTjl5VTBISk5aYlpp?=
 =?utf-8?Q?6dbMhybonuO1tIG8ci?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96296dff-08b6-4c07-2e8d-08da13f64821
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 15:42:52.1863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xM8eUud6QEES7+LapwYetaspbRYZKChPep2MYHijZpcFK3GWnu1iNO3Dfs29tTFY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR0102MB3486
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 4/1/2022 11:25 AM, Enzo Matsumiya wrote:
> On 04/01, Tom Talpey wrote:
>> Is SMB2 really FIPS compliant? Even if it is, a server that doesn't
>> support anything higher is obviously far out of date.
> 
> It's more that the crypto stuff used by SMB1 is *not* compliant.

Sure, but that's not the point here. It's time to simply state
"don't use SMB1".

> If SMB2 keeps using FIPS-approved hashing/crypto algorightms, I guess it
> makes it FIPS compliant, and the burden is on their end to disqualify
> older algorithms for their certification.

I don't think the crypto algorithm is enough. SMB2 is vulnerable
to man-in-the-middle attacks and therefore the crypto type is
only a part of the picture. SMB3 is much stronger, even with the
same crypto algs.

>> I think it
>> would be better to recommend, or maybe even require, SMB3 here.
> 
> So, I've added a bit in the SECURITY section saying that mount.cifs
> doesn't enforce anything, and all crypto blocking/allowing is made on
> the kernel.
> 
> Do you think we should? An informed user, with particular requirements,
> might want to use SMB2 *and* still be FIPS compliant, but we would be
> enforcing something (non-SMB3) that's not quite right.

The Microsoft FIPS statement only refers to SMB3, for example:

 
https://docs.microsoft.com/en-us/windows/security/threat-protection/fips-140-validation

   Is SMB3 (Server Message Block) FIPS 140 compliant in Windows?

   SMB3 can be FIPS 140 compliant, if Windows is configured to operate in
   FIPS 140 mode on both client and server. In FIPS mode, SMB3 relies on
   the underlying Windows FIPS 140 validated cryptographic modules for
   cryptographic operations.

I think anyone who is serious enough to want FIPS should darn well
be advised that the best security means running the strongest version
of the protocol, and the doc should not waffle around with discussion
of SMB1 or SMB2.

MHO.

Tom.

> And if the kernel is not in FIPS mode, we should only inform the user,
> because we don't actually use/do any crypto computation in mount.cifs.
> 
> 
> Cheers,
> 
> Enzo
> 
