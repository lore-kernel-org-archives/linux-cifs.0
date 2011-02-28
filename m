From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] [CIFS] Allow user names longer than 32 bytes
Date: Mon, 28 Feb 2011 13:43:44 -0600
Message-ID: <AANLkTi=q5aOv635GeDvdskOg-XzxcBJLGRswBczwB=yW@mail.gmail.com>
References: <AANLkTimMxszw620jHORHYQ_jj-fhQiXUe=AiAFRAtMLU@mail.gmail.com>
	<20110228135935.1486b3dc@corrin.poochiereds.net>
	<20110228140451.056ee6ea@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110228140451.056ee6ea-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Arggghh

Good catch - thx.

On Mon, Feb 28, 2011 at 1:04 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Mon, 28 Feb 2011 13:59:35 -0500
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Fri, 25 Feb 2011 12:24:17 -0600
>> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> > commit 355e57ca063338eb00ea067a7570bb5f136cc513
>> > Author: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>> > Date: =A0 Fri Feb 25 01:11:56 2011 -0600
>> >
>> > =A0 =A0 [CIFS] Allow user names longer than 32 bytes
>> >
>> > =A0 =A0 We artificially limited the user name to 32 bytes, but mod=
ern servers handle
>> > =A0 =A0 larger. =A0Set the maximum length to a reasonable 256, and=
 make the user name
>> > =A0 =A0 string dynamically allocated rather than a fixed size in s=
ession structure.
>> > =A0 =A0 Also clean up old checkpatch warning.
>> >
>> > =A0 =A0 Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>>
>> [...]
>>
>> > diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> > index a51585f..e307a28 100644
>> > --- a/fs/cifs/cifsencrypt.c
>> > +++ b/fs/cifs/cifsencrypt.c
>> > @@ -469,15 +469,15 @@ static int calc_ntlmv2_hash(struct cifsSesIn=
fo
>> > *ses, char *ntlmv2_hash,
>> > =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> > =A0 =A0 }
>> >
>> > - =A0 /* convert ses->userName to unicode and uppercase */
>> > - =A0 len =3D strlen(ses->userName);
>> > + =A0 /* convert ses->user_name to unicode and uppercase */
>> > + =A0 len =3D strlen(ses->user_name);
>> > =A0 =A0 user =3D kmalloc(2 + (len * 2), GFP_KERNEL);
>> > =A0 =A0 if (user =3D=3D NULL) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "calc_ntlmv2_hash: user mem allo=
c failure\n");
>> > =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> > =A0 =A0 =A0 =A0 =A0 =A0 goto calc_exit_2;
>> > =A0 =A0 }
>> > - =A0 len =3D cifs_strtoUCS((__le16 *)user, ses->userName, len, nl=
s_cp);
>> > + =A0 len =3D cifs_strtoUCS((__le16 *)user, ses->user_name, len, n=
ls_cp);
>> > =A0 =A0 UniStrupr(user);
>> >
>>
>> Now that user_name can be a NULL pointer, what prevents the code abo=
ve
>> from oopsing if no one passes in a user=3D parm?
>>
>
> Oh, and another problem too...
>
> cifs_construct_tcon does a stack allocation for a temporary username =
field:
>
> =A0 =A0 =A0 =A0char username[MAX_USERNAME_SIZE + 1];
>
> That was probably ok when this was 33 bytes, but now that it's 257 it=
's
> a little more scary. That should probably be switched to a kzalloc'ed
> buffer too.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Thanks,

Steve
