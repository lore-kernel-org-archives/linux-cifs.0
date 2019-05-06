Return-Path: <SRS0=HMAP=TG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68296C04A6B
	for <linux-cifs@archiver.kernel.org>; Mon,  6 May 2019 17:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 339A5205ED
	for <linux-cifs@archiver.kernel.org>; Mon,  6 May 2019 17:02:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cz5Eejok"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbfEFRCT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 May 2019 13:02:19 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:32890 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbfEFRCT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 May 2019 13:02:19 -0400
Received: by mail-pg1-f196.google.com with SMTP id h17so775231pgv.0;
        Mon, 06 May 2019 10:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qy+Uvnt48sjAfiUPJQkldDmklRLHRIc2GGNrnTuoC0Q=;
        b=Cz5Eejokd6UGPW9qdjFeTimi9ZTg0DcaFj32df9nbInXYCObQYSCoEkyAChntWZ5H+
         E5FD/xoLySqtV06cAIB523RuTsFNGsmeMHQuQ4PFZrzOzU3NjbnNgPM1zDbIHwE0ras+
         1fmQJDHy3FiA3btWdLmfXNWo+a5ebrpr1qHcEfK+w6CNAlPW69DoCwB9JXNyTOoYKBxk
         +OS7iAiP5ajY19lxbGlrIJAPdtFbDNLsHIqsP2I8eRLJD7+kC4JzLqaj9TJW5LHMsclL
         dDnaa9ZXEAz4Kdq300KGoFHfc4fXwki4OiMKZks27JiVbmI/Pb1QUsVRpUoaN3SuOPEj
         mdTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qy+Uvnt48sjAfiUPJQkldDmklRLHRIc2GGNrnTuoC0Q=;
        b=L5tvZ2Jz0X0aOIyjcstpAshBjy3QO/40YkqunZid3CkDKJnTVT/eqnCu9tAX48J0S+
         w3n5R2/i03f5OYbz396iyywXYmybLXnayAPNREYIVOPydQkGGKAYI1LHddKou1lz0IfB
         jarJGAJqC6EBMlPvX+qBeZhEPvuU/loyHkZaP0s/mVavjuGnQvLDYHVBtJG8sJZnliuC
         gFQVweCC1NPn8tXfIOal/wwhsAUTmdcMzQWVavwpD/W0lkZyQJI9LPOY0QL7fjj1FHxh
         nvgAl3r5s39Aw1s7f28G6F9lUQZ3alwtNAMRYvIYRv2QEFT1F7ZBNg0dGUovCZl82b8H
         PWIA==
X-Gm-Message-State: APjAAAVsLx43oasMudwEIEejfLhlhUPz+TcY+ulAzd4i4wviwXz9ojtb
        x4zDqPd7QoVVQRBoPVstNIr10HGPbFreEa8X5uQ=
X-Google-Smtp-Source: APXvYqzyPYN8ElDG7RR+MU74p733KZu/WFf/OnvpHRT8RjSxRlE0QQwZSM9VxyhJNbI6zJ2HAwg5yMapk+3YEKzN6XQ=
X-Received: by 2002:a62:479b:: with SMTP id p27mr35842131pfi.111.1557162138865;
 Mon, 06 May 2019 10:02:18 -0700 (PDT)
MIME-Version: 1.0
References: <1557155792-2703-1-git-send-email-kernel@probst.it>
 <CAH2r5mtdpOvcE25P2UuNFpOwsNyFiBWRQELQFui+FJGVOOBV8w@mail.gmail.com> <20190506165658.GA168433@jra4>
In-Reply-To: <20190506165658.GA168433@jra4>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 6 May 2019 12:02:07 -0500
Message-ID: <CAH2r5msK6yNNm_QbdsFZuB5uS0iNRuqe8gSDKvVAiR0N6E3MWg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix strcat buffer overflow in smb21_set_oplock_level()
To:     Jeremy Allison <jra@samba.org>
Cc:     Christoph Probst <kernel@probst.it>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We could always switch it to strncpy :)

In any case - he is correct, it is better than what was there because
we should not strcat unless the array were locked across the whole
function

On Mon, May 6, 2019 at 11:57 AM Jeremy Allison <jra@samba.org> wrote:
>
> On Mon, May 06, 2019 at 11:53:44AM -0500, Steve French via samba-technical wrote:
> > I think strcpy is clearer - but I don't think it can overflow since if
> > R, W or W were written to "message" then cinode->oplock would be
> > non-zero so we would never strcap "None"
>
> Ahem. In Samba we have :
>
> lib/util/safe_string.h:#define strcpy(dest,src) __ERROR__XX__NEVER_USE_STRCPY___;
>
> Maybe you should do likewise :-).
>
> > On Mon, May 6, 2019 at 10:26 AM Christoph Probst <kernel@probst.it> wrote:
> > >
> > > Change strcat to strcpy in the "None" case as it is never valid to append
> > > "None" to any other message. It may also overflow char message[5], in a
> > > race condition on cinode if cinode->oplock is unset by another thread
> > > after "RHW" or "RH" had been written to message.
> > >
> > > Signed-off-by: Christoph Probst <kernel@probst.it>
> > > ---
> > >  fs/cifs/smb2ops.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > > index c36ff0d..5fd5567 100644
> > > --- a/fs/cifs/smb2ops.c
> > > +++ b/fs/cifs/smb2ops.c
> > > @@ -2936,7 +2936,7 @@ smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
> > >                 strcat(message, "W");
> > >         }
> > >         if (!cinode->oplock)
> > > -               strcat(message, "None");
> > > +               strcpy(message, "None");
> > >         cifs_dbg(FYI, "%s Lease granted on inode %p\n", message,
> > >                  &cinode->vfs_inode);
> > >  }
> > > --
> > > 2.1.4
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve
> >



-- 
Thanks,

Steve
