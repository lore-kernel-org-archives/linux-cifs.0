From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch] cifs: update limit for snprintf() in cifs_construct_tcon()
Date: Tue, 12 Jul 2011 13:14:00 -0500
Message-ID: <CAH2r5mu6TuWs6P8ZeR1=KCv8BLSu0_Z8b2uoVUqXhw55=39CWg@mail.gmail.com>
References: <20110617103059.GE2520@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"open list:COMMON INTERNET F..." <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"open list:COMMON INTERNET F..." <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110617103059.GE2520-z0WHZYlhLlzP0Z7Jsv878P8+0UxHXcjY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

What about the following alternative, so we dont rely on the magic
number as much.

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index dbd669c..ccc1afa 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3485,7 +3485,7 @@ cifs_construct_tcon(struct cifs_sb_info
*cifs_sb, uid_t fsuid)
 		goto out;
 	}

-	snprintf(username, MAX_USERNAME_SIZE, "krb50x%x", fsuid);
+	snprintf(username, sizeof(username), "krb50x%x", fsuid);
 	vol_info->username =3D username;
 	vol_info->local_nls =3D cifs_sb->local_nls;
 	vol_info->linux_uid =3D fsuid;

On Fri, Jun 17, 2011 at 5:31 AM, Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> In 34c87901e113 "Shrink stack space usage in cifs_construct_tcon" we
> change the size of the username name buffer from MAX_USERNAME_SIZE
> (256) to 28. =A0This call to snprintf() needs to be updated as well.
>
> Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> I know that everyone is going to complain about using a literal but
> it's local to this function and it's commented in the lines above.
> I'm not opposed to using a define, I suppose, if you give me a good
> one, but really I'd just as soon leave it as is. =A0*eye roll in
> advance*.
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 12cf72d..efd1c7a 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3451,7 +3451,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_s=
b, uid_t fsuid)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 snprintf(username, MAX_USERNAME_SIZE, "krb50x%x", fsuid=
);
> + =A0 =A0 =A0 snprintf(username, 28, "krb50x%x", fsuid);
> =A0 =A0 =A0 =A0vol_info->username =3D username;
> =A0 =A0 =A0 =A0vol_info->local_nls =3D cifs_sb->local_nls;
> =A0 =A0 =A0 =A0vol_info->linux_uid =3D fsuid;
>



--=20
Thanks,

Steve
