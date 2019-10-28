Return-Path: <SRS0=uI0J=YV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC66CA9EC0
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Oct 2019 22:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35DDD21479
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Oct 2019 22:52:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YsPwTLkC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbfJ1WwH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Oct 2019 18:52:07 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43849 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJ1WwH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Oct 2019 18:52:07 -0400
Received: by mail-lf1-f68.google.com with SMTP id j5so2683240lfh.10
        for <linux-cifs@vger.kernel.org>; Mon, 28 Oct 2019 15:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2D9UvgzO0SOv4NOWC35xK0MEf3H9gkR9jqoxpLM6W4E=;
        b=YsPwTLkCc7rpt0BMYn5yqt062gd+6bbhjwIMn8BBY5lt1AJsOeuFLeFeegzfCRU6IJ
         vhZPMsH8DxrmLgU1HK5/LR6uiiRdDtbZFzNpIgVnrNoETQFjMzOYCjBg97uqZ4OuElMq
         JDudSJj0EOtAogjRJmlGxIhrSe3kgjaDQnorhK19XDYNEMyU3xKVusd6+sEqM9frkNrU
         TS3JaUoVmjmCm7ZC7H2Qa3rH/99x2Egl2u2tVOFentsIgdvl+6qVxQZiX0oGTt0dm09b
         1A43SHvqb4lo4F7NjFRfkqYfxsdeiQv8vxcd0aPKK9G+TGndOsvCN5nx8iaDLNpAmMUF
         zWbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2D9UvgzO0SOv4NOWC35xK0MEf3H9gkR9jqoxpLM6W4E=;
        b=ogTFlmipHmWg5ZsxYUwPdSb4zLsOsye596fYc09VqTdYtEFs0uEeuz7vMQyh8HIhTF
         QMLz2op4l+Di8g6SGiVGBwWC08CQLX1w2Jcnruz7lEJcdcfvN7OOd0Ev/mOHoV/7U3C/
         lHnXVc2hRWRKNYxbNFTIp6A6tqZtZ3bfNqP9b5Ob3hDbZGHF6wdvQULQZG6At2uCHHBb
         Qz/yAWqyX96m83BKkKIRRmgVa63VXjBHTJTzBXaymDZHCdRevqOK757p4rMIo0PSsFxc
         By3gnnXuJq8IDmB6PmjMG1zMr9+N30sgj+30wOfgfeUWnbdnBWIz9BWtEyWqMvMu5qGq
         f0Fw==
X-Gm-Message-State: APjAAAVp7ozdSGtXX2SKb+oJcHgbfedwOCaE9k45RE0DSwwNrv7EwJya
        2msHYbEIOXAw1JPY/4ZZvYml3bq3C1jK+PohhA==
X-Google-Smtp-Source: APXvYqzf/B6XHWqQ5VRvVDWG1wdfMi6/AapvcT+aNa3Jd0rRFANzxON7ekSk8N3XPsikWjLI1IZIZWXc/HupVqyL1KM=
X-Received: by 2002:ac2:5144:: with SMTP id q4mr182307lfd.36.1572303125715;
 Mon, 28 Oct 2019 15:52:05 -0700 (PDT)
MIME-Version: 1.0
References: <20191026210419.7575-1-lsahlber@redhat.com> <ca15c743-11f0-ff36-6c66-23ad795cf293@redhat.com>
In-Reply-To: <ca15c743-11f0-ff36-6c66-23ad795cf293@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 28 Oct 2019 15:51:54 -0700
Message-ID: <CAKywueQhAOjPQoF2=LPmvBASeWmixM1dr6u_8_R70CZUdMawAA@mail.gmail.com>
Subject: Re: [PATCH 0/1] cifs: move cifsFileInfo_put logic into a work-queue
To:     Frank Sorenson <sorenson@redhat.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 28 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 05:13, Frank Soren=
son <sorenson@redhat.com>:
>
> On 10/26/19 4:04 PM, Ronnie Sahlberg wrote:
> > Steve, Pavel, Frank
> >
> > This patch moves the logic in cifsFileInfo_put() into a work-queue so t=
hat
> > it will be processed in a different thread which, importantly, does not=
 hold
> > any other locks.
> >
> > This should address the deadlock that Frank reported in the thread:
> > Yet another hang after network disruption or smb restart -- multiple fi=
le writers
>
> Pavel,
>
> Thanks for understanding my report and translating it into what it meant.
>
> Ronnie,
> Thanks for the patch.  I'm happy to say that my attempt at the same
> looks like it would have been similar, had I known what I was doing to
> begin with :)
>
>
> Unfortunately, I think the patch really only moves the problem from one
> place to another.  I'm guessing that means we have a second underlying
> deadlock.  (this reproducer appears to be quite effective)
>
>
> On the plus side, only the one file involved is jammed in the deadlock
> now, as opposed to the parent directory as well, so it is at least progre=
ss.
>

Hi Frank, Ronnie,

Ok, it seems there is another bug resulting in a deadlock between a
page lock and writeback (WB) flag in cifs_writev_complete and
cifs_writepages.

1) cifs_writev_complete. in the case of WB_SYNC_ALL and EAGAIN
(reconnect) it calls cifs_writev_requeue. At this point it still has
WB flag set for all the pages being retried. Inside
cifs_writev_requeue it tries to lock the page:

kworker/4:3+cifsiod
#0 __schedule at ffffffffab4f1a45
#1 schedule at ffffffffab4f1ea0
#2 io_schedule at ffffffffab4f22a2
#3 __lock_page at ffffffffaae3f66f
#4 cifs_writev_complete at ffffffffc07df762
#5 process_one_work at ffffffffaacecc11
#6 worker_thread at ffffffffaaced0f0
#7 kthread at ffffffffaacf2ac2
#8 ret_from_fork at ffffffffab600215

2) cifs_writepages. It locks the page and then waits on WB flag to be
cleared before processing pages:

1 openloop.sh
#0 __schedule at ffffffffab4f1a45
#1 schedule at ffffffffab4f1ea0
#2 io_schedule at ffffffffab4f22a2
#3 wait_on_page_bit at ffffffffaae3fbc6
#4 cifs_writepages at ffffffffc07ffc73
#5 do_writepages at ffffffffaae4ba71
#6 __filemap_fdatawrite_range at ffffffffaae4321b
#7 filemap_write_and_wait at ffffffffaae432aa
#8 cifs_flush at ffffffffc0800fe3
#9 filp_close at ffffffffaaeed181
#10 do_dup2 at ffffffffaaf12c0b
#11 __x64_sys_dup2 at ffffffffaaf1306a
#12 do_syscall_64 at ffffffffaac04345

The bug is in cifs_writev_complete and cifs_writev_requeue: the 1st
needs to clear the WB flag and re-dirty pages before trying to retry
the IO; the 2nd needs additionally to skip pages that are no longer
dirty (e.g. written by another thread) and re-set the WB flag before
sending pages over the wire.

--
Best regards,
Pavel Shilovsky
