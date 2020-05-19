Return-Path: <SRS0=BTJv=7B=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BC0C433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 07:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93CD42075F
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 07:12:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GTb4sPQV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgESHMZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 May 2020 03:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgESHMZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 May 2020 03:12:25 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10971C061A0C;
        Tue, 19 May 2020 00:12:25 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b6so13591567qkh.11;
        Tue, 19 May 2020 00:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cNg7FN/W8JWKP6MBzG6p7+LD65E1TOSXjw0rNIPuOe8=;
        b=GTb4sPQVySd4XgTcyxRqRDbI+K4LAcU8Z4+YOdwSWnGXtfL3o6Agfws1fVuLzQJwtE
         FWEqPY2JN0drr+TtN8ApXS2UC1xmvApjbNdQzKbWd31QFltaLF6SSbsQ+FZGYsQzYDwG
         pM7QcCdIQ9O4Gw0donfjj8RZd1rkhywPzQ3v4Uh8iWryfTraFfUsIgjZ39pjtGgheSkO
         nalby7lkfUSx/pX9N53MY2ugN4ZH8wRnzelK0jVteaa+B2OqQzMZDks51cAurn1ASgTJ
         d54ot/qXR2WRgcrwKcuohuGoezU214unHFQagtwB8mZYKV57FVc8nNEcqsl37A2Vz+Am
         I/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cNg7FN/W8JWKP6MBzG6p7+LD65E1TOSXjw0rNIPuOe8=;
        b=g0qQpF4K2TjJSyC5KJ71xtUmDDlaTAx5tfcRvzv99d5npApOUQc5ti5sPyMVTM04wK
         2+8bXt4At3us64yXSMaEJaRKIikKeCH9sKFaae6We2DiQ+hu7Dx/l9Qpp3OU2zQfI95R
         oL9IoFzm+1A0fsm/JJ3+1oWE3Lw27WLeYMdOUBOFDLLq5gJ1T+8A7wT36TPxJXS9gA3s
         i0YUJppMr5fkQtt5K9PoKpFkFQ/4bk/C+yJJpfLsTGK+CinlnX70bCjl6WeYRxLjPsI0
         5GcFZz/gyFvkvKzBt8D7IOYZmwloHfD9E71o6x6DKB3SoEfcHljxes5X7cxnhil/BENd
         Qy9A==
X-Gm-Message-State: AOAM531Hp+ohGO6T+teHa6QtXhM4Jdw5624Puu9reA8KMrwuPpxVi1uH
        XMJfdjiD8xtZRERAfJRrNv0IqlCsaeban0DQszI=
X-Google-Smtp-Source: ABdhPJxy0gBLGYz61uFe84q3wd6VCQ+Xtu00K2i0SemHsMVIpEPa9M+NwDkony3NPTMutPA3Q5Dq0i9oZY9HGxXpRvI=
X-Received: by 2002:a25:c644:: with SMTP id k65mr31328453ybf.183.1589872344238;
 Tue, 19 May 2020 00:12:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200519165734.79d0c3a3@canb.auug.org.au>
In-Reply-To: <20200519165734.79d0c3a3@canb.auug.org.au>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 19 May 2020 02:12:13 -0500
Message-ID: <CAH2r5mviK7_=o1Q0FAbqNMTs3=-gCc7Lf9GuJ_ASrxEvXgAUuA@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the tip tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie mentioned that he will take a look ...

On Tue, May 19, 2020 at 1:57 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
>
> fs/cifs/smb2inode.c: In function 'smb2_compound_op':
> fs/cifs/smb2inode.c:424:1: warning: the frame size of 2736 bytes is larger than 2048 bytes [-Wframe-larger-than=]
>   424 | }
>       | ^
>
> I have no idea what caused this.
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
