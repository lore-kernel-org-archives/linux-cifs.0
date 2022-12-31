Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB332C4332F
	for <linux-cifs@archiver.kernel.org>; Sat, 31 Dec 2022 08:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiLaIWC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 31 Dec 2022 03:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiLaIV7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 31 Dec 2022 03:21:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5CE11154
        for <linux-cifs@vger.kernel.org>; Sat, 31 Dec 2022 00:21:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 952B260A24
        for <linux-cifs@vger.kernel.org>; Sat, 31 Dec 2022 08:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4E4C433D2
        for <linux-cifs@vger.kernel.org>; Sat, 31 Dec 2022 08:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672474916;
        bh=yiu62qnBfZqRNfOPcn2rma/bz9Vu59znbaypELRfBv4=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Nd4Toh0Gm8nwFQt/Rm5kz0AjF3F6vdZKcTNoFwy7TyVcKz6b8Be+6Tz7SmxNCnaSs
         8RB+sYfLS2lR6/lpumjIC1Eo0JNhKhOoxfrlUKuZbkx5WjnQ+7DIbgZRuR5bAXMyeV
         o0vOzhYXa5w6JSgoZHY4lfEqK5eOcl9sf7KYEj3Nhl482ykOFdOzXCrdg+2vJCfVLb
         Z139xJAzB4JupeV+gkaN09os/aLCtTOMHwsFTqXsnaJcNXbK/NLjaWcQtv3krwtE8v
         E0WP+9sD/NVhSqb+XaVy9p8meT0KsIszmg7WLfFC2tTj7cKv+qQ8Dub0ukPGVqJXKB
         rqQjggkkr9bxw==
Received: by mail-ot1-f50.google.com with SMTP id k44-20020a9d19af000000b00683e176ab01so9403749otk.13
        for <linux-cifs@vger.kernel.org>; Sat, 31 Dec 2022 00:21:55 -0800 (PST)
X-Gm-Message-State: AFqh2krTZx/QZcslE2SrsObvqweDeimKiMxltGDPqU8632SrBc3TKuhX
        NGpYr9OU4Gk6xAOTmMU/bRgFBmsmuXBFRWFR4ac=
X-Google-Smtp-Source: AMrXdXv3AHJhshIxxIF8b8z868POKzMgA9nh/IQwxnsWcbpaZC672k9tBB8/CWY6C+P8JnxjBw7RQV9ghXw993uPXUc=
X-Received: by 2002:a05:6830:4119:b0:670:6e9b:2c89 with SMTP id
 w25-20020a056830411900b006706e9b2c89mr2019454ott.339.1672474915104; Sat, 31
 Dec 2022 00:21:55 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6838:2d06:0:0:0:0 with HTTP; Sat, 31 Dec 2022 00:21:54
 -0800 (PST)
In-Reply-To: <Y68CyMM/swjY/mhz@google.com>
References: <20221230142420.10930-1-linkinjeon@kernel.org> <Y68CyMM/swjY/mhz@google.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 31 Dec 2022 17:21:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-f=gYAAo7_XwVpy2Rknbod2d+HepO17x1bvv5QwZ+N6Q@mail.gmail.com>
Message-ID: <CAKYAXd-f=gYAAo7_XwVpy2Rknbod2d+HepO17x1bvv5QwZ+N6Q@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd-tools: add max connections parameter to global section
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com,
        atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-12-31 0:24 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
> On (22/12/30 23:24), Namjae Jeon wrote:
> [..]
>> @@ -548,6 +548,16 @@ static gboolean global_group_kv(gpointer _k, gpointer
>> _v, gpointer user_data)
>>  		return TRUE;
>>  	}
>>
>> +	if (!cp_key_cmp(_k, "max connections")) {
>> +		global_conf.max_connections = memparse(_v);
>> +		if (global_conf.max_connections > KSMBD_CONF_MAX_CONNECTIONS) {
>> +			pr_info("Limits exceeding the maximum simultaneous
>> connections(%d)\n",
>> +				KSMBD_CONF_MAX_CONNECTIONS);
>> +			global_conf.max_connections = KSMBD_CONF_MAX_CONNECTIONS;
>> +		}
>> +		return TRUE;
>> +	}
>
> A quick question: do you want "max connections = 0" to be possible or
> should ksmb never permit unlimited connections?
updated it on v3.
>
>> +	global_conf.max_connections = 512;
>>  }
> [..]
>> +	share->max_connections = 512;
>
> A nit: may be have a define for default limit instead?
Okay. Thanks for your review!
>
