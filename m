Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2F0C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Feb 2022 15:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbiBPPdm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Feb 2022 10:33:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbiBPPdm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Feb 2022 10:33:42 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BF71516B9
        for <linux-cifs@vger.kernel.org>; Wed, 16 Feb 2022 07:33:29 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id r20so3923102ljj.1
        for <linux-cifs@vger.kernel.org>; Wed, 16 Feb 2022 07:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lhddi27jZ3y3GXsDpUsLziufl3cIaLlqm+y0u/joPZI=;
        b=WHaG6J6eKhYL05E1cAJLXRfefQInBo2fg5Mw4nd/yXvG4ri4y7bWJksrj8GHldzNTi
         ykvbY3b1nS8d/tMHYewr1zVXIv7KtEeUYHlhMs26KI3ooX+D1ZUgXrBbYmy1rZBGRyC7
         Od44HfWNqyh7Zs9u1siE0gXR7oZLuplCMj3QSMdubUCL/XeM5i+bHNl4Qa69m/HD5aUT
         NHS9p5jB6mkvWIssXoQDB0X+4MxEk+ZgjCnP9reEjMeuGl4NA1tIy/BkqgQyrXMS+92Q
         ixclxm1qBn/nuRQ7M9K5raKOZ6dQcsXTxrisJnd3getiMnoA+LIhrrAOcqc8099rkTSu
         eo6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lhddi27jZ3y3GXsDpUsLziufl3cIaLlqm+y0u/joPZI=;
        b=PiTK3lWPO1JIEjvXqDCVeyLgfeXsSAfVTSIsJle6rmprEt8Ae4yfqB1cs+wh8bqI82
         FxC4toWWj3ejPV37t1CZ+UfC4yZPv5ZXU78RZfdrlBCNZKWDXDgsto+BwSvEtsGqXakG
         R7eKf/HIGEv3wPiBxOqa/Lh7p/ddtqTeTxVPEJGPpcqY7kk6MeXq3+NDXJuh+b/pl4eA
         AHZp0nt3apwTcFC5Y6+zn3pGFQiSVGQ52BDibf/1ZLx+OJGe0GG055aIYezc0tUOZVEt
         mH4z5n3UrEOGeWtLK3DZsT4d+s81AbGsRVNOOm5jqQlXKNDX4ES1x6GaOc5351ss+tKk
         0f8w==
X-Gm-Message-State: AOAM530c5P5/ws/21Tq37JHi1rJ8VAihG9ngVvof1aC43olf6lgTqg6R
        hw9mQM7EWlc4XsYNSdfxOOf+jyO8QQ/GUOKjzbV5bFGq30H6vg==
X-Google-Smtp-Source: ABdhPJxQQ6zZmYDGxSjB0W+1Zrvz76PuC+kN9oZXR1DJXf0ewLsq0KYYZwviYHOArnZ0BQ3hmP5hMnNRj8vMyjllgGo=
X-Received: by 2002:a2e:9c94:0:b0:233:82df:a3b8 with SMTP id
 x20-20020a2e9c94000000b0023382dfa3b8mr2420959lji.229.1645025607542; Wed, 16
 Feb 2022 07:33:27 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=oyS-49nAvmddV=s+VOz+TG0SG7RcTEs6f25g_2hC-rUQ@mail.gmail.com>
 <87leyckkzo.fsf@cjr.nz> <CAH2r5muC7Bg5WQf1UcWd0LaPg+NVxQ5y_nz7p19U_SvVh9qJHQ@mail.gmail.com>
 <CAH2r5msU0Bjp+CsKb4VQ5yEaPoOh6+e40hdvBOY1Hs-FUGe4iQ@mail.gmail.com>
 <CANT5p=qHHCTT0EaQDiYediXNo5ATi1j_gZGhTW6+zyC5m6zY5g@mail.gmail.com> <CAH2r5mtQZwi=f+q7YZTay4qkf46h2ppMwB6eScPXAEVK8+1nWA@mail.gmail.com>
