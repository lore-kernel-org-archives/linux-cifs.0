Return-Path: <SRS0=TBB8=72=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B349C433DF
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Jun 2020 21:31:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0266D207DD
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Jun 2020 21:31:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f2rfWr3U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgFMVbQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 Jun 2020 17:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgFMVbP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 13 Jun 2020 17:31:15 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD371C03E96F;
        Sat, 13 Jun 2020 14:31:15 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id o4so6893797ybp.0;
        Sat, 13 Jun 2020 14:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nOtq4IfCN7fb95vJs6iUg3mhuTz6pORH3UinBbE37sI=;
        b=f2rfWr3UnBc7TAhoJXIMZSx2Fect0CYk4IxifgL8ua+OrYVv82/Hk89QPliiJK5PR0
         6nqX26p8qqOljOi5Hvi1T7/xv7VvhfWhi3KqAESP6GuJ8/u1G1kaQr3M7jjmrp1aVtlD
         en4ei33ZVHs/yj7S7QeMgQuinR2FiY68xms/EgLeAOGlow+rCRqpI3S0WcpsBVoaWB0+
         GmcSeGyhtLIJ9hSkjE9uXrY9fcyupZZbOFC1CiBoW70dVrJFJYmDmg5vSviVWRh4hlWy
         OMcpk1mMvX+KCkefaOWkZWeYQqRicdck/DUdyyTuCZ5unRJYw8HkvUrNaI5IBxrtJapR
         zwJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nOtq4IfCN7fb95vJs6iUg3mhuTz6pORH3UinBbE37sI=;
        b=HCP5FGNnCA3Jjq4pso7VOCSdzej/fKxSUln90PtwV4nBLqtpKDhvDCa2V6y/QPB5z3
         SbpeuQD/H5wDSROzATGFs6NfotdCxt+4GEVjj7mFQKzA55tt5IqlO3g7eNEVHUiPbtHN
         vMxxTThRsTlgOCP1299JQYxFJxHNQRpJb0iPQL377J3gfQv56GCvOy9F++Gtd1/sNh1e
         EiaWIOOd3VoOygAl+TJOKQVTCbCJMQ/abH7rcQ99PK0lyCfhccFhm7gdA9FaNfiyjB3/
         0OTMUAqSGHcFhb2T99VS/FxUBfbTR7DO7AM8/5cCrjeCTJQFvbFh4w2kiLHTq0SkfRyd
         f62A==
X-Gm-Message-State: AOAM530kRqS34fyCi0mRPqBBytZqxXFyEqczuT8fEvb0udhhrjZoUazJ
        sDR4RBqSGqMzEfhSYyuUy9ewNaB/ROck+V0hQpI=
X-Google-Smtp-Source: ABdhPJx/QdegrSi/PieXiJ1curU9LJV9mDZho/vWSlJm8ozO0w7/odlnaJPKy49cX/9cytFQFApn9bc4a861GJxFFXE=
X-Received: by 2002:a25:ca45:: with SMTP id a66mr31494866ybg.85.1592083873963;
 Sat, 13 Jun 2020 14:31:13 -0700 (PDT)
MIME-Version: 1.0
References: <1592051229-93898-1-git-send-email-xiyuyang19@fudan.edu.cn>
In-Reply-To: <1592051229-93898-1-git-send-email-xiyuyang19@fudan.edu.cn>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 13 Jun 2020 16:31:02 -0500
Message-ID: <CAH2r5msU3Oq4swZ2wkUHgNAW1BAM33NT01YEdaGWKSCK+NX-JQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix cached_fid refcnt leak in open_shroot
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, yuanxzhang@fudan.edu.cn,
        kjlu@umn.edu, Xin Tan <tanxin.ctf@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

added cc:stable and merged into cifs-2.6.git for-next

On Sat, Jun 13, 2020 at 7:36 AM Xiyu Yang <xiyuyang19@fudan.edu.cn> wrote:
>
> open_shroot() invokes kref_get(), which increases the refcount of the
> "tcon->crfid" object. When open_shroot() returns not zero, it means the
> open operation failed and close_shroot() will not be called to decrement
> the refcount of the "tcon->crfid".
>
> The reference counting issue happens in one normal path of
> open_shroot(). When the cached root have been opened successfully in a
> concurrent process, the function increases the refcount and jump to
> "oshr_free" to return. However the current return value "rc" may not
> equal to 0, thus the increased refcount will not be balanced outside the
> function, causing a refcnt leak.
>
> Fix this issue by setting the value of "rc" to 0 before jumping to
> "oshr_free" label.
>
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
> ---
>  fs/cifs/smb2ops.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 736d86b8a910..28553d45604e 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -763,6 +763,7 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
>                         /* close extra handle outside of crit sec */
>                         SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
>                 }
> +               rc = 0;
>                 goto oshr_free;
>         }
>
> --
> 2.7.4
>


-- 
Thanks,

Steve
