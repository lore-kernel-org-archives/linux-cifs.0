From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Mounts to Windows 7 and "out of memory" or "insufficient server
 resources"
Date: Thu, 29 Sep 2011 06:47:38 -0400
Message-ID: <20110929064738.02af5762@corrin.poochiereds.net>
References: <CAH2r5msivsE_47mESmGR=Xjf2v-kKwi-Qpym2kxuTLPbYudisQ@mail.gmail.com>
	<4E82B4ED.4060107@suse.com>
	<20110928080622.5e30429b@corrin.poochiereds.net>
	<CAH2r5msGRvhahCXbAb8mj7c28qUzPxOB5dJjjyQFAZvQxZzY-g@mail.gmail.com>
	<20110928155404.12b84af3@tlielax.poochiereds.net>
	<4E83FE54.7060309@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E83FE54.7060309-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 29 Sep 2011 10:42:52 +0530
Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:

> On 09/29/2011 01:24 AM, Jeff Layton wrote:
> > On Wed, 28 Sep 2011 13:27:33 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > 
> >> On Wed, Sep 28, 2011 at 7:06 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> >>> On Wed, 28 Sep 2011 11:17:25 +0530
> >>> Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
> >>>
> >>>> On 09/28/2011 03:06 AM, Steve French wrote:
> >>>>> FYI - The cifs async write in 3.0 seems to exacerbate problems running
> >>>>> out of memory (apparently) on the Windows 7 system (running as a
> >>>>> server) after a large file copy to the server completes.   I have been
> >>>>> able to reproduce the same problem on Windows Vista Service Pack 2
> >>>>> (which is a good news/bad news story since my earlier testing on
> >>>>> Windows Vista showed hangs on some requests rather than returning out
> >>>>> of memory).  Does not seem to be a problem with any of the Windows
> >>>>> server versions just Windows 7 and Vista so far.
> >>>>
> >>>> The last time when I encountered this, cifs client was reporting "Cannot
> >>>> allocate memory" a.k.a -ENOMEM error. But, it is actually a
> >>>> NT_STATUS_INSUFF_SERVER_RESOURCES error from Server being mapped to
> >>>> -ENOMEM. I found this mapping confusing atleast initially. Is this
> >>>> mapping correct?
> >>>>
> >>>> Not sure do we have a POSIX equivalent of
> >>>> NT_STATUS_INSUFF_SERVER_RESOURCES? Should we map it to a error code that
> >>>> is more obvious?
> >>>>
> >>>
> >>> Maybe -EREMOTEIO ?
> >>
> >> The mapping of NT_STATUS_INSUFFICIENT_SERVER_RESOURCES to posix error
> >> ENOMEM appears to be correct for multiple reasons.  Windows itself maps it this
> >> way when mapping from NT STATUS to DOS errors. For example, on subsequent
> >> requests, I see server returning DOS (!) error for error_no_memory on some
> >> types of SMBs and NT error insufficient_server_resources on others.
> >>
> > 
> > I don't know...
> > 
> > ENOMEM has clear connotations -- it tells you the machine (client) is
> > unable to allocate memory. You might be able to stretch that to mean
> > that the client is unable to allocate some other resource, but in this
> > case it's the *server* not the client that's reporting the problem.
> 
> Exactly. I have had customers with whom I had hard time explaining this
> is not a client side problem because they argue that it is a client side
> memory allocation error and the client should be fixed. I couldn't find
> any standard text where the current mapping is documented.
> 
> > It seems probable that DOS error codes just lacked anything better for
> > this mapping. In our case though, -EREMOTEIO seems like a better
> > mapping as it makes it clear that it's the server that can't allocate
> > resources, not the client.
> > 
> 
> -EREMOTEIO sounds very close me. Atleast, it communicates it is a remote
> server side issue and not a client side issue.
> 

Yeah, I always sort of consider -EIO to be more or less a "catch-all"
error. Report that when you can't translate it to any other allowable
error. -EREMOTEIO is basically -EIO on a remote host -- that seems like
a more reasonable representation of the problem.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
