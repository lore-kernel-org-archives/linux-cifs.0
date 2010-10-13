From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS] [1/4] NTLM authentication and signing - Calculate
 auth response per smb session
Date: Wed, 13 Oct 2010 13:42:24 -0500
Message-ID: <AANLkTikLp9BH6_vgkebkKWDJrwLSo4X=u08xTEoAnAuR@mail.gmail.com>
References: <1286912703-22661-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101013083642.74d9b8a9@corrin.poochiereds.net>
	<AANLkTik_bqHOsOn1UpgWECu-x=cZgVKUt4HAgWRi-z7W@mail.gmail.com>
	<20101013130345.41bb7e85@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101013130345.41bb7e85-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Oct 13, 2010 at 12:03 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> On Wed, 13 Oct 2010 10:28:25 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Wed, Oct 13, 2010 at 7:36 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
>> > On Tue, 12 Oct 2010 14:45:03 -0500
>> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> >
>> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >>
>> >> Start calculation auth response within a session. =A0Move/Add per=
tinet
>> >> data structures like session key, server challenge and ntlmv2_has=
h in
>> >> a session structure. =A0We should do the calculations within a se=
ssion
>> >> before copying session key and response over to server data
>> >> structures because a session setup can fail.
>> >>
>> >> Only after a very first smb session succeeds, it copies/makes its
>> >> session key, session key of smb connection. =A0This key stays wit=
h
>> >> the smb connection throughout its life.
>> >>
>> >>
>> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >
>> >
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D CIFS_SESS_KEY_SIZE;
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->capabilities & CAP_UNICODE) =
{
>> >> @@ -3175,6 +3176,15 @@ int cifs_setup_session(unsigned int xid, s=
truct cifsSesInfo *ses,
>> >> =A0 =A0 =A0 if (rc) {
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Send error in SessSetup =3D=
 %d", rc);
>> >> =A0 =A0 =A0 } else {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&ses->server->srv_mutex);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (!server->session_estab) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&server->session=
_key.data,
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &ses->a=
uth_key.data, ses->auth_key.len);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.len=
 =3D ses->auth_key.len;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->session_es=
tab =3D true;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nit: Aren't "server=
" and "ses->server" the
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0same? Why access th=
em differently here?
>> >
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&server->srv_mutex);
>> >> +
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0What are the rules for locking arou=
nd the session_estab
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flag? Here you're holding the srv_m=
utex when checking
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0and altering it, but in cifs_reconn=
ect you're altering
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0it without holding the mutex. Is th=
at a potential race
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0condition?
>>
>> Jeff, I do not think it is a potential race. =A0In cifs_reconnect, b=
y the
>> time session_estab is set as false, all the sessions have been
>> invalidated and socket connection has been taken down
>> and restablished. Isn't that as good as new connection?
>> Setting session_estab under srv_mutex is mainly to prevent
>> newly established sessions from racing.
>>
>
> You may be right, but I don't immediately see what prevents the
> following scenario:
>
> The sessions have been invalidated in cifs_reconnect and we're making
> our way down to the point where that flag is set to false.
>
> Another task then calls smb_init to issue a new call, notices that th=
e
> session is invalid and reconnects it.
>
> This succeeds, but cifs_reconnect isn't done yet. session_estab is
> still true. The session setup code takes the mutex and then checks an=
d
> finds that the flag is still true so it doesn't copy the key.
>
> Eventually cifs_reconnect flips the flag to false (maybe even while
> we're holding the mutex) but now we're borked. We have a valid sessio=
n
> on the socket but the key is likely to be wrong.
>
> This is admittedly unlikely, and maybe impossible, but we should
> understand what makes it impossible before we wave our hands and say
> there's no race.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>

Or we could move them earlier

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 848e458..d7e0651 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -173,6 +173,8 @@ cifs_reconnect(struct TCP_Server_Info *server)
                sock_release(server->ssocket);
                server->ssocket =3D NULL;
        }
+       server->sequence_number =3D 0;
+       server->session_estab =3D false;

        spin_lock(&GlobalMid_Lock);
        list_for_each(tmp, &server->pending_mid_q) {
@@ -205,8 +207,6 @@ cifs_reconnect(struct TCP_Server_Info *server)
                        spin_lock(&GlobalMid_Lock);
                        if (server->tcpStatus !=3D CifsExiting)
                                server->tcpStatus =3D CifsGood;
-                       server->sequence_number =3D 0;
-                       server->session_estab =3D false;
                        spin_unlock(&GlobalMid_Lock);
        /*              atomic_set(&server->inFlight,0);*/
                        wake_up(&server->response_q);


There is no smb connection at this point and (certainly) sessions are
not established at this point.
