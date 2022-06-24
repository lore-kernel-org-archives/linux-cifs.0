Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 553BACCA473
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Jun 2022 14:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbiFXOt0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Jun 2022 10:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233789AbiFXOs5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Jun 2022 10:48:57 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D28E81505
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jun 2022 07:44:30 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id 8so1316446vkg.10
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jun 2022 07:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8It37Erljbkfwzk63v6gSpA74hW3MTF6bVXBLb30ssI=;
        b=YXmseG07XguJRMxD2cinpEtm9SD9BWUQPMvhWYmbBSXUKCPYKsZGwV5D/ItMEUasRD
         Q4pwEWRkZDtrLYwjPmvpXOleM4zO6oFA4uZOzqoYrPdZvkIJaT3EBSNuyJaVoEpFIIS8
         BGQyvEy5bhgV3aV26FPs55kQEEj8mRW+0l6II+qf1RdLLPOy0Kz0CILV4huk14BGFykh
         +eXJfOllUH2cS+we+BJdc7cz05r2xup2FUtiLqe/xVJDVeBT2eW2vJs6ysT6x8Ov4pm8
         LDKB41x/bvquar5ZVn1qSNOakzYujzt/kIsO8jKOuG8H67y0zYJ6Cz8O8Z4vPns35Yu+
         dg6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8It37Erljbkfwzk63v6gSpA74hW3MTF6bVXBLb30ssI=;
        b=YMKDduxUTOAIkdyIvW0Wy5Gvfi+UsqlbAZP0mUwnuMjaJARfaAaqW2aUdNw6oY//dZ
         NFIWZkY7GcX+tPLAVfI/ZPaftFafYlGd2EZbykpAkWhN2amLnJRaD0BQodDG5eQGhkRU
         CQdZIUAimu/QO2OJNYhpRHlBsNYZGUPxMEv12Fz8ihIyrT5SkOzN2HIpLIHGEicLnZnT
         5rM+x4h1qRnZoQxUXGlLFHU4K8wsJG3tY7LDwGWFV9K1Ac9rGr5aIo0e+0+prmfJwgjl
         PHCetp41Ni4stLbQWl9p61meU6niBcxkN1oVgUZMv+7pvTfAxKXlGoxK7SrKvVwCtl/I
         +UVg==
X-Gm-Message-State: AJIora+iOB8P4yohKYNJ22kHFbrfjPomo6zd52xxQ9a5PpHFeZbMeOMg
        6Od4cEh0e7WLGHSd86htyLeLTRVXCjJK/MFeQhU=
X-Google-Smtp-Source: AGRyM1tL8+GiikUjrBJ1YnDfcb6HqnviXqt48WKYKrikbsAGmWjVGlCh9W3UJ+0wUW++Vr6HqWMcIEvWpDrnOPsSwao=
X-Received: by 2002:ac5:cbc8:0:b0:36b:f534:eca2 with SMTP id
 h8-20020ac5cbc8000000b0036bf534eca2mr14931731vkn.38.1656081861540; Fri, 24
 Jun 2022 07:44:21 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=pfEF91j3frZFJgxMLU6XmaC-pn=_oQnOF2BQPaj7Bh+Q@mail.gmail.com>
 <874k1m3b56.fsf@cjr.nz> <CANT5p=rRTWpBR6MKiXrMtH0r_PD_jKyLhUhM_Of_oev=7rybDA@mail.gmail.com>
 <CANT5p=rw=JamyDwYby1VVgMXAANMCou_aMhcw0vB48gggDWJQQ@mail.gmail.com> <CANT5p=q6xyaaqqNizp1HsXhLFTnwezJ267SJDqr5WwyG8KZO+g@mail.gmail.com>
In-Reply-To: <CANT5p=q6xyaaqqNizp1HsXhLFTnwezJ267SJDqr5WwyG8KZO+g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 24 Jun 2022 09:44:10 -0500
Message-ID: <CAH2r5mt6A616063ZigfPBBKFjsV5AhNG3ifk-1HQOcgwb_i0kg@mail.gmail.com>
Subject: Re: Multichannel fixes
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

FYI - the last one includes the fix for the lock ordering problem that
Coverity spotted.

On Fri, Jun 24, 2022 at 9:43 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Mon, Jun 6, 2022 at 3:57 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > On Mon, Jun 6, 2022 at 11:12 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > >
> > > Hi Paulo,
> > >
> > > Sorry for the late reply.
> > > Good point. Tested basic DFS mounts. I was facing setup issues while
> > > setting up DFS for failover.
> > > Steve will be running the buildbot DFS tests anyway, which will
> > > contain DFS failover.
> > >
> > > On Thu, May 19, 2022 at 12:45 AM Paulo Alcantara <pc@cjr.nz> wrote:
> > > >
> > > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > >
> > > > > This time, I've verified that it does not break the multiuser
> > > > > scenario. :)
> > > >
> > > > Thanks!  What about DFS failover scenario?  :-)
> > >
> > >
> > >
> > > --
> > > Regards,
> > > Shyam
> >
> > More fixes for multichannel:
> >
> > [PATCH] cifs: populate empty hostnames for extra channels
> > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/fb231a3e148e7537c899f4e145fc0dd876c2b195.patch
> >
> > [PATCH] cifs: change iface_list from array to sorted linked list
> > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/94363021b50edb86813ae280526d7f33d6903703.patch
> >
> > [PATCH] cifs: during reconnect, update interface if necessary
> > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/7610df44d276634a51155e6314ee159b7618013f.patch
> >
> > [PATCH] cifs: periodically query network interfaces from server
> > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/7dad71410514232501f921a8c3ad389d3344fddb.patch
> >
> > First one is a fix for ensuring that reconnect does not resolve extra
> > channels to possibly wrong IP address.
> > Rest three enable periodic query of server interfaces. This is
> > important for Azure service, where the server can change the IP
> > addresses of secondary channels.
> >
> > Reviews will be appreciated.
> >
> > --
> > Regards,
> > Shyam
>
> Updated the last set of patches to the below set after fixing some
> coverity warnings.
>
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/37d488b3d38c04f9f4caf1fab2b58301f0c20227.patch
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/a21e72b2a9599482739884329523ed91cfabf8db.patch
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/ad8f403ac707cf326371d1361ef5880d89b9bbe6.patch
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/85ede3abb8348d3b9b5a2548c9773ed0fec0f157.patch
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/8577d17e605634f297e1be71f602c8027737fefc.patch
>
> --
> Regards,
> Shyam



-- 
Thanks,

Steve
