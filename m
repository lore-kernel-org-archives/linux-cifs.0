From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: build failure after merge of the cifs tree
Date: Thu, 12 Aug 2010 13:21:22 -0500
Message-ID: <AANLkTi=bAGSrPbqmOUbt9O7G0SbOXYTtNDYZ-e5JPsrS@mail.gmail.com>
References: <20100812131741.f3a800d7.sfr@canb.auug.org.au>
	<AANLkTi=iHi=kpk+nsB396B9GWdefj=WJywA2K1PawHxi@mail.gmail.com>
	<20100812174621.b1dbc20f.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Bryan Schumaker <bjschuma-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100812174621.b1dbc20f.sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Aug 12, 2010 at 2:46 AM, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org=
> wrote:
> See above. =A0You need CONFIG_NFS_USE_KERNEL_DNS to also depend on
> CONFIG_KEYS ...

=46ixed in cifs-2.6.git


--=20
Thanks,

Steve
