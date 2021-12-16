Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0EBFC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Dec 2021 02:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbhLPCHP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Dec 2021 21:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbhLPCHO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Dec 2021 21:07:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64960C06173E
        for <linux-cifs@vger.kernel.org>; Wed, 15 Dec 2021 18:07:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 839E8B820FE
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 02:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50737C36AE3
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 02:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639620431;
        bh=bv/X4E6/VTgU9QEv9Y988I7T66LlAgadqgc8nK97nX4=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=XT917B07e88VrwQP1ZASXnWc4bcq4ciBmfW4/Oahr4YMxmcBqQ4Wx/8zTGJFqzHx+
         P1NHhBTrpB4U3UFjptADDgTWpqcVO8ICJkTEU11Im7r9ZoqJWUE2ZlMVDRKKBU5QxZ
         u0mM8NfygopC/9fmYe137ft9y5z2P0vL64EOxISjAH2f/pmY8f+b+o77qhyNA3T47H
         EgPJgMI2WbaqgiEfE89wuW/2waQvzjsWdJ4CMbicFkwVJr0yABlVBO8+Itd2uSvYqC
         ecQ972EYxi/QCSn8AjrwdeR9ZzZ2bYHyf/51PdhuOfkqkytNic5FaBhySp0dBFkLsD
         fxeHA+4zxZ9Ig==
Received: by mail-oi1-f178.google.com with SMTP id t19so34365547oij.1
        for <linux-cifs@vger.kernel.org>; Wed, 15 Dec 2021 18:07:11 -0800 (PST)
X-Gm-Message-State: AOAM532jFMdQbhTmL00VE1tUszZRfRw9XOEXX6RaCmCE3wpq4AH7SNIh
        yoq5HGfhyEHSTPQvpeqBUQhfWMiAyN2FFuza0VM=
X-Google-Smtp-Source: ABdhPJzRlAuvZbaLNpVc6bYCXVev7Sik8iPcLNih2x+zlS9XjPw6EhKuJHgsIds/k2pvVjclEvgf+7AdMRUGy2coipo=
X-Received: by 2002:aca:c650:: with SMTP id w77mr2533323oif.8.1639620430577;
 Wed, 15 Dec 2021 18:07:10 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:428a:0:0:0:0:0 with HTTP; Wed, 15 Dec 2021 18:07:10
 -0800 (PST)
In-Reply-To: <CA+_sPao7zLjEpwsM7i96Mrohe8Uqpd=qzAq+ykw=K0NWjtLxYA@mail.gmail.com>
References: <20211130184710.r7dzzfhak4w3eoi6@cyberdelia> <CAKYAXd9b0Pji2+Ek9ZcRjN0SfZd4jzyNtDLKwzySh4WCjmSYkQ@mail.gmail.com>
 <20211215150008.u26snbaml5amlaep@cyberdelia> <CA+_sPao7zLjEpwsM7i96Mrohe8Uqpd=qzAq+ykw=K0NWjtLxYA@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 16 Dec 2021 11:07:10 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-DX+1P5hxYoPkDkGow9GuNY-m5bErqUbXz8OUDQxNZMQ@mail.gmail.com>
Message-ID: <CAKYAXd-DX+1P5hxYoPkDkGow9GuNY-m5bErqUbXz8OUDQxNZMQ@mail.gmail.com>
Subject: Re: [RFC] Unify all programs into a single 'ksmbdctl' binary
To:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Enzo Matsumiya <ematsumiya@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-12-16 10:38 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
> Hi,
>
> On Thu, Dec 16, 2021 at 12:00 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>>
>> Any feedback on this proposal? Should I focus on polishing + splitting
>> into meaningful commits?
>
> I haven't gotten a chance to look at it yet, but in general I have no
> objections to the "git-way" implementation.
Thanks for your point out and opinion:)
Enzo, I will check your work at detail today. I will reply soon.
Thanks!
>
