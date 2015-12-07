From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 2/4] vfs: pull btrfs clone API to vfs layer
Date: Mon, 7 Dec 2015 16:13:19 +0100
Message-ID: <20151207151319.GA2472@lst.de>
References: <1449143992-7415-1-git-send-email-hch@lst.de> <1449143992-7415-3-git-send-email-hch@lst.de> <20151207005331.GA10582@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org,
	bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151207005331.GA10582-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Sun, Dec 06, 2015 at 04:53:31PM -0800, Darrick J. Wong wrote:
> > +	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
> > +		return -EISDIR;
> > +	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
> > +		return -EOPNOTSUPP;
> 
> I thought we were moving to -EINVAL for wrong file types?
> 
> Though, perhaps "I've also prepared a btrfs patch for this and clone" from the
> earlier thread about generic/157 wasn't referring to /this/ patch. :)
> 
> In any case, I'm ok with EINVAL, and I haven't heard any objections to
> changing -EOPNOTSUPP -> -EINVAL when trying to reflink/dedupe/whatever
> non-file non-dir fds.

I'm fine with with EINVAL - not sure why I ended up with EOPNOTSUP,
probably because 157 is already failing as in general the errors for
something in the VFS vs a specific ioctl handler are just too different.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
