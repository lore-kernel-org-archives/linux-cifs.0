Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C60A8C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 11:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EF50610A0
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 11:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhIULIN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 07:08:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231956AbhIULIM (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Sep 2021 07:08:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90B65610A0
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 11:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632222404;
        bh=/a4bigzdiUGrm7GiCRsNfi3hd2DQH6o+U7HzzeQcMyY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=D7+WFNV3cD4Js6AQ38DGkwLVdN4h+f2oGR8pwZMYN8WdZeqTjj/f3uP7pHp5PL2qQ
         oKZzL7z7vJYzRhmTLy6DJ00w/FiS1WOv7E/VoIFpYUrvSww19RinK0g07SNwXrqisl
         gXlWctUrWbFGPgCGiN7tTE5Fqz8bTHTtkZ5UhJQSl1AxTjVD5+OI/n2qgGtzCwr9K5
         hbEeFOmZFIzvJP8SthOGYJCq7jC86HcRkX4+U7+8/KVvj1gLlx+zwLFSyF7OAVVSZL
         fmaD4nTj014L6DlWTDVd1uvQ4v/f7C7axnPApGnMeILM9OPp+PcQ6ryhpBnf7CXOiy
         BtBJi71VIhm1Q==
Received: by mail-ot1-f43.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so27762160otq.7
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 04:06:44 -0700 (PDT)
X-Gm-Message-State: AOAM53389amtqd2srEiI/IJ402+gQvsoMJWKz6Jg7mizA6FjD2fzMPXS
        GK97f7gZ0qyqhbS2NrPJVSA03KMer2ElR5HZzTE=
X-Google-Smtp-Source: ABdhPJwwWIAAHTE+LVHApww8OkryH8iY4XRWwNVuj9Z1NBCjraquDndSxcGm4/0fy7Tzt2VjBcBYinkj0z0ncw5D+Po=
X-Received: by 2002:a9d:4705:: with SMTP id a5mr8442311otf.237.1632222403977;
 Tue, 21 Sep 2021 04:06:43 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Tue, 21 Sep 2021 04:06:43
 -0700 (PDT)
In-Reply-To: <d9f2a3c9-b9fb-9896-b318-466563e9cd56@samba.org>
References: <20210921044040.624769-1-linkinjeon@kernel.org>
 <20210921044040.624769-2-linkinjeon@kernel.org> <d9f2a3c9-b9fb-9896-b318-466563e9cd56@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 21 Sep 2021 20:06:43 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8N74WvriorwC7-4W-Mv-oseADrL07Ds5DPFAACWmYoAw@mail.gmail.com>
Message-ID: <CAKYAXd8N74WvriorwC7-4W-Mv-oseADrL07Ds5DPFAACWmYoAw@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: add request buffer validation in smb2_set_info
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-21 16:38 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Hi Namjae,
>
>
> Am 21.09.21 um 06:40 schrieb Namjae Jeon:
>> Add buffer validation in smb2_set_info.
>>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   v2:
>>     - smb2_set_info infolevel functions take structure pointer argument.
>>
>
> perfect, thanks! One nitpick: we should either split out the
> smb2_file_basic_info fix into a preceeding commit or at least mention it
> in the commit message.
Will update patch header description.
>
> With that change: reviewed-by: me.
Thanks for your review!
>
> Thanks!
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
>
