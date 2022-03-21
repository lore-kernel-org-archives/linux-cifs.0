Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9804C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 12:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346327AbiCUMc0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Mar 2022 08:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347373AbiCUMcX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Mar 2022 08:32:23 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABDB84ECA
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 05:30:58 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id D870980851;
        Mon, 21 Mar 2022 12:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1647865856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XLUYBlWQKdPWvFRX6s+fcXqyHyZ/iJdqSvW5kpkEdEA=;
        b=1E+T47RO+RIpQNONM/wIkaRwtxP76ZoVPfSykbRhS0lUaj2htE6m/+hrtkK73HROUvroZO
        jFeDPQPHBi3rTZTcp898SgAs0i56Ed7RlHMSV1owYX18x7rCurhHfIWcF9CmbDyTucDE/h
        GlMD9txo/I5Lbft2CGZzJmrGv18yInibY2I6l2oHgOrvcIFb9+RkvIjF2zttv3ExsBQb8v
        r0X3xhCb791SWhCU0mQ1T+yYj1RajzZ377NT8c1/UgWQ2sVR8FcqHBqD9+RhZ07CK+F/xb
        FF7+lm3HaAh5ubn7HNIHJLndo9bjJY6cgUY7OQsmwICpXFepffsq22Z50DdbTg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
Subject: Re: [PATCH] cifs: fix bad fids sent over wire
In-Reply-To: <6ef3f7db-a6ed-62c7-226e-b2a20ef5b294@talpey.com>
References: <20220321002007.26903-1-pc@cjr.nz>
 <6ef3f7db-a6ed-62c7-226e-b2a20ef5b294@talpey.com>
Date:   Mon, 21 Mar 2022 09:30:51 -0300
Message-ID: <878rt3v66c.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tom Talpey <tom@talpey.com> writes:

> On 3/20/2022 8:20 PM, Paulo Alcantara wrote:
>> The client used to partially convert the fids to le64, while storing
>> or sending them by using host endianness.  This broke the client on
>> big-endian machines.  Instead of converting them to le64, store them
>> verbatim and then avoid byteswapping when sending them over wire.
>> 
>> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>> ---
>>   fs/cifs/smb2misc.c |  4 ++--
>>   fs/cifs/smb2ops.c  |  8 +++----
>>   fs/cifs/smb2pdu.c  | 53 ++++++++++++++++++++--------------------------
>>   3 files changed, 29 insertions(+), 36 deletions(-)
>> 
>> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
>> index b25623e3fe3d..3b7c636be377 100644
>> --- a/fs/cifs/smb2misc.c
>> +++ b/fs/cifs/smb2misc.c
>> @@ -832,8 +832,8 @@ smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info *serve
>>   	rc = __smb2_handle_cancelled_cmd(tcon,
>>   					 le16_to_cpu(hdr->Command),
>>   					 le64_to_cpu(hdr->MessageId),
>> -					 le64_to_cpu(rsp->PersistentFileId),
>> -					 le64_to_cpu(rsp->VolatileFileId));
>> +					 rsp->PersistentFileId,
>> +					 rsp->VolatileFileId);
>
> This conflicts with the statement "store them verbatim". Because the
> rsp->{Persistent,Volatile}FileId fields are u64 (integer) types,
> they are not being stored verbatim, they are being manipulated
> by the CPU load/store instructions. Storing them into a u8[8]
> array is more to the point.

Yes, makes sense.

> If course, if the rsp structure is purely private to the code, then
> the structure element type is similarly private. But a debugger, or
> a future structure reference, may once again get it wrong
>
> Are you rejecting the idea of using a byte array?

No.  That would work, too.  I was just trying to avoid changing a lot of
places and eventually making it harder to backport.

I'll go with the byte array then.
