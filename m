From: Grazvydas Ignotas <notasas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: DNS resolver cache does not expire
Date: Tue, 28 Jun 2011 12:47:40 +0300
Message-ID: <BANLkTinN0pXZsPADfzvO8p+Jf0i3tWtKpw@mail.gmail.com>
References: <BANLkTim+Phg+cY6_KAhxhfSeDj1td_GALw@mail.gmail.com>
	<BANLkTikbk1yvwWCvhmqdH1DHZN1PPEz+hw@mail.gmail.com>
	<21187.1309178053@redhat.com>
	<BANLkTikOq_dT1SF9aZ=0DNdoVOngvygfZw@mail.gmail.com>
	<28505.1309203730@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <28505.1309203730-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jun 27, 2011 at 10:42 PM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Yes, I meant, that dns_query calls request_key -> request_key_and_li=
nk
>> -> construct_key_and_link -> construct_alloc_key -> key_alloc and
>> there expiry timeout is set to zero. I don't noticed any other place=
s
>> where this value changes while request_key is being processing. If I
>> miss something, point me, please!
>
> request_key() upcalls to userspace. =A0The userspace application shou=
ld call
> keyctl_set_timeout() before calling keyctl_instantiate().

So in my case it's cifs.upcall that doesn't set the timeout I guess,
as contents of my /etc/request-key.conf are:
create	cifs.spnego	*	*		/usr/sbin/cifs.upcall -c %k
create	dns_resolver	*	*		/usr/sbin/cifs.upcall %k
