Return-Path: <SRS0=TaZu=3G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CDE2C33C9E
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 04:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11D912082F
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 04:48:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pu+rPYnG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgAQEsS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jan 2020 23:48:18 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:41732 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbgAQEsS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Jan 2020 23:48:18 -0500
Received: by mail-io1-f66.google.com with SMTP id m25so8982843ioo.8
        for <linux-cifs@vger.kernel.org>; Thu, 16 Jan 2020 20:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8gAo1V9znQ7t47L0/xlbEGazTNRJs4nKnBkcsrviBV0=;
        b=Pu+rPYnGFOo+DnyHDuDJxQmzIYbYaSXBIWVIIg6pvteWE3BKruYDmnE4NxYpOJyVun
         kjWxXBdzGuLPXojG4aq/uAQjqy7wRSSmjWU197kuPZ7Y3E+fu49vCUQYuBwGhQcsMvQr
         GJZBcHezM0xxMiHhnYQ60UbijdOEA3DPne9JI3JdceNE8udwCxWAwOLXQXtuyXIiLw4A
         Q4Weo2Sldv0Q/G/2/k5joBd4UZm+ZOanfZXETE23uBTsy4AM5EKsiMLfkOHGjgFdvOeD
         VobExottfvO55hpeO960O8WwhbgM+oubuW7GIS2K54BNDILanLIVgsYClmC/Gnf0gO3k
         ukEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8gAo1V9znQ7t47L0/xlbEGazTNRJs4nKnBkcsrviBV0=;
        b=E3e61B7XrOxCOiKu7k9OSKP7o/O0CAbYLcwqmz/9u9cTXBHXkj0O2TLJnuvXhxiUUE
         jO0BbwV1l6yE/i0CrqYgCrVKy4C3gDe8qpYZq9fpt493+ghTZYNsOjg55LvD1LN6c2I9
         5InpqPkCANyq/KHHV+YEw3EyrSDfa7/pJw4uFLbczlYfSyFpHmS0QWaiPonKbdggAxa5
         61oUnjGC4IyOR5mkJ+JY+WR24CdRTMmIxnajAVM484yH5+g+C87+TlgJpJ56f2Rhl67H
         DGsVo2ibA6aZ/PVdwpXYUwcJs2N428ueiKUWxGOSfDRD2AlQuXVaJe4/i093X76uPcWm
         3L7g==
X-Gm-Message-State: APjAAAWZyhyzbkChzOUx+h5VMYETfScyC9cnj2uMF/7y60FDZQzS8mOH
        QQESvtQOyrKy7LWn17M8Stp45MXr8OGGRyyR8gA=
X-Google-Smtp-Source: APXvYqylxdkj6uvkC9qhuOvk0YUcTcRFaGULMBDMQzttMeU3m7n3YYBX85vdw4gUlvYUsXeYtNolPi05N5VOPpkCjDY=
X-Received: by 2002:a6b:a06:: with SMTP id z6mr28093268ioi.5.1579236497563;
 Thu, 16 Jan 2020 20:48:17 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mvLCqTXVFG93AgSJHTu8daMLwV_hpbjgJs-7orUwr7ffg@mail.gmail.com>
 <644970174.6192265.1579230257768.JavaMail.zimbra@redhat.com>
In-Reply-To: <644970174.6192265.1579230257768.JavaMail.zimbra@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 16 Jan 2020 22:48:06 -0600
Message-ID: <CAH2r5mvGDLY0CN3i0R3sLK9exaGbTVohVNzRjh8-482mp-d_yg@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Fix modefromsid newly created files to allow more
 permission on server
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

updated with your suggestion and reviewed-by

On Thu, Jan 16, 2020 at 9:04 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Reviewed-By: Ronnie Sahlberg <lsahlber@redhat.com>
>
> But drop the extra parenthesises here :
> +                (2 * sizeof(struct cifs_ace));
>
> ----- Original Message -----
> From: "Steve French" <smfrench@gmail.com>
> To: "CIFS" <linux-cifs@vger.kernel.org>
> Sent: Friday, 17 January, 2020 12:28:03 PM
> Subject: [PATCH][SMB3] Fix modefromsid newly created files to allow more permission on server
>
>     When mounting with "modefromsid" mount parm most servers will require
>     that some default permissions are given to users in the ACL on newly
>     created files, and for files created with the new 'sd context' -
> when passing in
>     an sd context on create, permissions are not inherited from the parent
>     directory, so in addition to the ACE with the special SID (which contains
>     the mode), we also must pass in an ACE allowing users to access the file
>     (GENERIC_ALL for authenticated users seemed like a reasonable default,
>     although later we could allow a mount option or config switch to make
>     it GENERIC_ALL for EVERYONE special sid).
>
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
