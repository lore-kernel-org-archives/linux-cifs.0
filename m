Return-Path: <SRS0=bM6M=4H=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490ABC35242
	for <linux-cifs@archiver.kernel.org>; Wed, 19 Feb 2020 19:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 206A624654
	for <linux-cifs@archiver.kernel.org>; Wed, 19 Feb 2020 19:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582140399;
	bh=aFXw8Li9wnpUZmRwFXzG5WXkfPVfjpgUyY8QQu27GyA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ok/LCZWPP1BbyYahJl6tXsDgtdxjYfgpZ6pvJYFgn3Vs/6GJ5NvU2kLNpOKtLIzwM
	 qpddFOvmm9go/jDbHE2uaVW1gjOTmSYLiruO5Z5m+BJ+FXbN6qP2/6y6uXwtOXcciK
	 koRLP8W7nCMvS4oZbZln/W/bSFon6HDTSxXN6NPs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgBST0i (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 Feb 2020 14:26:38 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42675 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgBST0i (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 19 Feb 2020 14:26:38 -0500
Received: by mail-lj1-f194.google.com with SMTP id d10so1570002ljl.9
        for <linux-cifs@vger.kernel.org>; Wed, 19 Feb 2020 11:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1fTub4GYfjONmIT82CPg1N7dCoXEnM2Sw2O8KqYucXw=;
        b=TTXA143+I9mRmEBx9/1NhLISHKMsH6waUZcmcpT1BguCNEKTR0hF7JmV5HoBZEGz3o
         db9fi0sUaay+pAz0CQoHWY2cCDHTPEMKkMTVnGzY174vOn3S+TeHtv27+wikNuljtZEX
         gzePqVGy4l+pJiMwf4qLcoz9ecA3N8Y267gYc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1fTub4GYfjONmIT82CPg1N7dCoXEnM2Sw2O8KqYucXw=;
        b=F2eAEATYblG2ipB3T2muyPl49H5S2x7hdo6BTtcDQLlOzSyVNcodwlQmi4EVL1tiM9
         7kxacsgqc4lcnOlY3HdHdFtIGxUTlITXxlW3IOlSiP+7Sw+d3I1KC/mxh7lSxTNghxhA
         m0sGkwlcAfCtwm+f3/awXbdNzu13scEYmv7ls3M9jpz0OJ7csWfKTZi91wl9NiyVc9+a
         mWro+eZ+96PIbOnx3QHvE++Ru4QDxcl2MwZgsKTAe3hb/BhGXSTUB1V9gdjsPZJ0mMhV
         klwe8shUmcIZCVpO4HGdqyPIqp7HHJzGva9vf6sOpq0liEW9C8TJ2A9otAAdAowqGB4C
         kevQ==
X-Gm-Message-State: APjAAAWdisR4cSEZrB7CkdZ/fy+C1Oz46VZGdap4law4yLId+czipSOJ
        NWaxLjcWMoq3MhIm+bM5LZ8uDLlUgjM=
X-Google-Smtp-Source: APXvYqzfmzHsiL8ZsfrC4HX98HJkxDULRmd+Q0elPPCT2Qi6/Nj/5HoPRksNpoguH1IJWPOQHEZfog==
X-Received: by 2002:a2e:9e03:: with SMTP id e3mr16671801ljk.186.1582140395698;
        Wed, 19 Feb 2020 11:26:35 -0800 (PST)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id l16sm284224lfh.74.2020.02.19.11.26.34
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 11:26:35 -0800 (PST)
Received: by mail-lj1-f172.google.com with SMTP id d10so1569903ljl.9
        for <linux-cifs@vger.kernel.org>; Wed, 19 Feb 2020 11:26:34 -0800 (PST)
X-Received: by 2002:a2e:909a:: with SMTP id l26mr16050682ljg.209.1582140394436;
 Wed, 19 Feb 2020 11:26:34 -0800 (PST)
MIME-Version: 1.0
References: <158212290024.224464.862376690360037918.stgit@warthog.procyon.org.uk>
 <CAMuHMdV+H0p3qFV=gDz0dssXVhzd+L_eEn6s0jzrU5M79_50HQ@mail.gmail.com>
 <227117.1582124888@warthog.procyon.org.uk> <CAHk-=wjFwT-fRw0kH-dYS9M5eBz3Jg0FeUfhf6VnGrPMVDDCBg@mail.gmail.com>
 <241568.1582134931@warthog.procyon.org.uk> <CAHk-=wi=UbOwm8PMQUB1xaXRWEhhoVFdsKDSz=bX++rMQOUj0w@mail.gmail.com>
 <CAHk-=whfoWHvL29PPXncxV6iprC4e_m6CQWQJ1G4-JtR+uGVUA@mail.gmail.com>
In-Reply-To: <CAHk-=whfoWHvL29PPXncxV6iprC4e_m6CQWQJ1G4-JtR+uGVUA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 19 Feb 2020 11:26:18 -0800
X-Gmail-Original-Message-ID: <CAHk-=whE0uzJy1C5z-GB-s7YioW_yhiEaes4cNa6tLJwyx19gA@mail.gmail.com>
Message-ID: <CAHk-=whE0uzJy1C5z-GB-s7YioW_yhiEaes4cNa6tLJwyx19gA@mail.gmail.com>
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

On Wed, Feb 19, 2020 at 11:07 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Actually, since this is apparently a different filetype, the _logical_
> thing to do is to use "mknod()".

Btw, don't get me wrong. I realize that you want to send other
information too in order to fill in all the metadata for what the
mountpoint then _does_.

So the "mknod()" thing would be just to create a local placeholder
(and an exclusive name) on the client - and then you do the ioctl on
that (or whatever) that sends over the metadata to the server along
with the name.

Think of it as a way to get a place to hook into things, and a (local
only) reservation for the name.

               Linus
