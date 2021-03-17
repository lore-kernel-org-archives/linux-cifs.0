Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E90BC433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Mar 2021 13:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCF6D64DFF
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Mar 2021 13:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhCQNs0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Mar 2021 09:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbhCQNsE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Mar 2021 09:48:04 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5368DC06174A;
        Wed, 17 Mar 2021 06:48:04 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso1371926pjb.4;
        Wed, 17 Mar 2021 06:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X0Kd/gVFWEpxhzoIaYRw9w3BiHsoDUdiQGPAy++5+UQ=;
        b=uIskyRGOQTlGpH9G9n0ufXVvvPLqC9vsJNQKEhkHb2ej8r6vK++4thbru0d5D+QBeE
         ixQqlK3cAE5+XwasutWgXtGQXX+LTJR5xrpkLMzqzNX2a2U37xvZpZukPDaAMVk63zv4
         nbLIytQQ2ef3aZZIFmXNFle1RgynEG83AWhRB38m8ujPpAs2LyF+Oj+HYvHeFTlv0lvb
         TwlsAN0h3i9Ldhxf05IuCtROayDpt+8AxQgL1gcpAPdmQgkJb3UIPTQR80ZIXJueMAI8
         istajSi+A7n0//RPZzRWRmBen3lKrCJIk1T3Rx7zt0kp1gd/Wccpyn9M4KMwWlqiPrNr
         xezA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X0Kd/gVFWEpxhzoIaYRw9w3BiHsoDUdiQGPAy++5+UQ=;
        b=LP6UbVzLk3kPKtJTdD9cu6Mk/nYFKPNCXov5zXMpiCypek86IrpIFuFQwB0+6u7P85
         uqatvhzoA7z07oVXFSBMgrx+PXMB45mXrHBIktRyZILFWRx2Yb8XWIqPCIU5p1Te+Jaa
         34dzPEZhfF4pW6aiHEbtxoWzTpIRRq2hTE2vOWc1U1ZjQsIj/zNqA9CdjGWbZkzvbgpl
         5+7awhZ8lbR8S61ITF9QzLNpNjqzAyJCaY3IXH+wMcRIufwGsv8vRgYEV5w6iltYSprJ
         hCmvs6YXtIoFSCareaOTYqc2yKMiOi2p6WzABIzrGaB0rqpG0upyz9eMq4RgGjsLmlSF
         8i/w==
X-Gm-Message-State: AOAM531jgGuuu/Mvpboo6uSZJxkMF/T7fSCsNvki7DwBPRdX7c+kffh/
        BWLHAF7hID4PCO1z0+LFhsWZwRs/IVO3Aj6jNOICSu7uJOMNtg==
X-Google-Smtp-Source: ABdhPJwG0FivMhLbpcIji+7dR87R2XVFxDEGj1pOwRW4U8RxEbX/oSFf59Do89cEX/bxapux9KjUGVp7bPh8EjoxvSw=
X-Received: by 2002:a17:90a:cb8c:: with SMTP id a12mr4906594pju.35.1615988883923;
 Wed, 17 Mar 2021 06:48:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210316124808.11984-1-vincent.whitchurch@axis.com>
 <93d506a6-5832-5006-3bab-6e8e7203da0e@talpey.com> <CACdtm0ac+oE1+KNbOGWhy-j9XHmUn4AXG6zAaX-nL0W=NJxQMA@mail.gmail.com>
 <4836330b-3d2f-9d35-4d03-3a457b0068a4@talpey.com>
In-Reply-To: <4836330b-3d2f-9d35-4d03-3a457b0068a4@talpey.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Wed, 17 Mar 2021 19:17:52 +0530
Message-ID: <CACdtm0bkVyAOJSPnu9sFhO1MnSxtnfH7Z13e_+40WM3Qn6xFbQ@mail.gmail.com>
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

On 3/16/2021 1:36 PM, Rohith Surabattula wrote:
>> This issue will not be seen once changes related to deferred close for
>> files is committed.

>That may be, but it's irrelevant to this.
Got it.

>> Currently, changes are in review. I will address review comments by this week.

>What do you mean by "in review"? Both threads are active on the
>mailing list. If you or others have something to discuss, please
>post it and don't leave us out of the discussion.

I mean, there is an active thread for patch "deferred close for
files". As I was busy with other activities, I didn't update the
thread. Will update the thread once i get to it.

Regards,
Rohith

On Wed, Mar 17, 2021 at 12:59 AM Tom Talpey <tom@talpey.com> wrote:
>
> On 3/16/2021 1:36 PM, Rohith Surabattula wrote:
> > This issue will not be seen once changes related to deferred close for
> > files is committed.
>
> That may be, but it's irrelevant to this.
>
> > Currently, changes are in review. I will address review comments by this week.
>
> What do you mean by "in review"? Both threads are active on the
> mailing list. If you or others have something to discuss, please
> post it and don't leave us out of the discussion.
>
> Tom.
>
>
> > Regards,
> > Rohith
> >
> > On Tue, Mar 16, 2021 at 9:33 PM Tom Talpey <tom@talpey.com> wrote:
> >>
> >> On 3/16/2021 8:48 AM, Vincent Whitchurch via samba-technical wrote:
> >>> Make SMB2 not print out an error when an oplock break is received for an
> >>> unknown handle, similar to SMB1.  The SMB2 lease break path is not
> >>> affected by this patch.
> >>>
> >>> Without this, a program which writes to a file from one thread, and
> >>> opens, reads, and writes the same file from another thread triggers the
> >>> below errors several times a minute when run against a Samba server
> >>> configured with "smb2 leases = no".
> >>>
> >>>    CIFS: VFS: \\192.168.0.1 No task to wake, unknown frame received! NumMids 2
> >>>    00000000: 424d53fe 00000040 00000000 00000012  .SMB@...........
> >>>    00000010: 00000001 00000000 ffffffff ffffffff  ................
> >>>    00000020: 00000000 00000000 00000000 00000000  ................
> >>>    00000030: 00000000 00000000 00000000 00000000  ................
> >>>
> >>> Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
> >>> ---
> >>>
> >>> Notes:
> >>>       v2:
> >>>       - Drop change to lease break
> >>>       - Rewrite commit message
> >>>
> >>>    fs/cifs/smb2misc.c | 2 +-
> >>>    1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> >>> index 60d4bd1eae2b..4d8576e202e3 100644
> >>> --- a/fs/cifs/smb2misc.c
> >>> +++ b/fs/cifs/smb2misc.c
> >>> @@ -755,7 +755,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
> >>>        }
> >>>        spin_unlock(&cifs_tcp_ses_lock);
> >>>        cifs_dbg(FYI, "Can not process oplock break for non-existent connection\n");
> >>> -     return false;
> >>> +     return true;
> >>>    }
> >>>
> >>>    void
> >>>
> >>
> >> As an oplock-only approach, it looks good. But the old cifs_dbg message
> >> "non-existent connection" is possibly misleading, since the connection
> >> may be perfectly fine.
> >>
> >> When breaking the loop successfully, the code emits
> >>          cifs_dbg(FYI, "file id match, oplock break\n");
> >> so perhaps
> >>          cifs_dbg(FYI, "No file id matched, oplock break ignored\n");
> >> ?
> >>
> >> Tom.
> >
