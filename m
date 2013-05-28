From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 19/19] cifs: try to handle the MUST SecurityFlags sanely
Date: Tue, 28 May 2013 10:38:23 +0400
Message-ID: <CAKywueSCEzGRT7mgCeH5ue7aBUmVy3stzKRt2pbu=ToPaLerNg@mail.gmail.com>
References: <1369321563-16893-1-git-send-email-jlayton@redhat.com>
	<1369321563-16893-20-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369321563-16893-20-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/5/23 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> The cifs.ko SecurityFlags interface wins my award for worst-designed
> interface ever, but we're sort of stuck with it since it's documented
> and people do use it (even if it doesn't work correctly).
>
> Case in point -- you can specify multiple sets of "MUST" flags. It makes
> absolutely no sense, but you can do it.
>
> What should the effect be in such a case? No one knows or seems to have
> considered this, so let's define it now. If you try to specify multiple
> MUST flags, clear any other MAY or MUST bits except for the ones that
> involve signing.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifs_debug.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 856f8f5..d21339a 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -595,6 +595,32 @@ static int cifs_security_flags_proc_open(struct inode *inode, struct file *file)
>         return single_open(file, cifs_security_flags_proc_show, NULL);
>  }
>
> +/*
> + * Ensure that if someone sets a MUST flag, that we disable all other MAY
> + * flags except for the ones corresponding to the given MUST flag. If there are
> + * multiple MUST flags, then try to prefer more secure ones.
> + */
> +static void
> +cifs_security_flags_handle_must_flags(unsigned int *flags)
> +{
> +       unsigned int signflags = *flags & CIFSSEC_MUST_SIGN;
> +
> +       if ((*flags & CIFSSEC_MUST_KRB5) == CIFSSEC_MUST_KRB5)
> +               *flags = CIFSSEC_MUST_KRB5;
> +       else if ((*flags & CIFSSEC_MUST_NTLMSSP) == CIFSSEC_MUST_NTLMSSP)
> +               *flags = CIFSSEC_MUST_NTLMSSP;
> +       else if ((*flags & CIFSSEC_MUST_NTLMV2) == CIFSSEC_MUST_NTLMV2)
> +               *flags = CIFSSEC_MUST_NTLMV2;
> +       else if ((*flags & CIFSSEC_MUST_NTLM) == CIFSSEC_MUST_NTLM)
> +               *flags = CIFSSEC_MUST_NTLM;
> +       else if ((*flags & CIFSSEC_MUST_LANMAN) == CIFSSEC_MUST_LANMAN)
> +               *flags = CIFSSEC_MUST_LANMAN;
> +       else if ((*flags & CIFSSEC_MUST_PLNTXT) == CIFSSEC_MUST_PLNTXT)
> +               *flags = CIFSSEC_MUST_PLNTXT;
> +
> +       *flags |= signflags;
> +}
> +
>  static ssize_t cifs_security_flags_proc_write(struct file *file,
>                 const char __user *buffer, size_t count, loff_t *ppos)
>  {
> @@ -648,6 +674,8 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
>                 return -EINVAL;
>         }
>
> +       cifs_security_flags_handle_must_flags(&flags);
> +
>         /* flags look ok - update the global security flags for cifs module */
>         global_secflags = flags;
>         if (global_secflags & CIFSSEC_MUST_SIGN) {
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--
Best regards,
Pavel Shilovsky.
