Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2857EECAAD2
	for <linux-cifs@archiver.kernel.org>; Sat, 27 Aug 2022 12:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbiH0Mpq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 27 Aug 2022 08:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbiH0Mpd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 27 Aug 2022 08:45:33 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2061.outbound.protection.outlook.com [40.107.100.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC2C2716D
        for <linux-cifs@vger.kernel.org>; Sat, 27 Aug 2022 05:45:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TEFA2+7xpNJmhFOv3Dx9yL23cNjgwcmWS8neKbXUyETnuVzOy0M/c07U5iQ30NKLs6E8ZzKr+rnTj9e0qLINlJvAJSi1pxJ3uicega0Hd/1j9i111OrDlYZlcvr7nPU4ia7uu29zNxC89ITBHdPxUNSQH40mRMYlr43DkrCfolA+cXn70v9vdO2mrhXoi3WYkgN4i3beaZnGxkF3Phrd29ct6NfqGq4JdqEUNCQ9t4wcvr46MYUSMVMZmT26wAILT5P4JIvYiNGwetVw9RuOO0HazEZaX2zPDcqZfj6pdR8b9AjgO9TBgdvGxKLeJN66rKGmNALf0hYL5DuzIwqYwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cu5QMUeR/FxXmwbCN3g1s6JiiMfqnRdckbMSeyirVzQ=;
 b=Q3gMS5OdsDq5roFtuqb7GUpJWjHtWoE1cT3yOZG5SXSnf95qsJSknUo0Ey/c6TkkgK08MhRLScpfzeYMb+HOvNcNmCMJaYFPh0Zw/mT7AME2unJcq7ZjzmxgyK1yxqYQl0xVUb7ER67Z7NEjxgQ4o9vE2EX68aG3PT9gumAHiNWYWuezklvB64dvCDdKEWFp0JkzXuPLntBKqjSEF+k7QfUsRPbLMzUS0KjtAnslx8l2ZAwienZZmAmvQ25/UrSy5ReU6RCoYiTh5MJpkEQNcgDdYcE+qfyn8WaHR3xDxPdQWS2lfOw9UuNDa4HzrIG5CUcR527t+918nOvO1f/5ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB4438.prod.exchangelabs.com (2603:10b6:a03:98::12) by
 PH0PR01MB7318.prod.exchangelabs.com (2603:10b6:510:10f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15; Sat, 27 Aug 2022 12:45:05 +0000
Received: from BYAPR01MB4438.prod.exchangelabs.com
 ([fe80::6d1c:4239:2299:c1f6]) by BYAPR01MB4438.prod.exchangelabs.com
 ([fe80::6d1c:4239:2299:c1f6%7]) with mapi id 15.20.5566.016; Sat, 27 Aug 2022
 12:45:05 +0000
Message-ID: <555c2542-392b-0d62-7a63-ca816eb932e6@talpey.com>
Date:   Sat, 27 Aug 2022 08:45:02 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [RFC PATCH] Reduce smbdirect send/receive SGE sizes
To:     Long Li <longli@microsoft.com>, linkinjeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <6f6a2e87-4764-114b-2780-184c845a84c2@talpey.com>
 <PH7PR21MB3263302360DDB4FBBE0881DFCE749@PH7PR21MB3263.namprd21.prod.outlook.com>
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <PH7PR21MB3263302360DDB4FBBE0881DFCE749@PH7PR21MB3263.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0406.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::21) To BYAPR01MB4438.prod.exchangelabs.com
 (2603:10b6:a03:98::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca074f7e-af72-42d3-d50e-08da8829f730
X-MS-TrafficTypeDiagnostic: PH0PR01MB7318:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NYbrCdO+dsZbTMf6eThru78a+kazhFmhu8nRudhFi4WlKo/idHD83vJCyuNIgJ44A6NmHKYXC/nvSZLJfyIfH+DfKuxtjhcHQyhqZQvr/LnKl3rJ0PFgfZ/9NA5/iLFNlxZd+cufETq1H8jGzuMfcUT06H00leL6T6qSKWavO9N51iQhrikb+NiVRP064wV80EiFMrB8nOtVSrUiSmp7uzUtG8/SFmAN66bx0Mlj2ktCQzFhCGb5lHS8XyT3DOroNARLrYzelcj000S0n0VNa7V0lIHjs82+dAwhmSqch5iievSUe3I05wWt2uHRm5TVWAUYOxw/8IoT1LpfA/3JY85O7VbHjNLAqJCrgTceqxYIdNRtc5laMdo1FuzL2EpTjyFoc2Y8Y7azdo5hESfkKa6fiE7PKWreQ+G0sZteEZKCADuMZ1Q2f1Tir8FvLSLaOhZ2eUvpX1OOD5IVQBPPRr4P3u7bgnaEv6rvhXpENv5nMESDYynlA9lXHQqrk+5a3jdXLJm6fILXp/S/GwR4EGAMHgxU/5SbAjTVqwJdX0t3KoKksCvu5EYLP/BC+IVhuRr8e8JIKpBz5Bwy8Ae6KFIglnGJQM6mlQhABMCcvCDWvh/mbRtWtFxnRQ1WL47KhiQ1nThEq1mX9RH59cQSYZtqYA+zPwR8Z/IgbEzrnJw1DPBrafLw7RdeskWP6gt/TnrXf9m8vidXRSrz5N/X97ndDNCkzV9bICAQeLTAgfgbcFot6CSTOtJNjisJwfNtHmqbk83LJPw8oaoCn/sglg0JU3gfMwWxFnvZ2viTiD8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB4438.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(136003)(376002)(39830400003)(346002)(66946007)(38100700002)(38350700002)(66556008)(66476007)(8676002)(31696002)(86362001)(31686004)(36756003)(52116002)(83380400001)(6506007)(6666004)(478600001)(6486002)(41300700001)(6512007)(316002)(110136005)(2616005)(2906002)(186003)(5660300002)(26005)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzNTMEJKZ21NK2ZtTlFscEd0OUpNcFIwZVNRVWVYdHFLalAxdXBhU3BOc01o?=
 =?utf-8?B?UHJ0bjliSElyRzRPR294SE1ieEdteHI4OGhCU0o5VWcyb0dreDhmaWdLMWhr?=
 =?utf-8?B?czE5MWh5T2JwN0ZybVRTcnlkVXY2U3NuNzdrNStRUEM4enRscG1NMnhtVnZC?=
 =?utf-8?B?Wm1KMWZ0aXdKbmorcHJ4UzlxUkltUGJ4OGVGMVpFUnJlbGZ0QUhTRDE4NlVl?=
 =?utf-8?B?SjJsaFhYWVhRLzlvZFpCZ00wRk9jNWhZYnNVV01lOWRDSlE3eUlVQkxNOGpz?=
 =?utf-8?B?VDhTZkJ1ZHNacmNMVGl1QVJ0TXM1ZVIxWVJNZS9yQ0JGa3U4REZkWGFvZjBE?=
 =?utf-8?B?TER1bFFSVjV0OERsbFg5YzVoMHVVZEtlbDV1Sk16YkttSEM5YWwxajh5T0Uv?=
 =?utf-8?B?SGMxVFhRQUN6S2JTYUhDbDNCSjJtSFl1ZnJnUTB0VEU5clI4WUQ4R2U2SE94?=
 =?utf-8?B?a2Mza20zL21NOFp6WE5xR3FnM3o0NTNqZ3dKVnY4ZHJzc0laQnVsUEtlMWpG?=
 =?utf-8?B?b3pmNm9LS0N2dUZ5VkRoVTVlN1liS1ErMjhMb1Y2ZXA0OVdKdldTazUvNUdl?=
 =?utf-8?B?UFpZWFF1RGlBVGdlOXRndjJpWmlXQk1mZWRzMXlBeTd6VHJvNExOQ2RyVVpI?=
 =?utf-8?B?VlVyNzdSSXA2YzA5L3E2UFk0SDZFRzRkenhkZlVzb3FzUXMrRms2QkltS3ZH?=
 =?utf-8?B?em5SN3RFUjB5d3p5OVppZzY3b3NvVWJYb1o0WGhIUE5nTS9NV0RVQTJ4cjhI?=
 =?utf-8?B?SWdjcTlhVjdHTzllWGxUSCtpaTUyN1pnVU1WZ1JsbGdYNVcwbys0WXcyb2ls?=
 =?utf-8?B?MXhKRmNSOHc2N2d0OHFqZFhDQ010eFY5dEtHeUE3dzQycWxBMHRuZ3lrM3BV?=
 =?utf-8?B?eE5nV1dLWnpHaEhHMGYveGpSV2ZKT2Rpc0ErV1VXb0VJeXRBMnZCVGJGbVFm?=
 =?utf-8?B?bE5rRi9ETjJyRmdNVFVnckpndjB0aFpoOTVrdVdYZjlXam02RlF0MDJsTU1x?=
 =?utf-8?B?dktENnZCVmxaRHJUdDhhUE5PbzQ5REF5U1NyVkplUDB5d2hMbFJWWFcrZmRY?=
 =?utf-8?B?SldaVEtYazUxNjZDT3d1dE5NUU9HUTVpcGJJMGtFV2ZoSEJrWTVVTkRDSWRl?=
 =?utf-8?B?MkJmVFZtZmdVZTJ5cWpFU2ZPT0VjN2ZLMFc3clBYZW84WUh6MHpJQUQxcExo?=
 =?utf-8?B?bmVJa0NBWFRuUVU0VFhvWmF6WWpGYmxmWHd3VHNOcVFBaE9BTTVsTjRBam83?=
 =?utf-8?B?bElaeVIycXpYV28wYmU0aUVBTnM4OEVpNzBqeDdLcllGMnpBbXA2bmpNWC9K?=
 =?utf-8?B?Um9iWFB1SmVYNTJ4UC9wTERoRTZ3d2tLRlQ2Z3NrNWorUjU5QkZ6VHVBSFMz?=
 =?utf-8?B?VnNoS1FXbEVJRk1wbXZEV0d1M0EvTWR0ZmpzZFNhRHFNdmcwSTdhSFpwbFdG?=
 =?utf-8?B?Q0xyVEl1NFdHT0EzV0JBeitvVFo1WWhWR1BjWWdMM09CQjY0QnkxaGsxaHFX?=
 =?utf-8?B?S2tqRGFhK0V6OXJqT3I5OG11RUZtMmVIRExSZXltQmZOUHBGQUFlVmtacmls?=
 =?utf-8?B?V3ZLUHdTYlZOc3ZreGFiRWpxNnFNTFVpb0VkS1oydGVNdFh2akcrWHR1b2du?=
 =?utf-8?B?NXRLdW41d3FpbkZsTE9JTFNBcG41QnBqY041RG9sSG96bjFEUUpFY0lLZzQ4?=
 =?utf-8?B?Z2pyUFluNCtQd21FN3g0a1lEZ0F5UnF6c2QvOGZhRlNicGJGa1NQQmNQeVZ3?=
 =?utf-8?B?aXZvenJZcGMvSVhkVmppSHJJSE9YUi9KcVF2cFlrTGVXTE5ZS3M1blNTWXVk?=
 =?utf-8?B?SGhRWUhnNUppRE9ocVNsSCtONzdhUDV0S3NiM0w4QXpaRFFNYmdUTTNhcU96?=
 =?utf-8?B?YXZpM1ZrU3JvdnNKZlVZWnJKSFdLaU05SWNYTUkwcDF1ZGIrOFYrS3VPTnVE?=
 =?utf-8?B?RWd5SVFPRW5FSXowSS9MZW1hSXA3QTROblJkS05uVURSRUFzUnRKSG5mTmIr?=
 =?utf-8?B?eXRhalY0dmp1dlhuL3ZKbThLM3VuT3ZZWlhTdkJaTm5FenVWMFZuK3lYd1Q0?=
 =?utf-8?B?emdid1orVytQY2lTRkIzUHErVU1BdWZlbGlyeFlKVmlmd2poMGxQMFdnVzZF?=
 =?utf-8?Q?iJmM=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca074f7e-af72-42d3-d50e-08da8829f730
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB4438.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2022 12:45:05.5430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dATVUdqCPRJQ5u+oi1dszewxTQ0cZxqPpmYQjlFWRZejVLVO+4+RADMXcv9yS61T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB7318
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/26/2022 8:38 PM, Long Li wrote:...
>> -/* Default maximum number of SGEs in a RDMA send/recv */
>> -#define SMBDIRECT_MAX_SGE	16
>> +/* Maximum number of SGEs needed by smbdirect.c in a send work
>> request */
>> +#define SMBDIRECT_MAX_SEND_SGE	5
> 
> I see the following comment in fs/cifs/smb2pdu.h:
> /*
>   * Maximum number of iovs we need for an open/create request.
>   * [0] : struct smb2_create_req
>   * [1] : path
>   * [2] : lease context
>   * [3] : durable context
>   * [4] : posix context
>   * [5] : time warp context
>   * [6] : query id context
>   * [7] : compound padding
>   */
> #define SMB2_CREATE_IOV_SIZE 8
> 
> Maybe using 8 is safer?

Thanks for taking a look!

SMB Direct re-frames the SMB3 request and the rq_iov's don't
always marshal the same way when they're transmitted over
RDMA. Sometimes they go in different packets, or get turned
into RDMA channel descriptors. So there isn't always a 1:1
mapping.

Also, I haven't perfectly convinced myself this comment is
correct. There is a good bit of optional context insertion,
and some buffer sharing, in SMB2_open_init(). And don't
forget SMB2_TRANSFORMs, compounds, and other SMB3 goop.

Either way, I don't think a "safer" number is a good idea.
It's just kicking the can down the road, and btw "8" still
won't fix the softiWARP compatibility issue. The best fix
may be to refactor smbdirect.c to build the requests more
compactly, so a crisp marshaling strategy can work, always.

I'm scraping some test gear together and I'll be taking a
deeper look next week. Maybe get some focused testing when
we're at the upcoming SDC IOLab.

Tom.
