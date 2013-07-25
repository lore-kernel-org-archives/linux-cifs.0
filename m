From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cifs: Move string length definitions to uapi
Date: Thu, 25 Jul 2013 14:18:57 -0400
Message-ID: <20130725141857.4094aaaf@tlielax.poochiereds.net>
References: <1374773721-24394-1-git-send-email-scott.lovenberg@gmail.com>
	<20130725135558.43d88c96@tlielax.poochiereds.net>
	<CAFB9KM2A9ptufqJp5wJxOGpVwmBL8E1GERDEVt3KigrSUmj_nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org>,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM2A9ptufqJp5wJxOGpVwmBL8E1GERDEVt3KigrSUmj_nw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 25 Jul 2013 14:04:14 -0400
Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Jul 25, 2013 at 1:55 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Thu, 25 Jul 2013 13:35:20 -0400
> > scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> > > From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > @@ -41,12 +42,8 @@
> > >  #define MAX_SES_INFO 2
> > >  #define MAX_TCON_INFO 4
> > >
> > > -#define MAX_TREE_SIZE (2 + MAX_SERVER_SIZE + 1 + MAX_SHARE_SIZE + 1)
> > > +#define MAX_TREE_SIZE (2 + MAX_SERVER_SIZE + 1 + CIFS_MAX_SHARE_LEN + 1)
> > >  #define MAX_SERVER_SIZE 15
> >                 ^^^^^^^
> > This looks wrong too. IIUC, that should be the max length of the
> > "server" portion of the field. The fact that MAX_TREE_SIZE is pretty
> > long is likely what papers over this...
> >
> > The userland helper uses NI_MAXHOST for this field, but that's not
> > defined in the kernel. Perhaps this should be given a name like
> > CIFS_NI_MAXHOST, and expanded to the same size as the mount helper uses
> > (1025)?
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> I didn't touch that because I really wasn't sure either.  Wouldn't we
> want to make that 1024 and add 1 for the null terminator in-line to be
> consistent?  Other than that, I'm on board with that idea.
> 

Yeah, sounds reasonable.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
