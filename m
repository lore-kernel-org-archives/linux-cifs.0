Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E161C19F28
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Aug 2022 14:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237433AbiHCO05 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Aug 2022 10:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236779AbiHCO0z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Aug 2022 10:26:55 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EF126124
        for <linux-cifs@vger.kernel.org>; Wed,  3 Aug 2022 07:26:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P53otR6v4L1WJZ814LnviDLADiigg+jUEWfNfAfDOC7hPnOLNpf5GZEUUUgIMuJcqXcwdBjr0zoSu5kUrTLppUDrBoHRXxriaLGgzfdUtaaawaLiN4qJjq7tsjG8Cx+akwi7rFUjncaRqXtmrDfcxxtjOi/0YY1Xa3V2VtDoZ7kWxOnylPx5hbg2K0iQbXb4HVW3qYTz0WHck7ndzLdTcOO36zIug2giOsGMP8lOwVMZtJSfQj7jF/yKHSgHOQBRJ6Euh5UuCv/HaU3WdgR4neaD7DJD3eZ3vPkNchwPnLYyYiM6uRWorDIyAn2RL4qyFe1CPN/9ORFENwGz9OCdhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CcQayc3LLK7pMvrnyB0JcJu9syPVGU/6da7nHNSUhoA=;
 b=R4pAiyTfdJOaUvpfN2lCB7ed+lmS7TwFl5bybTxYU2farwk5LxX6ZcVmvL2O1Fy803esKuZe9eom9N1iNIE4ZtlX7bDDl2VIDC5GNEdAKsr6pMqqI3raeXFkhqiXct+peuXQNbJGVPmieMR36igwOSWH99ZshKUhQFPxCORke0+8ZdequsXBG5e9YOEPPL3Ew1VO/WieCUaUaYTnDQWhCXdJHQ1x1jlJZubpOgj99orgojvWPNnHWGO1DWGugqvpk1aw96koVz0t1tEDCUgDWAcEHQmmnnbF/8v1mmHTwlEoqoF3A+uW0hMz8jSH0NRn9vWyrj4jfG/HFNtjtbCfzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 CY4PR01MB2454.prod.exchangelabs.com (2603:10b6:903:68::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.12; Wed, 3 Aug 2022 14:26:50 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5482.016; Wed, 3 Aug 2022
 14:26:49 +0000
Message-ID: <d1e09264-bec2-8dfd-c793-6fc7c528b1c5@talpey.com>
Date:   Wed, 3 Aug 2022 10:26:48 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH] cifs: smbdirect: use the max_sge the hw reports
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, David Howells <dhowells@redhat.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Long Li <longli@microsoft.com>
References: <20220803022042.10543-1-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220803022042.10543-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0051.namprd02.prod.outlook.com
 (2603:10b6:207:3d::28) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c395564-56bb-4ebc-91de-08da755c33d8
