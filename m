From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/6] cifs: get rid of smb_vol->UNCip and smb_vol->port
Date: Wed, 21 Nov 2012 19:17:02 +0400
Message-ID: <CAKywueS_Q+mCq5_B+ercaOEGoHm+O+cVYjNysGmLV4xXa2TV1A@mail.gmail.com>
References: <1353087414-32152-1-git-send-email-jlayton@redhat.com>
	<1353087414-32152-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org, almiller_1-/E1597aS9LT10XsdtD+oqA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353087414-32152-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/11/16 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Passing this around as a string is contorted and painful. Instead, just
> convert these to a sockaddr as soon as possible, since that's how we're
> going to work with it later anyway.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h  |  3 +-
>  fs/cifs/cifsproto.h |  4 +--
>  fs/cifs/connect.c   | 91 +++++++++++++++++++----------------------------------
>  fs/cifs/netmisc.c   | 14 +--------
>  4 files changed, 36 insertions(+), 76 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index f5af252..b141c90 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -396,7 +396,6 @@ struct smb_vol {
>         char *password;
>         char *domainname;
>         char *UNC;
> -       char *UNCip;
>         char *iocharset;  /* local code page for mapping to and from Unicode */
>         char source_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL]; /* clnt nb name */
>         char target_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL]; /* srvr nb name */
> @@ -444,11 +443,11 @@ struct smb_vol {
>         unsigned int rsize;
>         unsigned int wsize;
>         bool sockopt_tcp_nodelay:1;
> -       unsigned short int port;
>         unsigned long actimeo; /* attribute cache timeout (jiffies) */
>         struct smb_version_operations *ops;
>         struct smb_version_values *vals;
>         char *prepath;
> +       struct sockaddr_storage dstaddr; /* destination address */
>         struct sockaddr_storage srcaddr; /* allow binding to a local IP */
>         struct nls_table *local_nls;
>  };
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 2d2ae69..a69cace 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -106,9 +106,7 @@ extern unsigned int smbCalcSize(void *buf);
>  extern int decode_negTokenInit(unsigned char *security_blob, int length,
>                         struct TCP_Server_Info *server);
>  extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
> -extern int cifs_set_port(struct sockaddr *addr, const unsigned short int port);
> -extern int cifs_fill_sockaddr(struct sockaddr *dst, const char *src, int len,
> -                               const unsigned short int port);
> +extern void cifs_set_port(struct sockaddr *addr, const unsigned short int port);
>  extern int map_smb_to_linux_error(char *buf, bool logErr);
>  extern void header_assemble(struct smb_hdr *, char /* command */ ,
>                             const struct cifs_tcon *, int /* length of
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index b9849ac..7d95206 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1108,6 +1108,9 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>         char *string = NULL;
>         char *tmp_end, *value;
>         char delim;
> +       bool got_ip = false;
> +       unsigned short port = 0;
> +       struct sockaddr *dstaddr = (struct sockaddr *)&vol->dstaddr;
>
>         separator[0] = ',';
>         separator[1] = 0;
> @@ -1416,12 +1419,12 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>                         vol->dir_mode = option;
>                         break;
>                 case Opt_port:
> -                       if (get_option_ul(args, &option)) {
> -                               cERROR(1, "%s: Invalid port value",
> -                                       __func__);
> +                       if (get_option_ul(args, &option) ||
> +                           option > USHRT_MAX) {
> +                               cERROR(1, "%s: Invalid port value", __func__);
>                                 goto cifs_parse_mount_err;
>                         }
> -                       vol->port = option;
> +                       port = (unsigned short)option;
>                         break;
>                 case Opt_rsize:
>                         if (get_option_ul(args, &option)) {
> @@ -1537,25 +1540,21 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>                         vol->password[j] = '\0';
>                         break;
>                 case Opt_blank_ip:
> -                       vol->UNCip = NULL;
> +                       /* FIXME: should this be an error instead? */
> +                       got_ip = false;
>                         break;
>                 case Opt_ip:
>                         string = match_strdup(args);
>                         if (string == NULL)
>                                 goto out_nomem;
>
> -                       if (strnlen(string, INET6_ADDRSTRLEN) >
> -                                               INET6_ADDRSTRLEN) {
> -                               printk(KERN_WARNING "CIFS: ip address "
> -                                                   "too long\n");
> -                               goto cifs_parse_mount_err;
> -                       }
> -                       vol->UNCip = kstrdup(string, GFP_KERNEL);
> -                       if (!vol->UNCip) {
> -                               printk(KERN_WARNING "CIFS: no memory "
> -                                                   "for UNC IP\n");
> +                       if (!cifs_convert_address(dstaddr, string,
> +                                       strlen(string))) {
> +                               printk(KERN_ERR "CIFS: bad ip= option (%s).\n",
> +                                       string);
>                                 goto cifs_parse_mount_err;
>                         }
> +                       got_ip = true;
>                         break;
>                 case Opt_unc:
>                         string = match_strdup(args);
> @@ -1805,8 +1804,18 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>                 goto cifs_parse_mount_err;
>         }
>
> -       if (vol->UNCip == NULL)
> -               vol->UNCip = &vol->UNC[2];
> +       if (!got_ip) {
> +               /* No ip= option specified? Try to get it from UNC */
> +               if (!cifs_convert_address(dstaddr, &vol->UNC[2],
> +                                               strlen(&vol->UNC[2]))) {
> +                       printk(KERN_ERR "Unable to determine destination "
> +                                       "address.\n");
> +                       goto cifs_parse_mount_err;
> +               }
> +       }
> +
> +       /* set the port that we got earlier */
> +       cifs_set_port(dstaddr, port);
>
>         if (uid_specified)
>                 vol->override_uid = override_uid;
> @@ -2056,29 +2065,13 @@ static struct TCP_Server_Info *
>  cifs_get_tcp_session(struct smb_vol *volume_info)
>  {
>         struct TCP_Server_Info *tcp_ses = NULL;
> -       struct sockaddr_storage addr;
> -       struct sockaddr_in *sin_server = (struct sockaddr_in *) &addr;
> -       struct sockaddr_in6 *sin_server6 = (struct sockaddr_in6 *) &addr;
> +       struct sockaddr *dstaddr = (struct sockaddr *)&volume_info->dstaddr;
>         int rc;
>
> -       memset(&addr, 0, sizeof(struct sockaddr_storage));
> -
> -       cFYI(1, "UNC: %s ip: %s", volume_info->UNC, volume_info->UNCip);
> -
> -       if (volume_info->UNCip && volume_info->UNC) {
> -               rc = cifs_fill_sockaddr((struct sockaddr *)&addr,
> -                                       volume_info->UNCip,
> -                                       strlen(volume_info->UNCip),
> -                                       volume_info->port);
> -               if (!rc) {
> -                       /* we failed translating address */
> -                       rc = -EINVAL;
> -                       goto out_err;
> -               }
> -       }
> +       cFYI(1, "UNC: %s", volume_info->UNC);
>
>         /* see if we already have a matching tcp_ses */
> -       tcp_ses = cifs_find_tcp_session((struct sockaddr *)&addr, volume_info);
> +       tcp_ses = cifs_find_tcp_session(dstaddr, volume_info);
>         if (tcp_ses)
>                 return tcp_ses;
>
> @@ -2134,15 +2127,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>                sizeof(tcp_ses->srcaddr));
>         ++tcp_ses->srv_count;
>
> -       if (addr.ss_family == AF_INET6) {
> -               cFYI(1, "attempting ipv6 connect");
> -               /* BB should we allow ipv6 on port 139? */
> -               /* other OS never observed in Wild doing 139 with v6 */
> -               memcpy(&tcp_ses->dstaddr, sin_server6,
> -                      sizeof(struct sockaddr_in6));
> -       } else
> -               memcpy(&tcp_ses->dstaddr, sin_server,
> -                      sizeof(struct sockaddr_in));
> +       memcpy(&tcp_ses->dstaddr, dstaddr, sizeof(tcp_ses->dstaddr));
>
>         rc = ip_connect(tcp_ses);
>         if (rc < 0) {
> @@ -2712,11 +2697,9 @@ cifs_match_super(struct super_block *sb, void *data)
>         struct cifs_ses *ses;
>         struct cifs_tcon *tcon;
>         struct tcon_link *tlink;
> -       struct sockaddr_storage addr;
> +       struct sockaddr *dstaddr;
>         int rc = 0;
>
> -       memset(&addr, 0, sizeof(struct sockaddr_storage));
> -
>         spin_lock(&cifs_tcp_ses_lock);
>         cifs_sb = CIFS_SB(sb);
>         tlink = cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
> @@ -2729,15 +2712,9 @@ cifs_match_super(struct super_block *sb, void *data)
>         tcp_srv = ses->server;
>
>         volume_info = mnt_data->vol;
> +       dstaddr = (struct sockaddr *)&volume_info->dstaddr;
>
> -       rc = cifs_fill_sockaddr((struct sockaddr *)&addr,
> -                               volume_info->UNCip,
> -                               strlen(volume_info->UNCip),
> -                               volume_info->port);
> -       if (!rc)
> -               goto out;
> -
> -       if (!match_server(tcp_srv, (struct sockaddr *)&addr, volume_info) ||
> +       if (!match_server(tcp_srv, dstaddr, volume_info) ||
>             !match_session(ses, volume_info) ||
>             !match_tcon(tcon, volume_info->UNC)) {
>                 rc = 0;
> @@ -3252,8 +3229,6 @@ cleanup_volume_info_contents(struct smb_vol *volume_info)
>  {
>         kfree(volume_info->username);
>         kzfree(volume_info->password);
> -       if (volume_info->UNCip != volume_info->UNC + 2)
> -               kfree(volume_info->UNCip);
>         kfree(volume_info->UNC);
>         kfree(volume_info->domainname);
>         kfree(volume_info->iocharset);
> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> index d5ce9e2..a82bc51 100644
> --- a/fs/cifs/netmisc.c
> +++ b/fs/cifs/netmisc.c
> @@ -204,7 +204,7 @@ cifs_convert_address(struct sockaddr *dst, const char *src, int len)
>         return rc;
>  }
>
> -int
> +void
>  cifs_set_port(struct sockaddr *addr, const unsigned short int port)
>  {
>         switch (addr->sa_family) {
> @@ -214,19 +214,7 @@ cifs_set_port(struct sockaddr *addr, const unsigned short int port)
>         case AF_INET6:
>                 ((struct sockaddr_in6 *)addr)->sin6_port = htons(port);
>                 break;
> -       default:
> -               return 0;
>         }
> -       return 1;
> -}
> -
> -int
> -cifs_fill_sockaddr(struct sockaddr *dst, const char *src, int len,
> -                  const unsigned short int port)
> -{
> -       if (!cifs_convert_address(dst, src, len))
> -               return 0;
> -       return cifs_set_port(dst, port);
>  }
>
>  /*****************************************************************************
> --
> 1.7.11.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

-- 
Best regards,
Pavel Shilovsky.
