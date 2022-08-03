Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98CB4C19F28
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Aug 2022 14:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbiHCOe4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Aug 2022 10:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbiHCOez (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Aug 2022 10:34:55 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472E8275FF
        for <linux-cifs@vger.kernel.org>; Wed,  3 Aug 2022 07:34:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dg6UsyoqmBQEAMiPhlJVUNw6SQhU0knwD29DBHm+2LxRglZyIs74iIvDX9yXFAIJ0364lTwmW+OaMHcHBkazzW5KqL4X2SCqhW815l+KcQpaZibsgLKicjk9Ems7t9r2kMQZ10QMczjWeGKGkjXKxiVOyqAKkhup1qcccEsWaSR01EsfzcWVK1jrh1Yrz9FGrbKYb4lBVNQkNrFzraA1Zaz4CmaBFYbuM3ePli+zxPm0UCjum4m3buMkMcIlLkjpYkpcbVX8fJIwIB5ZkkaaFTo5/Xr7CiftuwXx0fzltmIDWptMvRkY5GA1a54Y2ilZKTp6G7HxGN228r3oZ0VtfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ioHb65ZlXTZwCUwFa9nuxY8qni8GfZC1OyUF4nzBEJ4=;
 b=f7HXRVLcOAUuw8oOptsPTkA6KOfTV5JiOrlSMSKH+5MlJLg7ubP3d9d0nJUgZkH3vLh9PzUBKBDsnG1qbMcWC/jPhFOec9Tw1R6CaZ3EmIvDu72/xLTh7Y4B6Cv+ND6SwZeADmD+/T3y6JjKJeixhtSV08Ubwu8E9pmHFPJsojwwAP1jmv5dcgWLi/db/v4LHxjNNo4L6ZmMtJhNeURUsjD7xUopZX+oMczcFcC9gLLT+pnL5Vn04UQu3Mx5YGESacYn+V0TlGiXIhjqv/88ea13/KPDa/oFFNZ0NWk1wwtmyIWhq88GF1EV+n28RFgiil6OU7J0q01qPZ1vvD0zJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB5495.prod.exchangelabs.com (2603:10b6:a03:11b::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.14; Wed, 3 Aug 2022 14:34:51 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5482.016; Wed, 3 Aug 2022
 14:34:51 +0000
Message-ID: <64fa262a-9629-1a94-4314-a218b686b46b@talpey.com>
Date:   Wed, 3 Aug 2022 10:34:49 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH] cifs: smbdirect: use the max_sge the hw reports
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, David Howells <dhowells@redhat.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Long Li <longli@microsoft.com>
References: <20220803022042.10543-1-linkinjeon@kernel.org>
 <d1e09264-bec2-8dfd-c793-6fc7c528b1c5@talpey.com>
In-Reply-To: <d1e09264-bec2-8dfd-c793-6fc7c528b1c5@talpey.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR07CA0003.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::13) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c639380-de81-43b6-8bee-08da755d528b
X-MS-TrafficTypeDiagnostic: BYAPR01MB5495:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3lnGTIFXCSxzpls+C3mvcXDQpNXFtJZGJ1I/HXzyd0+Fzq31iTqhomn0rgxMuEJ2DxQuh5rlTDCVqXKylz8JZNj7HwdSJtyZusxK2UnS6sQ0GUrNvMv9WcLMBmRN2fDhURA89cTVAKodf2/7/Bt3z1PYeHIV9oMvREjWyKwOqSoASxWXZGvTuzOU3L5jbkIuATCr1xr85QFbUZf1Sy8nQ/xgZSFPpsSxjGNeJjtntVNIS1RlJII3oD7NlA1ObAkiblWd/pdyxfRRTKFtTa+O9JktrFJRvdjzy5Vrj/I2REdR7cid2Y+yDTj2t/zg48iOssZ+OQ4IlYOYFVFeZQ18ezg+LPnVzS14dvP77RcgRvwE52gehKMSZ7ST5cI04MMPkmMc2PsXrnrX92J+04DX8iKu95c3JoyFjZDiFJXoRmBEEr2fhG3fn+gKOAEWXF9EkQqCPhbqjKZNBzH3BxFVoIW0d04RDGh3z6uKeJKjtCd/Cl+GEu7KSnuRp3tnNznsojE1VXXjo40bqi82ylMaTOVwPKsfMdWf+pbkakEqjauktFCikkDK9u2Ey3zRw/NoZlI0AfhNGnwSA1m92NvWIxzy4T8NbgsDcWCLCxuc5dRxYwsIrm58t6qOQxzA9xXvEBCN1IL739zbJ2PzmVjX9OQMed/hRsYiTR03H+PAjgwO7gHeLBpqt/uFs1BZAylv7jEQYSWKn5FaRHSDRN/yjK1VC4VzRdsuNB+A2LFFqO40kbQFwYtFukqqMmQwH17oBNJpetWlqDQh6g8pthzgCEc/+0bgKDp7L94m7i1Mf10So9cQamgydjFAfHP0LkLQp0llXhjb9vmaeJt9lwl8hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(39830400003)(366004)(376002)(346002)(136003)(396003)(2906002)(4326008)(8676002)(66946007)(54906003)(5660300002)(66476007)(66556008)(86362001)(31696002)(38350700002)(26005)(38100700002)(83380400001)(45080400002)(31686004)(6512007)(316002)(478600001)(41300700001)(8936002)(36756003)(52116002)(53546011)(6506007)(6486002)(186003)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWxpU2wxNDRTSHd0L00xbG1SY1U3Um9VdW81LzNYT01vcTZQVUI0ZCt1YSs0?=
 =?utf-8?B?TDZwNmFsSDU4KzRnclFmZk5EM01TUzE0YVgyc2JINXJzaG03Rnpna1ZPK2d2?=
 =?utf-8?B?YlJnaTZCL1dHWHNobzJiM2RPOTQvVmwvdjFDUmJYL2tHckF4T2I4SnJQaVdU?=
 =?utf-8?B?bW9YTmNEaVlPM3RDWVRSNUFDY0J4OEhXY0h5ZDlDUVhBOFRQQ29ZaTNkeElU?=
 =?utf-8?B?MjFUNS9uWk85d0FRZUZTcjhFTDB0OURDSnpnZWNaSHNlQlRoZnZiTnRCbzFW?=
 =?utf-8?B?ZkQrZlgrWVJGM2dXaS8xOVhLanBkOE1TWm56clBRNmNudldhNWRIdU9sT1Fh?=
 =?utf-8?B?eDczVUY2dWRmYzc2dEtCemlUeCtCd1hySjVGdy9tQy9WQ1lQTVlRWDAyTmNp?=
 =?utf-8?B?eFBITzhqZTY3WTMwRDZJelB1OWhMYjlTMmtDYkY4L2JqcUtNcjNrWnc0MFN2?=
 =?utf-8?B?WlMvdkVyVDcvbWdkU2VtMEREN2t2TGRJYzNXS0lCa3RRMUhZTmdHUnhFbFEy?=
 =?utf-8?B?UDIwcW9kWnBrKzVVQzZtamNENjRlb2ZZcWRaa1JQOG5uMG5OditXNWo3andX?=
 =?utf-8?B?SDlqQXhOZjE2VGZoandNL0I0RmdqZ2hoTXlEUXVjeWVJK05PcVBGY0k0UWZG?=
 =?utf-8?B?dm9oU2pRTnQ0SHFRUGxVVXNhcktPaGtCZG5KRFNrdXZuOWdBbjl6b2Zud2RB?=
 =?utf-8?B?ekRVOUJtaElFL0dlVlNYc1grYVR4YkJSMmlJeFVFMWxIK3Jlb0tKVlgyMkMr?=
 =?utf-8?B?bjRRbWtyeVlPclg1UUo1NlU4RVBBNy84Snpzb2JUcjJLNk9abnVVREdhTGho?=
 =?utf-8?B?YWlTT3h0eWFDcmwwemVyUzNXWW85MHVxUFBzM0lrWG1qdVJHN3NtZXc4T1A5?=
 =?utf-8?B?SUUrNmZQazB5K0FlOFhkVGVDcVVkMnZrMzI3cXVYRk8xallOSnZ2RjV0RjFP?=
 =?utf-8?B?OWtXQXFhWWRDNG9BOVl1bmVBaVpPYk5rYUNQN0pReURhNUlRV056bm13Z2xR?=
 =?utf-8?B?ZUFOTTlvZlpNcHJHSzZRaGJPQll0anBRdm1TU1dyQ1JJZTlLa28yK2F2Z3Yx?=
 =?utf-8?B?SFA3bDdZa1JVNlVWbXp5ektVTTRFT1MvQ0xaQzluc2RuVEdvQUtrOS8yVHNK?=
 =?utf-8?B?ZWk0dGJmemQ2bW1zS2I3ZFJHcVBpaENNVk5wTXFiUm4wVzBxWlV4TDE3cXQw?=
 =?utf-8?B?QUxmSVdGdkdtSEFYR21sQ1F3ak1XSWFlZkNkOG8zeXZVNDBuSlYxM005aGx3?=
 =?utf-8?B?UUVydUFBVjM3aUlLS3dIU2svK3lDdDBUcnJFOUJTRVYxNkJsTkt4Y2tBU1JX?=
 =?utf-8?B?QVM3TEc3aUhNTy8wWnRjZnlpNHMrUW1KQVdMdUUxM3dQOUJXSW5PcDlUTUxN?=
 =?utf-8?B?WlNjb3h3VnVLUTNZd1RrR01RTWtiWU9RQkRDMjNVb3c3VWZyeVV5K1RyMUlW?=
 =?utf-8?B?OVJhdDl1ZDRNSEJSVWVQTzhMd2hzT0cxNnJYTU5OcXNCQXNKM3NZdXk3ZXZ2?=
 =?utf-8?B?MTlqcnlhYkw2T2JTRUM1WXZhUVVVMkRDaUR5NkNUdWtuT1VaQ0U0dWV0NUs1?=
 =?utf-8?B?ZFlTNnV4ajl5TStCNXg2RGkrRlUvOU5BelFVWG9OdFRGeDdKME0zczFVZmpq?=
 =?utf-8?B?dXBrS2dOaFNzMi8yMlNuWTVZN3NWeFk3b28wc0ZjSXg3Y09YOTBrQy9VTER0?=
 =?utf-8?B?Q2p6NzVmalhPSTVkaC9Dd25QbzhOZlBENkQrb0dLRTE2b0JDYU9adkNmaDlL?=
 =?utf-8?B?bE1nalQ1V2syM0tBN2NOUkhRY0NSck9NNno0bXZ3MmZBcFp2VERRTHhob0J5?=
 =?utf-8?B?eDJNR0lmRmw1SmNNZ0dEZHRYUXRoREhiazFyb1h0d2hXRjBGdVJLMnkyNFBF?=
 =?utf-8?B?YjAxbFhyTE5Ic09ZbGpKZlZPeUkyTkZwc2Z4NkE0MG5vMmtZUFBibzNPd3RL?=
 =?utf-8?B?NGpLSTN1U0RNWmFTQVROTDJvNFZSZ09jaG85VDhuWDcrQTRJZEhzVXlBT3Zp?=
 =?utf-8?B?YWMvZTdnNnJzaFdQNTUrRGVUbXJIb1M1V093R3ZJSExDdk5KdFk1SXJGdEVt?=
 =?utf-8?B?eXh1MkJJQjVJMUpiOS93MDduSlgwVTNYMDByRVZ2ekNKdDdtbHlKU3N1dU1W?=
 =?utf-8?Q?nhfk=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c639380-de81-43b6-8bee-08da755d528b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 14:34:50.5038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hbEUeQKZyK9B8AwAVIRrI1fOHGJvQXNbc+pnDwpLi9qOUUyquwJtxlrK+AG5ahBd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB5495
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Oops, I typed "ksmbd" below, I meant "smbdirect client".
However, fewer sge's are always better, and ksmbd may
well have different requirements than "cifs", making a
hardcoded value even less appropriate.

