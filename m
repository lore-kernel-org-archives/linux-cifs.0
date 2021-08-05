Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EAEC4338F
	for <linux-cifs@archiver.kernel.org>; Thu,  5 Aug 2021 05:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9F3E60725
	for <linux-cifs@archiver.kernel.org>; Thu,  5 Aug 2021 05:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhHEF5B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 5 Aug 2021 01:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhHEF5B (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 5 Aug 2021 01:57:01 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA27C061765
        for <linux-cifs@vger.kernel.org>; Wed,  4 Aug 2021 22:56:46 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id hs10so7693134ejc.0
        for <linux-cifs@vger.kernel.org>; Wed, 04 Aug 2021 22:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fZ1wVk2fYZBnHb5t6wxoJvHbb86dzGUC2ModDU0ak+c=;
        b=W5upoBAq78/atXpJYf4Gs1TH/O9iFHWo8x9IeEENEweOrGuGrudPPEIoDw0mEuiYNd
         3f0+iQHATT5c6O6MybFo7rkOP1AkL1WRI4xBs+bCiTMx/Q8dVXmz0UEQPsbCfHC+ybuX
         UGkDj382fHCayGPLwOModQ/ptBL/innG4rmuBPyF6nGCqqdAwk3f+LESZ1PJVfAarr5M
         5CUxLQecW0vv0Rv8Km0WGUNomrjCHLXvZsDDhzZXMvr6jnzYSD3xmheokCByAUy6f4Vh
         z8zc3Wdk2mgxyEYq+DTdYuVRbY2DRPANSn+HQDFVsvumVTxRN+t9WkqHuyFq94bLFswy
         043Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fZ1wVk2fYZBnHb5t6wxoJvHbb86dzGUC2ModDU0ak+c=;
        b=rFDRA5htcuYdCz1kt0BQ+I419KW5jAjbSuZjtQz5hhzY4Y2TqCMJp2xXJV3Xb/7Ltn
         hljG1H1ZEO67PIel8mnVECtaz5cGkuq2SWuNmRETL+HhB0XtPXk/OPgywNDUSCJWCrsm
         9BcoEvoNVC/xkosIsC7sAAqOekwv6jd2cN15y7TjuOOEvIwCNXL4tba6vBvXOYPIzuTu
         6TnH7jw6U16q+6oHbau44RnGz0ZZICE06OToV/8Xl01EdzDY+8yAjckzxEsyjoFwR0zE
         zC7YQQAeDzQXndrfkUu6LCPKCUZSqP5hfcaF0xOhhXNzYpMjU2IjO+xA6gY+5Nz7Xqcf
         7J6Q==
X-Gm-Message-State: AOAM532xVCGZUwrQrZxT6KQGgRmhRuQO2yycOASG6gbYjxuMRZyBvmKD
        PIqL+dOSVs3kGY6SRBz9lMwZ2LlMgJcDx/RxsCE=
X-Google-Smtp-Source: ABdhPJzHZY9LSvbSqY1R+CIvfAE07LrowUhuRZ+aJPJa55E0sHpC1NtsblFSGozqspHpEWISQ1N2l9tAuSno7rYQFWQ=
X-Received: by 2002:a17:906:c251:: with SMTP id bl17mr3077590ejb.219.1628143005273;
 Wed, 04 Aug 2021 22:56:45 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=ouksRAiRLLexVhPZU1=iWwhiRUxw8dBRj-a_f2vjnEDw@mail.gmail.com>
In-Reply-To: <CANT5p=ouksRAiRLLexVhPZU1=iWwhiRUxw8dBRj-a_f2vjnEDw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 5 Aug 2021 15:56:33 +1000
Message-ID: <CAN05THRRNQ3gucogR=cP-5dV2BqVFR6CBnxxt=XhsLhArykT0A@mail.gmail.com>
Subject: Re: [PATCH] cifs: create sd context must be a multiple of 8
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Acked by me.

The entire handling of how we do contexts length and padding is broken I think.
We really should have a model where we add the contexts one at a time,
with the actual length of the context
(without any padding)
and then once we have the list of all contexts we iterate over this
list and adjust the lengths and adding padding where needed,

Currently we add padding very ad-hoc only in the contexts we know
where it might be needed, and this leads to bugs like this, where we
forget.
I think the context handling in negotiate protocol is even worse.


On Thu, Aug 5, 2021 at 3:17 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi Steve,
>
> Please review the fix for the bug reported at:
> https://bugzilla.kernel.org/show_bug.cgi?id=213927
>
> The issue was misalignment of create context caused by one of our
> earlier commit:
> commit ea64370bcae126a88cd26a16f1abcc23ab2b9a55 (tag: 5.10-rc6-smb3-fixes-part2)
> Author: Ronnie Sahlberg <lsahlber@redhat.com>
> Date:   Mon Nov 30 11:29:20 2020 +1000
>
>     cifs: refactor create_sd_buf() and and avoid corrupting the buffer
>
>     When mounting with "idsfromsid" mount option, Azure
>     corrupted the owner SIDs due to excessive padding
>     caused by placing the owner fields at the end of the
>     security descriptor on create.  Placing owners at the
>     front of the security descriptor (rather than the end)
>     is also safer, as the number of ACEs (that follow it)
>     are variable.
>
>     Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
>     Suggested-by: Rohith Surabattula <rohiths@microsoft.com>
>     CC: Stable <stable@vger.kernel.org> # v5.8
>     Signed-off-by: Steve French <stfrench@microsoft.com>
>
> The fix can be found at:
> https://github.com/sprasad-microsoft/smb3-kernel-client/pull/4
>
> I think this should be marked for stable as well, with a "fixes" tag.
>
> --
> Regards,
> Shyam
