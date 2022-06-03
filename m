Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82523C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Jun 2022 01:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235464AbiFCB1A (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Jun 2022 21:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236587AbiFCB07 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Jun 2022 21:26:59 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6504D102C
        for <linux-cifs@vger.kernel.org>; Thu,  2 Jun 2022 18:26:55 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id n20so2874917vkl.9
        for <linux-cifs@vger.kernel.org>; Thu, 02 Jun 2022 18:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=p9iH7wtgv1cNM9gumnTLowj/6zQXhnsv8M3PwDG3cJY=;
        b=qHY+Yxzyh8ydpQxFq0i41yjrhRAlynBi9u8u8/f6r2VcWnr10fpISivudoKCxIMlVN
         iEM5/O0nTQ4yUMQAIbzATEmvToPxFAPkI8L828b48JIe+j6GYPB/wopUC5L+wM9TTSIY
         LdAKwVXcYOlxv7zy16DAEbV2C8IfIcJEvXnqwQoeYdsoB2797sP8y0YTwD890CK7LkYd
         J2KDWo9xdcgih5NcoSLw/y15xV8iXdILDo5QDkBYaJTz9rG+k4FaC/V3Pyo8U6oBF1Gg
         UU3d7llox2fx5pC/ns2UqwrFlZUfeBWeMSFRt4ydF/1IJ42nUxxbYN6uMPrTV0a/jYlS
         Nudw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=p9iH7wtgv1cNM9gumnTLowj/6zQXhnsv8M3PwDG3cJY=;
        b=DjlOAlKQdQI0nU+lvS02rmZBJFLPJ3+Qchv6VAYjcDyBUSY5E7jRAFgC/WJWf45e2e
         phwqatJdzVV8EsU48d1mqDgRe6dOMDlov4+MYDmuqhfqd7uEhpG8cttM45jSGwDzYL3M
         6E55E/V0GZs7QOs7HjWCaDMmeKxMnCWVDrBpr4qftPGZVIRXpeuit/n3mpjLTJltH8t4
         qHM5oD5TAZDTcno/ZtK0ZNlqHjqIvAxqskItbIGwHcZPqhZXy5AUPQDb9J0f0m3Ljgkk
         t9ocO/+ByY4G24No90FJSTMpihPzXPrdheS10MOhtR/g3xgpDO5ymF+jshVRg5z9rfhL
         8WTw==
X-Gm-Message-State: AOAM5333Jr7VGL2mrj3+dtZOHnGZarYfdzB3GsxK3vSwP2HqnFYlaVbb
        1wsHJrWLHIFWGbH9Rr0lUrREq+uOy7gxkoGDcMXOwgRI
X-Google-Smtp-Source: ABdhPJxvCA+4kbYP9m3nFJ5c8ckOQvbaUvrvRWDuebExGjxWaikRwtdlCblQ5ZkyNCI+ocYuHf7SwLnVK+6S6m/285A=
X-Received: by 2002:a05:6122:2027:b0:35a:19c8:3ec7 with SMTP id
 l39-20020a056122202700b0035a19c83ec7mr14679376vkd.4.1654219614778; Thu, 02
 Jun 2022 18:26:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtUe2f0xi5zu0Np0bkyv7K9BKKgUkUJp2b25BteHBFjeg@mail.gmail.com>
 <CAH2r5mufZdKWrUGbp0Pha5C6YrYqUR-=vT2Pw8TixtzVaQuk0Q@mail.gmail.com>
 <359a28c9-1d6e-6908-6502-ffb29bcadca4@talpey.com> <CAH2r5musMTR_jEJ40mQAmzZs6wypVce3vjp_0EMgB9QNHJdL8g@mail.gmail.com>
In-Reply-To: <CAH2r5musMTR_jEJ40mQAmzZs6wypVce3vjp_0EMgB9QNHJdL8g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 2 Jun 2022 20:26:43 -0500
Message-ID: <CAH2r5mtMqsqq+wGf5oE3ZGE5JwZ+Ln2eENF2GxuG9MSDW5qRjw@mail.gmail.com>
Subject: Fwd: [PATCH][CIFS] Do not build smb1ops.c if legacy support is disabled
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

---------- Forwarded message ---------
From: Steve French <smfrench@gmail.com>
Date: Thu, Jun 2, 2022 at 8:23 PM
Subject: Re: [PATCH][CIFS] Do not build smb1ops.c if legacy support is disabled
To: Tom Talpey <tom@talpey.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, samba-technical
<samba-technical@lists.samba.org>


I was thinking about staging smb1 removal gradually over about a year
and a half (assuming that Samba has the SMB3.1.1 POSIX Extensions
merged in from jra's tree by then so no excuses functionally to
removing smb1)
- marking the CONFIG_CIFS_ALLOW_INSECURE_LEGACY as recommended 'N'
starting in next release 5.20 and move some additional SMB1 code into
the #ifdef
- in 5.21 pulling some of those smb1 specific pieces into a new helper
module (perhaps smb1.ko??)
- in 5.20 or 5.21 renaming fs/cifs directory to fs'smbfs_client (or
something similar)
- evaluate whether we can change the default module name to smb3.ko
from cifs.ko (we already have a module alias for cifs.ko of "smb3" and
have for years been able to "mount -t smb3" with cifs.ko)
- in 5.21 note that insecure legacy support is scheduled for removal
(perhaps a year later), and if anyone mounts with "vers=1.0" (or
vers=2.0) print a warning that it is scheduled for removal in a year.

Thoughts?


On Thu, Jun 2, 2022, 11:39 Tom Talpey <tom@talpey.com> wrote:
>
> LGTM, but I had some additional suggestions that I found when
> researching how to yank the entire SMB1 code into a module.
> Which actually looks quite possible, but for another day.
>
> This patch doesn't actually stop building smb1ops.c and cifssmb.c
> however. Don't you want to deselect them in the kconfig?
>
> Feel free to add my
> Reviewed-by: Tom Talpey <tom@talpey.com>
>
>
> On 6/1/2022 11:45 PM, Steve French wrote:
> > Another minor one to remove some unneeded SMB20 code when legacy is disabled
> >
> >
> > On Wed, Jun 1, 2022 at 9:39 PM Steve French <smfrench@gmail.com> wrote:
> >>
> >> We should not be including unused SMB1/CIFS functions when legacy
> >> support is disabled (CONFIG_CIFS_ALLOW_INSECURE_LEGACY turned
> >> off), but especially obvious is not needing to build smb1ops.c
> >> at all when legacy support is disabled. Over time we can move
> >> more SMB1/CIFS and SMB2.0 legacy functions into ifdefs but this
> >> is a good start (and shrinks the module size a few percent).
> >>
> >> --
> >> Thanks,
> >>
> >> Steve
> >
> >
> >



-- 
Thanks,

Steve
