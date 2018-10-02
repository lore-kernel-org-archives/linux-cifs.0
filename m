From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH v2] CIFS: Print message when attempting a mount
Date: Tue, 2 Oct 2018 14:17:02 -0500
Message-ID: <CAH2r5mtu9XbQfR=QevDqu36ZRYah1hrRGSQyynCfr82PRyunwQ@mail.gmail.com>
References: <ad6b338c900a17c4ecb1655a42b954221f242be2.1538480816.git.rfreire@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
To: rfreire@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ad6b338c900a17c4ecb1655a42b954221f242be2.1538480816.git.rfreire@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Are you sure that these aren't logged by the automounter (for ext4,
xfs etc.).  When I looked in my dmesg logs I didn't find matching log
entries in the file systems themselves.  Do you have an example?

On the idea of adding cifsFYI logging here - I slightly prefer using
ftrace (trace-cmd, ie dynamic tracing) so there is less overhead and
easier to turn on/off following the example of xfs, f2fs, nfs, nfsd
etc.
On Tue, Oct 2, 2018 at 6:57 AM Rodrigo Freire <rfreire@redhat.com> wrote:
>
> Currently, no messages are printed when mounting a CIFS filesystem and
> no debug configuration is enabled.
>
> However, a CIFS mount information is valuable when troubleshooting
> and/or forensic analyzing a system and finding out if was a CIFS
> endpoint mount attempted.
>
> Other filesystems such as XFS, EXT* does issue a printk() when mounting
> their filesystems.
>
> A terse log message is printed only if cifsFYI is not enabled.
>
> Sample mount operations:
>
> [root@corinthians ~]# mount -o user=administrator //172.25.250.18/c$ /mnt
> (non-existent system)
>
> [root@corinthians ~]# mount -o user=administrator //172.25.250.19/c$ /mnt
> (Valid system)
>
> Kernel message log for the mount operations:
>
> [  450.464543] CIFS VFS: Attempting to mount //172.25.250.18/c$
> [  456.478186] CIFS VFS: Error connecting to socket. Aborting operation.
> [  456.478381] CIFS VFS: cifs_mount failed w/return code = -113
> [  467.688866] CIFS VFS: Attempting to mount //172.25.250.19/c$
>
> v2: Created a loop to select the right cifs_dbg message to be printed,
>     considering the current system's scenario, in order to avoid a
>     duplicate message or stripping out important information in
>     debug.
>
> Signed-off-by: Rodrigo Freire <rfreire@redhat.com>
> ---
>  fs/cifs/cifsfs.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 7065426..7fde6bc 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -707,7 +707,11 @@ static int cifs_set_super(struct super_block *sb, void *data)
>         struct cifs_mnt_data mnt_data;
>         struct dentry *root;
>
> -       cifs_dbg(FYI, "Devname: %s flags: %d\n", dev_name, flags);
> +       /* Prints in Kernel / CIFS log the attempted mount operation */
> +       if (cifsFYI)
> +               cifs_dbg(FYI, "Devname: %s flags: %d\n", dev_name, flags);
> +       else
> +               cifs_dbg(VFS, "Attempting to mount %s\n", dev_name);
>
>         volume_info = cifs_get_volume_info((char *)data, dev_name, is_smb3);
>         if (IS_ERR(volume_info))
> --
> 1.8.3.1
>


-- 
Thanks,

Steve
