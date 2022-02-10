Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18EF8C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Feb 2022 16:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240434AbiBJQqL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Feb 2022 11:46:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244659AbiBJQqK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Feb 2022 11:46:10 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF51490
        for <linux-cifs@vger.kernel.org>; Thu, 10 Feb 2022 08:46:11 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id y129so17178959ybe.7
        for <linux-cifs@vger.kernel.org>; Thu, 10 Feb 2022 08:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MUZ1pmNV/4S6ozCdofeC5uIbpiDx2ms03E7rIM8r7nE=;
        b=e5mpE90LnffpDabsmATILorD6E6116Bn4xXYPVluSOQlWNsFkLPcdKg4YzWl9T8/Id
         u3FRowZjTb8uljR6IYM7deHR1dJUbxeqAnjtYpnCwun4JE9rMbtCgMoc0q9tq2+pe/1Q
         Eh2NNkqxogZp+9eMIHYAE1KKGRAfqqkIt2i8aaJf+xDzfkzvMaZUgsOloYqIU9/p7HH8
         hcYG6MuIr7Gj7seViYkXcq0FAc2IGXSPrVbbxN07TVL09W46n+19LJrxlsVQxq1vPGUc
         Oj+t5a7wl06uixE1ggFUmC88DZIOJug4rGGckms6sVwJxQeTui/CZ/eSvv4MwjtPL4Nw
         vwog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MUZ1pmNV/4S6ozCdofeC5uIbpiDx2ms03E7rIM8r7nE=;
        b=g8F+N926/fFY1Dv5pgkxZ63psk3L8OfOHVQc3NcClgbAEq0UZBJweBvlghWSdgMfZv
         sN8m+JSvf/mudXHLTjRL0ru1G1jIVszMtVWoP/5rFb4nMZuX1f8K2hSn4FTv87EnCFU2
         ZmktiOH+QpClY0BotdZufOx0eD62lVduslzGVZhMOBvrTh2BjZ4GGpDkFXNytqEdHCVM
         7rGk2Lx5j57rAcx2GWBsUd0tYIeV1J55L4w3QFSj7JrqKoB1tiylhw5wD7hXQt2JArbs
         rxXgV4qsow0h/bTeikD3Tci/kLCWtkFx3nXwwM2mpDBBRRXMmjTQj4DNR0jmvddbUE8b
         5Akw==
X-Gm-Message-State: AOAM533grUYL3HSy3NerrsX5ztjzqPo68HZ+qquunXPSyap8KgE17SZ8
        Tg+vMaNHdIv1+VboJg+rHxsxmEv4TGYEoCSBs64hCg3Ihq8=
X-Google-Smtp-Source: ABdhPJzJe9qdNRwbdC8/zRABqqeFWX1bWtEOfWL5ncqc2BeUuBNJgFGtZeCSgkSKVaTADAT0/MCODHZFasZLgFQ+MYs=
X-Received: by 2002:a25:68c2:: with SMTP id d185mr7581895ybc.37.1644511571049;
 Thu, 10 Feb 2022 08:46:11 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=oR0pk=jPKvTUbQNfqga5V_EuUKR+tDNCXQz3Gas1LOKQ@mail.gmail.com>
In-Reply-To: <CANT5p=oR0pk=jPKvTUbQNfqga5V_EuUKR+tDNCXQz3Gas1LOKQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 11 Feb 2022 02:45:59 +1000
Message-ID: <CAN05THQC7dz+QmfK1nmbz7nH=7H+QAmrRCXcPS5q2g-03kS45Q@mail.gmail.com>
Subject: Re: Double free in mount codepath
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Shyam

That is a really good analysis.
After we have called deactivate_locked_super() which will eventually
call delayed_free()
we should not explicitely try to do the same work as delayed_free()
already does.

I think we should simply add a return root; after the call to
deactivate_locked_super(), like this:

out_super:
       deactivate_locked_super(sb);
       return root;
out:
...


regards
ronnie sahlberg

On Fri, Feb 11, 2022 at 12:24 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi David/Steve/Ronnie,
>
> I hit a "double free or use after free" kasan warning today when I was
> running some test.
> Attached the warnings.
>
> It looks to me like one of the issues is this:
> In cifs_smb3_do_mount, we call deactivate_locked_super when we fail to
> get a ref to the root dentry.
> deactivate_locked_super calls cifs_umount which frees the fs_context and sb.
> Then, we later go on to free these again:
> out_super:
>         deactivate_locked_super(sb);
> out:
>         if (cifs_sb) {
>                 kfree(cifs_sb->prepath);
>                 smb3_cleanup_fs_context(cifs_sb->ctx);
>                 kfree(cifs_sb);
>         }
>         return root;
>
> I don't know if the rest of the warnings are related. Please check.
>
> --
> Regards,
> Shyam
