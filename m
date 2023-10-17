Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B78FCDB483
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Oct 2023 14:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344025AbjJQOHG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Oct 2023 10:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343900AbjJQOHB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Oct 2023 10:07:01 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594B1F0
        for <linux-cifs@vger.kernel.org>; Tue, 17 Oct 2023 07:06:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQhCTd1AiT6BvELyUWX3826qOA81fjhQ/y32xX48ppogCFEY0VsuFHJBBmpERHRzElydN2QZneBINdPSD4J3me9gEJUEHn8gWx3giRiR22sQXIAHZ0LqxBCXD6gUAB4biJNaeXO9QYJgVGCxnFScT638FrzX4EscxyBgaC/mXaM4AWNmRIW8nRH1AngYNXuDBLaNioaokt7+tbiWWhN1Vi3FLBxQ++z6WmOAJd46z5vkhUkLrajuOk7U24Zy5nMMRiJJFas42cqGwkrzpUIgnUxsLM87fzFHNIzZDaZiamjbj+ul3V1HssVqRramb5Rldb1xL3ub3HBWzhFKDbqP2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gkjIryIR7VZWX2jWA0EFB4xavqdLYfKWA6FtVVnSj8w=;
 b=MCoe9KKhkQ5nwh+QAxTJhqb+s9VWh0OQtxzqt83rd3II6fDK7vFNqHcKxvSHl/bEktv1jAvUj3wVth6Vtjr/RnKvck2gIiTWLTI2NIrBvgTjCKZpjPEn3yejrh3oPbxjwnRVGi7CQfz+ZM93HaSJ7GITEJ5wosBimjWJtQPUOPom6twyQdeSsKbGwjwbA1Ha5jXHRi+stRhawcGGMVeBzOpwbUq5dB2LPvP7n8stSwHsdqw93anAjBbdysjc5dpMRTCuU0q7OJ3tHRJ5Yb2UxENPU4suxLzx37T9YYXwkXPuENYm60NIf20ZtRrEYSkx4oDJjvAl9QylmfsN85VpQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SJ2PR01MB8634.prod.exchangelabs.com (2603:10b6:a03:574::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6863.40; Tue, 17 Oct 2023 14:06:53 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::28cd:b4e1:d64b:7160]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::28cd:b4e1:d64b:7160%4]) with mapi id 15.20.6907.021; Tue, 17 Oct 2023
 14:06:53 +0000
Message-ID: <11e5bc36-677d-474d-acae-ab7e6ade9b2b@talpey.com>
Date:   Tue, 17 Oct 2023 10:06:48 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksmbd: fix missing RDMA-capable flag for IPoIB device in
 ksmbd_rdma_capable_netdev()
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org,
        atteh.mailbox@gmail.com, Kangjing Huang <huangkangjing@gmail.com>
