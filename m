From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: linux-next: build warning after merge of the cifs tree
Date: Mon, 26 Jun 2017 10:07:28 +1000
Message-ID: <20170626100728.0494601c@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,

After merging the cifs tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

In file included from include/linux/kernel.h:13:0,
                 from include/linux/list.h:8,
                 from include/linux/wait.h:6,
                 from include/linux/fs.h:5,
                 from fs/cifs/smb2transport.c:25:
fs/cifs/smb2transport.c: In function 'generate_smb3signingkey':
fs/cifs/cifs_debug.h:55:24: warning: field width specifier '*' expects argument of type 'int', but argument 4 has type 'long unsigned int' [-Wformat=]
   pr_debug_ratelimited("%s: "    \
                        ^
include/linux/printk.h:285:21: note: in definition of macro 'pr_fmt'
 #define pr_fmt(fmt) fmt
                     ^
fs/cifs/cifs_debug.h:55:3: note: in expansion of macro 'pr_debug_ratelimited'
   pr_debug_ratelimited("%s: "    \
   ^
fs/cifs/smb2transport.c:352:2: note: in expansion of macro 'cifs_dbg'
  cifs_dbg(VFS, "Session Id    %*ph\n", sizeof(ses->Suid), &ses->Suid);
  ^
In file included from fs/cifs/smb2transport.c:39:0:
fs/cifs/smb2transport.c:352:16: warning: field width specifier '*' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
  cifs_dbg(VFS, "Session Id    %*ph\n", sizeof(ses->Suid), &ses->Suid);
                ^
fs/cifs/cifs_debug.h:58:16: note: in definition of macro 'cifs_dbg'
   cifs_vfs_err(fmt, ##__VA_ARGS__);   \
                ^
In file included from include/linux/kernel.h:13:0,
                 from include/linux/list.h:8,
                 from include/linux/wait.h:6,
                 from include/linux/fs.h:5,
                 from fs/cifs/smb2transport.c:25:
fs/cifs/smb2transport.c:352:16: warning: field width specifier '*' expects argument of type 'int', but argument 3 has type 'long unsigned int' [-Wformat=]
  cifs_dbg(VFS, "Session Id    %*ph\n", sizeof(ses->Suid), &ses->Suid);
                ^
include/linux/printk.h:285:21: note: in definition of macro 'pr_fmt'
 #define pr_fmt(fmt) fmt
                     ^
fs/cifs/cifs_debug.h:60:3: note: in expansion of macro 'pr_debug_ratelimited'
   pr_debug_ratelimited(fmt, ##__VA_ARGS__);  \
   ^
fs/cifs/smb2transport.c:352:2: note: in expansion of macro 'cifs_dbg'
  cifs_dbg(VFS, "Session Id    %*ph\n", sizeof(ses->Suid), &ses->Suid);
  ^

Introduced by commit

  ba4f2a8b205f ("CIFS: add CONFIG_CIFS_DEBUG_KEYS to dump encryption keys")

-- 
Cheers,
Stephen Rothwell
