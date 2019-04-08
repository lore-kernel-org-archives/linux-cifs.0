Return-Path: <SRS0=JvIj=SK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB03C10F13
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 22:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E38C213F2
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 22:30:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pwTdRwMk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbfDHWad (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Apr 2019 18:30:33 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38943 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbfDHWad (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Apr 2019 18:30:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id i17so5316472pfo.6;
        Mon, 08 Apr 2019 15:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gy9mFEQpDUkiHzZw+24ioyedli1UnVM5xqbrv5HsyqI=;
        b=pwTdRwMk2BB1FM0ni6b16lvU5CTBqyoJygPLMBgAiTui/QfPZ+ymajjc34StgawM3H
         2/F2buD0ZhueU/y3GcLqVMFkQLUTexntAz/BEMqIDXAms7VC0JwrcGwjN9IzyqLWX41w
         4j2lslhNUAJC/JTFI5+Y77smEP2KMCNu9nk+Atvksm1mROBRFoyUKGIY4rivinS2kFKj
         l95CeOOh/WXt5i/okpC3mrJa5pCp/oE8QJOAWpNsegQPEWbRkq3hEFmXIvYOeyA3CkdF
         6KrhX2IS1CpgePHb2GOUH161a8rjimPTHJpaw+gkha64/AUicDgQwHrpuiCFs/uCCn4N
         pgnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gy9mFEQpDUkiHzZw+24ioyedli1UnVM5xqbrv5HsyqI=;
        b=JPUTZoioLGRS4sEqitIgv4tyhpdvwhbpJhn4ot9aTXthb6ocX57F3Zni8e3BH01iU3
         sWQ/b1oKGXFgoK8p0mI8OqpfoQsHxzSyxxn2ZyrBod6FlcMshIQc1NXp8T10+etLmwQT
         9fDrtd36zFt4ZCJ2dlK2CrFjJJXrRSCINvo5O8aiRT2+JoKGtFbJvHP1xox8dxOPv2nF
         jEKGTLo740BV2h9Z81Zhl8/bmLgGlkuWViWghy82KNv00xxYJ79MuZ3xPY2l6k2TWkWG
         q8ZUh5OYtWuAVbHnf7ilXx6mDp1XwzCvYzKY0ccp/1FiRoUCmC1nxymogyOsj/gbfjpt
         rfkQ==
X-Gm-Message-State: APjAAAUtnf9mBJzSmIwy8a5jzzIryryg5ByvB8XZmE1NhbUn9fVhaKt0
        UbFDQLOOT1GoJG5ZMnqLiRrGootyAvw9Vb7z2bQ=
X-Google-Smtp-Source: APXvYqyUUowo86JoiAuB+BY4j0R2v8oC4mV/aV5eP1ukbS4wXw5ABztcOF+1Eb0ApK0T3ito8WyfnEVx8IY767/OASE=
X-Received: by 2002:a63:d302:: with SMTP id b2mr30451812pgg.13.1554762632391;
 Mon, 08 Apr 2019 15:30:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190409073827.0ac717ab@canb.auug.org.au>
In-Reply-To: <20190409073827.0ac717ab@canb.auug.org.au>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 8 Apr 2019 17:30:20 -0500
Message-ID: <CAH2r5mvSQ6+gq92EMtj+_DYCZW_AOjZocJ9rAKHdtU09Nw-pgw@mail.gmail.com>
Subject: Re: linux-next: Fixes tags need some work in the cifs tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I just fixed these up manually and repushed to cifs-2.6.git for-next

I was curious if checkpatch should have flagged this - I reran
checkpatch on the original version of Zhang's patches and it didn't
complain about the spacing (and probably should have).

On Mon, Apr 8, 2019 at 4:38 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> In commit
>
>   7d672725ba72 ("cifs: Fix lease buffer length error")
>
> Fixes tags
>
>   Fixes: 9764c02fcbad(SMB3: Add support for multidialect negotiate (SMB2.1 and later))
>   Fixes: d5c7076b772a(smb3: add smb3.1.1 to default dialect list)
>
> has these problem(s):
>
>   - missing space between the SHA1 and the subject
>   - missing quotes around the subject
>
> In commit
>
>   54492efdd6a2 ("cifs: Fix use-after-free in SMB2_read")
>
> Fixes tag
>
>   Fixes: eccb4422cf97(smb3: Add ftrace tracepoints for improved SMB3 debugging)
>
> has these problem(s):
>
>   - missing space between the SHA1 and the subject
>   - missing quotes around the subject
>
> In commit
>
>   3cc71735cf9f ("cifs: Fix use-after-free in SMB2_write")
>
> Fixes tag
>
>   Fixes: eccb4422cf97(smb3: Add ftrace tracepoints for improved SMB3 debugging)
>
> has these problem(s):
>
>   - missing space between the SHA1 and the subject
>   - missing quotes around the subject
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
