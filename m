Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A4A9C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 16:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244887AbiCUQsO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Mar 2022 12:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351393AbiCUQru (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Mar 2022 12:47:50 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF72516C0A9
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 09:46:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nn3W74/J2c/Lt2O/Ddyb6I0spwdd1dcKVB5HJw8m5jXx2GmWrbCEIc/m3NA6D5rGWladE3XiaCFgEyjaEa89vmN3DkQe6tFySLPri7XCLHNDf3yF2brLXZaU0ISa8GrXpawqoplnsi4yd0Klb98UCwjosP2+RIj/z92UtMIm/sWnukQjcUxO67JynAZHA5zf8J3NYo5Al2tC1puSNZK5X8QbYQ1Lw1HVHhMdCqKrATAJndu8CWNlEAE0+dKL/wyY/pI0qjlAxovc3d4WmDb8HgmZhPVFLSZxCLeIVJFWXA8dHyMwZyWVCHHNO3y/rqBAAV714DAQSYJ9mgqnB3vYEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i1kHyCNzUIRCkyD1FOCJ3WZq5Z587d30niQFMB4vSbY=;
 b=Kf0XZzynlHvwCgJmL9i6sKh7TCt0ZOkgeMuv9WHiujwkYIj4y8JUAIxfBp2uZRt+CI344S93PmlarHkWG9qCkXhaUE3DFThTTSh+2Nu8PKP2LFkrHqV8pGcrlkvkPSLZqV33lZBDt/qCWSKzylzlWNuPsZsIBSHTWp5kjL0oPzgVvUF9k1r2OxJF3mOBlOD73smShvfo+ivb+qyuGQ0GFtpdIkUh8y9HsDeH3aLFctGJwttAAZVMoUhntGBBtY9qTYzg6ZTkpIB0WpjhN37mgxHAxnmC9ls2qhQt/pLp+AwEkYmcDtZRTtebnujXGAkyKB3aC7hKW3lxWQ6vb/7aRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB4021.prod.exchangelabs.com (2603:10b6:a03:15::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.14; Mon, 21 Mar 2022 16:46:21 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d%4]) with mapi id 15.20.5081.023; Mon, 21 Mar 2022
 16:46:21 +0000
Message-ID: <8b39a494-215e-8984-34d1-773f2e77547b@talpey.com>
Date:   Mon, 21 Mar 2022 12:46:19 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] cifs: fix bad fids sent over wire
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
References: <20220321002007.26903-1-pc@cjr.nz>
 <6ef3f7db-a6ed-62c7-226e-b2a20ef5b294@talpey.com> <878rt3v66c.fsf@cjr.nz>
 <2962692d-a0b5-25f2-3053-7e21620639c9@talpey.com>
 <CAH2r5muAKvWknawHHYPGpAQ7oiQqTEBaskB8taNK0f9msPaHuQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5muAKvWknawHHYPGpAQ7oiQqTEBaskB8taNK0f9msPaHuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0206.namprd13.prod.outlook.com
 (2603:10b6:208:2be::31) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04ecf2f1-1e5d-4920-5a57-08da0b5a540f
