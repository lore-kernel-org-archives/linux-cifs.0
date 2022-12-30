Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD045C4332F
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Dec 2022 03:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiL3D4z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Dec 2022 22:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiL3D4y (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Dec 2022 22:56:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8132A13D25
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 19:56:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC1526170E
        for <linux-cifs@vger.kernel.org>; Fri, 30 Dec 2022 03:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47168C433F1
        for <linux-cifs@vger.kernel.org>; Fri, 30 Dec 2022 03:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672372612;
        bh=4gso4AJMH+R72EbkmWr2Rt7sWmWI5P28knu5oNPkcXY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=IheRJPewsXJEGgs9PL8TsOA1B3bpR/Vj01YRO0SBg9OCO52i7lPrHpWh28lFFzun2
         irYAO/AKRRVPuImSUH6Uyb0vpYn7mIclNdsY+fCxLoe6OnIb7asEPAkuLJKrYYRd57
         pMry7EKv7AguwYOmaWJu5p1OABqjrDtRD+Jno4zblkP9foogwdBrHOY+n0fsCxjfmQ
         eh6WFvlTlK3Hqx5aC0jBBINWtDtClrXa22D3d7puYKcDvD8hWhFr4g8Mfp8mmYCcnk
         EIXYd3hK6r46CHxvR3ivSODKr6UqOnR/2nCOxMTTK2pBMkevMhzRxqHt+l9dzXoy2Z
         5iWcMEMlzA+7g==
Received: by mail-ot1-f44.google.com with SMTP id e17-20020a9d7311000000b00678202573f1so12524612otk.8
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 19:56:52 -0800 (PST)
X-Gm-Message-State: AFqh2kotMLK+3MOV+R2byi6rXyruLxYyAw1q9G+X6YzUxVVclNeXaECr
        ZM3OCTEaNJhJDb+1veUY/Ngo1jbtA2ZLjGkDuNQ=
X-Google-Smtp-Source: AMrXdXvFUtXvDZecNtePzA6obtFLKGdg0ZwsyFGmkwk5gTXs3wKovPL1bKRK3bpoJ7l7cjydAFxts5zFzqtAMiLfxPM=
X-Received: by 2002:a05:6830:12c6:b0:663:c86f:7573 with SMTP id
 a6-20020a05683012c600b00663c86f7573mr2117347otq.187.1672372611382; Thu, 29
 Dec 2022 19:56:51 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6838:2d06:0:0:0:0 with HTTP; Thu, 29 Dec 2022 19:56:51
 -0800 (PST)
In-Reply-To: <Y65S+r6PtXWjvmmx@google.com>
References: <20221227150213.9842-1-linkinjeon@kernel.org> <Y65S+r6PtXWjvmmx@google.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 30 Dec 2022 12:56:51 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9_SDb=B1kDcBw_uV_Cp1HQcoPqWu_ZAjH1Ywoya8_SVA@mail.gmail.com>
Message-ID: <CAKYAXd9_SDb=B1kDcBw_uV_Cp1HQcoPqWu_ZAjH1Ywoya8_SVA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd-tools: add max connections parameter to global section
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com,
        atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-12-30 11:54 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
> On (22/12/28 00:02), Namjae Jeon wrote:
> [..]
>> @@ -175,6 +175,7 @@ static int ipc_ksmbd_starting_up(void)
>>  	ev->smb2_max_write = global_conf.smb2_max_write;
>>  	ev->smb2_max_trans = global_conf.smb2_max_trans;
>>  	ev->smbd_max_io_size = global_conf.smbd_max_io_size;
>> +	ev->max_connections = global_conf.max_connections;
>>  	ev->share_fake_fscaps = global_conf.share_fake_fscaps;
>>  	memcpy(ev->sub_auth, global_conf.gen_subauth, sizeof(ev->sub_auth));
>>  	ev->smb2_max_credits = global_conf.smb2_max_credits;
>> diff --git a/tools/config_parser.c b/tools/config_parser.c
>> index 2dc6b34..5f36606 100644
>> --- a/tools/config_parser.c
>> +++ b/tools/config_parser.c
>> @@ -548,6 +548,11 @@ static gboolean global_group_kv(gpointer _k, gpointer
>> _v, gpointer user_data)
>>  		return TRUE;
>>  	}
>>
>> +	if (!cp_key_cmp(_k, "max connections")) {
>> +		global_conf.max_connections = memparse(_v);
>> +		return TRUE;
>> +	}
>> +
>
> I'd say that it'll make sense to me if ksmbd will impose a default
> limit on the number of connections, which people can overwrite. Yes,
> I know that samba doesn't limit by default, but ksmbd is a kernel
> module and the price of unlimited resource consumption is higher.
> We can't probably easily apply the "samba does it" rule here. What
> do you think?
>
> How about:
> - default `max connections`, say, of 512. max possible value, say, 64k?
> - `max connections` cannot be zero
Make sense. I will update it on v2.
Thanks for your review:)
>
