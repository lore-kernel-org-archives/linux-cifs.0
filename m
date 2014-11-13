From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v2 1/5] common: re-enable tests that require scratch dev
 on NFS
Date: Thu, 13 Nov 2014 14:33:17 +1100
Message-ID: <20141113033317.GC28565@dastard>
References: <1414775040-4051-1-git-send-email-eguan@redhat.com>
 <1414775040-4051-2-git-send-email-eguan@redhat.com>
 <CAH2r5muuJRcC4YgFkwUeUcCeEntgY+4POF8-bwmox64wXykuTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	dros-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5muuJRcC4YgFkwUeUcCeEntgY+4POF8-bwmox64wXykuTw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Wed, Nov 12, 2014 at 12:36:13PM -0600, Steve French wrote:
> On Fri, Oct 31, 2014 at 12:03 PM, Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > This commit disables tests requires scratch dev running on NFS
> >
> > c041421 xfstests: stop special casing nfs and udf
> >
> > Now re-enable them to get a larger test coverage on NFS.
> >
> > Signed-off-by: Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  common/rc | 22 +++++++++++++++++++---
> >  1 file changed, 19 insertions(+), 3 deletions(-)
> >
> > diff --git a/common/rc b/common/rc
> > index 747cf72..ae03712 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -551,6 +551,14 @@ _mkfs_dev()
> >      rm -f $tmp_dir.mkfserr $tmp_dir.mkfsstd
> >  }
> >
> > +# remove all files in $SCRATCH_MNT, useful when testing on NFS/CIFS
> > +_scratch_cleanup_files()
> > +{
> > +       _scratch_mount
> > +       rm -rf $SCRATCH_MNT/*
> > +       _scratch_unmount
> > +}
>
> There should be a check to make sure SCRATCH_MNT exists before you
> wipe the whole disk ....
> 
> so if no SCRATCH_MNT then this does rm -rf/*
> right ... (and wipes out your whole system ...)

You can't get to that function until after all the checks that
SCRATCH_MNT exists. i.e. this happens during _scratch_mkfs, and that
is only called in tests after all the startup checks validate
devices and mounts exist. i.e. see common/config::get_next_config()

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