X-MS-TrafficTypeDiagnostic: CY4PR01MB2454:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tbdtwAzDiUwX+gGyoIHznYrAA3J53yVE2PmByAwX2gm/L4YHTYuZYFqJAAH4DldkVo7DdIHR52Ee1Xv+jjXFThPKeBFuEmh0rUYvr+Fj5s2Qm/kOt2VVKs0zKJ5DoBuvkX2QaWXFMaxDD+KVYCr68m3zuXXyIXGSEU0RObsvwh6+9dVX9gPjBxpU5jeh3nAkuFttLectG+gsWg/wTIgxvGrwb6lP2nCje6a758WswLpGcQOK+qRtyvKwm7jIqXtLpcs8ycQcHETIyFnqNaFbKOWIbeWLA9xVfeVYDxYUeH43asYHrNPEdNul7Dag7CLuUnj43rmEVse5IuvUmjKvugAV+YmCzLelVdxp8NkOUSuGz+K2uurr34QCUm7vafI6UWDBLochwpoBTRwgLCfe1kVJ7FB9rKdUvf1xrm8qlEpweOCyE+3jrYProzOfSd8LVse06NAVyrP2ROIkisM7RF7jzDrTbrSoVhqunsPta8Z5tDOjayqvCRAwFkDXieo/FJUvwdSCgcW/59F3kA7PnsDhv6hDrYetgB2Nsy2+ORBG0z5E5nRmyMm5Li2LV/M9qhC2fHwESQQyDQjfasO/yMlWEglLGxvNNYDLPYmO7m3t8wDygGBe6U6N8Kuff3KSQyIVkq4PuCUXXkrY8n2Tsq6LLohR6L0GEwxffrP/OctPv+UsPvVaao+JXYdaWSyV3powBzXu7D3UVNlx2Vs4LnvENqAyOTaeq9dStWbHbWgi7EO+NmlyOGsWRCslNvzJB35V3M6D7CivUlGb7p2uOZC+2RakgTamh7YOiHsjFupt+OQuQJGycARV9L59NJAJ2SJKA/vQeEAla4NikH4o6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(346002)(376002)(39830400003)(366004)(36756003)(6512007)(31686004)(26005)(478600001)(5660300002)(2616005)(45080400002)(86362001)(41300700001)(6486002)(66946007)(31696002)(66556008)(8936002)(8676002)(66476007)(4326008)(186003)(54906003)(83380400001)(52116002)(38350700002)(53546011)(2906002)(316002)(6506007)(38100700002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFZMZUNXUmlaa0JlQWt3cGdFa1RRMXlON0JxODFkNXFXWG1KVmxCTHNCQ3Vu?=
 =?utf-8?B?ZHMxcjdZRWRuUzNMQkR0TWg1K1NwNFkzN3hXUDllZktrTUZXWEhmYS9aUUdr?=
 =?utf-8?B?VzBPYVJGNHM4SStSOTk4YkdrVUk5dmZXZGRDcVNIT0RVajdUK0hCTGJzcC9t?=
 =?utf-8?B?WndiSE9GeXlaYTFXWnRoQWQrYkVWMmoyZHJuajQ0WHlRU3dab3llblZ3bUNE?=
 =?utf-8?B?TDFKRWxyS1F6bDdFZnIrM2M5b3Q5WU9kejcwRm9NT0FjcXR0eTlGdEVTZE1Z?=
 =?utf-8?B?dU56TktuaDBMVUtyNHhNb2dJanY0VEY1dHowTFgzZG84MUFvRE9FMmgrci9k?=
 =?utf-8?B?QTdQWGo1OG50UE1RUC8vVU5nVDhGdHNCRTkvNVoxc1A0YW9pUXdDQnF3dXlk?=
 =?utf-8?B?aEt4ZW5DYTZXOE4xU0IwZ1NWS3ZRUGlCQm5nNEtPd3BBOFBJUjFhOVZQdXVI?=
 =?utf-8?B?a05HMnN5cnZycDZRbllsYmhRN3huaGdZelVId2FiUlBzcFNCdjNNTzZKTWNs?=
 =?utf-8?B?N1c5S05QTnhKd2xsWnh3MzRZeFlnUkxTeUNtU2M3cnFza3JwaEp4SXFwWElE?=
 =?utf-8?B?MFUreDZpK2FoSXFtZXh0V2FLUFRhTnJuRWxUMjU3TWdmT29FeUNuTXQwQnZW?=
 =?utf-8?B?azVqMWpTekNKenpzNzBQUHFSdngzRjZhZTVjRUYyVWlUSlowbFd3Vi9lM3Mr?=
 =?utf-8?B?VjlSU0ZhY0FMOHViZWZvMmdmYlNITkpLTXVsNFlwYTFYTjZTSGVXdXpxSXdG?=
 =?utf-8?B?YmJnWUhHT0F5d0g1WnBQVUg1cVFsOFIvc1pJcnVOSkdSZUdqaG5mMk5jTnJz?=
 =?utf-8?B?YUxCN0ZyRmZYMHdPN29QMHZtRUw2NTUxOC9EK2lpcWRaVlBaNjBZSCt6bURP?=
 =?utf-8?B?ZUV2UitnV1JYTVBWMlo5M2NHUm9lWkZOR0dJUmNkTTZWOFJOWGRNVnhGMFpU?=
 =?utf-8?B?ajBrbFlRYkV1Q2lGQ0pCek9SK05nUjhNNmhzRVhseFpkM1FNK1dSQkxXcGV6?=
 =?utf-8?B?VlNWc3paOWFDOEhTS0E3M1RTNjAycnRrVDVvUkdITDViUG1XM3Jtd09GejV6?=
 =?utf-8?B?YXljZmxqVDRyaUR1S0pSbEVzOTNUUit6aDRQS0xGWEJ6TllRU0RtdENQRlR6?=
 =?utf-8?B?REtiZ1o1QmM1bWhSY1I0WXNCc011M3lPckFUdVZIQ0d4bTM4Nk1MU290L2pE?=
 =?utf-8?B?MU9Pcld4NXhORFNJWXM2V3Rsa3AvYmtMSVlJUkR1a3ZXbHpUOXF2a0ZCVXRE?=
 =?utf-8?B?UFZzRCs5VENQeU1TTEwrMGdHUk5Fc1RSY1FMdHIwRWNMT1FlVENscEVUdUpa?=
 =?utf-8?B?TkRCaThoOURvSWNBelIzOG1tNjhQYzFSKzl2Ky9teGpTZnJDMVZIbjZsOVF2?=
 =?utf-8?B?ZXY0K2VVY2ZjMjBQV2g4eWl1Nk9vWjBVSUlHWnZhaEpScHJSUFhLQ2ZxQzF2?=
 =?utf-8?B?UWRrT2g3bGd1eVhwY3VCM3o1NGhUOFFJR3QvNlpNcXVzSG5Iak8ycmhuTHB6?=
 =?utf-8?B?TlFRNXdzK09nQzB1NnozTTRaalhHVzY1eVZOUThvR2hpRXR0RXVSK0VLK2M3?=
 =?utf-8?B?VVg1WUtJYVNLbEIzMXZjcTJ2KzR6d1RnZE9wQURkQUtBS0pybDFPbFVERUYy?=
 =?utf-8?B?Z1pkbE83Q2M4ZGZrdDltQjBTQVdHMElMV3FwdjhRWlVSOGlEQTB2d0lVeVQ2?=
 =?utf-8?B?QWhrRHNaZlFJS3JZY3ZOaEx2UU53OXpIcEdsbk1CdnlHYnZXMFFibjJ0cGZJ?=
 =?utf-8?B?eEo4MG5xQzFvMG5mb2tIeXJsNTE5QVNaR3puUnlVVmgvNXRPajA4V3JyODZh?=
 =?utf-8?B?YUlDRFI2VlZucWJIMUpyWG9MTnNkYUl6Mmh5UFVtQW9xMjhYTzBHMWkwemcy?=
 =?utf-8?B?UUlrb1B6MnVLN05DOUNuZ3VLUnpjRFMwcG9pS3dOTUE5RnBUUjhHVkZtLzdv?=
 =?utf-8?B?eFFMSVZKRXc0UWQ5SGF6NkJ1blUyUU1tSDhIQzlpb1kvaU9pcVNXM0NqZlFw?=
 =?utf-8?B?Y2tXRGtuUjU4TDA4ZUlVTmRKYjBKL1Jxc0N3SHI4RGswSGFNaVp5UVBsUDBD?=
 =?utf-8?B?WVMyYVJiVWZLUGpvREtqa2xsMzFkVGRuRnNrZ1h2Q1ZJZTlwRFM0MUYxRlln?=
 =?utf-8?Q?jQ5A=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c395564-56bb-4ebc-91de-08da755c33d8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 14:26:49.7680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o9OkktYKf/S8UbTumVP83iIa4uWIhcdM1JE42yjBc9U355w7u9EvSFHXH/soj8cb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR01MB2454
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/2/2022 10:20 PM, Namjae Jeon wrote:
> In Soft-iWARP, smbdirect does not work in cifs client.
> The hardcoding max_sge is large in cifs, but need smaller value for
> soft-iWARP. Add SMBDIRECT_MIN_SGE macro as 6 and use the max_sge
> the hw reports instead of hardcoding 16 sge's.

There is no issue in SoftiWARP, the bug is in ksmbd, so I think
the message is incorrect. May I suggest:

  "Use a more appropriate max_sge, and ensure it does not exceed the
   RDMA provider's maximum. This enables ksmbd to function on
   SoftiWARP, among potentially others."

More comments below.

> Cc: Tom Talpey <tom@talpey.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Long Li <longli@microsoft.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/cifs/smbdirect.c | 15 ++++++++++-----
>   fs/cifs/smbdirect.h |  3 ++-
>   2 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index 5fbbec22bcc8..bb68702362f7 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -1518,7 +1518,7 @@ static int allocate_caches_and_workqueue(struct smbd_connection *info)
>   static struct smbd_connection *_smbd_get_connection(
>   	struct TCP_Server_Info *server, struct sockaddr *dstaddr, int port)
>   {
> -	int rc;
> +	int rc, max_sge;
>   	struct smbd_connection *info;
>   	struct rdma_conn_param conn_param;
>   	struct ib_qp_init_attr qp_attr;
> @@ -1562,13 +1562,13 @@ static struct smbd_connection *_smbd_get_connection(
>   	info->max_receive_size = smbd_max_receive_size;
>   	info->keep_alive_interval = smbd_keep_alive_interval;
>   
> -	if (info->id->device->attrs.max_send_sge < SMBDIRECT_MAX_SGE) {
> +	if (info->id->device->attrs.max_send_sge < SMBDIRECT_MIN_SGE) {
>   		log_rdma_event(ERR,
>   			"warning: device max_send_sge = %d too small\n",
>   			info->id->device->attrs.max_send_sge);
>   		log_rdma_event(ERR, "Queue Pair creation may fail\n");
>   	}
> -	if (info->id->device->attrs.max_recv_sge < SMBDIRECT_MAX_SGE) {
> +	if (info->id->device->attrs.max_recv_sge < SMBDIRECT_MIN_SGE) {
>   		log_rdma_event(ERR,
>   			"warning: device max_recv_sge = %d too small\n",
>   			info->id->device->attrs.max_recv_sge);
> @@ -1593,13 +1593,18 @@ static struct smbd_connection *_smbd_get_connection(
>   		goto alloc_cq_failed;
>   	}

Why are the two conditions treated differently? It prints a rather
vague warning if the send sge is exceeded, but it fails if the
receive sge is too large.

I suggest failing fast in both cases, but the code gives no way
for the user to correct the situation, SMBDIRECT_MIN_SGE is a
hardcoded constant. That's the bug

IIRC, the ksmbd code requires 3 send sge's for send, and it needs
5 sge's when SMB3_TRANSFORM is needed. Why not provide a variable
sge limit, depending on the session's requirement?

> +	max_sge = min3(info->id->device->attrs.max_send_sge,
> +		       info->id->device->attrs.max_recv_sge,
> +		       SMBDIRECT_MAX_SGE);
> +	max_sge = max(max_sge, SMBDIRECT_MIN_SGE);

This is inaccurate. ksmbd's send sge requirement is not necessarily
the same as its receive sge, likewise the RDMA provider's limit.
There is no reason to limit one by the other, and they should be
calculated independently.

What is the ksmbd receive sge requirement? Is it variable, like
the send, depending on what protocol features are needed?

> +
>   	memset(&qp_attr, 0, sizeof(qp_attr));
>   	qp_attr.event_handler = smbd_qp_async_error_upcall;
>   	qp_attr.qp_context = info;
>   	qp_attr.cap.max_send_wr = info->send_credit_target;
>   	qp_attr.cap.max_recv_wr = info->receive_credit_max;
> -	qp_attr.cap.max_send_sge = SMBDIRECT_MAX_SGE;
> -	qp_attr.cap.max_recv_sge = SMBDIRECT_MAX_SGE;
> +	qp_attr.cap.max_send_sge = max_sge;
> +	qp_attr.cap.max_recv_sge = max_sge;

See previous comment.

>   	qp_attr.cap.max_inline_data = 0;
>   	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
>   	qp_attr.qp_type = IB_QPT_RC;
> diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
> index a87fca82a796..8b81301e4d4c 100644
> --- a/fs/cifs/smbdirect.h
> +++ b/fs/cifs/smbdirect.h
> @@ -225,7 +225,8 @@ struct smbd_buffer_descriptor_v1 {
>   	__le32 length;
>   } __packed;
>   
> -/* Default maximum number of SGEs in a RDMA send/recv */
> +/* Default maximum/minimum number of SGEs in a RDMA send/recv */
> +#define SMBDIRECT_MIN_SGE	6

See previous comment, and also, please justify the "6".

David Howells commented it appears to be "5", at least for send.
I think with a small refactoring to allocate a more flexible header
buffer, it could be even smaller.

I would hope the value for receive is "2", or less. But I haven't
looked very deeply yet.

With sge's and an RDMA provider, the smaller the better. The adapter
will always be more efficient in processing work requests. So doing
this right is beneficial in many ways.

>   #define SMBDIRECT_MAX_SGE	16

While we're at it, please justify "16". Will ksmbd ever need so many?

>   /* The context for a SMBD request */
>   struct smbd_request {

Tom.
