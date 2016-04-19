From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 5/6] cifs_readv_receive: use cifs_read_from_socket()
Date: Tue, 19 Apr 2016 11:01:06 -0400
Message-ID: <1461078066.15135.0.camel@poochiereds.net>
References: <20160409204301.GF25498@ZenIV.linux.org.uk>
	 <20160409205236.GK25498@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160409205236.GK25498-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 2016-04-09 at 21:52 +0100, Al Viro wrote:
> Signed-off-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> ---
> =C2=A0fs/cifs/cifssmb.c | 11 ++++-------
> =C2=A01 file changed, 4 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 76fcb50..3da077a 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1447,10 +1447,8 @@ cifs_readv_receive(struct TCP_Server_Info *ser=
ver, struct mid_q_entry *mid)
> =C2=A0	len =3D min_t(unsigned int, buflen, server->vals->read_rsp_siz=
e) -
> =C2=A0							HEADER_SIZE(server) + 1;
> =C2=A0
> -	rdata->iov.iov_base =3D buf + HEADER_SIZE(server) - 1;
> -	rdata->iov.iov_len =3D len;
> -
> -	length =3D cifs_readv_from_socket(server, &rdata->iov, 1, len);
> +	length =3D cifs_read_from_socket(server,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0buf + HEADER_SIZE(serv=
er) - 1, len);
> =C2=A0	if (length < 0)
> =C2=A0		return length;
> =C2=A0	server->total_read +=3D length;
> @@ -1502,9 +1500,8 @@ cifs_readv_receive(struct TCP_Server_Info *serv=
er, struct mid_q_entry *mid)
> =C2=A0	len =3D data_offset - server->total_read;
> =C2=A0	if (len > 0) {
> =C2=A0		/* read any junk before data into the rest of smallbuf */
> -		rdata->iov.iov_base =3D buf + server->total_read;
> -		rdata->iov.iov_len =3D len;
> -		length =3D cifs_readv_from_socket(server, &rdata->iov, 1, len);
> +		length =3D cifs_read_from_socket(server,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0buf + server->total_r=
ead, len);
> =C2=A0		if (length < 0)
> =C2=A0			return length;
> =C2=A0		server->total_read +=3D length;

This one is orthogonal to the rest. Looks good though.

Reviewed-by: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
