From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: DNS resolver cache does not expire
Date: Mon, 27 Jun 2011 13:34:13 +0100
Message-ID: <21187.1309178053@redhat.com>
References: <BANLkTikbk1yvwWCvhmqdH1DHZN1PPEz+hw@mail.gmail.com> <BANLkTim+Phg+cY6_KAhxhfSeDj1td_GALw@mail.gmail.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Grazvydas Ignotas <notasas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikbk1yvwWCvhmqdH1DHZN1PPEz+hw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> It seems that dns_resolver sets expiry timeout to zero here
> (http://lxr.free-electrons.com/source/security/keys/key.c#L310) and
> doesn't change it - so, it always returns cached value.

That's not the DNS resolver you've provided a pointer to - that's where the
key allocator initialises a new key.

> David, can you comment on this problem, please?

It's not much of a problem.  Userspace needs to set the key timeout before
instantiating the key:

http://git.kernel.org/?p=linux/kernel/git/dhowells/keyutils.git;a=blob;f=key.dns_resolver.c;h=ab9b87875bcd94dae3083b2711207f87ceea7df1;hb=faabd7c8464502becd01972b1a76ab1dfa1906cc#l502

David
