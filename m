From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: build warning after merge of the cifs tree
Date: Sun, 30 Jan 2011 21:25:08 -0600
Message-ID: <AANLkTineJds4VXmYP7q68C5mk_KD_TyMT7Fj=KE0BupJ@mail.gmail.com>
References: <20110131132743.4ae5d4ae.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110131132743.4ae5d4ae.sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Noticed this Friday but had a pending merge request (upstream) in so
was holding off.  I now have merged the fix for this crypto cleanup
warning.

On Sun, Jan 30, 2011 at 8:27 PM, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org=
> wrote:
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
>
> fs/cifs/link.c: In function 'symlink_hash':
> fs/cifs/link.c:58: warning: 'rc' may be used uninitialized in this fu=
nction
>
> and, indeed, it may be ...
>
> Introduced by commit ee2c9258501f83d3ed0fd09ce5df1cec53312cf0 ("cifs:
> More crypto cleanup (try #2)").
> --
> Cheers,
> Stephen Rothwell =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sfr-3FnU+UHB4dPYtjvyW6yDsg@public.gmane.org=
=2Eorg.au
> http://www.canb.auug.org.au/~sfr/
>



--=20
Thanks,

Steve
