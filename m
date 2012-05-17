From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: don't send a mandatory ver= option to the
 kernel
Date: Thu, 17 May 2012 13:54:37 -0400
Message-ID: <20120517135437.6af5c851@corrin.poochiereds.net>
References: <1336763001-7315-1-git-send-email-jlayton@samba.org>
	<1337273046.2275.1.camel@localhost>
	<CAH2r5muvJ=QUt6MsYQiZpZDWp+GRzviJRnJ6Q7O5eE1zYNOnJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muvJ=QUt6MsYQiZpZDWp+GRzviJRnJ6Q7O5eE1zYNOnJg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 17 May 2012 12:03:26 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, May 17, 2012 at 11:44 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Fri, 2012-05-11 at 15:03 -0400, Jeff Layton wrote:
> >> Traditionally, this ver= option was used to specify the "options
> >> version" that we're passing in. It has always been set to '1' though
> >> and we have never changed that.
> >>
> >> Eventually we want to have a ver= (or vers=) option that allows users
> >> to specify the SMB version that they want to use to talk to the server.
> >>
> >> At that point, this option will just get in the way. Let's go ahead
> >> and remove it now in preparation for that day.
> >>
> >
> > Do we need 'ver=' mount option to specify the SMB version number? Isn't
> > 'vers=' sufficient for this?
> 
> Yes - "vers" is sufficient (although I am fine with adding synonyms to
> make it easier for nfs users - e.g. "smbvers=" or if we want to have
> smb2 specific utility programs (e.g. for a phone or tablet) that call
> do_mount automatically set vers=2.1.
> 
> I think that there will be times when we want (the kernel cifs.ko) to
> know the version number of the user space utility (bugs? security
> problems? debugging mount errors, at least when debugging set to
> maximum level to log to dmesg?) so I think we should pass the real
> mount.cifs version number in "ver=" as was the original intent (if for
> nothing else it would help debugging mount bugs so we could log it to
> dmesg in a few cases) - but since we have been sending "1" instead of
> the mount.cifs version (and it is not currently used by the kernel
> code) I can understand Jeff's point.  In any case, we can't use "ver="
> to mean "vers=" (ie the requested dialect the user wants to use) as if
> so current mount.cifs will force cifs by sending "ver=1" and when we
> want to move the default in the future it would get in the way
> (cifs.ko would require an update of mount.cifs but we would have no
> way of telling in kernel whether it was the old mount.cifs - kind of a
> catch-22 due to the lack of version number)
> 

Yes, I don't think we're going to use ver= as a synonym for vers=.

That said, we haven't needed a way for the kernel to recognize the
userspace "options version" and no other userspace mount helper that
I'm aware of has such a thing. After all, a userspace mount helper
isn't even required...someone can mount cifs just fine w/o one as long
as they pass in ip=.

Handling an options version is more of a problem with binary mount
options, where you need to know if you're breaking the ABI. With text
based options, it's just not an issue.

So I think going ahead and getting rid of this in the kernel is the
right thing to do. It's just useless cruft that may get in the way in
the future.

If the kernel ever needs to determine the mount helper "version" for
some reason, then it can treat a lack of ver= at all identically to how
it handles a helper that passes in ver=1.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
