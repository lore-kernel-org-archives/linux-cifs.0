Return-Path: <SRS0=BRhE=RO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 629DBC43381
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Mar 2019 22:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2665D214AE
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Mar 2019 22:31:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NQUImDtK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfCKWbk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Mar 2019 18:31:40 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:42171 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfCKWbk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 11 Mar 2019 18:31:40 -0400
Received: by mail-pf1-f175.google.com with SMTP id n74so280807pfi.9
        for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2019 15:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9fTq21K7MTMoa6fqeaEPYGkwCDCrkQSqj4lCsf8lCfs=;
        b=NQUImDtKuM2r9mA2Ko91ShcfvXkZY/lm2N3TX6yEMSAu15yOxWyPad+MKA5hvoZ/Pn
         0Q4mROS0QKlakg8Rr1ZGL0zoQ6sFgUDEuwdI4DZ94nA/1oGn3M7I4Qv/3zayj1Ds1orf
         YMXpgixMo3UQMYxXAH9dKOc3Yz7vLaYMR9pMOnPPckRUZXxtPPP4x8LE4ofzeMYweLga
         iH92UUAkULgCvEz/DtozMhTwCoiq9gZapwScezWhcGXIYnOYctAus1Sl/vqPTOzdAZeG
         Yca3cpOmExTnZNXa1AbIw07QKsBAcv0HevyLtQGK4tv/JJwgbbfIe8/wT6+OKp+Qeq8z
         I9yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9fTq21K7MTMoa6fqeaEPYGkwCDCrkQSqj4lCsf8lCfs=;
        b=VkLSzn2cBddbQDZ2MrUVyPh+vvU8BUD7eZU1ESDvDOE+E1598dnjc9z6a3TTdvi/9V
         JAUEJXQ4bkOZpgVitPyllSuUrj3Tl3y5cVXgb5QndzJrRLBE6CZD1dpp7EKYUrOTKYCm
         n2HF47hkhW262f/YW0QJmt5mG0GC2xSQk5bYfvoNr+ddHH/tSwvQ9mpjP/uaXV49X4My
         TvB//08Hs5YskDRQSn8a5brdhOaXO+dkzkWnfGqiEDMJLQxZzX/OzRtneYISYknP4XeW
         1UAUkhJLWEGFoNNNqf51GFAGjqyHe0XW2TANbqM539BFmGH6RHLE16w2yQPQgycz+ZTf
         Rwig==
X-Gm-Message-State: APjAAAXlbKa4G/KrrTMDIIkerHCXKqGFG/5pJH0zMF/qVFJzz36TMRcF
        mBXL1tVh/irz05eKMOYcA9qT32wJjVwbm0xWDII=
X-Google-Smtp-Source: APXvYqwdSxIy08vTAh0y9R+pR2nKUkB60oBEaDr7uPRG3dkWRcnKKQlrvUtTa77cOFRzXlM17IFUXqi9Mdo+DD7VZzA=
X-Received: by 2002:a17:902:147:: with SMTP id 65mr32485715plb.18.1552343498864;
 Mon, 11 Mar 2019 15:31:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muY3xgVW03Mi8N-c4wyZFikzTeZgLDEuGLoXFXNZ-wFHA@mail.gmail.com>
 <CAKywueR9-_yYVA4YfycxfH_jog0xQKhgoQeFG6nhLws4TLC8Tg@mail.gmail.com>
