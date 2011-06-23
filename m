From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: DNS resolver cache does not expire
Date: Thu, 23 Jun 2011 23:15:29 +0400
Message-ID: <BANLkTikbk1yvwWCvhmqdH1DHZN1PPEz+hw@mail.gmail.com>
References: <BANLkTim+Phg+cY6_KAhxhfSeDj1td_GALw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Grazvydas Ignotas <notasas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTim+Phg+cY6_KAhxhfSeDj1td_GALw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/6/23 Grazvydas Ignotas <notasas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Hello,
>
> one of our slave servers have changed it's address, and I can no
> longer access it's shares that are forwarded to by the main server
> using DFS redirection. The slave server resolves correctly when trying
> to access it directly, but when trying to access through a mount on
> the main server, cifsFYI shows dns_resolve_server_name_to_ip returns
> the old address. I've verified slave server names match and windows
> clients can access those DFS shares correctly. It has been several
> days since server address change. I'm running 2.6.38.2 kernel on
> Ubuntu 10.04.
>
> Any way to clear that dns_resolver cache? I have no desire to reboot
> the machine.
>

It seems that dns_resolver sets expiry timeout to zero here
(http://lxr.free-electrons.com/source/security/keys/key.c#L310) and
doesn't change it - so, it always returns cached value.

David, can you comment on this problem, please?

-- 
Best regards,
Pavel Shilovsky.
