Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC50FC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Mar 2022 16:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237734AbiC1Q3V (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Mar 2022 12:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbiC1Q3U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Mar 2022 12:29:20 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B056004B
        for <linux-cifs@vger.kernel.org>; Mon, 28 Mar 2022 09:27:39 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id yy13so29828287ejb.2
        for <linux-cifs@vger.kernel.org>; Mon, 28 Mar 2022 09:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ljxQBPHVpFniOG4UVvizBNgL/39CyDlxq97+DR8uD/w=;
        b=NW0YoHSbUnWElpSkEhfweH7BOQfoO/0vYeEOEX9/7zWrMQJWHhQJqwFwt5GnCoFfM/
         dhKM4DrdVIAdgof1TodcSA0/yVoNLp9hAy8yLtbgA/GU/c5FUf13lHVb8JkgwiaPtd4X
         R0QE8hnffGn/G6IL7trscorsgdpEx6C8H4mTAsJe5ZdE0s35rr8QQeOgB265lQUvxHix
         KBSFbTlGWY8pxOOK3lne450635Cb93PsUcJajHgQqm8TH0WxVtx0YLCQvmtFWLKTxMNZ
         Z5++lDVReB7nYWS9R5AWl81ML1Xp+kxUekxq623kpoyUnOPfOZYImmlN4mqqCSJA/yTE
         Mc9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ljxQBPHVpFniOG4UVvizBNgL/39CyDlxq97+DR8uD/w=;
        b=enRXWewr/i1uRQsFbJXpPml6GfKwT8DkZKuqKKIJ0lBEzlDqe69cB5kG3WotTkL2ja
         2jYApqlm73jp0thGFWKEPCSMT9Rv721aJ0dz4ZHrmX5drVmgkPUTT+jUFy0bKzaFtRlP
         zQpo1X7kALLWi4tLOk2TJEeLooPi5emYJ8YFH2w96iMffJKcKMjEdNLuEbcvJJ4afcPB
         2Uq0dXrXLejpQAILu0m54jPSotD8zMG86Eqqk/mzvMGHM+rq/SIGmzdy9oelHD8XiPl7
         M/vNkSJ2+/pDh6Cmf/VE8ROfU8qRkiCxrpJ685OUZAZJX7Wsz/329cWpjC0AF4lDevYj
         6UOw==
X-Gm-Message-State: AOAM530flZaeTr+BZ26+arZ80M9slmdwKHW/LGorib3wpcymfW+yzbwo
        hgGYOjCAhlZc7vlpxzOAxs1LB/iR9HANC1PSb3s+N/8h
X-Google-Smtp-Source: ABdhPJzSbHJz0CKpQc1ZB5cA0liok9s/uka163//oiym6F5xj0mpwjsbCL3kerhCxpYwRf3pgU+dgXwCOSo6m6Qdunk=
X-Received: by 2002:a17:906:d1c4:b0:6d5:83bb:f58a with SMTP id
 bs4-20020a170906d1c400b006d583bbf58amr28817836ejb.672.1648484858024; Mon, 28
 Mar 2022 09:27:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msLJ166+yuHWQnV7_10_SZ3R1RmMwgLyGMBbggcYks1hQ@mail.gmail.com>
 <CAH2r5mu7q4yUO-qgY+A=Gjv4cDWGZrhHi0Yr01Zx-W1nE36Rvg@mail.gmail.com>
In-Reply-To: <CAH2r5mu7q4yUO-qgY+A=Gjv4cDWGZrhHi0Yr01Zx-W1nE36Rvg@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 28 Mar 2022 21:57:26 +0530
Message-ID: <CANT5p=rUKVw4L5R6QsX+pHgRR8_hg3C+K1YEM==YAvLMLZ-0qw@mail.gmail.com>
Subject: Re: [PATCH][CIFS] cleanup and clarify status of tree connections
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Mar 28, 2022 at 7:17 AM Steve French <smfrench@gmail.com> wrote:
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

Please try to maintain the old values in the new enum.
Rest looks good.

-- 
Regards,
Shyam
