Return-Path: <SRS0=8LXX=Y5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DA6CA9ED3
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Nov 2019 02:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF39E217F5
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Nov 2019 02:11:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kR2bkruF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbfKECLx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Nov 2019 21:11:53 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33315 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728987AbfKECLx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 4 Nov 2019 21:11:53 -0500
Received: by mail-lf1-f66.google.com with SMTP id y127so13800078lfc.0
        for <linux-cifs@vger.kernel.org>; Mon, 04 Nov 2019 18:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XYbhVELrGrA22psESrSmZoUs2rF/YOF69kpSVJ5Z3LE=;
        b=kR2bkruF1GcwXGS6Nq510PXthkzz3ZiTTmsQCZqg9Nmb6xDrifjuRhPSXdhcAuOGeh
         6+80S+GhRe1t8JJy9nEPFvzrOoi1mjhYODiBvTJKRtoFqrYasUxq0mMmkesynw/BTspX
         qGesdZBN5N4QvjCCnsvpzJM/Kxca6fx1FV8L01F42/yTZH+qAAQL+IJt4TaA+6iIJ72T
         enNamgQwa/S8iQgfvPuv7bwtfbmB+c1apte8zGVK6SSSsWmHqju2TwC9tV8iOOotNzfY
         xjnPl8sUwlj26cBwdrK0QiBl4GUDBVwvDQSzTF+uXoSvhNR1GkZ50BA7W9jh8LlvjByJ
         eOxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XYbhVELrGrA22psESrSmZoUs2rF/YOF69kpSVJ5Z3LE=;
        b=jih/xXXOG4FY86Xqjnup051wPJjk/aowUfxWo3kawJ8iIqimWvYBLeiFgGkFN95MkC
         CnU6oTBUkfFsV8DyNn8Cf7bm44m8IO8NQO3jrtFyoCecXlpFaQZJ/4aJo1fHPIgHbbpw
         DjauFnzDFQfBlAaxEkIrgvOw374RjYMquH+ZCVDgTDnCqTAKBQkdZBWhvqJpgGYZQsUb
         9Qew38nIrA6i5EfyvrSvwroE6/gY+/7FuuSAopvZe3bKXr66f/jv6dEpX5KFZ75mwSAg
         pAjQtH1vbMXwUkt0sosmd12ya9aX+0JdroBNzLgQeerreHcxzOwTMhaxRZZSRoaF2WoT
         M8pw==
X-Gm-Message-State: APjAAAVtALK/FCD1nFwcaJssOKJpE5Rp1jxauDvA/NsWUASS717rcnoi
        YE2zaI2TOf5+UZznRfubtZVQV7b3qWFjPeUpoN6AvIs=
X-Google-Smtp-Source: APXvYqwRKhHPijqxXDAC5n42BLMOY6fwNr+tySQZfXmfE7FIAIfVtVYrsCNww2vvDH5Pa41vbyTfBCcUNwGPE6Jc9mU=
X-Received: by 2002:a19:800a:: with SMTP id b10mr19045717lfd.15.1572919910994;
 Mon, 04 Nov 2019 18:11:50 -0800 (PST)
MIME-Version: 1.0
References: <20191026210419.7575-1-lsahlber@redhat.com> <ca15c743-11f0-ff36-6c66-23ad795cf293@redhat.com>
 <CAKywueQhAOjPQoF2=LPmvBASeWmixM1dr6u_8_R70CZUdMawAA@mail.gmail.com>
In-Reply-To: <CAKywueQhAOjPQoF2=LPmvBASeWmixM1dr6u_8_R70CZUdMawAA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 4 Nov 2019 18:11:39 -0800
Message-ID: <CAKywueS=cHupEvJiHbWTg1Ri4q-8t=cA-m7wF4BwVwOBFO-VAg@mail.gmail.com>
Subject: Deadlock between cifs_writev_requeue and cifs_writepages
To:     Frank Sorenson <sorenson@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 28 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 15:51, Pavel Shilo=
vsky <piastryyy@gmail.com>:
>
> =D0=BF=D0=BD, 28 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 05:13, Frank Sor=
enson <sorenson@redhat.com>:
> >
> > On 10/26/19 4:04 PM, Ronnie Sahlberg wrote:
> > > Steve, Pavel, Frank
> > >
> > > This patch moves the logic in cifsFileInfo_put() into a work-queue so=
 that
