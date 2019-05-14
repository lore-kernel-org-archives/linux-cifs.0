Return-Path: <SRS0=e7zQ=TO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C1FC04AB4
	for <linux-cifs@archiver.kernel.org>; Tue, 14 May 2019 12:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30D2620881
	for <linux-cifs@archiver.kernel.org>; Tue, 14 May 2019 12:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfENMiW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 May 2019 08:38:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfENMiW (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 14 May 2019 08:38:22 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A5243082B40;
        Tue, 14 May 2019 12:38:22 +0000 (UTC)
Received: from localhost (dhcp-12-130.nay.redhat.com [10.66.12.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E92645C542;
        Tue, 14 May 2019 12:38:21 +0000 (UTC)
Date:   Tue, 14 May 2019 20:38:20 +0800
From:   Murphy Zhou <xzhou@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     Petr Vorel <pvorel@suse.cz>, Murphy Zhou <xzhou@redhat.com>,
        ltp@lists.linux.it, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [LTP] [PATCH] safe_setuid: skip if testing on CIFS
Message-ID: <20190514123820.sh5l3rhyxaohmppn@XZHOUW.usersys.redhat.com>
References: <20190510043845.4977-1-xzhou@redhat.com>
 <20190513143413.GA4568@dell5510>
 <CAH2r5mvSS4crgid-srKr+hycN=uW-vPLGhF81RvA6UBP2T7K4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mvSS4crgid-srKr+hycN=uW-vPLGhF81RvA6UBP2T7K4A@mail.gmail.com>
User-Agent: NeoMutt/20180716-1400-f2a658
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 14 May 2019 12:38:22 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Petr and Steve,

Thanks for reviewing! Steve you are right that this is more about
mode bits and ownership. Great to know the development work progress.
Most of the tests fail after setuid because chmod/chown operations
before that does not take effect, which is expected now I guess.
Now I am testing option "dynperm".

Self nack for this patch. Don't skip them.

Thanks!
M

On Mon, May 13, 2019 at 03:13:39PM -0500, Steve French wrote:
> Also note that we are working on patches to improve saving of mode
> bits and ownership information even in cases where the server does not
> support POSIX Extensions.
> 
> Currently mount options cifsacl and idsfromsid can be used for some
> use cases but they are being extended.
> 
> On Mon, May 13, 2019 at 11:04 AM Petr Vorel <pvorel@suse.cz> wrote:
> >
> > Hi Murphy,
> >
> > > As CIFS is not supporting setuid operations.
> > Any reference to this?
> > fs/cifs/cifsfs.c and other parts of kernel cifs works with CIFS_MOUNT_SET_UID.
> > Also samba_setreuid() from lib/util/setid.c from samba git (I guess used in
> > samba libraries works with SYS_setreuid syscall or setreuid() libc wrapper.
> > What am I missing?
> >
> > > diff --git a/lib/tst_safe_macros.c b/lib/tst_safe_macros.c
> > > index 0e59a3f98..36941ec0b 100644
> > > --- a/lib/tst_safe_macros.c
> > > +++ b/lib/tst_safe_macros.c
> > > @@ -111,6 +111,7 @@ int safe_setreuid(const char *file, const int lineno,
> > >                 uid_t ruid, uid_t euid)
> > >  {
> > >       int rval;
> > > +     long fs_type;
> >
> > >       rval = setreuid(ruid, euid);
> > >       if (rval == -1) {
> > > @@ -119,6 +120,13 @@ int safe_setreuid(const char *file, const int lineno,
> > >                        (long)ruid, (long)euid);
> > >       }
> >
> > > +     fs_type = tst_fs_type(".");
> > > +     if (fs_type == TST_CIFS_MAGIC) {
> > > +             tst_brk_(file, lineno, TCONF,
> > > +                      "setreuid is not supported on %s filesystem",
> > > +                      tst_fs_type_name(fs_type));
> > > +     }
> > I guess this check should be before setreuid() As it's in safe_seteuid() and
> > safe_setuid()
> > > +
> > >       return rval;
> > >  }
> >
> > Kind regards,
> > Petr
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
