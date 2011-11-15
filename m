From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: CIFS mount twice
Date: Tue, 15 Nov 2011 05:45:04 -0500
Message-ID: <20111115054504.550248e0@tlielax.poochiereds.net>
References: <20111114172138.Horde.60sJZ1wlEB5OwQDKknIWLdA@mail.linuz.in>
	<loom.20111115T070545-916@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aravind M D <aravind-f8yKZFm1E5Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20111115T070545-916-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 15 Nov 2011 06:07:39 +0000 (UTC)
Aravind M D <aravind-f8yKZFm1E5Q@public.gmane.org> wrote:

> Aravind M D <aravind@...> writes:
> 
>  
> > 
> > Hi,
> > 
> >   I have some cifs mount points configured on my /etc/fstab.
> > 
> >   When i am doing mount -a command mount points are mouting again.
> > 
> >   If mount command is issued mount point is showing twice.
> > 
> >   If i use mount through command line also i am facing the same issue.
> > 
> >   Please help me.
> > 
> >   Rgds,
> >   Aravind M D
> > 
> 
> Can someone help me with the below issue.
> 
> Thanks in Advance
> 

Not with the description you've given as there's just hardly anything
there in the way of details...

I set up my fedora rawhide test box with a cifs mount in /etc/fstab and
then ran mount -a several times. It was only mounted once.

IIUC, it's the job of /bin/mount to only attempt to mount filesystems
that have not already been mounted when mount -a is run. If that's not
happening on your machine then it sounds like something is broken there.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
