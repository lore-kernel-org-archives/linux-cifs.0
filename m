Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BCBAC7618D
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Apr 2023 18:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240241AbjDFSiw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Apr 2023 14:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240240AbjDFSiv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Apr 2023 14:38:51 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC996A47
        for <linux-cifs@vger.kernel.org>; Thu,  6 Apr 2023 11:38:50 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id g18so3618572ejj.5
        for <linux-cifs@vger.kernel.org>; Thu, 06 Apr 2023 11:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680806329; x=1683398329;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+v8TvavxDbX9fWI/W0PYQhtQ0lJjBm1BFz3M6bjs3kc=;
        b=jTR3qDK5itl1Y8iiMQEes2HByZ3L/eo1mXgycBqoKuxtlSJFpz+56o92rc56KPXDmw
         Q9f+afIiY8NDqVEL512py1vyE8EaZw04KUjcQ1mv1EwNimAoWbMldC8XZfuIYllGE6VE
         X3fvOQAGMgqHNieSBe6aXRBa7pkOslMRHSF60IWCLRw5DYIcdVjC+Xxrx37ELvUFNpMI
         nBMZQDrDgnYQoB8NbPgUKGE9Xa6hEAH6uMvYmbrVasBAE+B4vmCtTO++1+wCfmYXZizj
         T7GXtzT2hyPdMxf0N7yRaG1NZm3E2jIDt6fIrt1N3NF3mYwSa4gHLaMXkvRLHPc/j6WB
         m5eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680806329; x=1683398329;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+v8TvavxDbX9fWI/W0PYQhtQ0lJjBm1BFz3M6bjs3kc=;
        b=Kr5pGhMOdFRebUHtVhB0kW5FJjHbva7Z110Wb0JodopFLFB9BsYNRDKcboy+wnlyn8
         7PWZn5exIIUxAJVPNLBXS4PBi8q6MYcng4Iiy/azQZpAwH3Dy4ikfKiqnbLhutix/31Q
         OEpaEPcsqXeH5GKwHiQ7NFGqpOcTTr5t4Kiojx01cmx6iuMN1euWg6sUlsp7u3ZCIpNv
         4AghP7bSuCPqF1f+1NPQNIf/T0agRjMFKqq5lPf3+oWot0EisIKv/vF1nprqmQF9b2Xh
         O+BIOk4oaUfhrX/eFuMAp8QwPomE+3CdrKC4jGCV5Jy8uJKHGZGCS+Qr/VpberSEdvvL
         +15A==
X-Gm-Message-State: AAQBX9eZ4Bbz3ZkkWvAg3l5zYJOklqSRXgXjG//Rnnuxq4dFqn7b6zfj
        5LPONAGaH1h6Idhom+49RiTOATcUGK+KVP3ACmkoGoZF
X-Google-Smtp-Source: AKy350avMeFjCw2VOBggdvF1Xxr9xGc0lAu1U8B90WIPALPzIhQaFWyasQ0xv9SMDSpR5iA3gqp2q+iAKsR19SG+2Pk=
X-Received: by 2002:a17:907:6d0e:b0:8b1:38d6:9853 with SMTP id
 sa14-20020a1709076d0e00b008b138d69853mr3759879ejc.2.1680806328835; Thu, 06
 Apr 2023 11:38:48 -0700 (PDT)
MIME-Version: 1.0
References: <6cf163fe-a974-68ab-0edc-11ebc54314ef@redhat.com> <7c7f01ba-66d0-c33b-21a5-800666bd97a1@talpey.com>
In-Reply-To: <7c7f01ba-66d0-c33b-21a5-800666bd97a1@talpey.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 7 Apr 2023 04:38:36 +1000
Message-ID: <CAN05THSQgfmL9LfifEw4rxwcyfBUWoZ4pY3RWMWWYmGGq3+N8g@mail.gmail.com>
Subject: Re: [PATCH] cifs: reinstate original behavior again for forceuid/forcegid
To:     Tom Talpey <tom@talpey.com>
Cc:     Takayuki Nagata <tnagata@redhat.com>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, sprasad@microsoft.com, pc@cjr.nz,
        samba-technical@lists.samba.org, lsahlber@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yeah, an oversight.
Acked-by me

On Fri, 7 Apr 2023 at 00:32, Tom Talpey via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> On 4/6/2023 8:02 AM, Takayuki Nagata wrote:
> > forceuid/forcegid should be enabled by default when uid=/gid= options are
> > specified, but commit 24e0a1eff9e2 ("cifs: switch to new mount api")
> > changed the behavior. This patch reinstates original behavior to overriding
> > uid/gid with specified uid/gid.
> >
> > Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
>
> This looks correct, but I'd love to hear Ronnie's call. Looking at
> that commit, was it simply an oversight to set override_{uid,gid}?
> It kind of looks that way, but...
>
> Tom.
>
> > Signed-off-by: Takayuki Nagata <tnagata@redhat.com>
> > ---
> >   fs/cifs/fs_context.c | 2 ++
> >   1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> > index ace11a1a7c8a..6f7c5ca3764f 100644
> > --- a/fs/cifs/fs_context.c
> > +++ b/fs/cifs/fs_context.c
> > @@ -972,6 +972,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
> >                       goto cifs_parse_mount_err;
> >               ctx->linux_uid = uid;
> >               ctx->uid_specified = true;
> > +             ctx->override_uid = 1;
> >               break;
> >       case Opt_cruid:
> >               uid = make_kuid(current_user_ns(), result.uint_32);
> > @@ -1000,6 +1001,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
> >                       goto cifs_parse_mount_err;
> >               ctx->linux_gid = gid;
> >               ctx->gid_specified = true;
> > +             ctx->override_gid = 1;
> >               break;
> >       case Opt_port:
> >               ctx->port = result.uint_32;
>
