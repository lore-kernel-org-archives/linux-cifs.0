Return-Path: <SRS0=Wa1n=VA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC5D0C0650E
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jul 2019 19:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B815F21882
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jul 2019 19:24:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="skExS2l/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfGCTY0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Jul 2019 15:24:26 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46357 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfGCTY0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Jul 2019 15:24:26 -0400
Received: by mail-pf1-f193.google.com with SMTP id 81so1730650pfy.13
        for <linux-cifs@vger.kernel.org>; Wed, 03 Jul 2019 12:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tetU2zanNPWMdo1nsLxwipNkRG3/RQfguSDGa9ustTE=;
        b=skExS2l/r7bdnvWZaPlwe+ozvG31O5ItfP0Y1MqH6CwqZfD1O5Hjrt0nJ+F6Y0zqbS
         cS0V8bmjzlvJvmQeX+ZJdEymDlpMo3UZCWtiXPPWeRo9vK4268PD2qZ8wOPpkbiZIEdn
         k8gwHFmjmdukcNpH49nlskTgnfrO6KYH8Hpg2aM3saOo4yrIf0oCri/mCrAzb8CEbNBp
         IorAa4RHp0+m0pfRbG8nEGlPQu+3O0XahprAgNo3reAktQGSVQt8Kns7fEksOgo6ybtC
         u2/kAZWjb/OWXWB3MWoN+NO6RohCJRCEiUShTGuVcYzgp2pedhZljb0HgkIiTTbCBp5S
         tbgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tetU2zanNPWMdo1nsLxwipNkRG3/RQfguSDGa9ustTE=;
        b=eWG7szS0ObtAk3J7mf2eDbi90mWMo/EqKcmHLaVBe9Zlw9MXJAXHca5qtQPAKkb7G+
         Vfgvdyn4Ubx/NyCoM6hIu3UY3Z+95cv6TDwbglOzXrXk4ASajeml0tkX5fYr5EtYcniO
         i2Qc791ghxHAOGQe/HRnhVpIvliZrCU4H6/sbwsbx34F9yLAGb8BErewd/5Ocdyit9Om
         XKScSBg/ayYc4BdTOeIcBJCR4c6ObRGutL0clJWNKnqnbyWZngMeW0B4WQs0jD9u1kMO
         f/sMYA0taEwohdsMsRSB124xnk73rAHcFShgUwNXv+eiZa4nWo2GMSNjk6pBqXaoStns
         LoUg==
X-Gm-Message-State: APjAAAWHopcU8CUBXdx8/YPZDgjBN1+uUSR8aR+47rtqeevJ1EsydkNO
        1BqQ1brkNZJJ/86N5893IS+Xc8ZFmO1DQ7jk8R7LNpeAfVE=
X-Google-Smtp-Source: APXvYqxwnrdOHmnuFcjD/j51faU66Ks1j2jAonWAKueHtChKe9QWpcw5iLer4V0QaX1zPJ02euUoK/ukzklxJqZKPCU=
X-Received: by 2002:a63:d4c:: with SMTP id 12mr39772740pgn.30.1562181865380;
 Wed, 03 Jul 2019 12:24:25 -0700 (PDT)
MIME-Version: 1.0
References: <684ed01c-cbca-2716-bc28-b0a59a0f8521@prodrive-technologies.com> <875zojx70t.fsf@suse.com>
In-Reply-To: <875zojx70t.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 3 Jul 2019 14:24:14 -0500
Message-ID: <CAH2r5mtAZeUx1MinUPhesFA9EPc1McC9jXV44jpLrmnfW1Raqw@mail.gmail.com>
Subject: Re: Many processes end up in uninterruptible sleep accessing cifs mounts
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Normally dynamic tracing is much easier and less noisy since you can
selectively turn on and off tracing with it (especially easier now
that good tutorials on how to use eBPF to make it even easier).

"trace-cmd record -e cifs"
then repro the problem
then in another process "trace-cmd show"

There are 70 events that can be individually turned on or off in
         /sys/kernel/debug/tracing/events/cifs

e.g. "trace-cmd record -e smb3_cmd_err -e smb3_enter -e smb3_exit_err"

Also can look at /proc/fs/cifs/Stats which shows how many of each
command and how many errors and if any reconnects

On Wed, Jul 3, 2019 at 2:18 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> Hi Martijn,
>
> Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com> writes:
> > One of the symptoms is that our monitoring system complains about not
> > being able to stat() every now and then, the next scraping cycle, stat(=
)
> > works again. Even when the mounts are not accesses at all.
> >
> > Also, lot of applications get stuck on either accessing data on the
> > mounts, or performing stat() like operations on the mounts.
> >
> > For us, the worst part is that applications end up in 'D'. The number o=
f
> > 'D' processes pile up really quickly, blocking users from performing
> > their work.
>
> Gah, sorry to hear. Thanks for the report.
>
> If you could pin down a specific way to reproduce some of those hangs
> that would be of great help.
>
> > We are running Linux 4.20.17 SMP PREEMPT on all machines. We tried
> > upgrading to > 5.x, but caused even more problems and kernel hangs.
>
> 5.0 and 5.1 really fixed a lot of issues with credits and reconnection.
>
> > I do not really have a clue where to start debugging. I enabled kernel
> > debug options suggested on the wiki, but the amount of logging is
> > immense now.
>
> Yes that is normal.
>
> > Can you provide any pointers where to look or start debugging?
> > Or any help on how to kill those D processes and get our Linux servers
> > stable again?
>
> Are there any kernel oops/panic with stack traces and register dumps in
> the log?
>
> You can inspect the kernel stack trace of the hung processes (to see wher=
e
> they are stuck) by printing the file /proc/<pid>/stack.
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 21284 (AG N=C3=
=BCrnberg)



--=20
Thanks,

Steve
