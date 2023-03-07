Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0539C678D5
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Mar 2023 07:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjCGHKU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Mar 2023 02:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbjCGHKR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Mar 2023 02:10:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BE038024
        for <linux-cifs@vger.kernel.org>; Mon,  6 Mar 2023 23:10:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A099B8164A
        for <linux-cifs@vger.kernel.org>; Tue,  7 Mar 2023 07:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7C1C43445
        for <linux-cifs@vger.kernel.org>; Tue,  7 Mar 2023 07:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678173012;
        bh=vDqJXAAzKZIs70F/RgLaiqJfSZS5pSmUThDPohDy0Qs=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=PGKUtJPgn2Czp/gLHo99tAlSlgYgR4nvqpWxdlre0gwPcIloeMHXTAhOJSYN+zcd3
         35B9/zih1owkik0s6PejjUPIICjHBObeW3w+OKgALWMj5f2EBVcqd6abqrKL1F/NbP
         pyJwnnFHROJ616eyRzXetIa7X+jLppl51D4VK1dE+FYB+lNWF/ltpSTNZH3Dl9ZlKG
         vRJE+86h/j8JZaVz+BNMJONC+9kx4IsQjTqCtoczV377QHaSaqEUC7NLyJWhkC5bhQ
         A+ifKecw7PNMotSxDjOeWu9k7FtPGmmf1DYNLtK/hlssGjf2nTlFxrrhCldECfcwuh
         J5cHcRRAPo4jg==
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-1767a208b30so12241616fac.2
        for <linux-cifs@vger.kernel.org>; Mon, 06 Mar 2023 23:10:12 -0800 (PST)
X-Gm-Message-State: AO0yUKWh+QHCDMsEsOXG9B5yEafpw9UcSyBkZTUOmOTXkqIQggwYH9Ga
        eM5oLAkib74V3rdp5G5+EVvNEyNPim1XQxBtpV0=
X-Google-Smtp-Source: AK7set/uzrH21Jl10s07UAnnwHtObRmhB8JH6fgA9d4ylf4vpbP90ZaA+SBqXq4qGv7XRYTXhMwDB5mSvRqXPQhtoeo=
X-Received: by 2002:a05:6870:5ab3:b0:176:69f4:d98a with SMTP id
 dt51-20020a0568705ab300b0017669f4d98amr3783487oab.11.1678173011981; Mon, 06
 Mar 2023 23:10:11 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:67ca:0:b0:4c2:5d59:8c51 with HTTP; Mon, 6 Mar 2023
 23:10:11 -0800 (PST)
In-Reply-To: <20230307040952.GF5231@google.com>
References: <20230305123443.21509-1-linkinjeon@kernel.org> <20230305123443.21509-2-linkinjeon@kernel.org>
 <20230307040952.GF5231@google.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 7 Mar 2023 16:10:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8eSsAZvbAFthuuWy-jy6VLv13pihCAUwygVrS2gh1B=A@mail.gmail.com>
Message-ID: <CAKYAXd8eSsAZvbAFthuuWy-jy6VLv13pihCAUwygVrS2gh1B=A@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: add low bound validation to FSCTL_QUERY_ALLOCATED_RANGES
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com,
        atteh.mailbox@gmail.com, Dan Carpenter <error27@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-03-07 13:09 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
> On (23/03/05 21:34), Namjae Jeon wrote:
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -7457,6 +7457,11 @@ static int fsctl_query_allocated_ranges(struct
>> ksmbd_work *work, u64 id,
>>  	start = le64_to_cpu(qar_req->file_offset);
>>  	length = le64_to_cpu(qar_req->length);
>>
>> +	if (start < 0 || length < 0) {
>> +		ksmbd_fd_put(work, fp);
>> +		return -EINVAL;
>> +	}
>
> Can we do sanity checking before we ksmbd_lookup_fd_fast()?
We can:), will update it on v2.

Thanks!
>
