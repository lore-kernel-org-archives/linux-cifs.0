Return-Path: <SRS0=bM6M=4H=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 290F5C34056
	for <linux-cifs@archiver.kernel.org>; Wed, 19 Feb 2020 18:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00C1224672
	for <linux-cifs@archiver.kernel.org>; Wed, 19 Feb 2020 18:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582138577;
	bh=RO+SxjwCSx2/qFP/8QJ2kYpYtpfH4O8dJvv2BSr0Efg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=HuBPomZ94mIdhRwqfTCPAni4ujcVp8Ir5TrUqpSVcIp6m7WnPcQcBmGkrQvLI/+U8
	 kYCGKZ66/jlD7TLFUr1YnlrR9uJpZQWtOCop8xInLGi5og+vmBuUz1GEtfAc2ZWAWX
	 pLRmUOVh2W1dtuh4r1fUrWxS05fJcIX8z+YaJl3g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgBSS4N (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 Feb 2020 13:56:13 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38701 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbgBSS4M (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 19 Feb 2020 13:56:12 -0500
Received: by mail-lf1-f65.google.com with SMTP id r14so971337lfm.5
        for <linux-cifs@vger.kernel.org>; Wed, 19 Feb 2020 10:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4/btNie2yJSHTlvtkEMVrzLJ5p+2iau4ZxcsT8Kh+V8=;
        b=OANlOLlls14aKMkL1WjVjo8f/tVbYdtb8Nt9MCvon8MWsZkBp2wf0M4h4HkivP25SY
         Lor+Pn5WeqeFiam04EJmGY4IF6tW7qKCzkRZwxbdgjj0f2w6R9Z2iIpFLl/G1lsUeweh
         z+TQEaepT45ebjzQ5n9r3U+GEMxGXZG+BGf8c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4/btNie2yJSHTlvtkEMVrzLJ5p+2iau4ZxcsT8Kh+V8=;
        b=SmmjUT2sUZm1l+BuI2tGS92Zu9uOhkAtX9vsO3/Q2mZICm1/yCOuhH8q3XDUY43l7D
         VuxY6qCKhsserpKC6HSPrvWlK0wv/Xk1RoZ4kV7e6wdLAMN7fH7ybSOHe3mVmDi/5t8e
         2pEL0lxxrOMgg1ISq5nc0UBJXv8ynM22f4R0razAIDfHiJiVAPtZ+bCxHSuxeINaAKuz
         PVqfrHX8flGl8YrlCvPc/ma7FVhAGBrVkjAteQ8wAz255cuonEowS7tctqCArTdfg47W
         TAyN9Y4d+NZjz/TFndat9YZ6gY6BvGbR+SJXoky1w0lm+APEIqyPqQSPAVhFyyb46kMs
         dtCQ==
X-Gm-Message-State: APjAAAXQX5fl0HSgmdMG/JruYj+Pl5Ss+2ErGPh/FLlleL193HWz53j1
        R6DiwLfIrJG50YeDyjw15347YqrBk4s=
X-Google-Smtp-Source: APXvYqwuin9LVRh7SoOIzFknB/lQ+0yNNlXKXu/Zn+6h3VaNYvInFr1jUjk+TW1IN/McH6uscunHGQ==
X-Received: by 2002:a19:ee1a:: with SMTP id g26mr14061923lfb.147.1582138569146;
        Wed, 19 Feb 2020 10:56:09 -0800 (PST)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id s17sm359636ljo.18.2020.02.19.10.56.07
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 10:56:08 -0800 (PST)
Received: by mail-lj1-f179.google.com with SMTP id q8so1516076ljb.2
        for <linux-cifs@vger.kernel.org>; Wed, 19 Feb 2020 10:56:07 -0800 (PST)
X-Received: by 2002:a2e:88c5:: with SMTP id a5mr16927004ljk.201.1582138567368;
 Wed, 19 Feb 2020 10:56:07 -0800 (PST)
MIME-Version: 1.0
References: <158212290024.224464.862376690360037918.stgit@warthog.procyon.org.uk>
 <CAMuHMdV+H0p3qFV=gDz0dssXVhzd+L_eEn6s0jzrU5M79_50HQ@mail.gmail.com>
 <227117.1582124888@warthog.procyon.org.uk> <CAHk-=wjFwT-fRw0kH-dYS9M5eBz3Jg0FeUfhf6VnGrPMVDDCBg@mail.gmail.com>
 <241568.1582134931@warthog.procyon.org.uk>
In-Reply-To: <241568.1582134931@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 19 Feb 2020 10:55:51 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi=UbOwm8PMQUB1xaXRWEhhoVFdsKDSz=bX++rMQOUj0w@mail.gmail.com>
Message-ID: <CAHk-=wi=UbOwm8PMQUB1xaXRWEhhoVFdsKDSz=bX++rMQOUj0w@mail.gmail.com>
Subject: Re: [RFC PATCH] vfs: syscalls: Add create_automount() and remove_automount()
To:     David Howells <dhowells@redhat.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Al Viro <viro@zeniv.linux.org.uk>, coda@cs.cmu.edu,
        linux-afs@lists.infradead.org, CIFS <linux-cifs@vger.kernel.org>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Feb 19, 2020 at 9:55 AM David Howells <dhowells@redhat.com> wrote:
>
> There's a file type beyond file, dir and symlink that AFS supports:
> mountpoint.  It appears as a directory with no lookup op in Linux - though it
> does support readlink.  When a client walks over it, it causes an automount of
> the volume named by the content of the mountpoint "file" on that point.  NFS
> and CIFS have similar things.

Honestly, AFS isn't common or relevant enough to make this worth a new
special system call etc.

Why don't you just use mkdir with S_ISVTX set, or something like that?
Maybe we can even add a new mode bit and allow you to set that one.

And why would removal be any different from rmdir()?

Or just do a perfectly regular mkdir(), followed by a ioctl().

> Directory, not file.  You can do mkdir (requiring write and execute), for
> example, in a directory you cannot open (which would require read).  If you
> cannot open it, you cannot do ioctl on it.

Honestly, who cares?

Seriously. Just make the rule be that you need read permission on the
directory too in order to do that ioctl() that is your magical "make
special node".

What makes this all *SO* special, and *SO* important that you need to
follow somebody elses rules that absolutely nobody cares about?

              Linus
