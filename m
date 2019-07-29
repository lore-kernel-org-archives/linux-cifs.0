Return-Path: <SRS0=0u7K=V2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 174FDC433FF
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Jul 2019 16:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0555206BA
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Jul 2019 16:07:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hbYCx89r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbfG2QHj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 29 Jul 2019 12:07:39 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:46348 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfG2QHj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 29 Jul 2019 12:07:39 -0400
Received: by mail-pl1-f169.google.com with SMTP id c2so27664328plz.13
        for <linux-cifs@vger.kernel.org>; Mon, 29 Jul 2019 09:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L+BqzgwxZlFE9/XhA/Z7AVNrQrmz4IpGsvStJOpR64E=;
        b=hbYCx89r3OJnrbhBIUvQGSSpICZWPdgm7SOLJGy6MQn0sylUu/5wy78px7TEow71zI
         G93F0RxCVwetOpjHGAail96xpXTposIZLOWLctQv9yg59jEr+ZPqn3kKYeYrDPVbVudK
         ZEHxyyAclJHo4KXyCGvTVnou42Dxg0oXUa/nRDU8UwT5n8pgleCtvsWdGDt1zsVVo0pM
         evMLvh1PKzonW8/0z8G7bCPdH+42MCTAttVBIR2WW90EN136eNBQvqCWBUmb8GMzNiEo
         BC0BVD/ql/osCq8Xaoe9JM8+1z6N1mYZ2F6nzQDZOu+vXkWbilX0COrWuIUELJu1Yp6Z
         Uzig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L+BqzgwxZlFE9/XhA/Z7AVNrQrmz4IpGsvStJOpR64E=;
        b=D/x01IS+DTozHn9uuGMe8IWPnpFsD5Su+Hds8zIi190xhthp7QU0m1UEA0LNkMGRMo
         VBLoynIu606x+CRan0ZAFiINn6NLQvGr8QsHh9oCY3kjaxSsRALAkyfzMg9SVDHmBrk5
         gFeMB+zuw3KmZC6MsgZcW1Xly+U3X664XFkcQFEcttFbPIiEXW3uMvmmNMDPq3bJhnJ5
         C0WI8plQf3Xdi/Qi/0nk7x2pw4cD8Oyzf/wgCof/oMA568kqfh5un8ZP200y1wC5lqLI
         mkbuM2mU4JvMaBM1fnzQzy468IO8QqgcKTtAuK5SNsp18nVAwumXqW0XorK5SHJ6H/yB
         aUpg==
X-Gm-Message-State: APjAAAUiumODHPnSY54x6q64kIRHEfKyaIWDsJTddQgkCRg864b3D8pH
        jud/KVf1RUJjJfYjvykd7gE1kwF8Wc5ahhjHenDIxocqabs=
X-Google-Smtp-Source: APXvYqz9HZzCaLYj5au44B1BoMIInnYDFUEXN1EBlV6r2NrUPqvp3BjGarvFZLY/++1zOCsxkux+ak1Eo42HZbs0y5c=
X-Received: by 2002:a17:902:2a68:: with SMTP id i95mr112932457plb.167.1564416457835;
 Mon, 29 Jul 2019 09:07:37 -0700 (PDT)
MIME-Version: 1.0
References: <CANidX5ScMgPfd_7N9QMTv3+nhzBxtE7tQVhrAncjrH0JG7q4vg@mail.gmail.com>
 <CAH2r5msU5Qkxcr-kM5seH_2HoUz=hkO+VDCjdEFCPRZh=a3W7A@mail.gmail.com> <CANidX5SRoxMHtm042arPxMUXP1SCoYOkg1SMxYL7RMvzW6mnGA@mail.gmail.com>
