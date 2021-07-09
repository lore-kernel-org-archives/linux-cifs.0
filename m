Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46872C07E99
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Jul 2021 23:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22180613BF
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Jul 2021 23:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhGIXQY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Jul 2021 19:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhGIXQY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Jul 2021 19:16:24 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750DCC0613DD
        for <linux-cifs@vger.kernel.org>; Fri,  9 Jul 2021 16:13:39 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id v14so26412244lfb.4
        for <linux-cifs@vger.kernel.org>; Fri, 09 Jul 2021 16:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d5+K8ikK4uRN9oKty0QlKM6SLniHB5u6byf3uJhMW5A=;
        b=m4ynMt2R7cag3TxmuYBqyCg3l758p2qtkKTQwXYgurcQbVLpq32GvVWStK1moCED6p
         JbdEY1sP/wDfmJUIMp8yycDAiyt/WonykIva7FV+SBApEEIPBaXlLUU6Z9+eQahdIF5y
         osNKmu2xj/BIOEBIQNHSeEuPRdg5yXal6+Q2110CL/O/3uuCeqwOAAqWDeDagt+8PYYg
         sZOb15f+gwd1NN0S4SCMzjFY5a/QHzJWDXkaZoSGbARk+ebhLznqmoehkSrOtom6FHrH
         w3e0Eom7HlQDSlv4q5GHOaz/THYbU5iY57w2dpMY+YIvBb1UahaFtKW7OrkBK2gtoS9s
         quDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d5+K8ikK4uRN9oKty0QlKM6SLniHB5u6byf3uJhMW5A=;
        b=T8GvTu2gdLjec+Rr4qGc4OpcXOSGJIaU9LS2H4UWpmrhvQYYKs0e2Hiw5Z13q8flQi
         3FlnkO5Kkocc1ilOlhB3Eaq234TvIdLMbFWT+yyvG8BxM4rZcETbLtmLnxZROW/n1Mjs
         wvzuySa6aj2lGgy+nRR8AVohfpjaGkqlsJisNhOpuZazYYfMI86Dq3P1P7N5tI1QXkfL
         IQaOm++D1c7sIDau4SuSTGu/hDZ+G2z7vldgQZeqfJipEJeWq8+pGyEJZpzed577lv56
         iYUFtzPf7hLA/hi4o+aKwAzwpxcpaHhIo1bzDgp7DOxChUyplfDsUEIZqc6ApoutF1w/
         ZaLw==
X-Gm-Message-State: AOAM531GHkmXyR/Obi2H58UVD0zwZkBTMudodpuYlgpPxFctH+/InNu1
        oCN9AWYdifi/h7VlW6NS7wBNHi8r4aJsJ6kivdwfLZdDWt0=
X-Google-Smtp-Source: ABdhPJwqCP0V14HxuND94Tx+XulOxrQ0kz85JHM+hZnGUMJxHz2MHasu5iesdeaMkxTa557cI9rx2i9cV7w/33+/oDM=
X-Received: by 2002:ac2:5149:: with SMTP id q9mr31310138lfd.313.1625872417436;
 Fri, 09 Jul 2021 16:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msu6Or-pOXFx23S9d7_3Uu8UoftiJMqL5dBL7Ji=MsxaQ@mail.gmail.com>
In-Reply-To: <CAH2r5msu6Or-pOXFx23S9d7_3Uu8UoftiJMqL5dBL7Ji=MsxaQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 9 Jul 2021 18:13:26 -0500
Message-ID: <CAH2r5mte9Phy5bAHNHeVZ-2CX-N1JYoxV7ZUjDZvAbiOdGGTcQ@mail.gmail.com>
Subject: Re: DFS name resolution bug
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

nevermind - user error

keyutils was not installed as a dependency of cifs-utils ... so had to
install keyutils

On Fri, Jul 9, 2021 at 5:46 PM Steve French <smfrench@gmail.com> wrote:
>
> I saw a strange error testing DFS today.
>
> When I connected to the server it gave out the referrals with the
> server hostname.  Since the client wasn't configured for DNS, I had
> added an entry in /etc/hosts for that hostname with the correct ip
> address.
>
> When I ping the hostname it works ... but mount still fails and in
> cifs.ko I get "dnfs_resolve_server_name_to_ip: unable to resolve: ..."
>
> It looks like a locally configured (/etc/hosts) address doesn't work
> with DFS on Linux client.
>
> Ideas?
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