In-Reply-To: <CAH2r5mtQZwi=f+q7YZTay4qkf46h2ppMwB6eScPXAEVK8+1nWA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 16 Feb 2022 09:33:16 -0600
Message-ID: <CAH2r5mv0Z8zSwt8FcHWYGoncNVzXv8SuVBD3UW-H7k+ObEHbsQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: use a different reconnect helper for non-cifsd threads
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

DFS reconnect tests for SMB3 and SMB3.1.1 failed with that patch

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/3/builds/192

On Tue, Feb 15, 2022 at 9:02 PM Steve French <smfrench@gmail.com> wrote:
>
> FYI - Running cifs-testing group on it now.  Will run DFS tests next
>
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/903
>
> $ git log --oneline v5.17-rc4..
> 5279203f772d (HEAD -> for-next, origin/for-next) cifs: use a different
> reconnect helper for non-cifsd threads
> 0c6f4ebf8835 cifs: modefromsids must add an ACE for authenticated users
> 3d6cc9898efd cifs: fix double free race when mount fails in cifs_get_root()
> 26d3dadebbcb cifs: do not use uninitialized data in the owner/group sid
> dd5a927e4118 cifs: fix set of group SID via NTSD xattrs
> 9405b5f8b20c smb3: fix snapshot mount option
>
> On Tue, Feb 15, 2022 at 7:51 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > Thanks for the review and update, Paulo.
> >
> > Steve, please run the DFS tests in buildbot as well.
> >
> > On Wed, 16 Feb, 2022, 06:11 Steve French, <smfrench@gmail.com> wrote:
> >>
> >> Looks like it passed multichannel buildbot tests with the patch
> >>
> >> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/11/builds/180
> >>
> >> On Tue, Feb 15, 2022 at 1:37 PM Steve French <smfrench@gmail.com> wrote:
> >> >
> >> > Updated and tentatively merged into cifs-2.6.git for-next and added acked-by
> >> >
> >> > Shyam,
> >> > Let me know if any additional changes you see or feedback.
> >> >
> >> > On Tue, Feb 15, 2022 at 1:06 PM Paulo Alcantara <pc@cjr.nz> wrote:
> >> > >
> >> > > Hi Shyam,
> >> > >
> >> > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> >> > >
> >> > > > My patch last week was not sufficient to fix some of the buildbot
> >> > > > failures we saw recently.
> >> > > > Please review and use the following patch for new buildbot runs.
> >> > > >
> >> > > > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/2b599dec7c9399b66b56419fcb252ab37de94e3b.patch
> >> > >
> >> > > Patch looks good, however you missed these:
> >> > >
> >> > > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> > > index 053cb449eb16..2e00cd58a8b5 100644
> >> > > --- a/fs/cifs/connect.c
> >> > > +++ b/fs/cifs/connect.c
> >> > > @@ -4416,7 +4416,7 @@ static int tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *tco
> >> > >          */
> >> > >         if (rc && server->current_fullpath != server->origin_fullpath) {
> >> > >                 server->current_fullpath = server->origin_fullpath;
> >> > > -               cifs_reconnect(tcon->ses->server, true);
> >> > > +               cifs_signal_cifsd_for_reconnect(server, true);
> >> > >         }
> >> > >
> >> > >         dfs_cache_free_tgts(tl);
> >> > > diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> >> > > index ebe236b9d9f5..235aa1b395eb 100644
> >> > > --- a/fs/cifs/netmisc.c
> >> > > +++ b/fs/cifs/netmisc.c
> >> > > @@ -896,7 +896,7 @@ map_and_check_smb_error(struct mid_q_entry *mid, bool logErr)
> >> > >                 if (class == ERRSRV && code == ERRbaduid) {
> >> > >                         cifs_dbg(FYI, "Server returned 0x%x, reconnecting session...\n",
> >> > >                                 code);
> >> > > -                       cifs_reconnect(mid->server, false);
> >> > > +                       cifs_signal_cifsd_for_reconnect(mid->server, false);
> >> > >                 }
> >> > >         }
> >> > >
> >> > > With that, feel free to add:
> >> > >
> >> > > Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> >> >
> >> >
> >> >
> >> > --
> >> > Thanks,
> >> >
> >> > Steve
> >>
> >>
> >>
> >> --
> >> Thanks,
> >>
> >> Steve
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