In-Reply-To: <CANidX5SRoxMHtm042arPxMUXP1SCoYOkg1SMxYL7RMvzW6mnGA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 29 Jul 2019 11:07:26 -0500
Message-ID: <CAH2r5msVTQKE6CL8V+KfNq+oOKzoH3B4MGiNGmY5gfSD7X-Qqw@mail.gmail.com>
Subject: Re: Search for advice on testing whether a local CIFS fd closed remotely
To:     Gefei Li <gefeili.2013@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Presumably the attempt to close a file (from the Linux client) which
the server has force closed on their side, would lead to
/proc/fs/cifs/Stats logging an error on close.   It is an unusual
situation to have a server force closed a handle in such a way that it
would return an error on an attempt by an SMB3 client to use it (more
typical would be for a resource constrained server to expire the
session and let the client reconnect its open handles as needed).

To test use of directory handles after a force close of server handles
(ie for the unusual case where the file handle is force closed on the
server side through some tool, but the client has the file still
open), you could try something similar to the "PASSTHRU_FSCTL" for
doing a query info (see e.g. the function fsctlgetobjid in cifs-utils
package smbinfo.c) after you have left a directory handle open long
enough for your force close on the server side to be done.

This is an unusual scenario though where you want to have the server
throw away state (network file handles open on a connection) without
killing the smb session (in which case the client can reconnect
transparently).

On Sun, Jul 28, 2019 at 10:03 PM Gefei Li <gefeili.2013@gmail.com> wrote:
>
> Thanks a lot for the '/proc/fs/cifs/Stats | grep "Open files"' tip,
> Steve. But it seems not working in my case(not crashing case).
>
> I have an SMB server that is able to close handles from server side,
> and if closed remotely I want to check from client side. I've done
> several experiments:
> 1. CIFS client open, server side close
>   -  both "/proc/fs/cifs/Stats" and "cat /proc/fs/cifs/open_files"
> remain unchanged
> 2. CIFS client open, server side close, client side call "close"
> function to check fd
>   - "Closes" in "/proc/fs/cifs/Stats" changes "4 total 1 failed"    <-
> 1 failed due to server side closed?
> 3. CIFS client open, server side close, client side call "read"
> function to check fd
>   - EBADF returned while trying to "read", this is what I expect.  But
> for dir handle and WR-only handles, which function should I use?
>
> Regards,
> Gefei
>
> On Sun, Jul 28, 2019 at 8:08 AM Steve French <smfrench@gmail.com> wrote:
> >
> > On Fri, Jul 26, 2019 at 3:22 AM Gefei Li <gefeili.2013@gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > From some stack overflow result I know that on a local ext4/fat32
> > > system, we can test whether a file descriptor is valid through
> > > "fcntl(fd, F_GETFD)". But in cifs cases, a fd typically bind a local
> > > fd to remote handle, do we have some c function/syscall that can test
> > > whether the fd is remotely closed?
> > >
> > > I've tried some windows way like "ioctl", which works well, and in
> > > linux local file system "fcntl" works. Tried to use "fcntl" on kernel
> > > 5.1.15, found no server request is received.. Could you please give me
> > > some advice on testing whether a fd is remoted closed in CIFS client?
> >
> > both F_GETFD and F_GETFL look like they check in the local VFS only
> > (aren't passed down to the file system, whether ext4 or cifs or even nfs)
> > for the value of these flags (see do_fcntl function in fs/fcntl.c)
> >
> > In general an open of a file (over an SMB3 mount) will result in a open
> > over a file on the server.   You can see the detailed information on
> > the network file handle ("PersistentFileID") open on the server by (on
> > the Linux client) doing:
> >
> >        cat /proc/fs/cifs/open_files
> >
> > If you were worried about a network crash temporarily closing remote handles
> > (in which case you might temporarily have a local handle which is not
> > open on the
> > server) you could (in theory) do:
> >
> >       /proc/fs/cifs/Stats | grep "Open files"
> >
> > but I did notice a bug (in the processing of one of those counters for
> > that /proc file)
> > in which we are leaking one of those two counters (the counter is
> > informational only
> > so presumably not a serious bug) and it can go negative so looking at the count
> > of open files on the server may not be as useful.
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Thanks,

Steve
