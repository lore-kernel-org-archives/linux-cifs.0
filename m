Return-Path: <SRS0=nxME=TI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68EDBC04A6B
	for <linux-cifs@archiver.kernel.org>; Wed,  8 May 2019 20:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FCA420578
	for <linux-cifs@archiver.kernel.org>; Wed,  8 May 2019 20:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557347848;
	bh=S0dbb590IBkbgNs7FT++/9eUgoS9Sg0EXTvi3gjJWiQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=r39wDOQF3a4TCWH8QSaokIehQtGmXLnziEN9vcCEY8IVEMDzjqtDLb0W+mHWMgB9g
	 w4SIWZUBIIzn7jx5jTk159B16UnkkCBpYCIyuX6AxdpuJAI0M4xZj/a6M7waVTNsUv
	 RUA08XHeuYgr7AZ3TaUP7EHttzKp7kN9jmcBVPgs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfEHUh1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 May 2019 16:37:27 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39541 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbfEHUh1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 8 May 2019 16:37:27 -0400
Received: by mail-lj1-f193.google.com with SMTP id q10so78517ljc.6
        for <linux-cifs@vger.kernel.org>; Wed, 08 May 2019 13:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IrFkw6283Zi8oefwq8lUxwFDaNKBwwzjBLXpJ0o3wyI=;
        b=HucpZu3G2A3y2jBqde10VM/HUWq1bWiHbhqIU/Jwo8GB+shkJSCZmQJ/qISI3zZ3rY
         ogduhkM5PErzigqiuw3A7DJyN2f4v//R0pDs1NgWKdNuhwiA/XYtrETqxmjvUGuuxfDR
         sMVc+PvkxAkgFWgYSSD70zSV8Y8Vk76osMdMs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IrFkw6283Zi8oefwq8lUxwFDaNKBwwzjBLXpJ0o3wyI=;
        b=MKpAVBoFGJncI/dDMcQjNDCgMap7qUgvxJrHi++0j/KjIkBERWOLB4GVyj4OpX4z9l
         /qtLnR3Sdp2o0skwkyJBVnysrKN/OWcfe4VhVrAWSv4nLM2q53AAYQqJbAYDC7agUfZY
         V5uZugzmzIQ4ee/YjQWZ1R8Ma4O2LahQ0ySEsC3mpTZBnd29ZsKXR5DswA+7li5uKJNe
         K37a+HWI9PHYwKrz1K7Tzv0Lt0lQi6NPjN6FeqKD3GTRPDVJUsI9KgWWTusLner92S0U
         wZG6CnS1gETylrHQnx+zTl9PaciVZ4RUqF0YJlW7cYoys7Rr0rku6HBmoC0XrhhMGHT8
         x+Eg==
X-Gm-Message-State: APjAAAVdQBR3Ce6zVOXZpLakhwgxK4ty3Ro30gvQMsw2ydElGfDPTDDI
        2I6MUdWLRpdl2bXSZbacXONkOpb1QWw=
X-Google-Smtp-Source: APXvYqwxB7QMMys2B+fe4vdxaw715TmqRwbxn291fZ/psmzA+JpnllKyyAOoBiSNBbZaC3ymoO2ZAg==
X-Received: by 2002:a2e:298d:: with SMTP id p13mr8142587ljp.64.1557347845039;
        Wed, 08 May 2019 13:37:25 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id u3sm2664207lfc.73.2019.05.08.13.37.24
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 13:37:24 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id v18so13313158lfi.1
        for <linux-cifs@vger.kernel.org>; Wed, 08 May 2019 13:37:24 -0700 (PDT)
X-Received: by 2002:a19:ec07:: with SMTP id b7mr86936lfa.62.1557347843674;
 Wed, 08 May 2019 13:37:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv=4JsaF-8v=U4JR3jrOyPfhtUsJPogNudLejDh09xGSA@mail.gmail.com>
In-Reply-To: <CAH2r5mv=4JsaF-8v=U4JR3jrOyPfhtUsJPogNudLejDh09xGSA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 8 May 2019 13:37:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiKoePP_9CM0fn_Vv1bYom7iB5N=ULaLLz7yOST3K+k5g@mail.gmail.com>
Message-ID: <CAHk-=wiKoePP_9CM0fn_Vv1bYom7iB5N=ULaLLz7yOST3K+k5g@mail.gmail.com>
Subject: Re: [GIT PULL] CIFS/SMB3 fixes
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, May 8, 2019 at 11:32 AM Steve French <smfrench@gmail.com> wrote:
>
>    [..] Our
> build verification tests passed (and continue to be extended to
> include more tests).  See e.g. our 'buildbot' results at:
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/199

Still, is there any reason for that very late rebase?

Why are all the commits so recent?

And perhaps even more importantly, why is the base for that rebase is
some completely random and inappropriate commit in the middle of the
merge window?

That's *INSANE*. And it's against everything I've always told people to do:

    DO NOT BASE YOUR DEVELOPMENT WORK ON SOME RANDOM "KERNEL OF THE DAY"
    DURING THE MERGE WINDOW !!

who knows what horrendous bugs we've introduced at that random point
in the merge window, and you now based all your work on that unstable
random commit.

There is *no* excuse for this kind of crazy development. Even if you
use something else than git to develop (some patch-queue based
inferior system or whatever) and even if you then import it into git
later

     PICK A SANE AND STABLE IMPORT POINT

and if you *do* use git for development, but you have to rebase
because you've made some silly mistake and need to undo something

    PICK A SANE AND STABLE REBASE POINT

I don't know how much clearer I can be about this, and I do not
understand why this keeps on happening. We've been using git for just
about 15 years now, and I've said this for pretty much all that time.

Some random googling found this lwn article based on some random old
email of mine from ten years ago:

    https://lwn.net/Articles/328436/

and while it is about general rebasing and merging issues, it does
talk about how to "allow development to be based on a (hopefully)
relatively stable point where the issues are known". That is as
important for a rebase point as it is for a merge point.

Rebasing on top of random kernel versions should not be done. EVER.

And if you did it to avoid some merge conflict, DON'T. I'd much rather
get a pull request for something that is *STABLE* and *WELL-TESTED*,
than get a pull request that has been syntactically cleaned up, but is
based on something that might not work at all under certain
circumstances.

Even if *your* code were to be perfect, that doesn't matter if the
thing you based your code on is a quicksand of memory corruption and
general flakiness.

So don't do the whole "rebase the day before" in the first place, but
*DEFINITELY* don't do it when you then pick a random and bad point to
rebase things on top of!

                   Linus
