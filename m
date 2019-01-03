From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: cifs large stack allocations
Date: Thu, 3 Jan 2019 10:54:20 +0100
Message-ID: <CAMuHMdUh3yjrs91976G_eB2DDtnsN4Vy3qj2LmtpTgZFdpyW7Q@mail.gmail.com>
References: <git-mailbomb-linux-master-a3a53b7603798fd875e2afbba7e2b9ba6b19c7c7@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Paulo Alcantara <palcantara@suse.de>,
        Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <git-mailbomb-linux-master-a3a53b7603798fd875e2afbba7e2b9ba6b19c7c7@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi Paulo,

On Wed, Jan 2, 2019 at 10:24 PM Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Commit:     a3a53b7603798fd875e2afbba7e2b9ba6b19c7c7
> Parent:     23324407143dd923660378fd9b40b9a711972269
> Refname:    refs/heads/master
> Web:        https://git.kernel.org/torvalds/c/a3a53b7603798fd875e2afbba7e2b9ba6b19c7c7
> Author:     Paulo Alcantara <palcantara@suse.de>
> AuthorDate: Wed Nov 14 17:20:31 2018 -0200
> Committer:  Steve French <stfrench@microsoft.com>
> CommitDate: Fri Dec 28 10:13:11 2018 -0600
>
>     cifs: Add support for failover in smb2_reconnect()
>
>     After a successful failover in cifs_reconnect(), the smb2_reconnect()
>     function will make sure to reconnect every tcon to new target server.
>
>     For SMB2+.
>
>     Signed-off-by: Paulo Alcantara <palcantara@suse.de>
>     Signed-off-by: Aurelien Aptel <aaptel@suse.com>
>     Signed-off-by: Steve French <stfrench@microsoft.com>

> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c

> @@ -152,6 +155,77 @@ out:
>         return;
>  }
>
> +#ifdef CONFIG_CIFS_DFS_UPCALL
> +static int __smb2_reconnect(const struct nls_table *nlsc,
> +                           struct cifs_tcon *tcon)
> +{
> +       int rc;
> +       struct dfs_cache_tgt_list tl;
> +       struct dfs_cache_tgt_iterator *it = NULL;
> +       char tree[MAX_TREE_SIZE + 1];

warning: the frame size of 1316 bytes is larger than 1024 bytes
[-Wframe-larger-than=]

MAX_TREE_SIZE = 1284

On Wed, Jan 2, 2019 at 10:24 PM Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
>
> Commit:     08744015492fec5a30ab8e2779601ae2b1a5e431
> Parent:     a3a53b7603798fd875e2afbba7e2b9ba6b19c7c7
> Refname:    refs/heads/master
> Web:        https://git.kernel.org/torvalds/c/08744015492fec5a30ab8e2779601ae2b1a5e431
> Author:     Paulo Alcantara <palcantara@suse.de>
> AuthorDate: Wed Nov 14 17:24:29 2018 -0200
> Committer:  Steve French <stfrench@microsoft.com>
> CommitDate: Fri Dec 28 10:13:11 2018 -0600
>
>     cifs: Add support for failover in cifs_reconnect_tcon()
>
>     After a successful failover, the cifs_reconnect_tcon() function will
>     make sure to reconnect every tcon to new target server.
>
>     Same as previous commit but for SMB1 codepath.
>
>     Signed-off-by: Paulo Alcantara <palcantara@suse.de>
>     Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>     Signed-off-by: Steve French <stfrench@microsoft.com>

> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c

> @@ -118,6 +121,77 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
>          */
>  }
>
> +#ifdef CONFIG_CIFS_DFS_UPCALL
> +static int __cifs_reconnect_tcon(const struct nls_table *nlsc,
> +                                struct cifs_tcon *tcon)
> +{
> +       int rc;
> +       struct dfs_cache_tgt_list tl;
> +       struct dfs_cache_tgt_iterator *it = NULL;
> +       char tree[MAX_TREE_SIZE + 1];

warning: the frame size of 1316 bytes is larger than 1024 bytes
[-Wframe-larger-than=]

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
