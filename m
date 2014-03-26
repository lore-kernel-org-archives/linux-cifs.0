From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Subject: Re: Question regarding CIFS cache=loose behavior.
Date: Wed, 26 Mar 2014 23:05:20 +0900
Message-ID: <201403262305.GBG17639.MOJLVOOSFHFtQF@I-love.SAKURA.ne.jp>
References: <201403210556.FEI21354.FLJOQMHtSVOFFO@I-love.SAKURA.ne.jp>
	<20140320191013.110276c0@tlielax.poochiereds.net>
	<201403262104.AGG86982.StVMOJOHFOQFLF@I-love.SAKURA.ne.jp>
	<20140326052119.32405279@ipyr.poochiereds.net>
	<20140326060305.3226a08c@ipyr.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140326060305.3226a08c-uvzPfv+vNdB0Ogp0/tUwVOTW4wlIGRCZ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeffrey Layton wrote:
> > ...or that samba is omitting it and is sending cached info instead of
> > doing the lstat() call? I'm not sure if it does that, but I don't
> > think you should draw too many conclusions about the behavior of
> > cifs.ko from stracing smbd.
> > 
> > What may make more sense is to get network captures and analyze the
> > behavior from that perspective.
> > 
> 
> ...or maybe it *is* cifs.ko. From cifs_inode_needs_reval:
> 
> 
>         if (!time_in_range(jiffies, cifs_i->time,
>                                 cifs_i->time + cifs_sb->actimeo))
>                 return true;
> 
> 
> ...I think though that if cifs_i->time == jiffies and actimeo=0, then
> that condition will be false. As a quick check, it might be good to add
> something like this before that if statement and then rerun your test:
> 
> 	if (!cifs_sb->actimeo)
> 		return true;
> 
> That should get rid of that particular corner case.

Yes, I confirmed that below change fixes this problem. Thank you.

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1737,6 +1737,8 @@ cifs_inode_needs_reval(struct inode *inode)
 	if (cifs_i->time == 0)
 		return true;
 
+	if (!cifs_sb->actimeo)
+		return true;
 	if (!time_in_range(jiffies, cifs_i->time,
 				cifs_i->time + cifs_sb->actimeo))
 		return true;
