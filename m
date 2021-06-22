Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FC2C2B9F4
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 23:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1610160C41
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 23:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhFVXQi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 19:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFVXQi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Jun 2021 19:16:38 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B203DC061574;
        Tue, 22 Jun 2021 16:14:20 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id i13so943030lfc.7;
        Tue, 22 Jun 2021 16:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=gmTKbbw2VfNilxgf1MZbHcRGG9kAzGHmXVIKe38TtIg=;
        b=dKy9U8PrSUScVJMENfpNd/50GsD7Jy+ap/wI/QIrOrFzxhsOHTrEZ024MS3zM7gNcI
         Ym3nW6eAfoYkoEeen9ElGsv/SD5qVg6J1IXcFVT1bP3NTF8pP7X6Avz9Ir4BMFRsV3VD
         mf8Lt+2TYKJ8iuTXSuUhQkwdoFTrROqtiQVouSx2C/HgPyZM/t4UuXBzZWQ+La9UGDOZ
         7d9zfJmjzdFlammOsdBFE77gMO3GF1tsb1e2qqfXMEM3pZlJAXDk/xd3wnWEuepF318I
         4Y2rb1/FRSmRvEyQPXHKmalSE7Hv4hJUVP4ks5Fh290eE+BPO0aBVd4tEF/RLr8SRN0p
         OLQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=gmTKbbw2VfNilxgf1MZbHcRGG9kAzGHmXVIKe38TtIg=;
        b=b/v5TkmKxSZuOJgRDajcHPi7PT6Qgh1HO6LrZcKg8YB1VX/nG39tsMvnfb9iygNIJg
         7QrmAMhcx+d+bBSvpURaCBMNiCF7k5dczRBxxasdJHu/qjGC9H4dZ4bMNU/8GNU5nOJY
         fezmzQoMSisym2cwX/DjgHOeGaJwSTmtsCTQstLXmfUaSsyKozIxtAnwf4gYYcMCLDVe
         eOhRvj1fAEX7jfNqtFbOOvplCVIMVL3Y14ktn02AfQIqGjVpcUqNc3j5L3rqZHskFuoQ
         0J64r+OhUP/5w4GH2WDu6Jl15/R3uvn+mhIyDHpmxzvbL9k/HTxcDfYKqdQL2PMKp738
         KAiA==
X-Gm-Message-State: AOAM533VLpBBfttBjxxjMCmfip0xIW+qJv3SR+r5JrljAfdQHADXYQxl
        s3lT30F82A6nQ+o5KRmpsgHnUU03WPwvPH8wFh19Z570yVM=
X-Google-Smtp-Source: ABdhPJwdNjn7A1NoAKSn4/inPzJewwzU2FlqhjsV6dzRUm603MKGQcMLYg8fWNJOxPOOfGbnCCKPn7wItxtijoOyG3w=
X-Received: by 2002:a19:c190:: with SMTP id r138mr4688267lff.175.1624403658698;
 Tue, 22 Jun 2021 16:14:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvCOafQpko19fmSTtEdgG7mp2R1+xto=_fkm7A=fqWq5Q@mail.gmail.com>
In-Reply-To: <CAH2r5mvCOafQpko19fmSTtEdgG7mp2R1+xto=_fkm7A=fqWq5Q@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 22 Jun 2021 18:14:07 -0500
Message-ID: <CAH2r5muNZdzYOWZrRvo_OKVsmsPnNZckriKDqQTAQ06Wm5PObA@mail.gmail.com>
Subject: Re: coverity problems with certain macros
To:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Also interesting that it appears to show up only in the "linux"
coverity report not the "linux-next" coverity report which have
similar code there.

On Tue, Jun 22, 2021 at 6:11 PM Steve French <smfrench@gmail.com> wrote:
>
> Looks like coverity's scan of the Linux kernel has problems with
> analyzing locks across some debug print macros (which ironically don't
> use any locks related to this component)
>
> e.g. Coverity Linux issues: 1484748, 1484736, 1475751, 1475743 and 1475726
>
> as an example it flags the section of code below, and others with
> calls to "cifs_dbf(VFS, ...) " in them (and note that the debug macros
> don't take a lock) starting with the cifs_dbg(VFS, ...) call.  It
> says:
>
> "May result in deadlock if there is another attempt to acquire the lock.
> In find_cifs_entry: Missing a release of a lock on a path"
>
> Oddly it doesn't flag "cifs_dbg(FYI, ...") calls, and even more
> strangely the calls they flag are simply wrappers around calls to
> "pr_err__ ## ratefunc ..."
>
> See below snippet from fs/cifs/readdir.c e.g.
>
>                         cifs_dbg(VFS, "reached end of buf searching
> for pos in buf %d index to find %lld rc %d\n",
>                                  pos_in_buf, index_to_find, rc);
>                 }
>                 rc = 0;
>                 *current_entry = cur_ent;
>         } else {
>                 cifs_dbg(FYI, "index not in buffer - could not
> findnext into it\n");
>                 return 0;
>         }
>
>         if (pos_in_buf >= cfile->srch_inf.entries_in_buffer) {
>                 cifs_dbg(FYI, "can not return entries pos_in_buf
> beyond last\n");
>                 *num_to_ret = 0;
>         } else
>                 *num_to_ret = cfile->srch_inf.entries_in_buffer - pos_in_buf;
>
>         return rc;
> }
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
