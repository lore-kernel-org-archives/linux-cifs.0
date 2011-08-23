From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: Add mount option named backup
Date: Tue, 23 Aug 2011 09:15:10 -0400
Message-ID: <20110823091510.2d8b8027@corrin.poochiereds.net>
References: <1313166821-9172-1-git-send-email-shirishpargonkar@gmail.com>
	<CADT32eJsAgNkhnY1VZ6wpxa2013h7TmO6i3H=4a6D8ke8iU2Aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eJsAgNkhnY1VZ6wpxa2013h7TmO6i3H=4a6D8ke8iU2Aw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 22 Aug 2011 08:33:49 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Aug 12, 2011 at 11:33 AM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >
> >
> > Add mount option backup.
> >
> > It allows an authenticated user to access files with the intent to back them
> > up including their ACLs, who may not have access permission but has
> > "Backup files and directories user right" on them (by virtue of being part
> > of the built-in group Backup Operators.
> >
> > If an authenticated user is not part of the built-in group Backup Operators
> > at the server, access to such files is denied.
> >
> >
> > Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
>
> 
> Jeff,  Steve,
> 
> Any comments on this patch (and manpage patch in cifs-utils)?
> 

This seems like a really nasty kludge. It doesn't seem like the
implications of this have been carefully considered.

What happens I mount with the "backup" flag and do not have the
necessary permissions on the server to use the flag in an open? Will
this new flag be mutually exclusive with "multiuser"?

One idea that might be better is to come up with way to mark certain
(unix) users with the appropriate flag. If all the backup users were in
a certan group, for instance, then you could use that info to decide
whether to set the flag in the open calls.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
