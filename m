Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2727EC001DF
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Oct 2023 20:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjJTU1i (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 Oct 2023 16:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbjJTU1f (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 Oct 2023 16:27:35 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA87510C3
        for <linux-cifs@vger.kernel.org>; Fri, 20 Oct 2023 13:27:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qs+/bxU1Tx6bNJo7Q3gEUXoVDE21MegW61ryNiaAOgJV8wXo3s969MRkd0ElSvy68i28Y6ffvb465G97JS96/uujQH4YwRWYAv6ZeMgQlAgzCCz5IwlFF/orOs/g2xWPvz9puPdesLzPxO2k2P5aO3aGO7BtoN84cM0NKtzoaArSDzxj0yqx6PViDSBrUSPPbRl7FdWDYgkZb2yaCrML7ebPIBC9nhBNIIOPnVVx3QCw2BIQkksd/ebZ8vWFjvq9MMLLGgj7bcFMtKqTvkyBo8LKL25hnU/kE1gdVSMP6yw9u2Mw0l//ehiqDD8dGPh5D0rwmithgyCmpL59gdwkVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VkcNh2NDd64S91jltnwERK3STrQ+GxeahQ2oZ8c3vxk=;
 b=QEuoUC51jCyxoP4nadB4Z21Mb4B4HQllElIXadfID07GPY/+UPPOoNx6pTeL2szYaOg4kp8LZPo0ifsFqH4u3374lJ0+acrhYg3s8sHVGmJpU5+YbWgFJr5C/FMKsgH8We0mjtzTqrFOYG20m1O1xHZDLeWr4Jn3T7WoKcoTbyWsmBLlP9aEkd8/UZ/yvgYUrWiMX8UdyLcY17Z8/v8dCmbKFbDyc7vp+Z8R7Cu7pCq4W0WNgG+VW/3t3Fff+dHuGlStouEvyYGV/v07ADH8bmOXnDsO/6vrQQ2zlur0xm/ZJFmwzVLSje4SNk1craNNZ03r3BAfNVnpXmeiKpNj0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL3PR01MB7179.prod.exchangelabs.com (2603:10b6:208:346::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.26; Fri, 20 Oct 2023 20:27:27 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::28cd:b4e1:d64b:7160]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::28cd:b4e1:d64b:7160%4]) with mapi id 15.20.6907.021; Fri, 20 Oct 2023
 20:27:27 +0000
Message-ID: <05cca6e5-350c-422c-abae-81f2855cf73a@talpey.com>
Date:   Fri, 20 Oct 2023 16:27:24 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ksmbd: fix missing RDMA-capable flag for IPoIB device
 in ksmbd_rdma_capable_netdev()
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>,
        "Kangjing \"Chaser\" Huang" <huangkangjing@gmail.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com
