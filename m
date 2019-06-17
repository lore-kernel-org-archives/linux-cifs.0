Return-Path: <SRS0=A3cw=UQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F0F2C31E5B
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Jun 2019 20:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 417B220644
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Jun 2019 20:46:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ic/kMytF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfFQUqA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Jun 2019 16:46:00 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:36961 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbfFQUqA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Jun 2019 16:46:00 -0400
Received: by mail-io1-f65.google.com with SMTP id e5so24482664iok.4
        for <linux-cifs@vger.kernel.org>; Mon, 17 Jun 2019 13:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+8iBOIYe8GRatRwuo0ZhzDzIL9QDN0BlutcHT01yG1Y=;
        b=Ic/kMytFAlDVHquNuF3iJ0MPK3s5zHg3L3ej0cljUgufAJyzmEW9/2NZEBA8VlWFmx
         a8vKm2t9dkyZjygL+nem2VuBTzrZ9VdkmHj7hwEB65uBC1V/kR+ynErnyRYHdNDdJB9P
         gd4wXPUdUr9iWRo0pptdktWWdOFeJgE/M2CVNL8jNSCtLRKunM6H4FZfhatTxkafxjTB
         x/kYPpKae6n2uPdDqp+swQHR0QSWr4+iFgju1s3445QthdQqjqU48MFYE7AGktYvLZgK
         C5oSU6/ZIF98w+IZ8aBSia4i2KmisgAdWw3Irp3Kc5BGJdNvcyDvQlolVDfroW7smWmJ
         /Cfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+8iBOIYe8GRatRwuo0ZhzDzIL9QDN0BlutcHT01yG1Y=;
        b=edRxfTeJgGjbE2zeDObOxqDCi4Kc59eT9mefnG/KMSmxwi4ZqIcXsCrcW9khTdtoY4
         x2BGXRBdszUPJhLxNhn44/JDjxUPyLsOK/uevBnFWkhJSrJ8qtEP4DzPuJdM0Er9rmFF
         nvYjlI/M8KudscNVKf1Uldi2wqT36yj/0tyUURXznpZ4ELpmvoDrPIkkGTdX4yxK4FCb
         wC5qnrzZWiAznQWFWMwZ6tJUNDuG7nTAUV4nbE9HHLtOHZK2C+PgKcVSHXrIuJBSXA0N
         KANhFn/rsygt1RuLxW7v6cwMnACP8yY2WNcvoMJlRjmRvTdnbKQlKPw9oYQ1iKY6UJ+z
         fcDw==
X-Gm-Message-State: APjAAAWanxCyxP4jVC9SLduLXnR33QE5BH/tqgC63+PsiryDQmOumqOb
        gIp1xarHR3hSKBu4WMmCLWrJ0R0l6/64uSH5eyk=
X-Google-Smtp-Source: APXvYqxgEZU7D3sHOzwxv7XhU18d3gA8LyIGfa40yJTz4WU1/mOz0fG65h/Bsznvmjv/M2VJ9O+pjdDiIkBb62zrCK8=
X-Received: by 2002:a6b:4f14:: with SMTP id d20mr543532iob.219.1560804359714;
 Mon, 17 Jun 2019 13:45:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvo9sWf8VoPb8puCDh4HM6WnrMgjs+HyhUzqEZXtuQwtA@mail.gmail.com>
 <CAH2r5mtC5cXkhAVrioy_cLeoTq_4Jq0nw3CR4HTiEP_twSSKJg@mail.gmail.com>
In-Reply-To: <CAH2r5mtC5cXkhAVrioy_cLeoTq_4Jq0nw3CR4HTiEP_twSSKJg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 18 Jun 2019 06:45:48 +1000
Message-ID: <CAN05THQaHUATgVy=5AKksQ+FciLxP=uuC1PwHe5gLm+g=Qz-aw@mail.gmail.com>
Subject: Re: NT_STATUS_INSUFFICIENT_RESOURCES and retrying writes to Windows
 10 servers