> > > it will be processed in a different thread which, importantly, does n=
ot hold
> > > any other locks.
> > >
> > > This should address the deadlock that Frank reported in the thread:
> > > Yet another hang after network disruption or smb restart -- multiple =
file writers
> >
> > Pavel,
> >
> > Thanks for understanding my report and translating it into what it mean=
t.
> >
> > Ronnie,
> > Thanks for the patch.  I'm happy to say that my attempt at the same
> > looks like it would have been similar, had I known what I was doing to
> > begin with :)
> >
> >
> > Unfortunately, I think the patch really only moves the problem from one
> > place to another.  I'm guessing that means we have a second underlying
> > deadlock.  (this reproducer appears to be quite effective)
> >
> >
> > On the plus side, only the one file involved is jammed in the deadlock
> > now, as opposed to the parent directory as well, so it is at least prog=
ress.
> >
>
> Hi Frank, Ronnie,
>
> Ok, it seems there is another bug resulting in a deadlock between a
> page lock and writeback (WB) flag in cifs_writev_complete and
> cifs_writepages.
>
> 1) cifs_writev_complete. in the case of WB_SYNC_ALL and EAGAIN
> (reconnect) it calls cifs_writev_requeue. At this point it still has
> WB flag set for all the pages being retried. Inside
> cifs_writev_requeue it tries to lock the page:
>
> kworker/4:3+cifsiod
> #0 __schedule at ffffffffab4f1a45
> #1 schedule at ffffffffab4f1ea0
> #2 io_schedule at ffffffffab4f22a2
> #3 __lock_page at ffffffffaae3f66f
> #4 cifs_writev_complete at ffffffffc07df762
> #5 process_one_work at ffffffffaacecc11
> #6 worker_thread at ffffffffaaced0f0
> #7 kthread at ffffffffaacf2ac2
> #8 ret_from_fork at ffffffffab600215
>
> 2) cifs_writepages. It locks the page and then waits on WB flag to be
> cleared before processing pages:
>
> 1 openloop.sh
> #0 __schedule at ffffffffab4f1a45
> #1 schedule at ffffffffab4f1ea0
> #2 io_schedule at ffffffffab4f22a2
> #3 wait_on_page_bit at ffffffffaae3fbc6
> #4 cifs_writepages at ffffffffc07ffc73
> #5 do_writepages at ffffffffaae4ba71
> #6 __filemap_fdatawrite_range at ffffffffaae4321b
> #7 filemap_write_and_wait at ffffffffaae432aa
> #8 cifs_flush at ffffffffc0800fe3
> #9 filp_close at ffffffffaaeed181
> #10 do_dup2 at ffffffffaaf12c0b
> #11 __x64_sys_dup2 at ffffffffaaf1306a
> #12 do_syscall_64 at ffffffffaac04345
>
> The bug is in cifs_writev_complete and cifs_writev_requeue: the 1st
> needs to clear the WB flag and re-dirty pages before trying to retry
> the IO; the 2nd needs additionally to skip pages that are no longer
> dirty (e.g. written by another thread) and re-set the WB flag before
> sending pages over the wire.
>
> --
> Best regards,
> Pavel Shilovsky

(re-titling and cc'ing Steve and Jeff to comment on this)

I looked at other file systems in the kernel. Different modules do
writepages differently, e.g. CephFS doesn't unlock pages after sending
and only does that once the IO completes. We may probably do the same:
postpone unlocking pages until we have successfully written them to
the server. In this case the retry code path (cifs_writev_requeue)
won't need to lock the pages again and thus the deadlock will be
avoided.

Thoughts?

--
Best regards,
Pavel Shilovsky