References: <20231015144536.9100-1-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20231015144536.9100-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0315.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::20) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SJ2PR01MB8634:EE_
X-MS-Office365-Filtering-Correlation-Id: 29e3b8e7-a47b-41d7-ddd2-08dbcf1a509e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RN7rJBaKsV3KDPRM2Ub1WIudLB6Mj7QYKvlfUaCatlx3k9omq3n3C+viiLTyc7bSE6ae6wUzLhRJfhN8ImR5e6+yVRSQ078v4Nkp7MhzYluKNEcF3GQ1TqRUs5yKI+ruTQIAfykhAdWCQk1t3cVxcVfrhgBu1EPQ4iqH1EpSSipXSpNhWEkkDL4557ng4SKL1hJBhTn/yvlyI37/YjJzGlI/GPXKZ8UwfRHCqk/o4qs5sZRjGZIXC7/nGatgbPd5+2dyJujfAQNNaLpT/sHJxT8c9BwMhMB4/hsg2+ND5bNlZHpOUSydC2BylTfLRpOU4pOYl6eQ1B8DmmS9Xoj43FK8Vuf8Au5BHdg2d5jgKVe/bhD7tYdwka1+ovkJNSjZ4vnc4vrYO/k3N6h8lK6X3xETB48YIP6lQLoUPrk6suCXKGGTVZ7G8Ze2T+Z+d5SKUDpZLbQaluNo78GZ+IOqJi9R+ascpj+EwTwzBiDKuL9qhxR5wokOmVS4ZNGtcASilVmZGmoc1LDR0/3v1bu8CXYWBUAF47xFt0RiutV+b4rnOjqSW5qRmcbLtdJM9ADclqWk50POUm1RzCbuU7xvk8erwFhMdo8WsKgeUkurgkGC6riDScOrrvLpcflFyisu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(396003)(39830400003)(136003)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(31686004)(6486002)(6512007)(53546011)(478600001)(6506007)(86362001)(38100700002)(83380400001)(2616005)(36756003)(31696002)(26005)(6666004)(8676002)(66556008)(8936002)(2906002)(41300700001)(316002)(5660300002)(4326008)(66476007)(66946007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXd1d0Y4MHdvT2RFVnQ1MHJ1b1dsSmpvcnNCZDUxaWNlbHZjRXVjOW9hMnpq?=
 =?utf-8?B?cVZFOHBOaWFpc212anZoS25YeVMxWEcxdWpLWTU0My9XbjZpZFhaSWM5Qjgw?=
 =?utf-8?B?QnkreGJJSklTSHNWMk9vS2kxTWF6bnd0a3NaVm5HTksreWtZTVdQTlBSRUVy?=
 =?utf-8?B?N3NZclRPYmZ2QzljaW1UbTdkZWJXSkRBQnJydHB3eWMwZlFRTDh3aGVtcjFC?=
 =?utf-8?B?NEFWMjNuQjc5cUZXWENHRmJBYUVpZkFabjBISHBjR0xPQ0FIQWN4TWd4eFQz?=
 =?utf-8?B?TSsrelNYNlRpWEI0cXJzdmoxVlJsemxGRmF3YjdRSkFGY3NNRW9QSTduU1Rv?=
 =?utf-8?B?V1kxdXZ2NVJnazNTb3FxdVB0LzB1K0JkRCtqV1BUWTFoWSs5ckFIcXpldmJG?=
 =?utf-8?B?VUdDVlprL3BJUWU4d2tVNUtuZENpQU1BaVpTRTlWUUdXR0k5UFp1RnlIUmR0?=
 =?utf-8?B?c2xNclJhNEx6SVFiN0VuY3FQOGhOa01wNFp2SDg2ZW1VS0xtYmd1WUR1WVZ4?=
 =?utf-8?B?ZndsT2o4L01YdjhqaFE0WEp6enFuTnNSc1BkSjhVcEhBanl5TjNWVmJWU3hW?=
 =?utf-8?B?QnNiQUhkTC9TeWVzQktkV2ZsVFVPdVFEbmkzY280aVY3SklDSXhVUlFwVzJa?=
 =?utf-8?B?R0hVNDJQd3dOUkN5Q2lQOXBSRWJiaUNQZUVLWW13OXk1VzF2SzVvdVZ1QXlI?=
 =?utf-8?B?Zy96ZGppS0xSLzkrekJsYXRrcEdOQ00xcnZEZ2hNSmRucXZ3eXVNZ1FCcU1K?=
 =?utf-8?B?dE0vV0tSVDVETTFMeTk0V1o4Y3V4QWpxWVhIdjNMcE5RUnNTb2xHaE9NSnVq?=
 =?utf-8?B?cVlUYXZCSEVxVFlRUUpTQ2QxNzBCaTRXYVdQV29yMHlaVWFha01OUUpQMzZz?=
 =?utf-8?B?dEJvUjA1SnVyb2M1Mi9rNWpYR3NLMkgzNXpnTHVDS05aTXBlaGlMaktWbzdl?=
 =?utf-8?B?dGpkNjZQSDIvWSt2NUVCVFZuR3RLQ0lDUDJRcHlzdngxN0t6ZkFrbERPYytN?=
 =?utf-8?B?YnJVaUNUOXZxUkxpWXFxaDQwNW1peWl2c281OWdHRWhiblcvaXJRWWRNK0dy?=
 =?utf-8?B?czVPbDI2RVl4eUEvSzNocnpQSXU1SlNHS2hSbGZudEV3T2dHVUt3dDUwUGVW?=
 =?utf-8?B?cmhuZ1I5UGIvOENWNmpTMGE1VWpmaXN4OWJaQzlkSFExYmRHOVNKODlzNXhP?=
 =?utf-8?B?d2I0Mmo5ZFJwTlkwUEgvdW5NTHlOcklsUkYzSDhlaFdYRlpwWjhrVGd2NGNW?=
 =?utf-8?B?elg0OTRXdzc4Ti9QeTQySnFyY0I2QnZRaVgrVlFBNytVVlZGMmgvTTJGUjM4?=
 =?utf-8?B?STh5ZlNYeENta1I1ZXR4VEpvc1hyKythSzRiaVRteU1uRzNWL2RrRnE5MjJM?=
 =?utf-8?B?YzkrY1IrM2owS1QvRWNyV1B6SmZvQ09rUkQ1QXF5Slh1Z2wwM05sanE0YjMv?=
 =?utf-8?B?bmJwcjMzNExKZU05YkJ4UWsya2JwSTZlby9mazVGZ1dTb3EvTW9NWnpTdDNp?=
 =?utf-8?B?Ulgwd1VkRTQvU1BRVzREZ2NIZXBZak9NTWlnVTdhZGJiUmVUU0JSclVVYjdi?=
 =?utf-8?B?dEZzMnIxS3JiaHFHMys0RjhNVDBHbTBIL3NkRVVzLzdpUXRHSHdsMmZxZk8w?=
 =?utf-8?B?SW84ekJ2WnRvOHIxczFPMWlieE5oUlZUMjdWZUZMRWVwKzlubWd0UklaWi9q?=
 =?utf-8?B?TXZLQ3dFaytPb0ZTQ1p6OCt2RDc1Y0NydXB0akd4eThzakcyRStSQW5hNVk0?=
 =?utf-8?B?Tzk3VnNQbTAxTno3dkdXTkJuUldQTTNaS1ZUNFVQR05tTzlSQnVGVEE3azhI?=
 =?utf-8?B?cUcydzI0YXh6dzZTYTBCMGpFSU5taDc3QUFQanhxaExYUEl1Yk1HbTNGVmR5?=
 =?utf-8?B?S2pBY3MyTWlKemxkKy9EK1FTQWdibldMcSsxSnpFZmpNN3JhNG9nWStGSk0z?=
 =?utf-8?B?WXliZW9WY041emZkVDJUamJWZUs0WnppTHVLdy95TDVlS0VHdXZBaVp0bHJQ?=
 =?utf-8?B?T0J4aVcvekRnRDIzSDVlYlZlclVWZCtIdng1cFRuNDYwdjd3ZTRDZVNDa0hF?=
 =?utf-8?B?STFlbmVXUHZXZXJCZHNyZHRaeEo3TlByMWNpWG4xOEtaS3Y2cEg2SVZTUlRC?=
 =?utf-8?Q?qy9Mh2fxQFjVyCBgOiz3CtiUp?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29e3b8e7-a47b-41d7-ddd2-08dbcf1a509e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 14:06:53.3775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xRBi/DAYRlXxnPClA9DyPa/Di2uIGak2MWSHIOH1mlq2IMk386tTD+7zjWgfhZI9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR01MB8634
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/15/2023 10:45 AM, Namjae Jeon wrote:
> From: Kangjing Huang <huangkangjing@gmail.com>
> 
> Physical ib_device does not have an underlying net_device, thus its
> association with IPoIB net_device cannot be retrieved via
> ops.get_netdev() or ib_device_get_by_netdev(). ksmbd reads physical
> ib_device port GUID from the lower 16 bytes of the hardware addresses on
> IPoIB net_device and match its underlying ib_device using ib_find_gid()
> 
> Signed-off-by: Kangjing Huang <huangkangjing@gmail.com>
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/smb/server/transport_rdma.c | 39 +++++++++++++++++++++++++---------
>   1 file changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
> index 3b269e1f523a..a82131f7dd83 100644
> --- a/fs/smb/server/transport_rdma.c
> +++ b/fs/smb/server/transport_rdma.c
> @@ -2140,8 +2140,7 @@ static int smb_direct_ib_client_add(struct ib_device *ib_dev)
>   	if (ib_dev->node_type != RDMA_NODE_IB_CA)
>   		smb_direct_port = SMB_DIRECT_PORT_IWARP;
>   
> -	if (!ib_dev->ops.get_netdev ||
> -	    !rdma_frwr_is_supported(&ib_dev->attrs))
> +	if (!rdma_frwr_is_supported(&ib_dev->attrs))
>   		return 0;
>   
>   	smb_dev = kzalloc(sizeof(*smb_dev), GFP_KERNEL);
> @@ -2241,17 +2240,37 @@ bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
>   		for (i = 0; i < smb_dev->ib_dev->phys_port_cnt; i++) {
>   			struct net_device *ndev;
>   
> -			ndev = smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
> -							       i + 1);
> -			if (!ndev)
> -				continue;
> +			/* RoCE and iWRAP ib_dev is backed by a netdev */
> +			if (smb_dev->ib_dev->ops.get_netdev) {

The "IWRAP" is a typo, but IMO the comment is misleading. This is simply
looking up the target netdev, it's not limited to these two rdma types.
I suggest deleting the comment.

> +				ndev = smb_dev->ib_dev->ops.get_netdev(
> +					smb_dev->ib_dev, i + 1);
> +				if (!ndev)
> +					continue;
>   
> -			if (ndev == netdev) {
> +				if (ndev == netdev) {
> +					dev_put(ndev);
> +					rdma_capable = true;
> +					goto out;
> +				}
>   				dev_put(ndev);

Why not move this dev_put up above the if (ndev == netdev) test? It's
needed in both cases, so it's confusing to have two copies.

> -				rdma_capable = true;
> -				goto out;
> +			/* match physical ib_dev with IPoIB netdev by GUID */

Add more information to this comment, perhaps:

   /* if no exact netdev match, check for matching Infiniband GUID */

> +			} else if (netdev->type == ARPHRD_INFINIBAND) {
> +				struct netdev_hw_addr *ha;
> +				union ib_gid gid;
> +				u32 port_num;
> +				int ret;
> +
> +				netdev_hw_addr_list_for_each(
> +					ha, &netdev->dev_addrs) {
> +					memcpy(&gid, ha->addr + 4, sizeof(gid));
> +					ret = ib_find_gid(smb_dev->ib_dev, &gid,
> +							  &port_num, NULL);
> +					if (!ret) {
> +						rdma_capable = true;
> +						goto out;

Won't this leak the ndev? It needs a dev_put(ndev) before breaking
the loop, too, right?

> +					}
> +				}
>   			}
> -			dev_put(ndev);
>   		}
>   	}
>   out:
