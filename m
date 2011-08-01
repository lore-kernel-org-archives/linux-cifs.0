From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [v5 PATCH 1/5] CIFS: Move buffer allocation to a separate function
Date: Mon, 1 Aug 2011 07:36:55 -0500
Message-ID: <CAH2r5mvuUPHkBGNKLXAAUsWx5Vv3gmy=hnYM-z48=0sOBaVRnA@mail.gmail.com>
References: <1312190384-3376-1-git-send-email-piastryyy@gmail.com>
	<1312190384-3376-2-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1312190384-3376-2-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Revewed and Merged (still reviewing the others).

Any idea why your patches (at least the last few) show up
with the following checkpatch warning (I don't think
it is a problem but thought it might be old git tools
on your system which generated the patch).


stevef@stevef-laptop:~/cifs-2.6$ scripts/checkpatch.pl ~/pavel1b.patch
WARNING: Use a single space after To:
#36:
To:	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

total: 0 errors, 1 warnings, 153 lines checked

/home/stevef/pavel1b.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.


On Mon, Aug 1, 2011 at 4:19 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
> Reviewed-and-Tested-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 92 +++++++++++++++++++++++++++++++--------=
-------------
> =A01 files changed, 55 insertions(+), 37 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 50b3523..217d365 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c

--=20
Thanks,

Steve
