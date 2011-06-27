From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: DNS resolver cache does not expire
Date: Mon, 27 Jun 2011 21:27:51 +0400
Message-ID: <BANLkTikOq_dT1SF9aZ=0DNdoVOngvygfZw@mail.gmail.com>
References: <BANLkTim+Phg+cY6_KAhxhfSeDj1td_GALw@mail.gmail.com>
	<BANLkTikbk1yvwWCvhmqdH1DHZN1PPEz+hw@mail.gmail.com>
	<21187.1309178053@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Grazvydas Ignotas <notasas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <21187.1309178053-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/6/27 David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> It seems that dns_resolver sets expiry timeout to zero here
>> (http://lxr.free-electrons.com/source/security/keys/key.c#L310) and
>> doesn't change it - so, it always returns cached value.
>
> That's not the DNS resolver you've provided a pointer to - that's whe=
re the
> key allocator initialises a new key.

Yes, I meant, that dns_query calls request_key -> request_key_and_link
-> construct_key_and_link -> construct_alloc_key -> key_alloc and
there expiry timeout is set to zero. I don't noticed any other places
where this value changes while request_key is being processing. If I
miss something, point me, please!

>
>> David, can you comment on this problem, please?
>
> It's not much of a problem. =A0Userspace needs to set the key timeout=
 before
> instantiating the key:
>
> http://git.kernel.org/?p=3Dlinux/kernel/git/dhowells/keyutils.git;a=3D=
blob;f=3Dkey.dns_resolver.c;h=3Dab9b87875bcd94dae3083b2711207f87ceea7df=
1;hb=3Dfaabd7c8464502becd01972b1a76ab1dfa1906cc#l502
>
> David
>

That makes the problem with setting expiry time to zero clear. Thanks!

--=20
Best regards,
Pavel Shilovsky.
