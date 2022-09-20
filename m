Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B45C6FA82
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 01:43:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiITBnv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Sep 2022 21:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiITBnb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Sep 2022 21:43:31 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C3C53D1A
        for <linux-cifs@vger.kernel.org>; Mon, 19 Sep 2022 18:43:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hc4w99yRghB+ANyZaWPIARQnKw4gdcX6GtpdJzAAtL8IgWDnKLdAEvKaE06jBLZpKKCDPwU9qiJCKibghozaGYgeNZuc3djnkjXKl04Ba7s2o7vaT7ZewDQ9dClDqfiCj+AHnF/xKyBIxXTuF3Qo2lE2jinsNjBeCr5ICuTX2b7dQvc2NWfGq89w7kenYoYmzv0UQAXzMHXx/iTwHGB4fE1x6eFLZ+M6AZ5QwczT/tAYZ+h74JN0cbsGInGuLtSl/5ZU8TPuQ4uo3CpIW/mQQD+4+mSbQp4aAKNoVX/k0+R+AdFmz6SEPHs3W4ZSIeG3glVHkd0zNezNpkzecJ336g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=62NdbHtjj8l65ikYLWQ6sGLlYof78pOuqgBPwjjPy7U=;
 b=PxN5H36K+W2uMQB9cKAX2l5I6FCKwKeHhT2elfInyTDvoyj1NGogrL3dIqvecoXLqFj+rEvOU5yMgr04aLDHTP19De1aDf1o2Ll4SFSmrbNmYdWazAMCIk7lH6FKET/RWVX3MQ2PQHuo3vivPovJmpVqwEgt+zoJ9gHh+NoefFY1NczPqsNBqCLBqzH8yLnfUp2+lR1EwCcPEIpoex/sRpDbqRQpJAN6OifO3wK3G1R5kG3/Q7JWp9qwDnof3gSoJUItzdqNDOEJcXkityAPMGSo9nAXLdD8w7HYO88atykmkbbaGcyE3VGbf7FoixKV9UtOgut4C7NOupvpWKD2mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB4843.prod.exchangelabs.com (2603:10b6:5:6a::13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.16; Tue, 20 Sep 2022 01:43:18 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4dc8:c035:7271:4df8]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4dc8:c035:7271:4df8%4]) with mapi id 15.20.5632.018; Tue, 20 Sep 2022
 01:43:18 +0000
