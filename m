Return-Path: <SRS0=CwqD=5A=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCEEC10DCE
	for <linux-cifs@archiver.kernel.org>; Sun, 15 Mar 2020 23:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44C24206B1
	for <linux-cifs@archiver.kernel.org>; Sun, 15 Mar 2020 23:10:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xv6hae6G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgCOXKJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 15 Mar 2020 19:10:09 -0400
Received: from mail-io1-f51.google.com ([209.85.166.51]:41230 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728512AbgCOXKJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 15 Mar 2020 19:10:09 -0400
Received: by mail-io1-f51.google.com with SMTP id m25so15288125ioo.8
        for <linux-cifs@vger.kernel.org>; Sun, 15 Mar 2020 16:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R2SS6FrZJe3tO26unNeweEHgIjlkku2FwfROK8gK5/Q=;
        b=Xv6hae6GQVv7ey7vHDlh+0Ux8FRdbMJ3t4Iyn0I/xq9+yCahd0xhMlZf4q2/xBXAQj
         LPetS6ml60SSK9+IsfIgA7aLDDcF9zNo4O+H4raxL8HpJcO5CME+okVeaDZhD3yYBOkb
         hVVrqxr19lRcbtVFEQ0w1NN7qG08vsJcQQ6Ft4PX0UZLH3gXEGXFas9fzWxC+RMAyjLS
         r3fHXbyJ5niYLYPh6Mb9KvoPSxaSoZpQBM3CZxyrwDyeS2McEN96ekAra+YjoeIHzrUZ
         F3sCKf3io57/ffCAmR7T30diifAWsx4fhChEq0QlWmWeSIY0qfOmlrJpKWP6D/KFNLHc
         WfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R2SS6FrZJe3tO26unNeweEHgIjlkku2FwfROK8gK5/Q=;
        b=IB2QFgQyz0wv2S8IxstEi0UXPy4/etzE4O/KTpdobFJCwu2oJP1CzzMUL64ZGEmisG
         gOTn+I6w5q6t6g72L5clTvSyYy3Ww5TfiJ/IbRciDXzwLKwCbzHyJ5Bdc2dE3Wg/N6Wp
         5RL4jcbbFX6fHSapSKZZRfrf0JUh86KrTtb7armaw1p13vTL4lyuzosndyMxPRtxCpnK
         9Kv27/1umVXNnnYLzRClpauEAb2ZUImT4ZSe7a/VSnE1+1YlPdCfSUBIscbvomzVnZzC
         I9pgtAbVqPYvqSJSdfMJfh5BC9rlBgXogCespvlkRmFIoC/iHTAtz1ujsdHugB8PcXVc
         8qfA==
X-Gm-Message-State: ANhLgQ3qQLydNuT1cUlpxgERjc9kr2AFChlxftnjAXTqwJYFcsjf6KRz
        MXVw/CI/w6H4T29Trl7yG8hAV3GgKuoVjXdh2DI=
X-Google-Smtp-Source: ADFU+vu7juPjWjAl5CNLkH9wtAxY9dOc3eBt6WPUDcs7Ci2eWvn1po3hHno0EdftVfhsnTVYdQizKwj5LXO15hNQinY=
X-Received: by 2002:a02:340c:: with SMTP id x12mr23597047jae.20.1584313807473;
 Sun, 15 Mar 2020 16:10:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms_oxqwHm56nzabM-x2XMR1Ni-WD1_LEYYxOW_NkswsOQ@mail.gmail.com>
 <CAH2r5mvN5ri_7x3dVah8tUft6Xxbjia9MSANZV04TkVwtqY9Tw@mail.gmail.com>
In-Reply-To: <CAH2r5mvN5ri_7x3dVah8tUft6Xxbjia9MSANZV04TkVwtqY9Tw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Mon, 16 Mar 2020 09:09:56 +1000
Message-ID: <CAN05THSjfj2ZJCSEdgdEfiEcxG8=xd-e5zR6KrF8gR_O1Mxb7w@mail.gmail.com>
Subject: Re: [SMB3] New compression flags
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Typo in
+    __le32    Repititions;

otherwise looks good.
Acked-by me for both.

On Mon, Mar 16, 2020 at 9:07 AM Steve French via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> And one more small set of structures for the updated transform header.
> See MS-SMB2 2.2.42.1 and 2.2.42.2
>
>
> On Sun, Mar 15, 2020 at 5:50 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Some compression related flags I noticed were added in the latest MS-SMB2
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve
