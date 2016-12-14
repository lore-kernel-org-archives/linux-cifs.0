From: Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH] cifs: use %16phN for formatting md5 sum
Date: Wed, 14 Dec 2016 11:46:44 -0800
Message-ID: <CAKywueSq_W0Ud2GXBanRK-F-kgaqh1b-+awUNt75ctwtwj3Bvg@mail.gmail.com>
References: <1480545633-2675-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench@samba.org>, linux-cifs <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>,
 Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1480545633-2675-1-git-send-email-linux@rasmusvillemoes.dk>
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

2016-11-30 14:40 GMT-08:00 Rasmus Villemoes <linux@rasmusvillemoes.dk>:
> Passing a gazillion arguments takes a lot of code:
>
> add/remove: 0/0 grow/shrink: 0/2 up/down: 0/-253 (-253)
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
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
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

-- 
Best regards,
Pavel Shilovsky
