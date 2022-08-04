Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B85CC00144
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Aug 2022 05:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiHDF6w (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Aug 2022 01:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiHDF6v (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Aug 2022 01:58:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06F661101
        for <linux-cifs@vger.kernel.org>; Wed,  3 Aug 2022 22:58:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AEC260AEA
        for <linux-cifs@vger.kernel.org>; Thu,  4 Aug 2022 05:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED12C433C1
        for <linux-cifs@vger.kernel.org>; Thu,  4 Aug 2022 05:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659592729;
        bh=wnayD04MEDIQGkDsAmvz/GB44EPJdgI0Kb87j47ZCpY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=tuup3cMqmsq8E6qNuK4tY0rgYRz3KJ3krHNzjTlH0JdpkLFz+bauu+mFbx+bFRYey
         FNh9O8bKzWlRawclHKmIdclvgRsdr2bLPfCWVwgB/tz9d+JX2Wg3IlIWKdD+S4ZZPu
         dm4+Q9LRKmDs10+VKkc+gXgPGfCVZOQ2eyUxZmfOsZTPmLDQeRBDbmLidx2GivSjKQ
         NmOsEA8S661OAMdIJ6QLrorrMOPrO7/YuoVtRBZeHy3VQfRGQc5obZrLh21ozAZgpd
         JNZjd8or2KZhmRT1BMon3DRV+f3zTyOh/hlMu5PFSUXIy7hV+Ll6yaHor0oJq+iGj6
         xlAHL5yTx/i7g==
Received: by mail-ot1-f46.google.com with SMTP id o16-20020a9d4110000000b0061cac66bd6dso13562655ote.11
        for <linux-cifs@vger.kernel.org>; Wed, 03 Aug 2022 22:58:49 -0700 (PDT)
X-Gm-Message-State: ACgBeo0U/UcSKuswBAlEZ23LwtybKRH45e6ZjmxWfpGkSTGOokNDTg4z
        T6eaWhSITELejiPEyvg1mICPd22Ez4Yqkpbiwxc=
X-Google-Smtp-Source: AA6agR56KmJDhlviZ1M9QOuj8CvfC2n+kMQuhMVTBk/eDLiGCM25ERoRWdIBpfv1u61plgLpRFQ2f09xwKmW6aHgaTc=
X-Received: by 2002:a9d:12ac:0:b0:636:7110:eda2 with SMTP id
 g41-20020a9d12ac000000b006367110eda2mr69533otg.339.1659592728841; Wed, 03 Aug
 2022 22:58:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6839:41a4:0:0:0:0 with HTTP; Wed, 3 Aug 2022 22:58:48
 -0700 (PDT)
In-Reply-To: <64fa262a-9629-1a94-4314-a218b686b46b@talpey.com>
References: <20220803022042.10543-1-linkinjeon@kernel.org> <d1e09264-bec2-8dfd-c793-6fc7c528b1c5@talpey.com>
 <64fa262a-9629-1a94-4314-a218b686b46b@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 4 Aug 2022 14:58:48 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9tJsvs6GKFXW6_V8jug+zvKjw0hc4ej1_mkmpfwZFK=w@mail.gmail.com>
Message-ID: <CAKYAXd9tJsvs6GKFXW6_V8jug+zvKjw0hc4ej1_mkmpfwZFK=w@mail.gmail.com>
Subject: Re: [PATCH] cifs: smbdirect: use the max_sge the hw reports
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        David Howells <dhowells@redhat.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Long Li <longli@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-08-03 23:34 GMT+09:00, Tom Talpey <tom@talpey.com>:
Hi Tom,
> Oops, I typed "ksmbd" below, I meant "smbdirect client".
> However, fewer sge's are always better, and ksmbd may
> well have different requirements than "cifs", making a
> hardcoded value even less appropriate.
Yes. Agreed. but I don't know if I can properly answer your questions.
I have not looked deeply into the cifs smbdirect code, so I requested
Long who is an author of smbdirect in cifs for a proper fix before.
And it's still there. I just wrote a stopgap fix patch as on David's
request. I expect Long or someone else with a deep look into cifs and
smbdirect will give the right solution later.

Thanks!
>
> On 8/3/2022 10:26 AM, Tom Talpey wrote:
>> On 8/2/2022 10:20 PM, Namjae Jeon wrote:
>>> In Soft-iWARP, smbdirect does not work in cifs client.
>>> The hardcoding max_sge is large in cifs, but need smaller value for
>>> soft-iWARP. Add SMBDIRECT_MIN_SGE macro as 6 and use the max_sge
>>> the hw reports instead of hardcoding 16 sge's.
>>
>> There is no issue in SoftiWARP, the bug is in ksmbd, so I think
>> the message is incorrect. May I suggest:
>>
>>   "Use a more appropriate max_sge, and ensure it does not exceed the
>>    RDMA provider's maximum. This enables ksmbd to function on
>>    SoftiWARP, among potentially others."
>>
>> More comments below.
>>
>>> Cc: Tom Talpey <tom@talpey.com>
>>> Cc: David Howells <dhowells@redhat.com>
>>> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>>> Cc: Long Li <longli@microsoft.com>
>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>> ---
>>>   fs/cifs/smbdirect.c | 15 ++++++++++-----
>>>   fs/cifs/smbdirect.h |  3 ++-
>>>   2 files changed, 12 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
>>> index 5fbbec22bcc8..bb68702362f7 100644
>>> --- a/fs/cifs/smbdirect.c
>>> +++ b/fs/cifs/smbdirect.c
>>> @@ -1518,7 +1518,7 @@ static int allocate_caches_and_workqueue(struct
>>> smbd_connection *info)
>>>   static struct smbd_connection *_smbd_get_connection(
>>>       struct TCP_Server_Info *server, struct sockaddr *dstaddr, int
>>> port)
>>>   {
>>> -    int rc;
>>> +    int rc, max_sge;
>>>       struct smbd_connection *info;
>>>       struct rdma_conn_param conn_param;
>>>       struct ib_qp_init_attr qp_attr;
>>> @@ -1562,13 +1562,13 @@ static struct smbd_connection
>>> *_smbd_get_connection(
>>>       info->max_receive_size = smbd_max_receive_size;
>>>       info->keep_alive_interval = smbd_keep_alive_interval;
>>> -    if (info->id->device->attrs.max_send_sge < SMBDIRECT_MAX_SGE) {
>>> +    if (info->id->device->attrs.max_send_sge < SMBDIRECT_MIN_SGE) {
>>>           log_rdma_event(ERR,
>>>               "warning: device max_send_sge = %d too small\n",
>>>               info->id->device->attrs.max_send_sge);
>>>           log_rdma_event(ERR, "Queue Pair creation may fail\n");
>>>       }
>>> -    if (info->id->device->attrs.max_recv_sge < SMBDIRECT_MAX_SGE) {
>>> +    if (info->id->device->attrs.max_recv_sge < SMBDIRECT_MIN_SGE) {
>>>           log_rdma_event(ERR,
>>>               "warning: device max_recv_sge = %d too small\n",
>>>               info->id->device->attrs.max_recv_sge);
>>> @@ -1593,13 +1593,18 @@ static struct smbd_connection
>>> *_smbd_get_connection(
>>>           goto alloc_cq_failed;
>>>       }
>>
>> Why are the two conditions treated differently? It prints a rather
>> vague warning if the send sge is exceeded, but it fails if the
>> receive sge is too large.
>>
>> I suggest failing fast in both cases, but the code gives no way
>> for the user to correct the situation, SMBDIRECT_MIN_SGE is a
>> hardcoded constant. That's the bug
>>
>> IIRC, the ksmbd code requires 3 send sge's for send, and it needs
>> 5 sge's when SMB3_TRANSFORM is needed. Why not provide a variable
>> sge limit, depending on the session's requirement?
>>
>>> +    max_sge = min3(info->id->device->attrs.max_send_sge,
>>> +               info->id->device->attrs.max_recv_sge,
>>> +               SMBDIRECT_MAX_SGE);
>>> +    max_sge = max(max_sge, SMBDIRECT_MIN_SGE);
>>
>> This is inaccurate. ksmbd's send sge requirement is not necessarily
>> the same as its receive sge, likewise the RDMA provider's limit.
>> There is no reason to limit one by the other, and they should be
>> calculated independently.
>>
>> What is the ksmbd receive sge requirement? Is it variable, like
>> the send, depending on what protocol features are needed?
>>
>>> +
>>>       memset(&qp_attr, 0, sizeof(qp_attr));
>>>       qp_attr.event_handler = smbd_qp_async_error_upcall;
>>>       qp_attr.qp_context = info;
>>>       qp_attr.cap.max_send_wr = info->send_credit_target;
>>>       qp_attr.cap.max_recv_wr = info->receive_credit_max;
>>> -    qp_attr.cap.max_send_sge = SMBDIRECT_MAX_SGE;
>>> -    qp_attr.cap.max_recv_sge = SMBDIRECT_MAX_SGE;
>>> +    qp_attr.cap.max_send_sge = max_sge;
>>> +    qp_attr.cap.max_recv_sge = max_sge;
>>
>> See previous comment.
>>
>>>       qp_attr.cap.max_inline_data = 0;
>>>       qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
>>>       qp_attr.qp_type = IB_QPT_RC;
>>> diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
>>> index a87fca82a796..8b81301e4d4c 100644
>>> --- a/fs/cifs/smbdirect.h
>>> +++ b/fs/cifs/smbdirect.h
>>> @@ -225,7 +225,8 @@ struct smbd_buffer_descriptor_v1 {
>>>       __le32 length;
>>>   } __packed;
>>> -/* Default maximum number of SGEs in a RDMA send/recv */
>>> +/* Default maximum/minimum number of SGEs in a RDMA send/recv */
>>> +#define SMBDIRECT_MIN_SGE    6
>>
>> See previous comment, and also, please justify the "6".
>>
>> David Howells commented it appears to be "5", at least for send.
>> I think with a small refactoring to allocate a more flexible header
>> buffer, it could be even smaller.
>>
>> I would hope the value for receive is "2", or less. But I haven't
>> looked very deeply yet.
>>
>> With sge's and an RDMA provider, the smaller the better. The adapter
>> will always be more efficient in processing work requests. So doing
>> this right is beneficial in many ways.
>>
>>>   #define SMBDIRECT_MAX_SGE    16
>>
>> While we're at it, please justify "16". Will ksmbd ever need so many?
>>
>>>   /* The context for a SMBD request */
>>>   struct smbd_request {
>>
>> Tom.
>>
>
