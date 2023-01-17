Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE52DC3DA78
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Jan 2023 18:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjAQSlu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Jan 2023 13:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbjAQSbu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Jan 2023 13:31:50 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF3C43921
        for <linux-cifs@vger.kernel.org>; Tue, 17 Jan 2023 10:03:38 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 2CA147FC02;
        Tue, 17 Jan 2023 18:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673978602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a0EQXHjlHZRuk7/E+eBLMAYriAzidRzFju2Ms/2y53Q=;
        b=1CsMKMwjlW2uFy9oTGTAcYsPuAxG2yiIn87iJgpQfYFBFbiho1FcRers8BpkIgc473YYLB
        abi1D9xGg2RZOhLSCvFJqHH6vxBzMtnoQGlHcd1VAw8q77X6s7bfUDqcYKlhNQix0d5wkY
        mYpruEiKgXeYs1oh69uP4oV+s71tHAzOpxPLLojKYv9Y7psw+Xr1segXuY5ATEBqeqLeD1
        4CXK8nab7MPYZT2ppnUP7WHJbWHmry3o18T+aFXagx5zIbhEp12C2/geA+iKF8xTIHsJ1u
        SnXUmEZxbSII79B/llIWb9ZKs+lZYUPoZvGYu+LQMSPc3N7j8/x2ewrVwjfREg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     =?utf-8?Q?Aur=C3=A9lien?= Aptel <aurelien.aptel@gmail.com>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/5] cifs: fix potential deadlock in cache_refresh_path()
In-Reply-To: <CA+5B0FPp5ELawadvymYumQPSaCrCL15=2_KiCX2=91u6KBoVyw@mail.gmail.com>
References: <20230117000952.9965-1-pc@cjr.nz>
 <20230117000952.9965-2-pc@cjr.nz>
 <CA+5B0FPp5ELawadvymYumQPSaCrCL15=2_KiCX2=91u6KBoVyw@mail.gmail.com>
Date:   Tue, 17 Jan 2023 15:03:18 -0300
Message-ID: <87v8l5ujh5.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aur=C3=A9lien Aptel <aurelien.aptel@gmail.com> writes:

> On Tue, Jan 17, 2023 at 1:35 AM Paulo Alcantara <pc@cjr.nz> wrote:
>> -       down_write(&htable_rw_lock);
>> +       down_read(&htable_rw_lock);
>>
>>         ce =3D lookup_cache_entry(path);
>> -       if (!IS_ERR(ce)) {
>> -               if (!cache_entry_expired(ce)) {
>> -                       dump_ce(ce);
>> -                       up_write(&htable_rw_lock);
>> -                       return 0;
>> -               }
>> -       } else {
>> -               newent =3D true;
>> +       if (!IS_ERR(ce) && !cache_entry_expired(ce)) {
>> +               up_read(&htable_rw_lock);
>> +               return 0;
>>         }
>>
>> +       up_read(&htable_rw_lock);
>
> Please add a comment before the up_read() to say why you do it here
> and where is the dead lock.

Ok, thanks.  Will send v2 with your suggestions.
