Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1590C433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 22:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A004D61359
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 22:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234212AbhKGWxS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Nov 2021 17:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbhKGWxR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 Nov 2021 17:53:17 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26782C061570
        for <linux-cifs@vger.kernel.org>; Sun,  7 Nov 2021 14:50:34 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id h11so25919234ljk.1
        for <linux-cifs@vger.kernel.org>; Sun, 07 Nov 2021 14:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2GtFYuxR5BdG/49NKnBrl6uliEOPWvKPtuddb7Q+RcI=;
        b=eGsRlAE5lNxUXhcqr9stL3nR/83pVrxGcxjbuUKZcro4fHxEcj0ks+BWvbrPnvjsnn
         BzHJk+5EMGG5DjpyLla5KbfLgHLk463dKsfgE3oKwotX5mZDE0OIyj/4yIZ7CWwpigBo
         pZYoM+sULrfI1tQdHokyXSianKE7M8Lyvfvowsj9RLfn3W8n8JOpmyF/yaM+hF2VWmQA
         yDaKDKbQtc6oV3qGLZZ9p1zi15V/jBZ5Rpvet1KZLl2oNzTQmZVzG5aDaPwxeVL1C2j+
         5yle8xIVqke07CDJyEh8E68OXoK8+xQ7SYKa5QyVe7qs79OsYERyPTS80ntMI8/mmtrA
         p8eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2GtFYuxR5BdG/49NKnBrl6uliEOPWvKPtuddb7Q+RcI=;
        b=CQOBJIwlCq3rXOUfm4/IZagSqchZdYpMdeaaw7kpPq1Zrd1mjkHLCVqfekctoPVWE9
         ntJBcz5VNFcMtEBH9zep94phBeF9LbL3UI+YNXKV0jnIUXv7XzExsIu5OMGQteuRahH4
         9lLKFVtgSBe+YwR22AqGeEPQHgHHYKz4btQDM4MEQDsdJS8d5HWy7RAgB9b1ACPfwZIa
         0laHmiOJzqRt1UstD48tYeFAJjOcJhUNommTWzwW4w2KCWny6BgIaNeUR3/GV0YzwJw+
         ssHn33zzW+yYfyb8CGnt8MwdCdWe9kx7wPcOUOEjsQRiXKFqxk01ZcmZEFtv2rVxZes4
         zIwg==
X-Gm-Message-State: AOAM533ImbzpydFVHfL1fc8odkbTk/2PNv6szFKFAY+TGxv8qwkvFYwB
        sEVnuIu/UDXRwNrO2PVIJYPW0hAiXMc77Uf1e8A=
X-Google-Smtp-Source: ABdhPJxFlm9fjwX4pYn4BPUBuPlI6qxyIYHFZaJ/HuSqUsOEUTpmT96HRFHmEK2z/u+iR6yXovnohjYlungXgAMhALQ=
X-Received: by 2002:a2e:7114:: with SMTP id m20mr5378816ljc.229.1636325432322;
 Sun, 07 Nov 2021 14:50:32 -0800 (PST)
MIME-Version: 1.0
References: <24b60b8a-febb-cee9-d96b-d7b8469309a4@gmail.com>
 <YYhI1bpioEOXnFYf@jeremy-acer> <YYhJ+8ehPFX1XDhv@jeremy-acer>
 <7abcce96-9293-cd47-780b-cdc971da07e5@gmail.com> <YYhXjG46ZZ1tqpxJ@jeremy-acer>
In-Reply-To: <YYhXjG46ZZ1tqpxJ@jeremy-acer>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 7 Nov 2021 16:50:21 -0600
Message-ID: <CAH2r5mvrPj5b460CeRT9+MNc1fOzwMixqsCN82v8KP_d+bgO2w@mail.gmail.com>
Subject: Re: Permission denied when chainbuilding packages with mock
To:     Jeremy Allison <jra@samba.org>
Cc:     Julian Sikorski <belegdol@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

That is interesting ... and weird.   Why would POSIX allow doing
something write related (fsync) without write permission?

To work around this (especially if the server is reliable enough) -
simply mount with "nostrictsync" (we will write out cached writes to
the server on flush, but won't send the fsync).

Will look at it more.

On Sun, Nov 7, 2021 at 4:47 PM Jeremy Allison <jra@samba.org> wrote:
>
> On Sun, Nov 07, 2021 at 11:15:49PM +0100, Julian Sikorski wrote:
> >Hi,
> >
> >thanks for responding. I am using loglevel 10. I have uploaded the
> >logs to my dropbox as they are too big to attach:
> >
> >https://www.dropbox.com/sh/r4b7q7ti2zmtlu9/AACqFY0FW2oW41Vu8l3nLZJSa?dl=0
> >
> >The problem happens around 15:45:48. Do the logs show what access mask
> >the fsp is being opened with you requested?
> >I am using quite an old samba server (4.9.5+dfsg-5+deb10u1) due to the
> >fact that openmediavault is based off debian 10 and there are no samba
> >backports available. Having said that, this configuration can work, as
> >shown by goffice/goffice-0.10.50-1.fc35.src.rpm rebuild and the fact
> >that it was working before for months previously.
>
> The error is occurring on the file:
>
> /srv/dev-disk-by-label-omv/julian/kernel/results/fedora-35-x86_64/goffice-0.10.50-2.fc35/goffice-devel-0.10.50-2.fc35.x86_64.rpm
>
> this is a regular file, not a directory
> opened with ACCESS_MASK: 0x00120089
>
> that is:
>
> SEC_STD_SYNCHRONIZE|
> SEC_STD_READ_CONTROL|
> SEC_FILE_READ_ATTRIBUTE|
> SEC_FILE_READ_EA|
> SEC_FILE_READ_DATA
>
> so indeed, this is being opened *without*
> SEC_FILE_WRITE_DATA|SEC_FILE_APPEND_DATA
> so smbd is correct in returning ACCESS_DENIED
> to an SMB2_FLUSH call.
>
> Looks like this is a client bug, in that it
> is passing a Linux fsync(fd) call directly
> to the SMB2 server without checking if the
> underlying file is open for write access.
>
> In this case, the SMB2 client should just
> return success to the caller, as any SMB_FLUSH
> call will always return ACCESS_DENIED on a
> non-writable file handle, and according to
> Linux semantics calling fsync(fd) on an fd
> open with O_RDNLY should return success.
>
> Steve, over to you :-).
>
> Jeremy.



-- 
Thanks,

Steve
