From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: use %16phN for formatting md5 sum
Date: Thu, 15 Dec 2016 00:37:48 -0600
Message-ID: <CAH2r5mv8nrgf1ZwRs6sHnzeJ9jPVEFiA0_VXS5nb7uXM2zNEnQ@mail.gmail.com>
References: <1480545633-2675-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480545633-2675-1-git-send-email-linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Wed, Nov 30, 2016 at 4:40 PM, Rasmus Villemoes
<linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org> wrote:
> Passing a gazillion arguments takes a lot of code:
>
> add/remove: 0/0 grow/shrink: 0/2 up/down: 0/-253 (-253)
>
> Signed-off-by: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
> ---
>  fs/cifs/link.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index d031af8d3d4d..c4d996f78e1c 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -45,13 +45,8 @@
>         (CIFS_MF_SYMLINK_LINK_OFFSET + CIFS_MF_SYMLINK_LINK_MAXLEN)
>
>  #define CIFS_MF_SYMLINK_LEN_FORMAT "XSym\n%04u\n"
> -#define CIFS_MF_SYMLINK_MD5_FORMAT \
> -       "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x\n"
> -#define CIFS_MF_SYMLINK_MD5_ARGS(md5_hash) \
> -       md5_hash[0],  md5_hash[1],  md5_hash[2],  md5_hash[3], \
> -       md5_hash[4],  md5_hash[5],  md5_hash[6],  md5_hash[7], \
> -       md5_hash[8],  md5_hash[9],  md5_hash[10], md5_hash[11],\
> -       md5_hash[12], md5_hash[13], md5_hash[14], md5_hash[15]
> +#define CIFS_MF_SYMLINK_MD5_FORMAT "%16phN\n"
> +#define CIFS_MF_SYMLINK_MD5_ARGS(md5_hash) md5_hash
>
>  static int
>  symlink_hash(unsigned int link_len, const char *link_str, u8 *md5_hash)
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
