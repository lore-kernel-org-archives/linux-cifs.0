Return-Path: <SRS0=8LXX=Y5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EFABC5DF60
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Nov 2019 22:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 449642053B
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Nov 2019 22:28:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lRV9knZq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbfKEW2I (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Nov 2019 17:28:08 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:40100 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730451AbfKEW1H (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Nov 2019 17:27:07 -0500
Received: by mail-il1-f193.google.com with SMTP id d83so19842690ilk.7;
        Tue, 05 Nov 2019 14:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U5wxPbwQtKBHc/N9ZJcuYcLTQ68b1CJSxGQDhLrTlZk=;
        b=lRV9knZqxPJQFL4Ti+/r2J+lfX5hyCNcm3ToQnFf2BqgLtYPNLjaNPMZ6CDF1qZan0
         +rU5CC+rsbVnaex+nnzCwz4k87pq9EYrRadMnhIMon/at2fQYkkoSeHARAYhG1/1oKR7
         LzXbRezlkUVvInWpcuhOCBo4tYpG1oERLBNPCaSIucbSOa7YR7ozvFHvxa9MFNDw1eT8
         Gt/bo0edmR2outPXZfxqHlI5DQACH1g36tE9Lg51qrxVj3Z2gB5Ro9sOwLbt1bpudFQN
         wFMRYUM9xg1ig4hCJSeu5y7ogR5Avd+zvXNezzxiCNLQqAj7UfTF7LZh2DS7BAH2gdHj
         pY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U5wxPbwQtKBHc/N9ZJcuYcLTQ68b1CJSxGQDhLrTlZk=;
        b=Jrr+hBAtq2Yt12bDpCeTIZSGmysaEU46Mm0H4Wy08WH9N4ZGWzankINP45DhLOWkTc
         +b+vstjsxsw9F6x6C4TLnln8XINm9AGYS0Nwr6ICVrKW+EaDspDKdO0HUD1/LU1/KbkS
         IXIedp8f3MiwQ18C5psnp00Nerx6oQ/Kvy0JL9XhPhOuW37gR2YYJeHJ0eB3eaQn5iih
         UHBF4KjIV7shNyDG0E5AyrahNhVp3LQ/AGqFBMD8ZSqBFRI2N8q/rBF2+rBpxIFQndJy
         5QXj93M4eqGVASFJZrMHklhZfS9Nor50YS4BWd71DQo6o9nSqdSxTw6HsAqWguNVCpC/
         bF1w==
X-Gm-Message-State: APjAAAV7HOrrQdXU97HuUcsC4+2k13yEw+OfpyXdQt59yR+i59gWOGuH
        8H1EAM2CpIdqpt/dWNNA+nSUt0XJMgDWLx5xc1zyelY9
X-Google-Smtp-Source: APXvYqzkhGY3lG38QqON8vahg2p/76hRxxnZPDZI/F/hixTAIJPZ3liDt4dCT0+DDf01yPjFZ8wktNFYnfxxlN1GIBc=
X-Received: by 2002:a92:8b4e:: with SMTP id i75mr4984503ild.5.1572992826228;
 Tue, 05 Nov 2019 14:27:06 -0800 (PST)
MIME-Version: 1.0
References: <b797b2fc-1a33-7311-70d7-dd258d721a03@web.de>
In-Reply-To: <b797b2fc-1a33-7311-70d7-dd258d721a03@web.de>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 5 Nov 2019 16:26:55 -0600
Message-ID: <CAH2r5mvWXtSdKb3RcSR_Z6LwsGhDmR0wBeKekwkS-VG4YnFNpQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] CIFS: Adjustments for smb2_ioctl_query_info()
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, Nov 5, 2019 at 3:38 PM Markus Elfring <Markus.Elfring@web.de> wrote:
>
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 5 Nov 2019 22:32:23 +0100
>
> Two update suggestions were taken into account
> from static source code analysis.
>
> Markus Elfring (2):
>   Use memdup_user() rather than duplicating its implementation
>   Use common error handling code in smb2_ioctl_query_info()
>
>  fs/cifs/smb2ops.c | 58 ++++++++++++++++++++++-------------------------
>  1 file changed, 27 insertions(+), 31 deletions(-)
>
> --
> 2.24.0
>


-- 
Thanks,

Steve
