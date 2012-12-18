From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Do not enable debugging code by default
Date: Tue, 18 Dec 2012 07:13:17 -0500
Message-ID: <20121218071317.01cbc41b@tlielax.poochiereds.net>
References: <1355737085-6671-1-git-send-email-bp@alien8.de>
	<CAH2r5mt=4ZoGR_4hP52uHsZabXpPfh1sa1X0GSg6W4=fawNFnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mt=4ZoGR_4hP52uHsZabXpPfh1sa1X0GSg6W4=fawNFnA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 17 Dec 2012 09:30:33 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I don't think taking out debugging makes sense - we need debugging a
> lot more often than expected even to diagnose user errors (usually
> relating to session establishment failures, since we are very limited
> in how much information can be passed back in mount).   If we had
> dynamic trace points for cifs and for common vfs entry points, or if
> the distros shipped dual cifs modules (one with debugging and one
> without), I wouldn't mind disabling it - but multiple times a month we
> have to diagnose user problems (sometimes user errors, sometimes
> server bugs etc.) by enabling debugging.
> 
> On Mon, Dec 17, 2012 at 3:38 AM, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:
> > Debugging code is generally disabled in the configurator since it is
> > only for devs and testers and not for the majority of the installations.
> >
> > Cc: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
> > Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Signed-off-by: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> > ---
> >  fs/cifs/Kconfig | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> > index 21ff76c22a17..241a0e2853c5 100644
> > --- a/fs/cifs/Kconfig
> > +++ b/fs/cifs/Kconfig
> > @@ -124,7 +124,6 @@ config CIFS_ACL
> >
> >  config CIFS_DEBUG
> >         bool "Enable CIFS debugging routines"
> > -       default y
> >         depends on CIFS
> >         help
> >            Enabling this option adds helpful debugging messages to
> > --
> > 1.8.1.rc2
> >

I agree that we often need cifsFYI debug info in order to troubleshoot
problems. The question here though is whether compiling those in ought
to be the default.

In generic distro kernels, I think we do want that turned on even in
non-debug kernels. On an embedded arch, it's less compelling.

Might it make sense to couple this change with a change to the
CONFIG_CIFS_DEBUG help text? Something like:

"This option defaults to 'N', but enabling this is strongly encouraged
unless memory is severely constrained."

Then we can just try to make sure non-embedded distros enable it.
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
