From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs: Re-order M-F Symlink code
Date: Tue, 28 Jan 2014 16:49:13 +0300
Message-ID: <20140128134913.GB4815@mwanda>
References: <20140127204856.GA3089@elgon.mountain>
 <1390915040.3984.11.camel@sachin-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1390915040.3984.11.camel@sachin-laptop>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jan 28, 2014 at 01:17:20PM +0000, Sachin Prabhu wrote:
> On Mon, 2014-01-27 at 23:48 +0300, Dan Carpenter wrote:
> > Hello Sachin Prabhu,
> > 
> > The patch 0f8dce1cb745: "cifs: Re-order M-F Symlink code" from Nov
> > 25, 2013, leads to the following static checker warning:
> > 
> > 	fs/cifs/link.c:188 couldbe_mf_symlink()
> > 	error: should you be using something like S_ISREG() here?
> > 
> > fs/cifs/link.c
> >    185  bool
> >    186  couldbe_mf_symlink(const struct cifs_fattr *fattr)
> >    187  {
> >    188          if (!(fattr->cf_mode & S_IFREG))
> >                                        ^^^^^^
> > Should this be:
> > 
> > 		if (!S_ISREG(fattr->cf_mode))
> > 
> >    189                  /* it's not a symlink */
> >    190                  return false;
> >    191  
> >    192          if (fattr->cf_eof != CIFS_MF_SYMLINK_FILE_SIZE)
> >    193                  /* it's not a symlink */
> >    194                  return false;
> >    195  
> >    196          return true;
> >    197  }
> > 
> > If this a real bug then please give the credit to Neil Brown because he
> > suggested I add this to Smatch (not pushed yet).
> > 
> > Reported-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> > 
> > regards,
> > dan carpenter
> 
> Hello Dan,
> 
> There seems to be no difference in operation between the original line
> and the proposed line. The newer line just seems to be the preferred way
> to test for regular files. Is there a bug I am missing here?

I mean, there is a functional difference in the obvious sense.

#define S_IFSOCK 0140000
#define S_IFLNK  0120000
#define S_IFREG  0100000
#define S_IFBLK  0060000
#define S_IFDIR  0040000
#define S_IFCHR  0020000
#define S_IFIFO  0010000
#define S_ISUID  0004000
#define S_ISGID  0002000
#define S_ISVTX  0001000

0100000 is set for S_IFREG, S_IFLNK and S_IFSOCK.  But I don't know if
this makes a difference for cifs?

regards,
dan carpenter
