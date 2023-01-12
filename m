Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF7EC5479D
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Jan 2023 02:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbjALCgq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Jan 2023 21:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbjALCgp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Jan 2023 21:36:45 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD804117E
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 18:36:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eocusLXWbNz/bLURqYPEfSCRbRhNRDP+QnKw3KCFFFkXpf/JFPrBDyoWTkZ1YlJ0mNkODjQqK3HEhG9z26gC5QamuaMQCCxzEGXBqFB2FPkaiBN6OIxLdj6o+gzXGQhs4Hme+lEcUsVd9+d88c4cpaiUfXqePgX0vITVD7HXUC+rd9Hkd7dw0ArCg/UCLGH+QEDiRbj6jX5K/K8Wjo27u8HUotmsWkcqLZfK+drVbyZqwEiKMSWWnPcxZ2HOIBN+x0M+AzlMhHg6yB6IpNA9OY0WSWI6kjiPtYnVxe7YosWt+yc2pZMJ224xAVwzO8C/6Bs8f3SuLdYFWWFzQj02FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZi6vqN+8vut/6yZdaosE1EbKHLfbf4Mxz61lRTK2qA=;
 b=dfgeU9LMLH+UPYkZBygSe9XTskpkQOzpa5+0dBgiNRxn9xSCWJBQfS+dz0G88gJPHsT63Lo8LAztzeCVvgbHpVtcXBMaekBs9L2KsEY3Obf0HAODSrwQgsE9f/uxFy5j/R8gWTOgO2pSiu9DiK4OsLnm1Xe7aDYQa4l6hcmo0APskkp29szu7GS4so9RBGoD5ESkpfrorMDMDA8tW04KXh9Ax++gfv33BU1dTeb4rg8rFj2aTxIhcTPHiTYLm4KEWyaLGb9LFwYMtlOFqyz2jzznZblStxIRdWNbJP6to3im6+mCMOEgRnBT6Bzs3mZrs3AXdL7LqsQk6dMUsuwzbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 PH7PR01MB7910.prod.exchangelabs.com (2603:10b6:510:271::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Thu, 12 Jan 2023 02:36:41 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5%7]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 02:36:41 +0000
Message-ID: <962d5749-f541-a078-9ac1-b33a9395fd16@talpey.com>
Date:   Wed, 11 Jan 2023 21:36:40 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] ksmbd: do not sign response to session request for guest
 login
Content-Language: en-US
To:     Marios Makassikis <mmakassikis@freebox.fr>,
        linux-cifs@vger.kernel.org
