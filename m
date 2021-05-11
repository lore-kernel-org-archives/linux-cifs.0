Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10FA0C433ED
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 18:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6CAA61168
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 18:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhEKSVs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 May 2021 14:21:48 -0400
Received: from mx.cjr.nz ([51.158.111.142]:48060 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231454AbhEKSVs (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 11 May 2021 14:21:48 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id CE3997FEDB;
        Tue, 11 May 2021 18:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1620757240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AO+Mpz+XN2cczR8BHp7LI6sH2TFA3zUWFdi9c4hI/FM=;
        b=b+ydvTRGC8Fn4MruyF0h7EDnWSL2LULB2kmKaviR+FWHup7lCAX3+VPBpLXnKN0XgqwgBL
        WfQP73pcS1/R4/66C3ALykPN4zjGdsBLWKerzJhzqgDJBK7J+JDevl2SRgYFmG2j26MOlp
        SLZstel6LSwHbL689RKYJNLcvPhnDp1St++Z6fwJ3ca/kW6HGkxtbNbZDL6CCZj25sUi3J
        mWmT97m7qXKlokZoTd7KpgSEd1Ifp9wHYtTkhroYe9qlTIZnrQSBjpJtWTJbo1MNQv860R
        ZfbLGXM/zEWhGgu4eSU86T5oAZsXljtdcm7efq9MeT1CD8r5HcJUuCd9MeO9/g==
From:   Paulo Alcantara <pc@cjr.nz>
To:     =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        linux-cifs@vger.kernel.org, piastryyy@gmail.com
Subject: Re: [PATCH cifs-utils] mount.cifs: handle multiple ip addresses per
 hostname
In-Reply-To: <8735uttb7s.fsf@suse.com>
References: <20210511163952.11670-1-pc@cjr.nz> <8735uttb7s.fsf@suse.com>
Date:   Tue, 11 May 2021 15:20:33 -0300
Message-ID: <877dk5jfny.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aur=C3=A9lien Aptel <aaptel@suse.com> writes:

> I would put in the commit msg that this requires recent kernel.

Agreed.

> We should probably merge kernel code first so we can reference it here
> in the commit msg, and say in the man page when did the kernel change.

Agreed.

> There can be cases where cifs-utils is more recent than kernel and
> mount.cifs will pass all the ip instead of trying them before passing
> the good one to the kernel but since it's an old kernel it won't try
> them all.

Good point!  Yes, we should handle both cases.

> We could add an option to enable new behavior or check the kernel
> version from within mount.cifs.. thoughts?

I don't like the idea of checking the version because the running kernel
might not have the expected patches.

Perhaps a new option would be better... I'll think more about it.

> Paulo Alcantara <pc@cjr.nz> writes:
>>=20=20
>> +static void set_ip_params(char *options, size_t options_size, char *add=
rlist)
>> +{
>> +	char *s =3D addrlist + strlen(addrlist), *q =3D s;
>> +	char tmp;
>> +
>> +	do {
>> +		for (; s >=3D addrlist && *s !=3D ','; s--);
>> +		tmp =3D *q;
>> +		*q =3D '\0';
>> +		strlcat(options, *options ? ",ip=3D" : "ip=3D", options_size);
>> +		strlcat(options, s + 1, options_size);
>> +		*q =3D tmp;
>> +	} while (q =3D s--, s >=3D addrlist);
>> +}
>
> I think you should write this in a clearer way and comment, this is hard
> to read.

That's horrible, indeed.  I'll definitely make it readable in next
version.

> I was going to say should we return errors if we truncate the ips, but
> none of the mount.cifs.c code checks for truncation so I guess we can
> ignore.

IIRC, yes.
