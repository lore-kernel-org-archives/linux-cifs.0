From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Build infrastructure for storing NTLM creds in kernel keyring
Date: Tue, 6 Jul 2010 07:09:32 -0400
Message-ID: <20100706070932.093d8916@corrin.poochiereds.net>
References: <20100430091431.624ee020@tlielax.poochiereds.net>
	<EB4CC79E8F0546FF8AFBFD746C856421@lan.jax.org.ru>
	<20100525121037.219129da@corrin.poochiereds.net>
	<2AF95C52855747BABAE21349F35C773E@lan.jax.org.ru>
	<20100601074406.5b8f7a87@tlielax.poochiereds.net>
	<73A4A0D322484441A6CEF0FE91E5D263@lan.jax.org.ru>
	<20100625161632.5f9378b2@tlielax.poochiereds.net>
	<C3BD4CBCCAD04D9EA6E04D3B157A69A4@lan.jax.org.ru>
	<20100706070056.0b37e3d3@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100706070056.0b37e3d3-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 6 Jul 2010 07:00:56 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> On Tue, 6 Jul 2010 14:04:44 +0400
> "Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > As I saw current kernel code had no method for checking from userspace is 
> > the entered credentials are wrong without mount. Is it's right?
> 
> Correct. You really can't check without connecting to the server.

We certainly could have this tool use libsmbclient to connect to the
server and authenticate to test the creds. I wouldn't bother with that
for the initial implementation though -- keep it simple. Still it's
something to keep in mind while you're coding this up.

> 
> > But if user want to update them there are should be a mechanism for clearing 
> > old or wrong creds. As my opinion it may be something like --clear option.
> 
> Sounds good. You will want to be able to update or clear invalid creds.
> 
> > Besides, is it right to store multiple identical creds in keyring or creds 
> > with the same user and domain_host name?
> 
> Not sure that I see any point in multiple creds per user@host or
> user@domain. Only one will ever be valid for each combination. Why
> would you want multiple sets? How would you know which ones to use?
> 


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
