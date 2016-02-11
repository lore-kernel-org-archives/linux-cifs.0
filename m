From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: fix potential overflow in cifs_compose_mount_options
Date: Wed, 10 Feb 2016 18:08:16 -0600
Message-ID: <CAH2r5muqNJXNcQRjJKjeZQfn303eUbM+fdGtm9x7hwBRomRKRg@mail.gmail.com>
References: <1454344498-16835-1-git-send-email-wuninsu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu,
 samba-technical <samba-technical@lists.samba.org>,
 LKML <linux-kernel@vger.kernel.org>, Steve French <sfrench@samba.org>,
 changwoo@gatech.edu
To: Insu Yun <wuninsu@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1454344498-16835-1-git-send-email-wuninsu@gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org

On Mon, Feb 1, 2016 at 10:34 AM, Insu Yun <wuninsu@gmail.com> wrote:

> In worst case, "ip=" + sb_mountdata + ipv6 can be copied into mountdata.
> Therefore, for safe, it is better to add more size when allocating memory.
>
> Signed-off-by: Insu Yun <wuninsu@gmail.com>
> ---
>  fs/cifs/cifs_dfs_ref.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> index 7dc886c..e956cba 100644
> --- a/fs/cifs/cifs_dfs_ref.c
> +++ b/fs/cifs/cifs_dfs_ref.c
> @@ -175,7 +175,7 @@ char *cifs_compose_mount_options(const char
> *sb_mountdata,
>          * string to the length of the original string to allow for worst
> case.
>          */
>         md_len = strlen(sb_mountdata) + INET6_ADDRSTRLEN;
> -       mountdata = kzalloc(md_len + 1, GFP_KERNEL);
> +       mountdata = kzalloc(md_len + sizeof("ip=") + 1, GFP_KERNEL);
>         if (mountdata == NULL) {
>                 rc = -ENOMEM;
>                 goto compose_mount_options_err;


Not likely to be reproducible in practice (since ip= is already in the
sb_mountdata) but in case mount.cifs was missing and ip= was missing from
the original mount string, might as well add it.

Merged into cifs-2.6.git
-- 
Thanks,

Steve
