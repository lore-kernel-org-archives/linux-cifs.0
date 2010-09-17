From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: samba changing mode of files on rename
Date: Fri, 17 Sep 2010 13:28:13 -0400
Message-ID: <20100917132813.5fb5f15d@corrin.poochiereds.net>
References: <20100917130005.23d0864a@corrin.poochiereds.net>
	<20100917131558.13a00c53@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100917131558.13a00c53-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 17 Sep 2010 13:15:58 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> On Fri, 17 Sep 2010 13:00:05 -0400
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 
> > I recently noticed a regression in samba in the last few weeks. Here's
> > a simple way to reproduce it:
> > 
> > 1) use smbclient to put a file on a samba share
> > 2) change the mode of the file to something without the owner execute bit set
> > 3) rename the file using smbclient
> > 
> > When you do this, the newly renamed file will magically end up with the
> > owner execute bit set. It seems like samba ought not be changing the
> > mode of files when renaming them so I consider this a regression.
> > 
> > I've reported the bug in the Fedora BTS, and attached some info there.
> > Anyone more familiar with this code willing to have a look?
> > 
> >     https://bugzilla.redhat.com/show_bug.cgi?id=617771
> > 
> > I've was able to reproduce it today using the most recent samba version
> > available in the Fedora repos (3.5.5).
> > 
> > Thanks,
> 
> Volker pointed out a workaround on IRC...
> 
> If I set "map archive = no" then this doesn't seem to happen. So, I
> guess something has happened relatively recently to make renames set
> the archive bit?
> 

Following up, it looks like windows sets the archive bit on a rename so
I guess this behavior is "correct". The problem though is that this is
problematic when unix extensions are in use. We generally don't want
files changing mode like this on a rename...

Anyone have thoughts on a reasonable fix? Perhaps we can implicitly
disable the "map *" options when unix extensions are enabled?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
