Return-Path: <SRS0=AEBP=RP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB0AC43381
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Mar 2019 05:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 705E4214AE
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Mar 2019 05:35:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QVn8grHc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfCLFfd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Mar 2019 01:35:33 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38064 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCLFfc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Mar 2019 01:35:32 -0400
Received: by mail-pg1-f194.google.com with SMTP id m2so951800pgl.5
        for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2019 22:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+tP7kLGc7x+s16VrNsj8GI4XKm7HCfi2IQXsiqVmWLs=;
        b=QVn8grHc38itYmOwyJC6qXgxt0oMvO23xT7NcpyofcKrtCgwDqJIGe4FV7JQx5beWC
         jdxctR7yWA69wvzYODVwFN8QZ1oCNshuGuwJIvMboLsBb/EPsV88P8tSs2GnUlCiglvD
         v0V6OQLWL5zqcu+CHNmGyKblfbx+5W9jeEbV5DdYXB6YN0UqAeIeJ6ROoZ/tPfF0UOcA
         AVeb2dRoieFDBIZWOY5wpczViwqbNj1E8ooPFwG4bZkdSTXgtprNAJIKUgQTWizO0isB
         zEG2ZDJkcBxs+lJVZCIn0ZR/iGxQRtWNFdtaGyTbO/mUm2TIHAuDBk0Xn/knamNnIApL
         1XBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+tP7kLGc7x+s16VrNsj8GI4XKm7HCfi2IQXsiqVmWLs=;
        b=XPLWxhXf/UaJiZwefl+qIDsuaTxTO2eDY0WhSapPcjnA2yhw6zcZcaa+ROBBkEQquq
         rLziRLpaSGST97qCl2ZoOGIWwAdDK+vY6cf3miZOKnphu9VACSe1ZGqLxu5DRv1cG00n
         d3JStpxvRvucF/uJfzH4NAgU66Ax+84h3kgdrBJrhx8CuJi9Jk5LmkjunRlOvE/05LmG
         SO+nJcaAngMrY/uux+pd1NlYl9v4QVVP9dBwvpPMLnglQMeFMXH5mPCnpWMrMhWMMssd
         +N7+dVi9IZG5XwhsVFY8fOzklW5tIg8Nt3umq2Ah+zuhA5F5mbgohG2136AKarQIbnq2
         LSdg==
X-Gm-Message-State: APjAAAUInMl997UdZVzP1VTObkyHSUh2f/NTcFyEQvD9cmtEbbCSYr11
        aRl2WXeaOdeaLbT/P0HHRzK1lLOvlEbw9zh55fn0I41h
X-Google-Smtp-Source: APXvYqzWN5ZSR9y96KISGTtlYb16LaZrxS3jx6IsRMm1JOnd6IUOad6CXFZzp5VfLdcsFcSsa6CZq0uMhqjRukawg5U=
X-Received: by 2002:a63:2c50:: with SMTP id s77mr16396752pgs.440.1552368931181;
 Mon, 11 Mar 2019 22:35:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muY3xgVW03Mi8N-c4wyZFikzTeZgLDEuGLoXFXNZ-wFHA@mail.gmail.com>
 <CAKywueR9-_yYVA4YfycxfH_jog0xQKhgoQeFG6nhLws4TLC8Tg@mail.gmail.com> <CAH2r5mv+6N=p183kFpYnFGo7ixcu1TkCjBvWnct=1M91kH3_WA@mail.gmail.com>
In-Reply-To: <CAH2r5mv+6N=p183kFpYnFGo7ixcu1TkCjBvWnct=1M91kH3_WA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 12 Mar 2019 00:35:19 -0500
Message-ID: <CAH2r5mv2Cp8YseCF1rz0dH8tvPYZ1+dCykupzVv_S81f2gPMJg@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Add various dynamic tracepoints for compounded operations
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000b445c40583df0e20"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000b445c40583df0e20
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Version 2 of the patch attached.   Here is sample output from running it:

# entries-in-buffer/entries-written: 32/32   #P:8
#
#                              _-----=3D> irqs-off
#                             / _----=3D> need-resched
#                            | / _---=3D> hardirq/softirq
#                            || / _--=3D> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
           mkdir-31324 [001] .... 362773.434903:
smb3_query_info_compound_enter: xid=3D7 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\newdir
           mkdir-31324 [002] .... 362773.435588:
smb3_query_info_compound_err: xid=3D7 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\newdir rc=3D-2
           mkdir-31324 [002] .... 362773.435607: smb3_mkdir_enter:
xid=3D8 sid=3D0xdd73f8cb tid=3D0x65257d36 path=3D\newdir
           mkdir-31324 [002] .... 362773.436643: smb3_mkdir_done:
xid=3D8 sid=3D0xdd73f8cb tid=3D0x65257d36 path=3D\newdir
           mkdir-31324 [002] .... 362773.436659:
smb3_query_info_compound_enter: xid=3D8 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\newdir
           mkdir-31324 [002] .... 362773.437414:
smb3_query_info_compound_done: xid=3D8 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\newdir
           mkdir-31326 [006] .... 362775.812007:
smb3_query_info_compound_enter: xid=3D9 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\newdir
           mkdir-31326 [006] .... 362775.812796:
smb3_query_info_compound_done: xid=3D9 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\newdir
           rmdir-31327 [003] .... 362781.753333:
smb3_query_info_compound_enter: xid=3D10 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\newdir
           rmdir-31327 [003] .... 362781.754057:
smb3_query_info_compound_done: xid=3D10 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\newdir
           rmdir-31327 [003] .... 362781.754080: smb3_rmdir_enter:
