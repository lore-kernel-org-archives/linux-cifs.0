Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF1CFC64E7C
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Dec 2020 09:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F5D8206C0
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Dec 2020 09:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbgLBJxf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Dec 2020 04:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729327AbgLBJxe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Dec 2020 04:53:34 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EAFC0613D4
        for <linux-cifs@vger.kernel.org>; Wed,  2 Dec 2020 01:52:54 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id 2so1033271ybc.12
        for <linux-cifs@vger.kernel.org>; Wed, 02 Dec 2020 01:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O7UqWr9QzAJrBlnQvptGneh3Jz6Y4DLLEk9rKCOZU0U=;
        b=vKmsOXAxEAoQY3cTQYnnprif/peYhn/Dy3wQ1yorVvGkxElY4rPKjx86vllM9Y+wcA
         GpT8dHi5Ds5NSsv2vp78/5Ns3QI+qnvARfB1q3e8M3qAubsjfihMjsOR8sOrA1EzgFa+
         C3tsKUdP8+P5Kp1wgz0O7rCaklt/iW5IaOzUgN7In7FVFezFDx7/SwZtgaI+T9mh8tsu
         T1p284ypMVu2LFgDlvdOA9RSY2oW1V1ybcfSFBQkz9L2ydjc7H46T1h3hFRDMjsIi5/T
         a5klN5pTIz/P3A8sMh/9QhtVbcrjWWAYIrKsBXCQZQaBbmk4nhl9WLDqngTLNO2NLvxp
         02Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O7UqWr9QzAJrBlnQvptGneh3Jz6Y4DLLEk9rKCOZU0U=;
        b=Yg4hC+ejt9qbaHPO3iUB/AoRwXja2ss/HrIdbWKS5XAzsWfmz85T0Q9wKhi/OHg2O/
         rYYjyTEKg28BXI/QgyD2PwmI8jMlaB8ik8Lfe2mQ4geeBbseAZtdMzTrhm605tCGzW7v
         vq6fiSCHWQWqy1M1mR+yNbA8YWRuH+wJsaA/gCx2Wob/nPB+eo9zxGYf07e+O256VBcM
         5gY1scqUOJ2Nh+0sA5v9AhudvBypD2OlKGYCeEW4Fnf2RhILJzq9CkQB1Hv40vKf8/Ro
         vR8SS1how6IDPJ7KNCzJrPzJva5E4k0cwq0brStC6Uc7UnQhEpDQO3h6jxSqkR+avS6k
         zqLw==
X-Gm-Message-State: AOAM5330OexueqGKUli6rkSPpqyt4QNsfTTXgx5q9PcomGl9oOGR5Vqk
        dotHTGPtrEBkUlezxBfP2TzyctOA6D3yU7lKMPA=
X-Google-Smtp-Source: ABdhPJws+rXic+g64OjeiUNYSds5AcCv2OZadRzVtHxlsgUIEnm6pdnPO7OdeTye53C38EmTQH0/QD5HxFqcW/DS9BU=
X-Received: by 2002:a25:7608:: with SMTP id r8mr2762630ybc.131.1606902773552;
 Wed, 02 Dec 2020 01:52:53 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtkt6-ezyTC6zoi+DBjYQ3qFwW3UneF0_4qETEt51Tm9w@mail.gmail.com>
 <CAH2r5mt+=ELCwSASFsPPjET=qf80_1tOTMPN-gG9cF=BQd-VBg@mail.gmail.com>
In-Reply-To: <CAH2r5mt+=ELCwSASFsPPjET=qf80_1tOTMPN-gG9cF=BQd-VBg@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 2 Dec 2020 15:22:42 +0530
Message-ID: <CANT5p=rXznKiOK0mGa+K00vsi2siTLiniKKD3M62QeKSAUj58Q@mail.gmail.com>
Subject: Re: [SMB3][PATCH] ifs: refactor create_sd_buf() and and avoid
 corrupting the buffer
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Friday, I made similar changes as a part of my changes for sending
default sec_desc, while testing against Azure.
The idea is similar to Ronnie's patch. Move the owner and group SIDs
up and push down the DACL.
In addition to the changes Ronnie made, it looks like the 8-byte
alignment is required for few of the other offset fields too.
Hopefully, I'll have it tested out by EOD, and send out another patch.

Regards,
Shyam

On Tue, Dec 1, 2020 at 9:54 AM Steve French <smfrench@gmail.com> wrote:
>
> Updated patch with fixes for various endian sparse warnings
>
>
> On Mon, Nov 30, 2020 at 12:02 AM Steve French <smfrench@gmail.com> wrote:
> >
> > When mounting with "idsfromsid" mount option, Azure
> > corrupted the owner SIDs due to excessive padding
> > caused by placing the owner fields at the end of the
> > security descriptor on create.  Placing owners at the
> > front of the security descriptor (rather than the end)
> > is also safer, as the number of ACEs (that follow it)
> > are variable.
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



-- 
-Shyam