References: <20230111163901.2030281-1-mmakassikis@freebox.fr>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20230111163901.2030281-1-mmakassikis@freebox.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0176.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::31) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|PH7PR01MB7910:EE_
X-MS-Office365-Filtering-Correlation-Id: 86cc6ad6-2791-4a53-bad0-08daf445d64b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ygjJ+sB0tMiyQkZTzKIvgw2yQIHEmNYGBBShAId0m0HdTVn4U1QJ/OBXwDURC+Fh6FCtsEA8Ag0d8XwRIcJbDOtJ6AxYALf10pd/HVWQTFuMZas1Xv4DsA3NkD34qC76KRikvZL84FcQxhfNHgDOPfZ5GlOeZ2G8qBjSCteuyW90H9gOH9Ia9mqN1sblSYK6CeidmiDbnKIGAHq43u6+LPWsvwwRSQDycDQpTJtmcP9ZMULcCKBPqgdv/VTwE9pOooAsVPA/TBwmS1+nyd7GCsV9jroXIvFUjQvkq50H2KoUYrRMlkh1uv3UN6zbOEdVuRCOeXywZTiu8vC7KCVblF0t+DgShqkcA1G1L+BammGxYDDYw50oqLczEYEDwTADgiQatJn01e6UF7K/tSn2TgRGqYjJbQ46P4tzoi3v0E/ZgXugvwzsVMsS5K1kPo+Zmi0JmrN2KcPyY9OpNnrFLQ/YFQVgNB1BKs9+qmqb5spgcvgldPkF6DIu8U4JUMuhlsueVdMCSkJtpCbdMv3vSJYKq66SdX5su/G+8bCd6gE1pNO/gYB0SbbL046mmrLf4plYuddf2kt4OF4nfyF8tsoQI52bBWQBQ81YvONJ0Aacs4yIGj4Kq7Nl8BHGLefmai1CZmqnqrK/zdtPMo4gk3SsGWSHcZTgelwtur6TdjHNTmtDmwRHXiIOYFcsCiMdjz24SeeMoQVgH0yl76qCbP+gUAdlAMbui8zg0WN4miE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39830400003)(346002)(136003)(366004)(376002)(451199015)(6506007)(38100700002)(31686004)(38350700002)(53546011)(2906002)(478600001)(6486002)(2616005)(316002)(52116002)(26005)(6512007)(186003)(5660300002)(86362001)(8936002)(83380400001)(36756003)(41300700001)(31696002)(8676002)(66946007)(66556008)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3BDeThUZnBWZzM3WkUrWEtzMk5pd1RMOGtiZ3hsOTJqeUk2R0ZlM2FKUFZ3?=
 =?utf-8?B?bnkxTUNVejdUSys4Qk5oK3FJdFNXMStwWkFDQitGUjJZek03STB2WGM1MEFw?=
 =?utf-8?B?ajN2S3g0MlpKcWp6UjRyMUVZdnNnWnh5N0h4bk50MWNiR3l3WVV1amtaMWNQ?=
 =?utf-8?B?enBiTUNpWHU0NE8vS20xV1JnelVZLzJ3RGxUait5Qm1ja1VrdG1CeWMvbXBV?=
 =?utf-8?B?bFpLUk80ekxuYU1OOHFpOG11UEh5S1ZNYXBORXFnNFVrQmg1d0IwZjYzQ2Vl?=
 =?utf-8?B?blRHTm43dmNGc2lKM0FUNUxiRTJpdTVua3Z3eWlkZm5mbERyOWtCWjlCMHVQ?=
 =?utf-8?B?b013b2R2TzBNbFlVNmo1aWs1SDFicnRTVDZkY0VrTXRyNVE3eU9KeWMwQ1J4?=
 =?utf-8?B?d1pDUENzUy8vZVkwd3dVaU80S1lKRjN1WCs5eDV4YjNBWFdRZzdBc3l0cTdX?=
 =?utf-8?B?MndneWZKQUtOQWpEZ1Vnd2o0NUUxUURlWktqWHZRYmFKU3VFNUdzSnhUSzFq?=
 =?utf-8?B?UEFqVlFnVGZiRjVqZEVpb3Z6TzdmZWNwb1pXU2xNUWc4NllGSk1RL2JWSmhs?=
 =?utf-8?B?RCsvcFV6MHA5dHorTzdJUXU3ZVR1WlZYVGkvQ09jUXFkVjE5aUZKVE9Zb2Ns?=
 =?utf-8?B?RmpUSVFrdk1KajNhRzhXRGErcnVDak9ITnZmWkVvMnRrZDNYdFN3aEQ4Z2Ji?=
 =?utf-8?B?bHovMTZqc015WmNkT2xUUGM5QlFaZVRzY3RNSXBsWExubGRlMy91citpRUdE?=
 =?utf-8?B?MnJrRVpjTjlLZDNpd253MXYwNGNsd1IwYzZzdlEyTVpzRjFQTlhuMER1K0Va?=
 =?utf-8?B?dU04TVpwWmIyZ2xiTzJLR21VS1NlNmVydVFnZXFYV2JLeWQ1RjluWi9CWEtB?=
 =?utf-8?B?ZlkrN1hMamI0eFBFa1VJTmxJMXVwbENKdHBGSGp0MjJRcTdrdkpQV1ZZYm1T?=
 =?utf-8?B?ZnpFUkxiSE5mQ2hPMkFmQ0psRXhzMkloM0JpMCszbEIwRzFkV3RESXJxM2s2?=
 =?utf-8?B?T0E5L3BiUDc4ZUc2akgvZHNqK25JeWMxWTA0T3RsY3hGd3YxR0JYbFVkLzRV?=
 =?utf-8?B?MjdQaFhUa203WjZiRGs3ZmRickxneFk1Y2VCM0hGZnZ4NTljekg2L01uVzND?=
 =?utf-8?B?MmhsL0ZRMWl0MEowRE9rUWozMmpQQ2tuSHJhOWNsY0lxWTluUXI3Y24ydy9T?=
 =?utf-8?B?bmJMdVQwTmJJeVcyZ0xXTGlKL3MvdUdqVk1lSVdFQ1ZrU002YTVmVCs3VjU3?=
 =?utf-8?B?SVgyejliVGdZRjRYendIaWFUc1lHMUx2VVV0dEJuNC9kbldwTVllclVRVm1r?=
 =?utf-8?B?VFNaT1ZFT3pvUVFJMk5lbU8vUGE3ZDFRbFNrbzF3V3VmTVNGMFdvVCtNR0FT?=
 =?utf-8?B?YSt2dFZwcUxOQWdKQVpyMmZMb041ckt3dllUMEtPTVIwN2NuUjZ0b2lrTnZP?=
 =?utf-8?B?MzRSbnZyeTIzSktra3ZIaHhDMHFQdHVldXZOeUtlckwwRDM1eFRQQnB0NHlY?=
 =?utf-8?B?bkxQa0hHb0xjQjhhLzRXbHkxWnRTVzF4SG9uWW01VFViWmp0VHVxNTQ0MC9N?=
 =?utf-8?B?OGVYRXRiUEZDckRuQk9mdWV4cXJ6UHFFaXh6YzVjd1dtNy9TTUptN2xuTDU2?=
 =?utf-8?B?RW9laEJFNlUyaW9EUWtZc2dCVGxuRmYzWVF5YTNCTXJYelBaRC9DQ2tqVmxM?=
 =?utf-8?B?aUZRT2FPV1hVL1UrL29FUlJQRzB2THE3cUcrWUdrL3RHU0oya2tQY3psdWhY?=
 =?utf-8?B?WlBRZmo5WCtCNW9DMXRQWElVMWVyN0N4czdyWVlLNVhUekN0ZlFSUmJ2cnRr?=
 =?utf-8?B?ekdOdU5kNm1tYmhycGMyQjJwNVc2SWNKWDZkaE5yc3ZaVTUrUGV6cjBPNlpl?=
 =?utf-8?B?KzE3SXdqWEUrRkg1UnFFY2grV3k1YTcxZ2Z5UVQ5bWxEc2J2dXRZWGh6dlIw?=
 =?utf-8?B?elVPNmNmQm5rV0RhUE8yb1RGbUVZaEtqTXJZcFNkVUVsUUlJNERiN09lb3VZ?=
 =?utf-8?B?MmF0TWNGUERlZ1ptSkZjMUsxUThId1BydUkwQVZNOWdRbHUyT1FMTTNwZVVi?=
 =?utf-8?B?YkN0dEJwaWVrTlIrTGFqaGNsaEZCVDBUMk8wN05Pb1JwN05ubGxKWEFjSThj?=
 =?utf-8?Q?o6eusa98MUn5qDHr3tlngFebZ?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86cc6ad6-2791-4a53-bad0-08daf445d64b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 02:36:41.6085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1b0kr2isNU2zT+Q2MISOuN6Mp7wYwvpWRsVXBYFkuW3WdWAcxxMoIBiLVoKcDoH7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR01MB7910
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 1/11/2023 11:39 AM, Marios Makassikis wrote:
> If ksmbd.mountd is configured to assign unknown users to the guest account
> ("map to guest = bad user" in the config), ksmbd signs the response.
> 
> This is wrong according to MS-SMB2 3.3.5.5.3:
>     12. If the SMB2_SESSION_FLAG_IS_GUEST bit is not set in the SessionFlags
>     field, and Session.IsAnonymous is FALSE, the server MUST sign the
>     final session setup response before sending it to the client, as
>     follows:
>      [...]
> 
> This fixes libsmb2 based applications failing to establish a session
> ("Wrong signature in received").

