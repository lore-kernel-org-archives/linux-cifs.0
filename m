From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] cifs: remove export_ops code
Date: Fri, 17 Dec 2010 10:38:16 -0500
Message-ID: <20101217103816.361fac97@tlielax.poochiereds.net>
References: <1291820625-20907-1-git-send-email-jlayton@redhat.com>
	<1291820625-20907-2-git-send-email-jlayton@redhat.com>
	<4D0B81AA.9060805@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D0B81AA.9060805-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 17 Dec 2010 20:58:42 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 12/08/2010 08:33 PM, Jeff Layton wrote:
> > Stubs for this code were added under the CONFIG_CIFS_EXPERIMENTAL tag in
> > 2007, but were never completed. The upshot -- anyone who turns on
> > CONFIG_CIFS_EXPERIMENTAL gets a filesystem that pretends to allow exporting
> > via nfsd. Trying to actually use it will just get you an error once
> > nfsd tries to walk into the directory.
> > 
> > Remove this code since it's unfinished. We can reintroduce it once someone
> > spends time on it and makes it usable.
> > 
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/Makefile |    2 +-
> >  fs/cifs/cifsfs.c |    7 -----
> >  fs/cifs/cifsfs.h |    4 ---
> >  fs/cifs/export.c |   67 ------------------------------------------------------
> >  4 files changed, 1 insertions(+), 79 deletions(-)
> >  delete mode 100644 fs/cifs/export.c
> 
> Looks good to me.
> 
> Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> 
> Perhaps it would be a good idea to briefly document expected behavior,
> what is working, problems etc (in Samba wiki) so that someone can pick
> up this later?
> 

Sounds reasonable.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
