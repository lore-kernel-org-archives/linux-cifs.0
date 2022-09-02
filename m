Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB1E6C38145
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Sep 2022 13:36:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236474AbiIBNgo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Sep 2022 09:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236992AbiIBNgL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Sep 2022 09:36:11 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F284CA17
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 06:15:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkv5FCDFTw2BQb3G29V4WwiaOBmdM449DBTI/dZeAB2UCJRg4w+DcOSbYVOJJqFj+84QvDsFM/SPfKg3I2E6glTgGFBQaUIEjLGTKqg7HZSN50Mynb1kCid5CnkJ/+RAZkipFbO+Z14cb1oI7/k4YKRi3ygQbQ5tW/jBpC4rz7pAbSJFZsumTQhTgO+awtxQt7L2jX9Arbn3kfTVXZvIJP496tXmlJH4PqALyCjSfR1yFItTsbQwtboKewRaAw4q0m73P2w9vBShISf2/nN5tshBMgPxE1OpZcpV01UoUhAIuBPwaX/NiZ6ozvRZ8yEY7rYgmjOTkLu+uGmkijWR/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qo7cX5HsVxCr0kROg7iz6b0nnYUDlvxoXj2Vtt3FMhY=;
 b=fx8mOmlK5Rz1auzOT4jgo1ipsIo/pqSjFNkIS4P+O+k4/3CE8hgYT4ofcO8FW0KBwgioJne5Q736xcjqzTG6DFBA+NtXEqHrZYysgALy3XCck3vvghqKIswkdtja4B6WSdPfQJIZzuT7Kd1V4i9Lqvg880o/ALuYiGhbetXbOb5kGou8hK7bCAbdoTnTdHV+s13+/PTEcnn4vvmO38oxK2FCczFdZ9h3CW4eIv2qmMWUpJCs1n2t8C0Bh3RdunNCFKZnvL69icD9BS97d6AUAEUVxjlnwC5tWMrN6AmbHdKUEddFlxixUwL+JhNQPL+bgIMDx3oXPiTdH8V7w/RWTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB4438.prod.exchangelabs.com (2603:10b6:a03:98::12) by
 BN8PR01MB5425.prod.exchangelabs.com (2603:10b6:408:b4::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15; Fri, 2 Sep 2022 12:52:54 +0000
Received: from BYAPR01MB4438.prod.exchangelabs.com
 ([fe80::6d1c:4239:2299:c1f6]) by BYAPR01MB4438.prod.exchangelabs.com
 ([fe80::6d1c:4239:2299:c1f6%7]) with mapi id 15.20.5566.021; Fri, 2 Sep 2022
 12:52:54 +0000
Message-ID: <25b614b7-0e8e-321e-c878-4422ff16b92a@talpey.com>
Date:   Fri, 2 Sep 2022 08:52:51 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v4 1/5] cifs: Fix the error length of
 VALIDATE_NEGOTIATE_INFO message
