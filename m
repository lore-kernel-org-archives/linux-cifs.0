Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C16BC0502F
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 17:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E6DC6137B
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 17:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236594AbhDARqC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbhDARjG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Apr 2021 13:39:06 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96892C0604DD;
        Thu,  1 Apr 2021 05:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=tVWLYEbLx9qrRAgapuYCwlPSpfDrqsPipPnLTPoxCjk=; b=WePIUIukGL00Rl/YfKZxWGjhtg
        uapdRFQ/Ywc8zYtqeWUb7DPDppM8gP69QZeSjyOhtiDemnaa4YAmwOhKS3xjkDa8ZXJ4UaaLe/Tta
        VNnOyFbbB6jympVSxIfKj52+PBHz6MrgCcp8Bls4l7A2CGfD2/V/A5I/FEfm7iEqVcyun6j6HdIGP
        HZDjfaHAeoI/1CbccffIkX91EfGFblZsr2Y1W4GGHHsMvtm3SzoPNDRlBCbXoG4fQ1Bd26rAoGJq8
        b9QUiLHuOmVY4cZ+3qcuFVcJMrCrFXQmLhvGbuaWIAn9SanZlUImmd25RJis0qfCFx+bN+61+OWKq
        PPDiDm+VwisuDSEd/cZyOAyJatw72rGmKSQrYERxKrPZhMFAabvrsdQ3tYPkdd6U+knVpFFv0nBWm
        7vaocRwGggqBWBS/aH+oNUeKiA3IbCrroX+2mhbouk33yBmhVaPqQdtwAFAU0Gy8StiGl20W2XLzn
        csZ5A5uJgYO55ubfhoGF7CeZ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lRwmX-0006VC-6X; Thu, 01 Apr 2021 12:50:41 +0000
Subject: Re: [Linux-cifsd-devel] [PATCH] cifsd: use kfree to free memory
 allocated by kzalloc
To:     Namjae Jeon <linkinjeon@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     COMMON INTERNET FILE SYSTEM SERVER <linux-cifs@vger.kernel.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>,
        kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>, colin.king@canonical.com,
        Muhammad Usama Anjum <musamaanjum@gmail.com>
References: <20210401113933.GA2828895@LEGION> <20210401115008.GS2088@kadam>
 <CAKYAXd-ou4-jf7_8xa4jDQ_otyQ9ffKhwD7WZrmrna1P3b_W8Q@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <ca1b9b0c-55f9-025d-558b-1b2b6c866d12@samba.org>
Date:   Thu, 1 Apr 2021 14:50:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CAKYAXd-ou4-jf7_8xa4jDQ_otyQ9ffKhwD7WZrmrna1P3b_W8Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zeRUUj6HNzvoePTSQnwPPm7ogV0B3n6Mm"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zeRUUj6HNzvoePTSQnwPPm7ogV0B3n6Mm
Content-Type: multipart/mixed; boundary="OeIAqnNtI8gSxOZGWCTJcJ31LJ66ZGbYu";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>,
 Dan Carpenter <dan.carpenter@oracle.com>
Cc: COMMON INTERNET FILE SYSTEM SERVER <linux-cifs@vger.kernel.org>,
 COMMON INTERNET FILE SYSTEM SERVER
 <linux-cifsd-devel@lists.sourceforge.net>, kernel-janitors@vger.kernel.org,
 open list <linux-kernel@vger.kernel.org>, Steve French <sfrench@samba.org>,
 colin.king@canonical.com, Muhammad Usama Anjum <musamaanjum@gmail.com>
Message-ID: <ca1b9b0c-55f9-025d-558b-1b2b6c866d12@samba.org>
Subject: Re: [Linux-cifsd-devel] [PATCH] cifsd: use kfree to free memory
 allocated by kzalloc
References: <20210401113933.GA2828895@LEGION> <20210401115008.GS2088@kadam>
 <CAKYAXd-ou4-jf7_8xa4jDQ_otyQ9ffKhwD7WZrmrna1P3b_W8Q@mail.gmail.com>
