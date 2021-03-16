Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB336C433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Mar 2021 17:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A49665120
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Mar 2021 17:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbhCPRhN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Mar 2021 13:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhCPRg4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Mar 2021 13:36:56 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89885C06174A;
        Tue, 16 Mar 2021 10:36:56 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id t37so12270088pga.11;
        Tue, 16 Mar 2021 10:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C2INz9jGth8YqEdF26bQM1k6RpOCFfBaXRyDGUE3fpc=;
        b=P0OwSngSahcWKM+DXoqhwv+uPm+yg/lInhL1wNxTMQR6yEzaEy57rxnPApK0DJUzoA
         iReZLBDd+2VyfEZBcCf47SR+034817WZqSOhfji1tJmobI3q9rChdC1n+elSBCl4TpFu
         LDSk7PGYZOu7TLepnzmNOwSw1t92QGsab6uk1WGcWiMslfGY0aOQ0LP+hS/3By0Zd4/Q
         nKxgbRpBSQjK69FlerA5FW67aTN6cPTH7cWyTJD6JE3b1IBN4eSNGS607Q3LI72ybnZg
         OyxTX0bXv3I0eMJG6CBUfMDlpgaV18ZrY/L+XPuepigkNpnp6D4XQPW+oIDWXeamiQNT
         jqDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C2INz9jGth8YqEdF26bQM1k6RpOCFfBaXRyDGUE3fpc=;
        b=G2YxRRnHqcVRvusMG9JCuLe16RPgCjtH286EX3FfgFoqYsEMNK2Jbu6ZU/egS0u7ZE
         t4YeJeJSOMWdWje521K1Op9pWyGc/dLPgbO2C9trNlSww/n+/PdT78l5mQoX4fQkM/Qv
         n352e8VSCvU7oCoY23cUYUyHtRtJeYEzf/8M12zH87F/k9ONE80+CfxKZv54D2/owlCX
         1aY1yYxGvU7BTMjXwkrTZWF2JYH28YAl5+TPFDFtQEtlOBHI/Gqqe/roIhA1SBI1Xasq
         rPecemR5H+tYIELJln1/Hj3dJRZ+bgEBFejx4p8Ju6aeR+ijC1gxccjlR6N1ZM7W0ZVg
         AqAQ==
X-Gm-Message-State: AOAM532qPrhIeyTh6MXAJk2vKENb0ZF23n0HUpoBBpcp0QRemzhauW6R
        fMkWwQ9PFTk8o8Jgw/kA4xuQTJu967Jl4t2gr/nF6P3lMDqxbg==
X-Google-Smtp-Source: ABdhPJymcDQn3heAnXPpCVSxyZhuxe2XCqoedKL02xJ1Af0X+YC26nDoDK1yat7ZvJ45X1ts4tNHKZRzHGJpIone/Bg=
X-Received: by 2002:a63:4652:: with SMTP id v18mr655646pgk.87.1615916216114;
 Tue, 16 Mar 2021 10:36:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210316124808.11984-1-vincent.whitchurch@axis.com> <93d506a6-5832-5006-3bab-6e8e7203da0e@talpey.com>
In-Reply-To: <93d506a6-5832-5006-3bab-6e8e7203da0e@talpey.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Tue, 16 Mar 2021 23:06:45 +0530
Message-ID: <CACdtm0ac+oE1+KNbOGWhy-j9XHmUn4AXG6zAaX-nL0W=NJxQMA@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: Silently ignore unknown oplock break handle
To:     Tom Talpey <tom@talpey.com>
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>, kernel@axis.com,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This issue will not be seen once changes related to deferred close for
files is committed.
Currently, changes are in review. I will address review comments by this week.

Regards,
Rohith

On Tue, Mar 16, 2021 at 9:33 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 3/16/2021 8:48 AM, Vincent Whitchurch via samba-technical wrote:
> > Make SMB2 not print out an error when an oplock break is received for an
> > unknown handle, similar to SMB1.  The SMB2 lease break path is not
> > affected by this patch.
> >
> > Without this, a program which writes to a file from one thread, and
> > opens, reads, and writes the same file from another thread triggers the
> > below errors several times a minute when run against a Samba server
> > configured with "smb2 leases = no".
> >
> >   CIFS: VFS: \\192.168.0.1 No task to wake, unknown frame received! NumMids 2
> >   00000000: 424d53fe 00000040 00000000 00000012  .SMB@...........
> >   00000010: 00000001 00000000 ffffffff ffffffff  ................
> >   00000020: 00000000 00000000 00000000 00000000  ................
> >   00000030: 00000000 00000000 00000000 00000000  ................
> >
> > Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
> > ---
> >
> > Notes:
> >      v2:
> >      - Drop change to lease break
> >      - Rewrite commit message
> >
> >   fs/cifs/smb2misc.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> > index 60d4bd1eae2b..4d8576e202e3 100644
> > --- a/fs/cifs/smb2misc.c
> > +++ b/fs/cifs/smb2misc.c
> > @@ -755,7 +755,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
> >       }
> >       spin_unlock(&cifs_tcp_ses_lock);
> >       cifs_dbg(FYI, "Can not process oplock break for non-existent connection\n");
> > -     return false;
> > +     return true;
> >   }
> >
> >   void
> >
>
> As an oplock-only approach, it looks good. But the old cifs_dbg message
> "non-existent connection" is possibly misleading, since the connection
> may be perfectly fine.
>
> When breaking the loop successfully, the code emits
>         cifs_dbg(FYI, "file id match, oplock break\n");
> so perhaps
>         cifs_dbg(FYI, "No file id matched, oplock break ignored\n");
> ?
>
> Tom.
