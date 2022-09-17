Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C01EEC6FA82
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Sep 2022 14:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiIQOYi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 17 Sep 2022 10:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiIQOYg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 17 Sep 2022 10:24:36 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2049.outbound.protection.outlook.com [40.107.95.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBD613F0C
        for <linux-cifs@vger.kernel.org>; Sat, 17 Sep 2022 07:24:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VscNgq/T7vXYK0pqCheb50mCpWnV1CUISi4gdLOXryG6oNvgT2yCWgjAvrMMgA1ljkNo0pIqCLJ4k/BqLhYjHD5WBbz3juo0Gv+KbOLcGJqMIZgy5tmko8s4PjowmcijxlQ4Yv+zp2pvH+dn1/mfwDOpGuG2Xo6GQC0eNQWFvsgYxVoxujhsie/u3XvbvM40DL80gUNXw51To7KMk8tk9grYao9Y+r0jbzdmBGfpRcmurVSjZcganfj8yH2NcQ4QNeMV2Qi5D49W7Zz2MxN1RP+zBUTv6gBeNRoAF/nkiMZMvh0cVTby7R7OdBtDxisjPM3Xd2lBtZLCUoWFP5ddKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ev9zL0MtJ/2lhZxXJ6vzA/Tuf/WmKY1LJ2MoK91AGOQ=;
 b=ZD/eUG7rb4byNOWROtGzKrrjcVWtVC8gnujk359BpQACML4J58hIP2RDpvcBBdXqS7UyD5/C7AlRGnU8WUCKZJyk0HUn2Bwo1b8EIc1m2K/WQqV1xcYImSBt8mTESOhRoEmeSZU/bXLj9CAV6/hHkJox/AlGN9O9nioG4tzYre5QtEciMNgDSqRRjFDOx0HRO6sp50PJmobL4LlPziSzGSQ+x45QdJJOQPyD/ak/WrShvKQkTNsIPKmuBPW7BdjXnTOP4+yozyot0owcVqP7gYlK9HHyqd9IkDsjXAm34EB+lNH64QmmJZuE216CV4RnC7EG3XN9L4XHmmhAIXMncQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BN7PR01MB3667.prod.exchangelabs.com (2603:10b6:406:81::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.22; Sat, 17 Sep 2022 14:24:33 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4dc8:c035:7271:4df8]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4dc8:c035:7271:4df8%4]) with mapi id 15.20.5632.018; Sat, 17 Sep 2022
 14:24:33 +0000
