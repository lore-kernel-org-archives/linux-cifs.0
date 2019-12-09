Return-Path: <SRS0=ClyU=Z7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D886AC43603
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Dec 2019 00:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B147B20637
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Dec 2019 00:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfLIAeX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 8 Dec 2019 19:34:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41962 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbfLIAeX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 8 Dec 2019 19:34:23 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ie709-0006VC-GC; Mon, 09 Dec 2019 00:34:13 +0000
Date:   Mon, 9 Dec 2019 00:34:13 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: build_path_from_dentry_optional_prefix() may schedule from
 invalid context
Message-ID: <20191209003413.GY4203@ZenIV.linux.org.uk>
References: <20190829050237.GA5161@jagdpanzerIV>
 <CAKywueRd4d_fojGL+n4BisoibhgkYfN9Wyc_+0=-1sarz4-HZw@mail.gmail.com>
 <20190921223847.GB29065@ZenIV.linux.org.uk>
 <CAKywueSC=MoBB6t2OeUiyc6+GST2Jgg8FTO-kkXif-pn+1k-cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKywueSC=MoBB6t2OeUiyc6+GST2Jgg8FTO-kkXif-pn+1k-cw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Sep 30, 2019 at 10:32:16AM -0700, Pavel Shilovsky wrote:
> сб, 21 сент. 2019 г. в 15:38, Al Viro <viro@zeniv.linux.org.uk>:

> > IOW, kindly lose that nonsense.  More importantly, why bother
> > with that kmalloc()?  Just __getname() in the very beginning
> > and __putname() on failure (and for freeing the result afterwards).
> >
> > What's more, you are open-coding dentry_path_raw(), badly.
> > The only differences are
> >         * use of dirsep instead of '/' and
> >         * a prefix slapped in the beginning.
> >
> > I'm fairly sure that
> >         char *buf = __getname();
> >         char *s;
> >
> >         *to_free = NULL;
> >         if (unlikely(!buf))
> >                 return NULL;
> >
> >         s = dentry_path_raw(dentry, buf, PATH_MAX);
> >         if (IS_ERR(s) || s < buf + prefix_len)
> >                 __putname(buf);
> >                 return NULL; // assuming that you don't care about details
> >         }
> >
> >         if (dirsep != '/') {
> >                 char *p = s;
> >                 while ((p = strchr(p, '/')) != NULL)
> >                         *p++ = dirsep;
> >         }
> >
> >         s -= prefix_len;
> >         memcpy(s, prefix, prefix_len);
> >
> >         *to_free = buf;
> >         return s;
> >
> > would end up being faster, not to mention much easier to understand.
> > With the caller expected to pass &to_free among the arguments and
> > __putname() it once it's done.
> >
> > Or just do __getname() in the caller and pass it to the function -
> > in that case freeing (in all cases) would be up to the caller.
> 
> Thanks for pointing this out. Someone should look at this closely and
> clean it up.

Could you take a look through vfs.git#misc.cifs?
