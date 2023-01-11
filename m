Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 556C6C46467
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Jan 2023 02:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjAKCe0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Jan 2023 21:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235730AbjAKCeC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Jan 2023 21:34:02 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FC7C1F
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 18:32:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bfUuaHGnjNPMbsMmaiO2WNqR1VCpJQsI+HJqmMnq7teD43nGgCz0RkAUdfN+a5plekJXn7MmSmrFn6qhLed+K+v21bkey+WKyKjgnGQQtg77lSScYwm9XUhtpmEIQoHubDJSD2mzmatf1FtjEWK6aY99zIS4uzrFrgsYdAm3VeD3jzQSqr3gAa4qWxZo5waSmZeK4JV/3AYKw3rWMnTLyIGy/ANWEjhv+5d4m+2OIxpeCBDadAelfsCkmnbqi5r+eiHm+7+8AtUNAYUCAHX1yLvY1wrMw/LJXZIFfr29IWVmFxOkqUv2EhUu+hf3m1AuPCHdjdPmOYpfvMtKewSmEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yiReGw2eDEQ3EG5YGSTYjWbl0wVJE+09f2Ykp5VvDzY=;
 b=FxkSrxbcaWSMsU0tCP2jpDljtWltL9e5Ys0eGtfmNJjO0tALhHkWHAASlNN0UerA23i0jPsXJDAIeVoQt9wXQu+l1Rvu+TwXSVuLz+lr8fFWj2MyuO05tBvYXyZBUoV+mNKazAD+Sus+h3LN3KQiS386C7T4q7RRJkdx3jAdev6oV1osIptFZlCtjqqtSYBS9q4mv78cNG4ehFkqV2pXfZaoNdj60e1+J2oaOmZi2+l9WWlp2yXTy3bDgB/UP+WhqzOTeRXm8aOBmdsCQRrGO/koo9nmmAlf3ad8OQOZq5EgH4ubR+7UBK+tcYBmFBLEdcnNgdBiPs0RBpKaZBg1iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB4583.prod.exchangelabs.com (2603:10b6:a03:9c::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Wed, 11 Jan 2023 02:32:36 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5%7]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 02:32:36 +0000
Message-ID: <89c5f6e9-2f8d-67a7-0ee4-55842d3063ec@talpey.com>
Date:   Tue, 10 Jan 2023 21:32:35 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2] cifs: do not query ifaces on smb1 mounts
Content-Language: en-US
To:     Paulo Alcantara <pc@cjr.nz>, smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>
References: <20230109164146.1910-1-pc@cjr.nz>
 <20230110222321.30860-1-pc@cjr.nz>
 <25f67260-e483-b81b-2fde-7df7d3359370@talpey.com>
 <4F09ED4F-E76E-454E-938C-2E6EFD1F871F@cjr.nz>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <4F09ED4F-E76E-454E-938C-2E6EFD1F871F@cjr.nz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:208:23a::8) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BYAPR01MB4583:EE_
