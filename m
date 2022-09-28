Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B16C32771
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Sep 2022 19:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbiI1TeG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 15:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbiI1TeE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 15:34:04 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EB3956A0
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 12:34:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlluXapMfVPScV4MqmBikImQMp29X04xP8AAf9+FP2PjybqUJYW2cFC6OOiC9eTWNyBXIcVFdxwshrrbxoyvI0Gzd8i9D1EX+k96YTTI2wwp9G51WQprV2dyQ+r2fzZcgCADcvUC/ZB3gIDYyV4QgkQRX7XP8BNWTdQXL+gLr8e09z4TGotEBe5IPXBK+z/O3hIN/mUAeakqBzzv8O0DASt5bzaYgkEa83Ctj1GlmBoEoDsX7xrBqlm/MK2CPOhkqb6peJWoBDuZr5d7Rc1IkfUmIJgXFj94JNA7je1bSzmdNWREBeQRr9MAmyjQSLf3elj3ipwlwvpPEKoSWENWQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wy+KHpAjPtAdvKLus5v2lnmYqiZanl6xEB9gL6+j9OY=;
 b=CXqK21yXUSHO81QOABBjzWNFhtG+JBc6OY7iCBcZGQwTkTkU718m4Makb4rqEs7NQ1J4OWqDi1jibm6T8OQjdA+LTG0tS8zSTjbpXNR38xmul0MscpTiS/snLxiQHMZRVE0XHBAS6306TnE9TbzAog8EVEzV3eMrt54ai/ACstaBUeDl5gUzcLaL7i6jCHdI1BG1SPLJ28Gs/9btskdKznndAOu1uAt+e6K1G4+mjZs+a3JPyV9sNkXr8GtclYQspBVBZIHjIHbHMfrlGAeX4Ri9RmgLP8qvhbILDXiAMlP0OP6dFl1a9FAZuIHV+P4U/X2RTSPK2Pd1ZzZk+8oizA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SA0PR01MB6123.prod.exchangelabs.com (2603:10b6:806:eb::7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.15; Wed, 28 Sep 2022 19:34:00 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0%3]) with mapi id 15.20.5654.014; Wed, 28 Sep 2022
 19:34:00 +0000
Message-ID: <e69391db-2e63-773c-4fbb-4818e4f587f9@talpey.com>
Date:   Wed, 28 Sep 2022 15:33:58 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
From:   Tom Talpey <tom@talpey.com>
Subject: Re: [RFC PATCH] cifs: fix signature check for error responses
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
References: <20220922223216.4730-1-ematsumiya@suse.de>
 <2cbf804b-a692-ad45-4ec4-4676f15d48f2@talpey.com>
 <20220928163037.q5lhvszdguewvwi7@suse.de>
