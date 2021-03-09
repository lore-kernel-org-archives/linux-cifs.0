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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E44EC433E0
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 00:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43ED965287
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 00:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhCIAFf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 19:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhCIAFX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 19:05:23 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B36C06174A;
        Mon,  8 Mar 2021 16:05:23 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id o9so11994095iow.6;
        Mon, 08 Mar 2021 16:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1dqCVTG2109HqZ5qitjhQym98S7SrqCwUMAJTjbj+9Y=;
        b=UEihR8CrE4FeNvT2OdS7bRAfFJCmRPsb30Kiepa47DNk2DE7zZbdu+v6dLRCJfRBCO
         oRwRvLNClbJaUy5/ecqwuAWxT5sW1ijnnlfn2osB6d9V7I6PD5SClj98hqqAlzk0YiTi
         Kz8NkwSO1Ts26CcybddV9OyUWdDndv3VPBlFEkusMyTOyW5Skb17fmNoWrNThK3nNtcY
         WhCy8NNJIy7prx5fKzFWuoBkcJCn0Thh6PTC8bGOP8LmKZBsglQXDo9LiIv5DLP5uxLY
         AefbjUIWHSznFSoHWpa9nSdJJg/siTERIO7DByP+cOdkVI1O3d27tCAyQMvWO5IvfdGA
         GQWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1dqCVTG2109HqZ5qitjhQym98S7SrqCwUMAJTjbj+9Y=;
        b=pp8117bgi5sketlHPV5AJ9jrYSyCnpjsM4CdKKKREaWitKJphvVudoGmvtwuJhiJlf
         PwT7nOJbxTeT/kvsLG4J9DFMmrbvFgYbVSMnOYWDK9pnZkPlXs8Wr4qavW29JwbabzgO
         FHJhQonHQhDkFxe3sbdzEXWMnGa6+WiXYiKOyaKIcuEH7WgrIzMGY446qVbWyyDSB8w+
         DT2YsMgWcqxGdE/JnSho4Mzo6Nc58EinKW7yhU0dwyqdbiHob19iaizPGXk+VjDLx+eM
         o3N1fRMS4WPElz7fzigN5ufK4jBnn7Drj77x8CyKDLWzodlS4gXKo5o8lyG9/aOe39QW
         0zXw==
X-Gm-Message-State: AOAM533bpGav2iCMjpJSr0EL0dLLX9bX/Wb6HKMA35YP0Yg2NK8mlOdB
        wnEAkYnkOJWX/TS9/ZNd8C9LD72NnGexgv0HvNw=
X-Google-Smtp-Source: ABdhPJzTcYB5yot0LrZe6zznt36hN//F09p3og4Ka+6TY2XhELvZ9Za8LU1mTe1TUZ6Z4d31CE/oMDyplA5k2K9kA9w=
X-Received: by 2002:a02:9042:: with SMTP id y2mr26340053jaf.94.1615248322889;
 Mon, 08 Mar 2021 16:05:22 -0800 (PST)
MIME-Version: 1.0
References: <20210305094107.13743-1-vincent.whitchurch@axis.com> <CANT5p=rB2=DvjtpmVy803emWpuzsy-C2+d4wqQ5g_9fJ8+a5Cw@mail.gmail.com>
In-Reply-To: <CANT5p=rB2=DvjtpmVy803emWpuzsy-C2+d4wqQ5g_9fJ8+a5Cw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 9 Mar 2021 10:05:11 +1000
Message-ID: <CAN05THQtb5RY2ye7nkyWBjrXS+=usZCxUM7jBQG+JEpg_TQQTA@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Prevent error log on spurious oplock break
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>, kernel@axis.com,
        Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Mar 7, 2021 at 8:52 PM Shyam Prasad N via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Hi Vincent,
>
> The reason for rejecting the request maybe a number of things like:
> corrupted request, stale request (for some old session), or for a
> wrong handle.
> I don't think we should treat any of these cases as a success.

I agree with Shyam here.
We shouldn't change the return value to pretend success just to
suppress a warning.

However, if it is common to trigger with false positives we might want
to something to prevent it from
spamming the logs.
These messages could be useful if we encounter bugs in our leasing
code, or bugs in server
lease code, so we should't throw them away completely. But if false
positives are common ...

Some thoughts I and Stever brainstormed about could be to change the code in the
demiltiplex thread where we currently dump the packets that were "invalid"
to maybe:
*  log once as VFS and then log any future ones as FYI
* log once as VFS and then only make the others available via dynamic
trace points
* rate limit it so we only log it once every n minutes?  (this is overkill?)



>
> Also, from the MS-SMB2 documentation:
> https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/4f35576a-6f3b-40f0-a832-1c30b0afccb3
>
> "The client MUST locate the file in the GlobalFileTable using the
> LeaseKey in the Lease Break Notification. If a file is not found, no
> further processing is required."
>
> So I don't think we should be changing the logic here.
> If SMB v1 had a different behaviour, we should check if that is as per
> the protocol documentation. If not, change it.
>
> Regards,
> Shyam
>
> On Fri, Mar 5, 2021 at 3:12 PM Vincent Whitchurch
> <vincent.whitchurch@axis.com> wrote:
> >
> > The SMB1 version of ->is_oplock_break() returns true even if the FileId
> > is not found, as long as the oplock break notification message structure
> > itself appears to be valid.  A true return value makes
> > cifs_demultiplex_thread() to not print an error message for such
> > packets.
> >
> > However, the SMB2 version returns false in such cases, leading to an
> > error "No task to wake, unknown frame received!" followed by a hexdump
> > of the packet header being printed by cifs_demultiplex_thread().
> >
> > Note that before commit fa9c2362497fbd64788063288d ("CIFS: Fix SMB2
> > oplock break processing"), SMB2 also returned true for the case where a
> > connection was found but the FileId was not, but it's not clear to me if
> > that commit really intended to change the behaviour of the error prints.
> >
> > Change the behaviour of SMB2 to be the same as SMB1 and avoid the error
> > messages for these packets which we ignore as per the spec.
> >
> > Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
> > ---
> >  fs/cifs/smb2misc.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> > index 60d4bd1eae2b..3ea3bda64083 100644
> > --- a/fs/cifs/smb2misc.c
> > +++ b/fs/cifs/smb2misc.c
> > @@ -679,7 +679,7 @@ smb2_is_valid_lease_break(char *buffer)
> >         }
> >         spin_unlock(&cifs_tcp_ses_lock);
> >         cifs_dbg(FYI, "Can not process lease break - no lease matched\n");
> > -       return false;
> > +       return true;
> >  }
> >
> >  bool
> > @@ -755,7 +755,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
> >         }
> >         spin_unlock(&cifs_tcp_ses_lock);
> >         cifs_dbg(FYI, "Can not process oplock break for non-existent connection\n");
> > -       return false;
> > +       return true;
> >  }
> >
> >  void
> > --
> > 2.28.0
> >
>
>
> --
> Regards,
> Shyam
>
