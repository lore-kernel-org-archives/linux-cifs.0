Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06F8C4361B
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 04:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADAD522483
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 04:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgLOEOc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 23:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgLOEOY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Dec 2020 23:14:24 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C717C061793
        for <linux-cifs@vger.kernel.org>; Mon, 14 Dec 2020 20:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Cc:To:From:Date;
        bh=kJryu0o2exWTSG68GgV4UL3yA9O4UvU7KTjaO/SMt4c=; b=omDbE/ge1y9ngMAj/4ik65yJK0
        VCLPEow2T5Je8Ib5y2bMa0q7pQyv68TKYU3PYbgdeMvUc1h5v/aJNgRB1ccPufzbWy1t/KIQBb5K/
        66ayRdZATftZbsQJTHBZWp6PZQPLfsJSUVdpfK4hHrH5Y4azUQ+4qh5E5ecLkA1xPcXfQaDKMpPOc
        ohSsL8DabzJPsh2wPXXhuexk1pbJRu7XPFf7m41QMzVJwfHMZfwibPuKMH7R0eWNFWhfbC994BER4
        LNkHExcjFrVou6Q1fK0gD6fqfwOHRbW8u6SysfbSNyqPTGvJvQJDVNRWlRJX+wqyXFf/YidI9OWo6
        MyXymORF4L0ObrqhpLYntz/mTIjOnvTOa6jaPnvOV5I9yEfidgEQ/YTx0S/4Y94JaQZBSTVOqbC3D
        HDCKmVMCNagfGsHK4O5NoO7I2IqTmeusqVHvTUA8akkn4SHdvc7nTLPCHZGFCpfDH5kfLrO+AC3Bq
        SMhNdxfhrSyBCEEdrA37/grz;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kp1iX-0005lI-0c; Tue, 15 Dec 2020 04:13:41 +0000
Date:   Mon, 14 Dec 2020 20:13:38 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     'Stefan Metzmacher' <metze@samba.org>,
        'Steve French' <smfrench@gmail.com>,
        'samba-technical' <samba-technical@lists.samba.org>,
        'CIFS' <linux-cifs@vger.kernel.org>
Subject: Re: updated ksmbd (cifsd)
Message-ID: <20201215041338.GA148040@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5muRCUzvKOv1xWRZL4t-7Pifz-nsL_Sn4qmbX0o127tnGA@mail.gmail.com>
 <3bf45223-484a-e86a-279a-619a779ceabd@samba.org>
 <CGME20201214184832epcas1p2095ebcc51c22fd003316c0e2334b9e1b@epcas1p2.samsung.com>
 <20201214184820.GB56567@jeremy-acer>
 <003b01d6d28a$0caa3750$25fea5f0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <003b01d6d28a$0caa3750$25fea5f0$@samsung.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Dec 15, 2020 at 11:29:01AM +0900, Namjae Jeon via samba-technical wrote:
>
>> On Mon, Dec 14, 2020 at 06:45:51PM +0100, Stefan Metzmacher via samba-technical wrote:
>> >Am 14.12.20 um 02:20 schrieb Steve French via samba-technical:
>> >> I just rebased https://protect2.fireeye.com/v1/url?k=e100f21c-be9bcb17-e1017953-002590f5b904-
>> f00629b46b3afee4&q=1&e=6fc8b980-0fd2-4e4d-a9dc-
>> 9ea15e482833&u=https%3A%2F%2Fgithub.com%2Fsmfrench%2Fsmb3-kernel%2Ftree%2Fcifsd-for-next
>> >> ontop of 5.10 kernel. Let me know if you see any problems.   xfstest
>> >> results (and recent improvements) running Linux cifs.ko->ksmbd look
>> >> very promising.
>> >
>> >I just looked briefly, but I'm wondering about a few things:
>> >
>> >1. The xattr's to store additional meta data are not compatible with
>> >   Samba's way of storing things:
>> >
>> >https://protect2.fireeye.com/v1/url?k=fbb13e03-a42a0708-fbb0b54c-002590
>> >f5b904-f4288e37b0eb9ae8&q=1&e=6fc8b980-0fd2-4e4d-a9dc-9ea15e482833&u=ht
>> >tps%3A%2F%2Fgit.samba.org%2F%3Fp%3Dsamba.git%3Ba%3Dblob%3Bf%3Dlibrpc%2F
>> >idl%2Fxattr.idl
>> >
>> >   In order to make it possible to use the same filesystem with both servers
>> >   it would be great if the well established way used in Samba would be used
>> >   as well.
>>
>> A thousand times this ! If cifs.ko->ksmbd adds a differnt way of storing the extra meta-data that is
>> incompatible with Samba this would be a disaster for users.
>>
>> Please fix this before proposing any merge.
>You said that samba can handle it even if ksmbd has own extra metadata format. I didn't think it was
>necessary to what you said. If we have to do this, I think it is not too late to work after sending
>ksmbd to linux-next first.

Yes, Samba could add an adaptor to read the ksmbd metadata format,
but then files written by Samba would have metadata unreadable
by ksmbd.

As the Samba metadata format is widely used then I don't see
the purpose of creating a new format for this. It's needless
incompatibility. Please fix this before submitting anywhere.
