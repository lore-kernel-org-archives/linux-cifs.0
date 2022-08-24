Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CCD7C00140
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Aug 2022 13:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238283AbiHXN0k (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Aug 2022 09:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238356AbiHXN0Y (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Aug 2022 09:26:24 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E73D6C771
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 06:26:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TEAKMURo2+muVch8VAUug6fSxlKn/MzvYcPbvO4+qygV3+Dz/mZUEK4bOJARXlIPjeAxtzk22Q/H4QkP+7ow1qh5GqbD7GUj6/JLQTxYOIpiql3uHG4BK/qWqDOiLHV6RmBHAKul7bgiKUYV++jE33WedtElsG+Ku0veJJVmoo2IHu+MOZDhZR6qdsDwiJ5bAprdZeD7WP/0r0Bf9jzPYR8OVpDt/RADmOe1JTDFFbSxzLlIUgWp22cNeE4c8Rs5SRSelfOk9SkPeDDWk8CyZ6ggcmzlMNvH4hIEU0Q06vrsBG2r5Mhtwrje90xnLAP4zi6yt/MlkQK3X3PfxlVWUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdezPVd3dKRS00HDGJnAdI6obFD4ubnx8coOea63izU=;
 b=GDI3ab0V5JLwbE1GgZNnH/NLHCmvDuDksuqGYvDfYA9+mDpt734hC6iGemVI5IhOQ0Wf5IhgA4Jo383KOUdeUiVLu5ttxBVf53GSVOW+wplky+GQ9fDEZAYdItmq4QnBu8sMSoaoVYlwMJIsXMaiXGdbdDAwcVFtFg1AJvNT4zZmBInP22R+3aa7G17YGRhu8eoi0sNqizW3DpmbDJNc7gH+Jhbp756Radz51Gr+pA4aR8aHUc8NprJpbbPSISyNa1qPHFkZvKb+iXOzj2vBmc8vJqZQdY2yCJE6MJluvvvktSA2OQVRJCVljImOdqmJAkKpIfct6oQ136LGofZ69w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM5PR0102MB3528.prod.exchangelabs.com (2603:10b6:4:a6::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.14; Wed, 24 Aug 2022 13:26:17 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5546.019; Wed, 24 Aug 2022
 13:26:15 +0000
Message-ID: <6be102e7-4e4d-a4da-6afd-54dbdfc10cae@talpey.com>
Date:   Wed, 24 Aug 2022 09:26:12 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH 2/6] cifs: cifs: handlecache, only track the dentry for
 the root handle
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
References: <20220824002756.3659568-1-lsahlber@redhat.com>
 <20220824002756.3659568-3-lsahlber@redhat.com>
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220824002756.3659568-3-lsahlber@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0400.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::15) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3b595e0-59e3-4412-ef26-08da85d43825
X-MS-TrafficTypeDiagnostic: DM5PR0102MB3528:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EqinBHlLSsIaGySushuEK0U1KV7mSMGbg+QHDgKJUn2uTdYCMziPvdc+s7//y7w0DOkh8Y4gyUZIHA/qrr2Y1MepBWresVMV3u13ax4jS6MCUH8ySr+sqFrsaAVAiHDgtkNPFfmH1CR4LM+DTATiE1nos3UwbYAM5DzUQkZcfv9mc2/BrkmrrN+7ghR7jOHxQSo5/YF5VHbq0vHKMp72ebvVITN0WdWwEHfr0HV33pg5PdV9tpTxNdu/qCXDFZoMSHQr+xAYd0c3nUEiG4m0yCILGNTMdqOAtb/puqP3pDW03FsG/tNOnLTMrdng7k0cNLPsXTocnwGcgh0/keelDR1CewZmCcQT/oTcF/bRDuFOnKFx1NgJCk3rU8+nr7UblV4w1TdOqBGc3TCNSUVOy3M/KGuioZUPQMydqoTZxVtV2gUvC2s6rrw6PR8h9baYwiF2TSdwMcIjV1wiWEHJfQeY5wTXVc3euLhSgprloQUq0pV0zEOjNVz5EaxqWv7y1NVruDHTXSpaMJ2V7b0mt2Voh+FCWPIOAvmYjPeBkA/p9tEvGmiT+G3ecZz0KCoJvEsCs1sKq/KVWSPLAEVa8xREpzEUcRPgX0paoADcFjC5V6cDOEikeXcX2vKDP4dcaP3Pafqez0JOSY6r5KTOvtPJzaT3r/KtT5aeLJUMDpv1m3pqOxZW12z/BLujUrOYle2MfVCxP0/rb/HgEvo4RSKFheJizT1A4Rf1vRA5qibKHFxJlm1HEpfdvJrUicjyhOscUYXly74QZp3rxxomBO8TCy6WuC+Z3I1ndJXIZI8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(136003)(366004)(39830400003)(396003)(8936002)(2906002)(478600001)(6486002)(2616005)(83380400001)(31686004)(36756003)(5660300002)(186003)(38350700002)(38100700002)(6666004)(66476007)(66946007)(86362001)(316002)(66556008)(4326008)(8676002)(110136005)(31696002)(6512007)(26005)(41300700001)(53546011)(6506007)(52116002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUg3YjhFVXNCa3RoQnVzbHc5N3JQT2g2VXpZRHJvL0lqNElxYlY4VDFnTDdE?=
 =?utf-8?B?bjZOZ21mY1prRFhhVWE1VjJ4TU1rVHdHZUVKTkdQOVE1YW1aMEYyc2UvYVNa?=
 =?utf-8?B?SU1kZ3Bac29aNlc4WHRtS3ZzK2VaQkl2NWpiaDNGbS94cSs3bVBNYVFva2dF?=
 =?utf-8?B?ZHNPQWNURkMzTytOTjJqMXJsb2p3Y01OZjFSeVlBdjJUeGtrbUZWT2Fscnc4?=
 =?utf-8?B?eXcwbEpjSkhFNHdmOU4wSEFUY3BLaks4SU5xNjdnVzlhYlJWaXYxbFBjQnU2?=
 =?utf-8?B?RjJsYlhaOXdBVnFqYXNndEJobDIyY002SG44VStUQjQ2dDBoMldwK0JEeXh4?=
 =?utf-8?B?eUdOU25rY0tVNW54N085RTloNUcxNTlBcnovVTFzb2xiRnpoZlhMeE45OG9s?=
 =?utf-8?B?LzdDQ1cyUVQrWk90RDlRSWRuL2wzS3VkZlJUYmRiRWZhdER3Ky9VKzIvZnMx?=
 =?utf-8?B?d3p4Z2tQT2pZaWRuL2t0aWowVmlLcjBITUQ5WDBLeTE3VXQrY0xCNnJNZjUz?=
 =?utf-8?B?cjJjQ0JOV254TjdYM2djVnJhMmdKR3dRbU4zREJ2cG1SRWpjR1lHMkthVEdw?=
 =?utf-8?B?NjBTd2ZKcWFLbWwwQk4xeXdtY05KZ0pVMkk5RlNwVmY2N2ROTGROK0h6OTZQ?=
 =?utf-8?B?ckxMb0s2ZU9JNFdFQWpzUjEwalMvb05wUCtiSytnQkVVd29LVHVkZnZyUE1J?=
 =?utf-8?B?bE5SYUFOdU9UQW5tamFLUGtuVlR6TGw2eXdLZzQ3dlpJVWtITVZ2OWZtMlE3?=
 =?utf-8?B?ckplMkd0RDNVeWxWRlYyWk55WWRqYUhOZGlBcWY2dFBUNHZzVDVLRnh0aHYz?=
 =?utf-8?B?ZlhCNjJLbXFRNnpHZGNLMldmMXVtK2p6S1piUjZ2bElOczhjZkZPdjBuOWxj?=
 =?utf-8?B?QzVhd3E4VTB4NjNyK25FS0lyWVVVZ3QvSHJGSmZOYWgwcEhjREp6dUc5TTFP?=
 =?utf-8?B?N0xmMUtTNVNZS1ZtYTV4dGZBWTlpbldUNkc3b0Jid0R2TmJwRnhoUVNKMmlP?=
 =?utf-8?B?WkI1cG85ZW8wOFFsSDd1UXRGTFZzMmdadEhZR0VUV3hvOXArZ0d0NUFZZ2NY?=
 =?utf-8?B?ZDNTQzk2M1VsK0pZZ3hVU0lZemhoSEdsNThubnNqQmRqb2hpOWk0Z3lWbzBi?=
 =?utf-8?B?bC9UVUtuMFA3Skg5cHNlSW0xOEptYlp2L1JNNmszRDQ2bGd5cU1FRjV2UURz?=
 =?utf-8?B?MnVTb2pidElyeExpWG5CZHdHZ1ZyTnJTb1RwTEVwdGMyWXljbWRJTGsxZVJZ?=
 =?utf-8?B?Z1RxSVhIVWh5dDV3WDlsN01ZNVBjRVRHMG5hVEFSYUZmWDFlL25HdEFoalNm?=
 =?utf-8?B?WmMzaHlmZTVWMjB3TzFtNmk5TnBOSmE1QlVCRnNxd2tZeW5PTG52WitvS1ZE?=
 =?utf-8?B?R0VxRjZ1UGxISzhrRHE0NTVSZGs0RE96dDViN2E4S0MzV3ZKaURUTi9BT0xE?=
 =?utf-8?B?VDd1VnlwcUhyNDZKVXZrenBUSnpkUmpxUCtkbFN3SjZ2Yzh6dHp4RmtCdnJm?=
 =?utf-8?B?Q2pBWGtTRk51WWFrWjZjQmZySG9DclhJdjJXYXQxWU13elN6MmFsdEpMcWFD?=
 =?utf-8?B?RWJ3b2VtUEtLNEJYMUxtbjlxWmc5d25YdWJSZ21kUzZudFFZY0M4WFZ1elBu?=
 =?utf-8?B?b0kxR0FDMllXczZwa1hLVTYzSGRRdHFsRTVHUThsa1NGV01jd2wzcEkzOU9D?=
 =?utf-8?B?YjRZK0RaYmtkK05IckhDOTQydTc1VUJqL2dtME4ybFErZVpkSVZ4VTd3bjRy?=
 =?utf-8?B?SHdZUXZ6c0JJSDI5dU0xSTllTE54MFd0SVJkZS9sN3lqQ2E1UmVtOG5MNm05?=
 =?utf-8?B?SEhhdUxrK080UXdYQTVPalBXOFFrKzlPdWNWSmVwTzJTaHphRmV2WW1HelEy?=
 =?utf-8?B?NkxmNmc4dVpCWVpwZ1F6VXB3UGxkeGUyUEtQRG9rYU9YZ0hJeUM2WmRPeGhC?=
 =?utf-8?B?QXNENm0vWVBEa2U2ZXVGQW8zbmVPeUlOd0VqOUZoNEtFbGZvNVB3eEIrdkdO?=
 =?utf-8?B?ODB0YzZQMXFXeDFLYXlZV3o1Nm51TUFkcmk1bjRzUjgrTkRkMFJadWIvMjgr?=
 =?utf-8?B?Rit2OWYzRE9zZG9sSkZSZzJyczJIN250RXhZb083MTR6TXhqN0UrZGVtWHYz?=
 =?utf-8?Q?hHtg=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3b595e0-59e3-4412-ef26-08da85d43825
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 13:26:15.0261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NuTiVrSe9J+onpoZaS8SaVbKkgPjD+r9Ctmcwq4zDsDmt5CuCSj16q7rWbmJehQC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0102MB3528
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/23/2022 8:27 PM, Ronnie Sahlberg wrote:
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>   fs/cifs/cached_dir.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
> index c2f5b71a3c9f..77880470c7ea 100644
> --- a/fs/cifs/cached_dir.c
> +++ b/fs/cifs/cached_dir.c
> @@ -47,11 +47,12 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>   	if (cifs_sb->root == NULL)
>   		return -ENOENT;
>   
> +	if (!strlen(path))
> +		dentry = cifs_sb->root;

Wouldn't it be safer and more efficient to simply test
"if (path[0] == 0)"?

But, why would a non-null path ever be passed, if it
always fails? Seems like a pointless call in the first
place.

> +
>   	if (strlen(path))

Simply "else"? No need to recompute strlen.

Tom.

>   		return -ENOENT;
>   
> -	dentry = cifs_sb->root;
> -
>   	cfid = &tcon->cfids->cfid;
>   	mutex_lock(&cfid->fid_mutex);
>   	if (cfid->is_valid) {
> @@ -177,7 +178,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>   	cfid->tcon = tcon;
>   	cfid->is_valid = true;
>   	cfid->dentry = dentry;
> -	dget(dentry);
> +	if (dentry)
> +		dget(dentry);
>   	kref_init(&cfid->refcount);
>   
>   	/* BB TBD check to see if oplock level check can be removed below */