Content-Language: en-US
In-Reply-To: <20220928163037.q5lhvszdguewvwi7@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR17CA0024.namprd17.prod.outlook.com
 (2603:10b6:208:15e::37) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SA0PR01MB6123:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c5c24d5-71ae-4be2-b8f8-08daa18864b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wxXVcE0HIaF9FzKINTJOLolk+VhEgBnXb6FuDYunkjPt18g4tYQbvUoFwJNcYVHEBwJDcR0bip1RXR0wZUh1iPzXenCB+7X0VleuWcVKjuQRYgpUcUwLmz5RoomqlTBuL7BirQx6yAQGsvGVPQxuUbbW0ylkZUZ48GYbDGqDcUB0qls1qhktP19maIZgj0bVcgW+wV5tpP8QhcUgVpqRtnXZ3fkaMymm8ydPlItaKK1jjolLHKQ4zhPikqOIgUAXMofA0TadcpeCNBZRM3dKH+dvgKDin/BE+C/fgwWX1pDj5FlQSbgt+u7+dx5T6UkMIXQq3xPSeOW6ysyTgP3YJCbQWr5NKrOimYARtiDC1kDdg61b3jW5QCpGXipCQ9eC7l8japyh5i+VPX4rxnxoqEm+jP2U+kvQhvtLduMPbJWN2S62i0gZeutV9sP8zYFUCQodCEkaJXm+S0I1yyvBFDm1EPM7H/aa33AI23irPxz0pXBTXCr3Hl7h6Ux18fUxSNQbL47pSk+kkSDg25SkZm74ikBDZr7f0Cwq3B1lhXHRDuqUXdKAvtTb8IgzClZkmm5fTPgBMUgYk3DGOS35UdxjSdrJZwBjShkbEriSzHlyXYcAG99KURHIdm5Gvze+j5USlLHrT6ygOTUdprLLqx/+O+sFRhvNk1D9O/DF8jol+Y8iZ1LL8gDLdjiEd+IJ9SvFcbFUl18IwaSDwOEE0VoMW1MoZ+VGP/lHxOriKFmyN+TftIoOQGSq5pfdHrJ1u+If1eEvI3Kn5AO+IDPEdIvDDHH765cRXw3XsF3ZUW73GXKlbC02BgTsI9X/qOE2ub9Ix2kRYZt0x9L+nGxvOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(396003)(136003)(39830400003)(451199015)(36756003)(8676002)(4326008)(66946007)(66556008)(2616005)(66476007)(86362001)(6506007)(478600001)(6512007)(52116002)(316002)(6916009)(26005)(186003)(31696002)(53546011)(2906002)(38100700002)(38350700002)(8936002)(31686004)(83380400001)(5660300002)(41300700001)(6486002)(966005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zmc5VmZLS2JyY3duMGlQenlreEZPVDFBUTFUSk91Y2hucm43cmZZTVMzanU0?=
 =?utf-8?B?R0sySHBUTWVQcjRhQ1NDV2paRUc1Qzk1R0F5U0xhUXNnaWRFMWFwb2JzY2pm?=
 =?utf-8?B?MVE0WndMVXJ2NjQ4cDZRQiszaWo5dlp2ZnplUk1lc2t6RjQ0YTZwdXMyL1hQ?=
 =?utf-8?B?UEIxeGE5UEVRcTRobk9jRnR5V24rMmhKbWViL28zTTFXWG5XY0tIKzc3aWYr?=
 =?utf-8?B?cWtjZUsveW90VUpBTmNGZFZLN3Mrc050RDhJSEIrOVE4NzZBQjRnZGVkQ0Uv?=
 =?utf-8?B?Y2J6YlQwWWZHeWlwYnd2Z3RkVGI3dThlZzZMdTRQeG41OVR6WUdXd0k1UlBa?=
 =?utf-8?B?bG1RMVIrWFdDKzh3eE9wL3Jwdm92QmRoOGlidXRzWDRFc1FBeHBoZUpJUkoy?=
 =?utf-8?B?RjluTTUyQ1ZiSFN6U0pWUjNmeXd2Q3dKbWFTTEpLd05NWGFLNkpmN0h1a2g5?=
 =?utf-8?B?OTJhdG5ZdzIxTW03SUZiV1RzaXVjdFQrYzR3VG9CbmtKSEo3MCs4U0xQczRF?=
 =?utf-8?B?YXVLZ1JTMVA4QVJ0OG5CZXdBVVV1dHBqQkQ2a1dBZWxRbTlVQk9NanZwNHQ3?=
 =?utf-8?B?amdta1hra2lseE9MamZjUW1MUnozWFFLbUxwNG95VDVRUlNLMTBCSWJhK09O?=
 =?utf-8?B?WldmcmpCSFhqNzNpd2x0WlMvelA0MUVacmNvTWVIaGZnSGIxNnNKQUZSeDZV?=
 =?utf-8?B?bTJXMGhMcmkvQXg1MHhmeFVjbUlMUkM3NElxMzMyQmFmK1FoREJKMkJqNW9k?=
 =?utf-8?B?Z3Y1VTR5a2RKSkpYbWE0a1k2VzZGc0pEeXpvT0tKNEMzbUtqR2xCN1N5Rm95?=
 =?utf-8?B?d0szRlNtR0hIOVduL2VuMk1JTlh4UE9XekpHVElpaExVbFdmaGpnbUE1VVV3?=
 =?utf-8?B?TFpDd0tUYTR5VCtzWDJvNWRvZVVvdUdoWnNXRXR1dHZBc0JZbS9GcVdZTGQ0?=
 =?utf-8?B?OWRQWDJMQWtybHZCMXF1ZGlqemo2dEpLV1p1VW93c2FXOXQ4UzhrTzcxVEVV?=
 =?utf-8?B?VVh6a0tqaHNBcElkcEZkN3B3YzRVdkp0TW5HazJ4MVdQZDl4OFlKMVNyNlRZ?=
 =?utf-8?B?VjVjelA4R3cramRSY1dUdzVxekhIeGNFOWdDT3lpNE5OcW5kcUFUU01Yd2N1?=
 =?utf-8?B?aHhEMGtXYTNuSUVjTnhvTk1YS3hzdmJWVGU4MkM3UVZmRlhWcEF0WHNLNDE3?=
 =?utf-8?B?ZGliK3A2VWRyYzlWWHFUWER3eEZSdzZLMHMxS212TnNZZmxWM084bk9SZGli?=
 =?utf-8?B?YjgwTmRBVVdKV0xDSG9mbHpPaEd1OW1BNFRyYjhscWlXL3FCREtiMm9ubkhH?=
 =?utf-8?B?NUI0amdhRmhiVEdheG5wTlRJY3M0Q2hUUmxieE1LMWViNXpienJFM0kzdHBm?=
 =?utf-8?B?OWphNWNZN2tKbkFySDBlWVBFYmp0R2h0amZGM2V2VU5TUE84SExMSEhVYkJs?=
 =?utf-8?B?SmZjeTYzVXUwSjJXcTd6bTR0bG1FZkdJb2NwWVY2OU43VmluN3Vwekl6MEh1?=
 =?utf-8?B?eEtjdDhGUk9sQVhTRDFMVVdmRGNhQ01kYVdtOUY5SVNjWDhGbzY3dVU2S2tW?=
 =?utf-8?B?Z2VDWXJHMUcvak9xWThWTGt0eDU0SFVZSGl1S21tUFRrNWVnMXhxZXVZN2pt?=
 =?utf-8?B?ZEZaNmhiRDJJQ01GbnhLQ1luQzEyWmh0UitrSWpHUk5RTU5QVExQY0Y3Vm1X?=
 =?utf-8?B?MEYrVE1GQWt2OEpTMGRPeGdKVmJUMDF2M2FqSVJudmJGN2lTZXMwVGVzRXc1?=
 =?utf-8?B?SXg1T2dwYlJaWVhhdFJSR1d4VlN4amc5dmdWaDhwemV3NHJlalpFZjlQdjNS?=
 =?utf-8?B?d1Q3cFU0bWtuRDdnRDRTZlpFRVZraUdHRVFwUjI4MWlQcUdSQTdwajg5TFB0?=
 =?utf-8?B?Z09XQlV4RFU5YURWaUZURzVkY2owVUFZUk83b042Ri9WUWJUeWlzWHRkR25v?=
 =?utf-8?B?UWhVNmFtZ2pqeFdyNkpZK0ZBdVBIZ1NZVW1VMGVrVjJmWGU2NEFucnBvZzUv?=
 =?utf-8?B?S2NzWHlnRlVqYWF4cU14dUZhOEFDUUhDUG5ONXlFYTNpemlXWUNxcy80THBJ?=
 =?utf-8?B?bk5kMDNQUjdLaENVOEpQQlVreGtUUjNCdFB1ejlEZFJKNmN2bkNhdEI0Zy9I?=
 =?utf-8?Q?k+Pg=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c5c24d5-71ae-4be2-b8f8-08daa18864b3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 19:34:00.5814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s85nDexAqOu+0wAl5MM+drkc7JPklPF3RXeQzGSH8NmdNlaXotI/sQ4pZ1m+sRzU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR01MB6123
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/28/2022 12:30 PM, Enzo Matsumiya wrote:
> On 09/28, Tom Talpey wrote:
>> On 9/22/2022 6:32 PM, Enzo Matsumiya wrote:
>>> Hi all,
>>>
>>> This patch is the (apparent) correct way to fix the issues regarding 
>>> some
>>> messages with invalid signatures. My previous patch
>>> https://lore.kernel.org/linux-cifs/20220918235442.2981-1-ematsumiya@suse.de/
>>> was wrong because a) it covered up the real issue (*), and b) I could 
>>> never
>>> again "reproduce" the "race" -- I had other patches in place when I 
>>> tested it,
>>> and (thus?) the system memory was not in "pristine" conditions, so 
>>> it's very
>>> likely that there's no race at all.
>>>
>>> (*) Thanks a lot to Tom Talpey for pointing me to the right direction 
>>> here.
>>>
>>> Since it sucks to be wrong twice, I'm sending this one as RFC because I
>>> wanted to confirm some things:
>>>
>>>   1) Can I rely on the fact that status != STATUS_SUCCESS means no 
>>> variable
>>>      data in the message?  I could only infer from the spec, but not 
>>> really
>>>      confirm.
>>
>> Technically, I think the answer is "no" but practically speaking maybe
>> "yes".
>>
>> Not all errors are actually errors however, e.g. STOPPED_ON_SYMLINK and
>> the additional error contexts which accompany it. We definitely don't
>> want to skip validation of those.
>>
>> There's also STATUS_PENDING, but that's special because it isn't actually
>> a response, it's just a "hang on I'm busy" that carries no other
>> data.
>>
>> Finally, MS-SMB2 lists a few others in section 2.2.2.2, all of which
>> need validation I think.
> 
> Sorry, I might have not been clear.  By "variable data" I actually meant
> data that's not going to be allocated in the requests' iovs, but rather
> in rqst->rq_pages.
> 
> The variable buffers that are already expected (by PDU/spec), are AFAICS
> always allocated either through cifs*buf_get() or some kmalloc() variant,
> i.e. non-HIGHMEM.
> 
> async IO, though, is the only place I can see that allocates
> rqst->rq_pages through iov_iter_get_pages_alloc2(), which is the source
> of my concern, and the reason of my patch.  Particularly, on async read
> cases, the page data is pre-allocated with the size we *expect* to
> receive/read from the server, but if there's an error in a READ
> response, the response itself will contain no/incomplete data in the page
> data, but since those pages are allocated, the signature computation will
> account for it, and generate a mismatching signature.

