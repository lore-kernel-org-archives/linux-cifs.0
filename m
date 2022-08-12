Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED00C25B06
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Aug 2022 01:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbiHLBKm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 21:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236151AbiHLBKh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 21:10:37 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE642F676
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 18:10:33 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id k26so36402870ejx.5
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 18:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=77WXt3Zvr/paPAJdiJjWO9LwlhG/c6qM6aDOo4DSj68=;
        b=oyVhAP/P2+FDlAHrxG2Tbt+xXtRu+5XybtRXRb3PT8XYoeX9Ibwx7EH/6YIUlxHXuP
         yasB0BIYgxz1gO9VUT+7ljEwDFY7ScVsGVl9+cTgStPN0D3slocDgtj7wEeCXsRL/k1x
         c4SVR2RBNQcxk2oTRK0wAc2T10NE+s17J5SUbryNeLLFDa6rzrn7scc3JCXXPgKdawT6
         aASGn2PitN4ZhgLWoEXG6xFCBKKGvPNlwvpxqLfRW8O1scxiAIgJSsHx7mcIHQ94D4Kx
         A3vOUlT+y6GPCnEEV56xHv63FEV8wQf9cqw7LtIzMYy9t/h7GT+bIh9Z4ZeOoo3/dzZc
         8LQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=77WXt3Zvr/paPAJdiJjWO9LwlhG/c6qM6aDOo4DSj68=;
        b=VgJ/6M7udifGrLdFI4RvtOF02bMV7NDzGrx7l/tQ6ACfK93/y31b0JJq7q6D5yQ6Xs
         7OTtwht2v313o9R4bl7JmaMOJwfJ8s1aLtUueDdIymAba1+wUz7kHSEUQ4Y7NqHtrF9u
         VrPVB02mGAi38inVtPBHu3PAUK6OUF3x8QL4OOquyQPVqVAO8P0BZIwGC8ctWWDgRn20
         biUJwwwg62IqFUjNOP0UTF1guS1qhYNYsdii4j8Ml6e9RE5FTapxv/ckoICMJsUjoL6q
         eugNKufztIiivXvOlr9WEmZ+j6Ol695cmeLoliw/A3egSFq++AwRUxNBe/GjHafbbQHD
         jkRA==
X-Gm-Message-State: ACgBeo2YKbMpQ7GjMBjmnep7ScPIqeXUxYrYLsI8K9uwOkY6/gZbUg5c
        c1F3//Royu+Wvot9EUkzDrDSOKyuFIqlirOHtYKe4ltM
X-Google-Smtp-Source: AA6agR64gqmd2vRsNj+t3CR0g0JHa+DOcQ2IAdZkmu7yUhrot7JGbR0E/VAnLd7s8l5bubEZDZtRf5KedAjNFdT/b70=
X-Received: by 2002:a17:907:7b95:b0:731:113a:d7a2 with SMTP id
 ne21-20020a1709077b9500b00731113ad7a2mr1010203ejc.377.1660266632419; Thu, 11
 Aug 2022 18:10:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msJ6=LfoyGWyi94o+Z1FcJFdxpcLyPRz9K9gK5SpvPCUQ@mail.gmail.com>
 <87zggasr6o.fsf@cjr.nz> <CAH2r5mviEtcCQa1Pbyf6OeQKQ8dzJrK+BQE61qaGk6rQUaGH4A@mail.gmail.com>
 <87wnbesql0.fsf@cjr.nz> <CAH2r5muf+h+tdR6k3wgyhY52hz9BUSBCs1hzC1V434ddt0ovxw@mail.gmail.com>
In-Reply-To: <CAH2r5muf+h+tdR6k3wgyhY52hz9BUSBCs1hzC1V434ddt0ovxw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 12 Aug 2022 11:10:20 +1000
Message-ID: <CAN05THSv+7C2J9yv2Ph0_KApS5wucE-GwPLzihQ+zU_68ceq2g@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] allow deferred close timeout to be configurable
To:     Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, Bharath S M <bharathsm@microsoft.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, 12 Aug 2022 at 03:17, Steve French <smfrench@gmail.com> wrote:
>
> The "jiffies vs. seconds" in comment was the only suggestion I didn't include.
> See updated patch v2 (attached), I made minor updates.  Added the
> Suggested-by from Bharath. Moved the defines for default/max to
> different name with SMB3 (and in fs_context.h) since it is an smb3
> feature (so not confused with cifs).  I increased the default to 5
> seconds (although that is still lower than some other clients - it
> should help perf.  As you suggested, unconditionally print the value
> used on the mount.
> for some workloads).

nack.
The problem with this is that it is a mount option that is impossible
for a sys admin to set correctly.

If we need this as a mount option we need documentation on it too.

1, How does a sys admin determine that there is an issue and that
changing this value will  fix it?
2, How does a sys admin determine what to set it to?

To me it seems this is an option that can only be used by developers
and thus it should not be
a mount option. We have too many ad-hoc mount options that end users
can not use correctly as it is.


>
> On Thu, Aug 11, 2022 at 11:16 AM Paulo Alcantara <pc@cjr.nz> wrote:
> >
> > Steve French <smfrench@gmail.com> writes:
> >
> > > Will fix the typos thanks.
> >
> > Thanks.
> >
> > > There are a couple of minor differences from Bharath's earlier patch e.g.
> > >
> > > "closetimeo" rather than "dclosetimeo" (I am ok if you prefer the longer name),
> > > and also this mount option is printed in list of mount options if set.
> >
> > Both look good to me.  I personally don't care much about naming,
> > though.
>
>
>
> --
> Thanks,
>
> Steve