X-MS-Office365-Filtering-Correlation-Id: ce9ab2b7-517e-4150-766f-08daf37c19dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rgzebkw0/wGYgcpsRPLksfbJZxjbW4mrNfLajjgG3+pkd4GzIkuWQzx+P1u6CEewsy4S3DUh70nBpX2dzkeMiL93DsCQMgQFN1um5uuIUJE7o+qB5KWsPYLwKLWk1peZ+MJM4fchy+t9VfsY42OofJNdoCns72LQ68GBRWqOiA81WS794gW9IXoh7VR113R5wiNRCttiaYjGRmD8bu+WITWebGUtMJEK8L77VltjGsMuWlFhKfZpVYpO1+Pz22xKrqkVYZzzO74v4ceOYmE65MbdNAUG0Cz3k6AgDM0QjfxjzYc8PUp2nL6XNicHB9nv3ZGicCCsAmf7yLi8QK7lFqUGwloP7N6jcTSJogy5zlT6+/pEwiBtwxHnJ6Cx4qECbNqGDGhDY1SbJmh9VAsvXPHEgwbb9p+J4KEqotFmW6Jpe1/H7QiholyTDwXaKTDLxVEg9n+EtiT+DBrbVsehqXZPT8QfqFpITySNfRjtu3/KVqZPxMxnEtkIj8a9XvJOvrmKhGqv8OzjB3Ff+NRdZ9I1Fomjnsbf4zpt7cvO4pUA+2/3lqsrKyawT/rYJrhfeQbaCYZUiAwCaYvAr8arvRnV/vIDGlK+aC0yFVwuurLAgfPL3wGHfhlNe23WUBF86W1PtQzyJIJHRUVIV7TClMf9M95ub6ItFXDBZpbEmIYd4Z2PzQkjEWGp2CNPliLEE3ZYTdCeYyZok5p8TkR1fVUw1LneQsDp6HP2mlMDgZcM3/rMmhVFB+MtIhc1SsvR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(376002)(366004)(136003)(346002)(396003)(451199015)(8676002)(66946007)(66476007)(66556008)(316002)(52116002)(4326008)(2906002)(5660300002)(8936002)(41300700001)(45080400002)(36756003)(31696002)(966005)(83380400001)(478600001)(53546011)(6486002)(6506007)(38100700002)(2616005)(26005)(6512007)(86362001)(186003)(31686004)(38350700002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3VHZnIxWGtKa0ZwU3ZiZFdFdWpBc2xwbWRYelMwMTNRaXJZcFNMSlFqT2No?=
 =?utf-8?B?OER4WW1odGs0QXNqWXFLN0lNbGhnUWNYMVdmK3JZUXFXbXVmdmV6M3Vpd3Yv?=
 =?utf-8?B?SFpUWmg3cVpsaVdSdDRvTXd1WnNyVVEzdFJzY1hvZEh1T0NpY3U3bEZtZnA0?=
 =?utf-8?B?L255R0V5RkVPSFUreEU0NVpmVmJsZ01GbG13OGFwYVB1YnZZV21uRW9jSkJu?=
 =?utf-8?B?WTJhdmVPMVpadVlEbGNmWUZweHA5NGdaTEdNSitXWXVxVG9mSkJSL0tHTlh2?=
 =?utf-8?B?cnZWdXBiNFUrYlpuQUNpUmhvTTV1S2VrcDU0NmY1d1Z1LzQvZC9zS2VET1lj?=
 =?utf-8?B?UHJUUjdIa3d3VDh4dkxnK3hVTEJtdHVoTWhlZlM4OCttQjkrM01nSDFMc3pE?=
 =?utf-8?B?ZUxubUx4M1ZKWnVEMnhScmlxMkdIVXBYVFRkcm9PY1N3QVAxUm9SOU4veGpr?=
 =?utf-8?B?QnBIOVcwRy9sKzVlRDdNYWNlZTYrdUY1QU03NU9rKzlORzN0S3NpUWd4a3VE?=
 =?utf-8?B?eGhQYmZNajB3Rm5ONGp4dXd1SzVVWXhQL0ZMT2ZFQ2wrVEdmbHNFL29keFhi?=
 =?utf-8?B?ZklnODg4UTUySFlWUWpZaGhodUxjVFhmWTZsSmh4K1lCVHZEUE9VdzRZcnox?=
 =?utf-8?B?SHJHOHNISEI4TnA0WlBkMmVpMDhHcm5uQ2p1RWVxd0h3cnhlbHJkbS9wcEt5?=
 =?utf-8?B?VVJibTJLeGs2dWZSZkdWQUhkeGw1a0dXa1YrR0ZST0c0Z1NTeGZndldLOFh5?=
 =?utf-8?B?SnlRR0NHVTczZXhPUzRuaVB4ZHR0Ymg3OU5adVA4VGpESzU4WHkwZDRQdFNr?=
 =?utf-8?B?SjZsWCtQUTY4YXdQWm9TdUEwdEtsbmhDcWxDZzZVcUZnRzdFYTRNS1pLQkRK?=
 =?utf-8?B?bVhKM1NibUlCeGNxNkM0UENEc3NEanhkVGk5b2dzYi84SE1CZnhBRG9IZTlB?=
 =?utf-8?B?Qks4M29YaTM3MVFibld3cC81OFdncmxneWJEQ0xzMGVBN0R2T3RRbTFadUxy?=
 =?utf-8?B?dGRwT3VJU0JURFh2TzVVUzVtcGtabGg1MElJRzF2VHpaWHRYemoxdlVOQmV4?=
 =?utf-8?B?TEFmdVBTTWNCMEh1UWNlQ1BGTHBzMlVBL21YeHA5dTlsRUlYblRPT1Z6TXZ0?=
 =?utf-8?B?RmpnTEZCMGw0UXp3RFVHQUtnUEFjR2o0WHlmK3VHYmdVb1BkcVQ3VGpvUk9H?=
 =?utf-8?B?aVBmb3I1RlVzOUg2eS9WN3NSUXZ2WFBzMnp1RnYyNDRSUldkYnZwN2xDWStD?=
 =?utf-8?B?WFl2NWpkVUs4Z3NHRk1aNUlSTU1JM2RNSVB4ejZCZkYxbHBrSUx2cXg4TUR3?=
 =?utf-8?B?NU1VRUh4UlhaOGVjcXNPT0VXOWsvL3NWMzNuQjE0elNNUFI1eUlIemNGUFpr?=
 =?utf-8?B?c2dyenM5QVBJRGpHNDErRkQzNjdBUXdDNzhsUCs4ZDdNc3NTVnByaEowdGdo?=
 =?utf-8?B?RGxpZm52UHU5bVE0VHErbU1iU1ArRmpYME4rRkQyNXNOTCs0aWlRUnlHUjYy?=
 =?utf-8?B?NzdOV2RxcDB6Um5IV2NJejd6ZU1WblpHYnVwa0VtNnpSSHA0c2JkNmlKSUk1?=
 =?utf-8?B?Z1hOUHI2b3MrYmdGTzBhNUlOZkkzcS9mb0R6QjVudUkxSVNxYlJ3bkVvZGEz?=
 =?utf-8?B?d09OWUhzaEx5WWVBNXVyL3M5Rm5GM0p5UHZpYmdIYlNnTGRjTnNMWnpYMGZI?=
 =?utf-8?B?ekVNbFVLU0RYdzR0WUhVdmZiWlpaQUlqYkhIZ1lHbkpaZVN3SHg2b2Q3SmM0?=
 =?utf-8?B?MFdWdzlZQWhmY3hXbVJPTFRwREFzbE5UbFdVSWx4ZmE3bTk5UTZUT3NnUG1j?=
 =?utf-8?B?UTJRZlZHRmNZSFNZTWU5NVk1SHlISVhDNUNmZ3dianZMckpYQ09XbDFOcG5q?=
 =?utf-8?B?RTJoWUdDdFZmQlFGNzdqdFdmcmFYTEptOEcxSExSOHdtcnRKekQwRjg2RHJI?=
 =?utf-8?B?bE1JdFdjdnRKdGNyWk56Si9ZaGx1dWlzcnI4NnRFKzRSVGswMDZub3BYaUZ3?=
 =?utf-8?B?ei9RNG9CMllIdEVhZktJQnIxRkNzaWU3cXFhMG80QTFmSllqd2xRK1c0WGdv?=
 =?utf-8?B?WEFOTkNoejdyNGswUDZEaks5bWlQVXlPS0NYWFhiUHdxVVdVSGxKbzlQMnF2?=
 =?utf-8?Q?rIdqYU2vX3ypWpMkPxEOu9BQm?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce9ab2b7-517e-4150-766f-08daf37c19dc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 02:32:36.3125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJP8UWPzZTnx6lmcwRpSbB5zxCkhl0CWSKF9nee/6PxZGxTWU7aUsfZPqUFKGxb0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4583
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 1/10/2023 9:24 PM, Paulo Alcantara wrote:
> On 10 January 2023 22:42:33 GMT-03:00, Tom Talpey <tom@talpey.com> wrote:
>> On 1/10/2023 5:23 PM, Paulo Alcantara wrote:
>>> Users have reported the following error on every 600 seconds
>>> (SMB_INTERFACE_POLL_INTERVAL) when mounting SMB1 shares:
>>>
>>> 	CIFS: VFS: \\srv\share error -5 on ioctl to get interface list
>>>
>>> It's supported only by SMB2+, so do not query network interfaces on
>>> SMB1 mounts.
>>>
>>> Fixes: 6e1c1c08cdf3 ("cifs: periodically query network interfaces from server")
>>> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>>> Signed-off-by: Steve French <stfrench@microsoft.com>
>>> ---
>>> v1 -> v2:
>>> 	remove cifs_tcon::iface_query_poll and then check version and
>>> 	server's capability multichannel
>>>
>>>    fs/cifs/connect.c | 9 ++++++---
>>>    1 file changed, 6 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>>> index d371259d6808..b2a04b4e89a5 100644
>>> --- a/fs/cifs/connect.c
>>> +++ b/fs/cifs/connect.c
>>> @@ -2606,11 +2606,14 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
>>>    	INIT_LIST_HEAD(&tcon->pending_opens);
>>>    	tcon->status = TID_GOOD;
>>>    -	/* schedule query interfaces poll */
>>>    	INIT_DELAYED_WORK(&tcon->query_interfaces,
>>>    			  smb2_query_server_interfaces);
>>> -	queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
>>> -			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
>>> +	if (ses->server->dialect >= SMB30_PROT_ID &&
>>
>> The dialect test is actually unnecessary, because the server
>> global capability, indicating the support, is what's important.
>> But it's harmless to be explicit, so..
> 
> The dialect test is still necessary, otherwise we'd end up mixing SMB2_GLOBAL_CAP_MULTI_CHANNEL with CAP_LARGE_FILES[1] and then scheduling the worker for smb1 mounts.

Oh, yuck.

OK.

> I quickly tested it and the global cap test passed for smb1 mount due to CAP_LARGE_FILES being set.
> 
> [1] https://git.cjr.nz/linux.git/tree/fs/cifs/cifspdu.h#n533
> 
> 
>>
>> Reviewed-by: Tom Talpey <tom@talpey.com>
>>
>> LGTM.
>>
>>> +	    (ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
>>> +		/* schedule query interfaces poll */
>>> +		queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
>>> +				   (SMB_INTERFACE_POLL_INTERVAL * HZ));
>>> +	}
>>>      	spin_lock(&cifs_tcp_ses_lock);
>>>    	list_add(&tcon->tcon_list, &ses->tcon_list);
> 
> 
