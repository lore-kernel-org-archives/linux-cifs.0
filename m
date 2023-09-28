Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4841E732E7
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Sep 2023 16:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjI1Qif (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjI1Qie (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Sep 2023 12:38:34 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B491698
        for <linux-cifs@vger.kernel.org>; Thu, 28 Sep 2023 09:38:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D901l0jbnv2NaJIGuvLFkra8gZOjxEWRC+dboJ4DRFWKu9t3gdYQIPJmE0elfqUMruV2NgscxxhXZcyYZ9NxMqV9Ku9GJkaz6EuS4Ohyhk6P2hUHwkIZ7Zs3uARY4IcrOo+W3akX/dKyZR0nlxzyVoLS9FSoPj/VWCWxpUdnZAB67kPYGYZYnAnfyx1rNq8iTjfKgTgHsSzq7pmln8vGLQm7TGXA2w/cZo6T34qfrtvxw8FsjmH2vWUR4DUQ485Pa9Ve45Gu148FsO6CxvpeGRsKS5QG+3kCdo1R7G2gGVMjQhUOk/LuwhRzrCG6iy3r6vl6zh5qW0ckoHAq7/keBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NAt0Rcv7fCr0Vj+TmusMIv8qcNnX1bVMfDxKEJF+Rpo=;
 b=hgW+5zXHadjmE1Y3QHaovYaI59RkLxAJLYQ5DNd2hZ1eFhQSdCCseWI7h+mF5JsveLWHXGyAyOdC2YNii0lrY3iGj3rWxqDmTYn5FiC9dXzCLPIWocZTHgOFSEqtH5wcJKcVUIGbuXYJD0y1iRokA1aJb1YgUDNs626/y2n+7SW01MiozN3pRfNXp/qvD4RygX23LnLsKniTpwqzI34YfS8j9lcN6iDI6KwEGR6+LS8DZ+uDHDCSTy9004SeqSkGswXYCVYoph7ekcyv5ggAXUdy2tGyfMDzBqysB9B7a+F7MQYPOKytmI4zBagV42hRFVCYLXvMv02oF/AJYiRm9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SA0PR01MB6474.prod.exchangelabs.com (2603:10b6:806:e7::9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6813.23; Thu, 28 Sep 2023 16:38:30 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::cbe6:1667:cce0:3485]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::cbe6:1667:cce0:3485%6]) with mapi id 15.20.6813.027; Thu, 28 Sep 2023
 16:38:30 +0000
Message-ID: <d7dd886e-0669-b3b5-5561-638b78dadbc4@talpey.com>
Date:   Thu, 28 Sep 2023 12:38:29 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] ksmbd: not allow to open file if delelete on close bit is
 set
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, hyc.lee@gmail.com,
        atteh.mailbox@gmail.com