xid=3D11 sid=3D0xdd73f8cb tid=3D0x65257d36 path=3D\newdir
           rmdir-31327 [003] .... 362781.755143: smb3_rmdir_done:
xid=3D11 sid=3D0xdd73f8cb tid=3D0x65257d36 path=3D\newdir
           touch-31328 [006] .... 362793.339620:
smb3_set_info_compound_enter: xid=3D13 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\newfile
           touch-31328 [006] .... 362793.340342:
smb3_set_info_compound_done: xid=3D13 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\newfile
              ln-31329 [002] .... 362800.848959:
smb3_query_info_compound_enter: xid=3D15 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\linknewfile
              ln-31329 [002] .... 362800.849624:
smb3_query_info_compound_err: xid=3D15 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\linknewfile rc=3D-2
              ln-31329 [002] .... 362800.849656:
smb3_query_info_compound_enter: xid=3D16 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\newfile
              ln-31329 [003] .... 362800.850318:
smb3_query_info_compound_done: xid=3D16 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\newfile
              ln-31329 [003] .... 362800.850370:
smb3_query_info_compound_enter: xid=3D17 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\linknewfile
              ln-31329 [003] .... 362800.850918:
smb3_query_info_compound_err: xid=3D17 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\linknewfile rc=3D-2
              ln-31329 [003] .... 362800.850940: smb3_hardlink_enter:
xid=3D18 sid=3D0xdd73f8cb tid=3D0x65257d36 path=3D\newfile
              ln-31329 [003] .... 362800.851669: smb3_hardlink_done:
xid=3D18 sid=3D0xdd73f8cb tid=3D0x65257d36 path=3D\newfile
           gmain-2225  [004] .... 362800.851847:
smb3_query_info_compound_enter: xid=3D19 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\linknewfile
           gmain-2225  [005] .... 362800.852345:
smb3_query_info_compound_done: xid=3D19 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\linknewfile
              rm-31330 [003] .... 362806.483029:
smb3_query_info_compound_enter: xid=3D20 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\badfile
              rm-31330 [003] .... 362806.483654:
smb3_query_info_compound_err: xid=3D20 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\badfile rc=3D-2
              rm-31330 [003] .... 362806.483704:
smb3_query_info_compound_enter: xid=3D21 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\badfile
              rm-31330 [003] .... 362806.484296:
smb3_query_info_compound_err: xid=3D21 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\badfile rc=3D-2
              rm-31335 [004] .... 362811.895827:
smb3_query_info_compound_enter: xid=3D22 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\newfile
              rm-31335 [005] .... 362811.896533:
smb3_query_info_compound_done: xid=3D22 sid=3D0xdd73f8cb tid=3D0x65257d36
path=3D\newfile
              rm-31335 [005] .... 362811.896575: smb3_delete_enter:
xid=3D23 sid=3D0xdd73f8cb tid=3D0x65257d36 path=3D\newfile
              rm-31335 [005] .... 362811.897364: smb3_delete_done:
xid=3D23 sid=3D0xdd73f8cb tid=3D0x65257d36 path=3D\newfile

