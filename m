From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: should we change the name of get/setcifsacl ?
Date: Sun, 25 Sep 2011 06:07:39 -0400
Message-ID: <20110925060739.6167abb8@tlielax.poochiereds.net>
References: <20110924083751.111d85a7@tlielax.poochiereds.net>
	<CADT32eKZKKmo+aEp4P9tFkJNfUY=oueW=6=-gUe_5sxEYS9Fiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eKZKKmo+aEp4P9tFkJNfUY=oueW=6=-gUe_5sxEYS9Fiw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 24 Sep 2011 12:05:03 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Sat, Sep 24, 2011 at 7:37 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > The nfs4 ACL tools are called nfs4_getfacl and nfs4_setfacl. I think it
> > would probably be good for consistency's sake to change the name of the
> > cifs variants to cifs_getfacl and cifs_setfacl.
> >
> > Any thoughts or objections?
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >
> 
> I have no objection/preference for the tools' names.
> But there is getfacl and setfacl. And I think richacl has tool/s
> such as setrichacl.
> 

Fair enough then. If the richacl tools are named along those
lines, I'll just leave the cifs ones named as they are.

Thanks.
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
