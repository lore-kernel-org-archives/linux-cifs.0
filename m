From: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v0 1/4] vfs: add copy_range syscall and vfs entry point
Date: Wed, 15 May 2013 12:39:31 -0700
Message-ID: <20130515193931.GB318@lenny.home.zabbo.net>
References: <CAH2r5ms0P8Hgv1mUpyHA32Er38iiaC1HHC4fhxvz2SBFy6Sucw@mail.gmail.com>
 <20130515185429.GA25994@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130515185429.GA25994-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, May 15, 2013 at 02:54:29PM -0400, J. Bruce Fields wrote:
> On Wed, May 15, 2013 at 12:50:13PM -0500, Steve French wrote:
> > Does nfs client ever have the case where two different superblocks map
> > to the same nfs export (and thus the check below is restricting the
> > ability to do server side copy)?
> > 
> > +	if (inode_in->i_sb != inode_out->i_sb ||
> > +	    file_in->f_path.mnt != file_out->f_path.mnt)
> > +		return -EXDEV;
> 
> The client attempts to use the same superblock whenever it can.
> 
> I suppose you're also losing the opportunity to copy between two
> different filesystems on the same server, which should be faster than
> requiring the client to do the copy.

Ah, yeah, that'd probably be the simplest motivation to move this down
into the ->copy_range methods.  It should be trivial to test once the
nfs bits are going and we have the page cache fallback.

- z
