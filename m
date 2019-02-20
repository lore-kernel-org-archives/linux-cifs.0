Return-Path: <SRS0=PjUO=Q3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC7CC43381
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Feb 2019 14:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51ADA20880
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Feb 2019 14:18:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=brauner.io header.i=@brauner.io header.b="SU7z7Wou"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfBTOSl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Feb 2019 09:18:41 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38113 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfBTOSl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Feb 2019 09:18:41 -0500
Received: by mail-wm1-f68.google.com with SMTP id v26so6627991wmh.3
        for <linux-cifs@vger.kernel.org>; Wed, 20 Feb 2019 06:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HYh/wMOJEjzj4yvU8ZgajL6TKXoZLNw8EN4YdASIjrg=;
        b=SU7z7Wou59v7qIuzNJjzzoKCPqdcMhzChZ+vYTQ2rxEq71vNRBFSWjPh4erTzQ34u9
         3Yn8JydmugfvNT7RfPpybaUhO8i2FCif/B4E/4NSmlO/sOzRTbXXJ8yeScFjG0kY4HDi
         Fhy54cbyEsKIXLO4irgRdGfDDvRXxtXzPHgM3aSYVAXeIJDoxo46NojbhZ1t6pZIVF6y
         Cd7R+E5CJQmWJFasLWe98siHZNyTKeRTIyAD0syGve3jOuWA49UVErOTklRVwebLu1ge
         FxxkPdWGpRHK+C2coxSEzRf9pz3Kp+EjFCSYb39krWlClbsX/9qF83vYY9jc+GKAVSbA
         1vow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HYh/wMOJEjzj4yvU8ZgajL6TKXoZLNw8EN4YdASIjrg=;
        b=EHS5eCxO3moHLeDJwfOgEsahAfVgwFFBGEwOHni5XKGYuOTj+a+OlIt3fIbs0bimur
         TdglHhi/voEM8V5hx58trbPTWo2+WDhq8tTdXMEVsP3nLEKT3XFMNGIkozsZg+XWaiAM
         R3nZ/ILj0L3z3rgJrc/NrIZHkEyrKKInH5FRrFEjla0qvjp0UMbHsoasQHzGSf8s8Z36
         GZ2NlYmrOEDJUEhaey6E2QoxuhhjG9LZ96RdeBWDktTImnEmvPnldml971IODnstpU1X
         uAP+FySdExIX8b/l2H6leDK0lwEr9U1Qq1axTORR6F1wWcl3sZBQePHbDRAZViuq2yaG
         /l9A==
X-Gm-Message-State: AHQUAub0cGdfPvRXN1vMckwpOgqkXFdawbKinIP+r4u8icPuiFinqdqF
        mSLH4kFxIXn5HVQoRcBwxwZJuQ==
X-Google-Smtp-Source: AHgI3IYWPXJvfR8Xt5hMzmUpaly+r19Src4me6mRrvf2QgQ9GUgAjPxNtAOMkMnKd8NwD97NB6iT9g==
X-Received: by 2002:a1c:3842:: with SMTP id f63mr6849753wma.25.1550672319714;
        Wed, 20 Feb 2019 06:18:39 -0800 (PST)
Received: from brauner.io ([81.92.17.155])
        by smtp.gmail.com with ESMTPSA id p16sm33606895wro.25.2019.02.20.06.18.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 20 Feb 2019 06:18:39 -0800 (PST)
Date:   Wed, 20 Feb 2019 15:18:37 +0100
From:   Christian Brauner <christian@brauner.io>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-api@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, sfrench@samba.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, trond.myklebust@hammerspace.com
Subject: Re: [RFC PATCH 00/27] Containers and using authenticated filesystems
Message-ID: <20190220141715.ukjo5d4ctepahl43@brauner.io>
References: <155024683432.21651.14153938339749694146.stgit@warthog.procyon.org.uk>
 <8736ojybw7.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8736ojybw7.fsf@xmission.com>
User-Agent: NeoMutt/20180716
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Feb 19, 2019 at 10:35:20AM -0600, Eric W. Biederman wrote:
> 
> So you missed the main mailing lists for discussion of this kind of
> thing, and the maintainer.  So I have reservations about the quality of
> your due diligence already.
> 
> Looking at your description you are introducing a container id.
> You don't descibe which namespace your contianer id lives in.
> Without the container id living in a container this breaks
> nested containers and process migration aka CRIU.
> 
> So based on the your description.
> 
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> 
> 
> David Howells <dhowells@redhat.com> writes:
> 
> > Here's a collection of patches that containerises the kernel keys and makes
> > it possible to separate keys by namespace.  This can be extended to any
> > filesystem that uses request_key() to obtain the pertinent authentication
> > token on entry to VFS or socket methods.

/me puts on kernel hat:
I'm not neccessarily opposed to making containers kernel objects even
though I have been for quite a while (for brevity I'll use "kcontainers"
for this). But I think the approach taken here is a little misguided.
This patchsets pushes the argument that kcontainers are needed because
of keyrings and authenticated filesystems and is designed around this
use-case. Imho, that is bound to fall short of requirements and
use-cases that have been piling up over the years.
If we want to make kcontainers a thing we need to have a separate
discussion and a separate patchset that is *solely* concerned with
creating a kcontainer api. And frankly, that is likely going to take a
long time.
At this point containers have become a real "thing" on Linux - like it
or not. So justifying it to making them in-kernel citizens doesn't need
the detour over keyrings or something else. We should just discuss
whether we think that the benefits of kcontainers (e.g. security)
outweight the costs (e.g. maintenance).

/me puts on runtime maintainer hat:
One thing that is true is that userspace containers (let's call them
"ucontainers") as implemented by runtimes today will not go away. We
have been living with this ad-hoc concept and it's various
implementations on upstream Linux at least since 2008. And kernels
without kcontainers will be with us until the end of (Linux)time
probably. So anyone who thinks that kcontainers will replace ucontainers
and that'll be it will be thoroughly disappointed in the end.
It is also very likely that not all use-cases we can currently cover
with ucontainers can be covered by kcontainers. Now that might be ok but
if we ever introduce kcontainers through a proper kernel api we will end
up maintaining ucontainers and kcontainers simultaneously. That's a
burden we shouldn't underestimate.
