Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E489CECAAA1
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Sep 2022 18:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiIOSpI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Sep 2022 14:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiIOSpG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Sep 2022 14:45:06 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553CA5140A
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 11:45:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8B83IAQgOHppR7Rsg83T66MKo+zZQSCdj0Ghpm/N/UhzcHQyIf+gEl0bDeC7XM01h2ZZaWJunZrodRUL/7oikVxEI5c3Ncu4Q9URZ/RMI7m+ofoSQpwGe1W6aT47yicIYNhoMthv44q3il/EmaG8NvhtFjRuJhj7tfphOZXuC8lkv9ZRfUFnTBl1TiL4ucYhNMdXYn3oWouXkMjsv87itNPfrwKlfKbvzLP6M8HHeaJez9+oMCzoLV2/y5EgDASEjHFvgo56yn3S0BVkswpfdnIpmtCKuwo8yUuOGkndm4JyAV8nsikhSt1IAyuXDaToPSvFuiiluKthx/NRxj8JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6pyDa54kHPxWaflsEtqNEOrg78ky1EgjdocFhmSiY+Y=;
 b=S4ZIxq4h90K4JLeTgWFKVAW9iI20kWljtnelPomHcT8cMRJtA7JBXHkCxnLMPMSfsJiPSHA4L+q8AiIvoBUwlofT3WUNvdJvF5Za+pzgwMkBtlmHTdFMvV6m2evo5LYQ2s06z381PlQUU7PdFa+4QWK3OBdoF7nQDlSg31/G+dtOUYhWPsvF66CKZoSlnrvJMf10Nay23ZMqN9jpSlW2AWt02zkblTq2kUBhGhQ+dULHPLJwUP/KX30RdSOOSS/kxOplza/f7M41MeN5ijtZ/Wu5bqg0SOcuVkPJ/jSD7VN+KOQwnnVpmRq2C8pOS+tyRCQKn1LfECSncUDwGzpq2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MN2PR01MB5584.prod.exchangelabs.com (2603:10b6:208:114::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.15; Thu, 15 Sep 2022 18:45:04 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4dc8:c035:7271:4df8]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4dc8:c035:7271:4df8%4]) with mapi id 15.20.5612.023; Thu, 15 Sep 2022
 18:45:03 +0000
Message-ID: <83e2c3dc-f474-de55-1f60-f429a7dd2898@talpey.com>
Date:   Thu, 15 Sep 2022 11:45:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v6 3/5] ksmbd: Fix FSCTL_VALIDATE_NEGOTIATE_INFO message
 length check in smb2_ioctl()
Content-Language: en-US
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        linkinjeon@kernel.org, hyc.lee@gmail.com
References: <20220914021741.2672982-1-zhangxiaoxu5@huawei.com>
 <20220914021741.2672982-4-zhangxiaoxu5@huawei.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220914021741.2672982-4-zhangxiaoxu5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0084.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::29) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|MN2PR01MB5584:EE_
