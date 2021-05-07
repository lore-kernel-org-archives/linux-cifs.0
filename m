Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 496FBC433B4
	for <linux-cifs@archiver.kernel.org>; Fri,  7 May 2021 03:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 165986101D
	for <linux-cifs@archiver.kernel.org>; Fri,  7 May 2021 03:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhEGDT0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 May 2021 23:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbhEGDT0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 May 2021 23:19:26 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC97CC061574
        for <linux-cifs@vger.kernel.org>; Thu,  6 May 2021 20:18:26 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id u25so9731938ljg.7
        for <linux-cifs@vger.kernel.org>; Thu, 06 May 2021 20:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HBFqpGmN1W6Fp7mBmdC2+sAFz0IgPW30ceYSM4x3edw=;
        b=njSY7s5NHX8EU6p5FOeiI6mtitoISrjBjZLqzqu34hX6PdoeBshIM+1qQ7xQtnc5np
         da/vZqZk+Yyt7m/peYU8v3ZdqcxeqeA7dLoppKPcUEPT7IT9yCUSq5KZ/dei3oMEBpVc
         D96R/gYgEwXIo6aG93xP5B9QhcBcYn76HjP/DGb5vvjqWm7F7cVZ28MBD+CSRbVkHWfe
         CdFfcJMv3VJ8UKWZSCqjE5vq7v4KuH9OAS7vE/Qk4q0SGY04EylSYyVJQeks2C+yrQS2
         QahzVZnYgYvxUeJRqgWZ2PfqrMAapuwZVzWDJsSC9gedEE5oDK3Mb2sTo1AtbvCbEm2o
         JwPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HBFqpGmN1W6Fp7mBmdC2+sAFz0IgPW30ceYSM4x3edw=;
        b=PJQ3hJTS1NQunZou72GBgJ9Z/vbEZbhwe3CjsMOp3c2zBrhCpy+W1xME/RWG7Vyis7
         W14NPaTYYXh5n7G9Xp+hn1oM/qnWw0V92IM4M/ezVMuHB2LXNH4Iwc8G627U5AJbZmEu
         4jmHPiia7nSyAjXPrm1OXuA+FTlVDyRO6/+j3ZcajH1UPuoGesA74ZaCnXdl63ey+MJE
         R+uzkOS7E//VklzSfUSjGtYeFOqqAxb+xhfcHgLnv9hA2Eq2qJCW4Q0RRoxlHkyIIQb2
         AwiC2IL1SuT/6brcj1o0lpqiehsnHmfz+UhknISoPU4251QS2KbkFnTqSw0LTPwVgTpZ
         9eEQ==
X-Gm-Message-State: AOAM5301Wy521fqMC5VHoIzS1jHikMrDN1BlFPdg+mJvh09h0cCJ48Fc
        VdJsNC3GxcuHaZxTtjGpmhnA+4dE04avsyZm/3XXlGMu7/s=
X-Google-Smtp-Source: ABdhPJwixbAdTagtoBim3U1oMZHnZLodOTtM6lK3KmFF13x3WmPYM7/HCaBkQVhf9gOXVbswbNBkstMtCiAwRYYx6jo=
X-Received: by 2002:a2e:7f03:: with SMTP id a3mr5899001ljd.406.1620357504718;
 Thu, 06 May 2021 20:18:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muN3rpUur8jSav=fJfnt_vuJhgOXxMeGmXvT3KvxbBU5w@mail.gmail.com>
 <c2b84e56-87c6-469d-c272-02731cb0937c@samba.org>
In-Reply-To: <c2b84e56-87c6-469d-c272-02731cb0937c@samba.org>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 6 May 2021 22:18:13 -0500
Message-ID: <CAH2r5msBg3g4w0L6ngAqf9XKe3jFFFjDdE5hKH2_MgyUgNZnNA@mail.gmail.com>
Subject: Re: [PATCH] smb3.1.1: allow dumping GCM256 keys to improve debugging
 of encrypted shares
To:     Stefan Metzmacher <metze@samba.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, May 6, 2021 at 7:17 PM Stefan Metzmacher <metze@samba.org> wrote:
>
> Hi Steve,
>
> > +/*
> > + * Dump full key (32 byte encrypt/decrypt keys instead of 16 bytes)
> > + * is needed if GCM256 (stronger encryption) negotiated
> > + */
> > +struct smb3_full_key_debug_info {
> > + __u64 Suid;
> > + __u16 cipher_type;
> > + __u8 auth_key[16]; /* SMB2_NTLMV2_SESSKEY_SIZE */
>
> Why this? With kerberos the authentication key can be 32 bytes too.
>
> Why are you exporting it at all?

I don't remember the original reason for why it was thought wireshark
could use this.

Aurelien,
Do you remember the context/reasons for each of the exported fields?

-- 
Thanks,

Steve
