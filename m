From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS] [1/4] NTLM authentication and signing - Calculate
 auth response per smb session
Date: Wed, 13 Oct 2010 10:28:25 -0500
Message-ID: <AANLkTik_bqHOsOn1UpgWECu-x=cZgVKUt4HAgWRi-z7W@mail.gmail.com>
References: <1286912703-22661-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101013083642.74d9b8a9@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101013083642.74d9b8a9-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Oct 13, 2010 at 7:36 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, 12 Oct 2010 14:45:03 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> Start calculation auth response within a session. =A0Move/Add pertin=
et
>> data structures like session key, server challenge and ntlmv2_hash i=
n
>> a session structure. =A0We should do the calculations within a sessi=
on
>> before copying session key and response over to server data
>> structures because a session setup can fail.
>>
>> Only after a very first smb session succeeds, it copies/makes its
>> session key, session key of smb connection. =A0This key stays with
>> the smb connection throughout its life.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D CIFS_SESS_KEY_SIZE;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->capabilities & CAP_UNICODE) {
>> @@ -3175,6 +3176,15 @@ int cifs_setup_session(unsigned int xid, stru=
ct cifsSesInfo *ses,
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Send error in SessSetup =3D %=
d", rc);
>> =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&ses->server->srv_mutex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!server->session_estab) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&server->session_ke=
y.data,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &ses->auth=
_key.data, ses->auth_key.len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.len =3D=
 ses->auth_key.len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->session_estab=
 =3D true;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nit: Aren't "server" a=
nd "ses->server" the
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0same? Why access them =
differently here?
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&server->srv_mutex);
>> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0What are the rules for locking around =
the session_estab
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flag? Here you're holding the srv_mute=
x when checking
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0and altering it, but in cifs_reconnect=
 you're altering
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0it without holding the mutex. Is that =
a potential race
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0condition?

Jeff, I do not think it is a potential race.  In cifs_reconnect, by the
time session_estab is set as false, all the sessions have been
invalidated and socket connection has been taken down
and restablished. Isn't that as good as new connection?
Setting session_estab under srv_mutex is mainly to prevent
newly established sessions from racing.

>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "CIFS Session Established succes=
sfully");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->status =3D CifsGood;
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
