From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: DNS resolver cache does not expire
Date: Tue, 28 Jun 2011 11:10:47 +0100
Message-ID: <20945.1309255847@redhat.com>
References: <BANLkTinN0pXZsPADfzvO8p+Jf0i3tWtKpw@mail.gmail.com> <BANLkTim+Phg+cY6_KAhxhfSeDj1td_GALw@mail.gmail.com> <BANLkTikbk1yvwWCvhmqdH1DHZN1PPEz+hw@mail.gmail.com> <21187.1309178053@redhat.com> <BANLkTikOq_dT1SF9aZ=0DNdoVOngvygfZw@mail.gmail.com> <28505.1309203730@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
To: Grazvydas Ignotas <notasas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinN0pXZsPADfzvO8p+Jf0i3tWtKpw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Grazvydas Ignotas <notasas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> So in my case it's cifs.upcall that doesn't set the timeout I guess,
> as contents of my /etc/request-key.conf are:

Indeed.  In any case, the kernel doesn't know about the TTL userspace received
received from the DNS server, so userspace has to tell the kernel somehow.

David
