From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 2/5] locks: new locks_mandatory_area calling convention
Date: Tue, 1 Dec 2015 08:37:18 +0100
Message-ID: <20151201073718.GA29495@lst.de>
References: <1448563859-21922-1-git-send-email-hch@lst.de> <1448563859-21922-3-git-send-email-hch@lst.de> <20151130223830.GB31564@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151130223830.GB31564-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Nov 30, 2015 at 05:38:30PM -0500, J. Bruce Fields wrote:
> > +	if (size < inode->i_size) {
> > +		return locks_mandatory_area(filp, size, inode->i_size - 1,
> > +				true);
> > +	} else {
> > +		return locks_mandatory_area(filp, inode->i_size, size - 1,
> > +				true);
> 
> I feel like these callers would be just slightly more self-documenting
> if that last parameter was F_WRLCK instead of true.

Sure, I can change that forthe next version.