Message-ID: <5e836422-b132-b28b-af31-4cf7d02cc365@talpey.com>
Date:   Mon, 19 Sep 2022 21:43:18 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] cifs: destage dirty pages before re-reading them for
 cache=none
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>
References: <20220919213759.487123-1-lsahlber@redhat.com>
 <20220919213759.487123-2-lsahlber@redhat.com>
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220919213759.487123-2-lsahlber@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0144.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::29) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DM6PR01MB4843:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e38b9eb-c5d5-4b88-3fbe-08da9aa97e47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v1KHhQ/8tGURiUGdtmjHIdEsJh7iLZ8UB8g8noz7FvE3NSiwWIATsHGjLYUW18qwdJkkF8lz3ltAGJqALMGvVBB5iQBChzZdfyUe1dhZfUJXCIsSPxa7gTCWpwsNUyD66UmeL9/1LU/JyLfzg6BZ5gX7f2KV8sbqb9lwwPSYDe4IBXdlNZ0vKKWObc/aF2cwN4aCXNjIwZy/3yEMwk5etxLdMr6WIsseeLXG+0YOhMC+DBIcqt/L09LRS/W94YNXtKKrzRIdaubrs9By5qkjLjlcxni7kOEnOMx0mwQ7RR6oeaJ+KD2DAGL9kMxpy7KP0QQWltEhiQCtcX8wiZ9BTV31VPU9+jxiu+qWGqliJ0hmpzPfB11lUytOWBKHimpSua21v31SZqm4cL6SdumFZpMo2ZYD2pgKCn27Po3Rqgs9YhWl5TNe17yjbHtBP0t33sSJKBWi8UXRPOrbfhVeJaiLb5T/5uH3yf1Zl8s21qkYxdlIesfv1htWUE0buYqgP9ifw1N0kk8Llimy5IqKg9LAzHIIfQnlgymROOj1lWlKKCtFPOln+aiBbkhevHcabr63Gxa5V51XABoVXYDvTpqqvoSXTNwdxjZUT0xLQRc8VW16kY6usJESCWEuIqTcKtXy70sH2vkOO7XKp75wnlSo2i0N/IFbwiWpsZ5D8sRag5E6J7jMrMVNVbM2nf2Ilba7rqGCWrflSLO5HXhCSTPOzE0YyfPpgw8cI0V9K0ipmsEMl7R3od2u2JSRNjPfQXbS+/fivvmHtEw9HCsDawqNJH4584GXPD+wSGgXzshEwxuNh42ohKICbMcKcTZw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(39830400003)(136003)(346002)(366004)(451199015)(8676002)(5660300002)(316002)(8936002)(66556008)(110136005)(66946007)(4326008)(31696002)(86362001)(54906003)(66476007)(38100700002)(38350700002)(52116002)(2616005)(83380400001)(41300700001)(53546011)(6486002)(6506007)(26005)(478600001)(186003)(6512007)(31686004)(36756003)(2906002)(14143004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWJhVG5GK2JPenNEUm8rUFVYRzZTeTB1bWxqak8zVFBjWjhhMjIvVHBsanRF?=
 =?utf-8?B?OHJTUnM3OThMVEFVVm1yb2tSSXNSMkFqNWl2L0U0NHhwUlNXeGtBZFNQeHJY?=
 =?utf-8?B?cVRUMnNEK2JWVWZ4MUh6Y0RoNzJWb2pBOVdsMEx1ZVBId3hZRC9PODdaTy9j?=
 =?utf-8?B?Z3ltZnRBRm93OGNOcU5od1pLM2VCS2VDZnN4SkFLZ3FBYnpvaVRER0NrNjdv?=
 =?utf-8?B?aHIwTzV6czRHQWxaTXNIblJGVStGVnBVR2ZLNFE1OVRQVEJmUW9OdUEzN1hC?=
 =?utf-8?B?YzBpdlE5ZWdJRGo4K3dxN2g2cDN5NDNLeDR4U0gwVUsvd1pRT01rVUY3bThI?=
 =?utf-8?B?Tisva3RWZ21YN3ZuQ1gvNWgxOWVFeVdiSU9WazNpb0Zzei9PZU5IVC96MnIz?=
 =?utf-8?B?Rk9mU0pZQjF0YmxjK3h3MEYxdmY0Tlc0SjVkM3JYQjIxZ1dMSVgzUjVkVWFj?=
 =?utf-8?B?OWVhbVFJVllYTXVvd25CUUVRT2g4NTh1R01IVjUyQ3VvU0x4dTNoeThkYWkv?=
 =?utf-8?B?Yzh3L2JFTW5BK29qUmUzNFQrbHpqUUYvQ1ozalRoOU81ck1ZWTI5UGRSYTJa?=
 =?utf-8?B?czYxVDRDYlJYZlNDTFdwcnlTTDR5a1dpUjNxMHROeTNsdUp2TUtmc1lhZGZF?=
 =?utf-8?B?Q200T3o3bUZmdFZLZUYyYzlEY1QzYXZDSE5aMHJweHFIaG1SRXYrVEluVDhn?=
 =?utf-8?B?bzQveWg1eGdteGwvUHp2SFJ6WkJWS2c0YUJMclJMZ1d0aFpKL1I0bEJ4SkJR?=
 =?utf-8?B?azFXWTY5OGVrdU5jbTZITFNuOXpTa0RuU25LdU8yZDJIejJXaFlJck9mVUwz?=
 =?utf-8?B?NHlsbHFSQkFCdnZUb2VaNmFlcWREVG1vTENBTTRhamVzM3JPRVNoSCt4dVRE?=
 =?utf-8?B?OVgwMHJwSk03UmRwSmtUZHFUQlc0eTJ5U1pFL25NeFF4SGFnUXNOZ0FFWEM1?=
 =?utf-8?B?b0hXdTVtR0hsQ1ZNWWpSb0JtY1dSdTVyandNaFNDTHBSVlJEeFJGYVpXNTlH?=
 =?utf-8?B?NEROa2ozUHFJaFJxNWdhc3Ivb2ptdVRMdkN5Y1ZkcnVPMFNOUGI2Z1N3OGZn?=
 =?utf-8?B?Q1VaSWhZa0xXR2gwUDZackVreTJSdWVVc1pwOUNjdjFmOWNEZEhmN1dwOFZw?=
 =?utf-8?B?VUdTOUtwRFVGTklSeGhoazJnNXM3cjM4R0MzNGhXNjMzTytHbGZKUlNxTCtt?=
 =?utf-8?B?ODh2QysvK2U4UXVoQURhVEtndTEwalJxMmhDRnpKRUVQeDNjN2ZITDNsSk1W?=
 =?utf-8?B?SFd4TUhxUzN1VEQzUjUrcUhUTE9WNG5GT3JrRE1RRDd4OXdnK1g3TmV4MnpW?=
 =?utf-8?B?YjJGcHRSZXJYdmlnbURWRzVia01DZzhrL01tRStJV2s2VHBQWStZYjlXdmhK?=
 =?utf-8?B?Mit4TENxK2JqUkhSNVpRWThsM2VlaTlvUlpoRmFZcGNnc2xRS2luRC9RSnlK?=
 =?utf-8?B?UzZHS3d2RWJBWjd0K09nOWhVdzZ5TzF4VXVQT2U4dlZFQ0JxMTZTakthbFJm?=
 =?utf-8?B?M1VrRlh2T1pjVlQrUjFabUd4V1hsbm11UkJ0NlBQejJ3amhtNDlJam9wVndk?=
 =?utf-8?B?NS82aVNVeVNaOHhvNmFmK1diWXFka2ZXV2o2eEVzdHZES1pnWWh5R0c3WGNT?=
 =?utf-8?B?YWJ5aGgzYlEwem1SZ2szVzc5dnB3ZGF2R1h2Q1VBT1lUY0NQMnByaHlPZm9S?=
 =?utf-8?B?alhOYnJWS3lSVE15aU5PYjBLZHhTbzRaYVhTRmcxSW55ODVyOStWbml3QjRq?=
 =?utf-8?B?ektEUTJhb2RyM0hwZWplMmNNcVMzVStnQW80UGJpZjhJK3FXTDhOMmVTU1Bz?=
 =?utf-8?B?OXhNM0R4cEJuQnMxS09xS25IVGN3NXdnSUlndWR5d2pmQTVHUjZrdzliVHRJ?=
 =?utf-8?B?TDdtRzhaZ1VWTEhpNWp4QWxvMWJrZmxxcXVJdXdaVDdSZE1oOVU2UFoza1R0?=
 =?utf-8?B?NnBFRFM0SzlZWUV4czlEb2dZT0JlamdIMENRdzhXbkJVcWoxUnVDdEE3Mkxk?=
 =?utf-8?B?UGxXU21IS2tFRHZ2Rlp3M28rT0IyOGdQRTZMZ2xEb1lEWU5NUVMzUXZ5R09o?=
 =?utf-8?B?YnBrNGFhOFBLVjhxazJsTHVwWWN3UUVEY2RacHVNY3ZDLzdHWE1hYlBxSDB0?=
 =?utf-8?Q?31Zo=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e38b9eb-c5d5-4b88-3fbe-08da9aa97e47
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 01:43:18.6501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kNNTGp1go9h3dP7xya3bw6SKusjhnxWq27RfnmsjoxAKKqy/YaqSEvabb7mAPo1I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4843
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/19/2022 5:37 PM, Ronnie Sahlberg wrote:
> This is the opposite case of kernel bugzilla 216301.
> If we mmap a file using cache=none and then proceed to update the mmapped
> area these updates are not reflected in a later pread() of that part of the
> file.
> To fix this we must first destage any dirty pages in the range before
> we allow the pread() to proceed.
> 
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>   fs/cifs/file.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 6f38b134a346..1f3eb97ef4ab 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -4271,6 +4271,15 @@ static ssize_t __cifs_readv(
>   		len = ctx->len;
>   	}
>   
> +	if (direct) {
> +		rc = filemap_write_and_wait_range(file->f_inode->i_mapping,
> +						  offset, offset + len - 1);
> +		if (rc) {
> +			kref_put(&ctx->refcount, cifs_aio_ctx_release);
> +			return rc;

Are the possible return values from filemap_write_and_wait_range() also
valid for returning from __cifs_readv()? It seems a bit odd to return
write errors here.

If not, then perhaps a more generic failure rc would be safer/more POSIX
compliant?

Tom.

> +		}
> +	}
> +
>   	/* grab a lock here due to read response handlers can access ctx */
>   	mutex_lock(&ctx->aio_mutex);
>   
