From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: trivial doc fix: note setlease implemented
Date: Tue, 2 Nov 2010 13:50:49 -0500
Message-ID: <AANLkTimvsos6dhXJgOYfeG3xmWhP5V23+4=MvBn6tTB1@mail.gmail.com>
References: <20101030210621.GD480@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101030210621.GD480-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged

On Sat, Oct 30, 2010 at 4:06 PM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>=
 wrote:
> Signed-off-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/TODO | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> I was grepping for setlease and noticed this.--b.
>
> diff --git a/fs/cifs/TODO b/fs/cifs/TODO
> index 5aff46c..355abcd 100644
> --- a/fs/cifs/TODO
> +++ b/fs/cifs/TODO
> @@ -81,7 +81,7 @@ u) DOS attrs - returned as pseudo-xattr in Samba fo=
rmat (check VFAT and NTFS for
>
> =A0v) mount check for unmatched uids
>
> -w) Add support for new vfs entry points for setlease and fallocate
> +w) Add support for new vfs entry point for fallocate
>
> =A0x) Fix Samba 3 server to handle Linux kernel aio so dbench with lo=
ts of
> =A0processes can proceed better in parallel (on the server)
> --
> 1.7.1
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
