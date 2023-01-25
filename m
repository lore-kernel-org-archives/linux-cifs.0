Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C199C27C76
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Jan 2023 14:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235714AbjAYOrw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Jan 2023 09:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235741AbjAYOrn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Jan 2023 09:47:43 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F09182
        for <linux-cifs@vger.kernel.org>; Wed, 25 Jan 2023 06:47:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kR69uhvoR5yFgfxj72t2aL6QATXI3zawiYEGQq8vsxe5R7vZgSbIaAdfA96OMwM2VJy1cICYB/B+WwlZT5jA4zav8DwwA3xIF6fTBu5OD3RPz+dy4fve/VSRv259SmxwXQAo39Ec/pwYs3xRfGQ4faCcSuQONSrolptz9TPNq8ewyj6OC6nnw65BFp3Qv1/1KqHUh5eEgMObgz1+eVSSCvofKtfRKhrB4u8mnqXw+Cm59SQpok0UZVOS5UnaJF079l8u72+xTpIqXEwWBJ1/miZiWc7QpCofb3XAOZLVcfUjA6DrUd5slw63E4UxcUOtzqshnFmQ62uRyNH92JP6Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gqUuwk/rUwmzk9TRUcVLRqRXjrFewVDR4QYpD0EX7UI=;
 b=O5MjtCTR4wMn5QXOvhATLWxIrxlq4MShEGgX/Ko62Ckh0pkmrMof3c6ZKPFS3iC8CjdFSZDFSEOrw3II40fRTor0MC1LPe7OHLQabeGIBBUXHLA814iZnYQjx8xY1i1JkSJqVTcMD2sEZ+c0tdfebt+SbT9cD0Y3kYRZxtlGpH6LUegproYQyuZ1xXGdpsSYWheP4jkxZy9sakj2+YM7BgeZ9CDoQNl3dm9bSHpcGAiLuYmckcF5SlpEiD4019Q76FYBQk9JzFBZoVi1L6Y+0PCD0olRQFUV38tk89XW+zs0LWr6dMH2GPV9mFJdbkzzoFXKHf2cBSIMdQkebw5Aaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN6PR01MB5245.prod.exchangelabs.com (2603:10b6:805:ce::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.33; Wed, 25 Jan 2023 14:47:38 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5%7]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 14:47:38 +0000
Message-ID: <0d4d0b2f-bb2b-a69b-2009-8c883119c10d@talpey.com>
Date:   Wed, 25 Jan 2023 09:47:37 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] cifs: Fix oops due to uncleared server->smbd_conn in
 reconnect
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>,
        Steve French <sfrench@samba.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org
References: <1130899.1674582538@warthog.procyon.org.uk>
 <2132364.1674655333@warthog.procyon.org.uk>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <2132364.1674655333@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR08CA0026.namprd08.prod.outlook.com
 (2603:10b6:208:239::31) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SN6PR01MB5245:EE_
X-MS-Office365-Filtering-Correlation-Id: e535b4bf-3aa2-40b8-3cb4-08dafee31a92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bbAhHUpsdHoy4Ak6RCT4h0MN0aZcNTT5R2VoPiGDUDOIj/ClSL2MnbMdSTDUPQrLXpeeYBZaxm5JMZ92YxoTthYrssi9VJbwPtJNkADajFR5xfF0VB0wIx+SDAsHeE8+S/VgdOjvVxMVeJha49Snnd+XbW0z/LTfi+dyrn8dNyxmq6uQc9/xBdkLN9672IGTBWY8U8V97Nc6Z1R4tGdgxqZg++C1iPMwgJPY8PsLf5ZGOLg7OQo7qY+ZUasRfvz8FxiPGC7szW0B3gZbwwgsXMwVUawYL4rFsJPXnhBSRmu2/4dm/kKWzG7mAV0H0pldVyYJL6LOIsGFyLRtUGfpvicCGDA/q/kPm5pkEXs2GdhyjOaRCk4hMS6kPs20ru68hD/piHh2Czi9X2U9BlaqBx88gXV7Gq/PfRftta/oQxdORabi+JOcO+lBKejYtO+hyBqxeYbEnXkEwS+wvkyRwt/jd7jKUDPuhQDdlBAmlm1cVoqecb+lWaf1J5Bc6DF2ibBqvqySwOIYDA4LAosZAw6fMcDpw+bZqge4py8RKwSzoRBSUi2Qp4WJ0RW5WBXBQhlyN19ZCxldIPyJ+FaA4Y+C5JqiEGJCY5nRaV2QOvBm1tCUdXJDLXgmLUxLKKDrdBpEJ/U+XafEey0beFSiArxDShXQbQPblFdAa64kFSyAnV/G2zHg/O8kFxezycplRg+kqcX2dhmohgVgUnVwrq62qmDuolTFa8KCCHEON90=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(376002)(39830400003)(366004)(396003)(451199018)(38100700002)(38350700002)(83380400001)(53546011)(66556008)(2616005)(54906003)(478600001)(8676002)(186003)(66476007)(31686004)(31696002)(45080400002)(36756003)(6486002)(110136005)(66946007)(52116002)(2906002)(86362001)(41300700001)(26005)(5660300002)(316002)(6506007)(6512007)(8936002)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0lVeGt5dTRkbkpUM1hvVWFxNFlvL1lnUlRqVVdKTUdZME9ZbVZweDU0K3hi?=
 =?utf-8?B?T084VVQxNzA5UEJOSnlVV0F1dWZEOXBSeStNSTZWaWxWcHZjYmZVZHZINHBS?=
 =?utf-8?B?aHBVdHpZZEgrWk42akN4alNmUklHeXJJSHJycHJNQzdvM2hRMHQvZFc5VDZi?=
 =?utf-8?B?eERGZmlITitLMHRHeldONnQ4TjVnUWFOZmlSd242N1ZXWUFxanc2cUR0NDdo?=
 =?utf-8?B?dDVpdkZmVmNqakg5cUxpVkVKNS8rZWlZck5LeXFGWnBWVVN5cGZKVEtZQzJC?=
 =?utf-8?B?S1hRRmZDc2owTkxuckFzVnE2WGNiZjliZmt6aXpnZURGVVQ3bGYrSEtycDlH?=
 =?utf-8?B?VFlmaDcyUFBNTnN6N1NFWHFsdnFwYWVRQm5oS2FyVmp2UHY5eVRLbXNqUlVL?=
 =?utf-8?B?a1JtRHpvcllkRzdMc3JCL0Y3Ym5MdXY1MVNFSThMajdvano0UDdFVHpWNXYv?=
 =?utf-8?B?dHlvbkI3NCtLSytUbzhaam1wOVY0MlNQc0JvWjdvNXZRQm5wUFF3OG9Fc1cx?=
 =?utf-8?B?Z2JjZlZ2eFl4YXkyd05yUFBVVVF5OG83dUdqUWFab3drOUtKZlc4ZFJYWEsz?=
 =?utf-8?B?cFRCY2tmbnBMaG9iSjJPSlVHRXU5VEVubGNMeHNwVkVoRDloc1RCekRjRkhI?=
 =?utf-8?B?SVhwbk8rSzhRWTJ2MUZsa3l6ME5iNG1zMkpnaUtlZ3dOSVV1MGxDa25WVldT?=
 =?utf-8?B?RnpPV0JUaDJFQWM2Ym9FWmMrVDVqaG16bUJDWW1WdnpIN2I4emg0dXlLM2d1?=
 =?utf-8?B?MlJZbEg0S1kzQTF4eFFzdFF4Qm5jc0kyT3hhVmV6LytocjZCYktxeWlwQ1Er?=
 =?utf-8?B?RTMzZmhzK2pBZjhFYkZCN04wdjJPbStuTVVmUXdwWXJaeWNvb2F6Q1NIK1oz?=
 =?utf-8?B?VHVZdDk4TnA1OFNsd0VOWWU1ZURpUXF0V3VmOFFyTzAzQnNocDllT1FhRW5N?=
 =?utf-8?B?VlMyeTZJODNsS0JhMHNwRVF3a1libURkT3MzK0dQOEJNdnNpZk91bHJsWjR5?=
 =?utf-8?B?eHFWZXJqVDdxVTFXeTBaL3hBK0lUMTNmbDlkSXFXUzdjeDBnbW9VaTA0Ujd0?=
 =?utf-8?B?QitLdG5SSWVCWEw5K2F6ZHhNQThGeXdxMkMzb3I5aHpBU0V2bk1rTlFCN2JG?=
 =?utf-8?B?RGI3dGJJdm1PdE96OGdOTjF4UmdkYzQ4MVFueHJ2RkVHK3pwbjRpTGw2T3No?=
 =?utf-8?B?bEIyaW5wcjhNOTJjQ0tnM3ZPR1V2YlVaNkgrU2NmU2VWS2lUSnF2SEloMnhR?=
 =?utf-8?B?TjUyNU9PREVOMStoSzFMM00rYWJKMGk3TU9uL2l6ZlZMN3RhS1JJc3RBMXRn?=
 =?utf-8?B?RWZzbjdiN21saGdhbVQ5bWppL1B4OXRiTEJmTC81NnpjN29QOCtrd2pUNFZI?=
 =?utf-8?B?VHRMV2NVOHgvVzR0dHc0bHJOdUE0SHFHbG16NURxcUloY0x4S1VCejdac2VL?=
 =?utf-8?B?ZXU4MW93RlA2SDJLL05Fc3k0Vk9id0p3SzhCbTd2dzBDVGJWN0pVZEYwRTJF?=
 =?utf-8?B?cjlHYk1tclg2VEZSNGpsZVJHekllUFBnazFqa2M3SlNORk5VQnU0aCtjekJi?=
 =?utf-8?B?ZUZvSlF1L1grVlhoanhsNmlwelFXWWlUdDh4RjNaUFkzK1puRUJVRkpUTTJY?=
 =?utf-8?B?c2kvNk9UcjlDM0JHc1JRdmEyVmFTS1JWcnpBOXBHTTVESEdEZFBPNFJ4S21N?=
 =?utf-8?B?TFdrOTN4dTRDRnkvM1F4U2JjUW1KcDNsVW1XbzNybHBaODRuOXhUeGZEVFF5?=
 =?utf-8?B?MGhmN1ZYWmwybm1PaWF3Z0tidlZKV0YyVWdwM3dLaEhiZW03TDNtMmMrOFFI?=
 =?utf-8?B?ck9RZllIRndLN3NNNjhubHdSSzJvU01RZHJ4VFE1eXFUSmxtQjNza0RPc0d5?=
 =?utf-8?B?dm9HR3UydnJGcUFiR1hBOERMSnVpV001YmdQQlk1OHkvemdhcnIrOXJtN0Va?=
 =?utf-8?B?ak5jaFhoTkxkcmJjVjBSTFhrbllvYWUrOFU0RnduTHA3eEdHYVpNd3BHQ2gx?=
 =?utf-8?B?YVF6NnI4NWZndXdxcWxDWkdWQWtqRU9vc3Bjd3pyOHFYUTV4My9OVmp1bVhO?=
 =?utf-8?B?UG1xMlM0QVNTWDVFVjEveU85bFFHT3lOUkF6YjlPMjBCMVNadVAyVnVwVlA5?=
 =?utf-8?Q?UWg+uR118Li2x/6H1YoiC2W+I?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e535b4bf-3aa2-40b8-3cb4-08dafee31a92
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 14:47:38.4731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cw70i47/fXZZfxhz/xp8q7meVwq+aa2MFbG5tALM72Q7CLyhT2ZrdvedP+tTdlj7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB5245
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 1/25/2023 9:02 AM, David Howells wrote:
> Hi Steve,
> 
> That attached patch stops the kernel from oopsing, but it still tries
> endlessly to send with softRoCE.  I'm having better luck with softIWarp - with
> some other patches, I can run generic/001 to completion with that transport.

