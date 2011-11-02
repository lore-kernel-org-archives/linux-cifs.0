From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: How to test multiusermount?
Date: Wed, 2 Nov 2011 15:08:28 -0400
Message-ID: <20111102150828.1a8ecf43@tlielax.poochiereds.net>
References: <CANXojcwxf0aD=_18_6D6=WkG86F9Qx4PTf7F=2husGbASac6hA@mail.gmail.com>
	<20111101060428.5d474bb9@tlielax.poochiereds.net>
	<CANXojcx0=j-hLOEO3qQyx65C8mB4sQ6mLhT5AY9vPtwcko5HAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANXojcx0=j-hLOEO3qQyx65C8mB4sQ6mLhT5AY9vPtwcko5HAQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2 Nov 2011 16:56:05 +0100
Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi,
> 
> thanks,
> 
> but what are unity mapped uids? Uids coming from a shared db like ldap and ads?
> 

That just means that the client and server need to have identically
mapped uid/gid's. For instance, user1 on the client needs to have the
same uid as user1 on the server.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
