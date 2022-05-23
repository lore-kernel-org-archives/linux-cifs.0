Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B04AC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 23 May 2022 13:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbiEWNhh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 May 2022 09:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236324AbiEWNhf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 May 2022 09:37:35 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60F85403D
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 06:37:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+QyoWrDE20uuDgH1bP65pFaklzLYzeWCn7zeAxaoYkizhPsgGcCeMqqieVt/XnyGPoMNxff6QeI76lY9bL4hsmrF+4HNBNHGySvwy5vQcA7Z1yUhnSTVlr62yKmLcngVpsW+SZyKe5oiAh2heNRF7I5s0RpWhFnRNhL+Q8xMq6mm/qM4spSW9FSHUNlfcWyb3WY9b6pGVKo2TuH4R8E7ZWQq/WD/DL82x1+C942dSCpenMtwEFxCXXFqpuw29g05h9ysDLy+QCkCb75kHicFOw1/wI6gFTqMQOQOt1rDT/y3ayPGJnroLsUK24oBfCtSuCAxbBT9IfygCJh747GWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xm7XndwcohLYGbJJTwbTAn8nKjwM4KLVynBfwBLotwI=;
 b=Ol1t5zSGZ7ludmFGZI4sJZfLWVvdzMDDA27VXUNypvsUDu4V8g1Aw2dHtfrdccOAqoSg23vvqrR20Bgu61A64O7xUhdFo0+Wshlv8+gm88O9+XdEB4Dfwzy3SrADIZeGaqSzxgzvwo57d0abCWv+uElCamSD6JIP2xwAqknLwA40JjeK0IAfho3ktKz5YsZwnyjYtp6ICLI5Lph8t/ippuyJZXr/p22tadT2tIlV/nh4AAbyHwcTT9noCz8nDeHlGQQDVYjamYy9+M1VNefPisXC8dLPpMMLZyCSlJ6AU9smS7OEkWEtD2tfQ+n+5729npDCVvg0WSJSlP3IVybPZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN6PR01MB3631.prod.exchangelabs.com (2603:10b6:805:21::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.14; Mon, 23 May 2022 13:37:32 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::f135:e76f:7ddd:f21]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::f135:e76f:7ddd:f21%3]) with mapi id 15.20.5273.023; Mon, 23 May 2022
 13:37:32 +0000
Message-ID: <9cd02802-c593-0246-43f4-43047eb06fda@talpey.com>
Date:   Mon, 23 May 2022 09:37:31 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: RDMA (smbdirect) testing
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Cc:     Long Li <longli@microsoft.com>, Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com>
 <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com>
 <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
 <84589.1653070372@warthog.procyon.org.uk>
 <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
 <747882.1653311226@warthog.procyon.org.uk>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <747882.1653311226@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0077.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::22) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bd4d8a3-5f53-4b9e-b3ea-08da3cc1637a
