From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [GIT] [CIFS] Allow user names longer than 32 bytes
Date: Mon, 28 Feb 2011 17:39:31 -0500
Message-ID: <20110228173931.184ce3d0@corrin.poochiereds.net>
References: <AANLkTimMxszw620jHORHYQ_jj-fhQiXUe=AiAFRAtMLU@mail.gmail.com>
	<20110228135935.1486b3dc@corrin.poochiereds.net>
	<AANLkTi=8CvigLkhK3V4Tf1=HgiYsKi7C6gUoLKTZc-My@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=8CvigLkhK3V4Tf1=HgiYsKi7C6gUoLKTZc-My-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 28 Feb 2011 15:09:00 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Feb 28, 2011 at 12:59 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> > On Fri, 25 Feb 2011 12:24:17 -0600
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> commit 355e57ca063338eb00ea067a7570bb5f136cc513
> >> Author: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> >> Date: =A0 Fri Feb 25 01:11:56 2011 -0600
> >>
> >> =A0 =A0 [CIFS] Allow user names longer than 32 bytes
> >>
> >> =A0 =A0 We artificially limited the user name to 32 bytes, but mod=
ern servers handle
> >> =A0 =A0 larger. =A0Set the maximum length to a reasonable 256, and=
 make the user name
> >> =A0 =A0 string dynamically allocated rather than a fixed size in s=
ession structure.
> >> =A0 =A0 Also clean up old checkpatch warning.
> >>
> >> =A0 =A0 Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> >
> > [...]
> >
> >> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> >> index a51585f..e307a28 100644
> >> --- a/fs/cifs/cifsencrypt.c
> >> +++ b/fs/cifs/cifsencrypt.c
> >> @@ -469,15 +469,15 @@ static int calc_ntlmv2_hash(struct cifsSesIn=
fo
> >> *ses, char *ntlmv2_hash,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> >> =A0 =A0 =A0 }
> >>
> >> - =A0 =A0 /* convert ses->userName to unicode and uppercase */
> >> - =A0 =A0 len =3D strlen(ses->userName);
> >> + =A0 =A0 /* convert ses->user_name to unicode and uppercase */
> >> + =A0 =A0 len =3D strlen(ses->user_name);
> >> =A0 =A0 =A0 user =3D kmalloc(2 + (len * 2), GFP_KERNEL);
> >> =A0 =A0 =A0 if (user =3D=3D NULL) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "calc_ntlmv2_hash: user mem =
alloc failure\n");
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto calc_exit_2;
> >> =A0 =A0 =A0 }
> >> - =A0 =A0 len =3D cifs_strtoUCS((__le16 *)user, ses->userName, len=
, nls_cp);
> >> + =A0 =A0 len =3D cifs_strtoUCS((__le16 *)user, ses->user_name, le=
n, nls_cp);
> >> =A0 =A0 =A0 UniStrupr(user);
> >>
> >
> > Now that user_name can be a NULL pointer, what prevents the code ab=
ove
> > from oopsing if no one passes in a user=3D parm?
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
>=20
> In cifs_mount in fs/cifs/connect.c we guarantee that
> volume_info->username is filled in (or we exit mount)
>=20
> 	if (volume_info->nullauth) {
> 		cFYI(1, "null user");
> 		volume_info->username =3D "";
> 	} else if (volume_info->username) {
> 		/* BB fixme parse for domain name here */
> 		cFYI(1, "Username: %s", volume_info->username);
> 	} else {
> 		cifserror("No username specified");
> 	/* In userspace mount helper we can get user name from alternate
> 	   locations such as env variables and files on disk */
> 		rc =3D -EINVAL;
> 		goto out;
> 	}
>=20
> then in get_smb_ses (see below) when we allocate a new session we
> either kstrdup successfully or we fail the mount:
> 	if (volume_info->username) {
> 		ses->user_name =3D kstrdup(volume_info->username, GFP_KERNEL);
> 		if (!ses->user_name)
> 			goto get_ses_fail;
> 	}
>=20
>=20
> I don't mind adding defensive code in other places, but the reason th=
e
> null check is (only) in the find_cifs_smb_ses is in case an invalid
> ses (being freed) was on the list.

That would be a bug and I think there would be better ways to check for
that if you think it's a possibility. I think we need to clearly define
the rules for this, and make the code follow those rules. There are two
possibilities:

1) it's possible to have a NULL user_name pointer. You always need to
check for that and deal with it appropriately.

=2E..or...

2) it's not ever possible to have a NULL user_name pointer. Once the
ses has been created, NULL pointer checks are unneeded.

I'm ok with either, but I think it needs to be consistent. Checking for
a NULL pointer in only some places is very confusing.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
