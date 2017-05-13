From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] fs: cifs: transport: Use time_after for time comparison
Date: Fri, 12 May 2017 20:11:08 -0500
Message-ID: <CAH2r5mvifDgGoQshsuETUHq5UgqS_Sg7+2V9To7Xcn6t87WZ0g@mail.gmail.com>
References: <1494546818-5544-1-git-send-email-karim.eshapa@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Karim Eshapa <karim.eshapa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494546818-5544-1-git-send-email-karim.eshapa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Thu, May 11, 2017 at 6:53 PM, Karim Eshapa <karim.eshapa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Use time_after kernel macro for time comparison
> that has safety check.
>
> Signed-off-by: Karim Eshapa <karim.eshapa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 4d64b5b..a7f5168 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -94,7 +94,7 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
>         now = jiffies;
>         /* commands taking longer than one second are indications that
>            something is wrong, unless it is quite a slow link or server */
> -       if ((now - midEntry->when_alloc) > HZ) {
> +       if (time_after(now, midEntry->when_alloc + HZ)) {
>                 if ((cifsFYI & CIFS_TIMER) && (midEntry->command != command)) {
>                         pr_debug(" CIFS slow rsp: cmd %d mid %llu",
>                                midEntry->command, midEntry->mid);
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
