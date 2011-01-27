From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] cifs: fix length vs. total_read confusion in
 cifs_demultiplex_thread (try #2)
Date: Thu, 27 Jan 2011 10:52:07 -0600
Message-ID: <AANLkTikSx1Z0DZj9Pk7UaP2DCNJT1My2eMm0DNd72oZk@mail.gmail.com>
References: <1296146511-25942-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296146511-25942-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Jan 27, 2011 at 10:41 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> length at this point is the length returned by the last kernel_recvms=
g
> call. total_read is the length of all of the data read so far. length
> is more or less meaningless at this point, so use total_read for
> everything.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 10 +++++-----
> =A01 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 47034af..41a0ba0 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -581,12 +581,12 @@ incomplete_rcv:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else if (reconnect =3D=3D 1)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 length +=3D 4; /* account for rfc1002 h=
dr */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 total_read +=3D 4; /* account for rfc10=
02 hdr */
>
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dump_smb(smb_buffer, length);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (checkSMB(smb_buffer, smb_buffer->Mi=
d, total_read+4)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_dump_mem("Bad SMB:=
 ", smb_buffer, 48);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dump_smb(smb_buffer, total_read);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (checkSMB(smb_buffer, smb_buffer->Mi=
d, total_read)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_dump_mem("Bad SMB:=
 ", smb_buffer,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 total_read < 48 ? total_read : 48);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;

Looks correct except that (and this is not a change in this patch) but
would be nice to know what is 48.

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
