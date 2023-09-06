Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF03EB8FA5
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Sep 2023 07:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbjIFHlZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Sep 2023 03:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbjIFHlY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Sep 2023 03:41:24 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8102E6E
        for <linux-cifs@vger.kernel.org>; Wed,  6 Sep 2023 00:41:08 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2bceb02fd2bso50427831fa.1
        for <linux-cifs@vger.kernel.org>; Wed, 06 Sep 2023 00:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693986067; x=1694590867; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oMdWZ8SGeUFcvJtPXdkx0vdysDKGo3KDkFuCvwvTSlA=;
        b=HuuKBHuU2EGXATYDRSMJWVlt3vDwd4/khWnGwnDKVtypL6qlp0HuQLsZuPSLgCa5Xo
         5hNRXdGQTMYSMkqyA09HzsohkpleQhLAs0VxbOFvo9+myxilVYWWTt10pZX7v2SGow/T
         Gf2zQvGB1BQ0hZJl2eTKa9C+mmmoVcPyUinYInOIObGULZpLACE01ajNVh8VTIEni5pB
         ZNOJA3HbdTNdj0lPmSgAng2K80HFf2ucyauGHPnx41KZttR4gLA1XaOyy/jN0fnQqVxx
         i2jDcioqoy8ONcJ6Upntr2jB0uMuNQPO+haa0lmwF3sp3Y0eKD/jy9h4BsS8OxIEqBsz
         9VCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693986067; x=1694590867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oMdWZ8SGeUFcvJtPXdkx0vdysDKGo3KDkFuCvwvTSlA=;
        b=bm89QxI4t/MyyZYP/YO5JnHacgjLL9UVdG3gR2IGg4Sz6Tqgr8+vVytA10U9/b6dwz
         2QIU043z0UKio6fgdHpDA5X36mn1reV5TVz3iM2YUNx9k7bIGT415aVk/FS6210TpbsK
         UEs2Vpx5qk/4dh5aerBKTXwjtjM5IBMLyBxRNtkxL2Hi8j20hEKGDrLlSv+CYnz3pvpM
         FXc8jIf6Nc8yThwyhbQtRkhPLIH9fUJcTHIs+UusgN9e9TfI9goIi4BI3HzGGU9q37L1
         Wbd82E4iuMJG2MVJHpq8WJEwqynbqGZHnRhkGZ77UipTetUB9EIqtE8qPJhrUSe4L7+H
         8XMQ==
X-Gm-Message-State: AOJu0YwcQQCWrn7D2ljXZaHaE8om5OnC7Kje1xOkyboIyMhUPg2/JwCI
        hu+rnifkD8cBbB0WaTKmbEjd94cjXEb8LTgXtmY=
X-Google-Smtp-Source: AGHT+IEjoWNY+hcGHTiNi1N18gdW603Gi2taEsre3PR5BmmTHRhLzUW/gkvY3aIM1JKy01dV3lVEtyPSzPoWWl6TnfU=
X-Received: by 2002:a2e:2419:0:b0:2bb:c22a:f28c with SMTP id
 k25-20020a2e2419000000b002bbc22af28cmr1559496ljk.32.1693986066920; Wed, 06
 Sep 2023 00:41:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mu0yS8zvrTSRcVqQEgDv_Qo8zmxUaJAajgLNoYEz7NOgg@mail.gmail.com>
In-Reply-To: <CAH2r5mu0yS8zvrTSRcVqQEgDv_Qo8zmxUaJAajgLNoYEz7NOgg@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 6 Sep 2023 13:10:55 +0530
Message-ID: <CANT5p=rj+REP7CgE7OBWcSpeG6K5Z=4SzezvE__pyTDT0E2rPw@mail.gmail.com>
Subject: Re: [PATCH][SMB3] add dynamic tracepoint for smb3_qfs_done
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Sep 1, 2023 at 12:06=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> Add trace point for queryfs (statfs)
>
> In debugging a recent performance problem with statfs, it would have
> been helpful to be able to trace the smb3 query fs info request
> more narrowly.  Add a trace point "smb3_qfs_done"
>
> Which displays:
>
>      stat-68950   [008] .....  1472.360598: smb3_qfs_done: xid=3D14
> sid=3D0xaa9765e4 tid=3D0x95a76f54 unc_name=3D\\localhost\test rc=3D0
>
>
> --
> Thanks,
>
> Steve

Looks good to me.

--=20
Regards,
Shyam
