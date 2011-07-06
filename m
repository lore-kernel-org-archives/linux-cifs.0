From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: DFS referral patchset ("fix regressions when chasing DFS
 referrals at mount")
Date: Wed, 6 Jul 2011 12:44:33 -0500
Message-ID: <CAH2r5mvzjpZypBSCvtDxDSe=8LT49ESab1zHHZ6VjLJvVqqNUA@mail.gmail.com>
References: <1309974124.1899.2.camel@adam>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adam Williamson <awilliam-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1309974124.1899.2.camel@adam>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

thx - that is a big help

On Wed, Jul 6, 2011 at 12:42 PM, Adam Williamson <awilliam-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> Sorry I'm not replying to the thread, I'm not subscribed to this list=
=2E
> Just wanted to pass along that I tested Jeff's patch set - posted tod=
ay
> under the description "fix regressions when chasing DFS referrals at
> mount" - and found it good. I reported the initial bug which got him
> chasing this code, https://bugzilla.redhat.com/show_bug.cgi?id=3D7170=
60 -
> a CIFS mount that worked fine on my system with kernel 2.6.38 caused =
an
> oops and did not work with 3.0 kernels. With the patch set applied,
> there is no oops, and the mount succeeds. I do not have any other ser=
ver
> configs to test with, though, so I can't say I've done any particular
> regression testing, only confirmed that it fixes my specific issue.
> --
> Adam Williamson
> Fedora QA Community Monkey
> IRC: adamw | Fedora Talk: adamwill AT fedoraproject DOT org
> http://www.happyassassin.net
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
