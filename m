From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] cifs: force a reconnect if there are too many MIDs in flight
Date: Sun, 30 Jan 2011 22:52:12 -0600
Message-ID: <AANLkTint6RnrpHzf+JQHCUs5k3LxNjk3Wys1CjrF3gLZ@mail.gmail.com>
References: <1296302548-18913-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296302548-18913-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed and Merged (along with 5 other patches).

There are a few more of Jeff's still to merge but stopped when
I found one that had some corruption in the patch description
to give him a chance to clean that up.

On Sat, Jan 29, 2011 at 6:02 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Currently, we allow the pending_mid_q to grow without bound with
> SIGKILL'ed processes. This could eventually be a DoS'able problem. An
> unprivileged user could a process that does a long-running call and t=
hen
> SIGKILL it.
>
> If he can also intercept the NT_CANCEL calls or the replies from the
> server, then the pending_mid_q could grow very large, possibly even t=
o
> 2^16 entries which might leave GetNextMid in an infinite loop. Fix th=
is
> by imposing a hard limit of 32k calls per server. If we cross that
> limit, set the tcpStatus to CifsNeedReconnect to force cifsd to
> eventually reconnect the socket and clean out the pending_mid_q.
>
> While we're at it, clean up the function a bit and eliminate an
> unnecessary NULL pointer check.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/misc.c | =A0 37 ++++++++++++++++++++++++-------------
> =A01 files changed, 24 insertions(+), 13 deletions(-)
>
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 77dc732..2a930a7 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -236,10 +236,7 @@ __u16 GetNextMid(struct TCP_Server_Info *server)
> =A0{
> =A0 =A0 =A0 =A0__u16 mid =3D 0;
> =A0 =A0 =A0 =A0__u16 last_mid;
> - =A0 =A0 =A0 int =A0 collision;
> -
> - =A0 =A0 =A0 if (server =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return mid;
> + =A0 =A0 =A0 bool collision;
>
> =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0last_mid =3D server->CurrentMid; /* we do not want to =
loop forever */
> @@ -252,24 +249,38 @@ __u16 GetNextMid(struct TCP_Server_Info *server=
)
> =A0 =A0 =A0 =A0(and it would also have to have been a request that
> =A0 =A0 =A0 =A0 did not time out) */
> =A0 =A0 =A0 =A0while (server->CurrentMid !=3D last_mid) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct list_head *tmp;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct mid_q_entry *mid_entry;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int num_mids;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 collision =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 collision =3D false;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (server->CurrentMid =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->CurrentMid++;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each(tmp, &server->pending_mid=
_q) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D list_entr=
y(tmp, struct mid_q_entry, qhead);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((mid_entry->mid =3D=
=3D server->CurrentMid) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (mid_entry->mid=
State =3D=3D MID_REQUEST_SUBMITTED)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_mids =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry(mid_entry, &server-=
>pending_mid_q, qhead) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++num_mids;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_entry->mid =3D=3D=
 server->CurrentMid &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->midS=
tate =3D=3D MID_REQUEST_SUBMITTED) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Thi=
s mid is in use, try a different one */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 collisi=
on =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 collisi=
on =3D true;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (collision =3D=3D 0) {
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* if we have more than 32k mids in t=
he list, then something
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* is very wrong. Possibly a local us=
er is trying to DoS the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* box by issuing long-running calls =
and SIGKILL'ing them. If
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* we get to 2^16 mids then we're in =
big trouble as this
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* function could loop forever.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Go ahead and assign out the mid in=
 this situation, but force
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* an eventual reconnect to clean out=
 the pending_mid_q.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (num_mids > 32768)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->tcpStatus =3D C=
ifsNeedReconnect;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!collision) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid =3D server->Curren=
tMid;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> --
> 1.7.3.4
>
>



--=20
Thanks,

Steve
