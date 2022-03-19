Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 956D2C433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Mar 2022 12:28:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242882AbiCSM3p (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Mar 2022 08:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234790AbiCSM3o (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Mar 2022 08:29:44 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2053.outbound.protection.outlook.com [40.107.101.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327F318BCC9
        for <linux-cifs@vger.kernel.org>; Sat, 19 Mar 2022 05:28:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0pGpMkJLdEIMD91rteyab/whTgl9YxDZ1DwUkQR+5CH5PzJ0jBE5Wukj61ySt/LpGNPOBToqZKza3Ruyhvo76VWrP222uGnsJOGjsXMP0/FK/LupBI/Gyec6//lao0ZtdrIW97dPd9Mdi67qat/vXYOHfWU29nHtwvB+1qe8bY80EoI6BYGTyWf+1TymIed+XjztRKE7vjh7OBq4kSjZ8NVYa7OzfKlU2Wlzu3nhUZmAQCyXlZxkbMzdlZ8jgGcOfMSmC82WMGsFOOxoS8ZhvOGcdN8yxAeFOwuSvuU3RipmW9m4S7/c8vnciIE0TXQw5jmNWgGeRnunoKKH7fhTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V+aopuaHgfo5BQ9fo+OW7nnUxJ+rabmHbvdphGoT8z4=;
 b=CGWH53b9+jdFjDN/CuoSPreHZNvDyBBE3jUUM1X4Kwk/B9YWUz4xe+KeZQ8IYCdIhcNF+T+j/lF9i/zgBIdfG6ac88P4FhcdOOStFeON1tiu3G1jyf6Ezd/a0q1moJIlVyA9ANsvh7E8swSlSXgKUS1AztTwmdpadBw8JAFtb2fOZSPj6uoUcT0aUJGEQX3BpSEytGI45VF2hXoFglWXT0XMGIDJQW4G3z0MTlyPwfDhFAIhuwr38zBPIevKOdmWEt5BvZMm+ii8DjpXYp2lyf+fd/21AyocXYiK7viE3LUlIxQQDOWxBA5G2zwP/3aW4K5OJZhH/B43eTw4GXNxRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN6PR0102MB3552.prod.exchangelabs.com (2603:10b6:805:f::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.14; Sat, 19 Mar 2022 12:28:22 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d%4]) with mapi id 15.20.5081.016; Sat, 19 Mar 2022
 12:28:21 +0000
Message-ID: <a0972fb5-38d3-5990-7c8e-0b7dd61d1abb@talpey.com>
Date:   Sat, 19 Mar 2022 08:28:19 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Signature check for LOGOFF response
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>,
        samba-technical@lists.samba.org, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com
References: <20220319032012.46ezg2pxjlrsdlpq@cyberdelia>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220319032012.46ezg2pxjlrsdlpq@cyberdelia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P222CA0005.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::10) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f83a6b01-cd69-4fd7-6e06-08da09a3f4bc
X-MS-TrafficTypeDiagnostic: SN6PR0102MB3552:EE_
X-Microsoft-Antispam-PRVS: <SN6PR0102MB3552D2D37547E48E1A4AD28AD6149@SN6PR0102MB3552.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OZ2j3UUZ7WlWzXBTwa8OShCjZWW01z7X5uoQphSWA+15U7ivTHGtjsFbDzbmf/KQjgplzYddK111nAA+h8mHKlvcwh7q9Umb5Gc3tVQHJ+8oRX1IQgHKNhxg+GEXJfItax8kucreHXA61jc6hmBYmy3hnniynT3JdqCugT4AZU9V8ftUJ1VyJcBUf4KjjR4Z6ErZ9cPcoHrtHO6ZnrAknWuiVS/jbvWU+zJCTg3T2b3Nv4eXU/eCwHRO4R9msIG9fSvmkkL2DVrJTiWG+8FIEEct+3Ni/+kksTzTk1rDzy19tFNP4kOacO4N6/yuM3wDAcGvbYs//bi7TmX8r/3iJ8SiR7N4O+6gg4fJJiKxK5MKGyrmdB2J8+J9CEUQhnEn5dfqL8jb1XK1O7ZYFvbR9KXRSSwa11d3ZeAccwjNFTn2hu0TFMXR14ZwI7+Iq+Y4V/yjrgKzsnW7sFT5zquuMdU8ZMf01W7O7pC2pbuyRreN2rumqVLT/CPkfOka1+V/nrB0TahbffC+VIsBWRszmEAzXxGFQAfVFOtsnlbySGzMMD0JmvBJK67lQ3DfJDvjFSAd9tkzjGPVmI+1ibd4685s7LG7zZiYDN/c5J/YpLsE+X4q/tD44N8PV6z18/0T9gCmNGh3su+OXry2nuHJ47NQMRQkWtYAr2PWiPF8pcP9/jswiHcW0AXwcfsolvk2LKB24cApmpJt2PUnzHgMDqdavEq9EDyJ1qb/xTyT834=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(39830400003)(346002)(376002)(136003)(36756003)(6512007)(53546011)(186003)(26005)(52116002)(6486002)(83380400001)(38100700002)(38350700002)(2906002)(31686004)(4326008)(66556008)(5660300002)(8676002)(2616005)(316002)(508600001)(66476007)(66946007)(8936002)(31696002)(86362001)(6506007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wkp0NFFBTld4MGNMZkwrQWZ3MVI5d1Blcml3U3Jtb0NSYXU1WTNMTFVKWTB1?=
 =?utf-8?B?UTdleE1PVjN2K0RqRE1NM2J2cXBtMVgrejlBcmZSdUpNdlg1aE1DdlYrYWR1?=
 =?utf-8?B?Q01ESWxXNlRlOENGMHVQM1BKNHJ1bytvNFpyTjRLZGVhamZSU2ZTd0FEcVgx?=
 =?utf-8?B?L2NPenZYOTMrWGthbVdPZUEyTS81TlZYWTM1WDl1Q0Fuc2FOZjdTdUZ3RXd6?=
 =?utf-8?B?ZUlwOHpKNWJNcjhXS3MrNUsxdjRQZzkxdHphSy8zbUFna2ZYbFZ3TDBBL0lv?=
 =?utf-8?B?MkpZdkhVMkZqdWRMejJXUTdRWmErRG9yTEc4UEpEZVorWFZrS1k3T0laNTVp?=
 =?utf-8?B?YXpXTTdmUGVaYXRNa1NLVHBrSXdpeWdHeHNzUVVyMTQ2ZTlOMXBwSG1uSUJC?=
 =?utf-8?B?aDJZSzhLdWRwWnRJMXlMY2FUTndBdzEyNUN1TFhoSGMwQWgzR0c5MWhnZkh5?=
 =?utf-8?B?ZmZoVVkxYTAraDJ4L3ZjK28vVUcvb3gxbGtRWEdzN252Wm9Qajk1bnRrTE5C?=
 =?utf-8?B?Z29ZWk80TkI5bEN0Ukxua3BmMkVUMUFqbDNvUURMZno1S2JBUkh0YkI5RU0y?=
 =?utf-8?B?dnV3ZDNXM09SSGRZMysrRVZPQU1kR3JoVjNTTjVGODNYREtHYkJXdS9RRWdE?=
 =?utf-8?B?Wjh0cENodHRYeVljQi92bUhLd3h6cFNMZWJsMkRUek9LWUUvdzUxaWZ2czBZ?=
 =?utf-8?B?RzVGZ3FoNjZWNWw4dmVrVFdacWNJUUo1SlVRbzNSUTM1ZEE5bmFtSnhBdmhQ?=
 =?utf-8?B?NndGRURiSEhQWDZucERvMlpYSXN2eEU1bEVsM3VUNkRxQm15T2VrMHQ3QWMz?=
 =?utf-8?B?YzFkbGl2WUFFQk8yWHJ0ei9ZdXRvbjRDbFpOY0ZpYmpkMGtOZXIveURDVzJ4?=
 =?utf-8?B?K2NCYUhzb2JPUTR4d1pkeGdIdmQwZUt2MUpXaXpiMmI5bTdIRFU5SzczeXBu?=
 =?utf-8?B?bTZWblJycStLSEtvT3A1MHQ3K29PME1HWCt6NGxxaCtxRWtlWm5hNFRmMWt3?=
 =?utf-8?B?L2x1MElTVFZSLy81OHBBNCtESk5MR3QzTy9UZFpYUVY4WXRSUlhMSnMxazBz?=
 =?utf-8?B?cXZIeUpKOTZEcGtGY2ZJVlRvangvUXp3eDVYbEp6SW10OW44cys5OWlGc3I4?=
 =?utf-8?B?aTNwZG9MWHBFOExvSUlXVVFkUVdCNmZuWE1uaTFKUWM1OUxmcGdNUlhqbzBm?=
 =?utf-8?B?RXpXSThQUm12T3hiRWRHRk4wUmNmOU5jQzZaOGRLTmg2ZmpmTjBaMndwOWtu?=
 =?utf-8?B?Z3BnZ2FhdUVLOUdYOUR6T1dnd0dmemc3QSs5cXVWNFFaUlpBVDB4dURHZEZs?=
 =?utf-8?B?MVZ4eHpYODdLTExGVDNlWGswQ2c3YXUyN1ZIcEpOcFJWS2dQN0dzeFk2QXgv?=
 =?utf-8?B?NEZkdURmT0RLdkVCQ3N1NERiNDM5NlNqdWRGTzYxbytkR0dEMHduSm85ZWxW?=
 =?utf-8?B?QW1NamU3YjJkK2VXenRHRlhWZWpadWhYRlR1ME1HSVVwS1Qyekp1WmdraTVX?=
 =?utf-8?B?Y0tZeEd4Ni9xN2c2V3BUNnJIL0l4aUtrMkVXYzZDbWpjSTYvV2FaanNENnVz?=
 =?utf-8?B?MExkc3FUTzFzQkRiSmcvcHc4WmQ1TjV5OUo4OU04aW9mZllXUVErNStjK25G?=
 =?utf-8?B?MG9OZnJJRzdYWDA0RVFCZTRWdGhuV1AzeUd1REQrVGNFSThnQnBObGJ5ZDRw?=
 =?utf-8?B?RmsrM1YwK0FuSEIwZUYxeW5aYmdJMDIzZXpnV21VTXRqV0NoV2RTMlJuRHRY?=
 =?utf-8?B?NnoyZGpSK2oxTFJhc3B3QlFLd2kwMHRTbk9HL0V5dFFpWUN6TFkyS3dadzVt?=
 =?utf-8?B?OCtUblpLMXlMclFSVDd0Z0dJY1N6WXl6TUtjWHdWMnIxbUtNZ2VDeDE4Q2s2?=
 =?utf-8?B?NzduaFZDTitjMmR5b0laTmZ1dGQ2U0JUdy9TRis4UVdzcFJtR1NNMEMxUi96?=
 =?utf-8?Q?KZmTyrNw1FI=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f83a6b01-cd69-4fd7-6e06-08da09a3f4bc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2022 12:28:21.8998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GS+NDkfyug5DEzVIF8gkS6c7PI28xjj6WDFhzHhOciAREoKxBffXbzUNsLxY5ykW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR0102MB3552
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 3/18/2022 11:20 PM, Enzo Matsumiya wrote:
> Hi,
> 
> The LOGOFF command response is not signed (=> signature is 0x0), but we
> check it anyway, displaying "sign fail" errors in ring buffer.

What server is returning this unsigned response? Assuming it's Windows,
that is either a doc bug or (arguably) a server bug, and should be
reported before deciding how to address it here.

Tom.

> As far as I checked, an explicit LOGOUT is only sent when tlink pruning
> happens (i.e. TLINK_IDLE_EXPIRE expires), but we have a case of this
> causing issues on production env.
> 
> I didn't find LOGOFF being a signature check exception in MS-SMB2 rev64.
> Relevant sections:
> 
> 2.2.7 SMB2 LOGOFF Request
> 2.2.8 SMB2 LOGOFF Response
> 3.2.5.4 Receiving an SMB2 LOGOFF Response
> 3.3.5.6 Receiving an SMB2 LOGOFF Request
> 
> If this is implementation defined, maybe something like this could work?
> (100% untested)
> 
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -667,6 +667,7 @@ smb2_verify_signature(struct smb_rqst *rqst, struct 
> TCP_Server_Info *server)
>          if ((shdr->Command == SMB2_NEGOTIATE) ||
>              (shdr->Command == SMB2_SESSION_SETUP) ||
>              (shdr->Command == SMB2_OPLOCK_BREAK) ||
> +           (shdr->Command == SMB2_LOGOFF) ||
>              server->ignore_signature ||
>              (!server->session_estab))
>                  return 0;
> 
> Thoughts?
> 
> 
> Enzo
> 
