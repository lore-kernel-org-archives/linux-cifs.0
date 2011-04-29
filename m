From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/5] cifs: fix some bounds checking problems
Date: Fri, 29 Apr 2011 00:05:09 -0500
Message-ID: <BANLkTimNseyrXc9ZDz0N4tomRx1oy5P60Q@mail.gmail.com>
References: <1303819401-14789-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303819401-14789-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I merged the following 3 into cifs-2.6.git (from the versions in your
cifs-2.6.39 branch).  Was curious why the last two weren't in that
branch.

cifs: change bleft in decode_unicode_ssetup back to signed type
cifs: check for bytes_remaining going to zero in CIFS_SessSetup
cifs: sanitize length checking in coalesce_t2

On Tue, Apr 26, 2011 at 7:03 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> This patchset fixes a number of problems that David pointed out while
> reviewing some backports for RHEL. I think they're appropriate for
> 2.6.39 and probably the stable series as well.
>
> Jeff Layton (5):
> =A0cifs: change bleft in decode_unicode_ssetup back to signed type
> =A0cifs: check for bytes_remaining going to zero in CIFS_SessSetup
> =A0cifs: sanitize length checking in coalesce_t2
> =A0cifs: refactor mid finding loop in cifs_demultiplex_thread
> =A0cifs: handle errors from coalesce_t2
>
> =A0fs/cifs/connect.c | =A0117 +++++++++++++++++++++++++++++----------=
-------------
> =A0fs/cifs/sess.c =A0 =A0| =A0 19 ++-------
> =A02 files changed, 69 insertions(+), 67 deletions(-)
>
> --
> 1.7.4.4
>
>



--=20
Thanks,

Steve
