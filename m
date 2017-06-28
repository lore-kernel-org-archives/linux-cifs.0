From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH resend] cifs: Do not modify mid entry after submitting I/O
 in cifs_call_async
Date: Wed, 28 Jun 2017 11:23:20 -0700
Message-ID: <CAKywueQZ5hzogURY6sFiv2nJREY9h0KAvbBAsEoNcqApymtxKw@mail.gmail.com>
References: <1498673154-30879-1-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498673154-30879-1-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-06-28 11:05 GMT-07:00 Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>:
> From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>
> In cifs_call_async, server response may return as soon as I/O is submitted.
> Because mid entry is freed on the return path, do not modify it after I/O is
> submitted.
>
> Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> ---
>  fs/cifs/transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 47a125e..ba62aaf 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -537,10 +537,10 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
>         spin_unlock(&GlobalMid_Lock);
>
>
> +       cifs_save_when_sent(mid);
>         cifs_in_send_inc(server);
>         rc = smb_send_rqst(server, rqst, flags);
>         cifs_in_send_dec(server);
> -       cifs_save_when_sent(mid);
>
>         if (rc < 0) {
>                 server->sequence_number -= 2;
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks good. Could you please add an additional comment describing the
behavior in the code?

--
Best regards,
Pavel Shilovsky
