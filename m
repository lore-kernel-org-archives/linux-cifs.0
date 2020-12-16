Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C790AC4361B
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 04:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FF6E22D49
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 04:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725275AbgLPEWU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725274AbgLPEWU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Dec 2020 23:22:20 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC35C0613D6
        for <linux-cifs@vger.kernel.org>; Tue, 15 Dec 2020 20:21:40 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id e2so16711766pgi.5
        for <linux-cifs@vger.kernel.org>; Tue, 15 Dec 2020 20:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JElVXmG8WpU7bDegf0LLY4ekEq02jebwMb9Kl4DFnVg=;
        b=aNxVZ8g/mzjx10gkJZP64Bbm6+rckXDOtpnf23eRxZwgUx723ojga6uvkEebEaUQF8
         IjAGeWqcBCvrws0f7mC5ko2npP9BWDKQbOL/D0W4tgRnAUHolRY88B59q5dRj4AaagyJ
         Iac461sZrGJwDp3iXlNnksXMMgr9Vkl5YeWMdoN42mADTsk21APbvdwCUdAWoJ3OB2PT
         y6bWiFFZSGzzsyN+0dTQ6jar6n3vW07SyExr4GRi2bYtrCtRUy6wJsKiRet4+6T5UYCu
         fc6Zr/Bn+M4mLmJ6oLeVCbRTx1rkQMb/9qxdcFm/QDQeLbH6lvmpDFxmNe43BQM+55JI
         jfsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JElVXmG8WpU7bDegf0LLY4ekEq02jebwMb9Kl4DFnVg=;
        b=uJq2Vzwyf9uAqMDAY4pyZVVQnVKIRdiT7hwBmI6/3M++PXhVaKpdUwCOCo6FhDNRM+
         nD0daeEfBO16CYkI/YbNfbn1vhtaEEa/cCjaOtJ7OH8Z9tWK+4X64hODtXYOmSSuTwGQ
         NVsyCEN3gIqdstY4ojnKJRodmC2r+1IoJWuGISaiCAilG0zgRnCb/TBPu2KcnwGJzpbn
         tAb9H0vCfxU3E+BGe4W9W3nIyq2bUSVZ8dGZHSZjn+yBT+IrkRRAlVDTr5t2HXwY517Q
         jWEhn9yE6jty5GyNR+8ANxLZuKla+NWR/ZMM98Zw3X0i8JusimM4KH6zbDP3a0Xhx2yY
         fIFA==
X-Gm-Message-State: AOAM531biMfF6g5+9mK/TudYMJemtwaFKgGwUd4Zm+7uNXQSxCQQSbUE
        7TNIwMKf/bcpMw7uhA/ZjavfQ4wcK7bSTA==
X-Google-Smtp-Source: ABdhPJxUumDHHDPbvXK97Db4p1PV5Zz7VwrhbJrFZERkpnVJbji9qt7YhlAvlmFzkWaxS0T1zbMzUw==
X-Received: by 2002:a65:6109:: with SMTP id z9mr31787304pgu.190.1608092499746;
        Tue, 15 Dec 2020 20:21:39 -0800 (PST)
Received: from localhost ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
        by smtp.gmail.com with ESMTPSA id d8sm433252pjv.3.2020.12.15.20.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 20:21:38 -0800 (PST)
Date:   Wed, 16 Dec 2020 13:21:36 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To:     Stefan Metzmacher <metze@samba.org>,
        Namjae Jeon <namjae.jeon@samsung.com>
Cc:     'CIFS' <linux-cifs@vger.kernel.org>,
        'Steve French' <smfrench@gmail.com>,
        'samba-technical' <samba-technical@lists.samba.org>,
        'Hyunchul Lee' <hyc.lee@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: updated ksmbd (cifsd)
Message-ID: <X9mLUOxGI8QM/tgV@jagdpanzerIV.localdomain>
References: <CAH2r5muRCUzvKOv1xWRZL4t-7Pifz-nsL_Sn4qmbX0o127tnGA@mail.gmail.com>
 <CGME20201214182517epcas1p1d710746f4dd56097f16ed08cfda0f6b2@epcas1p1.samsung.com>
 <3bf45223-484a-e86a-279a-619a779ceabd@samba.org>
 <003a01d6d28a$00989dd0$01c9d970$@samsung.com>
 <069556fc-cb6c-1e52-02ab-fa9b71f58cf6@samba.org>
 <X9l9/7rttZkNc389@jagdpanzerIV.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9l9/7rttZkNc389@jagdpanzerIV.localdomain>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (20/12/16 12:24), Sergey Senozhatsky wrote:
> On (20/12/15 15:29), Stefan Metzmacher wrote:
> > >> 6. Why is SMB_SERVER_CHECK_CAP_NET_ADMIN an compile time option and why is it off by default?
> > >>    I think the behavior should be enforced without a switch.
> > > I can make it default yes. Can you explain more why it should be enforced ?
> > 
> > Why should an unprivileged user ever be able to start the server?
> > Wouldn't that be a massive security problem as that user would provide
> > the share definitions and users and controls what ksmbd_override_fsids() will use?
> 
> The idea was that user-space needs to have its own user:group
> (e.g. CIFSD:CIFSD). And smb.conf and password file should not
> be readable by anyone who's not from CIFSD:CIFSD - similar to
> how .ssh/config is 0700 on any reasonably configured system.
> 
> The massive security problem here is that the server runs in
> the kernel. So I don't always see why people want to also run
> user-space (which serves RPC calls, and technically can be
> tricked to do something that it was not intended to do) under
> root - wouldn't this just increases the attack surface?

So SMB_SERVER_CHECK_CAP_NET_ADMIN enforces the "user-space must
be a privileged process" policy. Even CAP_NET_ADMIN is too huge,
not to mention that _probably_ this CAP requirement means that
people will just "sudo cifsd". One way or another a malformed
RPC request can do quite a bit of damage to the system, because
user-space runs with the CAPs it doesn't really need.

It would be better to enforce a different policy, IMHO.
Something like:

	groupadd ... CIFSD_GROUP
	useradd -g CIFSD_GID -p CIFSD_PASSWORD CIFSD_LOGIN
	chmod 0700 smb.conf and password db
	chown CIFSD_LOGIN:CIFSD_GROUP smb.conf and password db

And perhaps we need to add some checks to the user-space cifsd:
make sure that smb.conf and password db are 0700 + some more.

	-ss
