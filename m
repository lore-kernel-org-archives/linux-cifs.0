Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2406CC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 15:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbiI2PqM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 11:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235790AbiI2Pp2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 11:45:28 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E72145959
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 08:44:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4w9jr2/9wMkF6YXuKwnpcoJVnH5n5DMfeFR0ezCuiwpgoCJICuWR1jpzumbTgF0GFJx4ZzOu7pRl0M8ayfMbI5HENcO8LV1qa5D//EzAsI8nmSElMnRDdtpWhakPzpOr3mVviDReJpGJD5RXXh5llFRKafEbzGcJgtd3+RZiOzps19aYcjjVmfXdF+sCdp+HHgiYH3tzIUigi0pOfMJFC8JBx6cUiMhTHhZUartKkJLGhBHkz78PP2Bu4qUcZuRbGaRkQqchf2eITKt6A19CayW8Zs1NIZkKlToGbrcawA4e+dINeUpf3ibwsohU6/0ClOtHX0Q0ZHBhZTASTyvWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HPSqk0KVk1yimVjxX1yI4zEv/UAfM5OAYzKtoPpy7Ig=;
 b=lHRw7nrk0vggr7Iw/v5n6gjpbs456SeBj5880jM+/vY0CJqOgG7h/eNdSiBZmsS8QbPQT1g3uE8cUz+zIzGTSMQ17s+A4qDjPRQiO+aCT7YTRZ0Yz8RZuGUuDqc4cSVgXtGzp0SCtGLlEryWwWmz0faQK6BQ5UCgbJ0C/kgRdfrmzjsCm3WndJ+EY+cO8A1OA1q3E9uQmsVz/bNEwpd0Or4Y1tD4LKC/oA94pikP5nhInZzll4wdPBt/FYz5bKdpTbgV+BusDPsRYgrY7O+CavQiCOdkhq1oQIsGQ2iR3FwXjOzt8yQLTDjdLac4SOqVivKrsCJ2CnNvzf2lIR/yYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB3865.prod.exchangelabs.com (2603:10b6:5:91::24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.22; Thu, 29 Sep 2022 15:44:24 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::5c62:b328:156a:2ded]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::5c62:b328:156a:2ded%7]) with mapi id 15.20.5676.020; Thu, 29 Sep 2022
 15:44:24 +0000
Message-ID: <7ae96753-f72e-fdb0-5bbe-b36864be9612@talpey.com>
Date:   Thu, 29 Sep 2022 11:44:23 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 0/6] Reduce SMBDirect RDMA SGE counts and sizes
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org, linkinjeon@kernel.org,
        senozhatsky@chromium.org, bmt@zurich.ibm.com, longli@microsoft.com,
        dhowells@redhat.com
