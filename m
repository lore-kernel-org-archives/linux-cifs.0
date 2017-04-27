From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: don't check for failure from mempool_alloc()
Date: Thu, 27 Apr 2017 15:08:23 -0500
Message-ID: <CAH2r5ms-aS6WCkY2NVvh6g87tAWjZTmjpOZN1roGEYqWa87qtA@mail.gmail.com>
References: <87h91xxbd6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: NeilBrown <neilb-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87h91xxbd6.fsf-wvvUuzkyo1HefUI2i7LXDhCRmIWqnp/j@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Sun, Apr 9, 2017 at 9:08 PM, NeilBrown <neilb-IBi9RG/b67k@public.gmane.org> wrote:
>
> mempool_alloc() cannot fail if the gfp flags allow it to
> sleep, and both GFP_FS allows for sleeping.
>
> So these tests of the return value from mempool_alloc()
> cannot be needed.
>
> Signed-off-by: NeilBrown <neilb-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/misc.c          | 14 +++++---------
>  fs/cifs/smb2transport.c | 30 +++++++++++++-----------------
>  fs/cifs/transport.c     | 32 ++++++++++++++------------------
>  3 files changed, 32 insertions(+), 44 deletions(-)
>
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index d3fb11529ed9..843787850435 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -167,13 +167,11 @@ cifs_buf_get(void)
>
>         /* clear the first few header bytes */
>         /* for most paths, more is cleared in header_assemble */
> -       if (ret_buf) {
> -               memset(ret_buf, 0, buf_size + 3);
> -               atomic_inc(&bufAllocCount);
> +       memset(ret_buf, 0, buf_size + 3);
> +       atomic_inc(&bufAllocCount);
>  #ifdef CONFIG_CIFS_STATS2
> -               atomic_inc(&totBufAllocCount);
> +       atomic_inc(&totBufAllocCount);
>  #endif /* CONFIG_CIFS_STATS2 */
> -       }
>
>         return ret_buf;
>  }
> @@ -201,15 +199,13 @@ cifs_small_buf_get(void)
>     albeit slightly larger than necessary and maxbuffersize
>     defaults to this and can not be bigger */
>         ret_buf = mempool_alloc(cifs_sm_req_poolp, GFP_NOFS);
> -       if (ret_buf) {
>         /* No need to clear memory here, cleared in header assemble */
>         /*      memset(ret_buf, 0, sizeof(struct smb_hdr) + 27);*/
> -               atomic_inc(&smBufAllocCount);
> +       atomic_inc(&smBufAllocCount);
>  #ifdef CONFIG_CIFS_STATS2
> -               atomic_inc(&totSmBufAllocCount);
> +       atomic_inc(&totSmBufAllocCount);
>  #endif /* CONFIG_CIFS_STATS2 */
>
> -       }
>         return ret_buf;
>  }
>
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 506b67fc93d9..c69ec96e92ac 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -538,23 +538,19 @@ smb2_mid_entry_alloc(const struct smb2_sync_hdr *shdr,
>         }
>
>         temp = mempool_alloc(cifs_mid_poolp, GFP_NOFS);
> -       if (temp == NULL)
> -               return temp;
> -       else {
> -               memset(temp, 0, sizeof(struct mid_q_entry));
> -               temp->mid = le64_to_cpu(shdr->MessageId);
> -               temp->pid = current->pid;
> -               temp->command = shdr->Command; /* Always LE */
> -               temp->when_alloc = jiffies;
> -               temp->server = server;
> -
> -               /*
> -                * The default is for the mid to be synchronous, so the
> -                * default callback just wakes up the current task.
> -                */
> -               temp->callback = cifs_wake_up_task;
> -               temp->callback_data = current;
> -       }
> +       memset(temp, 0, sizeof(struct mid_q_entry));
> +       temp->mid = le64_to_cpu(shdr->MessageId);
> +       temp->pid = current->pid;
> +       temp->command = shdr->Command; /* Always LE */
> +       temp->when_alloc = jiffies;
> +       temp->server = server;
> +
> +       /*
> +        * The default is for the mid to be synchronous, so the
> +        * default callback just wakes up the current task.
> +        */
> +       temp->callback = cifs_wake_up_task;
> +       temp->callback_data = current;
>
>         atomic_inc(&midCount);
>         temp->mid_state = MID_REQUEST_ALLOCATED;
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index f6e13a977fc8..4d64b5b8fc9c 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -55,26 +55,22 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
>         }
>
>         temp = mempool_alloc(cifs_mid_poolp, GFP_NOFS);
> -       if (temp == NULL)
> -               return temp;
> -       else {
> -               memset(temp, 0, sizeof(struct mid_q_entry));
> -               temp->mid = get_mid(smb_buffer);
> -               temp->pid = current->pid;
> -               temp->command = cpu_to_le16(smb_buffer->Command);
> -               cifs_dbg(FYI, "For smb_command %d\n", smb_buffer->Command);
> +       memset(temp, 0, sizeof(struct mid_q_entry));
> +       temp->mid = get_mid(smb_buffer);
> +       temp->pid = current->pid;
> +       temp->command = cpu_to_le16(smb_buffer->Command);
> +       cifs_dbg(FYI, "For smb_command %d\n", smb_buffer->Command);
>         /*      do_gettimeofday(&temp->when_sent);*/ /* easier to use jiffies */
> -               /* when mid allocated can be before when sent */
> -               temp->when_alloc = jiffies;
> -               temp->server = server;
> +       /* when mid allocated can be before when sent */
> +       temp->when_alloc = jiffies;
> +       temp->server = server;
>
> -               /*
> -                * The default is for the mid to be synchronous, so the
> -                * default callback just wakes up the current task.
> -                */
> -               temp->callback = cifs_wake_up_task;
> -               temp->callback_data = current;
> -       }
> +       /*
> +        * The default is for the mid to be synchronous, so the
> +        * default callback just wakes up the current task.
> +        */
> +       temp->callback = cifs_wake_up_task;
> +       temp->callback_data = current;
>
>         atomic_inc(&midCount);
>         temp->mid_state = MID_REQUEST_ALLOCATED;
> --
> 2.12.2
>



-- 
Thanks,

Steve
