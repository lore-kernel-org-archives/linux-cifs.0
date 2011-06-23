From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: DNS resolver cache does not expire
Date: Thu, 23 Jun 2011 16:14:41 -0400
Message-ID: <20110623161441.35ea50a4@tlielax.poochiereds.net>
References: <BANLkTim+Phg+cY6_KAhxhfSeDj1td_GALw@mail.gmail.com>
	<BANLkTikbk1yvwWCvhmqdH1DHZN1PPEz+hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Grazvydas Ignotas <notasas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikbk1yvwWCvhmqdH1DHZN1PPEz+hw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 23 Jun 2011 23:15:29 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2011/6/23 Grazvydas Ignotas <notasas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> > Hello,
> >
> > one of our slave servers have changed it's address, and I can no
> > longer access it's shares that are forwarded to by the main server
> > using DFS redirection. The slave server resolves correctly when trying
> > to access it directly, but when trying to access through a mount on
> > the main server, cifsFYI shows dns_resolve_server_name_to_ip returns
> > the old address. I've verified slave server names match and windows
> > clients can access those DFS shares correctly. It has been several
> > days since server address change. I'm running 2.6.38.2 kernel on
> > Ubuntu 10.04.
> >
> > Any way to clear that dns_resolver cache? I have no desire to reboot
> > the machine.
> >
> 
> It seems that dns_resolver sets expiry timeout to zero here
> (http://lxr.free-electrons.com/source/security/keys/key.c#L310) and
> doesn't change it - so, it always returns cached value.
> 
> David, can you comment on this problem, please?
> 

I think the right thing to do here is probably to tie the lifetime of
the key to the record's TTL. Getting that info may be a little tricky
though since it's not generally available via getaddrinfo and such.

Also, for name records that come from /etc/hosts or yp, or some other
mechanism you'll need to pick a default TTL since those mechanisms
don't provide one.

-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
