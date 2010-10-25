From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS] [1/3 -v3] NTLM auth and sign - Allocate session
 key/client response dynamically
Date: Mon, 25 Oct 2010 12:39:54 -0500
Message-ID: <AANLkTikwVH2L+oXRT8+jp=Xg4H_DMoaezCvcp04kxffx@mail.gmail.com>
References: <1287661375-6954-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101025121410.6a0aef5f@corrin.poochiereds.net>
	<AANLkTik0aRH9NcBjR0AGVgc5V-TwEsV3uMYJ_PhcqvD8@mail.gmail.com>
	<20101025131344.65779724@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101025131344.65779724-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Oct 25, 2010 at 12:13 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> On Mon, 25 Oct 2010 11:26:53 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Mon, Oct 25, 2010 at 11:14 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wr=
ote:
>> > On Thu, 21 Oct 2010 06:42:55 -0500
>> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> >
>> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >>
>> >>
>> >> Start calculating auth response within a session. =A0Move/Add per=
tinet
>> >> data structures like session key, server challenge and ntlmv2_has=
h in
>> >> a session structure. =A0We should do the calculations within a se=
ssion
>> >> before copying session key and response over to server data
>> >> structures because a session setup can fail.
>> >>
>> >> Only after a very first smb session succeeds, it copy/make its
>> >> session key, session key of smb connection. =A0This key stays wit=
h
>> >> the smb connection throughout its life.
>> >> sequence_number within server is set to 0x2.
>> >>
>> >> The authentication Message Authentication Key (mak) which consist=
s
>> >> of session key followed by client response within structure sessi=
on_key
>> >> is now dynamic. =A0Every authentication type allocates the key + =
response
>> >> sized memory within its session structure and later either assign=
s or
>> >> frees it once the client response is sent and if session's sessio=
n key
>> >> becomes connetion's session key.
>> >>
>> >> ntlm/ntlmi authentication functions are rearranged. =A0A function
>> >> named setup_ntlm_resp(), similar to setup_ntlmv2_resp(), replaces
>> >> function cifs_calculate_session_key().
>> >>
>> >> size of CIFS_SESS_KEY_SIZE is changed to 16, to reflect the byte =
size
>> >> of the key it holds.
>> >>
>> >>
>> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> ---
>> >> =A0fs/cifs/cifsencrypt.c | =A0113 ++++++++++++++++++++++++++++---=
------------------
>> >> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A09 +----
>> >> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A07 +++-
>> >> =A0fs/cifs/cifsproto.h =A0 | =A0 11 ++---
>> >> =A0fs/cifs/connect.c =A0 =A0 | =A0 18 +++++++-
>> >> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0107 +++++++++++++++++------=
-----------------------
>> >> =A0fs/cifs/transport.c =A0 | =A0 =A06 +-
>> >> =A07 files changed, 134 insertions(+), 137 deletions(-)
>> >>
>> >
>> > [...]
>> >
>> >> @@ -3178,10 +3185,11 @@ int cifs_setup_session(unsigned int xid, =
struct cifsSesInfo *ses,
>> >> =A0 =A0 =A0 } else {
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&ses->server->srv_mutex);
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!server->session_estab) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&server->session=
_key.data,
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &ses->a=
uth_key.data, ses->auth_key.len);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.res=
ponse =3D ses->auth_key.response;
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.l=
en =3D ses->auth_key.len;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->session_es=
tab =3D true;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->sequence_number=
 =3D 0x2;
>> >
>> > It looks like the sequence_number is protected by the Global_MidLo=
ck.
>> > It's not held here. Are there potential races with setting this va=
lue
>> > here?
>> >
>>
>> Jeff, I do not think so. =A0This setting is happening only during th=
e very first
>> smb session setup for that smb connection. Rest of the smb sessions
>> and subsequent smb traffic going on on that smb connection for all t=
he
>> smb sessions ensues only after this step i.e. for signature calculat=
ions.
>> So there is no resetting sequence_number by doing this.
>> If signing is not enabled, this is not even an issue at all.
>>
>
> I'm not sure I follow...
>
> The Global_MidLock is taken in the other places where this counter is
> incremented. Why is it OK to set it here outside of that lock?
>
> Isn't it possible for two session setups to proceed in parallel? If
> not, what serializes them?
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>

Jeff, for a brand new smb connection, if the session connections race, =
they
are serialized on srv_mutex cifs_setup_session.  Only one session setup=
 grabs
that lock does change server's sequene number, none of the ones that fo=
llow can
reset sequence_number because session_estab is true now.
