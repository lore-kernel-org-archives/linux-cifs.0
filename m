Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD94C4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Oct 2022 17:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiJQR3y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Oct 2022 13:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiJQR3s (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Oct 2022 13:29:48 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991AA13F13
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 10:29:27 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id h3so12214505vsa.4
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 10:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5niwhkZmEgrG/IrLqoUWH0fTfvBCXqgz6IJ+PQ24Q9I=;
        b=Dy7wQAFkvyKKky9dpueuamajeKqljIldnRXRPxbpTzOCIHVdNVKFQ8e5Q2MicQi7FS
         Bz2SWel0vmvy7av4jokKgUO/W+lrIOdL/3B07UzFcdT07w3uqHFF8phzcgcBJKSqQoxE
         YFMnAPmvbG8FZASNkiHeflnu92it28OF8PGoxU7x9/BNqd0LQoH9TJMCVUBI7nhR2k9G
         ZMNQ8DOpleazX6H9djD4gqynm4rIGQ00VKrYfH6FBD6ToVfZ8tLKR9O1g+TUTUtWl+nT
         xcU3y8jTcCujXPhUJ+AgGjlpBsSl8S7ffIH4LORpSrn6A/91L7sMYMp/gJaN3n+4MH4P
         nVGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5niwhkZmEgrG/IrLqoUWH0fTfvBCXqgz6IJ+PQ24Q9I=;
        b=Kwoss+9kY4qwXzcljUcjyJG/Uw+vMlLwO4Ia+mcmiM6lFi8MN4IQ3dWBVN4/kE68Xf
         GaQWOfQRm19rcea9HsDG9oCPdpMKS2O+Fhpo8clSa5NynaiaZl41vxnW6Caqs4iwPe1M
         oQHlVa5hBbbJVIzZlNxi+8E9n7vGaEFUmoucb171ndssg1rhrq0QcgWJbezTdNeh0UdT
         o1u12EneAVXnguoREA5s6hJHQ15S6UMmJ9vNgcRMgZ5grpL1/s8mlSJLAiE8g19E5tyl
         evPbQcDLoFtC4pENrTUofhn0xnobO+FaPxgP96U/L3IWZ5YFXXzhh2mG0VYNu3Nux8zp
         D4sg==
X-Gm-Message-State: ACrzQf0X2XmHZMysqindd+gDl+qpt5UHnVeytc2cFrhvmvIMdwtFPdLJ
        CI9CgG8wfPZLzKzYu663+iCCUSBP8IxdBgUT54FE3vK4
X-Google-Smtp-Source: AMsMyM4v0EBuetmqOoEUspT9AdJYOWU1+hK85qIwXHtzuPJCSBPFz52MXeCz1OyQX6Lt/suYozBWYQcCuxEEW4ecuJ0=
X-Received: by 2002:a67:fc97:0:b0:3a6:d37e:e7a3 with SMTP id
 x23-20020a67fc97000000b003a6d37ee7a3mr4803475vsp.29.1666027695355; Mon, 17
 Oct 2022 10:28:15 -0700 (PDT)
MIME-Version: 1.0
References: <20221017144525.414313-1-zhangxiaoxu5@huawei.com>
In-Reply-To: <20221017144525.414313-1-zhangxiaoxu5@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 17 Oct 2022 12:28:04 -0500
Message-ID: <CAH2r5mv=JmG7WppxXz4wJe3GWHvu6Ak4Q140bREUdAFnDtDvaw@mail.gmail.com>
Subject: Re: [PATCH 0/5] cifs: Fix xid leak in cifs
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org, pc@cjr.nz,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
        aaptel@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Good catch - merged into cifs-2.6.git for-next

In one of the cases we also as an alternative could have skipped the
get_xid instead as an alternative (and passed zero as xid to negotiate
in that case) - but your approach may be slightly better

On Mon, Oct 17, 2022 at 8:42 AM Zhang Xiaoxu <zhangxiaoxu5@huawei.com> wrote:
>
> Found some xid leak with the following cocci script:
>
> /usr/bin/spatch -I include -timeout 60 -very_quiet \
>         -sp_file missing-free_xid.cocci fs/cifs
>
> @r1@
> identifier xid;
> position p;
> @@
> ...
>   xid = get_xid();
> <+... when != free_xid(xid)
>   if (...) {
>     ... when != free_xid(xid)
>         when forall
>     return@p ...;
>   }
> ...+>
>   free_xid(xid);
>
> @depends on r1@
> position r1.p;
> @@
> + free_xid(xid);
>   return@p ...;
>
> @r2@
> identifier xid;
> position p;
> @@
> ...
>   unsigned int xid = get_xid();
> <+... when != free_xid(xid)
>   if (...) {
>     ... when != free_xid(xid)
>         when forall
>     return@p ...;
>   }
> ...+>
>   free_xid(xid);
>
> @depends on r2@
> position r2.p;
> @@
> + free_xid(xid);
>   return@p ...;
>
> @r3@
> identifier xid;
> position p;
> @@
> ...
>   xid = get_xid();
>   ... when != \(free_xid\|_free_xid\)(xid);
>   return@p ...;
>
> @depends on r3@
> position r3.p;
> @@
> + free_xid(xid);
>   return@p ...;
>
> @r4@
> identifier xid;
> position p;
> @@
> ...
>   unsigned int xid = get_xid();
>   ... when != \(free_xid\|_free_xid\)(xid);
>   return@p ...;
>
> @depends on r4@
> position r4.p;
> @@
> + free_xid(xid);
>   return@p ...;
>
> Zhang Xiaoxu (5):
>   cifs: Fix xid leak in cifs_create()
>   cifs: Fix xid leak in cifs_copy_file_range()
>   cifs: Fix xid leak in cifs_flock()
>   cifs: Fix xid leak in cifs_ses_add_channel()
>   cifs: Fix xid leak in cifs_get_file_info_unix()
>
>  fs/cifs/cifsfs.c |  7 +++++--
>  fs/cifs/dir.c    |  6 ++++--
>  fs/cifs/file.c   | 11 +++++++----
>  fs/cifs/inode.c  |  6 ++++--
>  fs/cifs/sess.c   |  1 +
>  5 files changed, 21 insertions(+), 10 deletions(-)
>
> --
> 2.31.1
>


-- 
Thanks,

Steve
