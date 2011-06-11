From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: don't allow cifs_reconnect to exit with NULL socket pointer
Date: Fri, 10 Jun 2011 22:37:33 -0500
Message-ID: <BANLkTikGnQDwTjVO2UfVN-o_xAPu+6gLqA@mail.gmail.com>
References: <1307736897-9831-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1307736897-9831-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

reviewed and merged

On Fri, Jun 10, 2011 at 3:14 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> It's possible for the following set of events to happen:
>
> cifsd calls cifs_reconnect which reconnects the socket. A userspace
> process then calls cifs_negotiate_protocol to handle the NEGOTIATE an=
d
> gets a reply. But, while processing the reply, cifsd calls
> cifs_reconnect again. =A0Eventually the GlobalMid_Lock is dropped and=
 the
> reply from the earlier NEGOTIATE completes and the tcpStatus is set t=
o
> CifsGood. cifs_reconnect then goes through and closes the socket and =
sets the
> pointer to zero, but because the status is now CifsGood, the new sock=
et
> is not created and cifs_reconnect exits with the socket pointer set t=
o
> NULL.
>
> Fix this by only setting the tcpStatus to CifsGood if the tcpStatus i=
s
> CifsNeedNegotiate, and by making sure that generic_ip_connect is alwa=
ys
> called at least once in cifs_reconnect.
>
> Note that this is not a perfect fix for this issue. It's still possib=
le
> that the NEGOTIATE reply is handled after the socket has been closed =
and
> reconnected. In that case, the socket state will look correct but it =
no
> NEGOTIATE was performed on it be for the wrong socket. In that situat=
ion
> though the server should just shut down the socket on the next attemp=
ted
> send, rather than causing the oops that occurs today.
>
> Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> # .38.x: fd88ce9: [CIFS] cifs: clarify the me=
aning of tcpStatus =3D=3D CifsGood
> Reported-and-Tested-by: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A06 +++---
> =A01 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index bb659eb..61ed0ba 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -152,7 +152,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry->callback(mid_entry);
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 while (server->tcpStatus =3D=3D CifsNeedReconnect) {
> + =A0 =A0 =A0 do {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0try_to_freeze();
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* we should try only the port we conn=
ected to before */
> @@ -167,7 +167,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server=
->tcpStatus =3D CifsNeedNegotiate;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid=
_Lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 } while (server->tcpStatus =3D=3D CifsNeedReconnect);
>
> =A0 =A0 =A0 =A0return rc;
> =A0}
> @@ -3371,7 +3371,7 @@ int cifs_negotiate_protocol(unsigned int xid, s=
truct cifs_ses *ses)
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0if (rc =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus !=3D CifsExiting)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus =3D=3D CifsNeedNe=
gotiate)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->tcpStatus =3D =
CifsGood;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EHOSTDOWN;
> --
> 1.7.5.2
>
>



--=20
Thanks,

Steve
