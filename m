Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F219EB64D9
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Jun 2023 19:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjF0ThZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Jun 2023 15:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjF0ThY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Jun 2023 15:37:24 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19C819B0
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jun 2023 12:37:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MTZdX5mwJsNpnmPlsjyPQbEZJQolLzgLhfUyHGgJyzHLi7c1jlgUKIE0CnmbLbUgP1/OXJXsL4mXQUxyo5r1j1aNxqrlzA7QSdveKWC0HOYAH7HCidxwJaclS5Nf43Lb6fPbEksdnEAsIcFU5wLpj3GVCDZaxmwvvgS0tFe7yGH5VPg0Dm7nr0bBwDF5vPeX5geICeirrEb86KfIlgQJTU1yvUNoBRtUdFfpetDa1dGnb+RfavpAHlBOzkw42H4X1+n40qHHp4NHz1yGX6VK6XjwzPPTM1e+JIJ6UKZ924wmfeqXGZ4eagKfQuTMnaw1VdM7jOyqQdb96iMvJEl5Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7hBVe/BSzyrhDJmpjrvkumGfmSOl+GajyeOAD/67PbM=;
 b=dU5WhuH9Z6ffq+46qgOtFSYzyKmbXCQATv9xbYtKPuZ1XfzNqqi/GkkRStlE9k+WxH6LHZ1AJgV2KacNGiWZWYFM/f7yEp8UFVA4EgBOLimegncaBazEhV5sumWlzGAbOqD1bxwLqyAstZDeMVMty6xaj5wCTRjJwM0z03dBko9Epd9TKRY2fzbkMRHj5MeBWhZJnAdqhfHLycySKZLDjcbGzgCLpHbjCOMWg/24tTg3Y0GPcwTAwTjVA9nAqa1sZXUvGpaJri1Ftd+g0zboyFMgikoWi1t3I8XbLqN8DunZZ/Rb6410j70Syz7r8bEqwdq72N+XhweTyYoxrfeTlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 CH3PR01MB8492.prod.exchangelabs.com (2603:10b6:610:19f::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6544.15; Tue, 27 Jun 2023 19:37:15 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc%5]) with mapi id 15.20.6521.023; Tue, 27 Jun 2023
 19:37:14 +0000
Message-ID: <1a8f95fb-9371-0a8a-d510-83f2294d6ee4@talpey.com>
Date:   Tue, 27 Jun 2023 15:37:12 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 6/6] cifs: fix sockaddr comparison in iface_cmp
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        bharathsm.hsk@gmail.com, Shyam Prasad N <sprasad@microsoft.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
References: <20230609174659.60327-1-sprasad@microsoft.com>
 <20230609174659.60327-6-sprasad@microsoft.com>
 <2099a884-2e27-cc43-a293-69de617ab5d7@talpey.com>
 <82239b61-4000-4f57-a7bb-17bbad7dd45f@kadam.mountain>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <82239b61-4000-4f57-a7bb-17bbad7dd45f@kadam.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0269.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::34) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|CH3PR01MB8492:EE_
