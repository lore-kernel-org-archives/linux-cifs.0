Return-Path: <SRS0=AEBP=RP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9918C43381
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Mar 2019 07:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 794AE214AE
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Mar 2019 07:19:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PeNb0ieH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbfCLHTF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Mar 2019 03:19:05 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:41037 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbfCLHTE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Mar 2019 03:19:04 -0400
Received: by mail-pg1-f169.google.com with SMTP id k11so1127490pgb.8
        for <linux-cifs@vger.kernel.org>; Tue, 12 Mar 2019 00:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E194djfSeNGQ1IriNNGqAI6WXK3WCSiYKEhCwQyt1Rc=;
        b=PeNb0ieHi1iVrsReKAtobZbYXmxbM4bKzISRBuzdznXkTypVkifzsQGUYEQfVftJuZ
         viSP/TEzdipCZ76miqgFmcP3SImfFknW0zlwN4zefJuzmZrRgzZ98NMrD40gdxLCnDbu
         4yXwTLqwCm7+KFg5QoT+9166I/ofnFvOfQPMhXNhM08TSAZb5B0UZlGDBfCur8fnxOfD
         ESXNwz6sjkqIN+bPBZ7Zpz/mR7SCqxdgPsjNi4JNQf4isf5Q//uluEXLnXIeyP+K+yq6
         6vFodsI6FwHyi43ULafmW38XipYemCQR+wxKReQ4dbOUwu/0aSfcyYv/hCU+eZ7igjL2
         rXVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E194djfSeNGQ1IriNNGqAI6WXK3WCSiYKEhCwQyt1Rc=;
        b=aqCpTRLvqASQa0Tv5L87AMvmbt5pfjEA7t8eA25bz9df8B0QD5YcWSt6JMPRsr74+K
         yfEm7dYyAMr3Aod6ovRixm67CEtmSotjJ2jAUQ8FNCtuNKqu6qwq3MHqmh7S3U+kZ2GU
         eludbnmjVfQe6adRV0Pov/3uoMmLlQZsADDb4oQMgc1Czpd3hxsvmZPjFiwIqmGhNeZa
         4299TNkk9mrKQsYa55ykqdGeEpSyS3NtefpwL/5x0xp24d7stb97d6Ly5AmMu5X4kahs
         xuZCrIYFr6hYCOMOfLl70a+GY3i2GB6Plkyhj5yseFhwqBoxy67SfxLsyQIMUaH8IEr8
         yOmg==
X-Gm-Message-State: APjAAAU2byrE3MXom/P9S/MCFfmAwX3WbJldrjAduYAeYBOcnVr0HARr
        zxJAthKVjdqHrEv7TvjWDQlBmTB2SS76jeNqZZk=
X-Google-Smtp-Source: APXvYqy/qJHs7IrsK5WlulbLdAxbmg1S7fYFmzC6FMRqBhcEFLeoa23N9e8yaboaKPfgwKTLMHQe0bOfN+TyF8pFy/k=
X-Received: by 2002:a62:ac10:: with SMTP id v16mr38496227pfe.111.1552375143030;
 Tue, 12 Mar 2019 00:19:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muY3xgVW03Mi8N-c4wyZFikzTeZgLDEuGLoXFXNZ-wFHA@mail.gmail.com>
 <CAKywueR9-_yYVA4YfycxfH_jog0xQKhgoQeFG6nhLws4TLC8Tg@mail.gmail.com>
 <CAH2r5mv+6N=p183kFpYnFGo7ixcu1TkCjBvWnct=1M91kH3_WA@mail.gmail.com>
 <CAH2r5mv2Cp8YseCF1rz0dH8tvPYZ1+dCykupzVv_S81f2gPMJg@mail.gmail.com> <CAN05THQt3se9xsbhKOsA4ZxhuZpe_SnkTAisTP0AnpKsb-jfOQ@mail.gmail.com>