X-MS-TrafficTypeDiagnostic: SN6PR01MB3631:EE_
X-Microsoft-Antispam-PRVS: <SN6PR01MB363122C54828018EE54BC22BD6D49@SN6PR01MB3631.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EvCAj72s3Bs0n2jW7/K69eMeNwPqLy2M0fRZgE50DxpDoxFYE6kcpmy8E/nS89BpdfIAXDSvKTx/HFEPky95j1r2oYRyBdkl2e+RzaWFfRRE4yvLpYBKObNFy5f7MKQqjZt7SIaVqu+Ly5xD6Ix/rwruFWF5YK1MAx3MjhI3zONmy8f4cNBd9jcjBUi1hd8DYTm8yEGDv8VPbRBLc4kILrWhl6MNc+0nQMmnC35JJGihdAm+9/gCv4GDDLXiDb7Vt7QP1cZf8MJmHHgcrwG7lJrd8BI6fRfOjgAEc4mGvj1IgHzge19pxZKQlSwpp1pxZBq6TqD4QOyc3mJuJR/hckalYmmkURwbK3gPjxqcem52vx/oeiq7cuG5sD/3vVCNT/2y6BsTdqyaWAupSw2z8lVKwXz76npGKjecAoIZikhUL3xLY4kJReNZvWntqKrjSvTT2RAqEUhxrbykRkr0EEoQ2eg1Qorzlbn0ggC+O/1VDOMbmCYl+k64Il708/InUe6F0RI9C02ll4xHpSQLNCwEN30Mnlb5eshna68WQDnq+kYvSg2ZolfGkqD0LprUgdFDoqx9O4A5h1JWNUEFej2Pae+1joefTF6FCUszQycpJkc+Q2rXMDTbu1T7cI9NPlva5+ZebqOkZHuw0SyMKIDhAojnjHkzQ8c6cwMv8xIaNL02TYrIRpWU7lDMv/vu8e69Y4LDKTV8wtF0GHqKFDnUb5ChpJe3I1fjyw2s0y0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(376002)(39830400003)(136003)(346002)(86362001)(508600001)(6512007)(8936002)(6486002)(38350700002)(38100700002)(26005)(36756003)(316002)(54906003)(110136005)(31686004)(186003)(5660300002)(41300700001)(2616005)(52116002)(4326008)(8676002)(66946007)(53546011)(6506007)(2906002)(31696002)(66556008)(66476007)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2R3RTdJdGlYVGp5VHRrVit6b2RwY3JPZ1FidUlUTEM4Y1ZMY09la1NBaXZG?=
 =?utf-8?B?aGordWp4ZWdPYkhwK2ljK0hpR2ZJcHhKcUV1NmVqcjIwK2ZlMWV2RE55NzNL?=
 =?utf-8?B?TmU0RmROMGNXOHhqczVIb29QNDI2ZFZsYXl4UktDaXdjOXFiM2VYN2YyMk9W?=
 =?utf-8?B?bEJ6emY0Y3B2L05DYmR3WUFzV2ZjUEpTZWxsd2E5YjdZYW9UbjYwVVp4cHM3?=
 =?utf-8?B?eFA0ZFBGR3AxZXlOeEdZQnJXU0x1dWxoWWFldndhYkVsYi9pa0dpSlRJZndW?=
 =?utf-8?B?RGFiN1Z2djh6bEJXRjFXZCtXMFZRd24vRGxMK0RmZ3puSUhUNjZEVmdWWWE4?=
 =?utf-8?B?SnFqZ25WbG5BTUxUeXl6bEJUYmNZUVYrYUN0VmJkczJoSE5tc0N0SFF2R2s2?=
 =?utf-8?B?cW14WWJsZXppaGhqRGpxdVpQZjV2NXVGMWZ1cHl0dHhHdy9KTmN3Y29YQ2t3?=
 =?utf-8?B?clJiVlppNnB3NDlyUlFHdWc1Rm1wSEpZZUVOR2d4VTVGVTN3VDMweXJrUmNO?=
 =?utf-8?B?U1NwaFRveVFDaC9XVTNKL1JWSkxrSjFGM0Y3YkY1SGZqQTJFS20rbXJDR0Fm?=
 =?utf-8?B?MHV6Rms1aVRlakZMUUtjeFhnRXVSSmpsWkI3enBOU213c09HelR0VndJYjBr?=
 =?utf-8?B?VGhaTURGTG5NTlRNdFdkdEx5TWhwQ2RtalhFSWpsSEh0SENHbE5WRE04aXZH?=
 =?utf-8?B?MjNOK3hyY2h5Ykd2bnNXY2tZVnZteWtxQlRsOFBkSG8rSnFWNU1lWXVja3VB?=
 =?utf-8?B?OFJzRUtIYlc3cHArZkMrUmF2Z2hBbk5DUkhObzBUUHdxUzV3NTJSa3orcWtw?=
 =?utf-8?B?aUp4eCtYYWJ0eFJiT3Zqc2JXdDc5UTB2L3ZVa2pSYS9DYUZvNXR2TUMrL08y?=
 =?utf-8?B?REc1cTVFaWNLNkJzOURncWlsQisxdWdzV01ScHNmU25hZW83YXhDYXZvVW9T?=
 =?utf-8?B?cUJkdm5vOGFvQ01qU3RJaytFQUNUVXdxUE1nUUtzY0Z2a2o1UkJMaGZVclZX?=
 =?utf-8?B?czRkSkVIbms4aGV2ZnhUWWxhZStaS0pLdERLUW1hOE5CeHh6cndIZWZXT3h0?=
 =?utf-8?B?OWtRZk9YNkxzSmwzdzVpa25CNjNtQThvV0hqK3A4NlFaUnV3MG9hM244djl0?=
 =?utf-8?B?UVA0VGZUYVdqYzVuMXJ6THNyYnlUaE0wd3BLWHpPNlNHSTN5QWQ5SzVQVTln?=
 =?utf-8?B?dmhHeUVTbFRCSWY5aEdaUDNPOWp5cFU5clhKMjMySjNpOFpkQXdjT3p3akhQ?=
 =?utf-8?B?NU1CWDJJOTZabmMzRmVVbS9mb1ozSDVTYmdHanJiV0l0TE9aN3dhd3QwNFh4?=
 =?utf-8?B?MFRSdjZYQmZhalBONzg0RnQ5RDRhbkVCMFZWMlhSWGtCQzl2UlY5RzFUeWJB?=
 =?utf-8?B?VW1GY2RJWDZ3ZVBQc0RQdVpURm5uTEJKMjFHM0Jsb3NYWVljenlUckJEL2Mz?=
 =?utf-8?B?MzBFVkJGcXJZQzl4UFJDQVVqSUlXcld2V09IY2o1c0VWQmpkamptL2t6QjBq?=
 =?utf-8?B?TWF4TFRQV1Yva0VYelZPRVpUa2JjYVk4ZEloYkFqQWVrUksvT3ZWQVQzbDg3?=
 =?utf-8?B?VmJ0NDdGYUNMYkx5ekxFUzBYTTlnTUg0TjVZRVNhaGRPWUR5RFZnYkJtL0JI?=
 =?utf-8?B?Nk9PZzdSb1U1UmVsMmJzS05UM25sZXY3cU4xTTN5M2N2eFNxcjBvME9qMFM3?=
 =?utf-8?B?cTlxZlFBVXc3M3ZiNEk2bkFabnlVKzJYRThRNjl6Yy9hTnROT0NhdGJpMnpy?=
 =?utf-8?B?UFJmdHp2Ym1INDh5TFdwZnZFVTcrYmtRaG1IZHhpcFBFT1lNQmJsNytiUVcr?=
 =?utf-8?B?NGd5QUNpOEVmaXJDYm04cXdnajRTeklRSzBWalQ3QjB2N3pwQ2lEWm5mN1k0?=
 =?utf-8?B?VFVwTWRLem5rc1JHWW9ONkdlalhpc3RSanRyWkI5VHhlbCtiWG5FRndKbldO?=
 =?utf-8?B?Z0JMb3Mra2FrNlVvTFV5WEk5SFFCWGx5TmhqZXJaR1N4T2RKcTJNUXZlQ0E2?=
 =?utf-8?B?VFVaOSswdjYwcytJQXhsNTdlZjFEZGd6ejVJRnZtSGE4Mk9SQTBzL3piSlpx?=
 =?utf-8?B?UVJITmZucjFiL04wZytjaGo0QXZjalkvUFVsNWpPcU9lTk16VFMvVXh4QmFB?=
 =?utf-8?B?SXJ1eHdRL2liM2pnbXJhRzI3NmNuQWUrQU1VVUEvMzNCMDRmNlJ5eTcxV1Bk?=
 =?utf-8?B?WmFQNTJmZ1ZQSFJnWmxsNFdWWkl5VkxEUm5BOGphWnFwSUZZSSs1Q25tMzZN?=
 =?utf-8?B?M05kdlhsLzZTZVB4VThRTnF6THNNL1F4ei9mSHZMeTlQaU5mMy9YTkhjLzcx?=
 =?utf-8?Q?FN2mZEPkrI7OZp3c5n?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bd4d8a3-5f53-4b9e-b3ea-08da3cc1637a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 13:37:32.3405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GVsqPiLgBVPxOquGblGTqP7BllAN0V/tSCQkM2xfLgPxJdVxozGh/aXbP8cbJMjz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB3631
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


On 5/23/2022 9:07 AM, David Howells wrote:
> Namjae Jeon <linkinjeon@kernel.org> wrote:
> 
>> No. I was able to reproduce the same problem that David reported. I
>> and Hyunchul will take a look. I also confirmed that RDMA work well
>> without any problems with soft-ROCE. Until this problem is fixed, I'd
>> like to say David to use soft-ROCE.
> 
> I managed to set up soft-RoCE and get cifs working over that.
> 
> One thing I'm not sure about: on my server, I see the roce device with
> ibv_devices, but on my test client, I don't.  I'm wondering if there's
> something I need to configure to get that.

Probably not, but I'd recommend to avoid wading into that if your
testing is going ok. Send a report to linux-rdma and let them know,
if so?

We are told that RedHat is removing SoftRoCE from RHEL9, this too might
affect your future testing plans...

Tom.

> I've attached the config for reference.  Note that I build a monolithic kernel
> so that I can PXE boot it directly out of the build dir rather than building
> and installing a fresh rpm each time.
> 
> David
