From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix bad buffer length check in coalesce_t2
Date: Tue, 3 Jan 2012 10:22:41 -0600
Message-ID: <CADT32eLSpbdc3JQyzXX-JP6wU2RAgcAxtu6ttPizomOBYZE6Vg@mail.gmail.com>
References: <1325432079-21179-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325432079-21179-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Jan 1, 2012 at 9:34 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The current check looks to see if the RFC1002 length is larger than
> CIFSMaxBufSize, and fails if it is. The buffer is actually larger tha=
n
> that by MAX_CIFS_HDR_SIZE.
>
> This bug has been around for a long time, but the fact that we used t=
o
> cap the clients MaxBufferSize at the same level as the server tended
> to paper over it. Commit c974befa changed that however and caused thi=
s
> bug to bite in more cases.
>
> Reported-and-Tested-by: Konstantinos Skarlatos <k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8cd4b52..27c4f25 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -282,7 +282,7 @@ static int coalesce_t2(struct smb_hdr *psecond, s=
truct smb_hdr *pTargetSMB)
> =A0 =A0 =A0 =A0byte_count =3D be32_to_cpu(pTargetSMB->smb_buf_length)=
;
> =A0 =A0 =A0 =A0byte_count +=3D total_in_buf2;
> =A0 =A0 =A0 =A0/* don't allow buffer to overflow */
> - =A0 =A0 =A0 if (byte_count > CIFSMaxBufSize)
> + =A0 =A0 =A0 if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4=
)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOBUFS;
> =A0 =A0 =A0 =A0pTargetSMB->smb_buf_length =3D cpu_to_be32(byte_count)=
;
>
> --
> 1.7.7.4
>

Tested-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Tested cifs module built with this patch against a Windows XP server
where the failure was noticed.
But even without this patch, there are no errors against Windows 2003 s=
erver
and Windows 2008 server.