X-MS-Office365-Filtering-Correlation-Id: 07a1182f-932b-4a65-68f5-08db7745e8bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1xeR9KP8AkRJko64QqiaOYsHT05Kt3i1hWrYnKjVKBRKRiRR4v869DU/1KGLtcF1FFWQ2qlVBWmKiaorFx5l+iWot/5E8dg4d0TxRm1F0JsDisUq/2uIGv6vcuwaGCS5TeHhrYOmTcnPgSneawgRp4FGU/ubQc6giC4jJsNQ2SUJnQGuQFnA7pVAFxEb0Ci7f0z4Ub4AAjuKvIGkrCoiZPs768jLA/FAmb1wUsVerIKVhda+9EgDXnc9urW8BhsD+moFOYhzUwTrfq7HW04bZUIs2vRk3JXqKGGsXdXuX3p3xeRxtCCkXkqqawScFphBbC3i+V1boVrMJKuzUu+qbXOv5v5fhki8oqbdFdbu/uXR7XjDcYjLDrkyi20Omgt0loveu+Ff0vIvteKbcnkXRGjBHCkcnnu7daqWF/B1TFAZXPVXkL0qecOTYeQm2WXKl+iBPvXfpu+jl9OM7QtoZXGtsVy+18jLF2gd5VhxVWoRHO5Xqq2eJqbH3gg1xQeS47/Gg8ijuDB2pxyVuM5sEVQ+n08Iu9mTRewAqvsUuf2A60ZpyX9NhbHlH3YoH+yrQ8DbvNkX4ctqz+iD/gxNdrse8iNVPFK6DGwUiyekv/6dEV+z7TCXqhG4KaZ1s344GEQu1PnU86wneQVchMVaBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(136003)(346002)(366004)(39830400003)(451199021)(2906002)(186003)(2616005)(66556008)(6916009)(66476007)(4326008)(66946007)(52116002)(316002)(54906003)(478600001)(5660300002)(6512007)(26005)(6506007)(8936002)(53546011)(6486002)(41300700001)(8676002)(38350700002)(38100700002)(36756003)(31696002)(86362001)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjV2UERYVmVLbWVYb3ZDZHNySFBKZ3cxWVlJa25DU0Vjb1NwbkRoQ2RaMkd4?=
 =?utf-8?B?MDQ1TzVybEtmeGxXQ2hpNzcxT1grMXFZMDRPcFVKVlZGUi9CelB0Z1NUdUdK?=
 =?utf-8?B?YlQvT29QM0NZVTJ5dFpRQ3E3eDBnQ3dqOVVqZEF0WmdGQUEydEp1cnhCdXVE?=
 =?utf-8?B?ZVJKRjBpV3FvYktwMm9XR2xpRTBxNm96NnlSTmtoYk56TGZwWXVyd3h2bHR6?=
 =?utf-8?B?dXJ3cGNGcHNXRndzSUxDdC9mMzB3VEVUL2dFbUR3WU9QSGtQRWx3djh6L09y?=
 =?utf-8?B?QkFFdGhHaWtLRFhhOHBQVElUdUh4L0hJQnNnQnNRQ0NqekxvYStPYVNVdlA3?=
 =?utf-8?B?czVFckNuR3IzclE1dDd4Rm9wVnU3WE9uVEJBQzZPeDMxM2VMaTVnV0dNd1U2?=
 =?utf-8?B?QnJ6L0FqbkxQSk9rOWVGS0NITnlDdkxEM3FBd2pGUnluVUhGd0VWZTJJYkh1?=
 =?utf-8?B?eGkvOGcyOTZrczNLS0xYVG9xcG5jU2tkUk9CZGFsdUgzMEpUU1dZVFpKMHZh?=
 =?utf-8?B?VzJUM1pUcm9aeDJPbmEvVjVvVS93Vm9Lc3ZVUEwrelhrNnR0Z0lZbEhJdnRR?=
 =?utf-8?B?VlhBMlB3N1JPWlpqem4yY1kzQ2N6aUJhRHQxWGE5K3I1TnVGS055YnIzQjln?=
 =?utf-8?B?dHZSVEs3VXZmSlM0SjdkNHBYc01QQ3dBL2g4Wk9wSTdJRGpId3h1Vkd5akRp?=
 =?utf-8?B?OU1iNVRXa2ZySTJyY1RHZFM4Zi9mRS9QdUtIdk9abWMwL3g3Q1dRSWt1MXVq?=
 =?utf-8?B?cDdReG5IbEhjaXdvS3h6WDlFMUhhajhDYTYrRDd5NkRQTnlabVJVYjQ2bk1P?=
 =?utf-8?B?UWx5WDlOSDNFQ09WSVhxQXgrcUFOdFBERXptdG80SVZXbGptR2k1MDJlYUx3?=
 =?utf-8?B?cmtTRUVJQzhLdUNDc21FSVhTV3JYeldaTWE2aCtGRWlDR2tMa2NtUUlFZWJl?=
 =?utf-8?B?ZmNySURJNHZ2REo4SmNRdTQwR3RCWlc2QnhEeFQwY2pPY2NiQ2JGZU1lQnYy?=
 =?utf-8?B?dkI5cjFuUTg3emRPUG5PdmpXRi9rcFZ5aFQ3Zzg0V09hSVVKYTE2REN4VXB3?=
 =?utf-8?B?dGVMRUlaM3NldVJyWTNRKy94UnIxclBlQzE0bGEyMk8rT0loUitpVkJhUDRT?=
 =?utf-8?B?TytZSWYwQ1cvN1V1b3c1MHRkWkxwMUw3Y3dLQmVkampnZUxBZ3NoMjF3U0Uy?=
 =?utf-8?B?a1doU0txNEVXRURqR2RtV2ltVzFPZmRFUEhLVkRINFdmamxZNzdaZC9SVGhI?=
 =?utf-8?B?cTZKY04zOFVCSHpXaHhLQ0UyS3RkMVJZVUQzSFdhUC85RThmZmdaR2lZRTFV?=
 =?utf-8?B?bUVGTlJlUWhFeXppUDU0UGRyQm45ZEZlaUFGeDRXNk5URHNTUUYzbE9oMVFa?=
 =?utf-8?B?STZYRmxBTmFxSkhrVkR6bGJZQ2VBQ0VXdFRYMFROUmJQd1ZFbnl6OGhialhN?=
 =?utf-8?B?L1VsWnJBUzJKajVuSHVEQ1l5OXJhbzYvNWg2dlNYdFZ0TUtVYU91ekZFcTdX?=
 =?utf-8?B?UVY1ZGVWUVdBQVRzbkUzTzhSeFIvNnArRUdubzNqQXJSWmpQb1hwYmJLVUky?=
 =?utf-8?B?b2cxV1ZtTis2L0xtZ2I0TlN2MGl3YlhNVWxBbno5eVdydU5BQjFRd3dvMk5W?=
 =?utf-8?B?RE9kNWgwczArdnVHVGtRWUlaNGhWcHpoWU5WQXFvNFBTWHg5RXBFbkxMeXp4?=
 =?utf-8?B?ck9tN29Bb3dqTnBtem1IWFdIRFc4US82eXpuRXhQYVg5Sk5aYk1WZlZhNlVn?=
 =?utf-8?B?eG03VTR3bmkzTytQamNqM05ndkxkdTVvcWRWN2NOWG9KeGhXQlBmVDZENVE3?=
 =?utf-8?B?OVM2aXFhUWJ5dkFmdnhTQnh0RjNrQ0VlWXpQQWhhVDRrQW5jdnVjMmtpMHV0?=
 =?utf-8?B?b0dGZVlzamlwSTZjZ2JDUHFpZDBYa3pwVWNYSFdoRGxoREVUSHoxRHdHMlZC?=
 =?utf-8?B?TDgyKytuOUpucUlQbkx6c212ZFZmeFI3K3U4bFgrMWs4UnFua3JKTFVINENl?=
 =?utf-8?B?b3ZvVkhCbEEzTzR2NG5FU2NTem1Xb2pKK0d6WFJQZVNNMTFsZGlVenN5MGlS?=
 =?utf-8?B?NktNMnJvOGVqcXVrT2R5NUFOak5jN2Y4b1BwZmt3N05uWEdQNTlmZXJydGJi?=
 =?utf-8?Q?8z44i0MtIzrri2BZ4ETrjsa+a?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a1182f-932b-4a65-68f5-08db7745e8bf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2023 19:37:14.5827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mPV9scNLWXusGm/7dtlaYJvlvO90wwMNbn9y7lOn+Byg8XIj36YQ77/2uNgUwhIC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR01MB8492
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/26/2023 7:12 AM, Dan Carpenter wrote:
> On Fri, Jun 23, 2023 at 12:09:12PM -0400, Tom Talpey wrote:
>> On 6/9/2023 1:46 PM, Shyam Prasad N wrote:
>>> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
>>> index 1250d156619b..9d16626e7a66 100644
>>> --- a/fs/smb/client/connect.c
>>> +++ b/fs/smb/client/connect.c
>>> @@ -1288,6 +1288,56 @@ cifs_demultiplex_thread(void *p)
>>>    	module_put_and_kthread_exit(0);
>>>    }
>>> +int
>>> +cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs)
>>
>> Please, please, please, let's not add a new shared entry starting with
>> this four-letter word.
>>
> 
> What would you suggest instead?

"smb" would be fine, but honestly it's only referenced in one
place and used to be static inline, so it kind of doesn't matter
what it's called. It's also unclear to me why it's being moved
to a .c file and made visible.

Anything but "cifs" though.

Tom.

> 
>>> +/*
>>> + * compare two interfaces a and b
>>> + * return 0 if everything matches.
>>> + * return 1 if a is rdma capable, or rss capable, or has higher link speed
>>> + * return -1 otherwise.
>>> + */
>>> +static int
>>> +iface_cmp(struct cifs_server_iface *a, struct cifs_server_iface *b)
>>> +{
>>> +	int cmp_ret = 0;
>>> +
>>> +	WARN_ON(!a || !b);
>>> +	if (a->rdma_capable == b->rdma_capable) {
>>> +		if (a->rss_capable == b->rss_capable) {
>>> +			if (a->speed == b->speed) {
>>> +				cmp_ret = cifs_ipaddr_cmp((struct sockaddr *) &a->sockaddr,
>>> +							  (struct sockaddr *) &b->sockaddr);
>>> +				if (!cmp_ret)
>>> +					return 0;
>>> +				else if (cmp_ret > 0)
>>> +					return 1;
>>> +				else
>>> +					return -1;
>>> +			} else if (a->speed > b->speed)
>>> +				return 1;
>>> +			else
>>> +				return -1;
>>> +		} else if (a->rss_capable > b->rss_capable)
>>> +			return 1;
>>> +		else
>>> +			return -1;
>>> +	} else if (a->rdma_capable > b->rdma_capable)
>>> +		return 1;
>>> +	else
>>> +		return -1;
>>> +}
>>> +
>>
>> The { <0 / 0 / >0 } behavior of this code has been a source of
>> incorrect comparisons in the past, and it still makes my head hurt
>> to attempt a review.
>>
>> So I'll ask, have you thoroughly tested this to be certain that it
>> doesn't result in new channels being created needlessly?
> 
> I was not a huge fan of this function and the move makes it harder to
> review.  But I didn't see anything wrong with it....  Here is a slightly
> simplified diff that I use to review.
> 
> regards,
> dan carpenter
> 
>   iface_cmp(struct cifs_server_iface *a, struct cifs_server_iface *b)
>   {
>          int cmp_ret = 0;
>   
>          WARN_ON(!a || !b);
> -       if (a->speed == b->speed) {
>                  if (a->rdma_capable == b->rdma_capable) {
>                          if (a->rss_capable == b->rss_capable) {
> -                               cmp_ret = memcmp(&a->sockaddr, &b->sockaddr,
> -                                                sizeof(a->sockaddr));
> +                       if (a->speed == b->speed) {
> +                               cmp_ret = cifs_ipaddr_cmp((struct sockaddr *) &a->sockaddr,
> +                                                         (struct sockaddr *) &b->sockaddr);
>                                  if (!cmp_ret)
>                                          return 0;
>                                  else if (cmp_ret > 0)
>                                          return 1;
>                                  else
>                                          return -1;
> -                       } else if (a->rss_capable > b->rss_capable)
> +                       } else if (a->speed > b->speed)
>                                  return 1;
>                          else
>                                  return -1;
> -               } else if (a->rdma_capable > b->rdma_capable)
> +               } else if (a->rss_capable > b->rss_capable)
>                          return 1;
>                  else
>                          return -1;
> -       } else if (a->speed > b->speed)
> +       } else if (a->rdma_capable > b->rdma_capable)
>                  return 1;
>          else
>                  return -1;
>   }
> 
> regards,
> dan carpenter
> 
> 