References: <6d41a4df-e0ab-47e5-a476-f5b6620bfe8d@gmail.com>
 <CAKYAXd8tPdomxriZbLMVOyG6f-mb+cfWb4HPGrywGvOZhnbD6A@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd8tPdomxriZbLMVOyG6f-mb+cfWb4HPGrywGvOZhnbD6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0329.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::34) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BL3PR01MB7179:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e7283e2-c1f8-47af-26ce-08dbd1aaf9c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pfaIdquwFeSWNRKeF2KFsnPnlTr68ogSv9mBK6i+bwwVRSLj9sMJobORKp2JU3vYr9yFh4vr1X3Qb78Bai29SPsctuTxu/iBgrcSeRyvpr+zWym0L25LsdXsyZQ4Tm4pw1iekLFArDk5IPQl0p50/LIdX/MpKD+nkZfwpt5j4mKzUE9ABhmEs2T7gegNWv1UE+Cp5CLIU6/skdAUyHtlNSaEnxhc9vGcpoMi2tDOvHd7zUnvqTqrDg1fDyGcLa2+LR4YvIEApc13JJ7aaOjT423jadb6UXOKz4MOWOVLuBT1FPgAyVmhdZ30Z0rAvwwtd30TqhK1i7Cw6sTqKkSaEqg34MYZz0sDcvrMRekMIel4kegMMTHgoOHB/3re2DLSi22MYtWmmaTED6M19F11k3ZrEdH6GeYQDedBiI/Swl4HweBz2ppoUMojSy0POht8NQIinMoickOjMEBjKFG2fMWq2+pYLBAdVYDTZ/ER7lRcZqARS5rUwVck8B0vtVxe+JcQzJ5+E9r59O6vbFJ+hxzebiIFPiheSbMFeouXoFpu9ftyN5TCBFO+SaPDY0e0ZE8WeCTEUQnP0yrozdHTjpEDMjgL6p1VlYtazoPW6xloJFcjRfxI63iNmyvHx7Io
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(366004)(39830400003)(346002)(136003)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(8936002)(8676002)(41300700001)(4326008)(5660300002)(316002)(36756003)(31696002)(86362001)(38100700002)(31686004)(83380400001)(110136005)(6506007)(6512007)(6666004)(66556008)(66476007)(66946007)(478600001)(6486002)(4001150100001)(2906002)(26005)(2616005)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NU5KQldNTEZnRkpQejlwZkY4NUNsQkJUU0tPeFFPbmJBUTF4MCtmT3lrN0Jl?=
 =?utf-8?B?YjBzZkZxUTRaZ2cxd2lhdmtwTUN6cVRaZERYeitZUnZXY29BdHdpRzdtcG9l?=
 =?utf-8?B?VGg2eGx5SFNpenVhejdiT0NTdzJ2TTNQNVZHd2YycDFJSGpzZkhLYmxrTGVj?=
 =?utf-8?B?OGFsZXdWM1dFb055clJBTVVNeFZNOFFKMzVoZWthY0dqYklFcnpRNFdtNkpj?=
 =?utf-8?B?MDkwWEpITDNUNGJ0ZkRYbkFPMTZtWGtXci95WUtWeEt1WmpCVE11Y3ZXdlRD?=
 =?utf-8?B?Y2N2aUVNU3huNElkM2JYdm5FTm02UFlSWnNQVEN0Y0VpdmdJWmtXdFFmMHlI?=
 =?utf-8?B?dDZxdXNPakQyczJkQ3pOb2Fqc3BHSkhJUTlmd3JGOFNnR2txNzZaZ3E2Y1Iv?=
 =?utf-8?B?ZW5LTDJZM09Sbmo5QmJzdWd0aVFBUUhiallVb3YvSENFVis1Z0cvWnQ4VFM1?=
 =?utf-8?B?RzlmVlMwOWY5WTMxa1pxU2xnd2tMNmtDV0RPSzN6OWJoa2p6MEhhOU1GSVhh?=
 =?utf-8?B?ZUZiQktFLzB4T05FTXVPVUhBbHFNTUJzcXZOY3FzaHVOMG92TTlkWjFiL1hE?=
 =?utf-8?B?NENDQkMyT3BYaFFMbnBMenVaQ0pnTC8xN0thYXVtY0ZUS0xJbnNrSXh2SHdW?=
 =?utf-8?B?Szd1RWFmVzNDRkwwQ0tVczBXdG51VFkxQnk5Ykh1US9rVWxzOHl3M0I1UG1P?=
 =?utf-8?B?RThqUjI0TWJHVDlMRisvNXdTUkRDOTRaTHJIS0NLRGZocEtWUytiS2E4dWhm?=
 =?utf-8?B?TXFVOVlsUU1IcHRsZTdxeVM4ZEZIcjE4bFBrdCtURHdkQytKNjhiYjcwUVpj?=
 =?utf-8?B?azBkMGI0dXJjcE1jVVVIcFREYmsxVHhnOG5ZZldHVitzWXNKQ05DOWhiY0d6?=
 =?utf-8?B?ZUFrdFMzNys5SHlVWlp1cGRzaXZDUTNXaEFDV1pRMDlHNnYrY1JXQlFaS3ha?=
 =?utf-8?B?VFpmcFdFVWxxTldEUjBUVDVTV0xxMGxraFZPVG9sc0dGQlB6OEI3SGFYd0FD?=
 =?utf-8?B?QnFlTVlhM2l4ZUVyRGlEZmdhYXd3Z0RzcWNXQVcrL0ZtSFhmMjcxazRheHpK?=
 =?utf-8?B?dXF6empmdUpKVHdtRnduczAyOXBycTlzcFIzWU82SnpOd2YzMnlxUXJ4T2pX?=
 =?utf-8?B?RTlBTVVvWHA5QXhiQnNTVHhJVUtISUViVnlXQ1EzS05Vc3k4WmVra1BIMlNF?=
 =?utf-8?B?c0xpTG5HYytJTDBtcjlUZ1ArSGVTamw1NmNrNm1XaFl1b1dlQUR0aFdycEJN?=
 =?utf-8?B?NGtENURMdkorTy9XeTVBUTQvVVBZS1B3QnNTb2J0dStmajIxZVYyR1VVdEQr?=
 =?utf-8?B?Zmt1bkRnMmJYODE4RFlOdER6THVjQnN1RGhRZXhjREhGZTlBdmsrM09mSVNX?=
 =?utf-8?B?SkRhak9aRE9uT1VobHJ4bU5zSUV6NHpzUC9yd21aVTZ4YmVhTW5ENG85UVJI?=
 =?utf-8?B?UE15Z09nWEo0SXFQSXRMN2cxaVlqc2E0K3FHNTMvQ2wxcndVelpzd25JYzZj?=
 =?utf-8?B?QWtqQVJraXJtUGNVYmhTOEZZSGtNbGN6cGJkQjBkUWlYZFFPdmwyWEdSdFFF?=
 =?utf-8?B?S0lFYW5DRE5vQ1VQL3RqbDg2dHhheGpBUmhWa1RnMUM0Q01TcFpFQU1COW5h?=
 =?utf-8?B?YkhEWm9YcTE1NExUdGdGUDdDS1RSTTN3T1JBazBEMG9Na1pmWnJoWXlRVmZv?=
 =?utf-8?B?YkdMamw2Wm5Da2s5RUthVzBCWlFZTU4wVXVVazRpbDMxVDcyVlZ1a1FVK09s?=
 =?utf-8?B?ZmhwdTJINUREem42Y1NpQWY1a1hUNCt1K1A2azBZRGYvbmRFSC9RRlptOHg0?=
 =?utf-8?B?TTE4MWZiZ25JLzdCSUVzOU5jWlFNUFkxZjBjSThtNkNoMk1QYWhRNG5ydVgz?=
 =?utf-8?B?VXlJbWFoVFdTeEo1MzBDbzVDdVc3SG5QcG1LNTZlTHdnYlFSSzhFdVM0aXpj?=
 =?utf-8?B?RjI0ZklNOTdDVlNrVDR4REkzQ25zZm94TDRkck45b2xqSGl2bUFFNjBNZXhT?=
 =?utf-8?B?RFM3V0RkaS9kRDUwRndPTmRDeVNONmlkN2hCVS9CV1VjcXpLR2ovZjZGcFJE?=
 =?utf-8?B?NTFXdzF6cjV3R2lXNERkK1FBMmxScUtjc2NpYnIrWTloMlBXZk4rMWVyc2dO?=
 =?utf-8?Q?sX25DOq7UdUVtT165wsGLZwco?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e7283e2-c1f8-47af-26ce-08dbd1aaf9c2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 20:27:26.9397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A1wb00nVvvwLpJbGyU5EW7bWTzXFeupDlAH8t9vLtWkGT1KA+olvvzawPaZCTSCo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR01MB7179
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/20/2023 10:45 AM, Namjae Jeon wrote:
> 2023-10-20 22:02 GMT+09:00, Kangjing "Chaser" Huang <huangkangjing@gmail.com>:
>> Physical ib_device does not have an underlying net_device, thus its
>> association with IPoIB net_device cannot be retrieved via
>> ops.get_netdev() or ib_device_get_by_netdev(). ksmbd reads physical
>> ib_device port GUID from the lower 16 bytes of the hardware addresses on
>> IPoIB net_device and match its underlying ib_device using ib_find_gid()
>>
>> Signed-off-by: Kangjing Huang <huangkangjing@gmail.com>
>> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> Can you fix the warnings from checkpatch.pl ?  You need to run it like
> this. ./scripts/checkpatch.pl [patch]
> 
> WARNING: Block comments use a trailing */ on a separate line
> #148: FILE: fs/smb/server/transport_rdma.c:2256:
> +			 * check for matching infiniband GUID in hw_addr */
> 
> WARNING: From:/Signed-off-by: email name mismatch: 'From: "Kangjing
> \Chaser\ Huang" <huangkangjing@gmail.com>' != 'Signed-off-by: Kangjing
> Huang <huangkangjing@gmail.com>'
> 
> total: 0 errors, 2 warnings, 54 lines checked
> 
> 
> And have you made this patch on linux 6.6-rc6 kernel ? because I can't
> apply this patch with the following error.
> 
> checking file fs/smb/server/transport_rdma.c
> Hunk #1 FAILED at 2140.
> Hunk #2 FAILED at 2241.
> 2 out of 2 hunks FAILED
> 
> Thanks.

