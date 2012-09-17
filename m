From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: many-to-one nested CIFS serving
Date: Mon, 17 Sep 2012 16:52:33 -0700
Message-ID: <20120917165233.0e8d75a7@corrin.poochiereds.net>
References: <50579A12.7070805@colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve.Finley-SOxAPD1SrF7V1CgomF1qdQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50579A12.7070805-SOxAPD1SrF7V1CgomF1qdQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 17 Sep 2012 15:45:54 -0600
Steve Finley <Steve.Finley-SOxAPD1SrF7V1CgomF1qdQ@public.gmane.org> wrote:

> To Whom:
> 
> I am exploiting a feature of the CIFS server that works for the client under
> Windows 8 (not sure about others), but does not work for the linux client
> under RedHat/CentOS5/6.
> 
> I am mounting multiple Thecus NAS devices via CIFS, making
> symbolic links to files on those NAS devices, where I reorganize the
> directory structure, and then turn around and serve the top level
> of that directory via CIFS.
> 
> On a Windows machine I only have to mount that top level directory, and
> the symbolic links automatically resolve themselves without having to also
> mount the NAS device(s).  THIS IS VERY POWERFUL.  On a linux
> machine however, the symbolic links can only be resolved if I have the
> NAS devices mounted, and the mount points have to be named as shown
> in the link.  It seems that the protocol necessary for this to work under
> Windows has not been added to the linux version of the client.
> 
> When I surf the web for others exploiting this feature, I find nothing.
> 
> Thanks
> 
> Steve Finley
> Research Associate
> CIRA - Colorado State University
> 

So you're reexporting a CIFS mount from a linux box with samba? Yuck.

Most likely you're running afoul of the fact that when POSIX extensions
are enabled, that symlinks are passed on as-is to the client. If you
mount from the clients using "nounix" it'll probably do something
closer to what you expect.

In truth though, I think you'd be better served by researching and
configuring a DFS share.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
