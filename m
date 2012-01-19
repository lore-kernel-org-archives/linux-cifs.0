From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: build failure after merge of the cifs tree
Date: Wed, 18 Jan 2012 18:31:11 -0600
Message-ID: <CAH2r5mv-dbFM0jf9V+=y-N8tuQey=MgcfToPzBg3hRvFbCWeBA@mail.gmail.com>
References: <20120119110153.7ffa3312b2943386750ac7ed@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120119110153.7ffa3312b2943386750ac7ed-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I already fixed that and merged it into cifs-2.6.git.   If you repull
you will get the fix for that.

On Wed, Jan 18, 2012 at 6:01 PM, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org=
> wrote:
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> fs/cifs/connect.c: In function 'cifs_set_vol_auth':
> fs/cifs/connect.c:3843:17: error: 'CIFSSEC_MUST_LANMAN' undeclared (f=
irst use in this function)
> fs/cifs/connect.c:3843:17: note: each undeclared identifier is report=
ed only once for each function it appears in
>
> Caused by commit 8a8798a5ff90 ("cifs: fetch credentials out of keyrin=
g
> for non-krb5 auth multiuser mounts").
>
> I have used the cifs tree from next-20120118 for today.
> --
> Cheers,
> Stephen Rothwell =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sfr-3FnU+UHB4dPYtjvyW6yDsg@public.gmane.org=
=2Eorg.au
> http://www.canb.auug.org.au/~sfr/



--=20
Thanks,

Steve
