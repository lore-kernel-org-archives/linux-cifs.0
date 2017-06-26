From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: build warning after merge of the cifs tree
Date: Mon, 26 Jun 2017 11:57:46 -0500
Message-ID: <CAH2r5mstCdHYdaJ1kQEDO5SiJP1gDNTQiXqZ3s3mW==XfCx7mw@mail.gmail.com>
References: <20170626100728.0494601c@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170626100728.0494601c-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I just merged an updated version of this patch to remove the warning
to cifs-2.6.git for-next

On Sun, Jun 25, 2017 at 7:07 PM, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> wrote:
> Hi all,
>
> After merging the cifs tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
>
> In file included from include/linux/kernel.h:13:0,
>                  from include/linux/list.h:8,
>                  from include/linux/wait.h:6,
>                  from include/linux/fs.h:5,
>                  from fs/cifs/smb2transport.c:25:
> fs/cifs/smb2transport.c: In function 'generate_smb3signingkey':
> fs/cifs/cifs_debug.h:55:24: warning: field width specifier '*' expects argument of type 'int', but argument 4 has type 'long unsigned int' [-Wformat=]
>    pr_debug_ratelimited("%s: "    \
>                         ^
> include/linux/printk.h:285:21: note: in definition of macro 'pr_fmt'
>  #define pr_fmt(fmt) fmt
>                      ^
> fs/cifs/cifs_debug.h:55:3: note: in expansion of macro 'pr_debug_ratelimited'
>    pr_debug_ratelimited("%s: "    \
>    ^
> fs/cifs/smb2transport.c:352:2: note: in expansion of macro 'cifs_dbg'
>   cifs_dbg(VFS, "Session Id    %*ph\n", sizeof(ses->Suid), &ses->Suid);
>   ^
> In file included from fs/cifs/smb2transport.c:39:0:
> fs/cifs/smb2transport.c:352:16: warning: field width specifier '*' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
>   cifs_dbg(VFS, "Session Id    %*ph\n", sizeof(ses->Suid), &ses->Suid);
>                 ^
> fs/cifs/cifs_debug.h:58:16: note: in definition of macro 'cifs_dbg'
>    cifs_vfs_err(fmt, ##__VA_ARGS__);   \
>                 ^
> In file included from include/linux/kernel.h:13:0,
>                  from include/linux/list.h:8,
>                  from include/linux/wait.h:6,
>                  from include/linux/fs.h:5,
>                  from fs/cifs/smb2transport.c:25:
> fs/cifs/smb2transport.c:352:16: warning: field width specifier '*' expects argument of type 'int', but argument 3 has type 'long unsigned int' [-Wformat=]
>   cifs_dbg(VFS, "Session Id    %*ph\n", sizeof(ses->Suid), &ses->Suid);
>                 ^
> include/linux/printk.h:285:21: note: in definition of macro 'pr_fmt'
>  #define pr_fmt(fmt) fmt
>                      ^
> fs/cifs/cifs_debug.h:60:3: note: in expansion of macro 'pr_debug_ratelimited'
>    pr_debug_ratelimited(fmt, ##__VA_ARGS__);  \
>    ^
> fs/cifs/smb2transport.c:352:2: note: in expansion of macro 'cifs_dbg'
>   cifs_dbg(VFS, "Session Id    %*ph\n", sizeof(ses->Suid), &ses->Suid);
>   ^
>
> Introduced by commit
>
>   ba4f2a8b205f ("CIFS: add CONFIG_CIFS_DEBUG_KEYS to dump encryption keys")
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
