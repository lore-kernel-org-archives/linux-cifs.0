Return-Path: <SRS0=XnNO=4O=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F73C4BA21
	for <linux-cifs@archiver.kernel.org>; Wed, 26 Feb 2020 18:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 859D520732
	for <linux-cifs@archiver.kernel.org>; Wed, 26 Feb 2020 18:41:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vp5Jdbzz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgBZSlz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 Feb 2020 13:41:55 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36610 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgBZSly (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 Feb 2020 13:41:54 -0500
Received: by mail-lf1-f65.google.com with SMTP id f24so106487lfh.3
        for <linux-cifs@vger.kernel.org>; Wed, 26 Feb 2020 10:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SpR1A8GYcNRetSMIHu0sHaILHgLhzAd06/vNPuRBuf0=;
        b=Vp5JdbzzTN7oJYTkTUKns7LwWdAzfT5PacphMKDjBRDEjr/HkBnxXmcqAcIvXe1+mn
         FscFKNOYN3nw0qqI6cLIA3Eao9vmE9sLhOOHauwY4lBTY5iOUHjkH6HhwYD96ayTXgE4
         NJod8HMw3tkV4/akAr7A3oVG3xoJRgfcBmxOWAAag3KSGpyYquQwzG+YWo3EcnFZGLXE
         ERcsa14K8ZWb8rTprTL6Bx3WJDNqXGKQLekGdqmODb5gSaIBNzz8WnUpEFoLiuZH4Ha7
         B4B3tsKLXyBX75Ru8gtugT68LjChr+3fzpQdMd4Do/KzeAcx8voJKNJbMb9l/6CSjRu+
         OF/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SpR1A8GYcNRetSMIHu0sHaILHgLhzAd06/vNPuRBuf0=;
        b=ohrOBWxi4IsAUvYhZccyFWgUxMT6VgE7GZQ1G7YrJ/i1Adwpt6rTfLHD0Vb6EM15A1
         HL123fEwUgvzqJPd+xv2byNkFqcKSc8SZ5xIXVjUSixTbKPnBTnNIsPx0SkiSc0AsARo
         UlefvsSnpI050w3o5788f5VxDsdpBmZtjskPF79Vk8CkxXZgZ7OIAoa+ZeDS4lV+fPVk
         PtqhaRcANC6p4lNfG0HR42E2eTrHcuYpsojMV5mNioYsR/uj92gnlAlyDPPFRCkIWcZV
         hhm3gRMcMVcGoRai9dJyl+/CUejAI70b8YcDnN3H5EGW8hexg0+UTAh3e+wwJQ/mWm2c
         bNHA==
X-Gm-Message-State: ANhLgQ3q9xdyaSPju0/bGbfG66bnUflVTt0Pe0O5Q0lDjb9EYNH6PArU
        NtNkaawMaHNrr/q7SbXx83V0ehvHNHJAYBLSCg==
X-Google-Smtp-Source: ADFU+vvdPqSOIEIdmSPFBTgG8rRJ0KrUAu6ajQc+x+YvraJvtvNv+Y3muq567r6DccBmgFFOKRNJ5Z1+IPxb7juOCoE=
X-Received: by 2002:a05:6512:10ca:: with SMTP id k10mr22002lfg.154.1582742512267;
 Wed, 26 Feb 2020 10:41:52 -0800 (PST)
MIME-Version: 1.0
References: <20200221023001.vcoc5f43rdqqeifn@xzhoux.usersys.redhat.com> <20200226153941.xv7xsrh623zp3s7w@xzhoux.usersys.redhat.com>
In-Reply-To: <20200226153941.xv7xsrh623zp3s7w@xzhoux.usersys.redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 26 Feb 2020 10:41:40 -0800
Message-ID: <CAKywueTiCvkA4xtaAhDHdcNLP2tbNc5sWv-9Q_9uqsppCge9kQ@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: allow unlock flock and OFD lock across fork
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 26 =D1=84=D0=B5=D0=B2=D1=80. 2020 =D0=B3. =D0=B2 07:39, Murph=
y Zhou <jencce.kernel@gmail.com>:
>
> On Fri, Feb 21, 2020 at 10:30:01AM +0800, Murphy Zhou wrote:
> > Since commit d0677992d2af ("cifs: add support for flock") added
> > support for flock, LTP/flock03[1] testcase started to fail.
> >
> > This testcase is testing flock lock and unlock across fork.
> > The parent locks file and starts the child process, in which
> > it unlock the same fd and lock the same file with another fd
> > again. All the lock and unlock operation should succeed.
> >
> > Now the child process does not actually unlock the file, so
> > the following lock fails. Fix this by allowing flock and OFD
> > lock go through the unlock routine, not skipping if the unlock
> > request comes from another process.
> >
> > Patch has been tested by LTP/xfstests on samba and Windows
> > server, v3.11, with or without cache=3Dnone mount option.
>
> Also tested with or without "nolease" mount option. No new
> issue shows.
>

Great, thanks!
--
Best regards,
Pavel Shilovsky
