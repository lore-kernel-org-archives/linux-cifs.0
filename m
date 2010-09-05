From: Andrew Hendry <andrew.hendry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] cifs: stop cifsd from exiting prematurely
Date: Sun, 5 Sep 2010 11:19:28 +1000
Message-ID: <AANLkTi=yigK6WHzPij2SopKAbZZ3=urOLYUjTrF3iH+b@mail.gmail.com>
References: <1283516711-15073-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283516711-15073-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Jeff,

Ive put your patches on the system which had the issue once.
cifs and mounts are working ok. As I can't find a way to reliably
reproduce it, I'll just leave it running and check its logs daily.


On Fri, Sep 3, 2010 at 10:25 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> We've had some sporradic reports of problems recently where the
> ses->server pointers have been NULL. That pointer should only get set=
 to
> NULL when cifs_demultiplex_thread exits. That should only happen when
> the last reference to it is put. If it gets cleaned up before then,
> other structures will hold pointers to it, and we'll get NULL pointer
> dereferences.
>
> Unfortunately, there are some places in cifs_demuliplex_thread where
> this rule is broken. In certain error conditions, cifsd will exit eve=
n
> though the reference count hasn't gone to zero yet. This patchset is
> intended to close these holes. With it, cifsd should only exit when t=
he
> last reference to it is put.
>
> Exiting from the loop early is a serious error that's likely to cause=
 an
> oops. I think we ought to consider this patchset for 2.6.36 and maybe
> for stable.
>
> Thoughts?
>
> Jeff Layton (3):
> =A0cifs: prevent cifsd from exiting prematurely
> =A0cifs: eliminate some more premature cifsd exits
> =A0cifs: prevent possible memory corruption in cifs_demultiplex_threa=
d
>
> =A0fs/cifs/cifsproto.h | =A0 =A03 +-
> =A0fs/cifs/connect.c =A0 | =A0 58 +++++++++++++++++------------------=
---------------
> =A0fs/cifs/netmisc.c =A0 | =A0 22 +++++++++++--------
> =A03 files changed, 35 insertions(+), 48 deletions(-)
>
>
