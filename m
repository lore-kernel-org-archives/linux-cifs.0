From: Tim Lank <timlank@timlank.com>
Subject: Re: mount.cifs -> Unisys MCP Mainframe -- Linux touch
 command "setting times of `testfile.txt': Permission denied"
Date: Wed, 31 Aug 2011 17:35:39 -0400
Message-ID: <CAHyifnQWeKpviqFN6hkahy2mVx2X8GUftEP+3kY0Eo=5vq=4JQ@mail.gmail.com>
References: <CAHyifnSXNRHfNmyQw0HXyqqwthCQ5si-JQc95JmuriYpf0ZL7g@mail.gmail.com>
	<CAHyifnQkFQ6kn5patfA7dYOFHxqyu263KhVN9EGVmRZvei0wRw@mail.gmail.com>
	<20110831154125.3e1f1a00@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: samba@lists.samba.org, linux-cifs@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <samba-bounces@lists.samba.org>
In-Reply-To: <20110831154125.3e1f1a00@tlielax.poochiereds.net>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba>,
	<mailto:samba-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba>
List-Post: <mailto:samba@lists.samba.org>
List-Help: <mailto:samba-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba>,
	<mailto:samba-request@lists.samba.org?subject=subscribe>
Sender: samba-bounces@lists.samba.org
Errors-To: samba-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Wed, Aug 31, 2011 at 3:41 PM, Jeff Layton <jlayton@redhat.com> wrote:

> On Wed, 31 Aug 2011 14:55:26 -0400
> Tim Lank <timlank@timlank.com> wrote:
>
> > the mount.cifs is from (cifs-utils-4.8.1-2.el6.x86_64)
> >
> >
> > On Tue, Aug 30, 2011 at 8:05 PM, Tim Lank <timlank@timlank.com> wrote:
> >
> > > I've got a share from a Unisys MCP Mainframe mounted with mount.cifs
> from
> > > RHEL 6.1 (samba-common-3.5.6-86.el6.x86_64).
> > >
> > > when I try to touch a file, it creates the file, but reports an error -
> > > "setting times of `testfile.txt': Permission denied"
> > >
> > > strace on the touch command shows that it is erroring out on the
> > > utimensat() call
> > >
> > > utimensat(0, NULL, NULL, 0) = -1 EACCES (Permission denied)
> > >
> > > Documentation from the Unisys Mainframe can be found here....
> > >
> > >
> http://public.support.unisys.com/aseries/docs/clearpath-mcp-12.0/pdf/70118328-103.pdf
> > > Pages:  C-2 and C3 show what POSIX functions are/not supported
> > > utime() and utimensat() are not among the supported functions listed
> there.
> > >
> > >
> > > Is there any combination of parameters to mount.cifs that can be used
> that
> > > would prevent touch from reporting this error?
> > >
> > >
> > >
>
> (cc'ing linux-cifs ml)
>
> Most likely, this is a local (unix) permissions issue. CIFS has a rather
> unintuitive permissions model. It attempts to enforce permissions
> locally, but doesn't really have enough information to do so properly.
> This leads to these sorts of problems.
>
> When you create files as a particular user, then they end up being
> owned by the "default" file owner on the mount rather than the user
> that just created the file. Then when you go to set the time, the
> kernel tries to enforce the permissions on the file and denies you
> access to do so. This varies somewhat depending on whether CIFS posix
> extensions are in force, but it's a common problem.
>
> The best scheme is to switch the mount to being multiuser, but that
> requires a kerberized setup at the moment.
>
> Another workaround is to mount with '-o noperm' which disables local
> permissions checking entirely. This will however allow any process on
> the box to read and write to the server using the mount credentials.
>
> Another idea is to get creative with the uid=,gid=,file_mode=, and
> dir_mode= options. See the mount.cifs manpage. If you're careful, you
> can craft a set of options that will allow the users you want to have
> proper access without opening everything up.
>
> My SambaXP talk from last year covers a lot of this in detail if you're
> interested....
>
>    http://sambaxp.org/index.php?id=38
>
> Good luck!
> --
> Jeff Layton <jlayton@redhat.com>
>

Jeff,

Thanks for all the info.

A wireshark analysis shows that the Mainframe here is returning a frame that
shows that the file is created and granted exclusive open for writing.  The
file actually gets created on the Mainframe (presumably because of the
combination of my uid=,gid=,file_mode=, and
dir_mode= options) and I can modify it from all users on the mount.cifs
box.  The next request is from the mount.cifs box to modify "Created, Last
Access, Last Write, and Change" timestamp attributes for the (already)
opened file.  The response frame from the Mainframe is a basic "Access
Denied" message which I suppose the touch command turns into a "setting
times of" ... Permission Denied message being returned.

I'd like to try and get a kerberized setup going with mount.cifs.  I see the
sec=krb5 option, but is there a series of other config steps that I need to
perform (modifying /etc/krb5.conf for example).  Supposedly the Mainframe
already has kerberos mapping setup for all the users on our mount.cifs
system.

Any references (besides the mount.cifs manpage) that you can provide that
walk through the kerberized setup would be appreciated.

Thanks,
Tim
-- 
To unsubscribe from this list go to the following URL and read the
instructions:  https://lists.samba.org/mailman/options/samba
