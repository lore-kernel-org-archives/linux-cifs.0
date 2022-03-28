Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10649C433FE
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Mar 2022 22:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiC1WOA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiC1WNw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Mar 2022 18:13:52 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6991180211
        for <linux-cifs@vger.kernel.org>; Mon, 28 Mar 2022 15:03:36 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2e6ceb45174so124921027b3.8
        for <linux-cifs@vger.kernel.org>; Mon, 28 Mar 2022 15:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7FHAZ8S7LPQD/oxAjssWALknO1+bYyZdp0Z+a4ZiiJU=;
        b=DbC2D5aoK6IlOlhRB96tUyujk0j8UnXPRqI4DlbQuFMZpVug8O5GnlorK8BwuFj7Hx
         hIqflxI+A7WcmiYZFNOzIHBBmOe+BdWSIXINd6NIRa+6F4ZvI+bXiJKetF3TwrFIRzh0
         cTvlA/mBFQX+J07T9Z8EGWDPmP/gJm9fyQ//zlXdepkcHcb3xNob2qMeXnSQAlrrjBoE
         36q64DcvzqsX2i2ROBYHqkoSzxW9HGSF8yAkTp34klRUubXnSE7FdVPwUl00iUQ0HQQy
         Vm1Mlx0dTGb/fMOgwn8K+DT/rooIgelKgBKaq+pvdXdZZ6aiqxOmY9/WtHwB5qmP9+e+
         5LQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7FHAZ8S7LPQD/oxAjssWALknO1+bYyZdp0Z+a4ZiiJU=;
        b=YbfBbDFJPfCXBqKv9HQvTVKQPucb+98+gMsbP5/mcCA26pQ5UQzSmdQuzDf/xoKHoa
         zUsrVNhCNrN/rywLnFDEuSrIRqa06DxIy0kcbmYSORD/OsTfhDrccTBT1hip4B8WfLy9
         rzmtbXegpzlahpoejihZ46OAsitiZj/ejM90+xY8qmtU/d7D05YbNrS/4Nfesr6JeQz0
         RZP7iILrsO8SAvdBwPYXLofIBzX4UhkXkwFaXoJd15kK8yNmFVROYelC4oucSpHSOfpB
         BcUzLWH/rV4Jy3Wc5/Wrm+C7BMSxDutnMY6st67Y/Dz0Z9TiFHe8DD/1c163zcQBRTyJ
         //2g==
X-Gm-Message-State: AOAM530+/uYqJe54Y1QqSJMEdrg2d70wlxy/gjHeXXc3mbs8ahZpZukw
        NMAQAEtiKZuqR46vTcDx/0/wGN4Pv2oPgAwJFM7x2aTp
X-Google-Smtp-Source: ABdhPJxTVdEViNtuBXYMMGYeMu0h5q06T2mKcNaYypkrjlnprFbHz/+2oNhNxEWZyBnLws98wdi2rs/W3JL25hqCprY=
X-Received: by 2002:a81:ad67:0:b0:2e5:8466:322a with SMTP id
 l39-20020a81ad67000000b002e58466322amr27481812ywk.54.1648505015584; Mon, 28
 Mar 2022 15:03:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msLJ166+yuHWQnV7_10_SZ3R1RmMwgLyGMBbggcYks1hQ@mail.gmail.com>
 <CAH2r5mu7q4yUO-qgY+A=Gjv4cDWGZrhHi0Yr01Zx-W1nE36Rvg@mail.gmail.com>
In-Reply-To: <CAH2r5mu7q4yUO-qgY+A=Gjv4cDWGZrhHi0Yr01Zx-W1nE36Rvg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 29 Mar 2022 08:03:24 +1000
Message-ID: <CAN05THS9TJMh7DtDxcqG3MFd+PhASRfZBaCEJd6Gyja+QEOapw@mail.gmail.com>
Subject: Re: [PATCH][CIFS] cleanup and clarify status of tree connections
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good to me.

Reviewed-by me

On Mon, Mar 28, 2022 at 12:49 PM Steve French <smfrench@gmail.com> wrote:
>
> Updated patch to fix one place I missed pointed out by the kernel test robot.
>
> See attached.
>
> On Sun, Mar 27, 2022 at 4:14 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Currently the way the tid (tree connection) status is tracked
> > is confusing.  The same enum is used for structs cifs_tcon
> > and cifs_ses and TCP_Server_info, but each of these three has
> > different states that they transition among.  The current
> > code also unnecessarily uses camelCase.
> >
> > Convert from use of statusEnum to a new tid_status_enum for
> > tree connections.  The valid states for a tid are:
> >
> >             TID_NEW = 0,
> >             TID_GOOD,
> >             TID_EXITING,
> >             TID_NEED_RECON,
> >             TID_NEED_TCON,
> >             TID_IN_TCON,
> >             TID_NEED_FILES_INVALIDATE, /* unused, considering removing
> > in future */
> >             TID_IN_FILES_INVALIDATE
> >
> > It also removes CifsNeedTcon CifsInTcon CifsNeedFilesInvalidate and
> > CifsInFilesInvalidate from the statusEnum used for session and
> > TCP_Server_Info since they are not relevant for those.
> >
> > A follow on patch will fix the places where we use the
> > tcon->need_reconnect flag to be more consistent with the tid->status
> >
> > See attached.
> >
> > Also FYI - Shyam had a work in progress patch to fix and clarify the
> > ses->status enum
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve
