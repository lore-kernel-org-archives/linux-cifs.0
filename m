Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C24C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Dec 2021 14:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358391AbhLBOIy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Dec 2021 09:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346972AbhLBOIx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Dec 2021 09:08:53 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CCCC06174A
        for <linux-cifs@vger.kernel.org>; Thu,  2 Dec 2021 06:05:30 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id k23so55127653lje.1
        for <linux-cifs@vger.kernel.org>; Thu, 02 Dec 2021 06:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sH/dx0PWIRf/nyUfXPKS1HuBeZ492P76yyzYIlfBzlk=;
        b=nG6m5LBffrvVUBeR8EILlrGjRRZTiO/MSyRFRse1cJherB8Hbuh3VBM66gcW3lhGwi
         TLivxwG2iA/eYXru9US6CM01dFdvRnrJwz0qe07FG39KU0R5wasr1gmcZrdjDfscMnPg
         xwp4bpwPXMCEHSUsdnMQUlhLvKwzdVQ7Nv4u6YtYO6HEDfzS4RZTonoXH/9YaCSQGOM7
         D0WljYTgnLkSTU2aR3Ecor9urmPUogf1dII9/xOtBw0sfHFkMPjRZzE4uI/MCYUZtlcO
         N/2QSDUaryaTb/o7E0efQMSIq33/xi+LYrRqPyeCzsvFN3DawJh50+yPjmr7DTAMRsZD
         e4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sH/dx0PWIRf/nyUfXPKS1HuBeZ492P76yyzYIlfBzlk=;
        b=JdIa/glueDrPS6DTd2neqLiN6aNlzVw68/L8Tx2og6EC+w80yvr2b5QVOfJk1aJeZ8
         z6Rpj822yUQnkqga9AnipBD+mlHnQ+0BlD9kT9kZXBGCLE7/SRewb+rw/gCYDT19C412
         wNYXJxkfZqo+8qoVSQbgwYcCHfzB7K+S6rM4D9Yqmn7HoBYsilpT23SHGx37cNdTDVjq
         7Dfr5MT/JMVms75B07hc6+d//rBezhN2sNk31VggyTRynB46L64zJEACWmB5cIcLXofe
         QH18J+rrab7fkG3CBwcn30B0QxIhNLCBHLIItkV2AEB0ynSJPvUIJWQV4+PjWatix3ml
         WXbA==
X-Gm-Message-State: AOAM531hxTiMjA29wCNeRA0a0eWRmfA8ROFfxomW/9qQXByGnXIw2T5J
        KA//OJpOxHUvCGobg5R7DnhTTYR0NYSb1g+ynNI=
X-Google-Smtp-Source: ABdhPJwURjGwniTplrc3gL+hSovK1xwC0mTDMdGLk/MZ0Fvu5GcWsXKJVPZWLbPTW1i+Ph9caN2a5urTaAeILROvAwE=
X-Received: by 2002:a05:651c:90:: with SMTP id 16mr12083591ljq.1.1638453928602;
 Thu, 02 Dec 2021 06:05:28 -0800 (PST)
MIME-Version: 1.0
References: <20211130184710.r7dzzfhak4w3eoi6@cyberdelia> <CAKYAXd9b0Pji2+Ek9ZcRjN0SfZd4jzyNtDLKwzySh4WCjmSYkQ@mail.gmail.com>
 <CA+_sParqF63m24NjL4o42agyk3mU_Cq1A-kpKFBpZaGmhdWYqg@mail.gmail.com>
In-Reply-To: <CA+_sParqF63m24NjL4o42agyk3mU_Cq1A-kpKFBpZaGmhdWYqg@mail.gmail.com>
From:   =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>
Date:   Thu, 2 Dec 2021 15:05:18 +0100
Message-ID: <CA+5B0FPK+o+yBUFAVL1fteAbbGu3a5FPxdQYGGKmFwvf9xcG-Q@mail.gmail.com>
Subject: Re: [RFC] Unify all programs into a single 'ksmbdctl' binary
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Dec 2, 2021 at 10:58 AM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
> Why?

Just commenting from the peanut gallery but as a user I definitely
prefer one self-documenting tool with a predictable UI over 3.
It's also less maintenance work I would say.

We took the multi-program approach in cifs-utils and it quickly
becomes a mess as you inevitably add utilities. We later added smbinfo
as an attempt to unify things behind 1 tool.

Cheers,