Aha - ok, got it. And I've been looking into those codepaths too because
the RDMA code fails badly when I try to optimize the completion path.
Right now, the code waits for ALL smbdirect packets to be sent before
returning, which is ridiculously inefficient. It does this in both
client and server sending. But if I remove the wait, nothing works as
it appears the queued buffers are either freed, or unwound from the
stack. Completely and totally bogus.

> I'm running more tests now and I'll make sure to test the other possible
> errors in 2.2.2.2.
> 
>>>   2) (probably only in async cases) When the signature fails, for 
>>> whatever
>>>      reason, we don't take any action.  This doesn't seem right IMHO,
>>>      e.g. if the message is spoofed, we show a warning that the 
>>> signatures
>>>      doesn't match, but I would expect at least for the operation to 
>>> stop,
>>>      or maybe even a complete dis/reconnect.
>>
>> I don't think so. The spec calls for dropping the message, and after
>> all it could have been simple packet corruption. The retries will sort
>> it out.
>>
>> Absolutely positively do not print a message for each received packet,
>> good or bad.
> 
> For the good messages ok, of course, but for bad? Why not? Otherwise, e.g.,
> spotting the misvalidation mentioned above would've taken much longer.

It's basic MITM. If there is such an attacker, it can trivially redirect
the client, by injecting an error undetected. Inspecting the payload
before doing the integrity check is just insecurely wrong.

