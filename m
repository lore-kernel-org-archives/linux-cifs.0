Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84074C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 23 May 2022 16:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236383AbiEWQFf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 May 2022 12:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236298AbiEWQFd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 May 2022 12:05:33 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2042.outbound.protection.outlook.com [40.107.236.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F89427D4
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 09:05:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JjYuJyk24WY46hzBYAyRWSdkO4rCgTKxUzAsaWInALOpIc1NAZxq4wb3DWWQFOS2Ly3p2duGLrPvu8f81wTLtUH2yVG43FlkbbkunNrSKKLh9je2u1mGgqSbizwP2Xv7F3mrR48aq+LSjbYJc8rSOh9CNk658dlsFfrnr7gSTdTd4v6kIXv7U4ZCZ0OTVbhjghgPnZzycQ44GIIhRROmbQ4P4/000vzB1NaCeHwBhGyv7k0ujHlJJEKZtScbMoUS9NzSyaWaZuoasU54nQQoagCQ8OfRBoHUAnusHB9cIXD450EX529wEOKmp2l5qBJNWgNE3D+6O4bre4AU4Z7VYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tk4oA4AQDbzeB5ZjcgkaYOhAP1cs1Vi+SvrbDGdvF/U=;
 b=G7CfViW2VywduusGlEgBeLDqYwrOnyDcDJXHBIzidM+u5uM9zCtlnStty6kyLpiYhCRTPkHlZW0n/yzse/naBzyS+NJ2LNErc4obxhiCdObL8kf0rF8KpdGzG2lzDfJPA1/nxOK04jW5clkr8YZ9sJvQ8sXqyRs2aBETCpnuKR+eMnU9YO/u5byv7zGXu0nSGhx7NbAohnoF8/fYGW7/cFwiC40AnkCotNAbJE9CBUpLvokd4IDXpjMCctRztQe5nxx4fb0y8rgrzcP8Jq4EgB9XtiUcLEwQcCQkjA1jwhQMLMhTFo8sZO/W+MqLsHQeQSsBBMGsu2Uke0+idovypQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BN7PR01MB3652.prod.exchangelabs.com (2603:10b6:406:85::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.14; Mon, 23 May 2022 16:05:30 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::f135:e76f:7ddd:f21]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::f135:e76f:7ddd:f21%3]) with mapi id 15.20.5273.023; Mon, 23 May 2022
 16:05:30 +0000
Message-ID: <307f1f2c-900b-8158-78a8-a3dd7564f2f8@talpey.com>
Date:   Mon, 23 May 2022 12:05:26 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: RDMA (smbdirect) testing
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Long Li <longli@microsoft.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com>
 <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
 <84589.1653070372@warthog.procyon.org.uk>
 <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
 <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com>
 <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com>
 <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0227.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::22) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 373e7556-bffd-460b-5002-08da3cd60e1f
X-MS-TrafficTypeDiagnostic: BN7PR01MB3652:EE_
X-Microsoft-Antispam-PRVS: <BN7PR01MB36525ADAB003CB8EA18EFC79D6D49@BN7PR01MB3652.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iIHjvt3R41ERzY8UKHeqoX8IhcAOnJwTJN5+5/6CuqKZdernJqCCSXwNx9paS4B7CpDKiabuey8FU7Twmn/46xqHbu3Kqr5tTNJZaxnE/8q24NOP7tTbuG61dUC/humM+f4ENNGauavCHznSWyHWTGJiX30AnPwzeyu1O79KccSgkRkJL4kf4fsMPrelmjS6RpP6ysnGEXH5E9hOs/TOmJF69Pwrz86QRSC5/EoED8bdbJk38g+Wf805i8U1yv3tinNlei4CZwKFbdGkaodotoJDyJVDMKf6Gb3DrAJXAKsP35CQN6FdfF5mAVbTrysvLw0UqGu03dwr4gm8VE7+1zQ5m6Ku2+N4pO0GboNwNnckB9O7Et+Qh3psKzVYJdID/nAlD6ekzkM5mGfG31m91BYdNr0IBa0R9ld70XKbQaWfT09LJjD9vvk+dXKbiK8Ka6RrVrIokDDcq2hMK02ZjIKC/04zZix8rcyYik9qQOTps/OlVRel1tyzI7MJ8/g/5GSGL4cteHABkwlrWdDsGmtn2lwPf7RB6GVZPcwKiIvDhNhxrJZTs6DSoSTcZlVojonmzg/ePx53e5I0qeZWkMC7R+Ixy0EPQVGsZNDlZBHrOazKFFFj+THux6njGc8WN0aWxgYo15EDclVHlEtTfvnu9b7qrg/ESW8sttdkLJzZTGL89ogclyXgYawweskhV8qHYfU8jYaq0q4Kv1Ei60fXKnOIwz7rqBGAm2g3bTY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(136003)(376002)(366004)(396003)(39830400003)(316002)(36756003)(6512007)(4326008)(8676002)(31686004)(38350700002)(38100700002)(6916009)(53546011)(41300700001)(186003)(66476007)(66556008)(66946007)(6506007)(52116002)(54906003)(8936002)(83380400001)(6666004)(2906002)(31696002)(86362001)(508600001)(26005)(5660300002)(2616005)(6486002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wlo0ZTY4anAwYkxDTXZDR2JKYU5udFIybC90QzhaWUZKbWttM3NpVTFIQnB2?=
 =?utf-8?B?bkNUVURrMkt5UVZlUEJITjNMQ3kwUVZZVGRUbWgzQjFjL1A5eGEvNkczRCsz?=
 =?utf-8?B?RVJSZjJmY0ROOE5uVHBiaDFHWUMwSVljN09ScWNGajRIeERzZ3ZzdVQ5aSsv?=
 =?utf-8?B?MC91RmhTeTA0cWZPTExFK21ETXBNQitOUnJVbnpHeFVVSHV6dFJrSi9nM3hu?=
 =?utf-8?B?VVVhT2pCSzRtU25lV1pCck5FUkd2Ym5SNEhmdFY1RE1zT1R2VG5jMFVWVHhn?=
 =?utf-8?B?Qm9Fa1dtWkhVeTFvMERHVUVyV3F1WVllQkkvOXhNb3ZIYlU5bTNlSnB1TjFW?=
 =?utf-8?B?bkNqVkl4dUYzVXVPK3VsSkx0MVJmSHJidjJZZlY0RTlyd0Nmdk5YTmMrNFlK?=
 =?utf-8?B?SzBEazVnTlR5SGZKV3F2dzZ3Qmg4dXVqRGhENHJmbFZXMVhnMlorclVYTDhI?=
 =?utf-8?B?T0QxVEJNcU9mZXpyQTUvZC9lOUVCd0lRZXhUbGpKTUxXbmRpSXByeVgyR2p0?=
 =?utf-8?B?ZVg2bGVxbWhscC9rN3VzT1U4RHQvZUdoV0R2bnRYVGVNckxTblpxRTlBcS9B?=
 =?utf-8?B?M2c2RjRNSVNScnJzRTRXY2c4S1hJWUVNN3BMTWUxQ1dMM2RNOGlwUDBCMTMz?=
 =?utf-8?B?NWF2dUlyOWNyWUFPaWFRMm4vbEdVSzRyUUcrRndObWxZVWRQQXdvRGRrTjF1?=
 =?utf-8?B?K0tqcFhVaWg4bW4weHBiOStyVndBeHdBY2lwU0FuTmlVT293NUdLYkpwV0ZP?=
 =?utf-8?B?TzNMeXZjckIvMWdXdjBWQlVhME1IR2tmdVM5aEFJcG9QdEJzKzNJRWIzOFBH?=
 =?utf-8?B?UlZBYzBJWTd5U08zcFJPN1RBalpGTGZLQkpDSUx4MVc3b1d4UGJmVCsrSlMy?=
 =?utf-8?B?N0dwYUE2bFR1T0dSWXJ6SC8zQUhzRVN4TjExNDgzMWtHeDExRjNYN0JwQlRU?=
 =?utf-8?B?R0hDNTJYSUZ1SFhoUWtHZVlwNFNodmxYY29jWnhiNzJZbmVTdkFKcy9MUm16?=
 =?utf-8?B?ckJETDdKdkdyR2RvRitvcndDVlc3OHJaWFhYS0NycmIvV2VXZ2VKVUkwSTZr?=
 =?utf-8?B?WmozZnJXVzhHenhRZmVMdXQ1MEl1cmE4YTJ2Y1Y5cEYrT2l3cnB0S2g2Vko2?=
 =?utf-8?B?OXorcjRSaHRYRE9DdG80OHY1L0cxMUE4SWk2dStURHQ3eXA4MyszM0JDNUpm?=
 =?utf-8?B?dlNBUWhrUWFwUDFWNlVmaUx4RENNcXJzV0dtb09UN3ROZ0RHVlQwTk1pcm5I?=
 =?utf-8?B?NFRaSWNselRRVTBCdWhoeUVsQlJLTkJSZmlSNUw2WjJQTWZkcEVIcXRXSkhW?=
 =?utf-8?B?QjhSalRwa0N2SGJEZ213TTJPbGdNcmhLZkE1c3psbzFwQk85NTRJZjk5UmJZ?=
 =?utf-8?B?MWFmRFJuZDE5ZXE0ank3Y2ZoRy9wSzVIcnBHeTlHR3hYUEpzNVJmemtOMWJp?=
 =?utf-8?B?dGRHQWVVSGFVbkdQeVVCZEtNajlGSVFoaGIwMFlDdHN6djZ1dVJ3enU0cTJV?=
 =?utf-8?B?bGhhV1JpNk5BbzNBTXFhY1dxTndKbFlHVnkybWMyejhXbTZuTitlZUlSbXIw?=
 =?utf-8?B?VHVUSzdxOTZIaFF2T25ZdkV2dFYvSmk5eENud1ErN1VaNS9kRC9USXBiVThF?=
 =?utf-8?B?T3FSdjg4UnVlQ3B4MTVxeEdrbHUyYnJHQ285eXZWT091UXcxY2cxaHRQWURB?=
 =?utf-8?B?b2Rza25HSmprZmRQWFc4WmFOdGtrejlmNXBTdEd0L084QjBEelBweWt1QzhF?=
 =?utf-8?B?b0ovQmducEo0dHB3MHlxaEgvRlpGR2I5WWUwWDJQdEVhTEE4aTVnSGJRRHZw?=
 =?utf-8?B?QWU5WWJ2MVVkZnVMQ1RsTDBNZFdndC9MVXNJUC85TkQwTzdraVBiZ0dabk9N?=
 =?utf-8?B?eVQ4TmdBS1JIRUhVK0FybS9ZbEFtVVlVZFEyeS9LWmR4NDFObDkxcGlTMkdQ?=
 =?utf-8?B?QzN3QVZUNWJ4dHMwQkdSOXJaeGtBaWJNb1B0cjBaS3E5U2k3emJIcVJyNjE5?=
 =?utf-8?B?bTJNRXhId3c2cWpEdFBKbmJ4ak0yYTVyc1psd3ptVngwUVVvSW9xZXJCeDAz?=
 =?utf-8?B?dU44eUpmLzU1UHNFZ1MzSFpVcEdNK2R1c3g1OHZBb1ZMTG9zZHFwMmZSdG9k?=
 =?utf-8?B?eHdnQ0RKbVdNYXk2VHVCMytJTlJFUEhkUm1vcjNXaVJWVUFpWVNEcEhBSFB1?=
 =?utf-8?B?L3BRSXArUkFVeDMxYkpQL0dTeThrVGx1YjBvUXM5WnhTZitPalJWSTdUUjZS?=
 =?utf-8?B?THpQMTBRWGx3RGlkYTJHZ1htSmV3TS9hZkMrT2N1N2tZTERvYWlPeXdPNHZV?=
 =?utf-8?Q?IVp2LhL6TbNFNBXzbh?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 373e7556-bffd-460b-5002-08da3cd60e1f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 16:05:30.4571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XbYPCI9Y2Bj0RT4jojMtHx+TRoOEYi60nSC7jEBuZAPcu5XT0HTxNDfSem8F3N8s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR01MB3652
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 5/23/2022 11:05 AM, Namjae Jeon wrote:
> 2022-05-23 22:45 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> On 5/22/2022 7:06 PM, Namjae Jeon wrote:
>>> 2022-05-21 20:54 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>>> ...
>>>> Why does the code require
>>>> 16 sge's, regardless of other size limits? Normally, if the lower layer
>>>> supports fewer, the upper layer will simply reduce its operation sizes.
>>> This should be answered by Long Li. It seems that he set the optimized
>>> value for the NICs he used to implement RDMA in cifs.
>>
>> "Optimized" is a funny choice of words. If the provider doesn't support
>> the value, it's not much of an optimization to insist on 16. :)
> Ah, It's obvious that cifs haven't been tested with soft-iWARP. And
> the same with ksmbd...
>>
>> Personally, I'd try building a kernel with smbdirect.h changed to have
>> SMBDIRECT_MAX_SGE set to 6, and see what happens. You might have to
>> reduce the r/w sizes in mount, depending on any other issues this may
>> reveal.
> Agreed, and ksmbd should also be changed as well as cifs for test. We
> are preparing the patches to improve this in ksmbd, rather than
> changing/building this hardcoding every time.

So, the patch is just for this test, right? Because I don't think any
kernel-based storage upper layer should ever need more than 2 or 3.
How many memory regions are you doing per operation? I would
expect one for the SMB3 headers, and another, if needed, for data.
These would all be lmr-type and would not require actual new memreg's.

And for bulk data, I would hope you're using fast-register, which
takes a different path and doesn't use the same sge's.

Getting this right, and keeping things efficient both in SGE bookkeeping
as well as memory registration efficiency, is the rocket science behind
RDMA performance and correctness. Slapping "16" or "6" or whatever isn't
the long-term fix.

Tom.

> diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
> index a87fca82a796..7003722ab004 100644
> --- a/fs/cifs/smbdirect.h
> +++ b/fs/cifs/smbdirect.h
> @@ -226,7 +226,7 @@ struct smbd_buffer_descriptor_v1 {
>   } __packed;
> 
>   /* Default maximum number of SGEs in a RDMA send/recv */
> -#define SMBDIRECT_MAX_SGE      16
> +#define SMBDIRECT_MAX_SGE      6
>   /* The context for a SMBD request */
>   struct smbd_request {
>          struct smbd_connection *info;
> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> index e646d79554b8..70662b3bd590 100644
> --- a/fs/ksmbd/transport_rdma.c
> +++ b/fs/ksmbd/transport_rdma.c
> @@ -42,7 +42,7 @@
>   /* SMB_DIRECT negotiation timeout in seconds */
>   #define SMB_DIRECT_NEGOTIATE_TIMEOUT           120
> 
> -#define SMB_DIRECT_MAX_SEND_SGES               8
> +#define SMB_DIRECT_MAX_SEND_SGES               6
>   #define SMB_DIRECT_MAX_RECV_SGES               1
> 
>   /*
> 
> Thanks!
>>
>> Tom.
>>
> 
