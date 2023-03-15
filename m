Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8774C61DA4
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Mar 2023 14:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbjCOOte (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Mar 2023 10:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233169AbjCOOtW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Mar 2023 10:49:22 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1922366F
        for <linux-cifs@vger.kernel.org>; Wed, 15 Mar 2023 07:49:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3LIeJ0e3OouP1eXc+nRdU00wJf8Pz+kb8N3FzFFuTqgtgOSPEEGGenCmcdgTEfUbjynaa1wVCBOsY0FRzM/u/cTqelFF6UKFudPRj/hIQ2XWXIvixzbr2YCWtw1daIwpsTOotWNnt3amlgybVJBhG7pWf1l8/a5AG4ABo8bO2zkM3b11vlg/woNo8HTsBe6FGF8Saby7Rkw/MP9QFLUG9b7QExxVE9xuWjmb692TC7YR+u4pCq8xraKlAXpPOfcBy935uwdHkPebA5LzRGujNY53w/BHamfMlcHsrbmNkxIUWFTLazQMJjYOwBv2WZ0au8LfqHDXHhSxrljfJNvqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LlPnKFM06VIZGIl0Y5b2/HZzlLHymibc6fJbI0u7I3g=;
 b=eUveH5J9AJ+gOSGx26w/fNvZRJ1dCe5FkSGS7bMSgTlngLM4P8HmSoWzkpft3iC+ho7FmAoX0gMkf+kw+vlh79R7CZ3/ZYWS3rTJVFWAmEVB/SjHKudu8IVg/y2HPg86JhQ0XHkyN1ihBnp0HSDAH7xY6HIHAlk8hv3sl2QY1lzheWiWIuRniDJfQrxUBuo9enHXSWVysj3WBLLrJguSvziya/cMbfXd1gtNhukSCWPhKBXjofFI+du0zlIBp5gVlFJ/wjRUtkKeqtSgZeQWoe1zc5DlIKiGxypl990FA0N+0/RgUwGunrIek8THorhYc1rs0A6B93cehUOjs7lQmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL0PR01MB4786.prod.exchangelabs.com (2603:10b6:208:30::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Wed, 15 Mar 2023 14:49:17 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::1d6d:194:ddc0:999d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::1d6d:194:ddc0:999d%7]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 14:49:17 +0000
Message-ID: <5254934a-36c2-18ab-1cf8-5c8f0991e2ac@talpey.com>
Date:   Wed, 15 Mar 2023 10:49:16 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 00/10] Some cleanups for fs/cifs
To:     Volker Lendecke <vl@samba.org>, linux-cifs@vger.kernel.org
References: <cover.1678885349.git.vl@samba.org>
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <cover.1678885349.git.vl@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:208:160::46) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BL0PR01MB4786:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ac390a9-6d90-4b3c-67e7-08db2564738e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yotLaz9QRf4UE+dxhN/BvKW6KjYaj4ykL4hciZac5BChGs4w9EFIsaC2KQzF71yG50NAEL8M17nkqyOspdoBxzJ/9O/VqfRb0DUgvObrVnRMFW4ghSL+0rz1tM2s3CNc+jq0L6YQBCJ544EAfr4+DSl+bMVyhhOKK3s3WqrZwA+f+zeQwwGKOEhxRTZUWp58i9Cx8Erupg06Kw/l3OeDoOdXRTn/UhMd6ItQP6zdcw+oZXvuI85WiEG2bt8QZK6Mf8ODdj0rB8zRah3XEY+AK12bwDpqO/dUr46NiCzhulh7YOHGB32dOQAdsq8ijPeaZaw/ZSUAd1LQM8MK6hEV76i9/ugO6XLQAqsmaamEV90jE3WcPtLJUrPBYDVejVV18dMAdEThM5Ky2OhZ98wVT+AIHQtgI/Cv4Db5q697elMvUfHH2BKT59OH7+H5p6rXuH1W5tVW0bxApcr3KNazN+O7uHC0BjCQk2nO+XrU3jZ8G1/L0iNKKoEoldYHYegFOKMqUmwsBEVqmzoApYOnu2ZaUYPF8OXvW/Hdi7MMiTEy3beUtCvQpe78DVLI86XVX7LE1jj/kvCBUmbUs1wyz8CIx/+ieKdO31o0Mj4C/Lvd6sgsnf2yb7jQiyXSggpgV8vrTkCf2AtIfgYL4AmY29VKKywJjC6S6cpd1e6lRTqHwao5B9QPPjno2SMLPiebAnGbi0nHkx+yqw+FgUf9JlJeaZJ+xuqSF4tU2Qi25dY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39830400003)(346002)(366004)(136003)(376002)(451199018)(31696002)(36756003)(86362001)(38350700002)(38100700002)(8676002)(66946007)(478600001)(41300700001)(8936002)(66556008)(26005)(316002)(5660300002)(2906002)(83380400001)(2616005)(186003)(66476007)(6506007)(53546011)(6512007)(52116002)(6486002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckYyeEtwTUhKQmRuZzYrZkdqMWtxVlhUZTErdVR2QUROVlhTdmdzblM2YlVV?=
 =?utf-8?B?N1AwRDF4OS9KU1NnWWFaT0ZTem53UkJia3VqQjZhcy84T0VmWjNUbm9vWldV?=
 =?utf-8?B?bjYweVNFeWNibkdGT1c0dFVHUmNLcmc1Y2pXSXRlRm1TOWRRZHd1ZnF3K2d1?=
 =?utf-8?B?K0czR0ZMamVFcStoc1FnTTN4VGNZS1luKzhCNTlwYm5abmhkWDhHNkI4Szc4?=
 =?utf-8?B?TEc1eTRqVUU5b3IwanhwMWRGM2o0aEQvSTJ3NFl6b3Y5RFRJbSs4OU9EQUN3?=
 =?utf-8?B?SWhXTmNKTEoyV2NzWW9LV2t0MVJCdXVXUkRQendIRG9XS3pFQ3ZkcVc3MGV5?=
 =?utf-8?B?ZGZRYzR6MnZvcVc4MkhiY1JFMmlpazdaY055NmN2Q25WZ3d1eXJLUDNVaFQw?=
 =?utf-8?B?OGY4T2V0c0NBNldtM1pJbTFyTExVczBDeU9tS1RmQStubXNpV3U1UXpBK2VQ?=
 =?utf-8?B?WWlBdmZjaUJ2UyttMlhGbFpCUnR1UHJXNEdKOXJySGNPdSsvQXVxL2NGOUVm?=
 =?utf-8?B?U2pMb1ZpZGlsdjFWdUF1clhNQkttaFo5MUpMZWMxTG5wQmVmZ2FFM0kxVkc4?=
 =?utf-8?B?SVVCNGZJVnRtYlVrL0tFN0hQUk5hZEFMNlBqalM1ckxoY0NMN2d4enpIdUkw?=
 =?utf-8?B?MzVab01CckdRLzh2V1VxZHZOWWltSkZnSVRBU3YzRno1bm1kamV5YVRleHZz?=
 =?utf-8?B?dGU0b0pjVTJwMmRtcDJmeGh0NXlEOWJTQUR2dzdOdnlqZm95bFZ0d3ZUL0dP?=
 =?utf-8?B?K0xiekVHZUNkUzNNczc0aUl2OHdvQkFUREQrdUdxeHlyT2orYVg3Sm9sK3dJ?=
 =?utf-8?B?ZkJpTmgva2hacWJMQmRBaHVBdVFhbXV0Z1NDeFFNNitjQVN3ZFJBV1BhbVdM?=
 =?utf-8?B?ZzlMVis0YVI3VVh2UXUyWXRtTHRRM2tqS1U1d0Qrb0x0cEhuR2xTT0gwQVRR?=
 =?utf-8?B?eTVmVEZzeC9tRE5BaXh4T1RHQ1RIcmlKRkFSNkFrZjg3Wk8xL1FBTzJjMmZG?=
 =?utf-8?B?OWF4VTRjaU54STI3bG9oV1QrTW1Fa2Frc2w2cTMzd1hDcm9LOEsyU0tZeWVn?=
 =?utf-8?B?Vk91U0dCakhMMTBDaXBpRUp4emIzVnkwYVUxaStMK1NybVBxV1N2RjV6ZGt4?=
 =?utf-8?B?VFMvcjk2dWxVb2RaWUJyMHp0aGtIRHczR0NYenF5ODhkcXl4RFc1QVhOR2JG?=
 =?utf-8?B?QzNRQkt3V3BKMElCcVZmRWw3UFRiWUhUUnNOdDN0cUZjVWpNWEswc1FtTWtF?=
 =?utf-8?B?SThvVXFLdExLM1BMUkl3YnVNN1p6SEZJNlBERGV6RlZPYWVINHNibkpKd3M1?=
 =?utf-8?B?Q0NKY2I0bUpjMXB5Y25sSHFJYVdJeU1HejlSYXJUWXJ0ZWdwdFZpRHFGQU1t?=
 =?utf-8?B?Nzl5MUhURi9wNFJBWXR4SG5NcnVRR0x2SzJnTno5TElOL3ZPSGlOWUY2WlQ3?=
 =?utf-8?B?T1BUQW5TL05ZWXdsL2h3VjhTVVRsY2Y3TXVEZnZzR0pJTVJZc3VlMEMvYVZq?=
 =?utf-8?B?anFZODRnQmI2S1o5aklFd1lYdjFxL3pKK21NaTREdy9YVXVLeEJTRkZWVjMz?=
 =?utf-8?B?M3BPUVVEZmEzYkFWSXlzNGJpS1FsckYrUVIvVHNRc1EwMis2azNxTUp2anBG?=
 =?utf-8?B?N0svVVJReThta0ZEd2JuWjNDcnBsQUF3VVVPTjNSZlBaanBDUXA0RnJyRldN?=
 =?utf-8?B?RnpSc2I4SUF5bDlDUzdGYVViRVpZK2pva2s1bVNYaTlOeW0zRWtIdlNGSytn?=
 =?utf-8?B?SUtrYWVmMm1BZUVZM3VXNXhac2Vyd2RSY0F4K2V1b2VXVURnVHVxNFlQTGtz?=
 =?utf-8?B?WU9CaWVuNTM5aXhRTEs0WmJLY0pwTVpmeW9RbzVKREIyVDZJSW4wQnVEZlBC?=
 =?utf-8?B?WVZzd3I2Yk40K3ovTzhKY0oxTmhjb0kwTURlZnBSektINFVsaTF3OWZYN0Va?=
 =?utf-8?B?VjVJb0lSbTkrVEx3ZDM2QzFRM0crTHltOGZLSlNGOUdtSGdac2ltalhKVklo?=
 =?utf-8?B?cU9qWXk4Y3R5RnNIeno5bFNORnl6R1UyWjBsMmVxRzRUUmRMZ0FwYXJ3Q2JN?=
 =?utf-8?B?QU9xZ0xSeE12Um1IOXMvL3RCdWNZMFB3SDZkMkZtNHIwNUdrYm05ZTdwOVdk?=
 =?utf-8?Q?SKp06ZkRdCmYy/Cutk5B6EZ7h?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ac390a9-6d90-4b3c-67e7-08db2564738e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 14:49:17.1070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pCr5WFWMOCpfXxL41b5F+KhZudDjqlhzCBY/dzz/NPx7De+0BEx1pKHOy0BMfXZz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB4786
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I like all these changes but I think #5 should be split out
into a standalone patch. It changes the rmdir wire semantics
so it's not just a cleanup.

Acked-by: Tom Talpey <tom@talpey.com>

On 3/15/2023 9:05 AM, Volker Lendecke wrote:
> These are some cleanups and simplifications to fs/cifs which helped me
> understand the code a bit better.
> 
> Volker Lendecke (10):
>    cifs: Simplify some callers of compound_send_recv()
>    cifs: Make "resp_buf_type" initialization consistent
>    cifs: Slightly simplify cifs_readdir()
>    cifs: Slightly simplify cifs_readdir()
>    cifs: Simplify SMB2_OP_RMDIR with CREATE_DELETE_ON_CLOSE
>    cifs: Slightly refactor smb2_compound_op()
>    cifs: Reduce copy&paste in smb2_compound_op()
>    cifs: Avoid two "else" branches
>    cifs: Store smb3_create_tag_posix just once
>    cifs: Use switch/case to dissect negprot reply ctxts
> 
>   fs/cifs/cached_dir.c |   1 -
>   fs/cifs/cifssmb.c    |   6 +-
>   fs/cifs/readdir.c    |   6 +-
>   fs/cifs/smb2inode.c  | 163 +++++++++++++------------------------------
>   fs/cifs/smb2ops.c    |   7 --
>   fs/cifs/smb2pdu.c    |  92 ++++++++++--------------
>   6 files changed, 91 insertions(+), 184 deletions(-)
> 