On Mon, Mar 11, 2019 at 5:31 PM Steve French <smfrench@gmail.com> wrote:
>
> On Mon, Mar 11, 2019 at 5:18 PM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > =D0=BF=D0=BD, 11 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 14:25, Steve F=
rench <smfrench@gmail.com>:
> > >
> > > Sample output from tracing various newly added dynamic trace points
> > > (with this patch)
> > >
> > > (trace-cmd  record -e *query_info_co* -e smb3_hardlink* -e
> > > smb3_rename* -e smb3_set_eof* -e smb3_set_info_co* -e smb3_mkdir* -e
> > > smb3_delete*)
> > >
> > > # entries-in-buffer/entries-written: 44/44   #P:8
> > > #
> > > #                              _-----=3D> irqs-off
> > > #                             / _----=3D> need-resched
> > > #                            | / _---=3D> hardirq/softirq
> > > #                            || / _--=3D> preempt-depth
> > > #                            ||| /     delay
> > > #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> > > #              | |       |   ||||       |         |
> > >      gvfsd-trash-2224  [004] .... 333095.401381:
> > > smb3_query_info_compound_enter: xid=3D5 sid=3D0xbb2583e9 tid=3D0xe7ab=
49dc
> > >      gvfsd-trash-2224  [002] .... 333095.402056:
> > > smb3_query_info_compound_err: xid=3D5 sid=3D0xbb2583e9 tid=3D0xe7ab49=
dc
> > > rc=3D-2
> > >      gvfsd-trash-2224  [002] .... 333095.402189:
> > > smb3_query_info_compound_enter: xid=3D6 sid=3D0xbb2583e9 tid=3D0xe7ab=
49dc
> > >      gvfsd-trash-2224  [002] .... 333095.402688:
> > > smb3_query_info_compound_err: xid=3D6 sid=3D0xbb2583e9 tid=3D0xe7ab49=
dc
> > > rc=3D-2
> > >            mkdir-16324 [002] .... 333123.559043:
> > > smb3_query_info_compound_enter: xid=3D7 sid=3D0xbb2583e9 tid=3D0xe7ab=
49dc
> > >            mkdir-16324 [003] .... 333123.559654:
> > > smb3_query_info_compound_err: xid=3D7 sid=3D0xbb2583e9 tid=3D0xe7ab49=
dc
> > > rc=3D-2
> > >            mkdir-16324 [003] .... 333123.559673: smb3_mkdir_enter:
> > > xid=3D8 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > >            mkdir-16324 [003] .... 333123.560748: smb3_mkdir_done:
> > > xid=3D8 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > >            mkdir-16324 [003] .... 333123.560763:
> > > smb3_query_info_compound_enter: xid=3D8 sid=3D0xbb2583e9 tid=3D0xe7ab=
49dc
> > >            mkdir-16324 [003] .... 333123.561516:
> > > smb3_query_info_compound_done: xid=3D8 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> > >            mkdir-16325 [002] .... 333126.841897:
> > > smb3_query_info_compound_enter: xid=3D9 sid=3D0xbb2583e9 tid=3D0xe7ab=
49dc
> > >            mkdir-16325 [003] .... 333126.842580:
> > > smb3_query_info_compound_err: xid=3D9 sid=3D0xbb2583e9 tid=3D0xe7ab49=
dc
> > > rc=3D-2
> > >            mkdir-16325 [003] .... 333126.842601: smb3_mkdir_enter:
> > > xid=3D10 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > >            mkdir-16325 [003] .... 333126.843513: smb3_mkdir_done:
> > > xid=3D10 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > >            mkdir-16325 [003] .... 333126.843529:
> > > smb3_query_info_compound_enter: xid=3D10 sid=3D0xbb2583e9 tid=3D0xe7a=
b49dc
> > >            mkdir-16325 [003] .... 333126.844251:
> > > smb3_query_info_compound_done: xid=3D10 sid=3D0xbb2583e9 tid=3D0xe7ab=
49dc
> > >            mkdir-16326 [000] .... 333129.858413:
> > > smb3_query_info_compound_enter: xid=3D11 sid=3D0xbb2583e9 tid=3D0xe7a=
b49dc
> > >            mkdir-16326 [000] .... 333129.859193:
> > > smb3_query_info_compound_done: xid=3D11 sid=3D0xbb2583e9 tid=3D0xe7ab=
49dc
> > >            rmdir-16328 [007] .... 333138.828049:
> > > smb3_query_info_compound_enter: xid=3D12 sid=3D0xbb2583e9 tid=3D0xe7a=
b49dc
> > >            rmdir-16328 [007] .... 333138.828827:
> > > smb3_query_info_compound_done: xid=3D12 sid=3D0xbb2583e9 tid=3D0xe7ab=
49dc
> > >            rmdir-16329 [006] .... 333141.388154:
> > > smb3_query_info_compound_enter: xid=3D14 sid=3D0xbb2583e9 tid=3D0xe7a=
b49dc
> > >            rmdir-16329 [006] .... 333141.388813:
> > > smb3_query_info_compound_err: xid=3D14 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> > > rc=3D-2
> > >               rm-16340 [006] .... 333157.935975:
> > > smb3_query_info_compound_enter: xid=3D15 sid=3D0xbb2583e9 tid=3D0xe7a=
b49dc
> > >               rm-16340 [006] .... 333157.936607:
> > > smb3_query_info_compound_err: xid=3D15 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> > > rc=3D-2
> > >               rm-16340 [006] .... 333157.936652:
> > > smb3_query_info_compound_enter: xid=3D16 sid=3D0xbb2583e9 tid=3D0xe7a=
b49dc
> > >               rm-16340 [006] .... 333157.937146:
> > > smb3_query_info_compound_err: xid=3D16 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> > > rc=3D-2
> > >            touch-16349 [005] .... 333184.932302:
> > > smb3_set_info_compound_enter: xid=3D18 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> > >            touch-16349 [005] .... 333184.938303:
> > > smb3_set_info_compound_done: xid=3D18 sid=3D0xbb2583e9 tid=3D0xe7ab49=
dc
> > >               rm-16350 [003] .... 333187.920309:
> > > smb3_query_info_compound_enter: xid=3D20 sid=3D0xbb2583e9 tid=3D0xe7a=
b49dc
> > >               rm-16350 [003] .... 333187.920999:
> > > smb3_query_info_compound_done: xid=3D20 sid=3D0xbb2583e9 tid=3D0xe7ab=
49dc
> > >               rm-16350 [003] .... 333187.921043: smb3_delete_enter:
> > > xid=3D21 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > >               rm-16350 [003] .... 333187.921870: smb3_delete_done:
> > > xid=3D21 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > >            touch-16361 [005] .... 333237.447252:
> > > smb3_set_info_compound_enter: xid=3D23 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> > >            touch-16361 [005] .... 333237.448044:
> > > smb3_set_info_compound_done: xid=3D23 sid=3D0xbb2583e9 tid=3D0xe7ab49=
dc
> > >               ln-16366 [000] .... 333250.734035:
> > > smb3_query_info_compound_enter: xid=3D25 sid=3D0xbb2583e9 tid=3D0xe7a=
b49dc
> > >               ln-16366 [001] .... 333250.734689:
> > > smb3_query_info_compound_err: xid=3D25 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> > > rc=3D-2
> > >               ln-16366 [001] .... 333250.734735:
> > > smb3_query_info_compound_enter: xid=3D26 sid=3D0xbb2583e9 tid=3D0xe7a=
b49dc
> > >               ln-16366 [001] .... 333250.735368:
> > > smb3_query_info_compound_done: xid=3D26 sid=3D0xbb2583e9 tid=3D0xe7ab=
49dc
> > >               ln-16366 [001] .... 333250.735413:
> > > smb3_query_info_compound_enter: xid=3D27 sid=3D0xbb2583e9 tid=3D0xe7a=
b49dc
> > >               ln-16366 [001] .... 333250.735947:
> > > smb3_query_info_compound_err: xid=3D27 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> > > rc=3D-2
> > >               ln-16366 [001] .... 333250.735973: smb3_hardlink_enter:
> > > xid=3D28 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > >               ln-16366 [001] .... 333250.736679: smb3_hardlink_done:
> > > xid=3D28 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > >            gmain-2225  [000] .... 333250.736855:
> > > smb3_query_info_compound_enter: xid=3D29 sid=3D0xbb2583e9 tid=3D0xe7a=
b49dc
> > >            gmain-2225  [001] .... 333250.737527:
> > > smb3_query_info_compound_done: xid=3D29 sid=3D0xbb2583e9 tid=3D0xe7ab=
49dc
> >
> > Let's add full paths to the logs to increase usability - this way we
> > can match logs with particular actions in the user space.
>
> ok - will add
>
> > Also please don't remove the blank line - the 2nd change in the patch:
>
> That was a typo - will fix
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--000000000000b445c40583df0e20
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-Add-dynamic-trace-points-for-various-compounded.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-Add-dynamic-trace-points-for-various-compounded.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jt5cd9jm0>
X-Attachment-Id: f_jt5cd9jm0