References: <cover.1663961449.git.tom@talpey.com>
 <CAH2r5msZ85dBBU=rPyzgBOPJmMrJ2ACCG+DhrJJprvDJcr9QPg@mail.gmail.com>
 <c4273f7e-6024-8f1d-5514-39501fa9943c@talpey.com>
 <CAH2r5mtw3QYxufa_CNf+YHRP9BU2Ydw90gsbj4c21AyrGnDYnw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mtw3QYxufa_CNf+YHRP9BU2Ydw90gsbj4c21AyrGnDYnw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0027.prod.exchangelabs.com
 (2603:10b6:207:18::40) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DM6PR01MB3865:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ad53788-e525-457b-cb07-08daa2317c16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dBfYsxlEcIRFg1EHYN+ZMDBsFuo7E7EuFERUazVaShKqSpbRgLcyyV6pC33m/JRPCfir8hpEzYdyv3vHMsri4kH1Vs3q+KCd67trSK5l+944KGsf4FRwnzCnZ8hE9+ARt74FOKxlapBlzsr2CTbo64Dv+Aui+Qlulc1lB9PTmAJfs99LuTtS3jvKTkO46CJ+bQraWA4x3+46C4cvUvV41MTbwR09F8a6h9mTdC6kzDfvYSGZ470SpcfmdNL4pqUlmT+IFvuqZwOS/WBcWP8jQFfY9np/f1KBlAb5cUX4QCrklAUJvYH1pTSmPV0g61hHfujzDRs8U8pDAbNFwUJ3LxAaOU/bYfZ5Eh2x/yRtN2Qae4N+rjKUTzwBQ3Xc+q3JlAHz80vjm9UCJ6UsrnqIMCV1hHau6HdQhkmCNmD0MlhfL17QeUhdF/e+Q4Sz011evOe/bKKfxFlp9CL/fzvaXjpOgUzTtdelNEakyD15ryyhUBIGpErwTvUM5hDfqIWo9rgW3VqttO3j3ApNOeBrIeiSym+D6fj3CUNIv9HLeKKniy7SkWiitYO79P+j8RbaXbWKVE9kkXS5gz4U2AtzBrTOfr6qHk4YlbgAZKzAxc3l7QcrRG0IH0Y/GPCYSrw1yGfKr6+vJqjS6eM8ZxYk7RvXcNDxyd1msKvubt2q/1TfloJ/sqOKLKbFRb0jv4yQjW6bucP/ng8Ty8RgcQm+7c9n5Y7eobPdoVEgUDhvJbpsUjwMWdKifb5+oUVackkzGGpPrIQJ8KgHxSnZU+WHkpbXHLgIbM4cR/vG9Jn8QWg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(376002)(346002)(39830400003)(451199015)(26005)(6506007)(186003)(53546011)(2616005)(2906002)(5660300002)(83380400001)(6512007)(6916009)(4326008)(8936002)(52116002)(66946007)(8676002)(66476007)(316002)(6486002)(66556008)(478600001)(41300700001)(38100700002)(31686004)(31696002)(38350700002)(36756003)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mzh4TVFCQmZGVThHR1hBSkw3ZDFkV1FPRWtvTlhzaHZ4OHlLMnJRNGc0U3NX?=
 =?utf-8?B?cDhueWlFdFU1bytMYjlkVmtua1o1ckNGZGhoMFhWU1E3N3kwNmJQcTVIM2tz?=
 =?utf-8?B?QTIvZVA0R1A4WXAzck9YZ3FWME5CQVJ5ZGZwWW9qdjhOZXE1VGdaSTFidFlN?=
 =?utf-8?B?VWREWTRZZHJRVU41NDFKZUIreEp2aFdabk5ST2ZHUjdlNG1JekdTVjdxRVNU?=
 =?utf-8?B?OGtaaWxUd09wZjV1dTFQNlEyNmNCWnlYeHBvM0oxTzNGMEVOY0JJOVhYVmlR?=
 =?utf-8?B?TDFBZFU5TGRIcnN6K0RLWHpraFFhMmV6RUxtelZRWktqWFlETmZyNjBBTHA0?=
 =?utf-8?B?YThuTTFwelp2cllSZHlsN253UEtRWHFDU1puZEFEWGx4dkE4cUtsSyt0dFNx?=
 =?utf-8?B?QkxZYjVOaUtwRDNWTlFHQStJWEVreEpIKzdUbzVCak1XZVR5ZTRaVzQ3dkFX?=
 =?utf-8?B?eUFWZ2xHemp4NmJFNkNpdkNJRWlwS0JPVFJ0TjNTbWMwZU1qOGlMZ0FraFBK?=
 =?utf-8?B?VVNYb2VKYVNaeWtTUllyNFJyaWdrdE42ZHBiUVI2Y3B6dzlpbDk5dUZsdyt3?=
 =?utf-8?B?bldSTzVIZnRneWZBZnBQT3RWTzNLZnduYk5SaUJyeE9TdGlvZlVscFNZQ3k1?=
 =?utf-8?B?NXJhWnozdng4dllYbVpNM0xscmlSSklEY093enVKemZQQmRCbnR2NlNFQ1Nv?=
 =?utf-8?B?cTAwS2c5Ri80Ykhhb214cFNuclljT1NZSmR4bjVaRTZoanBiV0NJdlBHRW9K?=
 =?utf-8?B?QVZUNm40N043aDBqWEJub1lKd3ZhcHVjNzFHMms1V2JVcitxWWN6TDB3VllX?=
 =?utf-8?B?alRFWHQxSVVSVXJVOGRkUU5QU3lGRWZCOEc3RVdrMDVvb2ZDbDVLWWVVeHNV?=
 =?utf-8?B?aUZCSTZQT0ZKWVFkRHlRYW1XNm5rbTdtbHFocC9mVFdMK3k2bncvNndjc3Y4?=
 =?utf-8?B?ZlY1UnJjbTByV25ESEd1S0FQeTVjUXpEV2ovMEJsVm15WWZ6TTh5OU12QThE?=
 =?utf-8?B?WTZRYkhaWWpaQVFTUVA2djdocVF5aFZmVnRuS25BR2pyb1RIYy9QM2R1VTdX?=
 =?utf-8?B?SEtSUzBFV21ueERIQUQ4Si8wZWNiSFI1OThrTVVqWGNrNG81NTN2cFpVUU1n?=
 =?utf-8?B?OEYzcytnMTcvYmlxV2ptL245WVN0c2V3YUtPR1l5d0s2MDNzdE14QkNvbEdu?=
 =?utf-8?B?VCtvNGhMbHJsUXYraGtVZ0V0UmFQMU5IVWl4L3BaZGVaYnROa2NjcmQ4aEJM?=
 =?utf-8?B?azk3S05oY3J4U0VZOUJCN0lmZDJIV1haQ1BSTU52Q1lWY3R5TUlNS3dtK2tw?=
 =?utf-8?B?S3FwYlFoaE5tSkI5UWdoYW0zdjEyS0JyVzh0NDVheWlvYk02L3dyZTF2WmEx?=
 =?utf-8?B?SjlocmVSbnB2NEhCVi9iV2QvMFRmdXJvdWRvcGJJQ3Evby9BRHBNeExlVGJp?=
 =?utf-8?B?dnRwc0dWNjNNdDBaaUhOa3EwUTZRMEhhaUhtTEdmaWxVcHhRVUs0TGp0c3hr?=
 =?utf-8?B?dDFmSWVmZ09WWlFRamg1YlJPKzEwajhQT1BKS2lwd1cwd3VKaWdWVk9xQmcv?=
 =?utf-8?B?VEV6N1BTaEpKK0FJN2x3OFRKVVdtbW9vdDVBOWd3cTlvblNLSmdOVjBRcC9p?=
 =?utf-8?B?YzJ5ZWtRMkdPeXZUSm5ZMDZPTXorSTdGTE5NOE4zQVdoMzZ2M0JwdHNiK2hY?=
 =?utf-8?B?WGVZQmdXS2IyTGtXaWhFaSsrWUs0d01VcjEySDVQV01lclplc0d6bVQ4SWIv?=
 =?utf-8?B?eXlhMmEvLzMvUUNJdlFBUVhQejdGQW10OEdRblNvUXowMlpiZ29nN0tpQkhW?=
 =?utf-8?B?QU1VTnNvb1NCTTN6ay9LYU9uT3BDcERnMDlmazdycGVZN2FWSU4wMWU4MWdE?=
 =?utf-8?B?YS8ybVp5V1B1Z3JubExMYk01QUw2VmdnNmlhcGZtVjlrMy9HRkZQbEVyRmx0?=
 =?utf-8?B?TFFnNWdJcE1CbXZHSE9MZmc5THlyM1Q0VlppT3BVNUZHSFNNdFZvRTNuUjh4?=
 =?utf-8?B?ZU9TeDN4OXNOdTJhTnBldy9xa2oxK2owdGx1dGw1cGdHVzBqbXVTS2NZRm1T?=
 =?utf-8?B?aDlzWnczRXNHQkZjUUd5cTl3b0p1TThlRnZaSTducjNDc1Y1R1h6L1N6UjN2?=
 =?utf-8?Q?PyShl9+F6xvuH+CfQVK2QlLZU?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ad53788-e525-457b-cb07-08daa2317c16
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 15:44:24.7030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IgLsGNwMg5IVLRN8yDIYoKMU3JCkctW0BrV2xFr4Lz7YAvc2SHA++IucWx1nrVY6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB3865
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/29/2022 11:27 AM, Steve French wrote:
> I can add the Acked-bys if you send them to me (for the cifs.ko ones)

