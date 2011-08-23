From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix possible memory corruption in CIFSFindNext
Date: Tue, 23 Aug 2011 06:46:44 -0500
Message-ID: <CAH2r5msVqJrD_FNOrY4S+NZAvonQfJgLWhSa_rfKhmvKPvOd=w@mail.gmail.com>
References: <1314098488-1547-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dcl-HN4QTLPn1qTvY7RNz7mR4EEOCMrvLtNR@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314098488-1547-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged

On Tue, Aug 23, 2011 at 6:21 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> The name_len variable in CIFSFindNext is a signed int that gets set t=
o
> the resume_name_len in the cifs_search_info. The resume_name_len howe=
ver
> is unsigned and for some infolevels is populated directly from a 32 b=
it
> value sent by the server.
>
> If the server sends a very large value for this, then that value coul=
d
> look negative when converted to a signed int. That would make that
> value pass the PATH_MAX check later in CIFSFindNext. The name_len wou=
ld
> then be used as a length value for a memcpy. It would then be treated
> as unsigned again, and the memcpy scribbles over a ton of memory.
>
> Fix this by making the name_len an unsigned value in CIFSFindNext.
>
> Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: Darren Lavender <dcl-HN4QTLPn1qTvY7RNz7mR4EEOCMrvLtNR@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifssmb.c | =A0 =A03 ++-
> =A01 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index f4d0988..950464d 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -4089,7 +4089,8 @@ int CIFSFindNext(const int xid, struct cifs_tco=
n *tcon,
> =A0 =A0 =A0 =A0T2_FNEXT_RSP_PARMS *parms;
> =A0 =A0 =A0 =A0char *response_data;
> =A0 =A0 =A0 =A0int rc =3D 0;
> - =A0 =A0 =A0 int bytes_returned, name_len;
> + =A0 =A0 =A0 int bytes_returned;
> + =A0 =A0 =A0 unsigned int name_len;
> =A0 =A0 =A0 =A0__u16 params, byte_count;
>
> =A0 =A0 =A0 =A0cFYI(1, "In FindNext");
> --
> 1.7.6
>
>



--=20
Thanks,

Steve
