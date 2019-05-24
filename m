Return-Path: <SRS0=//+f=TY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CEE7C072B5
	for <linux-cifs@archiver.kernel.org>; Fri, 24 May 2019 14:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 517DD206A3
	for <linux-cifs@archiver.kernel.org>; Fri, 24 May 2019 14:14:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uhKgduvE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404110AbfEXOOU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 May 2019 10:14:20 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:37204 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403981AbfEXOOU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 May 2019 10:14:20 -0400
Received: by mail-pg1-f176.google.com with SMTP id n27so5144478pgm.4;
        Fri, 24 May 2019 07:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6h70DII01vc5AT/Achjo29MFy4kzT0/DLQcmd2XnwKU=;
        b=uhKgduvEe5oxL2fXoG++sjialxQ50ChAUc3WciT4t+SZTulJ3J3/bZIpdDbjk08wlg
         o3eWmb5PZJwSFboUwNHxoqeiKL4748uKaczaIUgs6H/fbw0mH8Gr75uv9bTHaJ9x8LaV
         0tM/In3eYG9sKCGigcR04zYl/sSmP/Z1Vx3BStQqXHwgNpCaTOo5TfzYha/N8mZoQhIR
         YD8tjpG3fmxTIBoSxTZKaLq58X843NLFbvNNE939bHcIAl4S94/9C17yDxb5qvJI7uac
         J+T14mjnX04J6FNaEpIioHtV/e0K/vwhFC2+1PIsXZn+ZwZ7R7xnM3uitf87cFxPkZsP
         AlJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6h70DII01vc5AT/Achjo29MFy4kzT0/DLQcmd2XnwKU=;
        b=cd7qeMxtjCeSAuQdi0Pb2d0ZrM+YwORXebG6iw0imR5Pv29DWFZ8uPnVCh6htbDN8u
         Mj4+11Hmk+F/QJOEFxQ1pyM7e+TkdZXutRVeD2Mcr8yML4nr1z1lj4q/QJ1I7DyWzX0m
         1LRpCrhIyfzMAW/O2YEwLTtm1H5pb9S/rYBo6MJFRt9c8xdrZBGbn7lzhoStUWeQy+Ct
         JoV1nhhaxtoZQfYRNuWOp0o7lAyHbpPcqL2cDP77yPJBE8ZbQtiuKIxwC5heg1jtdZxe
         LLdMJYRXq/UR6PESuV945R+zF5OuwvtoUsh0S/SDSn4pYwRq0qxr6RpxT5vVkNPEQNE3
         Y2Mg==
X-Gm-Message-State: APjAAAX5bnhlA8JiOl9eVykv+fShFZNp73CsDvZ0V3k2f290Z2Yw72Tm
        m4PRXTrayHbg5E/HyRWW0VG0Sxf4XU0iOrKUjDo=
X-Google-Smtp-Source: APXvYqyjUPYjp6u5VBIgbQIbByV2A/1X2b6aOT6ENs5VfoMXsbamQalLOcb+p9ougBdtkYbEn0Hr7Kf/+DaQUR3+bkY=
X-Received: by 2002:aa7:8495:: with SMTP id u21mr102639494pfn.125.1558707259841;
 Fri, 24 May 2019 07:14:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190524142713.360c0c10@canb.auug.org.au>
In-Reply-To: <20190524142713.360c0c10@canb.auug.org.au>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 24 May 2019 09:14:07 -0500
Message-ID: <CAH2r5msm9TfC8f5WNOyD-9g01u9m-UNPuk_XPp3Ykhc4u7+Rtg@mail.gmail.com>
Subject: Re: linux-next: Fixes tag needs some work in the cifs tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Murphy Zhou <jencce.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

fixed and repushed to cifs-2.6.git for-next

On Thu, May 23, 2019 at 11:27 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> In commit
>
>   f875253b5fe6 ("fs/cifs/smb2pdu.c: fix buffer free in SMB2_ioctl_free")
>
> Fixes tag
>
>   Fixes: 2c87d6a ("cifs: Allocate memory for all iovs in smb2_ioctl")
>
> has these problem(s):
>
>   - SHA1 should be at least 12 digits long
>     Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
>     or later) just making sure it is not set (or set to "auto").
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