That would be a big help!

Patch 1: Add "cifs:"
Patch 2: Add "ksmbd:" and Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Patch 3: Add "cifs:"
Patch 4: Add "ksmbd:" and Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Patch 5" Add "cifs:"
Patch 6: Add "cifs:"

No R-B's received, and no code changes.

Tom.

> 
> The client for server (cifs vs ksmbd prefix) in the title is more of
> an issue for email threads and patch review.
> 
> On Thu, Sep 29, 2022 at 10:15 AM Tom Talpey <tom@talpey.com> wrote:
>>
>> I need to add the "cifs" and "ksmbd" prefixes, and a couple of
>> Acked-by's. I'm still pretty ill so not getting much done just
>> now though. I'll try to get on it later today.
>>
>> On 9/29/2022 1:02 AM, Steve French wrote:
>>> merged patches 1, 3, 5, 6 of this series into cifs-2.6.git for-next
>>> (will let Namjae test/try the server patches, 2 and 4) pending
>>> additional testing.
>>>
>>> Let me know if any Reviewed-by to add
>>>
>>> On Fri, Sep 23, 2022 at 4:54 PM Tom Talpey <tom@talpey.com> wrote:
>>>>
>>>> Allocate fewer SGEs and standard packet sizes in both kernel SMBDirect
>>>> implementations.
>>>>
>>>> The current maximum values (16 SGEs and 8192 bytes) cause failures on the
>>>> SoftiWARP provider, and are suboptimal on others. Reduce these to 6 and
>>>> 1364. Additionally, recode smbd_send() to work with as few as 2 SGEs,
>>>> and for debug sanity, reformat client-side logging to more clearly show
>>>> addresses, lengths and flags in the appropriate base.
>>>>
>>>> Tested over SoftiWARP and SoftRoCE with shell, Connectathon basic and general.
>>>>
>>>> v2: correct an uninitialized value issue found by Coverity
>>>>
>>>> Tom Talpey (6):
>>>>     Decrease the number of SMB3 smbdirect client SGEs
>>>>     Decrease the number of SMB3 smbdirect server SGEs
>>>>     Reduce client smbdirect max receive segment size
>>>>     Reduce server smbdirect max send/receive segment sizes
>>>>     Handle variable number of SGEs in client smbdirect send.
>>>>     Fix formatting of client smbdirect RDMA logging
>>>>
>>>>    fs/cifs/smbdirect.c       | 227 ++++++++++++++++----------------------
>>>>    fs/cifs/smbdirect.h       |  14 ++-
>>>>    fs/ksmbd/transport_rdma.c |   6 +-
>>>>    3 files changed, 109 insertions(+), 138 deletions(-)
>>>>
>>>> --
>>>> 2.34.1
>>>>
>>>
>>>
> 
> 
> 
