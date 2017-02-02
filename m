From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [cifs:for-next 17/19] fs/cifs/smb2ops.c:1920:2: note: in
 expansion of macro 'cifs_dbg'
Date: Wed, 1 Feb 2017 19:37:54 -0600
Message-ID: <CAH2r5msnG0JTSqyXdW-48TTEto=cZd1AYkzsSLMJaqdo27dC-A@mail.gmail.com>
References: <201702020732.x0thMW1T%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201702020732.x0thMW1T%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel just fixed this - and I just repushed to cifs-2.6.git for-next

Thx for spotting this.

On Wed, Feb 1, 2017 at 5:49 PM, kbuild test robot
<fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> head:   f339620a6d00fdf92f68b37024fb447d3fcc474f
> commit: c9d651a5a2fedac623853852ab2c3cd3b8fdf3bf [17/19] CIFS: Decrypt and process small encrypted packets
> config: i386-allmodconfig (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         git checkout c9d651a5a2fedac623853852ab2c3cd3b8fdf3bf
>         # save the attached .config to linux build tree
>         make ARCH=i386
>
> All warnings (new ones prefixed by >>):
>
>    In file included from include/linux/kernel.h:13:0,
>                     from include/asm-generic/bug.h:13,
>                     from arch/x86/include/asm/bug.h:35,
>                     from include/linux/bug.h:4,
>                     from include/linux/mmdebug.h:4,
>                     from include/linux/mm.h:8,
>                     from include/linux/pagemap.h:7,
>                     from fs/cifs/smb2ops.c:20:
>    fs/cifs/smb2ops.c: In function 'handle_read_data':
>>> fs/cifs/cifs_debug.h:55:24: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'size_t {aka unsigned int}' [-Wformat=]
>       pr_debug_ratelimited("%s: "    \
>                            ^
>    include/linux/printk.h:276:21: note: in definition of macro 'pr_fmt'
>     #define pr_fmt(fmt) fmt
>                         ^~~
>    fs/cifs/cifs_debug.h:55:3: note: in expansion of macro 'pr_debug_ratelimited'
>       pr_debug_ratelimited("%s: "    \
>       ^~~~~~~~~~~~~~~~~~~~
>>> fs/cifs/smb2ops.c:1920:2: note: in expansion of macro 'cifs_dbg'
>      cifs_dbg(FYI, "0: iov_base=%p iov_len=%lu\n",
>      ^~~~~~~~
>    In file included from fs/cifs/smb2ops.c:29:0:
>>> fs/cifs/smb2ops.c:1920:16: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'size_t {aka unsigned int}' [-Wformat=]
>      cifs_dbg(FYI, "0: iov_base=%p iov_len=%lu\n",
>                    ^
>    fs/cifs/cifs_debug.h:58:16: note: in definition of macro 'cifs_dbg'
>       cifs_vfs_err(fmt, ##__VA_ARGS__);   \
>                    ^~~
>    In file included from include/linux/kernel.h:13:0,
>                     from include/asm-generic/bug.h:13,
>                     from arch/x86/include/asm/bug.h:35,
>                     from include/linux/bug.h:4,
>                     from include/linux/mmdebug.h:4,
>                     from include/linux/mm.h:8,
>                     from include/linux/pagemap.h:7,
>                     from fs/cifs/smb2ops.c:20:
>    fs/cifs/smb2ops.c:1920:16: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type 'size_t {aka unsigned int}' [-Wformat=]
>      cifs_dbg(FYI, "0: iov_base=%p iov_len=%lu\n",
>                    ^
>    include/linux/printk.h:276:21: note: in definition of macro 'pr_fmt'
>     #define pr_fmt(fmt) fmt
>                         ^~~
>    fs/cifs/cifs_debug.h:60:3: note: in expansion of macro 'pr_debug_ratelimited'
>       pr_debug_ratelimited(fmt, ##__VA_ARGS__);  \
>       ^~~~~~~~~~~~~~~~~~~~
>>> fs/cifs/smb2ops.c:1920:2: note: in expansion of macro 'cifs_dbg'
>      cifs_dbg(FYI, "0: iov_base=%p iov_len=%lu\n",
>      ^~~~~~~~
>
> vim +/cifs_dbg +1920 fs/cifs/smb2ops.c
>
>   1904                  iov.iov_base = buf + data_offset;
>   1905                  iov.iov_len = data_len;
>   1906                  iov_iter_kvec(&iter, WRITE | ITER_KVEC, &iov, 1, data_len);
>   1907          } else {
>   1908                  /* read response payload cannot be in both buf and pages */
>   1909                  WARN_ONCE(1, "buf can not contain only a part of read data");
>   1910                  rdata->result = -EIO;
>   1911                  dequeue_mid(mid, rdata->result);
>   1912                  return 0;
>   1913          }
>   1914
>   1915          /* set up first iov for signature check */
>   1916          rdata->iov[0].iov_base = buf;
>   1917          rdata->iov[0].iov_len = 4;
>   1918          rdata->iov[1].iov_base = buf + 4;
>   1919          rdata->iov[1].iov_len = server->vals->read_rsp_size - 4;
>> 1920          cifs_dbg(FYI, "0: iov_base=%p iov_len=%lu\n",
>   1921                   rdata->iov[0].iov_base, server->vals->read_rsp_size);
>   1922
>   1923          length = rdata->copy_into_pages(server, rdata, &iter);
>   1924
>   1925          kfree(bvec);
>   1926
>   1927          if (length < 0)
>   1928                  return length;
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation



-- 
Thanks,

Steve