References: <20230927143009.8882-1-linkinjeon@kernel.org>
 <6f702d13-6473-844a-5873-9c70c909ca8b@talpey.com>
 <CAKYAXd8T7Rc1wh_aM0wyz7L7Mc-g0AYfbqHfjQ8mBe7fmMmYaQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd8T7Rc1wh_aM0wyz7L7Mc-g0AYfbqHfjQ8mBe7fmMmYaQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR01CA0008.prod.exchangelabs.com (2603:10b6:208:71::21)
 To SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SA0PR01MB6474:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e8e1617-07e7-4a83-74fd-08dbc0415936
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VM4l3OZOUGcPKjLHXloyUkV9AcUOTH8fXGyNO1DBfKn1B8isA9tVnkbf7v/cYKPE4eT9WZhnREDz4bzHHcyTNe6hkeepgiCCif0Eh43NV1kGTLfUmsQC00/qUeegZjYTzMJqr2DkQGgTwHbXdmYzRCjY7pSsIlKPmrAWNWWrhAy7yZaQGCChUZ1z/tUAh1JkRuCF7rxxcI4qijp83P1hYdU8pcOqp8zz3A62lIQbeW5cDPx2exUkn0tCr/PQq3Xdg+X4+kOuQvorCalrY1drqKYf6LGW+48j7/qdlkg3jKhTkLWLk3Ahw1xh3eFfLC3UAlph23KVJMsxfRruBKo00sGNgEkhPTerl0O97t1zB1d98LbAZXPvcmtzUFkqhFecdjnj2DSS2fRWew0a9U77B2H/PDX453XQQgbj3gXfAFoTDHGbslpTuwyMZOLDmSm+UcGZG8izcPRxu9p8T5EdGDSUrQBQfrTD5OCsb+SSN987pjD4R0MFZnY2myYmxoW1gLrBav6+VkUei/TOwp/1iCxU/mChoBes/Nxb2vPc1AcGO/xUXGZyS975cpkrmC5gy10KGe5K3P9j+QQnKXhJt+nUGlrpg9rKdk5S8lLZqhgUxIKwnfWqxXsyH3bNpkhy9exdEpQr+t0lHRhj+CqRig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(39830400003)(136003)(396003)(376002)(346002)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(5660300002)(8676002)(2906002)(316002)(66476007)(66946007)(66556008)(6916009)(8936002)(4326008)(41300700001)(36756003)(86362001)(31696002)(31686004)(52116002)(6506007)(478600001)(83380400001)(2616005)(26005)(53546011)(6512007)(6486002)(38100700002)(38350700002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0ZSaXpoaHYxQ3FRWElzZVBYQmdtd1UzSCtic0tkeGEwQ09HOHpTRkhJcHNt?=
 =?utf-8?B?QTJRbGlTSnVkakJWUDUzWHBPNndlckt2UTFDL3J4OFkwL0Y2WC9Ra2xKTllx?=
 =?utf-8?B?SjhHNWVtZHRHV1RqaWZVZDlhYm9sZnFPL3E0aE9sT0t6Y0xhU1N1QnFaOVJT?=
 =?utf-8?B?UGtHSms3WHRDWUdPb1l1dTFubnRVY3g1NW52d0hzTmRhUXRJUExiclMvNFh0?=
 =?utf-8?B?UDJoQkoxaGIySkd6Rm8xM1B2RmZrZnM3VHBNUzZOdko5a2RNNkpTN1krQ0c2?=
 =?utf-8?B?ZEJBbEFSUnA1OVcxNGJ5WTlwUmIrbjZPM2dFTVljSjJnTzJxbThvMkMweXZI?=
 =?utf-8?B?NVA0ejVVRTlhQWo1NEhtenpwSnRtSjFKckN6eTg0VFdpVmFKUk5ZMUhqcWJO?=
 =?utf-8?B?eHNRU21TWXc4VmtDK0ZhWHhMUTNrbDNXZjMzU3lHb1pkMEVFYkVBV1VlS1d0?=
 =?utf-8?B?S2I0amNzUk8zUTcxWFluTllwOFlQaDhzK043VTY4UExmWmpmZ1I3czNoeGx0?=
 =?utf-8?B?S2I3SW5VZWVKekRDb0o1QnNWaHhCdW1vU3UvV1R4U2RnR1BJQUN6cUlmNWlV?=
 =?utf-8?B?Y0EzNUo2SldIMWZGOCtPcUFmV2lYL25XRU03cnpYZzlMeEJYaHlaaWFqY1F1?=
 =?utf-8?B?ZFE0M0VsWTRaOGVjczU2djRJdTh4NjRPQXdMTDJXN25TTGp6K2k0N2NJc004?=
 =?utf-8?B?eVdRNGVONVVCcGE1OStxcE1YODgwTCtLSVpIQ091bEs1bGEyNHVGOUZ1QmRy?=
 =?utf-8?B?UEpZQ0k2Q09MNStDVU1VM2VCRGZMZjZiNEt1VlVKMGp0NUN3bmgyVkdhbERp?=
 =?utf-8?B?QWhyUUkydXAwQ0pGcHNlNzRvVzFZWXZyY2F5eStxWlFRVVdOSEhaMmZML0FC?=
 =?utf-8?B?VEJUcFpFalVLa2Fwd2JCbDB6amgyTW9XS3paK3dGazQ5MGR4eFUzcjcwZDlH?=
 =?utf-8?B?M3VOdG0zK2I0NmpCSkI0Y214UEt4alZkdWRmTDRBemw0VVM0b1duaGRoVHVh?=
 =?utf-8?B?ZXBHZjAvUm9zU3V3ZjFqZDVkMFd5a1M4Q3pBZXVOL3d1UHZlOWRWZjJ6YkNL?=
 =?utf-8?B?S3g2QkxYODFhdW5xdFNHdEV4Yjh2MjVsTnM2Q3BNQ2JSZDZoRWtEOVF5aisx?=
 =?utf-8?B?ZzYzUjJWZk1IUjBBWnBVcm00K3AwT2VvemxRWXlOMEpuRW9MYS9mOCttYkx3?=
 =?utf-8?B?RkFqcFkydkVkL29MaFRzMjNmeVBsRXFjeG9oNExhaTY2Wi9BNFNvNlRNNkQr?=
 =?utf-8?B?aFBLQ0wycHRyM3lybzNYUk8zMmZlQlhhTzFNK2c2RGN0anI4OUk2Q0NwNHdU?=
 =?utf-8?B?dm9DOXJXamNFK01mdGtDNldFRk1qaitLYW5tM1ZmcHYzd0tidVZmSCt1MUZn?=
 =?utf-8?B?Zk1pSUxyeFpvTGtCc2lndWVRSjRaRkFvZUJpUE1FalBra2JIL0dqVWhGSFVr?=
 =?utf-8?B?dTk1Wm8yTWtmUVFGcE5UUDNSdkIwNUZhcEdaSDVURm41Z004cXBSclcvMUdu?=
 =?utf-8?B?VHJLZ3hRU1ErVk5WR2VtWWxIRy9zNTByRXZRV2IrU0ZWall5N29rNnROWjBo?=
 =?utf-8?B?eW5jWkNvUEp3Y2duU2NWNWM0aW5aMmVzZC84VjZIMnkrNmhQamhJK0s3ajBI?=
 =?utf-8?B?UlhTdzZXbWZ4TWtxVUIrZy9xbGI3MmxEb0cxQksvZ0lIbDhqUm9raDBHdXBL?=
 =?utf-8?B?OW1mSlBoeEwzUlYvNUwzTzkzeTIvRkU4UGJDMXo4cFo3NHlwNGlNWjc4akFw?=
 =?utf-8?B?bWdnVGxLM1RxK1phZGRWQkVNdExtMEVocTFzdDlQUGtINmRHcG1WeFcxL24x?=
 =?utf-8?B?N1Z0bkQwSVhZRnd6ZU5maktwRzZ6ajBqNjJ2T3RkOGVFWUNOWENVYkk4YXRM?=
 =?utf-8?B?L25hR2NyREVZaUZBQ1JuM1l5Yjl1TDh4OTMrS25VQjExQXZWRkUvUlFKd3BQ?=
 =?utf-8?B?Y29QejN1OFpCYVYwSjdRYWxZNmVFT3lnbTJBSWk4c1dpNisxY3paOW9YTEd3?=
 =?utf-8?B?aGdPZTRVNEdhQjY2SThLMHNCemo4UmJ0eGQ3ZFdiN2cyYWxPTXhCTHIvSCtS?=
 =?utf-8?B?NVNwV2FvSGlMVUg2UW9kUE1OME9OOEN1eEhIT3BDVjRrT2xDRWQvUmQrMjUw?=
 =?utf-8?Q?rqVuXJbRRRylbF9ECShWfL9d4?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e8e1617-07e7-4a83-74fd-08dbc0415936
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2023 16:38:30.6586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M6vYvQJqmHDiD4mFjxlP7RD7LX1Jn8lzLcgPLSpdOEqK47rnESp+8Q3APjd8EqdR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR01MB6474
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/28/2023 11:51 AM, Namjae Jeon wrote:
> 2023-09-29 0:23 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> On 9/27/2023 10:30 AM, Namjae Jeon wrote:
>>> Cthon test fail with the following error.
>>>
>>> check for proper open/unlink operation
>>> nfsjunk files before unlink:
>>>     -rwxr-xr-x 1 root root 0  9월 25 11:03 ./nfs2y8Jm9
>>> ./nfs2y8Jm9 open; unlink ret = 0
>>> nfsjunk files after unlink:
>>>     -rwxr-xr-x 1 root root 0  9월 25 11:03 ./nfs2y8Jm9
>>> data compare ok
>>> nfsjunk files after close:
>>>     ls: cannot access './nfs2y8Jm9': No such file or directory
>>> special tests failed
>>>
>>> Cthon expect to second unlink failure when file is already unlinked.
>>> ksmbd can not allow to open file if flags of ksmbd inode is set with
>>> S_DEL_ON_CLS flags.
>>>
>>> Reported-by: Tom Talpey <tom@talpey.com>
>>
>> I don't remember reporting this.
> You told me basic test of cthon run fine but special test fail.

Well yes but I didn't say the failure was incorrect. Connectathon is
a useful test, but it's not a protocol test. What makes it handy for
me is that it's easy to deploy and run, and it is not a synthetic
client, that is, it makes ordinary syscalls and exercices the local
in-kernel client code.

The "special" tests in particular are about NFS client quirks, and
specifically quirks that were interesting in, like, 1999. They need
to be taken with a huge lump of salt, and an even larger lump today.

It's ok, I'm not concerned that you added my Reported-by. But it needs
a lot more research before pushing this upstream.

Tom.

>> But more fundamentally, the Connectathon test is an NFS exerciser, and
>> specific to NFS (and Posix) semantics. Delete-on-last-close is not one
>> of them.
>>
>> Won't failing a new open break Windows semantics if it's enforced by
>> default? Normally Windows checks for FILE_SHARE_DELETE before deciding
>> this. Maybe other checks as well...
>>
>> Tom.
>>
>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>> ---
>>>    fs/smb/server/vfs_cache.c | 5 +++++
>>>    1 file changed, 5 insertions(+)
>>>
>>> diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
>>> index f41f8d6108ce..f2e2a7cc24a9 100644
>>> --- a/fs/smb/server/vfs_cache.c
>>> +++ b/fs/smb/server/vfs_cache.c
>>> @@ -577,6 +577,11 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work
>>> *work, struct file *filp)
>>>    		goto err_out;
>>>    	}
>>>
>>> +	if (fp->f_ci->m_flags & S_DEL_ON_CLS) {
>>> +		ret = -ENOENT;
>>> +		goto err_out;
>>> +	}
>>> +
>>>    	ret = __open_id(&work->sess->file_table, fp,
>>> OPEN_ID_TYPE_VOLATILE_ID);
>>>    	if (ret) {
>>>    		ksmbd_inode_put(fp->f_ci);
>>
> 