On 8/3/2022 10:26 AM, Tom Talpey wrote:
> On 8/2/2022 10:20 PM, Namjae Jeon wrote:
>> In Soft-iWARP, smbdirect does not work in cifs client.
>> The hardcoding max_sge is large in cifs, but need smaller value for
>> soft-iWARP. Add SMBDIRECT_MIN_SGE macro as 6 and use the max_sge
>> the hw reports instead of hardcoding 16 sge's.
> 
> There is no issue in SoftiWARP, the bug is in ksmbd, so I think
> the message is incorrect. May I suggest:
> 
>   "Use a more appropriate max_sge, and ensure it does not exceed the
>    RDMA provider's maximum. This enables ksmbd to function on
>    SoftiWARP, among potentially others."
> 
> More comments below.
> 
>> Cc: Tom Talpey <tom@talpey.com>
>> Cc: David Howells <dhowells@redhat.com>
>> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>> Cc: Long Li <longli@microsoft.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   fs/cifs/smbdirect.c | 15 ++++++++++-----
>>   fs/cifs/smbdirect.h |  3 ++-
>>   2 files changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
>> index 5fbbec22bcc8..bb68702362f7 100644
>> --- a/fs/cifs/smbdirect.c
>> +++ b/fs/cifs/smbdirect.c
>> @@ -1518,7 +1518,7 @@ static int allocate_caches_and_workqueue(struct 
>> smbd_connection *info)
>>   static struct smbd_connection *_smbd_get_connection(
>>       struct TCP_Server_Info *server, struct sockaddr *dstaddr, int port)
>>   {
>> -    int rc;
>> +    int rc, max_sge;
>>       struct smbd_connection *info;
>>       struct rdma_conn_param conn_param;
>>       struct ib_qp_init_attr qp_attr;
>> @@ -1562,13 +1562,13 @@ static struct smbd_connection 
>> *_smbd_get_connection(
>>       info->max_receive_size = smbd_max_receive_size;
>>       info->keep_alive_interval = smbd_keep_alive_interval;
>> -    if (info->id->device->attrs.max_send_sge < SMBDIRECT_MAX_SGE) {
>> +    if (info->id->device->attrs.max_send_sge < SMBDIRECT_MIN_SGE) {
>>           log_rdma_event(ERR,
>>               "warning: device max_send_sge = %d too small\n",
>>               info->id->device->attrs.max_send_sge);
>>           log_rdma_event(ERR, "Queue Pair creation may fail\n");
>>       }
>> -    if (info->id->device->attrs.max_recv_sge < SMBDIRECT_MAX_SGE) {
>> +    if (info->id->device->attrs.max_recv_sge < SMBDIRECT_MIN_SGE) {
>>           log_rdma_event(ERR,
>>               "warning: device max_recv_sge = %d too small\n",
>>               info->id->device->attrs.max_recv_sge);
>> @@ -1593,13 +1593,18 @@ static struct smbd_connection 
>> *_smbd_get_connection(
>>           goto alloc_cq_failed;
>>       }
> 
> Why are the two conditions treated differently? It prints a rather
> vague warning if the send sge is exceeded, but it fails if the
> receive sge is too large.
> 
> I suggest failing fast in both cases, but the code gives no way
> for the user to correct the situation, SMBDIRECT_MIN_SGE is a
> hardcoded constant. That's the bug
> 
> IIRC, the ksmbd code requires 3 send sge's for send, and it needs
> 5 sge's when SMB3_TRANSFORM is needed. Why not provide a variable
> sge limit, depending on the session's requirement?
> 
>> +    max_sge = min3(info->id->device->attrs.max_send_sge,
>> +               info->id->device->attrs.max_recv_sge,
>> +               SMBDIRECT_MAX_SGE);
>> +    max_sge = max(max_sge, SMBDIRECT_MIN_SGE);
> 
> This is inaccurate. ksmbd's send sge requirement is not necessarily
> the same as its receive sge, likewise the RDMA provider's limit.
> There is no reason to limit one by the other, and they should be
> calculated independently.
> 
> What is the ksmbd receive sge requirement? Is it variable, like
> the send, depending on what protocol features are needed?
> 
>> +
>>       memset(&qp_attr, 0, sizeof(qp_attr));
>>       qp_attr.event_handler = smbd_qp_async_error_upcall;
>>       qp_attr.qp_context = info;
>>       qp_attr.cap.max_send_wr = info->send_credit_target;
>>       qp_attr.cap.max_recv_wr = info->receive_credit_max;
>> -    qp_attr.cap.max_send_sge = SMBDIRECT_MAX_SGE;
>> -    qp_attr.cap.max_recv_sge = SMBDIRECT_MAX_SGE;
>> +    qp_attr.cap.max_send_sge = max_sge;
>> +    qp_attr.cap.max_recv_sge = max_sge;
> 
> See previous comment.
> 
>>       qp_attr.cap.max_inline_data = 0;
>>       qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
>>       qp_attr.qp_type = IB_QPT_RC;
>> diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
>> index a87fca82a796..8b81301e4d4c 100644
>> --- a/fs/cifs/smbdirect.h
>> +++ b/fs/cifs/smbdirect.h
>> @@ -225,7 +225,8 @@ struct smbd_buffer_descriptor_v1 {
>>       __le32 length;
>>   } __packed;
>> -/* Default maximum number of SGEs in a RDMA send/recv */
>> +/* Default maximum/minimum number of SGEs in a RDMA send/recv */
>> +#define SMBDIRECT_MIN_SGE    6
> 
> See previous comment, and also, please justify the "6".
> 
> David Howells commented it appears to be "5", at least for send.
> I think with a small refactoring to allocate a more flexible header
> buffer, it could be even smaller.
> 
> I would hope the value for receive is "2", or less. But I haven't
> looked very deeply yet.
> 
> With sge's and an RDMA provider, the smaller the better. The adapter
> will always be more efficient in processing work requests. So doing
> this right is beneficial in many ways.
> 
>>   #define SMBDIRECT_MAX_SGE    16
> 
> While we're at it, please justify "16". Will ksmbd ever need so many?
> 
>>   /* The context for a SMBD request */
>>   struct smbd_request {
> 
> Tom.
> 
