From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 1/8] cifs: Fix xattr name checks
Date: Thu, 14 Apr 2016 05:59:20 +0100
Message-ID: <20160414045920.GT25498@ZenIV.linux.org.uk>
References: <20160413182026.GR25498@ZenIV.linux.org.uk>
 <1460586620-5717-1-git-send-email-agruenba@redhat.com>
 <1460586620-5717-2-git-send-email-agruenba@redhat.com>
 <CAH2r5mumJ22+Q0bASFcXp5fK39Ubh+sznfOpVUtSJ94_c5gkxA@mail.gmail.com>
 <20160414043718.GS25498@ZenIV.linux.org.uk>
 <CAH2r5ms6USEO3a_EPUpgsnvTZgSHB2QqJnUnCSCQdFmvV0yPDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5ms6USEO3a_EPUpgsnvTZgSHB2QqJnUnCSCQdFmvV0yPDg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Apr 13, 2016 at 11:43:19PM -0500, Steve French wrote:
> If you are planning to merge it in next few weeks (they fix bugs, and
> are safe so why not),  I can simply just back out my changes from
> cifs-2.6.git for-next branch and let you merge the trivial checkpatch
> cleanup attached.

Do you want it in mainline before 4.6-final?  If that can wait until 4.7-rc1
(and these are both old and not earth-shattering), I've no problem with
putting the entire series (including cleanup) into a branch merged into
vfs.git#for-next; if you consider it 4.6-final fodder, it's probably better
be your pull request.

PS: are there any docs re setup for cifs testing?