Regarding the logging on signature validation, consider that an attacker
will therefore trivially be able to overrun the log, either DOSing the
system, or at the very least hiding other messages. Why alarm the
sysadmin, for something they are not likely to be able to act upon?
Bump a statistic, maybe.

To me, the kernel log is not informational, it's for critical actions.
For example, it requires root to even see it. Consider what you need to
tell such a person each time it happens. "Oops, I dropped a packet"
doesn't cut it. If it's a developer hint, then place it under CIFS FYI,
or some sort of opt-in diagnostic tracing channel.

Tom.

> (btw I spotted that misvalidation while debugging my AES-GMAC series,
> but the same behaviuour happens with AES-CMAC i.e. in current code)
> 
>>>   3) For SMB1, I couldn't really use generic/465 as a real 
>>> confirmation for
>>>      this because it says "O_DIRECT is not supported".  From reading the
>>>      code and 'man mount.cifs' I understood that this is supported, 
>>> so what
>>>      gives?  Worth noting that I don't follow/use/test SMB1 too much.
>>>      The patch does work for other cases I tried though.
>>
>> Honestly, I don't think we care. No amount of patching can possibly
>> save SMB1.
> 
> Ack :)
> 
>> Tom.
> 
> 
> Cheers,
> 
> Enzo
> 
>>> I hope someone can address my questions/concerts above, and please 
>>> let me
>>> know if the patch is technically and semantically correct.
>>>
>>> Patch follows.
>>>
>>>
>>> Enzo
>>>
>>> --------
>>> When verifying a response's signature, the computation will go through
>>> the iov buffer (header + response structs) and the over the page 
>>> data, to
>>> verify any dynamic data appended to the message (usually on an SMB2 READ
>>> response).
>>>
>>> When the response is an error, however, specifically on async reads,
>>> the page data is allocated before receiving the expected data.  Being
>>> "valid" data (from the signature computation POV; non-NULL, >0 pages),
>>> it's included in the parsing and generates an invalid signature for the
>>> message.
>>>
>>> Fix this by checking if the status is non-zero, and skip the page data
>>> if it is.  The issue happens in all protocol versions, and this fix
>>> applies to all.
>>>
>>> This issue can be observed with xfstests generic/465.
>>>
>>> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>>> ---
>>>  fs/cifs/cifsencrypt.c | 17 +++++++++++++++++
>>>  1 file changed, 17 insertions(+)
>>>
>>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>>> index 46f5718754f9..e3260bb436b3 100644
>>> --- a/fs/cifs/cifsencrypt.c
>>> +++ b/fs/cifs/cifsencrypt.c
>>> @@ -32,15 +32,28 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
>>>      int rc;
>>>      struct kvec *iov = rqst->rq_iov;
>>>      int n_vec = rqst->rq_nvec;
>>> +    bool has_error = false;
>>>      /* iov[0] is actual data and not the rfc1002 length for SMB2+ */
>>>      if (!is_smb1(server)) {
>>> +        struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
>>> +
>>>          if (iov[0].iov_len <= 4)
>>>              return -EIO;
>>> +
>>> +        if (shdr->Status != 0)
>>> +            has_error = true;
>>> +
>>>          i = 0;
>>>      } else {
>>> +        struct smb_hdr *hdr = (struct smb_hdr *)iov[1].iov_base;
>>> +
>>>          if (n_vec < 2 || iov[0].iov_len != 4)
>>>              return -EIO;
>>> +
>>> +        if (hdr->Status.CifsError != 0)
>>> +            has_error = true;
>>> +
>>>          i = 1; /* skip rfc1002 length */
>>>      }
>>> @@ -61,6 +74,9 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
>>>          }
>>>      }
>>> +    if (has_error)
>>> +        goto out_final;
>>> +
>>>      /* now hash over the rq_pages array */
>>>      for (i = 0; i < rqst->rq_npages; i++) {
>>>          void *kaddr;
>>> @@ -81,6 +97,7 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
>>>          kunmap(rqst->rq_pages[i]);
>>>      }
>>> +out_final:
>>>      rc = crypto_shash_final(shash, signature);
>>>      if (rc)
>>>          cifs_dbg(VFS, "%s: Could not generate hash\n", __func__);
> 