Message-ID: <bf09670b-df76-7fcc-2c8c-8b049f82d41b@talpey.com>
Date:   Sat, 17 Sep 2022 10:24:31 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] cifs: verify signature only for valid responses
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
References: <20220917020704.25181-1-ematsumiya@suse.de>
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220917020704.25181-1-ematsumiya@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:208:236::17) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BN7PR01MB3667:EE_
X-MS-Office365-Filtering-Correlation-Id: 840a1ca7-83ad-4258-ae77-08da98b8572b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iL0uPXvXa1xi7KaXnxRULqoNAxp+E+zYayIuxmYh/0ydtbiDlGfaR8W8kgbgpWZVsbEddpz1TzighRuIzIq5Cbjcgyn6IeCX9+Zvif3OY5dJgGGYMuRYpv5pFqFki/B3WVUP1+VRLQc0ETF0YTW/AjdrwJ0HFsduN81xvywZbxdRGg5i4/xEg0ngt/vsPM4ZDeSTjVXNTjnzu664ALE8T3nZ4y44l4DlD+kSDLW9aLWYQL8yAqUZLeBkaGQSg23wuhPJjO47DeNqASSG8t0aeTUwQb/4JqLxiNfFKJov+Ss7FpeNLZVO4W4DSEJtoP+K+CKo9ZgWJzJvsexrd4Ik7gSsgwAvvbGkJ7dMsUEkMl7MxdY0H0osyz+KWji6PrqfaqPldJEiz7WNRCIs7pv0t4Fi12PsGEU7PWxT4qCFoPewMMK/+TqVFnldiaHVOdONrgwFdEUfEEptPloROq3Ym9nChHlFzu9DP9rpbG8bXtFmMWD3zziDFME18bnmuxaYx3P24KbotfL8+6jKoYerxhetXNQ6GfmA/xd7x5tdTRHe4vzID1ZmyqrhOJIVa+sB+BJW/0QYsVMVUZQ2eRAMSLgQTvFhGMWAXDyQQ8LS3D/i84yfVTQuP+Au5mQFVi/xViG08iV4PjfJgHKzbTWpfluAC7N0c+1Xtb8E9SgPblaMn3uUEKJxrjP1HQA6hqWHlG4e8RT1N/+zLB7AgFdeQtnLQ4TtmA5ziV1Ke3cA+5kgXT70OvYIwmswQD5tizSqfib5exANc+sOGRP1xRDw3Mo/TEKUtKqyrPAWgh/O2nY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(376002)(346002)(39830400003)(451199015)(38350700002)(38100700002)(36756003)(86362001)(31696002)(31686004)(83380400001)(6512007)(26005)(15650500001)(2906002)(186003)(478600001)(6486002)(6506007)(53546011)(52116002)(41300700001)(2616005)(4326008)(66476007)(66556008)(316002)(66946007)(8676002)(8936002)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnZnU1FLUlNac29iTUREM3hNbXhVbkFUTWxTM1NjdTlmdWJWQlJmUlBpbzBj?=
 =?utf-8?B?TDVpeVcvZ290Uk1neFNYY245WGEwR0NZMFYxNTV5aG5XRDA3dVBBdlNta2ZB?=
 =?utf-8?B?cHpXSVdCRHZCR2pPdHQ0UHA1TVZTNHoxYnNCa3Jod0ZaQ1grVVljS1psclQ4?=
 =?utf-8?B?ajJkY004T2VQZURzcGQvei9kUmZFbEdpVDhzS09HK3dldlhRVWgrc0ZacWxN?=
 =?utf-8?B?RVpZS2U4aE5zUXF0VHFIUG44d1FQNlVuWTVUSFRXcWVLMHhWVnh0MU5NK2o1?=
 =?utf-8?B?KzZZZUs4QUx5NFY4Z2ZxQzJoalhoTzVUM1R3MW9CZ0RGVU96cnZ5TzN2K0RQ?=
 =?utf-8?B?cC9Kbm1lZ3ZqRjRDZTBhcmFUcUJ5bkFtd05VcXBsTVkvQ2MrZHdDKzQ1LzJX?=
 =?utf-8?B?dmRRSjNDSHFaRER3b2tLdXJKUThWeFc0bEpjNmdZc1FaWUxuWXZybEloYmdx?=
 =?utf-8?B?UUx6c1hnNkNZNkV0VmJrY3ZINWJJZGJuOVExbDF5dERSMXYwci9tOXUybW9m?=
 =?utf-8?B?b2J5NFdDSXdZSzFoUWR2U3FiM1g5L2RuRmN4MGlnSlVRM2ZDbjErdFIweExX?=
 =?utf-8?B?SlNWUDlSUlJNQ3NabkV2R2o4b3RyTnJBRy8yTVhPa3AxWHdIWXJ6blQrZkw1?=
 =?utf-8?B?ZnlLSG9SNHpSdExuZlhFWTA1Wk5WazZnZE5XVjVFVnhVWGJNQXZxK0c3N3lt?=
 =?utf-8?B?ck1aSGRNN3RLL1IzL3ZJWWdQRi81VWZoZ2MyazZmK2hiQldyWWEwdjRCL1Zj?=
 =?utf-8?B?aHloM0FWQ0JOMUtldDk4Q0pkT0dqT2JKZXJEUGJlQjFIbnVMdmxiMFA1dkJM?=
 =?utf-8?B?THhOdmdqRnRtMGRGS20yak1tQ2VVcDZDOGhxVDlRa3pmUkV1RUxPVy9nUGtE?=
 =?utf-8?B?ZEhoVHFrcEUvYmNQb0liOXhQTU0zS29OcXdYNEdpYndiQ0hybWhlTkRDYWhD?=
 =?utf-8?B?U01SWGFaV1Z1RzBKTDFXaDJqVFJEd1EyYTdreXREL1RGMXc4SnlGNTlMeDhv?=
 =?utf-8?B?YWJvNHNCWWhpRUZhRE41NmJBK0dYanhDdTduNk5oT09zZjR1VTF2Q3grbmNT?=
 =?utf-8?B?Q2tHL3F1eG5GRk11SDFxUmd4VEJQS0FoWGJGMDVVUXp2NkFsL1V3dGcra2cz?=
 =?utf-8?B?QVlhczZhWjVyQkJuc1VJRFVYUWpmSkVFaFZnK0kwWFRJVnNxZlZSOXAxUGVw?=
 =?utf-8?B?ZDhNaGx2dWJJMy9JUnVJaUczSGxZN3ZDM21JTGJMYTlrWUgrRnFScjVBc2M2?=
 =?utf-8?B?Rys1VW1aUU5FUFlqd2JCbHphM3lGai9tRFByTUd6QytZVS95ZHMyT3J3Mm4w?=
 =?utf-8?B?YlZkOFhtbEpxYU5WZjhrek1FSEhMMVNJdU1NenpyU3diek1CZWJIU1ZqLzF4?=
 =?utf-8?B?RGVzUGl2bmZmdlVFTHlCUzdUWmdMdEsvaWRuNDBWSDBSaEpzT2JNUHhTUkpy?=
 =?utf-8?B?ZHlhaGJyY21OVnQ3NzU5eVdPbnp0dTlNdDRTRlhMY1FmdlVBdnVNSHVEdmRC?=
 =?utf-8?B?LzRiR3lvTEN1aVlJRkdmdUZ2R1M0UjdkQ3ArOVdmZ0Uzc1dHWDNpRmpzaTFK?=
 =?utf-8?B?M0ZUeExBMGRGbkFka0Rpa0RqVEo2WUViQkdtV29TakliTVA4UEJpNnR6UXov?=
 =?utf-8?B?bjFwUEdscm1UNnRuMzd2THlNYXVHNnkxemhUbEdRUFAxd0x4QmxqQXR0NW5E?=
 =?utf-8?B?TFBxQUg5RC9WcjR2QnBiNzhOTk56T0dTalgxMFZrTkdZMFlVZnFsY2xDMWxM?=
 =?utf-8?B?MXUwYXBwYWlLSmlBaExnZ0p6VWlvZzViV2IzNGFRUmsraDRQNjZyWWw5V1B2?=
 =?utf-8?B?Uy9GTlltV1Q3QzBrdWdoY2lENjl2anJ1ZjdwTGZ6TDFXeTJNRCtjcmcyYllT?=
 =?utf-8?B?MTZNcWZ2NUMwbGtZUkdCbmlCekV4cm1zYS9DRkdoNElFUGg4NGlrUUplRmps?=
 =?utf-8?B?aU96SkgxdjVMWmdUellYY0dWclhldUsvckFXdDdBMGJzRVg5OEU3bENEaGJz?=
 =?utf-8?B?TzBhRUsvbDd1dmhCd29KNXdva0dKejU2VnRvcDhZU1hFMVR4Vlg1VHNSMHBI?=
 =?utf-8?B?Wm55bEd4UmoxWUNoOG5NOUdaSUFIdkxMUHdSZmNXaW9GOXQ1N1BqZ2NDejho?=
 =?utf-8?Q?4My8=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 840a1ca7-83ad-4258-ae77-08da98b8572b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2022 14:24:33.2575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4DxHX+5j3AYz98OY+XC72/PR6y2t5nX6FEFXC9vzzWklYOjIX69Kqsv5+Ax+g7o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR01MB3667
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/16/2022 10:07 PM, Enzo Matsumiya wrote:
> The signature check will always fail for a response with SMB2
> Status == STATUS_END_OF_FILE, so skip the verification of those.