In-Reply-To: <CAKywueR9-_yYVA4YfycxfH_jog0xQKhgoQeFG6nhLws4TLC8Tg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 11 Mar 2019 17:31:26 -0500
Message-ID: <CAH2r5mv+6N=p183kFpYnFGo7ixcu1TkCjBvWnct=1M91kH3_WA@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Add various dynamic tracepoints for compounded operations
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Mar 11, 2019 at 5:18 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D0=BF=D0=BD, 11 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 14:25, Steve Fre=
nch <smfrench@gmail.com>:
> >
> > Sample output from tracing various newly added dynamic trace points
> > (with this patch)
> >
> > (trace-cmd  record -e *query_info_co* -e smb3_hardlink* -e
> > smb3_rename* -e smb3_set_eof* -e smb3_set_info_co* -e smb3_mkdir* -e
> > smb3_delete*)
> >
> > # entries-in-buffer/entries-written: 44/44   #P:8
> > #
> > #                              _-----=3D> irqs-off
> > #                             / _----=3D> need-resched
> > #                            | / _---=3D> hardirq/softirq
> > #                            || / _--=3D> preempt-depth
> > #                            ||| /     delay
> > #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> > #              | |       |   ||||       |         |
> >      gvfsd-trash-2224  [004] .... 333095.401381:
> > smb3_query_info_compound_enter: xid=3D5 sid=3D0xbb2583e9 tid=3D0xe7ab49=
dc
> >      gvfsd-trash-2224  [002] .... 333095.402056:
> > smb3_query_info_compound_err: xid=3D5 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > rc=3D-2
> >      gvfsd-trash-2224  [002] .... 333095.402189:
> > smb3_query_info_compound_enter: xid=3D6 sid=3D0xbb2583e9 tid=3D0xe7ab49=
dc
> >      gvfsd-trash-2224  [002] .... 333095.402688:
> > smb3_query_info_compound_err: xid=3D6 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > rc=3D-2
> >            mkdir-16324 [002] .... 333123.559043:
> > smb3_query_info_compound_enter: xid=3D7 sid=3D0xbb2583e9 tid=3D0xe7ab49=
dc
> >            mkdir-16324 [003] .... 333123.559654:
> > smb3_query_info_compound_err: xid=3D7 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > rc=3D-2
> >            mkdir-16324 [003] .... 333123.559673: smb3_mkdir_enter:
> > xid=3D8 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> >            mkdir-16324 [003] .... 333123.560748: smb3_mkdir_done:
> > xid=3D8 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> >            mkdir-16324 [003] .... 333123.560763:
> > smb3_query_info_compound_enter: xid=3D8 sid=3D0xbb2583e9 tid=3D0xe7ab49=
dc
> >            mkdir-16324 [003] .... 333123.561516:
> > smb3_query_info_compound_done: xid=3D8 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
> >            mkdir-16325 [002] .... 333126.841897:
> > smb3_query_info_compound_enter: xid=3D9 sid=3D0xbb2583e9 tid=3D0xe7ab49=
dc
> >            mkdir-16325 [003] .... 333126.842580:
> > smb3_query_info_compound_err: xid=3D9 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> > rc=3D-2
> >            mkdir-16325 [003] .... 333126.842601: smb3_mkdir_enter:
> > xid=3D10 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> >            mkdir-16325 [003] .... 333126.843513: smb3_mkdir_done:
> > xid=3D10 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> >            mkdir-16325 [003] .... 333126.843529:
> > smb3_query_info_compound_enter: xid=3D10 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> >            mkdir-16325 [003] .... 333126.844251:
> > smb3_query_info_compound_done: xid=3D10 sid=3D0xbb2583e9 tid=3D0xe7ab49=
dc
> >            mkdir-16326 [000] .... 333129.858413:
> > smb3_query_info_compound_enter: xid=3D11 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> >            mkdir-16326 [000] .... 333129.859193:
> > smb3_query_info_compound_done: xid=3D11 sid=3D0xbb2583e9 tid=3D0xe7ab49=
dc
> >            rmdir-16328 [007] .... 333138.828049:
> > smb3_query_info_compound_enter: xid=3D12 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> >            rmdir-16328 [007] .... 333138.828827:
> > smb3_query_info_compound_done: xid=3D12 sid=3D0xbb2583e9 tid=3D0xe7ab49=
dc
> >            rmdir-16329 [006] .... 333141.388154:
> > smb3_query_info_compound_enter: xid=3D14 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> >            rmdir-16329 [006] .... 333141.388813:
> > smb3_query_info_compound_err: xid=3D14 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
> > rc=3D-2
> >               rm-16340 [006] .... 333157.935975:
> > smb3_query_info_compound_enter: xid=3D15 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> >               rm-16340 [006] .... 333157.936607:
> > smb3_query_info_compound_err: xid=3D15 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
> > rc=3D-2
> >               rm-16340 [006] .... 333157.936652:
> > smb3_query_info_compound_enter: xid=3D16 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> >               rm-16340 [006] .... 333157.937146:
> > smb3_query_info_compound_err: xid=3D16 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
> > rc=3D-2
> >            touch-16349 [005] .... 333184.932302:
> > smb3_set_info_compound_enter: xid=3D18 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
> >            touch-16349 [005] .... 333184.938303:
> > smb3_set_info_compound_done: xid=3D18 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> >               rm-16350 [003] .... 333187.920309:
> > smb3_query_info_compound_enter: xid=3D20 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> >               rm-16350 [003] .... 333187.920999:
> > smb3_query_info_compound_done: xid=3D20 sid=3D0xbb2583e9 tid=3D0xe7ab49=
dc
> >               rm-16350 [003] .... 333187.921043: smb3_delete_enter:
> > xid=3D21 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> >               rm-16350 [003] .... 333187.921870: smb3_delete_done:
> > xid=3D21 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> >            touch-16361 [005] .... 333237.447252:
> > smb3_set_info_compound_enter: xid=3D23 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
> >            touch-16361 [005] .... 333237.448044:
> > smb3_set_info_compound_done: xid=3D23 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> >               ln-16366 [000] .... 333250.734035:
> > smb3_query_info_compound_enter: xid=3D25 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> >               ln-16366 [001] .... 333250.734689:
> > smb3_query_info_compound_err: xid=3D25 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
> > rc=3D-2
> >               ln-16366 [001] .... 333250.734735:
> > smb3_query_info_compound_enter: xid=3D26 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> >               ln-16366 [001] .... 333250.735368:
> > smb3_query_info_compound_done: xid=3D26 sid=3D0xbb2583e9 tid=3D0xe7ab49=
dc
> >               ln-16366 [001] .... 333250.735413:
> > smb3_query_info_compound_enter: xid=3D27 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> >               ln-16366 [001] .... 333250.735947:
> > smb3_query_info_compound_err: xid=3D27 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
> > rc=3D-2
> >               ln-16366 [001] .... 333250.735973: smb3_hardlink_enter:
> > xid=3D28 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> >               ln-16366 [001] .... 333250.736679: smb3_hardlink_done:
> > xid=3D28 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> >            gmain-2225  [000] .... 333250.736855:
> > smb3_query_info_compound_enter: xid=3D29 sid=3D0xbb2583e9 tid=3D0xe7ab4=
9dc
> >            gmain-2225  [001] .... 333250.737527:
> > smb3_query_info_compound_done: xid=3D29 sid=3D0xbb2583e9 tid=3D0xe7ab49=
dc
>
> Let's add full paths to the logs to increase usability - this way we
> can match logs with particular actions in the user space.

ok - will add

> Also please don't remove the blank line - the 2nd change in the patch:

That was a typo - will fix



--=20
Thanks,

Steve
