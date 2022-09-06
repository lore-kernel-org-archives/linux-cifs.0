Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 052B9ECAAD5
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Sep 2022 16:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbiIFQTb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Sep 2022 12:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbiIFQTL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Sep 2022 12:19:11 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320F887680
        for <linux-cifs@vger.kernel.org>; Tue,  6 Sep 2022 08:47:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPQbb65ZdFkeNih8OoHzy7RsbK4khw+SgDq3y+/VuFsh6XxBWjLSxYqUvS/5sdNo3ifQaTfHWhFeZ6TN7zjJsVw2+XBxHeygurWGVYWYGEgLdqs1CwqiBntRrC3MKfyWg5j1suBHDLZH1j56EbpXIsoQRbUkMwitcgEoo6u+QRPK581wa+JVzvsVSjuzuubOHjg5VkHovvehFlJQFgDGSg3R0z9RLNfWfeeoihgpgY8KLRDlw8dzxr8Ij/WoN3fkRMIxgmRrbw6/NMJJRI4ZZil/Gy/tZ5Z02TVYSpcmF5Rwsiu5GEbyHJQ+N7Q5ulJhZOJ9/PN/mwg+Xyow51OQtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qzlq6HhyY6w6wEJCC83y4UUqTPn1xqgL7mznfg1dtQ4=;
 b=lngzCmJNx+sSJV7TDVguF5cNKSpgYyz8usBOIC1kXgSTY2ww13+Vr/L7WrrozjpMmyFnS1xb1Hm4EMky9i4d3avbKFYHFvbTRpQsdI4qsNtmpayPH7wcO+n1SQYkMf7APa7B+syHuW0MBP5+3CL8Z9uuB5qEDTJefuO2utjQ394HBLdsHbzZ8TviUcsHYoWgnCVKpJlmt1d5/ELBpANdajcVZRP+FAh+vBlClJqhxVWX6OwX3n2j/naT0UyyFwsZ77I+8lZjhj9CHHe5uu0Y5+VV2EImVBK6EjpNbtJDvoYbNhGoXfp2GV1roj5vqcF5uYNp/nmm74/GFCcJu2YNQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SA1PR01MB6751.prod.exchangelabs.com (2603:10b6:806:1a6::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.10; Tue, 6 Sep 2022 15:47:51 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b%4]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 15:47:51 +0000
Message-ID: <a644c02b-8a43-0c35-c843-26c8ed9ad0bf@talpey.com>
Date:   Tue, 6 Sep 2022 11:47:49 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] cifs: perf improvement - use faster macros ALIGN() and
 round_up()
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        nspmangalore@gmail.com
References: <20220906013040.2467-1-ematsumiya@suse.de>
 <CAN05THRK3hPQ0c4h9bxhrJYa17eH7NjXKe4Gj8upCcuMvPB2cQ@mail.gmail.com>
 <20220906144102.yfxvwx2jbs3iy2x3@cyberdelia>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220906144102.yfxvwx2jbs3iy2x3@cyberdelia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR0102CA0047.prod.exchangelabs.com
 (2603:10b6:208:25::24) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92884fcf-8228-42ee-f05e-08da901f279b
X-MS-TrafficTypeDiagnostic: SA1PR01MB6751:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ZybRn9xf53H6T/n5x/1gorMYUx2mNS7huaE0BCJw7Pdge2rNGiSeX8h3mQZ2x1DorDkeatCMgBchD/8K5pTQpPCfF4HjU0nmqNHKXYZv40j2wAbzUATe6qViwiUcW1J8lI1rIACe/tD2VDfxi1Tni5QGZM70f4qFGuH2sbguZf/4FcJIedvUer0yuPERd9G3F9m96nhTFPDk3B0DIBWNavOWlQT8yTymjQy+QGoKZE0C5RYAwm77z5piCbWNzCYcY9uUFzCCprOpXUPaF4uNrkhMfXLy6RszJO5GyhuH44QKKdJ0hH7XbnQe3OCQ0IojemA13EAtUo5wWwzHPUTqgdIcqEYLQbOjEqUvyGSvHyw0cYBtz3yji0uMiyVUojhXk/mphJ5hrQ4sm029Z8FJE5yFy76AzMUg60zEcBIrfcY04h0YIwXBcRscSnHNvy2vnvwFdQ2fnqnKl4CcHuiFGQzoY2CbEAJTyodNtU0Cgy//24LEIdGFaTUHQYzJcS/BJpOnNVCtcHWrmgO7GsO+1a1TtmDqUiHZCN76+qPUPnTWVJUhTSGkNvm6RGSSiWVVOcZ48aQlbAwy/eZkqb7cV0mCHuuqJuoew9qSMZATjKN2HRXJ8NhVOzC29M0wm1rPKKnJz9AYJuizx+Z2eodlojH3dDpwW2S0mtRt5oDOEAG2QYkkCoZ03TGnJx8omzlIEp7cTeD1rn8w09EE4l7HaONdOBKjE1CtLLjXOLppQ3qxE9eyr9BezbbQHHrwgXwsidKb229W0CAgOWxNla/H5RecHNSQJm6AuNiPVmirE8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(136003)(396003)(39830400003)(366004)(8936002)(2906002)(5660300002)(30864003)(41300700001)(38350700002)(478600001)(38100700002)(6486002)(52116002)(6506007)(53546011)(110136005)(316002)(66476007)(4326008)(66556008)(66946007)(8676002)(83380400001)(186003)(26005)(6512007)(36756003)(31696002)(2616005)(86362001)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVFLTG14aEk0czNQTW56bU80bDNaN3o2dXJLYzIxZDJLeVhYeFMxd3FOT1No?=
 =?utf-8?B?ZU1NWlJNSXl5M29wdFFHVFFHZVBLdkVwZHliRzZISGN5SGhYcmJMMkM4UlVs?=
 =?utf-8?B?T3BVK21GR2l1V3VSQ1JCbkN5VHJmUEpxYzNOSC9pRFJLcFp6WGtGYkJBN0sx?=
 =?utf-8?B?WC9xeGZHWWtpL0JpQnplZFBndVJqb1Q2UTFoYnp3Vi9vT3VheHVyOUZsZ3FD?=
 =?utf-8?B?NTEwUFhBNDhTcVhlMk4rQVJmZ0x6eDhNMHlwaHJCVXVuazZVbUlyOFRkUm9t?=
 =?utf-8?B?dFZRdjFKeWVTeG5GSjVWV2pvVXl0OVdKR0NUV2FaOFdHVTlCNk9GSDRvR21t?=
 =?utf-8?B?cUdqcU1ZNnd2aVdCZ29KUFBxRjUvMXZVRUluQ3o4Qnk4bmU4ZU9HSmR4Nm9j?=
 =?utf-8?B?b1o0RlVMb0NONHlpUEpodC84aGlxUUkyRCtKdGp0UGdGMnlOb3JHcUh0VDgv?=
 =?utf-8?B?QnhrTG9kQk9acHVlNWEwU0dxbDlUUmlOKy9VZ2Fob0FSczVBb3FxbFpQam0r?=
 =?utf-8?B?R0E4RFVYbE5CQmExbVFZV1J0eTV1eFByeVBGcXhyeWllYmJzbmRRdzRMZUp2?=
 =?utf-8?B?bVNHWXYraWFKYjZ4a3pQbDQvK1p5R3RRVHdmMmp6WEJxNGpySFh6eWJLN1V4?=
 =?utf-8?B?cEhIUWlUckxSOExVRHJXSk42enppZnErWHh5b05lc2VFbDhxRVV3ZnlIRVM5?=
 =?utf-8?B?VkJrV3ljQkl4RXVCTDRUNWlJR0pKdVJYblhvT29yZnBxRGkyTlgxOVJlckY4?=
 =?utf-8?B?aTVuTWxDUDYzT2ZBZkE5Q3dzM3dvM0NWQkVDeFZNQnQxVWtDS0ptbkVXelpO?=
 =?utf-8?B?a3B2ZlJRT1AxUFEwSmpmcTdLK21hOHVrbisyU3BZYjBaZG0rSmg5RnFYUi9H?=
 =?utf-8?B?S2QvQzdXaVlYNzk5Vi9RUnFIb2VqbjZwRDE4d1dUNEpSc0pCZjVjY1V1dUdo?=
 =?utf-8?B?ekdGb0FreDEwRUVOYUFoMmhHL3RCWnJQUGpJMHUxSzA3bWZ6ME8wdVFOL0hC?=
 =?utf-8?B?c0Y2S0dmR2pwNTdzektvNU5zLzJYaUNZQUdvUFBGRFNTOUpwdUg2bmlzc2pI?=
 =?utf-8?B?MHE1cnF5NUIwRHJqaGVQSDFobVh6em9hY0pON2l6a1BrTnE2bnd2cTlYNG9u?=
 =?utf-8?B?UzRsdWZ2UkxDOWxsSG5CTWpuM3RwRnQwQmR1STFwdUtqUFFuVFljOTRLU3hH?=
 =?utf-8?B?TUlHMVo4YUVXakJTcU1zOTBUOUZwc2ZKK00za3puRmk0L3RXaWVhZE42c1F2?=
 =?utf-8?B?aVJjM1JUZVNBQ1hVQWhtSWhVOG9GbkNhS2tVTkwwbE9YLysrQkNWenZRS0t3?=
 =?utf-8?B?Szhndno1SWw2dk9pSTdIRmpZTjdFbC9LbldOc0pQR1RsSjlCUUlCYUZHa1Nx?=
 =?utf-8?B?YkV1akxKTVRsc0NKYWVDOUlSRTgvdHN5TS81MFNPK2xhTGtDQzZxWTgxc2tL?=
 =?utf-8?B?bHVnb2dxL3k2TFNxazdIOG1iMUh4d3l5MzBaZ09SMm5SUWZkWGErVDlaN2Y1?=
 =?utf-8?B?eUtVd2p5VWpEVGwxR1kwUFJvZlIyUFpNNmIrcGFxbGpGUVoyMlVVTFV3M3dT?=
 =?utf-8?B?Q294c0lNd2tCa0FkVVB4Qldyb1VZVU8yMjMvVFhUNUV5SlpVNWw1dFhHdExQ?=
 =?utf-8?B?bWJlMWwxQXlJWnN6aTI5L0I2RnNvb0xGTFdlbk5BUmlrNXZGdnlGR1orUzhy?=
 =?utf-8?B?RGNQZ0FxYkJzMisrdU5wcGorUHVacGJXdXdnMXp3Q2xrM0ZwaTJLRFd6WHhv?=
 =?utf-8?B?RndNTWhicGI3eWNOV25jOEM2L0k5dVBlTkRTZG81VkF6Qi9kNUFEZE9qblE0?=
 =?utf-8?B?RlpUdExvdERKQkVsL1VMeEk5empDUFZDOVhmZFdncjFnS2dLUWpMOFBCMTNQ?=
 =?utf-8?B?RXJ0Qy95N0s3dFMzU08rdjhRaEt4MndmR3dySFpzRkxmVUpRVW9RZENDNUNx?=
 =?utf-8?B?VFV6SGpEYjlnVGpnS2ttK1ovTklYaGsyWncrbEtKeG0vRHpCRUZML0lkK0o3?=
 =?utf-8?B?VTJScmUzcFVwRmxybDFaTy9QUUo4bHJlbXJaeVJpWE9rVnIrMlpMeFZyRjFC?=
 =?utf-8?B?MGRzdlkwOWc0WG1iQ00vaEM1cDlZSDNNbS8xd3ZEbUNKVjgzOGVEci8xNHZ4?=
 =?utf-8?Q?NBMoHBc7U+TG0Qup3274s323E?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92884fcf-8228-42ee-f05e-08da901f279b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 15:47:51.0982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZpMBv0Cjx4pCsEarRtClv5MiNToSyZyfdIBr5yjKG8iWvM6U3pqnSDL1lQRoBSVi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB6751
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/6/2022 10:41 AM, Enzo Matsumiya wrote:
> On 09/06, ronnie sahlberg wrote:
>> Very nice. The performance change can not be explained, but nice cleanup.
>>
>> Reviewed by me
> 
> Thanks, Ronnie. Multiplication and division operations have higher CPU
> cost (cycles) than simple bitwise operations; in x86-64, multiplications
> can cost ~5x more, and divisions ~20x more (there's actually a huge
> variation from system to system, but I'd say those numbers are a good
> guesstimate). So the ALIGN()/round_up() macros, that don't do any mult/div,
> are faster, and in cases like ours, where they'll be called billions of
> times on any non-trivial workload, the number of cycles saved adds up
> and performance improves.

In addition to polluting fewer registers and generally being more
lightweight to frob just four low bits.

I am a bit shocked at the improvement though. It's almost worth a
fully profiled before/after analysis.

Reviewed-by: Tom Talpey <tom@talpey.com>


> Cheers,
> 
> Enzo
> 
>>
>> On Tue, 6 Sept 2022 at 11:31, Enzo Matsumiya <ematsumiya@suse.de> wrote:
>>>
>>> Replace hardcoded alignment computations (e.g. (len + 7) & ~0x7) of
>>> (mostly) SMB2 messages length by ALIGN()/IS_ALIGNED() macros (right
>>> tools for the job, less prone to errors).
>>>
>>> But also replace (DIV_ROUND_UP(len, 8) * 8) with ALIGN(len, 8), which,
>>> if not optimized by the compiler, has the overhead of a multiplication
>>> and a division. Do the same for roundup() by replacing it by round_up()
>>> (division-less version, but requires the multiple to be a power of 2,
>>> which is always the case for us).
>>>
>>> Also remove some unecessary checks where !IS_ALIGNED() would fit, but
>>> calling round_up() directly is just fine as it'll be a no-op if the
>>> value is already aligned.
>>>
>>> Afraid this was a useless micro-optimization, I ran some tests with a
>>> very light workload, and I observed a ~50% perf improvement already:
>>>
>>> Record all cifs.ko functions:
>>>   # trace-cmd record --module cifs -p function_graph
>>>
>>> (test-dir has ~50MB with ~4000 files)
>>> Test commands after share is mounted and with no activity:
>>>   # cp -r test-dir /mnt/test
>>>   # sync
>>>   # umount /mnt/test
>>>
>>> Number of traced functions:
>>>   # trace-cmd report -l | awk '{ print $6 }' | grep "^[0-9].*" | wc -l
>>> - unpatched: 307746
>>> - patched: 313199
>>>
>>> Measuring the average latency of all traced functions:
>>>   # trace-cmd report -l | awk '{ print $6 }' | grep "^[0-9].*" | jq 
>>> -s add/length
>>> - unpatched: 27105.577791262822 us
>>> - patched: 14548.665733635338 us
>>>
>>> So even though the patched version made 5k+ more function calls (for
>>> whatever reason), it still did it with ~50% reduced latency.
>>>
>>> On a larger scale, given the affected code paths, this patch should
>>> show a relevant improvement.
>>>
>>> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>>> ---
>>> Please let me know if my measurements are enough/valid.
>>>
>>>  fs/cifs/cifssmb.c   |  7 +++---
>>>  fs/cifs/connect.c   | 11 ++++++--
>>>  fs/cifs/sess.c      | 18 +++++--------
>>>  fs/cifs/smb2inode.c |  4 +--
>>>  fs/cifs/smb2misc.c  |  2 +-
>>>  fs/cifs/smb2pdu.c   | 61 +++++++++++++++++++--------------------------
>>>  6 files changed, 47 insertions(+), 56 deletions(-)
>>>
>>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>>> index 7aa91e272027..addf3fc62aef 100644
>>> --- a/fs/cifs/cifssmb.c
>>> +++ b/fs/cifs/cifssmb.c
>>> @@ -2305,7 +2305,7 @@ int CIFSSMBRenameOpenFile(const unsigned int 
>>> xid, struct cifs_tcon *pTcon,
>>>                                         remap);
>>>         }
>>>         rename_info->target_name_len = cpu_to_le32(2 * len_of_str);
>>> -       count = 12 /* sizeof(struct set_file_rename) */ + (2 * 
>>> len_of_str);
>>> +       count = sizeof(struct set_file_rename) + (2 * len_of_str);
>>>         byte_count += count;
>>>         pSMB->DataCount = cpu_to_le16(count);
>>>         pSMB->TotalDataCount = pSMB->DataCount;
>>> @@ -2796,7 +2796,7 @@ CIFSSMBQuerySymLink(const unsigned int xid, 
>>> struct cifs_tcon *tcon,
>>>                 cifs_dbg(FYI, "Invalid return data count on get 
>>> reparse info ioctl\n");
>>>                 goto qreparse_out;
>>>         }
>>> -       end_of_smb = 2 + get_bcc(&pSMBr->hdr) + (char 
>>> *)&pSMBr->ByteCount;
>>> +       end_of_smb = sizeof(__le16) + get_bcc(&pSMBr->hdr) + (char 
>>> *)&pSMBr->ByteCount;
>>>         reparse_buf = (struct reparse_symlink_data *)
>>>                                 ((char *)&pSMBr->hdr.Protocol + 
>>> data_offset);
>>>         if ((char *)reparse_buf >= end_of_smb) {
>>> @@ -3350,8 +3350,7 @@ validate_ntransact(char *buf, char **ppparm, 
>>> char **ppdata,
>>>         pSMBr = (struct smb_com_ntransact_rsp *)buf;
>>>
>>>         bcc = get_bcc(&pSMBr->hdr);
>>> -       end_of_smb = 2 /* sizeof byte count */ + bcc +
>>> -                       (char *)&pSMBr->ByteCount;
>>> +       end_of_smb = sizeof(__le16) + bcc + (char *)&pSMBr->ByteCount;
>>>
>>>         data_offset = le32_to_cpu(pSMBr->DataOffset);
>>>         data_count = le32_to_cpu(pSMBr->DataCount);
>>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>>> index a0a06b6f252b..389127e21563 100644
>>> --- a/fs/cifs/connect.c
>>> +++ b/fs/cifs/connect.c
>>> @@ -2833,9 +2833,12 @@ ip_rfc1001_connect(struct TCP_Server_Info 
>>> *server)
>>>          * sessinit is sent but no second negprot
>>>          */
>>>         struct rfc1002_session_packet *ses_init_buf;
>>> +       unsigned int req_noscope_len;
>>>         struct smb_hdr *smb_buf;
>>> +
>>>         ses_init_buf = kzalloc(sizeof(struct rfc1002_session_packet),
>>>                                GFP_KERNEL);
>>> +
>>>         if (ses_init_buf) {
>>>                 ses_init_buf->trailer.session_req.called_len = 32;
>>>
>>> @@ -2871,8 +2874,12 @@ ip_rfc1001_connect(struct TCP_Server_Info 
>>> *server)
>>>                 ses_init_buf->trailer.session_req.scope2 = 0;
>>>                 smb_buf = (struct smb_hdr *)ses_init_buf;
>>>
>>> -               /* sizeof RFC1002_SESSION_REQUEST with no scope */
>>> -               smb_buf->smb_buf_length = cpu_to_be32(0x81000044);
>>> +               /* sizeof RFC1002_SESSION_REQUEST with no scopes */
>>> +               req_noscope_len = sizeof(struct 
>>> rfc1002_session_packet) - 2;
>>> +
>>> +               /* == cpu_to_be32(0x81000044) */
>>> +               smb_buf->smb_buf_length =
>>> +                       cpu_to_be32((RFC1002_SESSION_REQUEST << 24) | 
>>> req_noscope_len);
>>>                 rc = smb_send(server, smb_buf, 0x44);
>>>                 kfree(ses_init_buf);
>>>                 /*
>>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>>> index 3af3b05b6c74..951874928d70 100644
>>> --- a/fs/cifs/sess.c
>>> +++ b/fs/cifs/sess.c
>>> @@ -601,11 +601,6 @@ static void unicode_ssetup_strings(char 
>>> **pbcc_area, struct cifs_ses *ses,
>>>         /* BB FIXME add check that strings total less
>>>         than 335 or will need to send them as arrays */
>>>
>>> -       /* unicode strings, must be word aligned before the call */
>>> -/*     if ((long) bcc_ptr % 2) {
>>> -               *bcc_ptr = 0;
>>> -               bcc_ptr++;
>>> -       } */
>>>         /* copy user */
>>>         if (ses->user_name == NULL) {
>>>                 /* null user mount */
>>> @@ -1318,7 +1313,7 @@ sess_auth_ntlmv2(struct sess_data *sess_data)
>>>         }
>>>
>>>         if (ses->capabilities & CAP_UNICODE) {
>>> -               if (sess_data->iov[0].iov_len % 2) {
>>> +               if (!IS_ALIGNED(sess_data->iov[0].iov_len, 2)) {
>>>                         *bcc_ptr = 0;
>>>                         bcc_ptr++;
>>>                 }
>>> @@ -1358,7 +1353,7 @@ sess_auth_ntlmv2(struct sess_data *sess_data)
>>>                 /* no string area to decode, do nothing */
>>>         } else if (smb_buf->Flags2 & SMBFLG2_UNICODE) {
>>>                 /* unicode string area must be word-aligned */
>>> -               if (((unsigned long) bcc_ptr - (unsigned long) 
>>> smb_buf) % 2) {
>>> +               if (!IS_ALIGNED((unsigned long)bcc_ptr - (unsigned 
>>> long)smb_buf, 2)) {
>>>                         ++bcc_ptr;
>>>                         --bytes_remaining;
>>>                 }
>>> @@ -1442,8 +1437,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
>>>
>>>         if (ses->capabilities & CAP_UNICODE) {
>>>                 /* unicode strings must be word aligned */
>>> -               if ((sess_data->iov[0].iov_len
>>> -                       + sess_data->iov[1].iov_len) % 2) {
>>> +               if (!IS_ALIGNED(sess_data->iov[0].iov_len + 
>>> sess_data->iov[1].iov_len, 2)) {
>>>                         *bcc_ptr = 0;
>>>                         bcc_ptr++;
>>>                 }
>>> @@ -1494,7 +1488,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
>>>                 /* no string area to decode, do nothing */
>>>         } else if (smb_buf->Flags2 & SMBFLG2_UNICODE) {
>>>                 /* unicode string area must be word-aligned */
>>> -               if (((unsigned long) bcc_ptr - (unsigned long) 
>>> smb_buf) % 2) {
>>> +               if (!IS_ALIGNED((unsigned long)bcc_ptr - (unsigned 
>>> long)smb_buf, 2)) {
>>>                         ++bcc_ptr;
>>>                         --bytes_remaining;
>>>                 }
>>> @@ -1546,7 +1540,7 @@ _sess_auth_rawntlmssp_assemble_req(struct 
>>> sess_data *sess_data)
>>>
>>>         bcc_ptr = sess_data->iov[2].iov_base;
>>>         /* unicode strings must be word aligned */
>>> -       if ((sess_data->iov[0].iov_len + sess_data->iov[1].iov_len) % 
>>> 2) {
>>> +       if (!IS_ALIGNED(sess_data->iov[0].iov_len + 
>>> sess_data->iov[1].iov_len, 2)) {
>>>                 *bcc_ptr = 0;
>>>                 bcc_ptr++;
>>>         }
>>> @@ -1747,7 +1741,7 @@ sess_auth_rawntlmssp_authenticate(struct 
>>> sess_data *sess_data)
>>>                 /* no string area to decode, do nothing */
>>>         } else if (smb_buf->Flags2 & SMBFLG2_UNICODE) {
>>>                 /* unicode string area must be word-aligned */
>>> -               if (((unsigned long) bcc_ptr - (unsigned long) 
>>> smb_buf) % 2) {
>>> +               if (!IS_ALIGNED((unsigned long)bcc_ptr - (unsigned 
>>> long)smb_buf, 2)) {
>>>                         ++bcc_ptr;
>>>                         --bytes_remaining;
>>>                 }
>>> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
>>> index b83f59051b26..4eefbe574b82 100644
>>> --- a/fs/cifs/smb2inode.c
>>> +++ b/fs/cifs/smb2inode.c
>>> @@ -207,7 +207,7 @@ smb2_compound_op(const unsigned int xid, struct 
>>> cifs_tcon *tcon,
>>>                 rqst[num_rqst].rq_iov = &vars->si_iov[0];
>>>                 rqst[num_rqst].rq_nvec = 1;
>>>
>>> -               size[0] = 1; /* sizeof __u8 See MS-FSCC section 
>>> 2.4.11 */
>>> +               size[0] = sizeof(u8); /* See MS-FSCC section 2.4.11 */
>>>                 data[0] = &delete_pending[0];
>>>
>>>                 rc = SMB2_set_info_init(tcon, server,
>>> @@ -225,7 +225,7 @@ smb2_compound_op(const unsigned int xid, struct 
>>> cifs_tcon *tcon,
>>>                 rqst[num_rqst].rq_iov = &vars->si_iov[0];
>>>                 rqst[num_rqst].rq_nvec = 1;
>>>
>>> -               size[0] = 8; /* sizeof __le64 */
>>> +               size[0] = sizeof(__le64);
>>>                 data[0] = ptr;
>>>
>>>                 rc = SMB2_set_info_init(tcon, server,
>>> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
>>> index d73e5672aac4..258b01306d85 100644
>>> --- a/fs/cifs/smb2misc.c
>>> +++ b/fs/cifs/smb2misc.c
>>> @@ -248,7 +248,7 @@ smb2_check_message(char *buf, unsigned int len, 
>>> struct TCP_Server_Info *server)
>>>                  * Some windows servers (win2016) will pad also the 
>>> final
>>>                  * PDU in a compound to 8 bytes.
>>>                  */
>>> -               if (((calc_len + 7) & ~7) == len)
>>> +               if (ALIGN(calc_len, 8) == len)
>>>                         return 0;
>>>
>>>                 /*
>>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>>> index 6352ab32c7e7..5da0b596c8a0 100644
>>> --- a/fs/cifs/smb2pdu.c
>>> +++ b/fs/cifs/smb2pdu.c
>>> @@ -466,15 +466,14 @@ build_signing_ctxt(struct 
>>> smb2_signing_capabilities *pneg_ctxt)
>>>         /*
>>>          * Context Data length must be rounded to multiple of 8 for 
>>> some servers
>>>          */
>>> -       pneg_ctxt->DataLength = cpu_to_le16(DIV_ROUND_UP(
>>> -                               sizeof(struct 
>>> smb2_signing_capabilities) -
>>> -                               sizeof(struct smb2_neg_context) +
>>> -                               (num_algs * 2 /* sizeof u16 */), 8) * 
>>> 8);
>>> +       pneg_ctxt->DataLength = cpu_to_le16(ALIGN(sizeof(struct 
>>> smb2_signing_capabilities) -
>>> +                                           sizeof(struct 
>>> smb2_neg_context) +
>>> +                                           (num_algs * sizeof(u16)), 
>>> 8));
>>>         pneg_ctxt->SigningAlgorithmCount = cpu_to_le16(num_algs);
>>>         pneg_ctxt->SigningAlgorithms[0] = 
>>> cpu_to_le16(SIGNING_ALG_AES_CMAC);
>>>
>>> -       ctxt_len += 2 /* sizeof le16 */ * num_algs;
>>> -       ctxt_len = DIV_ROUND_UP(ctxt_len, 8) * 8;
>>> +       ctxt_len += sizeof(__le16) * num_algs;
>>> +       ctxt_len = ALIGN(ctxt_len, 8);
>>>         return ctxt_len;
>>>         /* TBD add SIGNING_ALG_AES_GMAC and/or 
>>> SIGNING_ALG_HMAC_SHA256 */
>>>  }
>>> @@ -511,8 +510,7 @@ build_netname_ctxt(struct 
>>> smb2_netname_neg_context *pneg_ctxt, char *hostname)
>>>         /* copy up to max of first 100 bytes of server name to 
>>> NetName field */
>>>         pneg_ctxt->DataLength = cpu_to_le16(2 * 
>>> cifs_strtoUTF16(pneg_ctxt->NetName, hostname, 100, cp));
>>>         /* context size is DataLength + minimal smb2_neg_context */
>>> -       return DIV_ROUND_UP(le16_to_cpu(pneg_ctxt->DataLength) +
>>> -                       sizeof(struct smb2_neg_context), 8) * 8;
>>> +       return ALIGN(le16_to_cpu(pneg_ctxt->DataLength) + 
>>> sizeof(struct smb2_neg_context), 8);
>>>  }
>>>
>>>  static void
>>> @@ -557,18 +555,18 @@ assemble_neg_contexts(struct smb2_negotiate_req 
>>> *req,
>>>          * round up total_len of fixed part of SMB3 negotiate request 
>>> to 8
>>>          * byte boundary before adding negotiate contexts
>>>          */
>>> -       *total_len = roundup(*total_len, 8);
>>> +       *total_len = ALIGN(*total_len, 8);
>>>
>>>         pneg_ctxt = (*total_len) + (char *)req;
>>>         req->NegotiateContextOffset = cpu_to_le32(*total_len);
>>>
>>>         build_preauth_ctxt((struct smb2_preauth_neg_context 
>>> *)pneg_ctxt);
>>> -       ctxt_len = DIV_ROUND_UP(sizeof(struct 
>>> smb2_preauth_neg_context), 8) * 8;
>>> +       ctxt_len = ALIGN(sizeof(struct smb2_preauth_neg_context), 8);
>>>         *total_len += ctxt_len;
>>>         pneg_ctxt += ctxt_len;
>>>
>>>         build_encrypt_ctxt((struct smb2_encryption_neg_context 
>>> *)pneg_ctxt);
>>> -       ctxt_len = DIV_ROUND_UP(sizeof(struct 
>>> smb2_encryption_neg_context), 8) * 8;
>>> +       ctxt_len = ALIGN(sizeof(struct smb2_encryption_neg_context), 8);
>>>         *total_len += ctxt_len;
>>>         pneg_ctxt += ctxt_len;
>>>
>>> @@ -595,9 +593,7 @@ assemble_neg_contexts(struct smb2_negotiate_req 
>>> *req,
>>>         if (server->compress_algorithm) {
>>>                 build_compression_ctxt((struct 
>>> smb2_compression_capabilities_context *)
>>>                                 pneg_ctxt);
>>> -               ctxt_len = DIV_ROUND_UP(
>>> -                       sizeof(struct 
>>> smb2_compression_capabilities_context),
>>> -                               8) * 8;
>>> +               ctxt_len = ALIGN(sizeof(struct 
>>> smb2_compression_capabilities_context), 8);
>>>                 *total_len += ctxt_len;
>>>                 pneg_ctxt += ctxt_len;
>>>                 neg_context_count++;
>>> @@ -780,7 +776,7 @@ static int smb311_decode_neg_context(struct 
>>> smb2_negotiate_rsp *rsp,
>>>                 if (rc)
>>>                         break;
>>>                 /* offsets must be 8 byte aligned */
>>> -               clen = (clen + 7) & ~0x7;
>>> +               clen = ALIGN(clen, 8);
>>>                 offset += clen + sizeof(struct smb2_neg_context);
>>>                 len_of_ctxts -= clen;
>>>         }
>>> @@ -2413,7 +2409,7 @@ create_sd_buf(umode_t mode, bool set_owner, 
>>> unsigned int *len)
>>>         unsigned int group_offset = 0;
>>>         struct smb3_acl acl;
>>>
>>> -       *len = roundup(sizeof(struct crt_sd_ctxt) + (sizeof(struct 
>>> cifs_ace) * 4), 8);
>>> +       *len = round_up(sizeof(struct crt_sd_ctxt) + (sizeof(struct 
>>> cifs_ace) * 4), 8);
>>>
>>>         if (set_owner) {
>>>                 /* sizeof(struct owner_group_sids) is already 
>>> multiple of 8 so no need to round */
>>> @@ -2487,7 +2483,7 @@ create_sd_buf(umode_t mode, bool set_owner, 
>>> unsigned int *len)
>>>         memcpy(aclptr, &acl, sizeof(struct smb3_acl));
>>>
>>>         buf->ccontext.DataLength = cpu_to_le32(ptr - (__u8 *)&buf->sd);
>>> -       *len = roundup(ptr - (__u8 *)buf, 8);
>>> +       *len = round_up((unsigned int)(ptr - (__u8 *)buf), 8);
>>>
>>>         return buf;
>>>  }
>>> @@ -2581,7 +2577,7 @@ alloc_path_with_tree_prefix(__le16 **out_path, 
>>> int *out_size, int *out_len,
>>>          * final path needs to be 8-byte aligned as specified in
>>>          * MS-SMB2 2.2.13 SMB2 CREATE Request.
>>>          */
>>> -       *out_size = roundup(*out_len * sizeof(__le16), 8);
>>> +       *out_size = round_up(*out_len * sizeof(__le16), 8);
>>>         *out_path = kzalloc(*out_size + sizeof(__le16) /* null */, 
>>> GFP_KERNEL);
>>>         if (!*out_path)
>>>                 return -ENOMEM;
>>> @@ -2687,20 +2683,17 @@ int smb311_posix_mkdir(const unsigned int 
>>> xid, struct inode *inode,
>>>                 uni_path_len = (2 * UniStrnlen((wchar_t *)utf16_path, 
>>> PATH_MAX)) + 2;
>>>                 /* MUST set path len (NameLength) to 0 opening root 
>>> of share */
>>>                 req->NameLength = cpu_to_le16(uni_path_len - 2);
>>> -               if (uni_path_len % 8 != 0) {
>>> -                       copy_size = roundup(uni_path_len, 8);
>>> -                       copy_path = kzalloc(copy_size, GFP_KERNEL);
>>> -                       if (!copy_path) {
>>> -                               rc = -ENOMEM;
>>> -                               goto err_free_req;
>>> -                       }
>>> -                       memcpy((char *)copy_path, (const char 
>>> *)utf16_path,
>>> -                              uni_path_len);
>>> -                       uni_path_len = copy_size;
>>> -                       /* free before overwriting resource */
>>> -                       kfree(utf16_path);
>>> -                       utf16_path = copy_path;
>>> +               copy_size = round_up(uni_path_len, 8);
>>> +               copy_path = kzalloc(copy_size, GFP_KERNEL);
>>> +               if (!copy_path) {
>>> +                       rc = -ENOMEM;
>>> +                       goto err_free_req;
>>>                 }
>>> +               memcpy((char *)copy_path, (const char *)utf16_path, 
>>> uni_path_len);
>>> +               uni_path_len = copy_size;
>>> +               /* free before overwriting resource */
>>> +               kfree(utf16_path);
>>> +               utf16_path = copy_path;
>>>         }
>>>
>>>         iov[1].iov_len = uni_path_len;
>>> @@ -2826,9 +2819,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct 
>>> TCP_Server_Info *server,
>>>                 uni_path_len = (2 * UniStrnlen((wchar_t *)path, 
>>> PATH_MAX)) + 2;
>>>                 /* MUST set path len (NameLength) to 0 opening root 
>>> of share */
>>>                 req->NameLength = cpu_to_le16(uni_path_len - 2);
>>> -               copy_size = uni_path_len;
>>> -               if (copy_size % 8 != 0)
>>> -                       copy_size = roundup(copy_size, 8);
>>> +               copy_size = round_up(uni_path_len, 8);
>>>                 copy_path = kzalloc(copy_size, GFP_KERNEL);
>>>                 if (!copy_path)
>>>                         return -ENOMEM;
>>> @@ -4090,7 +4081,7 @@ smb2_new_read_req(void **buf, unsigned int 
>>> *total_len,
>>>         if (request_type & CHAINED_REQUEST) {
>>>                 if (!(request_type & END_OF_CHAIN)) {
>>>                         /* next 8-byte aligned request */
>>> -                       *total_len = DIV_ROUND_UP(*total_len, 8) * 8;
>>> +                       *total_len = ALIGN(*total_len, 8);
>>>                         shdr->NextCommand = cpu_to_le32(*total_len);
>>>                 } else /* END_OF_CHAIN */
>>>                         shdr->NextCommand = 0;
>>> -- 
>>> 2.35.3
>>>
> 
