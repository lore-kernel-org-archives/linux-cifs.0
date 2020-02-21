Return-Path: <SRS0=yfkL=4J=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86EF0C11D00
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Feb 2020 00:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 490CC208E4
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Feb 2020 00:08:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VJhxi1vz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbgBUAIm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Feb 2020 19:08:42 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:41463 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729410AbgBUAIl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 Feb 2020 19:08:41 -0500
Received: by mail-io1-f68.google.com with SMTP id m25so448185ioo.8
        for <linux-cifs@vger.kernel.org>; Thu, 20 Feb 2020 16:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Br/spUN0Tuo92pkftVIN9APHyCmdvM5w0ki4soUKtfQ=;
        b=VJhxi1vz70XDKoOjjDw1lvI/XjSv2WKwm0wkk4iprKAhYOQin1VhS89GNpfyFeoUtT
         Ng0L+r44QbOpGXy+ubna9ma5UdLxpkqSIWTJUG0oakYFkypnDOexK88WZBKCkHySSATR
         a/C9pBrccC86sZWUvQPX0gWwzOYTygORJ+q2wi7EydlhvnMvbAR434/OdA4KPHv7BYBN
         qVKgurpwEOaj+q3/nn3DeHktqQAQrc25eGudx7deEHN2jn0erAl5LKKMTJQ3JnID42tO
         p9Q7Qm5JFS2wZ9QScbjhihpzVU9BMbFgrMxkzxcMyL8mhG0uw9p/AXlsIew+NtMUTg7Y
         o8sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Br/spUN0Tuo92pkftVIN9APHyCmdvM5w0ki4soUKtfQ=;
        b=qEa+szRSaqgxzu8WzRBqYo8AeTfEh4el/L6qVX9uqkaPXXvwUYg+hHJnSyygD/u53t
         N9nZ7wOozwhrN8+da+KyDkLuoU2uMi5ffSdUuqP9mfYsYhUlJ2rf7IHgvXZblR38jVOO
         Nx2q3me8dR8I6TqyoVl4ULfH09barf5lZe49PWhERTr6mFoZXAytGWlVqGZQu0qDB4Ce
         K1Z7H4JxNVUf9m0vpdPlm2sRi2ysL8AETWHRaV1pblDhI/1/9/5E3oGSyY2FXL9X9ps/
         pv7eng3aZKIrQuGntzYy4TK8UX7GBACtKpZ+90k1V0qK2kIdZM35AkNiMwBQitD1f9z5
         jHTA==
X-Gm-Message-State: APjAAAVwEXZmMJlw7vdjNpthOfpz+JBNs3iOHqEbV4MVVzkeCOlZ5CUM
        E/EPpnX5VrU76ormzHu8VtF2QCM58IBzJdFBM1I=
X-Google-Smtp-Source: APXvYqwQiS7bYL6Lwtawo+kxZJRqqXWj9469rqgsX71ScWdxjTslRiucN5Le72CjgKxypFPfHDJM4SYDnVzbrL2Lrys=
X-Received: by 2002:a6b:fe0f:: with SMTP id x15mr25834986ioh.219.1582243720830;
 Thu, 20 Feb 2020 16:08:40 -0800 (PST)
