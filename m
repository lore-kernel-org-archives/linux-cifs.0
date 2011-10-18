From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: mention the kernel version that introduced getcifsacl
Date: Tue, 18 Oct 2011 04:35:05 -0500
Message-ID: <CADT32eLiG_oqKEu6dtEXyH6kepMwGt+G_+5OJTxefO8y85oCHA@mail.gmail.com>
References: <4E9D1E5D.4020603@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: sjayaraman-l3A5Bk7waGM@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E9D1E5D.4020603-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 18, 2011 at 1:36 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> =
wrote:
>
> Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
> =A0getcifsacl.8.in | =A0 =A03 +++
> =A01 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/getcifsacl.8.in b/getcifsacl.8.in
> index 02e1355..f79f7ff 100644
> --- a/getcifsacl.8.in
> +++ b/getcifsacl.8.in
> @@ -40,6 +40,9 @@ Print version number and exit\&.
> =A0.RS 4
> =A0Display a security descriptor in raw mode. Values such as type and=
 flags are displayed in hexadecimal format, a SID is not mapped to a na=
me.
> =A0.RE
> +.SH "NOTES"
> +.PP
> +Kernel support for getcifsacl/setcifsacl utilities was initially int=
roduced in the 2.6.37 kernel.

Looks fine.  Just a nitpicking, since this is a getcifsacl manpage,
does setcifsacl also need to be mentioned here?

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

> =A0.SH "SEE ALSO"
> =A0.PP
> =A0\fBmount.cifs\fR(8),
>