X-MS-Office365-Filtering-Correlation-Id: 1421fc0f-8ef5-4f08-a36c-08da974a66fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sfT+QXHrI/f0cxQ8P7fSZNkbfICJOTTqwG9PbjET5YNpdkdm/gj3n1CUMiviENA596DSB5b6G465adcdHnPFyyWHO75pzeRJM8uUuFUweLePp89cEU4oMoxDGsP6qphUkmvKht5u/Ex2gSW3WyWiyl+M+thhb9Br86I2SMMhQJ4YYjWdv+ZvvkU5G+UJrzQ1tzlBwbcvBOf+qrb1oth444iWqIh45cMJu+xTalfr2WpTx+qtVIlFNa6du47/bOh6oeK5S9E1/ATOzb9UvI3mm/edHSLS3w/2gngnaC5QvnI7hv7eYNi25cVrL5FSSb1MycZsF/89URMYq4hGTM1Q/xKUBMJ7J7MhM+j57n83ERlFSJ/j2AaYjHxw7j+TDaNomubRfgIIPR6qaqqpHfFn113GlI9htCJ9dW8FAG/OOt2nNNiIr3Lv3EYEPH5viBU83VXoEjZqqih3MBLHV/E73PKusQX1iGFqR8f96VQD0DQIvDQ/PaD+YcmJkDR2on6BBlKRUR61tW22xPU95DQripc1gCzU1MZQghDrq/VWl9Ym/7takLcwK/Rw6F7SamR2nE4LC/ZMGm+2fCuMWdVceYJC+W2jez5dQzaAUWGuWzmARgDNKrdddz/eMhIxuKClPoZVAYCYk0/UT5Gzyr1h80ifMLUG10T9t2j4b2TPyd0wRm3uEz85Y2jiqdaIuGalljm0y92iMheTsyS2hrEW6uiouWrKzErN8cQtXZm4+bn7GaUHCY9qWgagZibV4XBu4vDqVWcm/dAHg9fQWFZk0YK6eRzJR/Usxjkcuwir0JZytxgNsRzf2e34nKflLHcK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(136003)(366004)(396003)(346002)(376002)(451199015)(478600001)(52116002)(6486002)(41300700001)(83380400001)(6506007)(26005)(53546011)(6512007)(2616005)(15650500001)(2906002)(7416002)(186003)(316002)(8676002)(5660300002)(8936002)(66556008)(66476007)(66946007)(31686004)(31696002)(86362001)(38350700002)(38100700002)(921005)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGdlUUxMSzI2RUJJcTAzR2M3ZUJBUEVzbGpFVVN2bkt3TkM2SHZGWmw4eTBv?=
 =?utf-8?B?NCsyTGF4MG5weVBJWDRrOEJ6SWtQNGhCbGNkbzFoVW83bWVyL0RYY3RiOXAw?=
 =?utf-8?B?U241KytrSTBEa2ZmdTlOMHphKzdZalFIbTRpT0lkeVl3cUJBQUFNdnkwbDNO?=
 =?utf-8?B?SGZnTkZqNUMyanNzV3FMMkZCREJJQkpGanZtazhvT1NhVGtCU3JNcFAzaXdB?=
 =?utf-8?B?ODVscXkvUldPaUNNQ3NzT3EzUVhXbjFvUEJKSzdyeXJMT3ZLYkZNRTYvdDBM?=
 =?utf-8?B?Ulp1aFk2bkhOQzFvWUFiaTI1K0U5SEV5Uld3anNlYkRnN2MxTmgzcWZncEtL?=
 =?utf-8?B?RkNya2htdGRtdEpIcmVXSkQvUEc1SHc1R1lUSjEyVC9KVVo4YzlsY1FUdEJ6?=
 =?utf-8?B?Ukc2TU1DQ1FWcFo2WjZRU2JrdHNwRjlkZzI5MnE1dkpQaDhYbktzKzlnd2pW?=
 =?utf-8?B?WS9sV3ZtNGo1bDV5OURGbTZORitTSW9BNEFickNXS2F0UitVeUczeEFjUmVX?=
 =?utf-8?B?SzZwVERJZm1GRE9UQzF1R00vNVladFBGOTFUdzNwRXdPVGtscXd3ZSs2dnIz?=
 =?utf-8?B?R3JZeDdFakdsVXc1NmxzTnlkZWViQ3c2VWR2M0tIc25NbTF5WGUraXMxTlFz?=
 =?utf-8?B?N21md01Md28vMVNZTEFOSDhZQlQ0bnBtYzd2VlN2L1gxTUlyMVU5NzgwbXNY?=
 =?utf-8?B?V1k2azNDSCtGQTRBcVFyQnJ3T0dKSlZEaGRNUWY5akVFTmFBNXZaTmlkM1o4?=
 =?utf-8?B?cFRVWHh4ZHpVU003MVZwRFFEamMwUVhENG02OENRKzJScjNvWW8wSG9tZVdD?=
 =?utf-8?B?bWU2TmQ2dDZ2dkRqVEFvQ1hYSnlZWmdBV0F4VHlUZy9kekNPSGhaZkh2dFpV?=
 =?utf-8?B?TGthT25oaVZpMVlhbklOL0xsZEhUSTVGNTNxTzVpdml5NFNrLys0QlNBV3A3?=
 =?utf-8?B?TCtnOTBPb0liaE5id0hCN3lIREdPUlhXZktFYWNsd292cUx0THdwQnBOMTlQ?=
 =?utf-8?B?RVhmU2c5RVNqK0V5emQ3RzZDS2FKMXdTYWpveFRWOURiUkQ4cnNrYnlGNGNM?=
 =?utf-8?B?cnFOWmlVekNUVi9PWjNIaW02VHhkT2phbjdyTk1QTk92K2JnYWZyVWt6NStS?=
 =?utf-8?B?MmRoVStDZW1acFZZczdMbGpZM1p6eWVwbHJYSmNOdVRqY2h0QXNISHQvZmpS?=
 =?utf-8?B?ak5DRWlOTGFRTExwTDl6bDRSajA2YmFHdWdyQ0FMbnpjR2V0ZlZEZTNLcmJ4?=
 =?utf-8?B?aTBidzlhQjJtbndmczB5QmNnS1BCMUY1VHd4YnZSL1VkWXAya2hlMzYrdXY4?=
 =?utf-8?B?bFNscjgrdXB2WmpkcGN5ODlnRlU4cmRSQzVNcDBURk4yZlEvODVPUXEyZUdS?=
 =?utf-8?B?SDRIQ2hzQzZLTEtQaXhEZnFIR1JVRGg0WjA1TUtDU25LMk4rZFMvNG1UL3gw?=
 =?utf-8?B?UjkvR3Nob3RsaTJtY05KNDdhN0dmZ1dNT2VoK1oxTEo0dHlBQmRVbkdVS2Vt?=
 =?utf-8?B?QVdlT2N2OVFoSml6R2RwYmVTd0NtTER0OFF6VHdZamlFa2taR0cvRGI0blFv?=
 =?utf-8?B?K1BnRWNpVWZYdklHekpteC8rMHZQeVNka09Wd1hzM0hQVUc1Y3VaRjNvU2p1?=
 =?utf-8?B?Zm1yQk9SaDI0MnZweWk0S0xpRll3dGY4RDFrSEZFMndXcUFlL2MxNWt5cjdB?=
 =?utf-8?B?ZEtTNm9wcU1DeXFqTVN2Umg1cGdYNERpMlJGaUQwTFVqbGxlNGFZZU9nUDlC?=
 =?utf-8?B?S1VzL3lrcG85dzlkZDF4elYzd1NTdTBpTldUN2phYU1PZFpZY2kwamdPeUZm?=
 =?utf-8?B?T0dvQXluY0Z2blJzcEoySU4yclh3TGttNWpBUWdkSHhxQTBMQnRIc1VFQ3BI?=
 =?utf-8?B?Y3lQeklzR211Q01KUjdLbkN2VnVPcjhjZVNQZUFmVzQ0OHBlenNxMmQ5dHl3?=
 =?utf-8?B?bStMZHpuSWdFUzk4ZTFrWTdGOTVzbjArN2JET09EclFzS0xuTStNbWZKc2I1?=
 =?utf-8?B?RUtWSnJpU3JzUnp1b1JzUWladzl3UXhJYVN6NEVtaHJIN1NVejFQOUlvdlBG?=
 =?utf-8?B?Q3RUQW5FWFpCUjJTZTdxSzhjYTVKTy94eHRJbGlYaWl5Smo0TzdVVHQ3aXA3?=
 =?utf-8?Q?SkVE=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1421fc0f-8ef5-4f08-a36c-08da974a66fd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 18:45:03.9181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nzv/M2RtnfoLiMT0Vy14tOWMHqsCgu8XqAX3EVylsVxMaHs9/LEqXW3kyXmSsFpV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR01MB5584
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/13/2022 7:17 PM, Zhang Xiaoxu wrote:
> The structure size includes 4 dialect slots, but the protocol does not
> require the client to send all 4. So this allows the negotiation to not
> fail.
> 
> Fixes: c7803b05f74b ("smb3: fix ksmbd bigendian bug in oplock break, and move its struct to smbfs_common")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> Cc: <stable@vger.kernel.org>
> ---
>   fs/ksmbd/smb2pdu.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index b56d7688ccf1..09ae601e64f9 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -7640,7 +7640,8 @@ int smb2_ioctl(struct ksmbd_work *work)
>   			goto out;
>   		}
>   
> -		if (in_buf_len < sizeof(struct validate_negotiate_info_req)) {
> +		if (in_buf_len < offsetof(struct validate_negotiate_info_req,
> +					  Dialects)) {
>   			ret = -EINVAL;
>   			goto out;
>   		}

Looks good, but see previous message regarding squashing this
with patch 2/5.

Reviewed-by: Tom Talpey <tom@talpey.com>

