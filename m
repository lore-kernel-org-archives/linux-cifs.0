From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Handle mismatched open calls
Date: Fri, 17 Feb 2017 12:31:23 -0800
Message-ID: <CAKywueQH_WCjECFsff+c7eUtXq56bCaU6D5OcxNjhzXVqjWp_Q@mail.gmail.com>
References: <20170217112522.12742-1-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170217112522.12742-1-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-02-17 3:25 GMT-08:00 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> A signal can interrupt a SendReceive call which result in incoming
> responses to the call being ignored. This is a problem for calls such as
> open which results in the successful response being ignored. This
> results in an open file resource on the server.
>
> The patch looks into responses which were cancelled after being sent and
> in case of successful open closes the open fids.
>
> For this patch, the check is only done in SendReceive2()
>
> RH-bz: 1403319
>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h      | 11 +++++++++++
>  fs/cifs/connect.c       |  9 +++++++--
>  fs/cifs/smb2misc.c      | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/smb2ops.c       |  4 ++++
>  fs/cifs/smb2proto.h     |  6 ++++++
>  fs/cifs/smb2transport.c | 26 ++++++++++++++++++++++++-
>  fs/cifs/transport.c     |  3 +++
>  7 files changed, 107 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 7ea8a33..cc97d73 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -241,6 +241,7 @@ struct smb_version_operations {
>         /* verify the message */
>         int (*check_message)(char *, unsigned int, struct TCP_Server_Info *);
>         bool (*is_oplock_break)(char *, struct TCP_Server_Info *);
> +       int (*handle_cancelled_mid)(char *, struct TCP_Server_Info *);
>         void (*downgrade_oplock)(struct TCP_Server_Info *,
>                                         struct cifsInodeInfo *, bool);
>         /* process transaction2 response */
> @@ -1319,12 +1320,19 @@ struct mid_q_entry {
>         void *callback_data;      /* general purpose pointer for callback */
>         void *resp_buf;         /* pointer to received SMB header */
>         int mid_state;  /* wish this were enum but can not pass to wait_event */
> +       unsigned int mid_flags;
>         __le16 command;         /* smb command code */
>         bool large_buf:1;       /* if valid response, is pointer to large buf */
>         bool multiRsp:1;        /* multiple trans2 responses for one request  */
>         bool multiEnd:1;        /* both received */
>  };
>
> +struct close_cancelled_open {
> +       struct cifs_fid         fid;
> +       struct cifs_tcon        *tcon;
> +       struct work_struct      work;
> +};
> +
>  /*     Make code in transport.c a little cleaner by moving
>         update of optional stats into function below */
>  #ifdef CONFIG_CIFS_STATS2
> @@ -1456,6 +1464,9 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
>  #define   MID_RESPONSE_MALFORMED 0x10
>  #define   MID_SHUTDOWN          0x20
>
> +/* Flags */
> +#define   MID_WAIT_CANCELLED    1 /* Cancelled while waiting for response */
> +
>  /* Types of response buffer returned from SendReceive2 */
>  #define   CIFS_NO_BUFFER        0    /* Response buffer not returned */
>  #define   CIFS_SMALL_BUFFER     1
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 35ae49e..95bd14d 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -887,10 +887,15 @@ cifs_demultiplex_thread(void *p)
>
>                 server->lstrp = jiffies;
>                 if (mid_entry != NULL) {
> +                       if ((mid_entry->mid_flags & MID_WAIT_CANCELLED) &&
> +                                       (server->ops->handle_cancelled_mid))
> +                               server->ops->handle_cancelled_mid(buf, server);
>                         if (!mid_entry->multiRsp || mid_entry->multiEnd)
>                                 mid_entry->callback(mid_entry);
> -               } else if (!server->ops->is_oplock_break ||
> -                          !server->ops->is_oplock_break(buf, server)) {
> +               } else if (server->ops->is_oplock_break &&
> +                          server->ops->is_oplock_break(buf, server)) {
> +                       cifs_dbg(FYI, "Received oplock break\n");
> +               } else {
>                         cifs_dbg(VFS, "No task to wake, unknown frame received! NumMids %d\n",
>                                  atomic_read(&midCount));
>                         cifs_dump_mem("Received Data is: ", buf,
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 3d38348..d3d550a 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -654,3 +654,54 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
>         cifs_dbg(FYI, "Can not process oplock break for non-existent connection\n");
>         return false;
>  }
> +
> +void
> +smb2_cancelled_close_fid(struct work_struct *work)
> +{
> +       struct close_cancelled_open *cancelled = container_of(work,
> +                                       struct close_cancelled_open, work);
> +
> +       cifs_dbg(VFS, "Close unmatched open\n");
> +
> +       SMB2_close(0, cancelled->tcon, cancelled->fid.persistent_fid,
> +                                          cancelled->fid.volatile_fid);
> +       cifs_put_tcon(cancelled->tcon);
> +       kfree(cancelled);
> +}
> +
> +int
> +smb2_handle_cancelled_mid(char *buffer, struct TCP_Server_Info *server)
> +{
> +       struct smb2_create_rsp *rsp = (struct smb2_create_rsp *)buffer;
> +       struct cifs_ses *ses;
> +       struct cifs_tcon *tcon;
> +       struct close_cancelled_open *cancelled;
> +
> +       if ((rsp->hdr.Command != SMB2_CREATE) ||
> +               (rsp->hdr.Status != STATUS_SUCCESS))
> +               return 0;
> +
> +       ses = smb2_find_smb_ses((struct smb2_hdr *)rsp, server);
> +       if (!ses)
> +               return -ENOENT;

ses obtained here can be freed before the next call since we are not
holding a reference. It works for the existing callers of
smb2_find_smb_ses() because their upper callers already holds a
reference to one of tcons although it is no so clear from the code.

One option here is to obtain a ref in smb2_find_smb_ses() and fix the
existing callers to put this ref after use. This will result in
putting possibly the last ref of tcp session in the middle of
demultiplex loop. Another option is to obtain a tcon ref with a single
locking of the spinlock and walking through ses and tcon lists in one
call. The latter might be cleaner for the bugfix since it doesn't
increase complexity of ref dependencies in the code.

> +
> +       tcon = smb2_find_smb_tcon(ses, rsp->hdr.TreeId);
> +       if (!tcon)
> +               return -ENOENT;
> +
> +       cancelled = (struct close_cancelled_open *)
> +                       kzalloc(sizeof(struct close_cancelled_open),
> +                               GFP_KERNEL);
> +       if (!cancelled) {
> +               cifs_put_tcon(tcon);
> +               return -ENOMEM;
> +       }



-- 
Best regards,
Pavel Shilovsky
