Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F222C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 00:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82F2461288
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 00:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347173AbhI3AeJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 20:34:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233113AbhI3AeJ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 29 Sep 2021 20:34:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 685E061368
        for <linux-cifs@vger.kernel.org>; Thu, 30 Sep 2021 00:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632961947;
        bh=4iixx0YTuEY02RArJoFVqyMMII/Y9ZMjhH7hoGhRvzE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=BsOQQytl/ukCJZYDGHVPXa3llV/5C7G1/9hSu1dmSYEvsjI8rjVDxdeC+2ZOucT/Q
         PEjxuMdcVNqD0PaDNDgWIWcjUPFbP9yznqq8J1pimzIpaf/8AacqeAYYahORYcg9Nw
         qfRLJf41+NxTpnnELwY1eVoUCmf9U7vxblrneVDt81W5BsHX8eLQdW0sdy2xCc7qfg
         iUDPUOxCOZECy5pMVvV4qczXUVrf2LVSo2gZfQa05rdbI0oxi8IQlzBJxMgl0LeBuX
         FqIW5vT6bf1vWc1SLTrS0AS2Btfdh2CnKUXcSHmK2qtOETXyJvPTt9aNES5VP3lE9o
         Y1QLZyz5UYmng==
Received: by mail-ot1-f46.google.com with SMTP id 5-20020a9d0685000000b0054706d7b8e5so5170504otx.3
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 17:32:27 -0700 (PDT)
X-Gm-Message-State: AOAM5308tQFqrTFv2Zu6CBx2xMJEOmUt4ztjdjKM8MmwBA4RIVXaQXhA
        jqfl+xiHN62jITFvea/6egBc9G3b3pUl9QqChJc=
X-Google-Smtp-Source: ABdhPJwQ2Nlf3OsTJC1cfN8E7Zcp7VThL5ncyA5ZQtNqC3v1B2MfA4zp7k4XEl+YxMzlCklkNu0TrFfKGzhqrDnzyy0=
X-Received: by 2002:a9d:4705:: with SMTP id a5mr2520750otf.237.1632961946787;
 Wed, 29 Sep 2021 17:32:26 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Wed, 29 Sep 2021 17:32:25
 -0700 (PDT)
In-Reply-To: <0132d0cb-5efd-f042-d8d6-720e7f3dc69b@samba.org>
References: <20210926135543.119127-1-linkinjeon@kernel.org>
 <a15a1d99-1a2f-0f41-773e-def5b83f2304@samba.org> <CAKYAXd8G5xBBLTS0vS_p1TFoULuxSf-CFjE4n98D+sQrtjpjcw@mail.gmail.com>
 <b9449e7f-5c27-c766-f8e0-1564b8848f7b@samba.org> <8f57cac6-1c8a-cbce-b245-bb4015575569@samba.org>
 <CAKYAXd88PNFg4oXisxw8fnUBzCQyceC=2KvPhdU7q6DUgatQbw@mail.gmail.com>
 <79ed52be-c92e-1c62-423f-ee126b3da409@samba.org> <YVNR6w7dq0HMIcFA@jeremy-acer>
 <76fcdc45-0a94-d9e6-14c8-1c638d0bd00f@talpey.com> <YVSJWPa8dalyzsl0@jeremy-acer>
 <ce52c130-74de-feaa-6995-6a0d947816a6@samba.org> <27908e3e-140e-8c7a-e792-414fec5b5190@talpey.com>
 <CAH2r5mvPy0UBJ2z=gSbyOSK9cMYMdB-Unr4Jk14Fve4W1XFTJQ@mail.gmail.com> <0132d0cb-5efd-f042-d8d6-720e7f3dc69b@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 30 Sep 2021 09:32:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8R2OQ3=m8HjUffph5+hw_D2KaT60ZDsYmEtCqEFE3gQQ@mail.gmail.com>
Message-ID: <CAKYAXd8R2OQ3=m8HjUffph5+hw_D2KaT60ZDsYmEtCqEFE3gQQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
To:     Ralph Boehme <slow@samba.org>
Cc:     Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
        Jeremy Allison <jra@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-30 2:18 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Am 29.09.21 um 19:11 schrieb Steve French:
>> gitnub is fine for many things, and we can automated "kernel
>> development process"
>> things presumably with github easier than alternatives:
>> - running "scripts/checkpatch"
>> - make with C=1 and "_CHECK_ENDIAN" support turned on
>> - kick off smbtorture tests (as Namjae already does in his branches in
>> github)
>
> you can also add "doing review". :)
>
> As for running tests: I want that as well! :) How can I get that? Maybe
> other want to run CI on their patches too before posting them.
>
>> BUT ... we have to ensure a couple things.
>> - we don't annoy Linus (and linux-next and stable maintainers) by doing
>> things
>> like web merges in github (he complained about the
>> meaningless/distracting
>> github web ui empty merge messages)
>
> as said before: just don't do the merge there, just the review. That's
> the way Samba has been doing it for years. Are you actually aware of the
> current Samba workflow?
Is it friendly to new developers? I know samba workflow now too. New
developers can do everything easily by simply subscribing to the
mailing list. And do we review only the SMB protocol on github? If we
review and discuss kernel common code usage and touching, it should be
visible to the component kernel maintainers as well.

And is the review history likely to be discarded on github? Doesn't it
get thrown away the moment you change or update a patch? Also, review
discussions left on each individual's github cannot be easily searched
like mailing list.
>
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
