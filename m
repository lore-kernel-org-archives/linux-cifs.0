From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 06/13] cifs: clean up handle_mid_response
Date: Sun, 12 Dec 2010 17:52:26 -0600
Message-ID: <AANLkTi=j8j=OxUxJcwn4h6EqvHSH2vrhQkzRxYjAerzi@mail.gmail.com>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
	<1291995877-2276-7-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291995877-2276-7-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Dec 10, 2010 at 9:44 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Make it use a switch statement based on the value of the midStatus. I=
f
> the resp_buf is set, then MID_RESPONSE_RECEIVED is too.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/transport.c | =A0 36 ++++++++++++++++++------------------
> =A01 files changed, 18 insertions(+), 18 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 0c0dadd..05ced17 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -356,33 +356,33 @@ handle_mid_result(struct mid_q_entry *mid, stru=
ct TCP_Server_Info *server)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D 0;
>
> - =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
> + =A0 =A0 =A0 cFYI(1, "%s: cmd=3D%d mid=3D%d state=3D%d", __func__, m=
id->command,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid->mid, mid->midState);
>
> - =A0 =A0 =A0 if (mid->resp_buf) {
> + =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
> + =A0 =A0 =A0 switch (mid->midState) {
> + =A0 =A0 =A0 case MID_RESPONSE_RECEIVED:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 cERROR(1, "No response to cmd %d mid %d", mid->command,=
 mid->mid);
> - =A0 =A0 =A0 if (mid->midState =3D=3D MID_REQUEST_SUBMITTED) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus =3D=3D CifsExitin=
g)
> + =A0 =A0 =A0 case MID_REQUEST_SUBMITTED:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* socket is going down, reject all cal=
ls */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus =3D=3D CifsExitin=
g) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: cancelin=
g mid=3D%d cmd=3D0x%x state=3D%d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__=
, mid->mid, mid->command, mid->midState);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EHOSTDOWN;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid->midState =3D MID_R=
ETRY_NEEDED;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 if (rc !=3D -EHOSTDOWN) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid->midState =3D=3D MID_RETRY_NEED=
ED) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EAGAIN;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "marking reques=
t for retry");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid->midState =3D MID_RETRY_NEEDED;

Would it be cleaner to set rc to -EAGAIN instead of setting state here
to fall down and then setting rc as -EAGAIN?

> + =A0 =A0 =A0 case MID_RETRY_NEEDED:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EAGAIN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: invalid mid state mid=3D=
%d state=3D%d", __func__,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid->mid, mid->midState=
);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
>
> =A0 =A0 =A0 =A0DeleteMidQEntry(mid);
> - =A0 =A0 =A0 /* Update # of requests on wire to server */
> =A0 =A0 =A0 =A0atomic_dec(&server->inFlight);
> =A0 =A0 =A0 =A0wake_up(&server->request_q);
>
> --
> 1.7.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
