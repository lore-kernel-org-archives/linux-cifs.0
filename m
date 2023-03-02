Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A90AEC6FA8E
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Mar 2023 19:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjCBTXk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Mar 2023 14:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCBTXk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Mar 2023 14:23:40 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD4C93E5
        for <linux-cifs@vger.kernel.org>; Thu,  2 Mar 2023 11:23:39 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id y14so74210ljq.4
        for <linux-cifs@vger.kernel.org>; Thu, 02 Mar 2023 11:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vXeIewHb1764abZLcsg6DIUqvIJzjqCIgVBgPWMKmbg=;
        b=gEouu9EkbPmqCsssEQwKqrO5X13uyKs3OFuiULgplItdkd81zOJtbZRdHXGYuJLMJj
         mLSsNMgTVlqXdSZGNivaTPyRPbTlWfuPTtJE9tXrxj1I6i1YE0b7SDo/DSkAHnLrXlrC
         DSA0K6nZ36/VI9+pLmslEjypE2vWIGH02ge5co9NccMOAa666aqJhfKVXvQ+CkVPYocW
         zH/QY3TWVNuTmWp6FJRZIMNzhTZIQWZ/jq0r45cNzUve7K45CpmaGrC+VKueYAj+xj5h
         XgAth/DO4S2kLSBFYlBaoP8XFJX9xU57z4f/GYUuDIidSJMOkONx4xfNhj8mF8zlG7xy
         x8mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vXeIewHb1764abZLcsg6DIUqvIJzjqCIgVBgPWMKmbg=;
        b=lABmIWYc9+hWOfx7+p+g41gxRpz6SM5WY0BZVlj1V7Dssgfw1mfLjuTevOMCtO0Wpa
         xYYQ2yGyldWeG8BUGNL024xpO8BldTuwCMjQaY+bRyz093hC24XvWf8sKiqNuLuO7Qv/
         PJUXW2jdcndphuwUixNd3q8Kk/iO4Lgd1jqDEXbdWDQsvNOJjZj/icfMG5ssCx7jFIl7
         kBdiayY9rQsZu2FlMhm8LxFIUZXKo0AlXAtZoog9qwWnbl4OiYth14pf19O+NFlVAH1+
         5RH1nAVNvqlffp/Uo8fIOj0ZJQhT7nlxavjwSQzNq0xWOkrGdozg4+NWk0sRC9XS3D/7
         O3xA==
X-Gm-Message-State: AO0yUKXFnbYPsIIrXvCklxwrGKTC2FZ0JA0gtaMnq4Ao481+VkMZcYmJ
        mF2V8Sm0YdXzBpy4CrIJUfa7vYfEahDTT9F/zXqdXWjbuH0=
X-Google-Smtp-Source: AK7set/8rs16vomkR38a1KL83ObfFom5SHFbEVn5ahKfNp0P1MpchrfwPcM0nJGzD7iKcFtV+8SP5yDAxzlvoKEHab4=
X-Received: by 2002:a05:651c:10b3:b0:295:c458:da98 with SMTP id
 k19-20020a05651c10b300b00295c458da98mr3645009ljn.5.1677785017064; Thu, 02 Mar
 2023 11:23:37 -0800 (PST)
MIME-Version: 1.0
References: <CAB5c7xoUXH6Xy+79Wz8M4yC70E=rwUL0ZRD_ApAFWv=C7S_uxg@mail.gmail.com>
 <514a3d90d263bd8422e9d13bd4c6e269.pc@manguebit.com> <CAB5c7xrdKSO4YE_vUQ6tg+p=WwxEdquj+VrRpwKxi8Jd0vPyAQ@mail.gmail.com>
 <CAH2r5mv52koGnKbvtRKE95c_JwwtitTXFaRc6mcM8nwLmWNo9A@mail.gmail.com> <300597ce-06a5-a987-5110-aa6ec24ea199@talpey.com>
In-Reply-To: <300597ce-06a5-a987-5110-aa6ec24ea199@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 2 Mar 2023 13:23:25 -0600
Message-ID: <CAH2r5msjKi-FMQRaHptk5fPycZRSS5ZQNC-u=1wE8oxBUhN5Ug@mail.gmail.com>
Subject: Re: Nested NTFS volumes within Windows SMB share may result in inode
 collisions in linux client
To:     Tom Talpey <tom@talpey.com>
Cc:     Andrew Walker <awalker@ixsystems.com>,
        Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Why isn't this behavior simply the default?

Without persisted inode numbers (UniqueId) it would cause problems
with hardlinks (ie mounting with noserverino).  We could try a trick
of hashing them with the volume id if we could detect the transition
to a different volume (as original thread was discussing) -
fortunately in Linux you have to walk a path component by component so
might be possible to spot these more easily.

On Thu, Mar 2, 2023 at 1:19=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 3/1/2023 8:49 PM, Steve French wrote:
> > I would expect when the inode collision is noted that
> > "cifs_autodisable_serverino()" will get called in the Linux client and
> > you should see: "Autodisabling the user of server inode numbers on
> > ..."
> > "Consider mounting with noserverino to silence this message"
>
> Why isn't this behavior simply the default? It's going to be
> data corruption (sev 1 issue) if the inode number is the same
> for two different fileid's, so this seems entirely backwards.
>
> Also, the words "to silence this message" really don't convey
> the severity of the situation.
>
> Tom.



--=20
Thanks,

Steve
