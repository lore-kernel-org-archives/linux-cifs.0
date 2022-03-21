Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 548CEC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 18:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352267AbiCUSle (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Mar 2022 14:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350189AbiCUSld (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Mar 2022 14:41:33 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2055.outbound.protection.outlook.com [40.107.92.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3E59D4C7
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 11:40:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNcKLnEaD+PNM36rs4EUZh14gpH3nj0C2YAm2y4W6V1HhWwS3tW6cbtC8pWuyVsPnBbdnqR8mTtCzdxUT1wcCSaEOg9NICEWOeMRtEhnaauD348vcyIDbxYQn69P6jd4C/mHRo9Wd2PgL1KpsH892w5lakzEV3zoG2MiCKuooLGyu2Cmf17j7Yi8ReJJGA+6cgFxeSuH0uwZMnIUzY7+Hunr/J9R/7TQgigbJmVtpHrxeqQAQrFPBotEjQvtaa7zMKJpd8BE+cqq+286yzK+ycMh07TZQR3LQTvsDv7vWfO0l+hQNuUnMRtO39LLa0/gKC+0ubXh4B+5/fgzbO7FrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=747g32Xem8628e8yS8FZ9qM2EZKsplP203uSzn8W0p8=;
 b=RYbycANrsjDZ8h8YyC0Iqllnkl5S/C2SPcs0jS8ktPXUrWIbM3sIf8fADg1T6IEtpsbbImgCgZLTnwRmvwsrzPxIe1qJolDIVPjdJMpDcJMjj80GrGc2/fLxhMSe+csWAGDkadHAMc3oXUpemz+CfpHyam8DnOl6B51Ofvn4QprjzfPlx+OEcz7JTJPg42FGjuHD7Dw/PWr1QqqYb1IjHH+nDNIGrm8O7pkz1c5RUdWaz1TY0QxQIyBOCgWZCssuVlhMgdHRIx2GIvsmMF35U1Na08MY0eHty+EUGL5EnmmUuF+W5zDPQf8Uk+Qtwjz+sk1RdKM+4/61twdmVhZ0Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB4933.prod.exchangelabs.com (2603:10b6:a03:1a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.18; Mon, 21 Mar 2022 18:40:03 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d%4]) with mapi id 15.20.5081.023; Mon, 21 Mar 2022
 18:40:03 +0000
Message-ID: <3cf7045a-360d-33c5-5aaa-45094d5b7e06@talpey.com>
Date:   Mon, 21 Mar 2022 14:40:00 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 2/2] ksmbd: store fids as opaque u64 integers
Content-Language: en-US
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com, linkinjeon@kernel.org
References: <20220321160826.30814-1-pc@cjr.nz>
 <20220321160826.30814-2-pc@cjr.nz>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220321160826.30814-2-pc@cjr.nz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR12CA0027.namprd12.prod.outlook.com
 (2603:10b6:208:a8::40) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73d1d5bb-2796-46d8-18bd-08da0b6a3623
X-MS-TrafficTypeDiagnostic: BYAPR01MB4933:EE_
X-Microsoft-Antispam-PRVS: <BYAPR01MB4933516717B820D806EF4D83D6169@BYAPR01MB4933.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vOvkcYE5jQOABz4vCjr3JRs9a9ViagCsdqffqiCUqES0drNzmiSUJbAI36ErB0zJK/zo0F1Q3n+C71Lw11Myp9JdIE34UoMOpJy+m+o1E96X028Z6B110XgT2uFYM3IwW+xq4dTcG/TWBQj8/XD05VKmaCwVgePY2XHxuB0/WyRkeE9/er9HkbH1dPjSS8QfADMtl+Th54w3NQASXq3wPfuYBe+XTnL6OCc+qPY/vaJOO9KWPx/HtDZwXeFyC6SRijpDOiUF4x/Ri9wTEagfdlKKErBTIsAPM9SXlln77ZLZc6jy/SXC0RFLwUz+GobBHyHlQlK1oGPRLmvnUPaHn9cf7qa3TD9oLTrB50ZRNQyIwFouuUZ2lE/njgCnf+X4RCTfEVSc8mj3Ly3hIe6k53smRL6nX2/Bm54IGRy4+GdNPPiXmCVL0qoUkfufS+YT0mCiMaiKJLL7nKlc/EceXDuZYZo/TDR0O1y9G1P8ZIbJkzNjSQZBBun9vljUprUf2JzG4DQFAowr4WFlk7UnU6gTqzbRBH3ab0bjURvUWglrwWp5c/ipPKs7k6eBBXwj7O3H9T3r9unKQlLS+itkyFzOPGTZwgiMCcUG+p+5fzzzWJu/BdYL+LFG0lToAScTRM/mknIEOIP5bPcv6W1b41CV5H2FVWN/u8H8GEnxRaUFbT8f4jn1pmlerfg8luCrduWIOeMFd0995gAHwnZmCIbJj10biNhf+GRDe077qDo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(366004)(346002)(396003)(376002)(39830400003)(8936002)(30864003)(5660300002)(186003)(52116002)(53546011)(6512007)(83380400001)(26005)(36756003)(31686004)(2906002)(66476007)(66946007)(66556008)(8676002)(6506007)(38350700002)(316002)(2616005)(38100700002)(6486002)(508600001)(86362001)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RnFzSzBnbUVLL0Nid0VlUVdOZTYzYklSejFnN1hoMUNFejN1QXV2bVpjanZB?=
 =?utf-8?B?elluUmlXdUJMZWZqeXdyaC8zYTg0bVQwYzMxUDJPL1ZLekNIbjJDSmI3TW9N?=
 =?utf-8?B?WExUZ3QyY2VoVkZpYTdIdXZZeTlDWVIzVXE2T2V0YkZ6SzIwNUUrd1hNa0NJ?=
 =?utf-8?B?RWJsU2xQamEzSXRiRGUrbTVMdjlpSzRFY2xEYjBCaEIyQ3ZQUDYzLys2S29w?=
 =?utf-8?B?YjB0WVlsWE5SaGtjQmJESWs2VFJjazJSSzMxTzJuNjNEZVNLZlZHQjkvKzRu?=
 =?utf-8?B?ajRkbVR2SmFvbXNJYXhrYmZqa3FSaUVKYTFiaGExOEExOHJEcDRsRjNOZGda?=
 =?utf-8?B?WlJFQTI2YXZMWEdDaCtsd0RLR1NsVzdHTEdmcmJQQ1dnR3phbkx6YVhVS3Z6?=
 =?utf-8?B?a3ZLZnVMQlBtOHhSNTFXU0VieENCMUVBcDFzYlhkQ25EcFk5QzMwR1Z6dkg1?=
 =?utf-8?B?K2luK2pvS1BWbnlsOGw1ZnRLZC95SU1HMXBrb0lWSithTk1KdjZuMEJYRkpI?=
 =?utf-8?B?OHNvRzYyNG5oV015Z05Cb2NNbDdld0hTeTdMaE01Y3FoTHM0RXhoMzEyUEMy?=
 =?utf-8?B?YUg4WU1wMWhlM3pRVk1kaGVQeTlldFBtMVpmT1NOYTBSRDNKeFJWaTBBK1dC?=
 =?utf-8?B?TldLOU1HM3BVSlphK1hHbnpYOTQ4dFRGTC96eFN3VGZBUjZFMThJditTQ1hv?=
 =?utf-8?B?bHJ2K1YvT0gyay9YaHlLNWpUQUE4K1NmbURreWgvRzNabkRpazFSWkZZSDdS?=
 =?utf-8?B?RUY4VUh0cDZvNVFhMmZtVW43YlA5VkVHQnVtZWd0VHNSQnhFUkZNUitEc09X?=
 =?utf-8?B?Vm5FKzhSTmxWUEpJdGRDMXl0OW9pajYvMGdZeDNzUDZNRXc1QmJySDRrbkgv?=
 =?utf-8?B?VEcvQWpDVVArWjF6aEh3UzU5VEF4RWYzL05YOHBCMFRlcWsrYUJ3WXkzWGhX?=
 =?utf-8?B?MzZVaTk4dVJhenRTUlFlRU9xWk5JcGdnUEo2d3VDd3hPcHptK2h4WVB6dHN2?=
 =?utf-8?B?eGJib2doZU1YZUxZWkhKZEJZZ3pSRHFHdjE5b05hVG5qU2U0L3BrNEpTZk9h?=
 =?utf-8?B?TUxxNlQ1TkJRTmp1VFhUbTZTQ0tYbWJ5S0RpdnV4aVc5T1UzeWhMWlZDWHhW?=
 =?utf-8?B?bFovRk51Z3hrZzJwbXQvZWNYSXpYVGFkc0JZZWFHbWFMcGNoT1FVRnhMTzhR?=
 =?utf-8?B?WDh6U296ODJIYmdWSWZNdmtqSGkvOVp3TEo5K2dIcDRKdjZ4aXB2UzlQOGZi?=
 =?utf-8?B?aTAzM3E4VTF3ZHpCeGtyei9wK3U3SzV3VVR4RTBBc0ZQOXlGRC9lSDRLTjJ3?=
 =?utf-8?B?ZEx2MGJEeVNjZmxIOGk1VVZ6NXQvNjNGYW9TL1Bmbmd0Tk1hK3JPRFowUU1i?=
 =?utf-8?B?V1pOMERFZkFhaFpZRWgxS1RKUExFMXRweFBXZDI0dzV2aVpobUtNN1BseWxv?=
 =?utf-8?B?SGJjK2ZkWlFyc2cwSC9BOEdBV1piTTN3MkVKbjRZaU0vNkZreURpRFJuUmNa?=
 =?utf-8?B?end5TkJIc2NZQlVETXN1azlLVFNaOXNweUFQSU1rVXNwL1MwTE5veG83bHNW?=
 =?utf-8?B?RlJ1UWFjelNTcGtUaWJra2ZQSlJmSkE4Q25RUEpaZktGTG5UcDhHRlBmZnBO?=
 =?utf-8?B?cE5lcHhKT2pVL285NDJ1dmdYNE5xV3ZCcDIrM3NvSTQ4OGR4S2RYdDhtSkZK?=
 =?utf-8?B?RmtMNGFnYnFXNUdycUIrSkJ2TlpzcjVNbHl5UlN3clhqdEVUM0JOL1QyalZp?=
 =?utf-8?B?TlFVTDJMUzFZQ1drN1NZVVlFaittOG1qSmNUeWpZMUNkZXloMEFGVVI3RWhP?=
 =?utf-8?B?VnRXZUFnazBRZmxVZjBucDhUTGdBdFNFSkFYU1FTYTVHbndvVGE3M1p2b3dm?=
 =?utf-8?B?blRucnFjdDU2ODVDaVovQ2c5ZkFOenRydC9sN29rYjJSN2NLY285SEZHcWUz?=
 =?utf-8?Q?UeGeQwKQL0pEh4qKcdIdfBd/nqpvQAWo?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73d1d5bb-2796-46d8-18bd-08da0b6a3623
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 18:40:03.0148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5TFMvzFsfSAgyICnmHzdwk9f9Dw7B0XYwqNH3xxGeLufohAJVb3LrfjIkx3B3g4e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4933
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

So, is this change strictly necessary? FID's are actually generated
by the server, so it can choose any convenient format. If the code
currently works on both endians, there's a case for not touching it
now.

OTOH if you've tested and it's solid, sure, because it will ever so
slightly reduce overhead on LE servers.

In any case,

Reviewed-By: Tom Talpey <tom@talpey.com>

On 3/21/2022 12:08 PM, Paulo Alcantara wrote:
> There is no need to store the fids as le64 integers as they are opaque
> to the client and only used for equality.
> 
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>   fs/ksmbd/smb2pdu.c | 94 +++++++++++++++++++---------------------------
>   fs/ksmbd/smb2pdu.h | 34 ++++++++---------
>   2 files changed, 56 insertions(+), 72 deletions(-)
> 
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 67e8e28e3fc3..5440d61cea9f 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -377,12 +377,8 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
>   	 * command in the compound request
>   	 */
>   	if (req->Command == SMB2_CREATE && rsp->Status == STATUS_SUCCESS) {
> -		work->compound_fid =
> -			le64_to_cpu(((struct smb2_create_rsp *)rsp)->
> -				VolatileFileId);
> -		work->compound_pfid =
> -			le64_to_cpu(((struct smb2_create_rsp *)rsp)->
> -				PersistentFileId);
> +		work->compound_fid = ((struct smb2_create_rsp *)rsp)->VolatileFileId;
> +		work->compound_pfid = ((struct smb2_create_rsp *)rsp)->PersistentFileId;
>   		work->compound_sid = le64_to_cpu(rsp->SessionId);
>   	}
>   
> @@ -2129,7 +2125,7 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
>   	rsp->EndofFile = cpu_to_le64(0);
>   	rsp->FileAttributes = FILE_ATTRIBUTE_NORMAL_LE;
>   	rsp->Reserved2 = 0;
> -	rsp->VolatileFileId = cpu_to_le64(id);
> +	rsp->VolatileFileId = id;
>   	rsp->PersistentFileId = 0;
>   	rsp->CreateContextsOffset = 0;
>   	rsp->CreateContextsLength = 0;
> @@ -3157,8 +3153,8 @@ int smb2_open(struct ksmbd_work *work)
>   
>   	rsp->Reserved2 = 0;
>   
> -	rsp->PersistentFileId = cpu_to_le64(fp->persistent_id);
> -	rsp->VolatileFileId = cpu_to_le64(fp->volatile_id);
> +	rsp->PersistentFileId = fp->persistent_id;
> +	rsp->VolatileFileId = fp->volatile_id;
>   
>   	rsp->CreateContextsOffset = 0;
>   	rsp->CreateContextsLength = 0;
> @@ -3865,9 +3861,7 @@ int smb2_query_dir(struct ksmbd_work *work)
>   		goto err_out2;
>   	}
>   
> -	dir_fp = ksmbd_lookup_fd_slow(work,
> -				      le64_to_cpu(req->VolatileFileId),
> -				      le64_to_cpu(req->PersistentFileId));
> +	dir_fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
>   	if (!dir_fp) {
>   		rc = -EBADF;
>   		goto err_out2;
> @@ -4088,12 +4082,12 @@ static int smb2_get_info_file_pipe(struct ksmbd_session *sess,
>   	 * Windows can sometime send query file info request on
>   	 * pipe without opening it, checking error condition here
>   	 */
> -	id = le64_to_cpu(req->VolatileFileId);
> +	id = req->VolatileFileId;
>   	if (!ksmbd_session_rpc_method(sess, id))
>   		return -ENOENT;
>   
>   	ksmbd_debug(SMB, "FileInfoClass %u, FileId 0x%llx\n",
> -		    req->FileInfoClass, le64_to_cpu(req->VolatileFileId));
> +		    req->FileInfoClass, req->VolatileFileId);
>   
>   	switch (req->FileInfoClass) {
>   	case FILE_STANDARD_INFORMATION:
> @@ -4738,7 +4732,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
>   	}
>   
>   	if (work->next_smb2_rcv_hdr_off) {
> -		if (!has_file_id(le64_to_cpu(req->VolatileFileId))) {
> +		if (!has_file_id(req->VolatileFileId)) {
>   			ksmbd_debug(SMB, "Compound request set FID = %llu\n",
>   				    work->compound_fid);
>   			id = work->compound_fid;
> @@ -4747,8 +4741,8 @@ static int smb2_get_info_file(struct ksmbd_work *work,
>   	}
>   
>   	if (!has_file_id(id)) {
> -		id = le64_to_cpu(req->VolatileFileId);
> -		pid = le64_to_cpu(req->PersistentFileId);
> +		id = req->VolatileFileId;
> +		pid = req->PersistentFileId;
>   	}
>   
>   	fp = ksmbd_lookup_fd_slow(work, id, pid);
> @@ -5113,7 +5107,7 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
>   	}
>   
>   	if (work->next_smb2_rcv_hdr_off) {
> -		if (!has_file_id(le64_to_cpu(req->VolatileFileId))) {
> +		if (!has_file_id(req->VolatileFileId)) {
>   			ksmbd_debug(SMB, "Compound request set FID = %llu\n",
>   				    work->compound_fid);
>   			id = work->compound_fid;
> @@ -5122,8 +5116,8 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
>   	}
>   
>   	if (!has_file_id(id)) {
> -		id = le64_to_cpu(req->VolatileFileId);
> -		pid = le64_to_cpu(req->PersistentFileId);
> +		id = req->VolatileFileId;
> +		pid = req->PersistentFileId;
>   	}
>   
>   	fp = ksmbd_lookup_fd_slow(work, id, pid);
> @@ -5221,7 +5215,7 @@ static noinline int smb2_close_pipe(struct ksmbd_work *work)
>   	struct smb2_close_req *req = smb2_get_msg(work->request_buf);
>   	struct smb2_close_rsp *rsp = smb2_get_msg(work->response_buf);
>   
> -	id = le64_to_cpu(req->VolatileFileId);
> +	id = req->VolatileFileId;
>   	ksmbd_session_rpc_close(work->sess, id);
>   
>   	rsp->StructureSize = cpu_to_le16(60);
> @@ -5280,7 +5274,7 @@ int smb2_close(struct ksmbd_work *work)
>   	}
>   
>   	if (work->next_smb2_rcv_hdr_off &&
> -	    !has_file_id(le64_to_cpu(req->VolatileFileId))) {
> +	    !has_file_id(req->VolatileFileId)) {
>   		if (!has_file_id(work->compound_fid)) {
>   			/* file already closed, return FILE_CLOSED */
>   			ksmbd_debug(SMB, "file already closed\n");
> @@ -5299,7 +5293,7 @@ int smb2_close(struct ksmbd_work *work)
>   			work->compound_pfid = KSMBD_NO_FID;
>   		}
>   	} else {
> -		volatile_id = le64_to_cpu(req->VolatileFileId);
> +		volatile_id = req->VolatileFileId;
>   	}
>   	ksmbd_debug(SMB, "volatile_id = %llu\n", volatile_id);
>   
> @@ -5988,7 +5982,7 @@ int smb2_set_info(struct ksmbd_work *work)
>   	if (work->next_smb2_rcv_hdr_off) {
>   		req = ksmbd_req_buf_next(work);
>   		rsp = ksmbd_resp_buf_next(work);
> -		if (!has_file_id(le64_to_cpu(req->VolatileFileId))) {
> +		if (!has_file_id(req->VolatileFileId)) {
>   			ksmbd_debug(SMB, "Compound request set FID = %llu\n",
>   				    work->compound_fid);
>   			id = work->compound_fid;
> @@ -6000,8 +5994,8 @@ int smb2_set_info(struct ksmbd_work *work)
>   	}
>   
>   	if (!has_file_id(id)) {
> -		id = le64_to_cpu(req->VolatileFileId);
> -		pid = le64_to_cpu(req->PersistentFileId);
> +		id = req->VolatileFileId;
> +		pid = req->PersistentFileId;
>   	}
>   
>   	fp = ksmbd_lookup_fd_slow(work, id, pid);
> @@ -6079,7 +6073,7 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
>   	struct smb2_read_req *req = smb2_get_msg(work->request_buf);
>   	struct smb2_read_rsp *rsp = smb2_get_msg(work->response_buf);
>   
> -	id = le64_to_cpu(req->VolatileFileId);
> +	id = req->VolatileFileId;
>   
>   	inc_rfc1001_len(work->response_buf, 16);
>   	rpc_resp = ksmbd_rpc_read(work->sess, id);
> @@ -6215,8 +6209,7 @@ int smb2_read(struct ksmbd_work *work)
>   			goto out;
>   	}
>   
> -	fp = ksmbd_lookup_fd_slow(work, le64_to_cpu(req->VolatileFileId),
> -				  le64_to_cpu(req->PersistentFileId));
> +	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
>   	if (!fp) {
>   		err = -ENOENT;
>   		goto out;
> @@ -6335,7 +6328,7 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
>   	size_t length;
>   
>   	length = le32_to_cpu(req->Length);
> -	id = le64_to_cpu(req->VolatileFileId);
> +	id = req->VolatileFileId;
>   
>   	if (le16_to_cpu(req->DataOffset) ==
>   	    offsetof(struct smb2_write_req, Buffer)) {
> @@ -6471,8 +6464,7 @@ int smb2_write(struct ksmbd_work *work)
>   		goto out;
>   	}
>   
> -	fp = ksmbd_lookup_fd_slow(work, le64_to_cpu(req->VolatileFileId),
> -				  le64_to_cpu(req->PersistentFileId));
> +	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
>   	if (!fp) {
>   		err = -ENOENT;
>   		goto out;
> @@ -6584,12 +6576,9 @@ int smb2_flush(struct ksmbd_work *work)
>   
>   	WORK_BUFFERS(work, req, rsp);
>   
> -	ksmbd_debug(SMB, "SMB2_FLUSH called for fid %llu\n",
> -		    le64_to_cpu(req->VolatileFileId));
> +	ksmbd_debug(SMB, "SMB2_FLUSH called for fid %llu\n", req->VolatileFileId);
>   
> -	err = ksmbd_vfs_fsync(work,
> -			      le64_to_cpu(req->VolatileFileId),
> -			      le64_to_cpu(req->PersistentFileId));
> +	err = ksmbd_vfs_fsync(work, req->VolatileFileId, req->PersistentFileId);
>   	if (err)
>   		goto out;
>   
> @@ -6804,12 +6793,9 @@ int smb2_lock(struct ksmbd_work *work)
>   	int prior_lock = 0;
>   
>   	ksmbd_debug(SMB, "Received lock request\n");
> -	fp = ksmbd_lookup_fd_slow(work,
> -				  le64_to_cpu(req->VolatileFileId),
> -				  le64_to_cpu(req->PersistentFileId));
> +	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
>   	if (!fp) {
> -		ksmbd_debug(SMB, "Invalid file id for lock : %llu\n",
> -			    le64_to_cpu(req->VolatileFileId));
> +		ksmbd_debug(SMB, "Invalid file id for lock : %llu\n", req->VolatileFileId);
>   		err = -ENOENT;
>   		goto out2;
>   	}
> @@ -7164,8 +7150,8 @@ static int fsctl_copychunk(struct ksmbd_work *work,
>   
>   	ci_rsp = (struct copychunk_ioctl_rsp *)&rsp->Buffer[0];
>   
> -	rsp->VolatileFileId = cpu_to_le64(volatile_id);
> -	rsp->PersistentFileId = cpu_to_le64(persistent_id);
> +	rsp->VolatileFileId = volatile_id;
> +	rsp->PersistentFileId = persistent_id;
>   	ci_rsp->ChunksWritten =
>   		cpu_to_le32(ksmbd_server_side_copy_max_chunk_count());
>   	ci_rsp->ChunkBytesWritten =
> @@ -7379,8 +7365,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
>   	if (nii_rsp)
>   		nii_rsp->Next = 0;
>   
> -	rsp->PersistentFileId = cpu_to_le64(SMB2_NO_FID);
> -	rsp->VolatileFileId = cpu_to_le64(SMB2_NO_FID);
> +	rsp->PersistentFileId = SMB2_NO_FID;
> +	rsp->VolatileFileId = SMB2_NO_FID;
>   	return nbytes;
>   }
>   
> @@ -7547,9 +7533,7 @@ static int fsctl_request_resume_key(struct ksmbd_work *work,
>   {
>   	struct ksmbd_file *fp;
>   
> -	fp = ksmbd_lookup_fd_slow(work,
> -				  le64_to_cpu(req->VolatileFileId),
> -				  le64_to_cpu(req->PersistentFileId));
> +	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
>   	if (!fp)
>   		return -ENOENT;
>   
> @@ -7579,7 +7563,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>   	if (work->next_smb2_rcv_hdr_off) {
>   		req = ksmbd_req_buf_next(work);
>   		rsp = ksmbd_resp_buf_next(work);
> -		if (!has_file_id(le64_to_cpu(req->VolatileFileId))) {
> +		if (!has_file_id(req->VolatileFileId)) {
>   			ksmbd_debug(SMB, "Compound request set FID = %llu\n",
>   				    work->compound_fid);
>   			id = work->compound_fid;
> @@ -7590,7 +7574,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>   	}
>   
>   	if (!has_file_id(id))
> -		id = le64_to_cpu(req->VolatileFileId);
> +		id = req->VolatileFileId;
>   
>   	if (req->Flags != cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL)) {
>   		rsp->hdr.Status = STATUS_NOT_SUPPORTED;
> @@ -7656,8 +7640,8 @@ int smb2_ioctl(struct ksmbd_work *work)
>   			goto out;
>   
>   		nbytes = sizeof(struct validate_negotiate_info_rsp);
> -		rsp->PersistentFileId = cpu_to_le64(SMB2_NO_FID);
> -		rsp->VolatileFileId = cpu_to_le64(SMB2_NO_FID);
> +		rsp->PersistentFileId = SMB2_NO_FID;
> +		rsp->VolatileFileId = SMB2_NO_FID;
>   		break;
>   	case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
>   		ret = fsctl_query_iface_info_ioctl(conn, rsp, out_buf_len);
> @@ -7705,8 +7689,8 @@ int smb2_ioctl(struct ksmbd_work *work)
>   				(struct copychunk_ioctl_req *)&req->Buffer[0],
>   				le32_to_cpu(req->CntCode),
>   				le32_to_cpu(req->InputCount),
> -				le64_to_cpu(req->VolatileFileId),
> -				le64_to_cpu(req->PersistentFileId),
> +				req->VolatileFileId,
> +				req->PersistentFileId,
>   				rsp);
>   		break;
>   	case FSCTL_SET_SPARSE:
> diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
> index 725b800c29c8..fd3df8b71687 100644
> --- a/fs/ksmbd/smb2pdu.h
> +++ b/fs/ksmbd/smb2pdu.h
> @@ -116,8 +116,8 @@ struct create_durable_reconn_req {
>   	union {
>   		__u8  Reserved[16];
>   		struct {
> -			__le64 PersistentFileId;
> -			__le64 VolatileFileId;
> +			__u64 PersistentFileId;
> +			__u64 VolatileFileId;
>   		} Fid;
>   	} Data;
>   } __packed;
> @@ -126,8 +126,8 @@ struct create_durable_reconn_v2_req {
>   	struct create_context ccontext;
>   	__u8   Name[8];
>   	struct {
> -		__le64 PersistentFileId;
> -		__le64 VolatileFileId;
> +		__u64 PersistentFileId;
> +		__u64 VolatileFileId;
>   	} Fid;
>   	__u8 CreateGuid[16];
>   	__le32 Flags;
> @@ -269,8 +269,8 @@ struct smb2_ioctl_req {
>   	__le16 StructureSize; /* Must be 57 */
>   	__le16 Reserved; /* offset from start of SMB2 header to write data */
>   	__le32 CntCode;
> -	__le64  PersistentFileId;
> -	__le64  VolatileFileId;
> +	__u64  PersistentFileId;
> +	__u64  VolatileFileId;
>   	__le32 InputOffset; /* Reserved MBZ */
>   	__le32 InputCount;
>   	__le32 MaxInputResponse;
> @@ -287,8 +287,8 @@ struct smb2_ioctl_rsp {
>   	__le16 StructureSize; /* Must be 49 */
>   	__le16 Reserved; /* offset from start of SMB2 header to write data */
>   	__le32 CntCode;
> -	__le64  PersistentFileId;
> -	__le64  VolatileFileId;
> +	__u64  PersistentFileId;
> +	__u64  VolatileFileId;
>   	__le32 InputOffset; /* Reserved MBZ */
>   	__le32 InputCount;
>   	__le32 OutputOffset;
> @@ -357,7 +357,7 @@ struct file_object_buf_type1_ioctl_rsp {
>   } __packed;
>   
>   struct resume_key_ioctl_rsp {
> -	__le64 ResumeKey[3];
> +	__u64 ResumeKey[3];
>   	__le32 ContextLength;
>   	__u8 Context[4]; /* ignored, Windows sets to 4 bytes of zero */
>   } __packed;
> @@ -432,8 +432,8 @@ struct smb2_lock_req {
>   	__le16 StructureSize; /* Must be 48 */
>   	__le16 LockCount;
>   	__le32 Reserved;
> -	__le64  PersistentFileId;
> -	__le64  VolatileFileId;
> +	__u64  PersistentFileId;
> +	__u64  VolatileFileId;
>   	/* Followed by at least one */
>   	struct smb2_lock_element locks[1];
>   } __packed;
> @@ -468,8 +468,8 @@ struct smb2_query_directory_req {
>   	__u8   FileInformationClass;
>   	__u8   Flags;
>   	__le32 FileIndex;
> -	__le64  PersistentFileId;
> -	__le64  VolatileFileId;
> +	__u64  PersistentFileId;
> +	__u64  VolatileFileId;
>   	__le16 FileNameOffset;
>   	__le16 FileNameLength;
>   	__le32 OutputBufferLength;
> @@ -515,8 +515,8 @@ struct smb2_query_info_req {
>   	__le32 InputBufferLength;
>   	__le32 AdditionalInformation;
>   	__le32 Flags;
> -	__le64  PersistentFileId;
> -	__le64  VolatileFileId;
> +	__u64  PersistentFileId;
> +	__u64  VolatileFileId;
>   	__u8   Buffer[1];
>   } __packed;
>   
> @@ -537,8 +537,8 @@ struct smb2_set_info_req {
>   	__le16 BufferOffset;
>   	__u16  Reserved;
>   	__le32 AdditionalInformation;
> -	__le64  PersistentFileId;
> -	__le64  VolatileFileId;
> +	__u64  PersistentFileId;
> +	__u64  VolatileFileId;
>   	__u8   Buffer[1];
>   } __packed;
>   