With these glitches addressed, please add my

Reviewed-by: Tom Talpey <tom@talpey.com>

Thanks for the update.

>>
>> v2 -> v1:
>> * Add more detailed description to comment
>> ---
>>    fs/smb/server/transport_rdma.c | 39 +++++++++++++++++++++++++---------
>>    1 file changed, 29 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/smb/server/transport_rdma.c
>> b/fs/smb/server/transport_rdma.c
>> index 3b269e1f523a..a623e29b2760 100644
>> --- a/fs/smb/server/transport_rdma.c
>> +++ b/fs/smb/server/transport_rdma.c
>> @@ -2140,8 +2140,7 @@ static int smb_direct_ib_client_add(struct ib_device
>> *ib_dev)
>>    	if (ib_dev->node_type != RDMA_NODE_IB_CA)
>>    		smb_direct_port = SMB_DIRECT_PORT_IWARP;
>>
>> -	if (!ib_dev->ops.get_netdev ||
>> -	    !rdma_frwr_is_supported(&ib_dev->attrs))
>> +	if (!rdma_frwr_is_supported(&ib_dev->attrs))
>>    		return 0;
>>
>>    	smb_dev = kzalloc(sizeof(*smb_dev), GFP_KERNEL);
>> @@ -2241,17 +2240,37 @@ bool ksmbd_rdma_capable_netdev(struct net_device
>> *netdev)
>>    		for (i = 0; i < smb_dev->ib_dev->phys_port_cnt; i++) {
>>    			struct net_device *ndev;
>>
>> -			ndev = smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
>> -							       i + 1);
>> -			if (!ndev)
>> -				continue;
>> +			if (smb_dev->ib_dev->ops.get_netdev) {
>> +				ndev = smb_dev->ib_dev->ops.get_netdev(
>> +					smb_dev->ib_dev, i + 1);
>> +				if (!ndev)
>> +					continue;
>>
>> -			if (ndev == netdev) {
>> +				if (ndev == netdev) {
>> +					dev_put(ndev);
>> +					rdma_capable = true;
>> +					goto out;
>> +				}
>>    				dev_put(ndev);
>> -				rdma_capable = true;
>> -				goto out;
>> +			/* if ib_dev does not implement ops.get_netdev
>> +			 * check for matching infiniband GUID in hw_addr */
>> +			} else if (netdev->type == ARPHRD_INFINIBAND) {
>> +				struct netdev_hw_addr *ha;
>> +				union ib_gid gid;
>> +				u32 port_num;
>> +				int ret;
>> +
>> +				netdev_hw_addr_list_for_each(
>> +					ha, &netdev->dev_addrs) {
>> +					memcpy(&gid, ha->addr + 4, sizeof(gid));
>> +					ret = ib_find_gid(smb_dev->ib_dev, &gid,
>> +							  &port_num, NULL);
>> +					if (!ret) {
>> +						rdma_capable = true;
>> +						goto out;
>> +					}
>> +				}
>>    			}
>> -			dev_put(ndev);
>>    		}
>>    	}
>>    out:
>> --
>> 2.42.0
>>
>>
> 
