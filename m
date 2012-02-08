From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] CIFS: Fix NULL pointer dereference in
	cifs_construct_tcon()
Date: Tue, 7 Feb 2012 22:26:42 -0600
Message-ID: <CAH2r5mud1Y1dWDzr6zn2aD5y0HtPhn_CKP-ZQVR-QNQDWxpqOg@mail.gmail.com>
References: <alpine.LNX.2.00.1202050030520.30244@swampdragon.chaosbits.net>
	<20120205062204.763bdab6@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	Jesper Juhl <jj@chaosbits.net>, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20120205062204.763bdab6@tlielax.poochiereds.net>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

It should be merged now.

In addition, jeff's more recent 3 patches are now in cifs-2.6.git

On Sun, Feb 5, 2012 at 5:22 AM, Jeff Layton <jlayton@redhat.com> wrote:
>
> On Sun, 5 Feb 2012 00:35:19 +0100 (CET)
> Jesper Juhl <jj@chaosbits.net> wrote:
>
> > If the call to kcalloc() fails and returns NULL we'll dereference a
> > NULL 'vol_info' after we jump to the 'out:' label.
> >
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> > =A0fs/cifs/connect.c | =A0 =A04 ++--
> > =A01 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 986709a..bd67b7c 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -3859,7 +3859,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb,=
 uid_t fsuid)
> > =A0 =A0 =A0 vol_info =3D kzalloc(sizeof(*vol_info), GFP_KERNEL);
> > =A0 =A0 =A0 if (vol_info =3D=3D NULL) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon =3D ERR_PTR(-ENOMEM);
> > - =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> > + =A0 =A0 =A0 =A0 =A0 =A0 goto out2;
> > =A0 =A0 =A0 }
> >
> > =A0 =A0 =A0 vol_info->local_nls =3D cifs_sb->local_nls;
> > @@ -3901,7 +3901,7 @@ out:
> > =A0 =A0 =A0 kfree(vol_info->username);
> > =A0 =A0 =A0 kfree(vol_info->password);
> > =A0 =A0 =A0 kfree(vol_info);
> > -
> > +out2:
> > =A0 =A0 =A0 return tcon;
> > =A0}
> >
>
> Thanks. Dan Carpenter already sent a patch a couple of weeks ago to fix
> this. Steve has it in his tree, but hasn't pushed it to Linus yet.
>
> Steve, is there a reason you're waiting?
>
> --
> Jeff Layton <jlayton@redhat.com>




--
Thanks,

Steve
