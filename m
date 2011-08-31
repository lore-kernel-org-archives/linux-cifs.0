From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Samba] mount.cifs -> Unisys MCP Mainframe -- Linux touch
 command "setting times of `testfile.txt': Permission denied"
Date: Wed, 31 Aug 2011 19:16:43 -0400
Message-ID: <20110831191643.71468336@corrin.poochiereds.net>
References: <CAHyifnSXNRHfNmyQw0HXyqqwthCQ5si-JQc95JmuriYpf0ZL7g@mail.gmail.com>
	<CAHyifnQkFQ6kn5patfA7dYOFHxqyu263KhVN9EGVmRZvei0wRw@mail.gmail.com>
	<20110831154125.3e1f1a00@tlielax.poochiereds.net>
	<CAHyifnQWeKpviqFN6hkahy2mVx2X8GUftEP+3kY0Eo=5vq=4JQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tim Lank <timlank-3iNpEh//jjRBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHyifnQWeKpviqFN6hkahy2mVx2X8GUftEP+3kY0Eo=5vq=4JQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 31 Aug 2011 17:35:39 -0400
Tim Lank <timlank-3iNpEh//jjRBDgjK7y7TUQ@public.gmane.org> wrote:

> On Wed, Aug 31, 2011 at 3:41 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Wed, 31 Aug 2011 14:55:26 -0400
> > Tim Lank <timlank-3iNpEh//jjRBDgjK7y7TUQ@public.gmane.org> wrote:
> >
> > > the mount.cifs is from (cifs-utils-4.8.1-2.el6.x86_64)
> > >
> > >
> > > On Tue, Aug 30, 2011 at 8:05 PM, Tim Lank <timlank-3iNpEh//jjRBDgjK7y7TUQ@public.gmane.org> wrote:
> > >
> > > > I've got a share from a Unisys MCP Mainframe mounted with mount.cifs
> > from
> > > > RHEL 6.1 (samba-common-3.5.6-86.el6.x86_64).
> > > >
> > > > when I try to touch a file, it creates the file, but reports an error -
> > > > "setting times of `testfile.txt': Permission denied"
> > > >
> > > > strace on the touch command shows that it is erroring out on the
> > > > utimensat() call
> > > >
> > > > utimensat(0, NULL, NULL, 0) = -1 EACCES (Permission denied)
> > > >
> > > > Documentation from the Unisys Mainframe can be found here....
> > > >
> > > >
> > http://public.support.unisys.com/aseries/docs/clearpath-mcp-12.0/pdf/70118328-103.pdf
> > > > Pages:  C-2 and C3 show what POSIX functions are/not supported
> > > > utime() and utimensat() are not among the supported functions listed
> > there.
> > > >
> > > >
> > > > Is there any combination of parameters to mount.cifs that can be used
> > that
> > > > would prevent touch from reporting this error?
> > > >
> > > >
> > > >
> >
> > (cc'ing linux-cifs ml)
> >
> > Most likely, this is a local (unix) permissions issue. CIFS has a rather
> > unintuitive permissions model. It attempts to enforce permissions
> > locally, but doesn't really have enough information to do so properly.
> > This leads to these sorts of problems.
> >
> > When you create files as a particular user, then they end up being
> > owned by the "default" file owner on the mount rather than the user
> > that just created the file. Then when you go to set the time, the
> > kernel tries to enforce the permissions on the file and denies you
> > access to do so. This varies somewhat depending on whether CIFS posix
> > extensions are in force, but it's a common problem.
> >
> > The best scheme is to switch the mount to being multiuser, but that
> > requires a kerberized setup at the moment.
> >
> > Another workaround is to mount with '-o noperm' which disables local
> > permissions checking entirely. This will however allow any process on
> > the box to read and write to the server using the mount credentials.
> >
> > Another idea is to get creative with the uid=,gid=,file_mode=, and
> > dir_mode= options. See the mount.cifs manpage. If you're careful, you
> > can craft a set of options that will allow the users you want to have
> > proper access without opening everything up.
> >
> > My SambaXP talk from last year covers a lot of this in detail if you're
> > interested....
> >
> >    http://sambaxp.org/index.php?id=38
> >
> > Good luck!
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
> 
> Jeff,
> 
> Thanks for all the info.
> 
> A wireshark analysis shows that the Mainframe here is returning a frame that
> shows that the file is created and granted exclusive open for writing.  The
> file actually gets created on the Mainframe (presumably because of the
> combination of my uid=,gid=,file_mode=, and
> dir_mode= options) and I can modify it from all users on the mount.cifs
> box.  The next request is from the mount.cifs box to modify "Created, Last
> Access, Last Write, and Change" timestamp attributes for the (already)
> opened file.  The response frame from the Mainframe is a basic "Access
> Denied" message which I suppose the touch command turns into a "setting
> times of" ... Permission Denied message being returned.
> 

In that case, none of what I said above applies :)

This sounds like a server implementation issue. If the server doesn't
support this call, then there's not much you can do other than report
it to them as a bug and plan to ignore it.

> I'd like to try and get a kerberized setup going with mount.cifs.  I see the
> sec=krb5 option, but is there a series of other config steps that I need to
> perform (modifying /etc/krb5.conf for example).  Supposedly the Mainframe
> already has kerberos mapping setup for all the users on our mount.cifs
> system.
> 
> Any references (besides the mount.cifs manpage) that you can provide that
> walk through the kerberized setup would be appreciated.
> 

There isn't much, mostly you need to set up krb5 on the client, and
then set up cifs.upcall to be called when the kernel requests a key
(see the cifs.upcall manpage for details on that). After that it should
"just work".

That said, it's not likely to help this specific problem...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