Can you elaborate on this assertion? I don't see this as a protocol
requirement:

   3.2.5.1.3 Verifying the Signature
     The client MUST skip the processing in this section if any of the
     following is TRUE:
     - Client implements the SMB 3.x dialect family and decryption in
       section 3.2.5.1.1.1 succeeds
     - MessageId is 0xFFFFFFFFFFFFFFFF
     - Status in the SMB2 header is STATUS_PENDING
     [goes on to discuss action if session not found, etc]

> Also, in async IO, it doesn't make sense to verify the signature
> of an unsuccessful read (rdata->result != 0), as the data is
> probably corrupt/inconsistent/incomplete. Verify only the responses
> of successful reads.

Same question. Why would we ever want to selectively skip signing
verification? Signing protects against corrupted SMB headers, MITM,
etc etc.

Tom.

> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>   fs/cifs/smb2pdu.c       | 4 ++--
>   fs/cifs/smb2transport.c | 1 +
>   2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 6352ab32c7e7..9ae25ba909f5 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -4144,8 +4144,8 @@ smb2_readv_callback(struct mid_q_entry *mid)
>   	case MID_RESPONSE_RECEIVED:
>   		credits.value = le16_to_cpu(shdr->CreditRequest);
>   		credits.instance = server->reconnect_instance;
> -		/* result already set, check signature */
> -		if (server->sign && !mid->decrypted) {
> +		/* check signature only if read was successful */
> +		if (server->sign && !mid->decrypted && rdata->result == 0) {
>   			int rc;
>   
>   			rc = smb2_verify_signature(&rqst, server);
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 1a5fc3314dbf..37c7ed2f1984 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -668,6 +668,7 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
>   	if ((shdr->Command == SMB2_NEGOTIATE) ||
>   	    (shdr->Command == SMB2_SESSION_SETUP) ||
>   	    (shdr->Command == SMB2_OPLOCK_BREAK) ||
> +	    (shdr->Status == STATUS_END_OF_FILE) ||
>   	    server->ignore_signature ||
>   	    (!server->session_estab))
>   		return 0;