X-MS-TrafficTypeDiagnostic: BYAPR01MB4021:EE_
X-Microsoft-Antispam-PRVS: <BYAPR01MB4021E9B503FE6FE1B7E57FBCD6169@BYAPR01MB4021.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tvcfgRaH9pwe0yGw4BgcVPuP7sDYN4LpwvbgfHuWsBkNTAb+oIL7BbbhS9DiU9giGf18UJ5W+R40z5+LMjqBinGS2IXHZgh4MQJz1AG74I/QZiQqzkM9lee2ekPX28nQuDS/6M5yI6FjEPJlRh0uGPcC7e1TpaF+0OxR4u+0sBh1Jwq7yl5Ps2opi3kOkXFFMiKdzzjkV36g6JnasJiZqgsnBs/FqigMXV7pZHhE1JdQX5Ucmlot5PAm+AJEAn1x4c9RHm/PBcqxU1EvCSwr4TLzzM/ksYmIrUchu40AUOW5iuL7I7IQ335mC6h3w421tFXsOwPb6ekAwv+aoUw/BDIYrf1PhPxLQLfDfvIkOCPjMXvJaXMPY56gsFNAFbiloBex83Kzcdkq4P0BwcVOEP3bPXQU3zij+mNWmKwjPGw1OFiRFGplSKYeRiu9k4lZE12oxm8hPuljAGOh+Kx/4RVMIyGX6ZrlFLaORPz4rhKuPhsO0Y1S50C6S1EdiJYNT13LWnduq/ZK7dPV4uwDEk5DPco6QchLpwWoZdSkUYm8fExFRTp2r61h0DJg6W0zbQDs/kqgv/LKa1SifpcrrTMndimD3c7hNOGnqQawlHVHLYU5rBdazhKe217+BidsFat7zFO0zcIZajwlPiW169xx9VoKI7QI3O7qdYm9r3OHRIccsxbPrFWQ/7tNmid/biVfLZ0hS1ZLPZnDUSIz5nO1hPzT+zG2Pbkp2CGbjLk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(39830400003)(136003)(376002)(346002)(31686004)(66946007)(66476007)(4326008)(66556008)(31696002)(86362001)(316002)(6486002)(83380400001)(36756003)(186003)(8676002)(6916009)(2906002)(54906003)(2616005)(26005)(38350700002)(38100700002)(6512007)(53546011)(52116002)(6506007)(508600001)(8936002)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RlJCcGdyaDBOcU53Y0lKSVJhUDlkekhMVy9SQVBld29DZUJNdmZWUU5mTWdJ?=
 =?utf-8?B?QlRtb0pKd205U0M2UnMyeXBRZHNuVjZwcmdXZHFOblJRalpXeWRNVFFFRnJY?=
 =?utf-8?B?MmJjTzlMazZEUDVlTkNHa1pjMkZaQ3lXUHQ2Q1BqVjJyWTlrTmwyK2x3WGx5?=
 =?utf-8?B?dGxxWTFBR2ZQVnl2elJ5V01Uc3l4Tk1ZZkRHN3NVNWJYenNCSUlDQlZ5cE42?=
 =?utf-8?B?TSt1Ui8vZGVYcDJHbTJkd0I2TVhwUFNPbHJVNzUySkZuUXdKK1hDTzB4VnMr?=
 =?utf-8?B?STh5aW81T0NQYkFGMnBaWThhVU9QMndxQTgwSlc2UGtFTHM3NnhHaDhva3Zi?=
 =?utf-8?B?ZFlweWx3ekdDc2lIMVB2amxVMy9Jamp5aU15N0hIYVFmR1Q3S2RVcDhXbEho?=
 =?utf-8?B?V25wNXlZOGZwNTRSOG5EMy9MeFNxYUhRYVhnOEUwcXhxN2NqS1o1QkREbHRn?=
 =?utf-8?B?ZlJFdXVuQlgzRU50UGpmbW1LL21tNDdMb0o5WUlqVHBSemVjS0VsYjdVQVd5?=
 =?utf-8?B?QnRodnFWbEJtRlpSd0NhUzFZbkdON3dUTXB2SlFqRHRRK3RWOGYzUkwwaEJr?=
 =?utf-8?B?ZEVITFpjUURXQmdVRHJFc1JNVGYxQUlFejd1cEZpb3JDTFZGVDNTdVloOG9q?=
 =?utf-8?B?a2lOcHpTY2tiR3N0TVZiNXFkeUtKdkplZ09EbGhsamlNc0tJcnpJQjQ0d0g4?=
 =?utf-8?B?aXZHd3FjZTJPbUlWMU1ISWh1cWxmK1FBcUlGYmkxRXYweFFvWHk0SUVPU2tK?=
 =?utf-8?B?emxad0hmdkhsMkxXSjJTcWlXaTk0WkpCRjVNSFZqWXl6TWl0ZkhRaGdSc1N2?=
 =?utf-8?B?bkFVV1dmZk5lbjA2L1FncVRtRTk0bEVTdkFMWVZJTW9oS2UrS1dONmVXMGFm?=
 =?utf-8?B?NE9EaW5VRUcxK000aHRXOTlyR1BVd2dXREI5VzRlM0ZVdUUzbW5vOGJ1anVz?=
 =?utf-8?B?ajI1MEZ2dTVQZlEyQWJtSmx2TUtSUEFldGxvVVIvV2VPVTlhWjFjYm9WZXFL?=
 =?utf-8?B?UitIbGcyMGZ0MWQzSUxPKzNhenpDb3Q5UmVpK3FSV3JYdWxDWC9YczVFWHU0?=
 =?utf-8?B?VTVlcjlrSVV2Rkc1RUdvYnBOcG5GODhENVdpczhSQUFWYXpwNEdyT2NHOVpl?=
 =?utf-8?B?a1RRVzJhWUhRb1VoczJvMkNZb095cWhVNjdpcHBHWFRpbkJwMUNVSHhHYXho?=
 =?utf-8?B?UUpPS3lFc05kQzViNTA4cWMrWnhYci8xVTRUbEJmMklLTjRSMFZqM3c4OXFl?=
 =?utf-8?B?eFdDMUhvV3N5Y0YrOWxzYlI2ZUYyazBULzI2YWFqUllIblM2eHdEN2pDZmtr?=
 =?utf-8?B?b21rRmlDYnVZZUpLT1M1dzVKNnJvRVhWVGloL3BoMGc3TktrYXQwMStVVFY1?=
 =?utf-8?B?STFtTUE2ZmxRVkxPakxraGdFY0RONlNLUnZTb0hsUjJwbVBJWnJyS3BFNjZi?=
 =?utf-8?B?dzcrYTR4cnhQWlJNN3JTaFdIVnlFYm5zam44SE94eWtmWFkvTWNxWUZYMWZm?=
 =?utf-8?B?aWo0ZFlqRW9wb29MUWpETnowL2hDdllOSTB6M21naHJvWVg5b2REVVVuY1hq?=
 =?utf-8?B?RXB6cS9mMlp5d0I1YlJwdTQ4b3lDYXJTbGtxeWJPUGZ4M01TakZaK1k1dHhS?=
 =?utf-8?B?WmNaU0JSVUVpMUpsc0tPKzRXUEYzM0NBK0VreUNjc0h2MmY1NGZjZHA2bGQ5?=
 =?utf-8?B?bWVBQkNaNFR0YitBallMaEcwUzZPMEY4OWNyaTNNUlUxZ2U5NUVabXNKdFNj?=
 =?utf-8?B?T3VVUWN6NFBiWXN1UnFOK3N2WXpjM2haQ0xGby9SNXVUc0dZWDBOMlBEK2E1?=
 =?utf-8?B?dk9PQ3ZaQnQyOVc3V0ZrUm9lS3ZHQXNNRTFUWFg1UHV3bGRYYkNBWDRMd1NU?=
 =?utf-8?B?VzRpelcxaTEvbWM2NlBXaDdMbzBkaW4rU0QrVit0ZzVvUVozRzQ4cEJqU1JE?=
 =?utf-8?Q?AwPBE2ClOG/tUfk3KE4A/cd8UV2skUtt?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04ecf2f1-1e5d-4920-5a57-08da0b5a540f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 16:46:21.4100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VtEnjcXbu1QqU/mT+AZy/EDRka8YZuyrenz+PuUHLYnYiEcSAI8vGCca9tQgqcMV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4021
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 3/21/2022 11:01 AM, Steve French wrote:
> Wouldn't u64 for these with no conversion (the original code was 
> consistent before half of use of fields converted to le64) be faster, 
> easier?

