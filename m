From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: build failure after merge of the cifs tree
Date: Tue, 25 Oct 2011 09:51:37 -0500
Message-ID: <CAH2r5muLiYKCrS2f_DftZSnyuP0EC+vu99mENznCSL8ecnTkpg@mail.gmail.com>
References: <20111026005939.ad20ab7a2dacce216c69e821@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Linus <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111026005939.ad20ab7a2dacce216c69e821-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Am fixing it now.  Jeff missed a stub for the non-freezer case.

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index a155561..cd2d55b 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -202,6 +202,8 @@ static inline void set_freezable_with_signal(void) =
{}

 #define wait_event_freezable_timeout(wq, condition, timeout)		\
 		wait_event_interruptible_timeout(wq, condition, timeout)
+#define #define wait_event_freezekillable(wq, condition)		\
+		wait_event_killable(wq, condition)


On Tue, Oct 25, 2011 at 8:59 AM, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org=
> wrote:
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> iseries_defconfig) failed like this:
>
> fs/cifs/transport.c: In function 'wait_for_response':
> fs/cifs/transport.c:328: error: implicit declaration of function 'wai=
t_event_freezekillable'
>
> Caused by commit f06ac72e9291 ("cifs, freezer: add
> wait_event_freezekillable and have cifs use it"). =A0In this config,
> CONFIG_FREEZER is not set.
> --
> Cheers,
> Stephen Rothwell =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sfr-3FnU+UHB4dPYtjvyW6yDsg@public.gmane.org=
=2Eorg.au
> http://www.canb.auug.org.au/~sfr/
>



--=20
Thanks,

Steve
