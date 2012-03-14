From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: use standard token parser for mount options
Date: Wed, 14 Mar 2012 14:17:26 -0400 (EDT)
Message-ID: <24dc471d-42ca-45cf-89eb-26dc3117fa1a@zmail17.collab.prod.int.phx2.redhat.com>
References: <4F5A2CCD.6010808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeffrey Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F5A2CCD.6010808-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thanks Scott,

Steve/Jeff, can I get your comments on this patch please.

Sachin Prabhu

----- Original Message -----
> On 3/9/2012 10:57 AM, Scott Lovenberg wrote:
> >
> >
> > On Fri, Mar 9, 2012 at 10:33, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > <mailto:sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>> wrote:
> >
> >     Use the standard token parser instead of the long if confidtion
> >     to
> >     parse
> >     cifs mount options.
> >
> >     This was first proposed by Scott Lovenberg
> >     http://lists.samba.org/archive/linux-cifs-client/2010-May/006079.html
> >
> >     Mount options have been grouped together in terms of their
> >     input
> >     types.
> >     Aliases for username, password, domain and credentials have
> >     been
> >     added.
> >     The password parser has been modified to make it easier to
> >     read.
> >
> >     Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> >     <mailto:sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>>
> >
> [CC'ing the list my response... kernel.org didn't like my HTML
> formatted
> email]
> Thanks. :)  IIRC, Jeff was getting panics on a Fedora box using this
> patch.  I never got around to fixing it.  I'll still sign off on it
> though.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
