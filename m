From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/4] cifs: sanitize username handling
Date: Wed, 18 Jan 2012 07:10:05 -0500
Message-ID: <20120118071005.77db7383@tlielax.poochiereds.net>
References: <1326836547-7011-1-git-send-email-jlayton@redhat.com>
	<1326836547-7011-3-git-send-email-jlayton@redhat.com>
	<CAH2r5msmuYW3+XZXecpan7jkBngy2hZBGMjfy+5C3hsNcWsavQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msmuYW3+XZXecpan7jkBngy2hZBGMjfy+5C3hsNcWsavQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 17 Jan 2012 22:41:30 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Merged your patch series, but fixed two of the four checkpatch
> warnings (one in this patch and one in following one).
>=20

Thanks. I just noticed one really minor thing. The description in
commit 8a8798a still says it's looking for a "secret" key, when it's
really looking for a "logon" key. The code is correct though. Let me
know if you want me to respin that patch and fix the description.

> On Tue, Jan 17, 2012 at 3:42 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > Currently, it's not very clear whether you're allowed to have a NUL=
L
> > vol->username or ses->user_name. Some places check for it and some =
don't.
> >
> > Make it clear that a NULL pointer is OK in these fields, and ensure=
 that
> > all the callers check for that.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/cifs_spnego.c | =C2=A0 10 +++++++---
> > =C2=A0fs/cifs/cifsencrypt.c | =C2=A0 11 ++++++++---
> > =C2=A0fs/cifs/connect.c =C2=A0 =C2=A0 | =C2=A0 19 ++++++++++++-----=
--
> > =C2=A03 files changed, 27 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
> > index 2272fd5..e622863 100644
> > --- a/fs/cifs/cifs_spnego.c
> > +++ b/fs/cifs/cifs_spnego.c
> > @@ -113,9 +113,11 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MAX_=
MECH_STR_LEN +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UID_=
KEY_LEN + (sizeof(uid_t) * 2) +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CRED=
UID_KEY_LEN + (sizeof(uid_t) * 2) +
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0USE=
R_KEY_LEN + strlen(sesInfo->user_name) +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 PID_=
KEY_LEN + (sizeof(pid_t) * 2) + 1;
> >
> > + =C2=A0 =C2=A0 =C2=A0 if (sesInfo->user_name)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc_len +=3D US=
ER_KEY_LEN + strlen(sesInfo->user_name);
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0spnego_key =3D ERR_PTR(-ENOMEM);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0description =3D kzalloc(desc_len, GFP_KE=
RNEL);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (description =3D=3D NULL)
> > @@ -152,8 +154,10 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0dp =3D description + strlen(description)=
;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0sprintf(dp, ";creduid=3D0x%x", sesInfo->=
cred_uid);
> >
> > - =C2=A0 =C2=A0 =C2=A0 dp =3D description + strlen(description);
> > - =C2=A0 =C2=A0 =C2=A0 sprintf(dp, ";user=3D%s", sesInfo->user_name=
);
> > + =C2=A0 =C2=A0 =C2=A0 if (sesInfo->user_name) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dp =3D descripti=
on + strlen(description);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sprintf(dp, ";us=
er=3D%s", sesInfo->user_name);
> > + =C2=A0 =C2=A0 =C2=A0 }
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0dp =3D description + strlen(description)=
;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0sprintf(dp, ";pid=3D0x%x", current->pid)=
;
> > diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> > index 5d9b9ac..bce99e6 100644
> > --- a/fs/cifs/cifsencrypt.c
> > +++ b/fs/cifs/cifsencrypt.c
> > @@ -420,15 +420,20 @@ static int calc_ntlmv2_hash(struct cifs_ses *=
ses, char *ntlmv2_hash,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* convert ses->user_name to unicode and=
 uppercase */
> > - =C2=A0 =C2=A0 =C2=A0 len =3D strlen(ses->user_name);
> > + =C2=A0 =C2=A0 =C2=A0 len =3D ses->user_name ? strlen(ses->user_na=
me) : 0;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0user =3D kmalloc(2 + (len * 2), GFP_KERN=
EL);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (user =3D=3D NULL) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cERROR(1, "c=
alc_ntlmv2_hash: user mem alloc failure\n");
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D -ENOM=
EM;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > - =C2=A0 =C2=A0 =C2=A0 len =3D cifs_strtoUCS((__le16 *)user, ses->u=
ser_name, len, nls_cp);
> > - =C2=A0 =C2=A0 =C2=A0 UniStrupr(user);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 if (len) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 len =3D cifs_str=
toUCS((__le16 *)user, ses->user_name, len, nls_cp);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UniStrupr(user);
> > + =C2=A0 =C2=A0 =C2=A0 } else {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(user, '\0=
', 2);
> > + =C2=A0 =C2=A0 =C2=A0 }
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D crypto_shash_update(&ses->server-=
>secmech.sdeschmacmd5->shash,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(char *)user, 2 * len);
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index a66dcb5..b8f5024 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -1997,10 +1997,16 @@ static int match_session(struct cifs_ses *s=
es, struct smb_vol *vol)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return 0;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0default:
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* NULL username=
 means anonymous session */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ses->user_na=
me =3D=3D NULL) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (!vol->nullauth)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* anything =
else takes username/password */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ses->user_na=
me =3D=3D NULL)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return 0;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (strncmp(ses-=
>user_name, vol->username,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (strncmp(ses-=
>user_name,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 vol->username ? vol->username: "",
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0MAX_USERNAME_SIZE))
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return 0;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (strlen(v=
ol->username) !=3D 0 &&
> > @@ -3167,10 +3173,9 @@ cifs_setup_volume_info(struct smb_vol *volum=
e_info, char *mount_data,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINV=
AL;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (volume_info->nullauth) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "null us=
er");
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 volume_info->use=
rname =3D kzalloc(1, GFP_KERNEL);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (volume_info-=
>username =3D=3D NULL)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return -ENOMEM;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "Anonymo=
us login");
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(volume_inf=
o->username);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 volume_info->use=
rname =3D NULL;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (volume_info->username) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* BB fixme =
parse for domain name here */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cFYI(1, "Use=
rname: %s", volume_info->username);
> > --
> > 1.7.7.5
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