In-Reply-To: <CAN05THQt3se9xsbhKOsA4ZxhuZpe_SnkTAisTP0AnpKsb-jfOQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 12 Mar 2019 02:18:51 -0500
Message-ID: <CAH2r5mvVA6Ov2sL-crNgeT91MeLeAZTJtNW6dZSnhh=ATzvjTQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Add various dynamic tracepoints for compounded operations
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The general feeling I am getting from tracing the compounding is that
we have to have the more granular tracing available
(similar to this patch), and also (with followon patch) add noisier
optional trace points lower down (that are generic) that we turn on
less frequently (in particular when the filename is not good enough
and we must have the xid - even if it makes the trace very noisy)


On Tue, Mar 12, 2019 at 1:06 AM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> Hmm.
>
> I don't think this is the wrong layer to add the tracing.
> Instead of adding the tracing in say smb2_compound_op(), where we
> create the compound,
> I think it will be better to add the tracing down in the leaf
> functions, i.e. down in SMB2_open_init(), SMB2_query_info_init(), ...
>
> That way we know that we will always have tracing for all opens/closes/..=
.
>
> But then what to do about the trace_smb3_..._err()/trace_smb3_..._done() =
calls ?
> These I think should be moved down and handled inside compound_send_recv(=
).
> That way we can have one single place where we call the appropriate
> _err()/_done() functions
> and we know that we will catch every single completed function.
>
> I.e. just put it in a single place instead of in every single call-site.
> In compound_send_recv we can just loop over all the responses, cast it
> to a smb2_hdr structure, looka at both the command code as well as the
> status code and call the appropriate xys_err() or xyz_done() functions
> as needed.
>
> Let me show an example of what I mean for a open/query/close compound :
>
> trace_smb3_open_enter(xid=3D5, filename=3D"foo", ...)   from SMB2_open_in=
it()
> trace_smb3_query_info_enter(xid=3D5,... ) from SMB2_query_info_init()
> trace_smb3_close_enter(xid=3D5, ...) from SMB2_close_init()
> (maybe have additional tracing in compound_send_recv() that we are
> about to send xid=3D5 to the wire)
> trace_smb3_open_done(xid=3D5, ...) from compound_send_recv()
> trace_smb3_query_info_done(xid=3D5, ...) from compound_send_recv()
> trace_smb3_close_done(xid=3D5, ...) from compound_send_recv()
>
>
> Now, we would not be able to immediately see the actual filename
> anywhere else than in the initial trace_smb3_open_enter() since we no
> longer have that available at the callsites that I suggest but do we
> actually need that?
> We can search on xid  and match it all up.
> Worst comes to it we could write a simple small tool that would
> post-process the tracefile and add in these decorations. I.e. track
> the xid numbers and the filename=3D"foo" from the open_enter()
> tracepoint and just inject them in all other tracepoints
> where xid=3D5.
> It would even have the benefit in that the log messages themselves
> would become smaller since they would no longer need to contain the
> filename for every single tracepoint.
> Smaller is better :-)
>
> That post-processing tool could also much around in /proc/fs/cifs  and
> replace the decorations for ses->Suid, tcon->tid witht he actuall name
> for the server and the share.
>
>
> Just adding the _done()/_err() tracing to compound_send_recv() and we
> will get tracing for every command completion today and in the future.
>
>
>
>
>
> On Tue, Mar 12, 2019 at 3:35 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Version 2 of the patch attached.   Here is sample output from running i=
t:
> >
> > # entries-in-buffer/entries-written: 32/32   #P:8
> > #
> > #                              _-----=3D> irqs-off
> > #                             / _----=3D> need-resched
> > #                            | / _---=3D> hardirq/softirq
> > #                            || / _--=3D> preempt-depth
> > #                            ||| /     delay
> > #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> > #              | |       |   ||||       |         |
> >            mkdir-31324 [001] .... 362773.434903:
> > smb3_query_info_compound_enter: xid=3D7 sid=3D0xdd73f8cb tid=3D0x65257d=
36
> > path=3D\newdir
> >            mkdir-31324 [002] .... 362773.435588:
> > smb3_query_info_compound_err: xid=3D7 sid=3D0xdd73f8cb tid=3D0x65257d36
> > path=3D\newdir rc=3D-2
> >            mkdir-31324 [002] .... 362773.435607: smb3_mkdir_enter:
> > xid=3D8 sid=3D0xdd73f8cb tid=3D0x65257d36 path=3D\newdir
> >            mkdir-31324 [002] .... 362773.436643: smb3_mkdir_done:
> > xid=3D8 sid=3D0xdd73f8cb tid=3D0x65257d36 path=3D\newdir
> >            mkdir-31324 [002] .... 362773.436659:
> > smb3_query_info_compound_enter: xid=3D8 sid=3D0xdd73f8cb tid=3D0x65257d=
36
> > path=3D\newdir
> >            mkdir-31324 [002] .... 362773.437414:
> > smb3_query_info_compound_done: xid=3D8 sid=3D0xdd73f8cb tid=3D0x65257d3=
6
> > path=3D\newdir
> >            mkdir-31326 [006] .... 362775.812007:
> > smb3_query_info_compound_enter: xid=3D9 sid=3D0xdd73f8cb tid=3D0x65257d=
36
> > path=3D\newdir
> >            mkdir-31326 [006] .... 362775.812796:
> > smb3_query_info_compound_done: xid=3D9 sid=3D0xdd73f8cb tid=3D0x65257d3=
6
> > path=3D\newdir
> >            rmdir-31327 [003] .... 362781.753333:
> > smb3_query_info_compound_enter: xid=3D10 sid=3D0xdd73f8cb tid=3D0x65257=
d36
> > path=3D\newdir
> >            rmdir-31327 [003] .... 362781.754057:
> > smb3_query_info_compound_done: xid=3D10 sid=3D0xdd73f8cb tid=3D0x65257d=
36
> > path=3D\newdir
> >            rmdir-31327 [003] .... 362781.754080: smb3_rmdir_enter:
> > xid=3D11 sid=3D0xdd73f8cb tid=3D0x65257d36 path=3D\newdir
> >            rmdir-31327 [003] .... 362781.755143: smb3_rmdir_done:
> > xid=3D11 sid=3D0xdd73f8cb tid=3D0x65257d36 path=3D\newdir
> >            touch-31328 [006] .... 362793.339620:
> > smb3_set_info_compound_enter: xid=3D13 sid=3D0xdd73f8cb tid=3D0x65257d3=
6
> > path=3D\newfile
> >            touch-31328 [006] .... 362793.340342:
> > smb3_set_info_compound_done: xid=3D13 sid=3D0xdd73f8cb tid=3D0x65257d36
> > path=3D\newfile
> >               ln-31329 [002] .... 362800.848959:
> > smb3_query_info_compound_enter: xid=3D15 sid=3D0xdd73f8cb tid=3D0x65257=
d36
> > path=3D\linknewfile
> >               ln-31329 [002] .... 362800.849624:
> > smb3_query_info_compound_err: xid=3D15 sid=3D0xdd73f8cb tid=3D0x65257d3=
6
> > path=3D\linknewfile rc=3D-2
> >               ln-31329 [002] .... 362800.849656:
> > smb3_query_info_compound_enter: xid=3D16 sid=3D0xdd73f8cb tid=3D0x65257=
d36
> > path=3D\newfile
> >               ln-31329 [003] .... 362800.850318:
> > smb3_query_info_compound_done: xid=3D16 sid=3D0xdd73f8cb tid=3D0x65257d=
36
> > path=3D\newfile
> >               ln-31329 [003] .... 362800.850370:
> > smb3_query_info_compound_enter: xid=3D17 sid=3D0xdd73f8cb tid=3D0x65257=
d36
> > path=3D\linknewfile
> >               ln-31329 [003] .... 362800.850918:
> > smb3_query_info_compound_err: xid=3D17 sid=3D0xdd73f8cb tid=3D0x65257d3=
6
> > path=3D\linknewfile rc=3D-2
> >               ln-31329 [003] .... 362800.850940: smb3_hardlink_enter:
> > xid=3D18 sid=3D0xdd73f8cb tid=3D0x65257d36 path=3D\newfile
> >               ln-31329 [003] .... 362800.851669: smb3_hardlink_done:
> > xid=3D18 sid=3D0xdd73f8cb tid=3D0x65257d36 path=3D\newfile
> >            gmain-2225  [004] .... 362800.851847:
> > smb3_query_info_compound_enter: xid=3D19 sid=3D0xdd73f8cb tid=3D0x65257=
d36
> > path=3D\linknewfile
> >            gmain-2225  [005] .... 362800.852345:
> > smb3_query_info_compound_done: xid=3D19 sid=3D0xdd73f8cb tid=3D0x65257d=
36
> > path=3D\linknewfile
> >               rm-31330 [003] .... 362806.483029:
> > smb3_query_info_compound_enter: xid=3D20 sid=3D0xdd73f8cb tid=3D0x65257=
d36
> > path=3D\badfile
> >               rm-31330 [003] .... 362806.483654:
> > smb3_query_info_compound_err: xid=3D20 sid=3D0xdd73f8cb tid=3D0x65257d3=
6
> > path=3D\badfile rc=3D-2
> >               rm-31330 [003] .... 362806.483704:
> > smb3_query_info_compound_enter: xid=3D21 sid=3D0xdd73f8cb tid=3D0x65257=
d36
> > path=3D\badfile
> >               rm-31330 [003] .... 362806.484296:
> > smb3_query_info_compound_err: xid=3D21 sid=3D0xdd73f8cb tid=3D0x65257d3=
6
> > path=3D\badfile rc=3D-2
> >               rm-31335 [004] .... 362811.895827:
> > smb3_query_info_compound_enter: xid=3D22 sid=3D0xdd73f8cb tid=3D0x65257=
d36
> > path=3D\newfile
> >               rm-31335 [005] .... 362811.896533:
> > smb3_query_info_compound_done: xid=3D22 sid=3D0xdd73f8cb tid=3D0x65257d=
36
> > path=3D\newfile
> >               rm-31335 [005] .... 362811.896575: smb3_delete_enter:
> > xid=3D23 sid=3D0xdd73f8cb tid=3D0x65257d36 path=3D\newfile
> >               rm-31335 [005] .... 362811.897364: smb3_delete_done:
> > xid=3D23 sid=3D0xdd73f8cb tid=3D0x65257d36 path=3D\newfile
> >
> > On Mon, Mar 11, 2019 at 5:31 PM Steve French <smfrench@gmail.com> wrote=
:
> > >
> > > On Mon, Mar 11, 2019 at 5:18 PM Pavel Shilovsky <piastryyy@gmail.com>=
 wrote:
> > > >
> > > > =D0=BF=D0=BD, 11 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 14:25, Ste=
ve French <smfrench@gmail.com>:
> > > > >
> > > > > Sample output from tracing various newly added dynamic trace poin=
ts
> > > > > (with this patch)
> > > > >
> > > > > (trace-cmd  record -e *query_info_co* -e smb3_hardlink* -e
> > > > > smb3_rename* -e smb3_set_eof* -e smb3_set_info_co* -e smb3_mkdir*=
 -e
> > > > > smb3_delete*)
> > > > >
> > > > > # entries-in-buffer/entries-written: 44/44   #P:8
> > > > > #
> > > > > #                              _-----=3D> irqs-off
> > > > > #                             / _----=3D> need-resched
> > > > > #                            | / _---=3D> hardirq/softirq
> > > > > #                            || / _--=3D> preempt-depth
> > > > > #                            ||| /     delay
> > > > > #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> > > > > #              | |       |   ||||       |         |
> > > > >      gvfsd-trash-2224  [004] .... 333095.401381:
> > > > > smb3_query_info_compound_enter: xid=3D5 sid=3D0xbb2583e9 tid=3D0x=
e7ab49dc
> > > > >      gvfsd-trash-2224  [002] .... 333095.402056:
> > > > > smb3_query_info_compound_err: xid=3D5 sid=3D0xbb2583e9 tid=3D0xe7=
ab49dc
> > > > > rc=3D-2
> > > > >      gvfsd-trash-2224  [002] .... 333095.402189:
> > > > > smb3_query_info_compound_enter: xid=3D6 sid=3D0xbb2583e9 tid=3D0x=
e7ab49dc
> > > > >      gvfsd-trash-2224  [002] .... 333095.402688:
> > > > > smb3_query_info_compound_err: xid=3D6 sid=3D0xbb2583e9 tid=3D0xe7=
ab49dc
> > > > > rc=3D-2
> > > > >            mkdir-16324 [002] .... 333123.559043:
> > > > > smb3_query_info_compound_enter: xid=3D7 sid=3D0xbb2583e9 tid=3D0x=
e7ab49dc
> > > > >            mkdir-16324 [003] .... 333123.559654:
> > > > > smb3_query_info_compound_err: xid=3D7 sid=3D0xbb2583e9 tid=3D0xe7=
ab49dc
> > > > > rc=3D-2
> > > > >            mkdir-16324 [003] .... 333123.559673: smb3_mkdir_enter=
:
> > > > > xid=3D8 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > > > >            mkdir-16324 [003] .... 333123.560748: smb3_mkdir_done:
> > > > > xid=3D8 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > > > >            mkdir-16324 [003] .... 333123.560763:
> > > > > smb3_query_info_compound_enter: xid=3D8 sid=3D0xbb2583e9 tid=3D0x=
e7ab49dc
> > > > >            mkdir-16324 [003] .... 333123.561516:
> > > > > smb3_query_info_compound_done: xid=3D8 sid=3D0xbb2583e9 tid=3D0xe=
7ab49dc
> > > > >            mkdir-16325 [002] .... 333126.841897:
> > > > > smb3_query_info_compound_enter: xid=3D9 sid=3D0xbb2583e9 tid=3D0x=
e7ab49dc
> > > > >            mkdir-16325 [003] .... 333126.842580:
> > > > > smb3_query_info_compound_err: xid=3D9 sid=3D0xbb2583e9 tid=3D0xe7=
ab49dc
> > > > > rc=3D-2
> > > > >            mkdir-16325 [003] .... 333126.842601: smb3_mkdir_enter=
:
> > > > > xid=3D10 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > > > >            mkdir-16325 [003] .... 333126.843513: smb3_mkdir_done:
> > > > > xid=3D10 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > > > >            mkdir-16325 [003] .... 333126.843529:
> > > > > smb3_query_info_compound_enter: xid=3D10 sid=3D0xbb2583e9 tid=3D0=
xe7ab49dc
> > > > >            mkdir-16325 [003] .... 333126.844251:
> > > > > smb3_query_info_compound_done: xid=3D10 sid=3D0xbb2583e9 tid=3D0x=
e7ab49dc
> > > > >            mkdir-16326 [000] .... 333129.858413:
> > > > > smb3_query_info_compound_enter: xid=3D11 sid=3D0xbb2583e9 tid=3D0=
xe7ab49dc
> > > > >            mkdir-16326 [000] .... 333129.859193:
> > > > > smb3_query_info_compound_done: xid=3D11 sid=3D0xbb2583e9 tid=3D0x=
e7ab49dc
> > > > >            rmdir-16328 [007] .... 333138.828049:
> > > > > smb3_query_info_compound_enter: xid=3D12 sid=3D0xbb2583e9 tid=3D0=
xe7ab49dc
> > > > >            rmdir-16328 [007] .... 333138.828827:
> > > > > smb3_query_info_compound_done: xid=3D12 sid=3D0xbb2583e9 tid=3D0x=
e7ab49dc
> > > > >            rmdir-16329 [006] .... 333141.388154:
> > > > > smb3_query_info_compound_enter: xid=3D14 sid=3D0xbb2583e9 tid=3D0=
xe7ab49dc
> > > > >            rmdir-16329 [006] .... 333141.388813:
> > > > > smb3_query_info_compound_err: xid=3D14 sid=3D0xbb2583e9 tid=3D0xe=
7ab49dc
> > > > > rc=3D-2
> > > > >               rm-16340 [006] .... 333157.935975:
> > > > > smb3_query_info_compound_enter: xid=3D15 sid=3D0xbb2583e9 tid=3D0=
xe7ab49dc
> > > > >               rm-16340 [006] .... 333157.936607:
> > > > > smb3_query_info_compound_err: xid=3D15 sid=3D0xbb2583e9 tid=3D0xe=
7ab49dc
> > > > > rc=3D-2
> > > > >               rm-16340 [006] .... 333157.936652:
> > > > > smb3_query_info_compound_enter: xid=3D16 sid=3D0xbb2583e9 tid=3D0=
xe7ab49dc
> > > > >               rm-16340 [006] .... 333157.937146:
> > > > > smb3_query_info_compound_err: xid=3D16 sid=3D0xbb2583e9 tid=3D0xe=
7ab49dc
> > > > > rc=3D-2
> > > > >            touch-16349 [005] .... 333184.932302:
> > > > > smb3_set_info_compound_enter: xid=3D18 sid=3D0xbb2583e9 tid=3D0xe=
7ab49dc
> > > > >            touch-16349 [005] .... 333184.938303:
> > > > > smb3_set_info_compound_done: xid=3D18 sid=3D0xbb2583e9 tid=3D0xe7=
ab49dc
> > > > >               rm-16350 [003] .... 333187.920309:
> > > > > smb3_query_info_compound_enter: xid=3D20 sid=3D0xbb2583e9 tid=3D0=
xe7ab49dc
> > > > >               rm-16350 [003] .... 333187.920999:
> > > > > smb3_query_info_compound_done: xid=3D20 sid=3D0xbb2583e9 tid=3D0x=
e7ab49dc
> > > > >               rm-16350 [003] .... 333187.921043: smb3_delete_ente=
r:
> > > > > xid=3D21 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > > > >               rm-16350 [003] .... 333187.921870: smb3_delete_done=
:
> > > > > xid=3D21 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > > > >            touch-16361 [005] .... 333237.447252:
> > > > > smb3_set_info_compound_enter: xid=3D23 sid=3D0xbb2583e9 tid=3D0xe=
7ab49dc
> > > > >            touch-16361 [005] .... 333237.448044:
> > > > > smb3_set_info_compound_done: xid=3D23 sid=3D0xbb2583e9 tid=3D0xe7=
ab49dc
> > > > >               ln-16366 [000] .... 333250.734035:
> > > > > smb3_query_info_compound_enter: xid=3D25 sid=3D0xbb2583e9 tid=3D0=
xe7ab49dc
> > > > >               ln-16366 [001] .... 333250.734689:
> > > > > smb3_query_info_compound_err: xid=3D25 sid=3D0xbb2583e9 tid=3D0xe=
7ab49dc
> > > > > rc=3D-2
> > > > >               ln-16366 [001] .... 333250.734735:
> > > > > smb3_query_info_compound_enter: xid=3D26 sid=3D0xbb2583e9 tid=3D0=
xe7ab49dc
> > > > >               ln-16366 [001] .... 333250.735368:
> > > > > smb3_query_info_compound_done: xid=3D26 sid=3D0xbb2583e9 tid=3D0x=
e7ab49dc
> > > > >               ln-16366 [001] .... 333250.735413:
> > > > > smb3_query_info_compound_enter: xid=3D27 sid=3D0xbb2583e9 tid=3D0=
xe7ab49dc
> > > > >               ln-16366 [001] .... 333250.735947:
> > > > > smb3_query_info_compound_err: xid=3D27 sid=3D0xbb2583e9 tid=3D0xe=
7ab49dc
> > > > > rc=3D-2
> > > > >               ln-16366 [001] .... 333250.735973: smb3_hardlink_en=
ter:
> > > > > xid=3D28 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > > > >               ln-16366 [001] .... 333250.736679: smb3_hardlink_do=
ne:
> > > > > xid=3D28 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > > > >            gmain-2225  [000] .... 333250.736855:
> > > > > smb3_query_info_compound_enter: xid=3D29 sid=3D0xbb2583e9 tid=3D0=
xe7ab49dc
> > > > >            gmain-2225  [001] .... 333250.737527:
> > > > > smb3_query_info_compound_done: xid=3D29 sid=3D0xbb2583e9 tid=3D0x=
e7ab49dc
> > > >
> > > > Let's add full paths to the logs to increase usability - this way w=
e
> > > > can match logs with particular actions in the user space.
> > >
> > > ok - will add
> > >
> > > > Also please don't remove the blank line - the 2nd change in the pat=
ch:
> > >
> > > That was a typo - will fix
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve
