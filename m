From: Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH] CIFS: Print message when attempting mount
Date: Mon, 1 Oct 2018 18:16:02 -0700
Message-ID: <CAKywueRxPtQHpSR9GBFW1o+j3cY=5B4DJZdv1bk+7Fkx2zf4YA@mail.gmail.com>
References: <463f424e3d4724a4ab7b84c395e7b0cf3068e31f.1538441538.git.rfreire@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
To: rfreire@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <463f424e3d4724a4ab7b84c395e7b0cf3068e31f.1538441538.git.rfreire@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

=D0=BF=D0=BD, 1 =D0=BE=D0=BA=D1=82. 2018 =D0=B3. =D0=B2 17:59, Rodrigo Frei=
re <rfreire@redhat.com>:
>
> By default, no messages are printed when mounting a CIFS filesystem.
> This information is valuable when troubleshooting and/or forensic
> analyzing a system and finding out if was a CIFS endpoint mount
> attempted.
> Other filesystems such as XFS, EXT* does issue a printk() when mounting
> their filesystems.
>
> Sample output:
>
> [root@ll-rhel7 ~]# mount -o user=3Dadministrator //172.25.250.18/c$ /mnt
> (non-existent system)
>
> [root@ll-rhel7 ~]# mount -o user=3Dadministrator //172.25.250.19/c$ /mnt
> (Valid system)
>
> Kernel message log:
>
> [  450.464543] CIFS VFS: Attempting to mount //172.25.250.18/c$
> [  456.478186] CIFS VFS: Error connecting to socket. Aborting operation.
> [  456.478381] CIFS VFS: cifs_mount failed w/return code =3D -113
> [  467.688866] CIFS VFS: Attempting to mount //172.25.250.19/c$
>
> Signed-off-by: Rodrigo Freire <rfreire@redhat.com>

Hi Rodrigo,

> ---
>  fs/cifs/cifsfs.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 7065426..3f5a31e 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -707,6 +707,7 @@ static int cifs_set_super(struct super_block *sb, voi=
d *data)
>         struct cifs_mnt_data mnt_data;
>         struct dentry *root;
>
> +       cifs_dbg(VFS, "Attempting to mount %s\n", dev_name);
>         cifs_dbg(FYI, "Devname: %s flags: %d\n", dev_name, flags);

Let's change the next FYI line to not contain devname thus avoiding
duplicate logging when FYI is enabled.

>
>         volume_info =3D cifs_get_volume_info((char *)data, dev_name, is_s=
mb3);
> --
> 1.8.3.1
>

Other than the comment above I agree with the change.

--
Best regards,
Pavel Shilovsky