RnJvbSBkZDVmZDU4YTg1ZTEzNTAwMDM3MTZhZDE3NDczMTI3ZGM4MDA4NTBlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMTIgTWFyIDIwMTkgMDA6MzE6NTAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBBZGQgZHluYW1pYyB0cmFjZSBwb2ludHMgZm9yIHZhcmlvdXMgY29tcG91bmRlZCBzbWIz
CiBvcHMKCkFkZHMgdHJhY2UgcG9pbnRzIGZvciBlbnRlciBhbmQgZXhpdCAoZG9uZSB2cy4gZXJy
b3IpIGZvcjoKCgljb21wb3VuZGVkIHF1ZXJ5IGFuZCBzZXRpbmZvLCBoYXJkbGluaywgcmVuYW1l
LAoJbWtkaXIsIHJtZGlyLCBzZXRfZW9mLCBkZWxldGUgKHVubGluaykKClNpZ25lZC1vZmYtYnk6
IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJp
bm9kZS5jIHwgODQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0KIGZz
L2NpZnMvdHJhY2UuaCAgICAgfCA5MiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgMTcyIGluc2VydGlvbnMoKyksIDQgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIyaW5vZGUuYyBiL2ZzL2NpZnMvc21iMmlu
b2RlLmMKaW5kZXggMDFhNzZiY2NkYjhkLi5kMTU1MzBmN2RiMmQgMTAwNjQ0Ci0tLSBhL2ZzL2Np
ZnMvc21iMmlub2RlLmMKKysrIGIvZnMvY2lmcy9zbWIyaW5vZGUuYwpAQCAtMzcsNiArMzcsMTYg
QEAKICNpbmNsdWRlICJzbWIycGR1LmgiCiAjaW5jbHVkZSAic21iMnByb3RvLmgiCiAKK3N0YXRp
YyB2b2lkCitmcmVlX3NldF9pbmZfY29tcG91bmQoc3RydWN0IHNtYl9ycXN0ICpycXN0KQorewor
CWlmIChycXN0WzFdLnJxX2lvdikKKwkJU01CMl9zZXRfaW5mb19mcmVlKCZycXN0WzFdKTsKKwlp
ZiAocnFzdFsyXS5ycV9pb3YpCisJCVNNQjJfY2xvc2VfZnJlZSgmcnFzdFsyXSk7Cit9CisKKwog
c3RhdGljIGludAogc21iMl9jb21wb3VuZF9vcChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1
Y3QgY2lmc190Y29uICp0Y29uLAogCQkgc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwgY29u
c3QgY2hhciAqZnVsbF9wYXRoLApAQCAtMTEyLDE0ICsxMjIsMTggQEAgc21iMl9jb21wb3VuZF9v
cChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJCQkg
IFBBVEhfTUFYICogMiwgMCwgTlVMTCk7CiAJCXNtYjJfc2V0X25leHRfY29tbWFuZCh0Y29uLCAm
cnFzdFtudW1fcnFzdF0pOwogCQlzbWIyX3NldF9yZWxhdGVkKCZycXN0W251bV9ycXN0KytdKTsK
KwkJdHJhY2Vfc21iM19xdWVyeV9pbmZvX2NvbXBvdW5kX2VudGVyKHhpZCwgc2VzLT5TdWlkLCB0
Y29uLT50aWQsCisJCQkJCQkgICAgIGZ1bGxfcGF0aCk7CiAJCWJyZWFrOwogCWNhc2UgU01CMl9P
UF9ERUxFVEU6CisJCXRyYWNlX3NtYjNfZGVsZXRlX2VudGVyKHhpZCwgc2VzLT5TdWlkLCB0Y29u
LT50aWQsIGZ1bGxfcGF0aCk7CiAJCWJyZWFrOwogCWNhc2UgU01CMl9PUF9NS0RJUjoKIAkJLyoK
IAkJICogRGlyZWN0b3JpZXMgYXJlIGNyZWF0ZWQgdGhyb3VnaCBwYXJhbWV0ZXJzIGluIHRoZQog
CQkgKiBTTUIyX29wZW4oKSBjYWxsLgogCQkgKi8KKwkJdHJhY2Vfc21iM19ta2Rpcl9lbnRlcih4
aWQsIHNlcy0+U3VpZCwgdGNvbi0+dGlkLCBmdWxsX3BhdGgpOwogCQlicmVhazsKIAljYXNlIFNN
QjJfT1BfUk1ESVI6CiAJCW1lbXNldCgmc2lfaW92LCAwLCBzaXplb2Yoc2lfaW92KSk7CkBAIC0x
MzUsNiArMTQ5LDcgQEAgc21iMl9jb21wb3VuZF9vcChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBz
dHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJCQlTTUIyX09fSU5GT19GSUxFLCAwLCBkYXRhLCBz
aXplKTsKIAkJc21iMl9zZXRfbmV4dF9jb21tYW5kKHRjb24sICZycXN0W251bV9ycXN0XSk7CiAJ
CXNtYjJfc2V0X3JlbGF0ZWQoJnJxc3RbbnVtX3Jxc3QrK10pOworCQl0cmFjZV9zbWIzX3JtZGly
X2VudGVyKHhpZCwgc2VzLT5TdWlkLCB0Y29uLT50aWQsIGZ1bGxfcGF0aCk7CiAJCWJyZWFrOwog
CWNhc2UgU01CMl9PUF9TRVRfRU9GOgogCQltZW1zZXQoJnNpX2lvdiwgMCwgc2l6ZW9mKHNpX2lv
dikpOwpAQCAtMTUwLDYgKzE2NSw3IEBAIHNtYjJfY29tcG91bmRfb3AoY29uc3QgdW5zaWduZWQg
aW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCQkJU01CMl9PX0lORk9fRklMRSwg
MCwgZGF0YSwgc2l6ZSk7CiAJCXNtYjJfc2V0X25leHRfY29tbWFuZCh0Y29uLCAmcnFzdFtudW1f
cnFzdF0pOwogCQlzbWIyX3NldF9yZWxhdGVkKCZycXN0W251bV9ycXN0KytdKTsKKwkJdHJhY2Vf
c21iM19zZXRfZW9mX2VudGVyKHhpZCwgc2VzLT5TdWlkLCB0Y29uLT50aWQsIGZ1bGxfcGF0aCk7
CiAJCWJyZWFrOwogCWNhc2UgU01CMl9PUF9TRVRfSU5GTzoKIAkJbWVtc2V0KCZzaV9pb3YsIDAs
IHNpemVvZihzaV9pb3YpKTsKQEAgLTE2Niw2ICsxODIsOCBAQCBzbWIyX2NvbXBvdW5kX29wKGNv
bnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQkJCVNNQjJf
T19JTkZPX0ZJTEUsIDAsIGRhdGEsIHNpemUpOwogCQlzbWIyX3NldF9uZXh0X2NvbW1hbmQodGNv
biwgJnJxc3RbbnVtX3Jxc3RdKTsKIAkJc21iMl9zZXRfcmVsYXRlZCgmcnFzdFtudW1fcnFzdCsr
XSk7CisJCXRyYWNlX3NtYjNfc2V0X2luZm9fY29tcG91bmRfZW50ZXIoeGlkLCBzZXMtPlN1aWQs
IHRjb24tPnRpZCwKKwkJCQkJCSAgIGZ1bGxfcGF0aCk7CiAJCWJyZWFrOwogCWNhc2UgU01CMl9P
UF9SRU5BTUU6CiAJCW1lbXNldCgmc2lfaW92LCAwLCBzaXplb2Yoc2lfaW92KSk7CkBAIC0xOTAs
NiArMjA4LDcgQEAgc21iMl9jb21wb3VuZF9vcChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1
Y3QgY2lmc190Y29uICp0Y29uLAogCQkJCQlTTUIyX09fSU5GT19GSUxFLCAwLCBkYXRhLCBzaXpl
KTsKIAkJc21iMl9zZXRfbmV4dF9jb21tYW5kKHRjb24sICZycXN0W251bV9ycXN0XSk7CiAJCXNt
YjJfc2V0X3JlbGF0ZWQoJnJxc3RbbnVtX3Jxc3QrK10pOworCQl0cmFjZV9zbWIzX3JlbmFtZV9l
bnRlcih4aWQsIHNlcy0+U3VpZCwgdGNvbi0+dGlkLCBmdWxsX3BhdGgpOwogCQlicmVhazsKIAlj
YXNlIFNNQjJfT1BfSEFSRExJTks6CiAJCW1lbXNldCgmc2lfaW92LCAwLCBzaXplb2Yoc2lfaW92
KSk7CkBAIC0yMTQsNiArMjMzLDcgQEAgc21iMl9jb21wb3VuZF9vcChjb25zdCB1bnNpZ25lZCBp
bnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJCQlTTUIyX09fSU5GT19GSUxFLCAw
LCBkYXRhLCBzaXplKTsKIAkJc21iMl9zZXRfbmV4dF9jb21tYW5kKHRjb24sICZycXN0W251bV9y
cXN0XSk7CiAJCXNtYjJfc2V0X3JlbGF0ZWQoJnJxc3RbbnVtX3Jxc3QrK10pOworCQl0cmFjZV9z
bWIzX2hhcmRsaW5rX2VudGVyKHhpZCwgc2VzLT5TdWlkLCB0Y29uLT50aWQsIGZ1bGxfcGF0aCk7
CiAJCWJyZWFrOwogCWRlZmF1bHQ6CiAJCWNpZnNfZGJnKFZGUywgIkludmFsaWQgY29tbWFuZFxu
Iik7CkBAIC0yNTIsMjEgKzI3Miw3NyBAQCBzbWIyX2NvbXBvdW5kX29wKGNvbnN0IHVuc2lnbmVk
IGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQlTTUIyX3F1ZXJ5X2luZm9fZnJl
ZSgmcnFzdFsxXSk7CiAJCWlmIChycXN0WzJdLnJxX2lvdikKIAkJCVNNQjJfY2xvc2VfZnJlZSgm
cnFzdFsyXSk7CisJCWlmIChyYykKKwkJCXRyYWNlX3NtYjNfcXVlcnlfaW5mb19jb21wb3VuZF9l
cnIoeGlkLCAgc2VzLT5TdWlkLAorCQkJCQkJdGNvbi0+dGlkLCBmdWxsX3BhdGgsIHJjKTsKKwkJ
ZWxzZQorCQkJdHJhY2Vfc21iM19xdWVyeV9pbmZvX2NvbXBvdW5kX2RvbmUoeGlkLCBzZXMtPlN1
aWQsCisJCQkJCQl0Y29uLT50aWQsIGZ1bGxfcGF0aCk7CiAJCWJyZWFrOwogCWNhc2UgU01CMl9P
UF9ERUxFVEU6CisJCWlmIChyYykKKwkJCXRyYWNlX3NtYjNfZGVsZXRlX2Vycih4aWQsICBzZXMt
PlN1aWQsIHRjb24tPnRpZCwKKwkJCQkJCWZ1bGxfcGF0aCwgcmMpOworCQllbHNlCisJCQl0cmFj
ZV9zbWIzX2RlbGV0ZV9kb25lKHhpZCwgc2VzLT5TdWlkLCB0Y29uLT50aWQsCisJCQkJCQlmdWxs
X3BhdGgpOworCQlpZiAocnFzdFsxXS5ycV9pb3YpCisJCQlTTUIyX2Nsb3NlX2ZyZWUoJnJxc3Rb
MV0pOworCQlicmVhazsKIAljYXNlIFNNQjJfT1BfTUtESVI6CisJCWlmIChyYykKKwkJCXRyYWNl
X3NtYjNfbWtkaXJfZXJyKHhpZCwgIHNlcy0+U3VpZCwgdGNvbi0+dGlkLAorCQkJCQkJZnVsbF9w
YXRoLCByYyk7CisJCWVsc2UKKwkJCXRyYWNlX3NtYjNfbWtkaXJfZG9uZSh4aWQsIHNlcy0+U3Vp
ZCwgdGNvbi0+dGlkLAorCQkJCQkJZnVsbF9wYXRoKTsKIAkJaWYgKHJxc3RbMV0ucnFfaW92KQog
CQkJU01CMl9jbG9zZV9mcmVlKCZycXN0WzFdKTsKIAkJYnJlYWs7CiAJY2FzZSBTTUIyX09QX0hB
UkRMSU5LOgorCQlpZiAocmMpCisJCQl0cmFjZV9zbWIzX2hhcmRsaW5rX2Vycih4aWQsICBzZXMt
PlN1aWQsIHRjb24tPnRpZCwKKwkJCQkJCWZ1bGxfcGF0aCwgcmMpOworCQllbHNlCisJCQl0cmFj
ZV9zbWIzX2hhcmRsaW5rX2RvbmUoeGlkLCBzZXMtPlN1aWQsIHRjb24tPnRpZCwKKwkJCQkJCWZ1
bGxfcGF0aCk7CisJCWZyZWVfc2V0X2luZl9jb21wb3VuZChycXN0KTsKKwkJYnJlYWs7CiAJY2Fz
ZSBTTUIyX09QX1JFTkFNRToKKwkJaWYgKHJjKQorCQkJdHJhY2Vfc21iM19yZW5hbWVfZXJyKHhp
ZCwgIHNlcy0+U3VpZCwgdGNvbi0+dGlkLAorCQkJCQkJZnVsbF9wYXRoLCByYyk7CisJCWVsc2UK
KwkJCXRyYWNlX3NtYjNfcmVuYW1lX2RvbmUoeGlkLCBzZXMtPlN1aWQsIHRjb24tPnRpZCwKKwkJ
CQkJCWZ1bGxfcGF0aCk7CisJCWZyZWVfc2V0X2luZl9jb21wb3VuZChycXN0KTsKKwkJYnJlYWs7
CiAJY2FzZSBTTUIyX09QX1JNRElSOgorCQlpZiAocmMpCisJCQl0cmFjZV9zbWIzX3JtZGlyX2Vy
cih4aWQsICBzZXMtPlN1aWQsIHRjb24tPnRpZCwKKwkJCQkJCWZ1bGxfcGF0aCwgcmMpOworCQll
bHNlCisJCQl0cmFjZV9zbWIzX3JtZGlyX2RvbmUoeGlkLCBzZXMtPlN1aWQsIHRjb24tPnRpZCwK
KwkJCQkJCWZ1bGxfcGF0aCk7CisJCWZyZWVfc2V0X2luZl9jb21wb3VuZChycXN0KTsKKwkJYnJl
YWs7CiAJY2FzZSBTTUIyX09QX1NFVF9FT0Y6CisJCWlmIChyYykKKwkJCXRyYWNlX3NtYjNfc2V0
X2VvZl9lcnIoeGlkLCAgc2VzLT5TdWlkLCB0Y29uLT50aWQsCisJCQkJCQlmdWxsX3BhdGgsIHJj
KTsKKwkJZWxzZQorCQkJdHJhY2Vfc21iM19zZXRfZW9mX2RvbmUoeGlkLCBzZXMtPlN1aWQsIHRj
b24tPnRpZCwKKwkJCQkJCWZ1bGxfcGF0aCk7CisJCWZyZWVfc2V0X2luZl9jb21wb3VuZChycXN0
KTsKKwkJYnJlYWs7CiAJY2FzZSBTTUIyX09QX1NFVF9JTkZPOgotCQlpZiAocnFzdFsxXS5ycV9p
b3YpCi0JCQlTTUIyX3NldF9pbmZvX2ZyZWUoJnJxc3RbMV0pOwotCQlpZiAocnFzdFsyXS5ycV9p
b3YpCi0JCQlTTUIyX2Nsb3NlX2ZyZWUoJnJxc3RbMl0pOworCQlpZiAocmMpCisJCQl0cmFjZV9z
bWIzX3NldF9pbmZvX2NvbXBvdW5kX2Vycih4aWQsICBzZXMtPlN1aWQsCisJCQkJCQl0Y29uLT50
aWQsIGZ1bGxfcGF0aCwgcmMpOworCQllbHNlCisJCQl0cmFjZV9zbWIzX3NldF9pbmZvX2NvbXBv
dW5kX2RvbmUoeGlkLCBzZXMtPlN1aWQsCisJCQkJCQl0Y29uLT50aWQsIGZ1bGxfcGF0aCk7CisJ
CWZyZWVfc2V0X2luZl9jb21wb3VuZChycXN0KTsKIAkJYnJlYWs7CiAJfQogCWZyZWVfcnNwX2J1
ZihyZXNwX2J1ZnR5cGVbMF0sIHJzcF9pb3ZbMF0uaW92X2Jhc2UpOwpkaWZmIC0tZ2l0IGEvZnMv
Y2lmcy90cmFjZS5oIGIvZnMvY2lmcy90cmFjZS5oCmluZGV4IGM3OGU5NmM0Y2M1My4uY2EwZDc3
YmY2NGUxIDEwMDY0NAotLS0gYS9mcy9jaWZzL3RyYWNlLmgKKysrIGIvZnMvY2lmcy90cmFjZS5o
CkBAIC0yNDIsNiArMjQyLDk4IEBAIERFRklORV9TTUIzX0lORl9FUlJfRVZFTlQocXVlcnlfaW5m
b19lcnIpOwogREVGSU5FX1NNQjNfSU5GX0VSUl9FVkVOVChzZXRfaW5mb19lcnIpOwogREVGSU5F
X1NNQjNfSU5GX0VSUl9FVkVOVChmc2N0bF9lcnIpOwogCitERUNMQVJFX0VWRU5UX0NMQVNTKHNt
YjNfaW5mX2NvbXBvdW5kX2VudGVyX2NsYXNzLAorCVRQX1BST1RPKHVuc2lnbmVkIGludCB4aWQs
CisJCV9fdTMyCXRpZCwKKwkJX191NjQJc2VzaWQsCisJCWNvbnN0IGNoYXIgKmZ1bGxfcGF0aCks
CisJVFBfQVJHUyh4aWQsIHRpZCwgc2VzaWQsIGZ1bGxfcGF0aCksCisJVFBfU1RSVUNUX19lbnRy
eSgKKwkJX19maWVsZCh1bnNpZ25lZCBpbnQsIHhpZCkKKwkJX19maWVsZChfX3UzMiwgdGlkKQor
CQlfX2ZpZWxkKF9fdTY0LCBzZXNpZCkKKwkJX19zdHJpbmcocGF0aCwgZnVsbF9wYXRoKQorCSks
CisJVFBfZmFzdF9hc3NpZ24oCisJCV9fZW50cnktPnhpZCA9IHhpZDsKKwkJX19lbnRyeS0+dGlk
ID0gdGlkOworCQlfX2VudHJ5LT5zZXNpZCA9IHNlc2lkOworCQlfX2Fzc2lnbl9zdHIocGF0aCwg
ZnVsbF9wYXRoKTsKKwkpLAorCVRQX3ByaW50aygieGlkPSV1IHNpZD0weCVsbHggdGlkPTB4JXgg
cGF0aD0lcyIsCisJCV9fZW50cnktPnhpZCwgX19lbnRyeS0+c2VzaWQsIF9fZW50cnktPnRpZCwK
KwkJX19nZXRfc3RyKHBhdGgpKQorKQorCisjZGVmaW5lIERFRklORV9TTUIzX0lORl9DT01QT1VO
RF9FTlRFUl9FVkVOVChuYW1lKSAgICAgXAorREVGSU5FX0VWRU5UKHNtYjNfaW5mX2NvbXBvdW5k
X2VudGVyX2NsYXNzLCBzbWIzXyMjbmFtZSwgICAgXAorCVRQX1BST1RPKHVuc2lnbmVkIGludCB4
aWQsCQlcCisJCV9fdTMyCXRpZCwJCQlcCisJCV9fdTY0CXNlc2lkLAkJCVwKKwkJY29uc3QgY2hh
ciAqZnVsbF9wYXRoKSwJCVwKKwlUUF9BUkdTKHhpZCwgdGlkLCBzZXNpZCwgZnVsbF9wYXRoKSkK
KworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5UKHF1ZXJ5X2luZm9fY29tcG91
bmRfZW50ZXIpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5UKHF1ZXJ5X2lu
Zm9fY29tcG91bmRfZG9uZSk7CitERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRU5URVJfRVZFTlQo
aGFyZGxpbmtfZW50ZXIpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5UKGhh
cmRsaW5rX2RvbmUpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5UKHJlbmFt
ZV9lbnRlcik7CitERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRU5URVJfRVZFTlQocmVuYW1lX2Rv
bmUpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5UKHJtZGlyX2VudGVyKTsK
K0RFRklORV9TTUIzX0lORl9DT01QT1VORF9FTlRFUl9FVkVOVChybWRpcl9kb25lKTsKK0RFRklO
RV9TTUIzX0lORl9DT01QT1VORF9FTlRFUl9FVkVOVChzZXRfZW9mX2VudGVyKTsKK0RFRklORV9T
TUIzX0lORl9DT01QT1VORF9FTlRFUl9FVkVOVChzZXRfZW9mX2RvbmUpOworREVGSU5FX1NNQjNf
SU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5UKHNldF9pbmZvX2NvbXBvdW5kX2VudGVyKTsKK0RFRklO
RV9TTUIzX0lORl9DT01QT1VORF9FTlRFUl9FVkVOVChzZXRfaW5mb19jb21wb3VuZF9kb25lKTsK
K0RFRklORV9TTUIzX0lORl9DT01QT1VORF9FTlRFUl9FVkVOVChkZWxldGVfZW50ZXIpOworREVG
SU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5UKGRlbGV0ZV9kb25lKTsKK0RFRklORV9T
TUIzX0lORl9DT01QT1VORF9FTlRFUl9FVkVOVChta2Rpcl9lbnRlcik7CitERUZJTkVfU01CM19J
TkZfQ09NUE9VTkRfRU5URVJfRVZFTlQobWtkaXJfZG9uZSk7CisKK0RFQ0xBUkVfRVZFTlRfQ0xB
U1Moc21iM19pbmZfY29tcG91bmRfZXJyX2NsYXNzLAorCVRQX1BST1RPKHVuc2lnbmVkIGludCB4
aWQsCisJCV9fdTMyCXRpZCwKKwkJX191NjQJc2VzaWQsCisJCWNvbnN0IGNoYXIgKmZ1bGxfcGF0
aCwKKwkJaW50CXJjKSwKKwlUUF9BUkdTKHhpZCwgdGlkLCBzZXNpZCwgZnVsbF9wYXRoLCByYyks
CisJVFBfU1RSVUNUX19lbnRyeSgKKwkJX19maWVsZCh1bnNpZ25lZCBpbnQsIHhpZCkKKwkJX19m
aWVsZChfX3UzMiwgdGlkKQorCQlfX2ZpZWxkKF9fdTY0LCBzZXNpZCkKKwkJX19zdHJpbmcocGF0
aCwgZnVsbF9wYXRoKQorCQlfX2ZpZWxkKGludCwgcmMpCisJKSwKKwlUUF9mYXN0X2Fzc2lnbigK
KwkJX19lbnRyeS0+eGlkID0geGlkOworCQlfX2VudHJ5LT50aWQgPSB0aWQ7CisJCV9fZW50cnkt
PnNlc2lkID0gc2VzaWQ7CisJCV9fYXNzaWduX3N0cihwYXRoLCBmdWxsX3BhdGgpOworCQlfX2Vu
dHJ5LT5yYyA9IHJjOworCSksCisJVFBfcHJpbnRrKCJ4aWQ9JXUgc2lkPTB4JWxseCB0aWQ9MHgl
eCBwYXRoPSVzIHJjPSVkIiwKKwkJX19lbnRyeS0+eGlkLCBfX2VudHJ5LT5zZXNpZCwgX19lbnRy
eS0+dGlkLAorCQlfX2dldF9zdHIocGF0aCksIF9fZW50cnktPnJjKQorKQorCisjZGVmaW5lIERF
RklORV9TTUIzX0lORl9DT01QT1VORF9FUlJfRVZFTlQobmFtZSkgICAgIFwKK0RFRklORV9FVkVO
VChzbWIzX2luZl9jb21wb3VuZF9lcnJfY2xhc3MsIHNtYjNfIyNuYW1lLCAgICBcCisJVFBfUFJP
VE8odW5zaWduZWQgaW50IHhpZCwJCVwKKwkJX191MzIJdGlkLAkJCVwKKwkJX191NjQJc2VzaWQs
CQkJXAorCQljb25zdCBjaGFyICpwYXRoLAkJXAorCQlpbnQgcmMpLAkJCVwKKwlUUF9BUkdTKHhp
ZCwgdGlkLCBzZXNpZCwgcGF0aCwgcmMpKQorCitERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRVJS
X0VWRU5UKHF1ZXJ5X2luZm9fY29tcG91bmRfZXJyKTsKK0RFRklORV9TTUIzX0lORl9DT01QT1VO
RF9FUlJfRVZFTlQoaGFyZGxpbmtfZXJyKTsKK0RFRklORV9TTUIzX0lORl9DT01QT1VORF9FUlJf
RVZFTlQocmVuYW1lX2Vycik7CitERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRVJSX0VWRU5UKHJt
ZGlyX2Vycik7CitERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRVJSX0VWRU5UKHNldF9lb2ZfZXJy
KTsKK0RFRklORV9TTUIzX0lORl9DT01QT1VORF9FUlJfRVZFTlQoc2V0X2luZm9fY29tcG91bmRf
ZXJyKTsKK0RFRklORV9TTUIzX0lORl9DT01QT1VORF9FUlJfRVZFTlQobWtkaXJfZXJyKTsKK0RF
RklORV9TTUIzX0lORl9DT01QT1VORF9FUlJfRVZFTlQoZGVsZXRlX2Vycik7CisKIC8qCiAgKiBG
b3IgbG9nZ2luZyBTTUIzIFN0YXR1cyBjb2RlIGFuZCBDb21tYW5kIGZvciByZXNwb25zZXMgd2hp
Y2ggcmV0dXJuIGVycm9ycwogICovCi0tIAoyLjE3LjEKCg==
--000000000000b445c40583df0e20--
