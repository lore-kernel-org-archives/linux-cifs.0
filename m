Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BDFEB64D7
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Jun 2023 16:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbjFWQBB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Jun 2023 12:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjFWQBA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Jun 2023 12:01:00 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888112117
        for <linux-cifs@vger.kernel.org>; Fri, 23 Jun 2023 09:00:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gMLLID9kzipC6vgxx7NH3zHT/e1GA7Y/hTLRrlw7zdIXtCkOvHqjdMUR3PYzZKevvayUf5JVhluXR4KP2xgfwnVJYnBovvJTjmJJ9Dnp2YmZNwgBc+1yuyDTiqVfMo8c3byTeaKCOB81PMRSz2te9fXbOdS6IItDmBFSm0fhMeN0IY2dihQZ0zvlEVpquw7QOQrl6YpcP9YScUNJodfr3QN+uFkafRELdJHx7asxshllQiQyMpAoKBn33EfCn8F1Vgnsd5wxssrLHsiU6TQbI5vp3yeNXW57sDt99h3JtCTQjSX1ymhbM2wpmOK/l32HTYlODx/YoN+/Movss71oTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VKI3SFCbXnQjSmnctIbHpAwMLjUhKEOiPbHBdy/WN64=;
 b=iprNWI+PssOSRx4R90xbHIHDldRKfR4pK+e0c93PxyAPiHgjUmYhS6+KjJj7g65Zdc6rfhnKil7hYuijuXDKoxqVzdpxYfH/fufQAX0t2XR5RFpOHq0bQKYgxkQ2/yDjVuaUARvYdf7rC+cEkVs68RKF6Xks7qEqo3sns7cG6CTpyMvq/mhEfFJ6hlWRSSUKG7wTsDuYYRlNGf2JVBC04ZXZ7+BIWifszpN8okZ9ZVzEn93s+Db20E9Dg+z/5DBQMN3O4zcQT26FJF4AeG6qQzWFfVpdyDblggRvKubrs4ZO6lwXHk8UPn8pCMNRaLd+J8p9hhs4RqJ+tFWcKM3lzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SJ0PR01MB8083.prod.exchangelabs.com (2603:10b6:a03:4e6::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.24; Fri, 23 Jun 2023 16:00:52 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc%5]) with mapi id 15.20.6521.023; Fri, 23 Jun 2023
 16:00:52 +0000
Message-ID: <b44d580c-6237-bccb-a9e1-2d5bdd2db35f@talpey.com>
Date:   Fri, 23 Jun 2023 12:00:49 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 5/6] cifs: fix max_credits implementation
Content-Language: en-US
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        bharathsm.hsk@gmail.com
Cc:     Shyam Prasad N <sprasad@microsoft.com>
References: <20230609174659.60327-1-sprasad@microsoft.com>
 <20230609174659.60327-5-sprasad@microsoft.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20230609174659.60327-5-sprasad@microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0201.namprd13.prod.outlook.com
 (2603:10b6:208:2be::26) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SJ0PR01MB8083:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e2ddf02-4fea-4bd3-5703-08db7403051f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DkrGq+AZvzXPIpYksuS26MQwPCHGlMx8NFGxED8zp3vj/bTO94EBvKiqWou73X0gwji9hD3Bn42BvCn4lvzn0pfemwY8hJvuCYzMruGUe3i3iet8STOCo1gXWpEt5SQffRY4vx4/AmdsluXdm5YJQcybBAc1Oco/UTMrEYXyic4lZEONxiieSIVfvorThE7qTNiBWW4rR2EF2CT9Bm3aLcrLrsrFWV6GimMflk4TGDYLgnRiuC4Ykl9AceIPKXSpopFEo7w3aydDYn1k2FZ+U7M9R0T3DktB71EEqUsQOQctkLq/uZvpHf37fDsYbdGBeHKsE7M2vvzf3H+At/JY0HtZh6OCAM8v5/n93rhGmnSRfAN5QjJ4CMv3bQ/PBJ6bdNg7IEeIGP8VCwyA34vRV5mf0Wn6NKVfoMdRLd5snA5TrlU0kprIDWS4WzipKOQW02oS/5gxNd4VdrusDaCfEY0s0Lbpx1CIlkzaYZNXokkVZYwNRcw+y/wefTIR2niKb9mFYUTyB4Z8sEluI51qyScPDIK2/Rt+tRxVm49Me5fVG9i3MqodqXAWDl2zyj4yM9C+/XngLk4sHiTG6Ht0qNMjPy+HussUmSUf1et6GixX4KsoyLcTAU2mb1QbiN57VQFNZclLYZuYrcv8HB6lnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(39840400004)(366004)(136003)(346002)(451199021)(38350700002)(2906002)(4326008)(6512007)(6666004)(45080400002)(26005)(186003)(36756003)(31686004)(31696002)(86362001)(2616005)(316002)(66556008)(66476007)(66946007)(52116002)(5660300002)(478600001)(53546011)(6506007)(6486002)(41300700001)(83380400001)(8936002)(38100700002)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Um1uc3crWkZSR3p3cU15U0k1MFRlcW5uTldUMlhvV05hUllOZHpmTVUvMTR6?=
 =?utf-8?B?OVRrVDRuYmJjWjdEb1FIY0FHWml3YmovcGt3ZFl2TmZMSDQzOGszSXc4MUta?=
 =?utf-8?B?bEI2QkIvcHpvUW5XcXJGOHlyWldXVU9aWDFJczFrVHZ3VTdUUkV3VFhROWVM?=
 =?utf-8?B?ZEZtRnd0dmJPTGkvR1lwN1pIZVhTcTBkTmdkNFV6cW5YY00rTmkrVTRqanpG?=
 =?utf-8?B?ZjIxQXl5enlJbkpwdWdHWk1tNU9nOG9aVGtTWjBmN1pPV2h1QmRvZFJvdjJw?=
 =?utf-8?B?bGRoSEZRUW5pYjRGbHRmcjc5MFFtRnJqKzBSUHplR3MzN1dxVmtTM2JDcGNw?=
 =?utf-8?B?Vjl3ZTlVVXNMU1pJSnNXZ2dvSTFBYll1ZkxLYnoyRHEvWTZZdDRONUgxSG92?=
 =?utf-8?B?R212NmUxSzQzYWFSTUp5c0FjcVQ0L1VzWkZGUk9xVHlmQllSWGQ5VEtWM0Vu?=
 =?utf-8?B?VU1iQWY0SWwvWThvSHNiSEVBSkxPSERsMjl1bVV5eVVkUzVBMzJ1b1g0RVM3?=
 =?utf-8?B?QTBDWGl6SGh1RTlJRmtROE9ZbmUxUmJ0NERlVUZna3ZVNytnQmhRWlNFQ3hG?=
 =?utf-8?B?ZTZITGtwQ0s3Y0NRYnlWekNhUDRxM1pVVnV2TzVlZXZadVl2UUt6VXlzeHV5?=
 =?utf-8?B?dTJ2ZnJzWVhEUlNwZ25jYWpZaDZBby9QZ0x0MlNvV1A0SWU0aFFoQVVrbmds?=
 =?utf-8?B?Y3BFOWNPY1BPRW5ONWJiNGsrbjZzRDJpVElrTjdQZVBtTC9kQVg1dCtBc3Bv?=
 =?utf-8?B?Z3BQVFN5RHhZKzI4ZDNiMXAvZWxLTnNVcW9BMW5nODlpbTc3VmlOS2JxeUZt?=
 =?utf-8?B?TElWU1I1S2dWQitreGRnNWdvUFpoa2t4OWZUSGpSS2xjem9FZXNkUDRETzlh?=
 =?utf-8?B?ZnhiZ3BicmtPbjJWYXlzVU9BQlBxcnlkMmRRU29uaE5oUHhQL1dqa3dSNVJO?=
 =?utf-8?B?SXhvZ2F0ZzVzR2FlOElHb0dvSlA5ZWM4SlJPNkt4WlhYOUVUVnQ0QW1JaHJy?=
 =?utf-8?B?eVo3b2JjdWhCdW4vWDNzaHNyYUtqdHNzUTE4WGpaemJ5RVhGeHkrM1F3SURp?=
 =?utf-8?B?ZStDdjRMT3llZHFmQzQ3Vlh0Vit5RzNhYjFuclg1V1dKVmJCQlVhZUdJME1Y?=
 =?utf-8?B?cExhZVB3WWIwTTJEK0F6SEROWTRCdkUwUnNnVXhoRGo4blNQQndoOTFsYjkw?=
 =?utf-8?B?Y3dBMmRtRDJObmR6dXRxNXE1TUFIYXFlNGZ5clRpOXhFT1FHc2YraDZBNGt5?=
 =?utf-8?B?dWhyWk80Zmg3ekkzeWJrbW4wS0FvenZzTUs0dnFIaG9QeUVuc3BYZFUya21N?=
 =?utf-8?B?QUlGRzNFY3RFcE9SNk81QjhMc2VJdUU2NU1iR3BjZDBVWDkzRk9Mb2cwazNZ?=
 =?utf-8?B?KzVtYzRWQnlPWmR3aHlXdm40Z3ppNjYxdFBZT0ZVTlNUMkxGTmlmbWlTOVB1?=
 =?utf-8?B?WVdacHZ4NGdST3I5b1VNQzFLdTkrWUppWlVBaHVWUHdqNTFSdHBTOFNyQWdQ?=
 =?utf-8?B?M2NTcGZzRHRXeDNTM0ZxU1R6ekk4WEJqckEyZTJjRkxDSHR4VUE1VWo2dDgw?=
 =?utf-8?B?TmsvakNMOHEzWkI0MXVuQTlIS1B2aFdyalZ1NDExUWNVUEFTQno2dTdkUDY5?=
 =?utf-8?B?ZG56d3djdi9SMCt3M2t1N0dsNFVXT2lyZFBqSWVpZ3V6RnpjY2NkUmNRa0Nx?=
 =?utf-8?B?eC9Ld2ordnRVNmNObnpYN01XcGlQMlJlOFBwVktxNVF2MkxsaHNld3BvQXZZ?=
 =?utf-8?B?a1F2L2luaEs2cnpjcEFGWnROZGlucllTczBLc3FXclZ5YnVSQmdSUk9zdDZP?=
 =?utf-8?B?RHIzT2xqYXlUd05yNEtCRE1wM3ZObUpTR2loWVFzSzVRdFlVZm5rM3BzQjhB?=
 =?utf-8?B?aHNhUW03Mkc2Uk5neHhXSlVQVkwwckR0bE1MMkJpQmMxcGpWQkpYSlEvV3lB?=
 =?utf-8?B?bUpTNlFwbm56NWozQm5ENFFwSkJPTHdkTWRBWlVwT3RDa0FsbnRBZlRrbml1?=
 =?utf-8?B?aGVLS3ZHbytVZlkxK0srTUpUZldmSlRrUFh6cGZ4cjFCNnlrL0YwZGgxTVdQ?=
 =?utf-8?B?dFB4Y09yNktqU2hZV3JSVFRsWW9XWnNaN05OY25ETFNkSUdIeVVKTkNiS1R6?=
 =?utf-8?Q?FrcX886Uw4/nxhoGU5fHWJxFL?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e2ddf02-4fea-4bd3-5703-08db7403051f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 16:00:52.4991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B9MwXdRhuLSccBECKM36pMD7Jn8oWJmy5O0WwD0LoHVBfNmpL7aob78UGz8BH1HY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB8083
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/9/2023 1:46 PM, Shyam Prasad N wrote:
> The current implementation of max_credits on the client does
> not work because the CreditRequest logic for several commands
> does not take max_credits into account.
> 
> Still, we can end up asking the server for more credits, depending
> on the number of credits in flight. For this, we need to
> limit the credits while parsing the responses too.
> 
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>   fs/smb/client/smb2ops.c |  2 ++
>   fs/smb/client/smb2pdu.c | 32 ++++++++++++++++++++++++++++----
>   2 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 43162915e03c..18faf267c54d 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -34,6 +34,8 @@ static int
>   change_conf(struct TCP_Server_Info *server)
>   {
>   	server->credits += server->echo_credits + server->oplock_credits;
> +	if (server->credits > server->max_credits)
> +		server->credits = server->max_credits;
>   	server->oplock_credits = server->echo_credits = 0;
>   	switch (server->credits) {
>   	case 0:
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 7063b395d22f..17fe212ab895 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -1305,7 +1305,12 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
>   	}
>   
>   	/* enough to enable echos and oplocks and one max size write */
> -	req->hdr.CreditRequest = cpu_to_le16(130);
> +	if (server->credits >= server->max_credits)
> +		req->hdr.CreditRequest = cpu_to_le16(0);
> +	else
> +		req->hdr.CreditRequest = cpu_to_le16(
> +			min_t(int, server->max_credits -
> +			      server->credits, 130));

This identical processing appears several times below. It would be
very bad if the copies got out of sync. Let's factor these as a
single function, perhaps inline but it might make sense as a client
common entry.

Tom.


>   	/* only one of SMB2 signing flags may be set in SMB2 request */
>   	if (server->sign)
> @@ -1899,7 +1904,12 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
>   	rqst.rq_nvec = 2;
>   
>   	/* Need 64 for max size write so ask for more in case not there yet */
> -	req->hdr.CreditRequest = cpu_to_le16(64);
> +	if (server->credits >= server->max_credits)
> +		req->hdr.CreditRequest = cpu_to_le16(0);
> +	else
> +		req->hdr.CreditRequest = cpu_to_le16(
> +			min_t(int, server->max_credits -
> +			      server->credits, 64));
>   
>   	rc = cifs_send_recv(xid, ses, server,
>   			    &rqst, &resp_buftype, flags, &rsp_iov);
> @@ -4227,6 +4237,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
>   	struct TCP_Server_Info *server;
>   	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
>   	unsigned int total_len;
> +	int credit_request;
>   
>   	cifs_dbg(FYI, "%s: offset=%llu bytes=%u\n",
>   		 __func__, rdata->offset, rdata->bytes);
> @@ -4258,7 +4269,13 @@ smb2_async_readv(struct cifs_readdata *rdata)
>   	if (rdata->credits.value > 0) {
>   		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(rdata->bytes,
>   						SMB2_MAX_BUFFER_SIZE));
> -		shdr->CreditRequest = cpu_to_le16(le16_to_cpu(shdr->CreditCharge) + 8);
> +		credit_request = le16_to_cpu(shdr->CreditCharge) + 8;
> +		if (server->credits >= server->max_credits)
> +			shdr->CreditRequest = cpu_to_le16(0);
> +		else
> +			shdr->CreditRequest = cpu_to_le16(
> +				min_t(int, server->max_credits -
> +						server->credits, credit_request));
>   
>   		rc = adjust_credits(server, &rdata->credits, rdata->bytes);
>   		if (rc)
> @@ -4468,6 +4485,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
>   	unsigned int total_len;
>   	struct cifs_io_parms _io_parms;
>   	struct cifs_io_parms *io_parms = NULL;
> +	int credit_request;
>   
>   	if (!wdata->server)
>   		server = wdata->server = cifs_pick_channel(tcon->ses);
> @@ -4572,7 +4590,13 @@ smb2_async_writev(struct cifs_writedata *wdata,
>   	if (wdata->credits.value > 0) {
>   		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(wdata->bytes,
>   						    SMB2_MAX_BUFFER_SIZE));
> -		shdr->CreditRequest = cpu_to_le16(le16_to_cpu(shdr->CreditCharge) + 8);
> +		credit_request = le16_to_cpu(shdr->CreditCharge) + 8;
> +		if (server->credits >= server->max_credits)
> +			shdr->CreditRequest = cpu_to_le16(0);
> +		else
> +			shdr->CreditRequest = cpu_to_le16(
> +				min_t(int, server->max_credits -
> +						server->credits, credit_request));
>   
>   		rc = adjust_credits(server, &wdata->credits, io_parms->length);
>   		if (rc)
