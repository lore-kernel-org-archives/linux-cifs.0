From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: DNS resolver cache does not expire
Date: Mon, 27 Jun 2011 20:42:10 +0100
Message-ID: <28505.1309203730@redhat.com>
References: <BANLkTikOq_dT1SF9aZ=0DNdoVOngvygfZw@mail.gmail.com> <BANLkTim+Phg+cY6_KAhxhfSeDj1td_GALw@mail.gmail.com> <BANLkTikbk1yvwWCvhmqdH1DHZN1PPEz+hw@mail.gmail.com> <21187.1309178053@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Grazvydas Ignotas <notasas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikOq_dT1SF9aZ=0DNdoVOngvygfZw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Yes, I meant, that dns_query calls request_key -> request_key_and_link
> -> construct_key_and_link -> construct_alloc_key -> key_alloc and
> there expiry timeout is set to zero. I don't noticed any other places
> where this value changes while request_key is being processing. If I
> miss something, point me, please!

request_key() upcalls to userspace.  The userspace application should call
keyctl_set_timeout() before calling keyctl_instantiate().

David
