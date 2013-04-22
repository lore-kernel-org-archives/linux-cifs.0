From: Michael Mol <mikemol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: on send failure, readjust server sequence number
 downward
Date: Mon, 22 Apr 2013 17:17:09 -0400
Message-ID: <5175A8D5.5040505@gmail.com>
References: <1365012430-6795-1-git-send-email-jlayton@redhat.com> <515C7AF2.3090902@gmail.com> <20130403150227.25f37cce@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2CARLPIUIDEWIBSACEWLL"
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130403150227.25f37cce-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2CARLPIUIDEWIBSACEWLL
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/03/2013 03:02 PM, Jeff Layton wrote:
> On Wed, 03 Apr 2013 14:54:42 -0400
> Michael Mol <mikemol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
>> On 04/03/2013 02:07 PM, Jeff Layton wrote:
>>> If sending a call to the server fails for some reason (for instance, =
the
>>> sending thread caught a signal), then we must readjust the sequence
>>> number downward again or the next send will have it too high.
>>>
>>> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>  fs/cifs/smb1ops.c   |  3 +++
>>>  fs/cifs/transport.c | 13 +++++++++++++
>>>  2 files changed, 16 insertions(+)
>>>
>>> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
>>> index 23bcd11..3efdb9d 100644
>>> --- a/fs/cifs/smb1ops.c
>>> +++ b/fs/cifs/smb1ops.c
>>> @@ -61,6 +61,9 @@ send_nt_cancel(struct TCP_Server_Info *server, void=
 *buf,
>>>  	 */
>>>  	--server->sequence_number;
>>>  	rc =3D smb_send(server, in_buf, be32_to_cpu(in_buf->smb_buf_length)=
);
>>> +	if (rc < 0)
>>> +		server->sequence_number--;
>>> +
>>>  	mutex_unlock(&server->srv_mutex);
>>> =20
>>>  	cifs_dbg(FYI, "issued NT_CANCEL for mid %u, rc =3D %d\n",
>>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>>> index 653bf26..293d2c8 100644
>>> --- a/fs/cifs/transport.c
>>> +++ b/fs/cifs/transport.c
>>> @@ -522,6 +522,9 @@ cifs_call_async(struct TCP_Server_Info *server, s=
truct smb_rqst *rqst,
>>>  	rc =3D smb_send_rqst(server, rqst);
>>>  	cifs_in_send_dec(server);
>>>  	cifs_save_when_sent(mid);
>>> +
>>> +	if (rc < 0)
>>> +		server->sequence_number -=3D 2;
>>>  	mutex_unlock(&server->srv_mutex);
>>> =20
>>>  	if (rc =3D=3D 0)
>>> @@ -711,6 +714,8 @@ SendReceive2(const unsigned int xid, struct cifs_=
ses *ses,
>>>  	cifs_in_send_dec(ses->server);
>>>  	cifs_save_when_sent(midQ);
>>> =20
>>> +	if (rc < 0)
>>> +		ses->server->sequence_number -=3D 2;
>>>  	mutex_unlock(&ses->server->srv_mutex);
>>> =20
>>>  	if (rc < 0) {
>>> @@ -835,6 +840,10 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
>>>  	rc =3D smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_le=
ngth));
>>>  	cifs_in_send_dec(ses->server);
>>>  	cifs_save_when_sent(midQ);
>>> +
>>> +	if (rc < 0)
>>> +		ses->server->sequence_number -=3D 2;
>>> +
>>>  	mutex_unlock(&ses->server->srv_mutex);
>>> =20
>>>  	if (rc < 0)
>>> @@ -968,6 +977,10 @@ SendReceiveBlockingLock(const unsigned int xid, =
struct cifs_tcon *tcon,
>>>  	rc =3D smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_le=
ngth));
>>>  	cifs_in_send_dec(ses->server);
>>>  	cifs_save_when_sent(midQ);
>>> +
>>> +	if (rc < 0)
>>> +		ses->server->sequence_number -=3D 2;
>>> +
>>>  	mutex_unlock(&ses->server->srv_mutex);
>>> =20
>>>  	if (rc < 0) {
>>>
>>
>> I was re-prioritized...I'll test the patches you'd like me to test jus=
t
>> as soon as I can. At that point, I'll prod the list and ask for an
>> up-to-date list of the patchset you'd like me to try.
>>
>=20
> This one is current vs. mainline as of today. It'll probably need to be=

> backported to RHEL6 though. The other one you'll want to test is commit=

> 31efee60f489c75 in the mainline tree. It too will need to be backported=

> to rhel6, but that shouldn't be too hard...
>=20

Backporting to RHEL6 is going to be "fun". The patched version of 2.6.32
looks only vaguely similar to the context in the patch. It looks like
transport.c in 2.6.32 used cifs_sign_smb{2,} in the places where these
changes are likely to apply.

Unless I'm completely forgetting something I knew a month ago. Ah well.
I'm sure I'll get it figured out; should only require a jaunt through
that file's history.



------enig2CARLPIUIDEWIBSACEWLL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRdajYAAoJED5TcEBdxYwQUz8H/RYnif2cDRmSH8u7I8Be6Ed2
D25yizZkE05zP61M3nWsAnfcoN7CR6cWNH+coaHUc3ka+i5sPYZIX1Q4p5m+OjfL
1bOr/NgSS716GQh/+AHeeT+eOlIg3bHgZiLfcQdSsslW4wRkPUNioMSgCT5F0fIm
MLoAwS9rbjeOWu9ahgCES/rcyV0nLBMD6K50T0Uu+sH8dV6SNfyTBDRXIzkWdaoy
Zi20iJjb96h0ATQNeQJDrv18XWWV07IVo73ZEDdy5RMCclaD0meusSC8sicT7y/R
dAx9thM4IEOnf7r8QHGNVnF9E3/qNpm5UabAetjYz+THJKfs535ist6Tw7NPevc=
=tj/w
-----END PGP SIGNATURE-----

------enig2CARLPIUIDEWIBSACEWLL--
