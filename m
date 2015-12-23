From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix race between call_async() and reconnect()
Date: Wed, 23 Dec 2015 09:21:31 -0600
Message-ID: <CADT32eL9JHxq-xNQgtgeLgFm9HNKGX32uSH2cVnhrA0bi4uZ8g@mail.gmail.com>
References: <1450852361-26556-1-git-send-email-rabin.vincent@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rabin-66gdRtMMWGc@public.gmane.org,
	Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
To: Rabin Vincent <rabin.vincent-VrBV9hrLPhE@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450852361-26556-1-git-send-email-rabin.vincent-VrBV9hrLPhE@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks correct. I think only cifs_call_async() is where
DeletedMidQEntry() is called without holding srv_mutex lock.

Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Dec 23, 2015 at 12:32 AM, Rabin Vincent <rabin.vincent-VrBV9hrLPhE@public.gmane.org> wrote:
> cifs_call_async() queues the MID to the pending list and calls
> smb_send_rqst().  If smb_send_rqst() performs a partial send, it sets
> the tcpStatus to CifsNeedReconnect and returns an error code to
> cifs_call_async().  In this case, cifs_call_async() removes the MID
> from the list and returns to the caller.
>
> However, cifs_call_async() releases the server mutex _before_ removing
> the MID.  This means that a cifs_reconnect() can race with this function
> and manage to remove the MID from the list and delete the entry before
> cifs_call_async() calls cifs_delete_mid().  This leads to various
> crashes due to the use after free in cifs_delete_mid().
>
> Task1                           Task2
>
> cifs_call_async():
>  - rc = -EAGAIN
>  - mutex_unlock(srv_mutex)
>
>                                 cifs_reconnect():
>                                  - mutex_lock(srv_mutex)
>                                  - mutex_unlock(srv_mutex)
>                                  - list_delete(mid)
>                                  - mid->callback()
>                                         cifs_writev_callback():
>                                                 - mutex_lock(srv_mutex)
>                                                 - delete(mid)
>                                                 - mutex_unlock(srv_mutex)
>
>  - cifs_delete_mid(mid) <---- use after free
>
> Fix this by removing the MID in cifs_call_async() before releasing the
> srv_mutex.  Also hold the srv_mutex in cifs_reconnect() until the MIDs
> are moved out of the pending list.
>
> Signed-off-by: Rabin Vincent <rabin.vincent-VrBV9hrLPhE@public.gmane.org>
> ---
>  fs/cifs/connect.c   |    2 +-
>  fs/cifs/transport.c |    6 ++++--
>  2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index ecb0803..3c194ff 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -368,7 +368,6 @@ cifs_reconnect(struct TCP_Server_Info *server)
>         server->session_key.response = NULL;
>         server->session_key.len = 0;
>         server->lstrp = jiffies;
> -       mutex_unlock(&server->srv_mutex);
>
>         /* mark submitted MIDs for retry and issue callback */
>         INIT_LIST_HEAD(&retry_list);
> @@ -381,6 +380,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>                 list_move(&mid_entry->qhead, &retry_list);
>         }
>         spin_unlock(&GlobalMid_Lock);
> +       mutex_unlock(&server->srv_mutex);
>
>         cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
>         list_for_each_safe(tmp, tmp2, &retry_list) {
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 2a24c52..87abe8e 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -576,14 +576,16 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
>         cifs_in_send_dec(server);
>         cifs_save_when_sent(mid);
>
> -       if (rc < 0)
> +       if (rc < 0) {
>                 server->sequence_number -= 2;
> +               cifs_delete_mid(mid);
> +       }
> +
>         mutex_unlock(&server->srv_mutex);
>
>         if (rc == 0)
>                 return 0;
>
> -       cifs_delete_mid(mid);
>         add_credits_and_wake_if(server, credits, optype);
>         return rc;
>  }
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
