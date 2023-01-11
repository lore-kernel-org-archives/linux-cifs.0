Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D14E4C54EBC
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Jan 2023 01:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjAKBml (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Jan 2023 20:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbjAKBmj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Jan 2023 20:42:39 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C1F19C1F
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 17:42:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IzjQ18V+F3wSZai4X/hc+904tnXFanKoKFPRNJhf0c49fcQ15DaOCT5ZBCZ+mEY4G5qGBg/xla7kXOOMAEeHBziXy/ppi/zYj8A4aHAf7w39InW/1cFS4iUGXkII6CwERrbrNv8S/YQFLEcWvS7FrAORhMupQZAX5xpU7Yp30o06t7v5FZhHwBT758k1JTw/C58Pzh2FQYhHjaPNWAO/v/7pAA659xSxUTFSQTh5yF55NAmXEi1NLCSHuHT5sp9Z1JXnMaP3G2+RhOIR6Y74+Bo3LZIZfbI52AF6IUqYK+hHvvngj0xjZEyfPvgg/zXU6H4FkQGgk8HGk8yN+zJJPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mqW1pa0LM48uya4L5ZlxtopcjAxzJGmBTSqf1gHkofk=;
 b=UopXcVDxxQHvnT7xAHGrxuStCXQJ6njfy+6vV2gbSbVc7gKnz5WGV86YOssBcedCxejW4qRtW2xFtdnGIrWalCVfPC0CBx+j+VsoVDYOTMjDauHIkYa4o9O5lTGZwjnVic2+CAWVVk4MyMSERukTNIBOafda2H8KtA9onfV+iUgocaUIItYXq9LKvGLUi1xevDk3BhC7nNyrPkLm5Gj6OqctD1OFof9ZDr1V6crLKTjkJI9YbLdmVXA1Yxd9nCU0dPBTHZEPfgKKwQm25kHVqv6BfCHE+4xXJPQ6NgDVmiNtOJptQpxWiwOcawRWp9XtLSK1QjQWOhm70QXCOhxS2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SJ0PR01MB6158.prod.exchangelabs.com (2603:10b6:a03:2a0::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Wed, 11 Jan 2023 01:42:34 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5%7]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 01:42:34 +0000
Message-ID: <25f67260-e483-b81b-2fde-7df7d3359370@talpey.com>
Date:   Tue, 10 Jan 2023 20:42:33 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2] cifs: do not query ifaces on smb1 mounts
To:     Paulo Alcantara <pc@cjr.nz>, smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>
References: <20230109164146.1910-1-pc@cjr.nz>
 <20230110222321.30860-1-pc@cjr.nz>
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20230110222321.30860-1-pc@cjr.nz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR1501CA0019.namprd15.prod.outlook.com
 (2603:10b6:207:17::32) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SJ0PR01MB6158:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e7568d1-077e-4683-b200-08daf3751c82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4bhfh/4HsOImwomS3uqo41P7rs8oz4LBDHZpPnBfIu2eN/WVPJwmDgIpFtBVVsJkA8dB4OYcPL1FPSHkmK5Pl73IG/Sdqhx3+3oZZ9zEA+kQn7tOJR4JIyVBCeVDZDzE38txDpeeTD5aQL9laQ9tk98RYCy51pAVJVa9tq5pZgJVqWMKRRoruwTWaEWmcKyj+yV6/FAxsGTI7IOFdMWOwVOTqv17N09hbv8+Z0Q5zniiRltu+LjKblr/XFeMWMMk28C9R0bxqKij9mFxnnK6PJEDIIYUtivlyx5hnBnbMGaRQizQs15FjhPfuRv2KQ+D+X6ihN8tUKOz4eEcrJTyLirQq5CdjS7kKbvU0RwZhr5EN0rRnfu27ToxKUlwaVNphfAj0GcuAp2/WNKfnFWjMclR8dXj2bLi+VCpkVOIkcDY6QKHpiSJYzv4jqlcSaqlcDtBeN1jF4eHVAWRfoIbzdBFpDjvaaQu5M1+C2i4lgIB8bL97trCTgxz+exqkb2bDFjzW/wexFITK8uktT6sisRCYTtUWLIfjmDMriZ4+JRGsO0bu7j/6trykZ/9g1MpegxCXwzNnFfqcTKOhVVQG5dB/Vn+a/qJfu/k5pzRBI0lLuxN9dJFveMhZdoS0yYbQ0iFPzdrRtKrBIpXsUYpjuBHpxjiGVPVwgYoRBLn2iqif1Irfi8trImcg8XZ7UyczmOwbLDaXHvUFQvqXy7iFNR8M8U+qCmowe2YMthUgg4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39830400003)(346002)(136003)(376002)(366004)(451199015)(45080400002)(52116002)(66946007)(2906002)(36756003)(83380400001)(8676002)(4326008)(66556008)(316002)(66476007)(38350700002)(38100700002)(478600001)(6486002)(186003)(26005)(86362001)(6506007)(6512007)(31696002)(2616005)(53546011)(8936002)(5660300002)(31686004)(41300700001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjZ3Wk9FZkRzNlZQM1R1T1YyU2VlR21RY0w3TmhOL2JWT0x6LzV6Z2c5Mmp1?=
 =?utf-8?B?YlJJdUdPK04vTW1ydzJGKzBqanlsWE9sNHh4YnpITFpsa2JhK3E2RWVvTEtk?=
 =?utf-8?B?UDZubVJaL2FOR3ZVRUxCU0E2ZU43NUlXYU1IUDR5SHJhNDdGQ1hDUHdCOHRR?=
 =?utf-8?B?cG02dHloY3haZXBQZUlTc2N2SDEvTUhxdGxybHZ1cm82VWw5ZmQrcEVyY2lD?=
 =?utf-8?B?a05NOHNJTTJSUzg4V25JNFJUQWNGeDZXNXBGajM5NWxhQ29sSkJuZ0xVVjZM?=
 =?utf-8?B?cDZ5TUZXRER1UVRiSlZiWVl1SXJpdmxUdXozTGZyK2JMc05wWm5RTkYzZjQ0?=
 =?utf-8?B?WnlQU0VTQmtXRFZiTEZDVnVYcXVnSEtlTXdVVmowY2xnOGgvUzNvSzkwUE1W?=
 =?utf-8?B?RUxwdUszOW0renBqWmVmTVJidTJFckdJT1BDN21uMGc5K0p2NlBWU2FrSFkx?=
 =?utf-8?B?aUNsSmVZTEV5VUViQnYyNGVpNGRDM3RvSGRYNXlmaVVUQnZGYk1Mdnk4S2dW?=
 =?utf-8?B?bVl5Q2Z0RDRTN0RtUHhvQ0RCOWN5RmRBMDh4cXNDcE9tSTJhR1lsUXMxMFNX?=
 =?utf-8?B?bUtpOEw5bnRFWkNBYWhmbzVGYVd1N2I3VU8zZm9sWkxvVkxuU0xVQjgrazdK?=
 =?utf-8?B?bm04RUExMS81Z2dQc0xMeFd2RXN3TkNqUW9QUEhnQzFodkRLL2dNOFcycDQx?=
 =?utf-8?B?MTJCT1JGL0I4YzloVmlPYWErU3VoVCtkR2RMbnovRzhHMjZxckxWMUZsSXlS?=
 =?utf-8?B?Ykw4Sk83Y3VROHRnTjhMWlhwWWc1dXVFTkE1VEN0M2Z3R284Slo3VFdQZTU4?=
 =?utf-8?B?eG1Rc2ZOMTJBM2Z3bDVIVUZoMlJWWWFMYkhZeFY2N0pISml0cHdsVURrOGJZ?=
 =?utf-8?B?SGNvTzRZMU5HUTRCYVM0eGNKSXNLUHNuUjV2VG1HL3BoVjRSQmlKbys4U09U?=
 =?utf-8?B?ajFLRnMwTXhHN3djRDJyTE5XOTNIR2pWZGNLd0M1OTNEanorWktSeUxkelBr?=
 =?utf-8?B?K29nSG9semcxTE1iVjZpT1JwOWM3R083VUQ2N0crMGd1YWRWMlhrM0tOR05h?=
 =?utf-8?B?Q2MwZ1hHL2l4K3o2S2JSVnEvREVQU2hmelhhZWluTXpjKzZEK2NLSWZVYlBH?=
 =?utf-8?B?ZXc0UTVRek0reUZJUkZDakU0VnNYMklRdDJTcm1xc0I0QzBwU3V0b1A3V0x4?=
 =?utf-8?B?aEdoRmU3OW8wcEZDYTRqdHROR01rZTVGTkRrQTFZVmJsOFI0UDRERVlRaTdQ?=
 =?utf-8?B?YS9pc1c1emZ1VHI2TTd1dTBUOVZjWUNQcU0xUXFBbjBIdnpEenFQemxFNlY1?=
 =?utf-8?B?UjNYN050ZkR0OWdTTTJQRUk0RzRMR0FoSHhaTlBRQjZIczgzc00xL0oyeWJD?=
 =?utf-8?B?cWFLS0pMQmFESmVESDZMR09BNzRxY2JWZUtoWkZKeGNBSjArNlNSSmlWaksx?=
 =?utf-8?B?SW9lQmVidzVCck04Z2prWTBiZDVkcS9CcmZUbGs3V3FrTmEvbFFiL0Nad2gy?=
 =?utf-8?B?VlFNdVJYWVFPdUpSb3BZbkVxYld3ZE5qTHM1SGhBRTA3eFZlaVBSQzFDQ3Z6?=
 =?utf-8?B?aUE0OERhL1VzMmhzOWZQUGcxLy9MTitFaGppOWkrZm1DUXk3RG5BWnlVQWVO?=
 =?utf-8?B?aWcyQ3N2cE9zSlg5WFpOcjFQUm1SN0kzNDVLaHh3SGVqRXB6YnVRZFZBYVRR?=
 =?utf-8?B?MWY3czVYemZWaHBBTGlTaGRQZGQyVmo4SER1eVVwdjgxRG0xeWM2QysrdHla?=
 =?utf-8?B?aXk1cTlQbVZkZ1ZBcm1McUs5Z2tnRy9xaDBKdWlGVW1UZ3duYWRxM2ZZWWJV?=
 =?utf-8?B?WUtyQzdtc21TUFUxZTZVVGthSFlYdXRoNzE1NUkxbGJiaGNCS1pjNHlBcjdi?=
 =?utf-8?B?b3ovRE40dHZSRVFJSHNsZWtGZERhek5MZVV4Zm53Z0JseUV6MUxQem83Ukts?=
 =?utf-8?B?WVNOYXc2YVo1aW9FVG1KYU11cTB3VDZWZTNUOEZJRURKNjJ2TkhjbGlPYjJJ?=
 =?utf-8?B?Z0QvQTkydU1XWitseTNNWmp5emt4QTdJV1JPSXhhdlNCekt5Ni9LdHM4em0r?=
 =?utf-8?B?T3NqbXpjSEtFQW5oSHA0TEF5bWpSOURnRzVvOE0raTlOVVgzMk9EY2EzeHlU?=
 =?utf-8?Q?6/tVZ4DevD9OpbqMJIkRVzWdT?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e7568d1-077e-4683-b200-08daf3751c82
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 01:42:34.3115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hM4pgs3NdAu9ep+DlT4rxmeBl9agZXjyP0FJfzehKIeVbNzJaGTXvqQcgEUHs/o1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB6158
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 1/10/2023 5:23 PM, Paulo Alcantara wrote:
> Users have reported the following error on every 600 seconds
> (SMB_INTERFACE_POLL_INTERVAL) when mounting SMB1 shares:
> 
> 	CIFS: VFS: \\srv\share error -5 on ioctl to get interface list
> 
> It's supported only by SMB2+, so do not query network interfaces on
> SMB1 mounts.
> 
> Fixes: 6e1c1c08cdf3 ("cifs: periodically query network interfaces from server")
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
> v1 -> v2:
> 	remove cifs_tcon::iface_query_poll and then check version and
> 	server's capability multichannel
> 
>   fs/cifs/connect.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index d371259d6808..b2a04b4e89a5 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2606,11 +2606,14 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
>   	INIT_LIST_HEAD(&tcon->pending_opens);
>   	tcon->status = TID_GOOD;
>   
> -	/* schedule query interfaces poll */
>   	INIT_DELAYED_WORK(&tcon->query_interfaces,
>   			  smb2_query_server_interfaces);
> -	queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
> -			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
> +	if (ses->server->dialect >= SMB30_PROT_ID &&

The dialect test is actually unnecessary, because the server
global capability, indicating the support, is what's important.
But it's harmless to be explicit, so...

Reviewed-by: Tom Talpey <tom@talpey.com>

LGTM.

> +	    (ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
> +		/* schedule query interfaces poll */
> +		queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
> +				   (SMB_INTERFACE_POLL_INTERVAL * HZ));
> +	}
>   
>   	spin_lock(&cifs_tcp_ses_lock);
>   	list_add(&tcon->tcon_list, &ses->tcon_list);