I guess that's what Paulo is going to do. It's certainly faster and
easier, but I predict it won't close the door on future code issues.
Someone is going to try to byteswap, or treat it as an integer somehow.
I'm advocating for correctness. But fast and easy are your call.

Tom.

> On Mon, Mar 21, 2022, 07:55 Tom Talpey <tom@talpey.com 
> <mailto:tom@talpey.com>> wrote:
> 
>     On 3/21/2022 8:30 AM, Paulo Alcantara wrote:
>      > Tom Talpey <tom@talpey.com <mailto:tom@talpey.com>> writes:
>      >
>      >> On 3/20/2022 8:20 PM, Paulo Alcantara wrote:
>      >>> The client used to partially convert the fids to le64, while
>     storing
>      >>> or sending them by using host endianness.  This broke the client on
>      >>> big-endian machines.  Instead of converting them to le64, store
>     them
>      >>> verbatim and then avoid byteswapping when sending them over wire.
>      >>>
>      >>> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz
>     <mailto:pc@cjr.nz>>
>      >>> ---
>      >>>    fs/cifs/smb2misc.c |  4 ++--
>      >>>    fs/cifs/smb2ops.c  |  8 +++----
>      >>>    fs/cifs/smb2pdu.c  | 53
>     ++++++++++++++++++++--------------------------
>      >>>    3 files changed, 29 insertions(+), 36 deletions(-)
>      >>>
>      >>> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
>      >>> index b25623e3fe3d..3b7c636be377 100644
>      >>> --- a/fs/cifs/smb2misc.c
>      >>> +++ b/fs/cifs/smb2misc.c
>      >>> @@ -832,8 +832,8 @@ smb2_handle_cancelled_mid(struct
>     mid_q_entry *mid, struct TCP_Server_Info *serve
>      >>>     rc = __smb2_handle_cancelled_cmd(tcon,
>      >>>                                      le16_to_cpu(hdr->Command),
>      >>>                                      le64_to_cpu(hdr->MessageId),
>      >>> -                                   
>     le64_to_cpu(rsp->PersistentFileId),
>      >>> -                                   
>     le64_to_cpu(rsp->VolatileFileId));
>      >>> +                                    rsp->PersistentFileId,
>      >>> +                                    rsp->VolatileFileId);
>      >>
>      >> This conflicts with the statement "store them verbatim". Because the
>      >> rsp->{Persistent,Volatile}FileId fields are u64 (integer) types,
>      >> they are not being stored verbatim, they are being manipulated
>      >> by the CPU load/store instructions. Storing them into a u8[8]
>      >> array is more to the point.
>      >
>      > Yes, makes sense.
>      >
>      >> If course, if the rsp structure is purely private to the code, then
>      >> the structure element type is similarly private. But a debugger, or
>      >> a future structure reference, may once again get it wrong
>      >>
>      >> Are you rejecting the idea of using a byte array?
>      >
>      > No.  That would work, too.  I was just trying to avoid changing a
>     lot of
>      > places and eventually making it harder to backport.
>      >
>      > I'll go with the byte array then.
> 
>     If you want to reduce a bit of code change, you could let the
>     compiler generate the loads and stores via memcpy, with (perhaps)
>     a struct { u8[8] } instead of the bare array.
> 
>     Tom.
> 
