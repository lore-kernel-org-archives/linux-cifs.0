Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5551DFA3744
	for <linux-cifs@archiver.kernel.org>; Thu, 27 Oct 2022 13:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbiJ0NHd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 27 Oct 2022 09:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236008AbiJ0NH1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 27 Oct 2022 09:07:27 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5222A17A016
        for <linux-cifs@vger.kernel.org>; Thu, 27 Oct 2022 06:07:25 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id g24so1404110plq.3
        for <linux-cifs@vger.kernel.org>; Thu, 27 Oct 2022 06:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bA5UIXoeSiPSdpk42SIcKNh5Hs0RGjWIBYmqNZvV8z0=;
        b=WMK5ErddZ+UAaVGwb6JZd/hV/xL45PeKozs9Y8Ts6Dl5wl6x54N23+uGqZ1KF/inKX
         lOIqkJkEFXdPaCgyh2+I9CKKgAPy3C6QQKf0OrAYKwXF1akmSsXU/T7s+DaDMjIXac0f
         P1VQieyooXdBGZPT78rPl5bE5TaCNoldXNwXU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bA5UIXoeSiPSdpk42SIcKNh5Hs0RGjWIBYmqNZvV8z0=;
        b=XY04EHbYgQmAf/jUw82e6cDuErlT0i5Im6mnzz/SMGOJTjxLBye3uDsyEDaH6+Aqdl
         pamKAAaGUNIVVsGMFa2EayQv1aAs5sv7oFcL4N90trB09Tyss06GTZf3/JfmcLC21v6j
         Fuh7cob9yNKM3kHpzUJ1ctncfGvWh4YPsGDm7BhsyfaY2Hk1wr3wKx3rvK4dAbXTkld6
         I/qhySY3oUO/J7mG/U/glXvdODjsoP34+99Fkjdyy1cBUY6rDEc093wFJp9K8LOI00Yh
         mwk0hbSd4NFkO7MY9V5WOY8Ilyzeeu7Mm29DYSaVq2vvj2EyT8qhU1xe8cM/b2mlcjYp
         spRw==
X-Gm-Message-State: ACrzQf2Oy+0crAG7OazEXB2aSV4mopy8Ds1A4TegfpOwMaxCl+ZSS1dc
        c6UNuAcQu6MjOWR8cLS+tyPb8w==
X-Google-Smtp-Source: AMsMyM6XvKHWZb4CUg/of1JGw7Fw/JFlLofrdFN0ZHBinRybiUgEUdo0acHehvuEcDop9LoIA26AjA==
X-Received: by 2002:a17:903:2306:b0:185:43a2:3d1c with SMTP id d6-20020a170903230600b0018543a23d1cmr19357662plh.154.1666876044670;
        Thu, 27 Oct 2022 06:07:24 -0700 (PDT)
Received: from google.com ([240f:75:7537:3187:a253:6b21:b32f:c252])
        by smtp.gmail.com with ESMTPSA id x14-20020aa7956e000000b0056265011136sm1138963pfq.112.2022.10.27.06.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 06:07:24 -0700 (PDT)
Date:   Thu, 27 Oct 2022 22:07:15 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Russ Weight <russell.h.weight@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] cred: Do not default to init_cred in
 prepare_kernel_cred()
Message-ID: <Y1qCg+g9je72TneY@google.com>
References: <20221026232943.never.775-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026232943.never.775-kees@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (22/10/26 16:31), Kees Cook wrote:
> A common exploit pattern for ROP attacks is to abuse prepare_kernel_cred()
> in order to construct escalated privileges[1]. Instead of providing a
> short-hand argument (NULL) to the "daemon" argument to indicate using
> init_cred as the base cred, require that "daemon" is always set to
> an actual task. Replace all existing callers that were passing NULL
> with &init_task.
> 
> Future attacks will need to have sufficiently powerful read/write
> primitives to have found an appropriately privileged task and written it
> to the ROP stack as an argument to succeed, which is similarly difficult
> to the prior effort needed to escalate privileges before struct cred
> existed: locate the current cred and overwrite the uid member.
> 
> This has the added benefit of meaning that prepare_kernel_cred() can no
> longer exceed the privileges of the init task, which may have changed from
> the original init_cred (e.g. dropping capabilities from the bounding set).

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
