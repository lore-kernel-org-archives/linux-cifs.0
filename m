From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] Making shares unaccessible at root level mountable (aka
 solving bsc#8950 ...again)
Date: Sat, 2 Jul 2016 10:02:36 +0300
Message-ID: <CAKywueRMvJ4B6ojqA1TduS4nGFTr5m4wLO2=0M_EVv=vw2T1pw@mail.gmail.com>
References: <20160527194346.08416d79@aaptelpc> <20160609185027.7349f260@aaptelpc>
 <5759C326.5040508@fu-berlin.de> <20160610171649.3e12b95c@aaptelpc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Marcus Hoffmann <marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160610171649.3e12b95c@aaptelpc>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2016-06-10 18:16 GMT+03:00 Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
=2E..
> I've moved some things around. All of the prefix path components are
> now checked for accessibility in cifs_do_mount(). This is more
> robust and it lets us set the CIFS_MOUNT_USE_PREFIX_PATH flag earlier=
=2E
>
> I've updated the cifs_root_iget() to use the prefix path when necessa=
ry
> which should take care of the last case (hard mode).
>
> Please test my latest patch (attached).

Hi Aur=C3=A9lien,

Thank you for the patch, it looks good like a right thing to do.

I put my comments below:

@@ -649,6 +649,7 @@ cifs_get_root(struct smb_vol *vol, struct super_blo=
ck *sb)
  dentry =3D child;
  } while (!IS_ERR(dentry));
  kfree(full_path);
+
  return dentry;
 }

Please remove this unnecessary change - probably it will go to stable
some day and may cause extra conflicts.


@@ -1002,10 +1002,21 @@ struct inode *cifs_root_iget(struct super_block=
 *sb)
  struct inode *inode =3D NULL;
  long rc;
  struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
+ char *path =3D NULL;
+ int len;
+
+ if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
cifs_sb->prepath) {
+ len =3D strlen(cifs_sb->prepath);
+ path =3D kzalloc(len + 2 /* leading sep + null */, GFP_KERNEL);
+ path[0] =3D '/';
+ memcpy(path+1, cifs_sb->prepath, len);
+ } else {
+ path =3D kstrdup("", GFP_KERNEL);
+ }

The above code should check for possible memory allocation failure.

--=20
Best regards,
Pavel Shilovsky
