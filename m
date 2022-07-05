Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F7E2C43334
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Jul 2022 11:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiGEL2s (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Jul 2022 07:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiGEL2r (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Jul 2022 07:28:47 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2549013E3A
        for <linux-cifs@vger.kernel.org>; Tue,  5 Jul 2022 04:28:47 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id z16so8414700qkj.7
        for <linux-cifs@vger.kernel.org>; Tue, 05 Jul 2022 04:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WhFSlvpuk9a/0AOEzgVFi1ms8C8N0bMJmyd4ZViqQJ0=;
        b=g4+1+VKYNOr8OGfCq6WZnnBahsLWgpwqs7QO3Amdm95oTI3e38CiFuqauYoOdUi4uZ
         C85LbG0ls1AI1fqenn3E91uH8ksAXLB8j8k9mZeZn9I1mwbdY2a92rl1Wpe0M2JGF8bW
         tcff7PwuxVyqPE0th5m4MBJura9jMBhDFvL/kiE5Xoph56VGOTbRH7QLAdr6JXNLsDXT
         egVvwah3syzXqc9gbbcXpGoTn1vfgET3etsikZTNHgJ7o5O5STr1meDmQ/SUu67YSxkk
         Vczy7BOG9xJyepWsO+wur12Kg+txhtCOvscyvQvH6pdbq+7jW0HUXYJ7a2b89q3YVjNv
         2rLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WhFSlvpuk9a/0AOEzgVFi1ms8C8N0bMJmyd4ZViqQJ0=;
        b=dmYf4VjczWLyOWbBTPtNhHqpqyMbf8NRKPJj9g47/FoJA27mXcqMBVvIq+2fprwkCV
         X8T0AaM0jub4SP50/vmsenZjKFEDIL4g4LaXvljbTWjOTvhCc75C0J33LoaewiZg/+Fo
         xUGrT3Y2ayd1+iiwe7yo3mJmV77TErs3lI7i1n20ZH7pq86eXbwIIX1KOkJsuBRJ2iMp
         yTFA7l1ygxqjQ4qciZUCZxQVbMnxKVgMAYGscYZyEiWmPC6Ydg20cBqQMq6CZ+xSslAl
         rrfGpJzYH9A0MjqiG1Ltw0lv5+LppV3epoYttRztZYDI1PJmg+N4uxMmEmjGKamZAr/W
         ksGQ==
X-Gm-Message-State: AJIora9jRzbZl7moECKUnRZekt5OW5Pyn18R8rH3a935rmb9aE1Q5m7R
        wpV9zMddoWFeS+HwJm341fArAz5X5i3j6JP9cC4=
X-Google-Smtp-Source: AGRyM1v30/spfulcIMC3XqO/iDKK+fusrK1qNnmPcfNe4lFWkE/ya7OCeE56BfcVoaZC41PLotl06ubCM3ya2xpqcLU=
X-Received: by 2002:a05:620a:2943:b0:6af:f2e:b4ec with SMTP id
 n3-20020a05620a294300b006af0f2eb4ecmr22893788qkp.320.1657020526184; Tue, 05
 Jul 2022 04:28:46 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=pfEF91j3frZFJgxMLU6XmaC-pn=_oQnOF2BQPaj7Bh+Q@mail.gmail.com>
 <874k1m3b56.fsf@cjr.nz> <CANT5p=rRTWpBR6MKiXrMtH0r_PD_jKyLhUhM_Of_oev=7rybDA@mail.gmail.com>
 <CANT5p=rw=JamyDwYby1VVgMXAANMCou_aMhcw0vB48gggDWJQQ@mail.gmail.com>
 <CANT5p=q6xyaaqqNizp1HsXhLFTnwezJ267SJDqr5WwyG8KZO+g@mail.gmail.com> <CAH2r5mt6A616063ZigfPBBKFjsV5AhNG3ifk-1HQOcgwb_i0kg@mail.gmail.com>
In-Reply-To: <CAH2r5mt6A616063ZigfPBBKFjsV5AhNG3ifk-1HQOcgwb_i0kg@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 5 Jul 2022 16:58:35 +0530
Message-ID: <CANT5p=okGAJCow=+BLGTHf3BqhmHijA1FK-XNVuLNHVRVhficA@mail.gmail.com>
Subject: Re: Multichannel fixes
To:     Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jun 24, 2022 at 8:14 PM Steve French <smfrench@gmail.com> wrote:
>
> FYI - the last one includes the fix for the lock ordering problem that
> Coverity spotted.
>
> On Fri, Jun 24, 2022 at 9:43 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > On Mon, Jun 6, 2022 at 3:57 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > >
> > > On Mon, Jun 6, 2022 at 11:12 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > > >
> > > > Hi Paulo,
> > > >
> > > > Sorry for the late reply.
> > > > Good point. Tested basic DFS mounts. I was facing setup issues while
> > > > setting up DFS for failover.
> > > > Steve will be running the buildbot DFS tests anyway, which will
> > > > contain DFS failover.
> > > >
> > > > On Thu, May 19, 2022 at 12:45 AM Paulo Alcantara <pc@cjr.nz> wrote:
> > > > >
> > > > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > > >
> > > > > > This time, I've verified that it does not break the multiuser
> > > > > > scenario. :)
> > > > >
> > > > > Thanks!  What about DFS failover scenario?  :-)
> > > >
> > > >
> > > >
> > > > --
> > > > Regards,
> > > > Shyam
> > >
> > > More fixes for multichannel:
> > >
> > > [PATCH] cifs: populate empty hostnames for extra channels
> > > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/fb231a3e148e7537c899f4e145fc0dd876c2b195.patch
> > >
> > > [PATCH] cifs: change iface_list from array to sorted linked list
> > > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/94363021b50edb86813ae280526d7f33d6903703.patch
> > >
> > > [PATCH] cifs: during reconnect, update interface if necessary
> > > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/7610df44d276634a51155e6314ee159b7618013f.patch
> > >
> > > [PATCH] cifs: periodically query network interfaces from server
> > > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/7dad71410514232501f921a8c3ad389d3344fddb.patch
> > >
> > > First one is a fix for ensuring that reconnect does not resolve extra
> > > channels to possibly wrong IP address.
> > > Rest three enable periodic query of server interfaces. This is
> > > important for Azure service, where the server can change the IP
> > > addresses of secondary channels.
> > >
> > > Reviews will be appreciated.
> > >
> > > --
> > > Regards,
> > > Shyam
> >
> > Updated the last set of patches to the below set after fixing some
> > coverity warnings.
> >
> > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/37d488b3d38c04f9f4caf1fab2b58301f0c20227.patch
> > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/a21e72b2a9599482739884329523ed91cfabf8db.patch
> > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/ad8f403ac707cf326371d1361ef5880d89b9bbe6.patch
> > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/85ede3abb8348d3b9b5a2548c9773ed0fec0f157.patch
> > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/8577d17e605634f297e1be71f602c8027737fefc.patch
> >
> > --
> > Regards,
> > Shyam
>
>
>
> --
> Thanks,
>
> Steve

Hi all,

Found a race condition between the delayed workers when there's a
failure to add a channel to a session.
This was causing occasional failures on the buildbot due to a warning
being logged.

Fixed it with the below patch:
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/ff9ba549b08b8a54bd951e74dae7a1e74f8e7db6.patch

Please review the fix.

-- 
Regards,
Shyam
