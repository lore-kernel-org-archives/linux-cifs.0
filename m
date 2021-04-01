Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99CFBC433B4
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 17:58:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76CE961055
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 17:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbhDAR57 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236477AbhDARyg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Apr 2021 13:54:36 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCBFC05BD3C;
        Thu,  1 Apr 2021 06:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=swE4EoXhPqkyGwf/uAOVfbrSwIidE9gVg5cqYOpgPAo=; b=3lrdxniK3kF3wA04GvkVUuOub4
        VVFHcWNG2S3EZMbN5Bu/S7hNO7QvN6LJj8Weud8NMEPnAsfdrYWjgKQGXe5boy88s5T0y9iK+WGhc
        vKFTrt2J1+BsqbsWwau4TyzjqyxwNI1vIwNRAStSUnZAoxL9TQD6VChybC055r9zFWlXvZlV/1Z9l
        vV+pBuyKhqifnIp3L97gPHmVJ+jCbLiulp9Quirn6CPu+gPUka+Z2l+KbQ6KzhMH/0Vh8yrUp8GFV
        Tm/lqCGkXUFU3eK0WxUOCZyy04LZfjCtH2XJEKg+N+ufYsETdSGptZpMRdVprui7D1IZol1AmOuDL
        1aRLT2rjt9ujh3/t14AkoQT3+GRs+MOdMUSWzSJlmCy9qoXJp4wTwNhtug5aqn+hTurBXTNlfkRph
        LvrmTmdrhQMO3yyUnnAEquN/IdqbpB4Mgdrp1I3FJy4j7KqCouRzfH5QKrviVeoitBD3GGZJLs4JW
        Qp33zgc6fgU8UYWvA9QmDqKP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lRx9f-0006gn-38; Thu, 01 Apr 2021 13:14:35 +0000
Subject: Re: [Linux-cifsd-devel] [PATCH] cifsd: use kfree to free memory
 allocated by kzalloc
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifs@vger.kernel.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>,
        kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>, colin.king@canonical.com,
        Muhammad Usama Anjum <musamaanjum@gmail.com>
References: <20210401113933.GA2828895@LEGION> <20210401115008.GS2088@kadam>
 <CAKYAXd-ou4-jf7_8xa4jDQ_otyQ9ffKhwD7WZrmrna1P3b_W8Q@mail.gmail.com>
 <ca1b9b0c-55f9-025d-558b-1b2b6c866d12@samba.org>
 <CAKYAXd-ScM9i9Ln_FL8pWyEnPO_0n8t1BLH8MJ=b4NkqEbhZ=Q@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <2b758812-f00b-9465-c24e-763912748809@samba.org>
Date:   Thu, 1 Apr 2021 15:14:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CAKYAXd-ScM9i9Ln_FL8pWyEnPO_0n8t1BLH8MJ=b4NkqEbhZ=Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6irsXNVLH7MyZpMBP8hna9kRQTHVFnfUe"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6irsXNVLH7MyZpMBP8hna9kRQTHVFnfUe
Content-Type: multipart/mixed; boundary="SqtiD885B9gtfv0UMVgrlVyDDXnfdCI9q";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
 COMMON INTERNET FILE SYSTEM SERVER <linux-cifs@vger.kernel.org>,
 COMMON INTERNET FILE SYSTEM SERVER
 <linux-cifsd-devel@lists.sourceforge.net>, kernel-janitors@vger.kernel.org,
 open list <linux-kernel@vger.kernel.org>, Steve French <sfrench@samba.org>,
 colin.king@canonical.com, Muhammad Usama Anjum <musamaanjum@gmail.com>
Message-ID: <2b758812-f00b-9465-c24e-763912748809@samba.org>
Subject: Re: [Linux-cifsd-devel] [PATCH] cifsd: use kfree to free memory
 allocated by kzalloc
References: <20210401113933.GA2828895@LEGION> <20210401115008.GS2088@kadam>
 <CAKYAXd-ou4-jf7_8xa4jDQ_otyQ9ffKhwD7WZrmrna1P3b_W8Q@mail.gmail.com>
 <ca1b9b0c-55f9-025d-558b-1b2b6c866d12@samba.org>
 <CAKYAXd-ScM9i9Ln_FL8pWyEnPO_0n8t1BLH8MJ=b4NkqEbhZ=Q@mail.gmail.com>
In-Reply-To: <CAKYAXd-ScM9i9Ln_FL8pWyEnPO_0n8t1BLH8MJ=b4NkqEbhZ=Q@mail.gmail.com>

--SqtiD885B9gtfv0UMVgrlVyDDXnfdCI9q
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 4/1/21 um 2:59 PM schrieb Namjae Jeon:
> 2021-04-01 21:50 GMT+09:00, Ralph Boehme <slow@samba.org>:
>> fwiw, while at it what about renaming everything that still references=

>> "cifs" to "smb" ? This is not the 90's... :)
> It is also used with the name "ksmbd". So function and variable prefix
> are used with ksmbd.

well, I was thinking of this:

 > +++ b/fs/cifsd/...

We should really stop using the name cifs for modern implementation of=20
SMB{23} and the code should not be added as fs/cifsd/ to the kernel.

Cheers!
-slow

--=20
Ralph Boehme, Samba Team                https://samba.org/
Samba Developer, SerNet GmbH   https://sernet.de/en/samba/
GPG-Fingerprint   FAE2C6088A24252051C559E4AA1E9B7126399E46


--SqtiD885B9gtfv0UMVgrlVyDDXnfdCI9q--

--6irsXNVLH7MyZpMBP8hna9kRQTHVFnfUe
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmBlxzoFAwAAAAAACgkQqh6bcSY5nkbd
jxAAuax6KSBUKQJmbu4BTGwgRnPllPkOT6IkynAfeq/NPMoU4nb6uPTYoMQtf69nASUuYOxIZ4rP
CsRYkpmM9Z29nw6wOFEstlkB5WmKUfj9dnL5Lh9MwI3RVr21IZbD0oXyFAIs6FFlLRU3cF/czGrU
9Zvq5h5qbkLccoKw4++s2XYFkVg4G1eS/oy0pcYLQ1VatltAmVpQzsH4dUkk6HB1S6xdh3rCvTlX
oEfmd05OyNCqUJ6kD+sCsymBlxCpk8wYWVqsjiVGhN/30LWAXy3LEZe0OCBP3eKIC4sOo2F4tp/b
Jveb0VHm0p3ZLq3o51wxAIFgvuY2eb6hfzS6JRdQpBcja8NGKmjCV1q1a5P4LGSy8mqBNpRKQEAd
U3UL1lQYEeNrg+vo05V6w2IxanD/EKufFtQNh1zjsYlWX4P1XyvnDqOrbMoZDnxC0KUEhCpVQ0AX
I7QR2EHtFZ1mroej7NwVx2ED21JwTpEMRFp8rWuEIVjxmj7lzmQQrE3TGMiZ/MCyeDh1w5l8s8XC
Ptovwz5oBMig8seSG7DoVYbDdIlbzCD5/QOVrbcrYIi997Agis0/LExKU8miTVlDHRhI82WolBHs
mvUjOp7OAbVXbNghZTI1kvb0fVH/9zC1ZchNLp3mxJAvMTUzvLaEo0V80bZhfDKfzJIF4p3bADR5
7WQ=
=Guqt
-----END PGP SIGNATURE-----

--6irsXNVLH7MyZpMBP8hna9kRQTHVFnfUe--
