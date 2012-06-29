From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: How the krb ticket is found?
Date: Fri, 29 Jun 2012 14:42:17 -0400
Message-ID: <20120629144217.7d0bbaa6@tlielax.poochiereds.net>
References: <CANXojczkVJ6j-Nowmb9bEc7M_wyc-D-=APs5JnD9G5SWQb50FA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANXojczkVJ6j-Nowmb9bEc7M_wyc-D-=APs5JnD9G5SWQb50FA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 24 Jun 2012 22:58:31 +0200
Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi,
> 
> I'm would like to know how mount.cifs gets the right ticket?
> 
> In my situation the mount is done for a user. Simular like the setting of the
> credentialsfile with credentials= option, but with kerberos how gets
> mount.cifs the right
> ticket, belonging to that user? Set the user= argument?
> 
> I'm not talking about multiuser mounts.
> 
> Is the cruid= the right option here??
> 
> Stef

Yes, the cruid= option gets passed to cifs.upcall, and tells it who's
credcache to use.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
