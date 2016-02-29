From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] s390x: fix condition to choose correct function
Date: Sun, 28 Feb 2016 22:17:32 -0600
Message-ID: <CAH2r5mtACstEhNif+_-0afz_0ddp5dqTKU8mALZtjvawrsZARw@mail.gmail.com>
References: <1456296347-9665-1-git-send-email-ydfan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	martin.schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org
To: Yadan Fan <ydfan-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456296347-9665-1-git-send-email-ydfan-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

Looks like alpha has a similar problem though

On Wed, Feb 24, 2016 at 12:45 AM, Yadan Fan <ydfan-IBi9RG/b67k@public.gmane.org> wrote:
> This issue is involved from commit 02323db17e3a7 ("cifs: fix
> cifs_uniqueid_to_ino_t not to ever return 0"), when BITS_PER_LONG
> is 64 on s390x, the corresponding cifs_uniqueid_to_ino_t()
> function will cast 64-bit fileid to 32-bit by using (ino_t)fileid,
> because ino_t (typdefed __kernel_ino_t) is int type.
>
> Signed-off-by: Yadan Fan <ydfan-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/cifsfs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 68c4547..02dcbe1 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -31,7 +31,7 @@
>   * so that it will fit. We use hash_64 to convert the value to 31 bits, and
>   * then add 1, to ensure that we don't end up with a 0 as the value.
>   */
> -#if BITS_PER_LONG == 64
> +#if BITS_PER_LONG == 64 && !defined(CONFIG_S390)
>  static inline ino_t
>  cifs_uniqueid_to_ino_t(u64 fileid)
>  {
> --
> 2.6.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
