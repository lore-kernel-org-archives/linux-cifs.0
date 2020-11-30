Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66510C64E8A
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Nov 2020 13:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8EC120708
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Nov 2020 13:03:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="b+Ro+eD8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgK3NDf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Nov 2020 08:03:35 -0500
Received: from mx.cjr.nz ([51.158.111.142]:38174 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbgK3NDf (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 30 Nov 2020 08:03:35 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 27C177FD0A;
        Mon, 30 Nov 2020 13:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1606741373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WkAIH7wGpXGjkH5u9FmAeYEB4t67ieXh3P99EHAEU4Y=;
        b=b+Ro+eD8HA6BcfFW3T/JgIymVSTiPXUEQ/0cMyJw0rOl14ZUt02hED61+yjm1XnxMy92+B
        gnrDSJ8cGJP5Fyiwha3fP3khNSvPnQZgJsIFBhUFC9hrWIBoeRatYx9CFblqxYQycFXgxH
        0mRHzMuodkzFl+4nJtk8zOTOkiFjHOF3s2+TOuzq6Hfcs9qq3s8cuZSwES0SSpQfUXPmBw
        vtPh6wiSSivcYyFix7hpJ4sxRXSxCN1t+JbsqKfMA+7UgCDCuOFAy2VbmYKHA02FWBxva0
        paVg4EsaVE/rCfzrP9JNjyfP8O5oI2woKmyzEiynABpbv88OZWYi+z2hPuhX5A==
From:   Paulo Alcantara <pc@cjr.nz>
To:     =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        linux-cifs@vger.kernel.org, smfrench@gmail.com
Subject: Re: [PATCH] cifs: allow syscalls to be restarted in __smb_send_rqst()
In-Reply-To: <87sg8rdtoj.fsf@suse.com>
References: <20201128185706.8968-1-pc@cjr.nz> <87sg8rdtoj.fsf@suse.com>
Date:   Mon, 30 Nov 2020 10:02:47 -0300
Message-ID: <87pn3vhua0.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aur=C3=A9lien Aptel <aaptel@suse.com> writes:

> Paulo Alcantara <pc@cjr.nz> writes:
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index e27e255d40dd..55853b9ed13d 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -338,10 +338,8 @@ __smb_send_rqst(struct TCP_Server_Info *server, int=
 num_rqst,
>>  	if (ssocket =3D=3D NULL)
>>  		return -EAGAIN;
>>=20=20
>> -	if (signal_pending(current)) {
>> -		cifs_dbg(FYI, "signal is pending before sending any data\n");
>> -		return -EINTR;
>> -	}
>> +	if (signal_pending(current))
>> +		return -ERESTARTSYS;
>
> Can we keep the debug message call?

Yes.

Steve, could you please update for-next with above debug msg?
