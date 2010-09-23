From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 11/15] cifs: fix cifs_show_options to show "username=" or "multiuser"
Date: Thu, 23 Sep 2010 01:12:24 -0500
Message-ID: <AANLkTimSW3tDkHy_zjAAy=BPX1cXmgX0rZdqFOiYbrJD@mail.gmail.com>
References: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
	<1285023704-2159-12-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1285023704-2159-12-git-send-email-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

obviously harmless/fine (would merge now, but don't want to do it
out of order with 8 and 9)

On Mon, Sep 20, 2010 at 6:01 PM, Jeff Layton <jlayton@redhat.com> wrote=
:
> ...based on CIFS_MOUNT_MULTIUSER flag.
>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
> =A0fs/cifs/cifsfs.c | =A0 =A06 +++++-
> =A01 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 2b897e3..51090cec 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -371,8 +371,12 @@ cifs_show_options(struct seq_file *s, struct vfs=
mount *m)
> =A0 =A0 =A0 =A0srcaddr =3D (struct sockaddr *)&tcon->ses->server->src=
addr;
>
> =A0 =A0 =A0 =A0seq_printf(s, ",unc=3D%s", tcon->treeName);
> - =A0 =A0 =A0 if (tcon->ses->userName)
> +
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",multiuser");
> + =A0 =A0 =A0 else if (tcon->ses->userName)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(s, ",username=3D%s", tcon->=
ses->userName);
> +
> =A0 =A0 =A0 =A0if (tcon->ses->domainName)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(s, ",domain=3D%s", tcon->se=
s->domainName);
>
> --
> 1.7.2.3
>
>



--=20
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