To:     Steve French <smfrench@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        Paulo Alcantara <paulo@paulo.ac>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Tue, Jun 18, 2019 at 5:51 AM Steve French <smfrench@gmail.com> wrote:
>
> Attached is a patch with updated comments and cc:stable:
>
>
> On Sat, Jun 15, 2019 at 11:18 PM Steve French <smfrench@gmail.com> wrote:
> >
> > By default large file copy to Windows 10 can return MANY potentially
> > retryable errors on write (which we don't retry from the Linux cifs
> > client) which can cause cp to fail.
> >
> > It did look like my patch for the problem worked (see below).  Windows
> > 10 returns *A LOT* (about 1/3 of writes in some cases I tried) of
> > NT_STATUS_INSUFFICIENT_RESOURCES errors (presumably due to the
> > 'blocking operation credit' max of 64 in Windows 10 - see note 203 of
> > MS-SMB2).
> >
> > "<203> Section 3.3.4.2: Windows-based servers enforce a configurable
> > blocking operation credit,
> > which defaults to 64 on Windows Vista SP1, Windows 7, Windows 8,
> > Windows 8.1, and, Windows 10,
> > and defaults to 512 on Windows Server 2008, Windows Server 2008 R2,
> > Windows Server 2012 ..."
> >
> > This patch did seem to work around the problem, but perhaps we should
> > use far fewer credits when mounting to Windows 10 even though they are
> > giving us enough credits for more? Or change how we do writes to not
> > do synchronous writes? I haven't seen this problem to Windows 2016 or
> > 2019 but perhaps the explanation on note 203  is all we need to know
> > ... ie that clients can enforce a lower limit than 512
> >
> > ~/cifs-2.6/fs/cifs$ git diff -a
> > diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
> > index e32c264e3adb..82ade16c9501 100644
> > --- a/fs/cifs/smb2maperror.c
> > +++ b/fs/cifs/smb2maperror.c
> > @@ -457,7 +457,7 @@ static const struct status_to_posix_error
> > smb2_error_map_table[] = {
> >         {STATUS_FILE_INVALID, -EIO, "STATUS_FILE_INVALID"},
> >         {STATUS_ALLOTTED_SPACE_EXCEEDED, -EIO,
> >         "STATUS_ALLOTTED_SPACE_EXCEEDED"},
> > -       {STATUS_INSUFFICIENT_RESOURCES, -EREMOTEIO,
> > +       {STATUS_INSUFFICIENT_RESOURCES, -EAGAIN,
> >                                 "STATUS_INSUFFICIENT_RESOURCES"},
> >         {STATUS_DFS_EXIT_PATH_FOUND, -EIO, "STATUS_DFS_EXIT_PATH_FOUND"},
> >         {STATUS_DEVICE_DATA_ERROR, -EIO, "STATUS_DEVICE_DATA_ERROR"},
> >
> >
> > e.g. see the number of write errors in my 8GB copy in my test below
> >
> > # cat /proc/fs/cifs/Stats
> > Resources in use
> > CIFS Session: 1
> > Share (unique mount targets): 2
> > SMB Request/Response Buffer: 1 Pool size: 5
> > SMB Small Req/Resp Buffer: 1 Pool size: 30
> > Operations (MIDs): 0
> >
> > 0 session 0 share reconnects
> > Total vfs operations: 363 maximum at one time: 2
> >
> > 1) \\10.0.3.4\public-share
> > SMBs: 14879
> > Bytes read: 0  Bytes written: 8589934592
> > Open files: 2 total (local), 0 open on server
> > TreeConnects: 3 total 0 failed
> > TreeDisconnects: 0 total 0 failed
> > Creates: 12 total 0 failed
> > Closes: 10 total 0 failed
> > Flushes: 0 total 0 failed
> > Reads: 0 total 0 failed
> > Writes: 14838 total 5624 failed
> > ...
> >
> > Any thoughts?
> >
> > Any risk that we could run into places where EAGAIN would not be
> > handled (there are SMB3 commands other than read and write where
> > NT_STATUS_INSUFFICIENT_RESOURCES could be returned in theory)
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