Content-Language: en-US
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        linkinjeon@kernel.org, hyc.lee@gmail.com
References: <20220901142413.3351804-1-zhangxiaoxu5@huawei.com>
 <20220901142413.3351804-2-zhangxiaoxu5@huawei.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220901142413.3351804-2-zhangxiaoxu5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0086.namprd02.prod.outlook.com
 (2603:10b6:208:51::27) To BYAPR01MB4438.prod.exchangelabs.com
 (2603:10b6:a03:98::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 743fe501-d480-44cc-38ed-08da8ce20da0
X-MS-TrafficTypeDiagnostic: BN8PR01MB5425:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ubMpz1op0Ihx6H8X0yw4rY+iUa9xQHa6w+XmrC1XvO0oKBfWjwQFk7hJ10atC0Bh9Fr6fyCjqji9ey2/BLAWmNsP489lIB3RqLXBBoNsuqceaKeZ5Wkkrjtyc3FM9riz3JLuOGNYATk7vyMB7sxmj/R0lGFpAQVX7Gf0ryQNIiK/wNYxDYS01jNuMC3vHo7XIMX6FzhJIAsy7E07fW3H7HeR99kQScnnjOlTi9nACdCKg1pANUWQpmZItpmnH6OjrF7q+KdOWc1PahjAImFGZXPQD0uMoTwXIRrx8MUC1Ye2NOJ9701qw+6HfWMsVvhPSyp+EPOpQc2FHNsTk1NKY9ZOHQEqSv9QaTBUNK3j3X4EOlEPyQWWxKUPLbvX5ZeJxLsZgFbp3x1XkCRw6qXrj6RP0fiT4GYrfMMn+aglX4hal7Ze/ElKjUrSlUhaOH1FwGmsJyKIa1JX/lJTXVzulcDeLJMnfrQRF+E+CsicIF3CMI8/+s/TBysnkxHrrF//AjkhsCgRo88V4/+day0Bs1DvxOE3ZJ7uVmddAKkhFRQD9bGSbHbPF/4EOV103K8okqW2GI2FOuDMEw0YkqQmY2vaBJRr4PcMBpZ4SOVrA+CyJGBrEeAAtvMeZhtPInB3TuzZU49j7wIV0ylQ0K92Va9uGPCzvPN5hQ8yjK17O3X3dBEfxBu6RkaiHG7XHlQmMtyy8ZdBc2BELI8kL6pzHeunu8jc5fZ+P0gn3eDC70Mf684ljW4sqk77EbD1VttoVN1M+mb2pl0b1xZP3V3fvWPyhOiqRTVgsgJAYKVOJyA/Htggah6jzgToFZM/0eWD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB4438.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(396003)(39830400003)(366004)(186003)(478600001)(6506007)(6486002)(2616005)(31696002)(6512007)(53546011)(52116002)(86362001)(26005)(38350700002)(41300700001)(6666004)(38100700002)(921005)(83380400001)(66946007)(66556008)(36756003)(66476007)(8676002)(7416002)(316002)(31686004)(5660300002)(2906002)(8936002)(15650500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUNjQk5IZUJaR1ZWdE9PTE5nTkNCdklsb1ozRkpNeFZ4VVA3alh5akE3OGln?=
 =?utf-8?B?V3ZwZXYrUjlLenlnbSt0OU8zbDRGUVZmRGpwNXVsNmkxemRIVmcyWWp2WW5w?=
 =?utf-8?B?bVh1Q25zM3dydjF5Vy9rN25XZ0pTZ1pLU0RsYU1paUQvc0hQVkNKdkx1RHZC?=
 =?utf-8?B?WHU0TjJkVWd5cmQ3RTN6bGxCcXNuY1VKZnJVWllzYThFVTFJQzVLU2hNbjh0?=
 =?utf-8?B?eXZvR25lamoyNVhSRktlS09mOG9WMlhtTzQvOXlYcTNUeTFNNE9NL2YyOWpS?=
 =?utf-8?B?all3M1RsUWlUaW9abWhxc1paVWhISmpKZFBtWExzL1N5cjVXdVQvZHE0Zjht?=
 =?utf-8?B?ODVyUkQwbFpsZzBtUHBqT25VOGxrY2c0b3NBRXplMnl1c2xvRzlacVpBbjZF?=
 =?utf-8?B?MFdEcjZxb1BmVUx1Q2E2QTZUaC93eDkvV2NMWSs3RWZOblVmZURwdURIZmtB?=
 =?utf-8?B?OFNkdTF4aUlXNDhuYUxMTThuOFk5QmI5NE9yY2ljOG50RWhwRXdyUjUyQmxV?=
 =?utf-8?B?UUhGYW15UlFmNUtBR04rQnllVmpRdWRJc2RKS1hvV0E2ancrMDdyblpVZnFQ?=
 =?utf-8?B?b3dkcW5xeG9PSXVaeFJneGMraUNtMEpXOHhnOTJ6UW9VUjVXVDREcmpCMVN0?=
 =?utf-8?B?M09mOFZxUklYYmtEbXRsTE1BbHMzZXVITzB6dms0eWZscUx5Tkpubk44Q29q?=
 =?utf-8?B?cWdTREY4YjdSRFJibHpNTkFOYVBVTy9lK3g0RTkrZlB2WHJyNWFFQVNEa3I4?=
 =?utf-8?B?T0dCeko4ZDhOWVVFRUhIZDFiVWRFKzhKTjhRZk5SbDk0a3REMGJBZzY0QkJN?=
 =?utf-8?B?WkpOMHZxZktqZmc3VFFCc2UwVUk0aDY0UjV4RTBNY1dmRmV2dXpsQ3l0dmd1?=
 =?utf-8?B?M1JyR3h0dGxPNWd1TzF1alRncm5hRDVJWDVYSzMvd3NCR3RYWnpEZkN3bVVO?=
 =?utf-8?B?RUJNUklFVmtiMXBQcnk0clcwaXNiOHcrU1BneU54TnZhSFpndjVja0phbFYw?=
 =?utf-8?B?bWMxTHpTYlc1ZS9Zb2pSMEM3TE4vMTVrM2hJYXpqQ3U2a0ZzRlhJU3dXejNQ?=
 =?utf-8?B?bVlwZ3cvR1RrZXgxNXQ3ZmR1TStrMVhQQjVBSEJ5WVd5SHROYS9BaGdoRTRp?=
 =?utf-8?B?V3Izb1hkUWhvbVY3S2RKSlNEcDk5WVpjMUhkMzBtNXNKVGVrUEVpWVA5aXA4?=
 =?utf-8?B?dTE0dFh6K3kyVUlMVlhMeGtFM2dYUHdLZUFlWEhkNlorbHhKM3FyS3dKSFRx?=
 =?utf-8?B?KzI4NTR5T2svbkRTRVBZNWU2SnpDTFBiY04zYW45bm1ackEzc3g1UmdzQXJD?=
 =?utf-8?B?ZUdiUkRDYnNyNGxQazU2UzRndDJTZ2JZLyt4eXhUS2VGMHFvWVdSd0NkUVVq?=
 =?utf-8?B?TWVKSWFmMWZ5bWN1ZXFJRDBsUlE3TFBHZlcwelRaR2hlMksrREJpaWo4N0dG?=
 =?utf-8?B?STc4ZFdrMkNjb2NkSlRUTzZJMHMrcHNrYnlFVnd0OTl1SC9JeUJYRWZKZkdH?=
 =?utf-8?B?aW85dWNIT3hxZHFiTHpsZ2FaYlJwQW5PSElEUUhMc3hOajlIWWdLSlRrTXc4?=
 =?utf-8?B?V2xVZ2FZYUVnY2JlL3VSV2FUYUU4cTJGOW8xMDh6NWVWV0pkcnltVXA0anZI?=
 =?utf-8?B?ZTMwSlVXRlNXQWtRZG9LQjZyRmlRUkpjd1llektBbGtnOERuaFN3Vm5lQkdD?=
 =?utf-8?B?RWhpYjRwYkQ3anh6TE8yQU8zNlh0ektEYzM2STF5cWU4N1oxeHF2eWh5NVpI?=
 =?utf-8?B?cUhxd1FPejhkMmxYL25DaUwycDVUQnp1WDhTVU1ybGxYcHVsU2IyN011aGFR?=
 =?utf-8?B?MFVQckVMWkF3eGs0SjdwcFdKV3JselhEWG15cCsrdThMV2lEU3ZwQTdLV1VT?=
 =?utf-8?B?TnFNc3cxTzlYWU1EMmo0TUNZRmJSaWN6N1hnTG90TDRtSlgyWWY1N2MxSWk5?=
 =?utf-8?B?ekZSZ01JNWFzZVIwcUJuK3J2VlVNRXZVOE16VWJIck1UK2xqZWdPMnNDbDVJ?=
 =?utf-8?B?K2ZsZTN2UU1qUm4zRmRDa2gxYld3eUJ1YTJxRzBtU3pZR0RQQ0MvMmM1b1Y5?=
 =?utf-8?B?ODVOQjFpZStlcDBDdUdiNEZ0WTNDYzV2OU9GZ3lkeUxkS3lXa0htdmhuZllJ?=
 =?utf-8?Q?V0BKwjyHQC9Xu+WkGL4/HdLsQ?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 743fe501-d480-44cc-38ed-08da8ce20da0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB4438.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 12:52:54.7323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AJ4hb7MdrYYdgfmP1E+sGy3taJYWJqNS3QH6qbX4qzE9sH4MPt+P4L+xAr1L0lhz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR01MB5425
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I guess this is good for stable:, but the code is obsoleted just
a few patches down. I do have one comment below.

On 9/1/2022 10:24 AM, Zhang Xiaoxu wrote:
> Commit d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")
> extend the dialects from 3 to 4, but forget to decrease the extended
> length when specific the dialect, then the message length is larger
> than expected.
> 
> This maybe leak some info through network because not initialize the
> message body.
> 
> After apply this patch, the VALIDATE_NEGOTIATE_INFO message length is
> reduced from 28 bytes to 26 bytes.
> 
> Fixes: d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> Cc: <stable@vger.kernel.org>
> ---
>   fs/cifs/smb2pdu.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 128e44e57528..37f422eb3876 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1167,9 +1167,9 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>   		pneg_inbuf->Dialects[0] =
>   			cpu_to_le16(server->vals->protocol_id);
>   		pneg_inbuf->DialectCount = cpu_to_le16(1);
> -		/* structure is big enough for 3 dialects, sending only 1 */
> +		/* structure is big enough for 4 dialects, sending only 1 */
>   		inbuflen = sizeof(*pneg_inbuf) -
> -				sizeof(pneg_inbuf->Dialects[0]) * 2;
> +				sizeof(pneg_inbuf->Dialects[0]) * 3;

This can be coded much more defensively by expressing as

	inbuflen = offsetof(pneg_inbuf->Dialects[1])

No need to repeat the "big enough for 4", either. Just drop the comment.

Reviewed-by: Tom Talpey <tom@talpey.com>

>   	}
>   
>   	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