In-Reply-To: <CAKYAXd-ou4-jf7_8xa4jDQ_otyQ9ffKhwD7WZrmrna1P3b_W8Q@mail.gmail.com>

--OeIAqnNtI8gSxOZGWCTJcJ31LJ66ZGbYu
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 4/1/21 um 2:43 PM schrieb Namjae Jeon:
> 2021-04-01 20:50 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
>> On Thu, Apr 01, 2021 at 04:39:33PM +0500, Muhammad Usama Anjum wrote:
>>> kfree should be used to free memory allocated by kzalloc to avoid
>>> any overhead and for maintaining consistency.
>>>
>>> Fixes: 5dfeb6d945 ("cifsd: use kmalloc() for small allocations")
>>> Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
>>> ---
>>> This one place was left in earlier patch. I've already received
>>> responsse on that patch. I'm sending a separate patch.
>>>
>>>   fs/cifsd/transport_tcp.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/cifsd/transport_tcp.c b/fs/cifsd/transport_tcp.c
>>> index 67163efcf472..040881893417 100644
>>> --- a/fs/cifsd/transport_tcp.c
>>> +++ b/fs/cifsd/transport_tcp.c
>>> @@ -551,7 +551,7 @@ void ksmbd_tcp_destroy(void)
>>>   	list_for_each_entry_safe(iface, tmp, &iface_list, entry) {
>>>   		list_del(&iface->entry);
>>>   		kfree(iface->name);
>>> -		ksmbd_free(iface);
>>> +		kfree(iface);
>>
>> We should just delete the ksmbd_free() function completely.
> Yes, I have added your review comment about this to my todo-list.
> I will do that.
>>
>> I think that cifsd is being re-written though so it might not be worth=

>> it.
> Right.

fwiw, while at it what about renaming everything that still references=20
"cifs" to "smb" ? This is not the 90's... :)

Cheers!
-slow


--OeIAqnNtI8gSxOZGWCTJcJ31LJ66ZGbYu--

--zeRUUj6HNzvoePTSQnwPPm7ogV0B3n6Mm
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmBlwZ8FAwAAAAAACgkQqh6bcSY5nkaP
5A/9HwRyi+MljbI8+wiUXUUq/57WIFHsgmrADXXUDSjmVFDQ6G89KyR7v0pMICklZfDj73S6JrKx
A2lX4fvFyKOyEMMhU9s1EGf5z9jXC9FM+kdNbXCM9ob0l2aBc2+gZhYn5B6uwbRddqI2Pa4fvFhG
gRQJkEiQ+/Ga3tRFGC9yOEqr4HOP9pv0jcQs94b4V+BoJirgyXiqtdjWsYEeQFiaqghwlNodbMex
ePDrQ1XAPMl5tOon/GeqD034Ov/aHAeiirUe5WO2GtpMiRZBhbA3jrYQRrFrCjHyRsmMIG9IuwpT
TfjMEFmwQperqm0cXIjR7S6DGwu3N29ciG4v2NN/R0k5cUGGth5w7XxD7VvZIL+gmxVqkn2IBffT
485ZBuAXQ1H1ohmY/+MNrF41NmnBkrM+qW3FDS1b5scB46fWEMdbLO8ebnpsdGWeLba+m+jbQ9Pp
4XE2A18/LSIzZKw/6g3gLTvmwLS97udLqHb1aWjVqHl8pm+BgGes5ghU/XUEq5588CCniLy62MCI
UMepXA1hAIwSSFRQyzdIpeW/O6hygqpKbus9dDuNvwzwPscLOcnSTbDI5eToo3uqYHE6HZ8a0tPd
GfhI3h6DumD+0vfkI8ga3WCyeyO/j95UZgh/2IQuKbiJcoJpBwAxw4WZjsMUoiNRTLP6El3ZJjGj
E4U=
=SsV9
-----END PGP SIGNATURE-----

--zeRUUj6HNzvoePTSQnwPPm7ogV0B3n6Mm--