Do you have any logging from the softRoCE runs? I'd suspect some
kind of RDMA-specific scatter/gather overflow which might be
server-side as easily as client-side.

On client, try:
   echo 0x1ff >/sys/module/cifs/parameters/smbd_logging_class

On server:
    ksmbd.control -d conn
    ksmbd.control -d rdma

> ---
> commit 820cb3802c6a73c54e2e215b674eb5870fd5d0e5
> Author: David Howells <dhowells@redhat.com>
> Date:   Wed Jan 25 12:42:07 2023 +0000
> 
>      cifs: Fix oops due to uncleared server->smbd_conn in reconnect
>      
>      In smbd_destroy(), clear the server->smbd_conn pointer after freeing the
>      smbd_connection struct that it points to so that reconnection doesn't get
>      confused.
>      
>      Fixes: 8ef130f9ec27 ("CIFS: SMBD: Implement function to destroy a SMB Direct connection")
>      Signed-off-by: David Howells <dhowells@redhat.com>
>      cc: Long Li <longli@microsoft.com>
>      cc: Steve French <smfrench@gmail.com>
>      cc: Pavel Shilovsky <pshilov@microsoft.com>
>      cc: Ronnie Sahlberg <lsahlber@redhat.com>
>      cc: linux-cifs@vger.kernel.org
> 
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index 90789aaa6567..8c816b25ce7c 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -1405,6 +1405,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
>   	destroy_workqueue(info->workqueue);
>   	log_rdma_event(INFO,  "rdma session destroyed\n");
>   	kfree(info);
> +	server->smbd_conn = NULL;
>   }
>   
>   /*
> 
> 