I can definitely see why! The reason for requiring the SESSION_IS_GUEST
flag to be false is because with guest there's no secret, and therefore
no key to use for signing!

But, I'd expect the code in smb3_set_sign_rsp to determine this. Before
signing it checks the following:

	if (conn->binding == false &&
	    le16_to_cpu(hdr->Command) == SMB2_SESSION_SETUP_HE) {
		signing_key = work->sess->smb3signingkey;
	} else {
		read_lock(&work->sess->chann_lock);
		chann = lookup_chann_list(work->sess, work->conn);
		if (!chann) {
			read_unlock(&work->sess->chann_lock);
			return;
		}
		signing_key = chann->smb3signingkey;
		read_unlock(&work->sess->chann_lock);
	}

	if (!signing_key)
		return;

So, the work->sess->smb3signingkey is obviously non-null.

What value is being set? Addressing that seems to be the more
general and appropriate fix here.

Tom.

> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
>   fs/ksmbd/smb2pdu.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 38fbda52e06f..d681f91947d9 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -8663,6 +8663,7 @@ int smb3_decrypt_req(struct ksmbd_work *work)
>   bool smb3_11_final_sess_setup_resp(struct ksmbd_work *work)
>   {
>   	struct ksmbd_conn *conn = work->conn;
> +	struct ksmbd_session *sess = work->sess;
>   	struct smb2_hdr *rsp = smb2_get_msg(work->response_buf);
>   
>   	if (conn->dialect < SMB30_PROT_ID)
> @@ -8672,6 +8673,7 @@ bool smb3_11_final_sess_setup_resp(struct ksmbd_work *work)
>   		rsp = ksmbd_resp_buf_next(work);
>   
>   	if (le16_to_cpu(rsp->Command) == SMB2_SESSION_SETUP_HE &&
> +	    sess->user && !user_guest(sess->user) &&
>   	    rsp->Status == STATUS_SUCCESS)
>   		return true;
>   	return false;
