From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: mention the kernel version that introduced setcifsacl
Date: Tue, 18 Oct 2011 04:34:08 -0500
Message-ID: <CADT32e+1oxnyO7Ajt__PSSMQLDntpV_RvgPBdT15vV0yFZmbWg@mail.gmail.com>
References: <4E9D1E69.6060408@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: sjayaraman-l3A5Bk7waGM@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E9D1E69.6060408-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 18, 2011 at 1:36 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> =
wrote:
>
> Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
> =A0setcifsacl.8.in | =A0 =A03 +++
> =A01 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/setcifsacl.8.in b/setcifsacl.8.in
> index 98ab0ac..a18b3de 100644
> --- a/setcifsacl.8.in
> +++ b/setcifsacl.8.in
> @@ -68,6 +68,9 @@ type: ALLOWED (0x0), DENIED (0x1), OBJECT_ALLOWED (=
0x5), OBJECT_DENIED (0x6)
> =A0flags: OBJECT_INHERIT_FLAG (OI or 0x1), CONTAINER_INHERIT_FLAG (CI=
 or 0x2), NO_PROPAGATE_INHERIT_FLAG (NI or 0x4), INHERIT_ONLY_FLAG (IO =
or 0x8), INHERITED_ACE_FLAG (IA or 0x10) or a combination/OR of these v=
alues.
> =A0.PP
> =A0mask: Either one of FULL, CHANGE, READ, a combination of R W X D P=
 O, or a hex value
> +.SH "NOTES"
> +.PP
> +Kernel support for getcifsacl/setcifsacl utilities was initially int=
roduced in the 2.6.37 kernel.
> =A0.SH "SEE ALSO"

Looks fine.  Just a nitpicking, since this is a setcifsacl manpage,
does getcifsacl also need to be mentioned here?

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

> =A0.PP
> =A0\fBmount.cifs\fR(8),
>
