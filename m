Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AEDAC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Mar 2022 13:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241350AbiC3NMD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Mar 2022 09:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345756AbiC3NMC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Mar 2022 09:12:02 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C05216FA4
        for <linux-cifs@vger.kernel.org>; Wed, 30 Mar 2022 06:10:16 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id bh17so1937489ejb.8
        for <linux-cifs@vger.kernel.org>; Wed, 30 Mar 2022 06:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cxUFTuuWwIplmPTKmt1X0J2bXcZnq48BVdraRiov6fY=;
        b=bmC4xzzlj0qOwLm/EBu7Nh75KL1SLs32qHcl2jvgOuNX8pPZy778rM6txHUOMe4jfs
         kYv7gH2AJR8sLkkH9n1NtQ785PhtHTI+11onoH9uJOmeRdohHwZB94A3I4g5kMn7hs4e
         7k2z5OsT8qvDIPKU0uKt3mUE3DTyzu2KzdWtkKVLixJqPyQyN3mMWRl0vuKxCUjirspx
         vwR3+bGmmTs9YJDQ41nLTPekq54zFisf4Y3rg4JBjj7I2OWMEgHRJ+sS/85kJH3VtAd6
         v3YCYXYB04PIntAYwZ95KongT8SzYAsrST8aTIkB1wx5GOCYGWtWDM914v0BEoH1abCB
         LzRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cxUFTuuWwIplmPTKmt1X0J2bXcZnq48BVdraRiov6fY=;
        b=Nd4So/cD9BHXJgf3ULJmXfKULTzsp8nhVOCr38dNqHlPKPRxxUS4YGjBggEbeSjira
         8i1ckizu5KZcr8ZzUyVDymCaRs3f/jw++OIwjWR00a7S1Ho5dITAlyKgH9OYs9xV1Y3Z
         BfDeg37VgEf2dw9bOeI2gjbSir/6gcYVgF+a7EyuLqiBzEw2pf59XYBdlpnqlVzoEdsx
         EigCKhqio7xKssjvX/yfmryWp55T7Fg5mdS6qzkglHboTDE6yE5SW20Z/Db1B8Sa4zJQ
         qhKobAY7+udtxsTTtbb+FkmlCKyEP8/HAH+gWviH538mE74izwttFwRA6H4549stSFcp
         Xlww==
X-Gm-Message-State: AOAM530MqRLGMIdWJS++RwAwk5y6qXjCFxYXMr6Bc8hkbiydVKUQgxqT
        vYGQIYEO6hMTDK6RzPrStaznnL73112Xol3TXaI=
X-Google-Smtp-Source: ABdhPJyBnt7P/0YBHuRV4GI6oOgzsZMJXmFxhSxqSPHiNtxBi9NPitajQvi89qp7nQUTiU8xdp9n/moWg9JAxZXmcgg=
X-Received: by 2002:a17:906:d1c4:b0:6d5:83bb:f58a with SMTP id
 bs4-20020a170906d1c400b006d583bbf58amr39994235ejb.672.1648645814614; Wed, 30
 Mar 2022 06:10:14 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=oU3E6v639bXKQd4ssEvWmAWEDD0qUOixcwONzJyLYgOg@mail.gmail.com>
 <CANT5p=rTosSwc3fer_dYgDFhTuEeeK5rxYxQMK+M2QuZu8fzpw@mail.gmail.com> <20220329151947.moon56737kryfrh3@cyberdelia>
In-Reply-To: <20220329151947.moon56737kryfrh3@cyberdelia>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 30 Mar 2022 18:40:03 +0530
Message-ID: <CANT5p=rpgzgjHM+kOKpt5u6WWcMYPbrhu0cvc7+0+Cr1GKRpJA@mail.gmail.com>
Subject: Re: Regarding EKEYEXPIRED error during dns_query
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        Bharath SM <bharathsm.hsk@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Enzo,

Thanks for the reply.

On Tue, Mar 29, 2022 at 8:49 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> On 03/29, Shyam Prasad N wrote:
> >David: Do you know if making frequent calls to dns_query can possibly
> >prevent expired keys from being cleaned up?
>
> The problem is that the key is being created with a permanent TTL:
>
> 2135708b I------     1 perm 1f030000     0     0 keyring   .dns_resolver: 2
>
I'm seeing this issue while trying to validate the fix to this problem.
In cases where dns_query gets called repeatedly, I'm seeing that
dns_query returns -EKEYEXPIRED. I don't see the userspace utility even
getting the upcall.
I see that keyring gc is scheduled with a default interval of 5 min.
But I don't see the situation recovering even after that.

> But answering your question, if a request to the same key is done before
> it expires, yes, it will extend its TTL. But, again, in the current
> case, cifs is only doing unnecessary upcalls every 5s, while also
> possibly getting outdated cached records.
Again, I'm trying with Paulo's fix that sets a minimum upcall interval to 2 min.

>
> I sent my patch to fix this as RFC to David, but he probably missed. I'll
> re-submit it to a public ML with him on CC.
I'll let Dave comment on this.

>
>
> Cheers,
>
> Enzo



-- 
Regards,
Shyam