MIME-Version: 1.0
References: <20200220224935.12541-1-pc@cjr.nz>
In-Reply-To: <20200220224935.12541-1-pc@cjr.nz>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 21 Feb 2020 10:08:29 +1000
Message-ID: <CAN05THS31jkB6Ta0qyJnrB49iTkDN=ghCBDec5ku9vcj2qKy9w@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: handle prefix paths in reconnect
To:     "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Cc:     Steve French <smfrench@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Fri, Feb 21, 2020 at 8:50 AM Paulo Alcantara (SUSE) <pc@cjr.nz> wrote:
>
> For the case where we have a DFS path like below and we're currently
> connected to targetA:
>
>     //dfsroot/link -> //targetA/share/foo, //targetB/share/bar
>
> after failover, we should make sure to update cifs_sb->prepath so the
> next operations will use the new prefix path "/bar".
>
> Besides, in order to simplify the use of different prefix paths,
> enforce CIFS_MOUNT_USE_PREFIX_PATH for DFS mounts so we don't have to
> revalidate the root dentry every time we set a new prefix path.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/cifsproto.h |  5 +++
>  fs/cifs/cifssmb.c   | 19 ++++++++---
>  fs/cifs/connect.c   | 63 +++++++----------------------------
>  fs/cifs/dfs_cache.c | 38 +++++++++++++++++++++
>  fs/cifs/dfs_cache.h |  4 +++
>  fs/cifs/misc.c      | 80 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/smb2pdu.c   | 19 ++++++++---
>  7 files changed, 169 insertions(+), 59 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 89eaaf46d1ca..af8e79b58b94 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -601,6 +601,11 @@ int smb2_parse_query_directory(struct cifs_tcon *tcon, struct kvec *rsp_iov,
>                                int resp_buftype,
>                                struct cifs_search_info *srch_inf);
>
> +struct super_block *cifs_get_tcp_super(struct TCP_Server_Info *server);
> +void cifs_put_tcp_super(struct super_block *sb);
> +int update_super_prepath(struct cifs_tcon *tcon, const char *prefix,
> +                        size_t prefix_len);
> +
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
>                                const char *old_path,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 3c89569e7210..b6fa575d2d3f 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -162,9 +162,18 @@ static int __cifs_reconnect_tcon(const struct nls_table *nlsc,
>
>         for (it = dfs_cache_get_tgt_iterator(&tl); it;
>              it = dfs_cache_get_next_tgt(&tl, it)) {
> -               const char *tgt = dfs_cache_get_tgt_name(it);
> +               const char *share, *prefix;
> +               size_t share_len, prefix_len;
>
> -               extract_unc_hostname(tgt, &dfs_host, &dfs_host_len);
> +               rc = dfs_cache_get_tgt_share(it, &share, &share_len, &prefix,
> +                                            &prefix_len);
> +               if (rc) {
> +                       cifs_dbg(VFS, "%s: failed to parse target share %d\n",
> +                                __func__, rc);
> +                       continue;
> +               }
> +
> +               extract_unc_hostname(share, &dfs_host, &dfs_host_len);
>
>                 if (dfs_host_len != tcp_host_len
>                     || strncasecmp(dfs_host, tcp_host, dfs_host_len) != 0) {
> @@ -175,11 +184,13 @@ static int __cifs_reconnect_tcon(const struct nls_table *nlsc,
>                         continue;
>                 }
>
> -               scnprintf(tree, MAX_TREE_SIZE, "\\%s", tgt);
> +               scnprintf(tree, MAX_TREE_SIZE, "\\%.*s", (int)share_len, share);
>
>                 rc = CIFSTCon(0, tcon->ses, tree, tcon, nlsc);
> -               if (!rc)
> +               if (!rc) {
> +                       rc = update_super_prepath(tcon, prefix, prefix_len);
>                         break;
> +               }
>                 if (rc == -EREMOTE)
>                         break;
>         }
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 4804d1df8c1c..e2196b363765 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -57,7 +57,6 @@
>  #include "smb2proto.h"
>  #include "smbdirect.h"
>  #include "dns_resolve.h"
> -#include "cifsfs.h"
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  #include "dfs_cache.h"
>  #endif
> @@ -389,54 +388,7 @@ static inline int reconn_set_ipaddr(struct TCP_Server_Info *server)
>  #endif
>
>  #ifdef CONFIG_CIFS_DFS_UPCALL
> -struct super_cb_data {
> -       struct TCP_Server_Info *server;
> -       struct super_block *sb;
> -};
> -
>  /* These functions must be called with server->srv_mutex held */
> -
> -static void super_cb(struct super_block *sb, void *arg)
> -{
> -       struct super_cb_data *d = arg;
> -       struct cifs_sb_info *cifs_sb;
> -       struct cifs_tcon *tcon;
> -
> -       if (d->sb)
> -               return;
> -
> -       cifs_sb = CIFS_SB(sb);
> -       tcon = cifs_sb_master_tcon(cifs_sb);
> -       if (tcon->ses->server == d->server)
> -               d->sb = sb;
> -}
> -
> -static struct super_block *get_tcp_super(struct TCP_Server_Info *server)
> -{
> -       struct super_cb_data d = {
> -               .server = server,
> -               .sb = NULL,
> -       };
> -
> -       iterate_supers_type(&cifs_fs_type, super_cb, &d);
> -
> -       if (unlikely(!d.sb))
> -               return ERR_PTR(-ENOENT);
> -       /*
> -        * Grab an active reference in order to prevent automounts (DFS links)
> -        * of expiring and then freeing up our cifs superblock pointer while
> -        * we're doing failover.
> -        */
> -       cifs_sb_active(d.sb);
> -       return d.sb;
> -}
> -
> -static inline void put_tcp_super(struct super_block *sb)
> -{
> -       if (!IS_ERR_OR_NULL(sb))
> -               cifs_sb_deactive(sb);
> -}
> -
>  static void reconn_inval_dfs_target(struct TCP_Server_Info *server,
>                                     struct cifs_sb_info *cifs_sb,
>                                     struct dfs_cache_tgt_list *tgt_list,
> @@ -508,7 +460,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>         server->nr_targets = 1;
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>         spin_unlock(&GlobalMid_Lock);
> -       sb = get_tcp_super(server);
> +       sb = cifs_get_tcp_super(server);
>         if (IS_ERR(sb)) {
>                 rc = PTR_ERR(sb);
>                 cifs_dbg(FYI, "%s: will not do DFS failover: rc = %d\n",
> @@ -535,7 +487,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>                 spin_unlock(&GlobalMid_Lock);
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>                 dfs_cache_free_tgts(&tgt_list);
> -               put_tcp_super(sb);
> +               cifs_put_tcp_super(sb);
>  #endif
>                 return rc;
>         } else
> @@ -666,7 +618,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>
>         }
>
> -       put_tcp_super(sb);
> +       cifs_put_tcp_super(sb);
>  #endif
>         if (server->tcpStatus == CifsNeedNegotiate)
>                 mod_delayed_work(cifsiod_wq, &server->echo, 0);
> @@ -4999,6 +4951,15 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
>          * dentry revalidation to think the dentry are stale (ESTALE).
>          */
>         cifs_autodisable_serverino(cifs_sb);
> +       /*
> +        * Force the use of prefix path to support failover on DFS paths that
> +        * resolve to targets that have different prefix paths.
> +        */
> +       cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
> +       kfree(cifs_sb->prepath);
> +       cifs_sb->prepath = vol->prepath;
> +       vol->prepath = NULL;
> +
>  out:
>         free_xid(xid);
>         cifs_try_adding_channels(ses);
> diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
> index 43c1b43a07ec..a67f88bf7ae1 100644
> --- a/fs/cifs/dfs_cache.c
> +++ b/fs/cifs/dfs_cache.c
> @@ -1260,6 +1260,44 @@ void dfs_cache_del_vol(const char *fullpath)
>         kref_put(&vi->refcnt, vol_release);
>  }
>
> +/**
> + * dfs_cache_get_tgt_share - parse a DFS target
> + *
> + * @it: DFS target iterator.
> + * @share: tree name.
> + * @share_len: length of tree name.
> + * @prefix: prefix path.
> + * @prefix_len: length of prefix path.
> + *
> + * Return zero if target was parsed correctly, otherwise non-zero.
> + */
> +int dfs_cache_get_tgt_share(const struct dfs_cache_tgt_iterator *it,
> +                           const char **share, size_t *share_len,
> +                           const char **prefix, size_t *prefix_len)
> +{
> +       char *s, sep;
> +
> +       if (!it || !share || !share_len || !prefix || !prefix_len)
> +               return -EINVAL;
> +
> +       sep = it->it_name[0];
> +       if (sep != '\\' && sep != '/')
> +               return -EINVAL;
> +
> +       s = strchr(it->it_name + 1, sep);
> +       if (!s)
> +               return -EINVAL;
> +
> +       s = strchrnul(s + 1, sep);
> +
> +       *share = it->it_name;
> +       *share_len = s - it->it_name;
> +       *prefix = *s ? s + 1 : s;
> +       *prefix_len = &it->it_name[strlen(it->it_name)] - *prefix;
> +
> +       return 0;
> +}
> +
>  /* Get all tcons that are within a DFS namespace and can be refreshed */
>  static void get_tcons(struct TCP_Server_Info *server, struct list_head *head)
>  {
> diff --git a/fs/cifs/dfs_cache.h b/fs/cifs/dfs_cache.h
> index 99ee44f8ad07..bf94d08cfb5a 100644
> --- a/fs/cifs/dfs_cache.h
> +++ b/fs/cifs/dfs_cache.h
> @@ -49,6 +49,10 @@ extern int dfs_cache_update_vol(const char *fullpath,
>                                 struct TCP_Server_Info *server);
>  extern void dfs_cache_del_vol(const char *fullpath);
>
> +extern int dfs_cache_get_tgt_share(const struct dfs_cache_tgt_iterator *it,
> +                                  const char **share, size_t *share_len,
> +                                  const char **prefix, size_t *prefix_len);
> +
>  static inline struct dfs_cache_tgt_iterator *
>  dfs_cache_get_next_tgt(struct dfs_cache_tgt_list *tl,
>                        struct dfs_cache_tgt_iterator *it)
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 40ca394fd5de..a456febd4109 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -31,6 +31,7 @@
>  #include "nterr.h"
>  #include "cifs_unicode.h"
>  #include "smb2pdu.h"
> +#include "cifsfs.h"
>
>  extern mempool_t *cifs_sm_req_poolp;
>  extern mempool_t *cifs_req_poolp;
> @@ -1022,3 +1023,82 @@ int copy_path_name(char *dst, const char *src)
>         name_len++;
>         return name_len;
>  }
> +
> +struct super_cb_data {
> +       struct TCP_Server_Info *server;
> +       struct super_block *sb;
> +};
> +
> +static void super_cb(struct super_block *sb, void *arg)
> +{
> +       struct super_cb_data *d = arg;
> +       struct cifs_sb_info *cifs_sb;
> +       struct cifs_tcon *tcon;
> +
> +       if (d->sb)
> +               return;
> +
> +       cifs_sb = CIFS_SB(sb);
> +       tcon = cifs_sb_master_tcon(cifs_sb);
> +       if (tcon->ses->server == d->server)
> +               d->sb = sb;
> +}
> +
> +struct super_block *cifs_get_tcp_super(struct TCP_Server_Info *server)
> +{
> +       struct super_cb_data d = {
> +               .server = server,
> +               .sb = NULL,
> +       };
> +
> +       iterate_supers_type(&cifs_fs_type, super_cb, &d);
> +
> +       if (unlikely(!d.sb))
> +               return ERR_PTR(-ENOENT);
> +       /*
> +        * Grab an active reference in order to prevent automounts (DFS links)
> +        * of expiring and then freeing up our cifs superblock pointer while
> +        * we're doing failover.
> +        */
> +       cifs_sb_active(d.sb);
> +       return d.sb;
> +}
> +
> +void cifs_put_tcp_super(struct super_block *sb)
> +{
> +       if (!IS_ERR_OR_NULL(sb))
> +               cifs_sb_deactive(sb);
> +}
> +
> +int update_super_prepath(struct cifs_tcon *tcon, const char *prefix,
> +                        size_t prefix_len)
> +{
> +       struct super_block *sb;
> +       struct cifs_sb_info *cifs_sb;
> +       int rc = 0;
> +
> +       sb = cifs_get_tcp_super(tcon->ses->server);
> +       if (IS_ERR(sb))
> +               return PTR_ERR(sb);
> +
> +       cifs_sb = CIFS_SB(sb);
> +
> +       kfree(cifs_sb->prepath);
> +
> +       if (*prefix && prefix_len) {
> +               cifs_sb->prepath = kstrndup(prefix, prefix_len, GFP_ATOMIC);
> +               if (!cifs_sb->prepath) {
> +                       rc = -ENOMEM;
> +                       goto out;
> +               }
> +
> +               convert_delimiter(cifs_sb->prepath, CIFS_DIR_SEP(cifs_sb));
> +       } else
> +               cifs_sb->prepath = NULL;
> +
> +       cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
> +
> +out:
> +       cifs_put_tcp_super(sb);
> +       return rc;
> +}
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index abc0a0512181..49b15a488ede 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -193,9 +193,18 @@ static int __smb2_reconnect(const struct nls_table *nlsc,
>
>         for (it = dfs_cache_get_tgt_iterator(&tl); it;
>              it = dfs_cache_get_next_tgt(&tl, it)) {
> -               const char *tgt = dfs_cache_get_tgt_name(it);
> +               const char *share, *prefix;
> +               size_t share_len, prefix_len;
>
> -               extract_unc_hostname(tgt, &dfs_host, &dfs_host_len);
> +               rc = dfs_cache_get_tgt_share(it, &share, &share_len, &prefix,
> +                                            &prefix_len);
> +               if (rc) {
> +                       cifs_dbg(VFS, "%s: failed to parse target share %d\n",
> +                                __func__, rc);
> +                       continue;
> +               }
> +
> +               extract_unc_hostname(share, &dfs_host, &dfs_host_len);
>
>                 if (dfs_host_len != tcp_host_len
>                     || strncasecmp(dfs_host, tcp_host, dfs_host_len) != 0) {
> @@ -206,11 +215,13 @@ static int __smb2_reconnect(const struct nls_table *nlsc,
>                         continue;
>                 }
>
> -               scnprintf(tree, MAX_TREE_SIZE, "\\%s", tgt);
> +               scnprintf(tree, MAX_TREE_SIZE, "\\%.*s", (int)share_len, share);
>
>                 rc = SMB2_tcon(0, tcon->ses, tree, tcon, nlsc);
> -               if (!rc)
> +               if (!rc) {
> +                       rc = update_super_prepath(tcon, prefix, prefix_len);
>                         break;
> +               }
>                 if (rc == -EREMOTE)
>                         break;
>         }
> --
> 2.25.0
>
