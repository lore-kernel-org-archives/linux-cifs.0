Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53801607A4;
	Tue,  5 Aug 2025 02:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754362414; cv=none; b=nrhYsY28db64LbajToR4agGPBbM3osAHuA54gX8wtkU3jCYYGLLAqujDHq94AWTroS9Z9q/Q6pof8XRn9lKoAKJ6XBFj4GpmZGdHwmH35mkJLgIwXZuvJzYoq8fD96pWr+AsgoZUPt6HwTwKgA7Xxo1w7h7tBAnnMlYJKh6k7bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754362414; c=relaxed/simple;
	bh=QipTbnbmJbXevkSIwo1Mx4o31Cq7mUkcYKgMQTWPLCQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fZ5U9jSWagDJXF/U6M37m9zgwgs3E13U5hQ+StCyYwrQ2ynsUKTSOPJ0EJRjynvo9kqBnd9TkQsRkXRRpvP6DpJ1yvCYpGsVJN2oFarfZw/nZVNI4o4JS+aTk4tE9SzGl7OUpTwmNad8vz6GWvchsutdgV95poAZ+nIKeqmBrhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZzhelpCE; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZzhelpCE"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-707453b0306so40149856d6.2;
        Mon, 04 Aug 2025 19:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754362411; x=1754967211; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gTBIYJDzpO1VP+KxSz7Ly2eNdEPOXZNrT/SgOAmUWdg=;
        b=ZzhelpCE4G29TUjtluqsuBWwLZ3lkKrVJXqFbf0KSoyQo9YPLdN3iSKU0WTKN3jQhg
         5Q7qGS4rA9zPD92VijJgN6aghu5qvLu4DDoAjA6QQck0FRYsvDN2YOVN3X+M+h4x7cXL
         8xY3w7ym6P4JgClTRSkytoOxY5W2EmwK4sb26vvZKWTl0DF5OeYFLsYXO1AAxQLcMzfW
         UcH3CMuNvVgJR3NJn9lPqoNfqvV55m0INIVSSjf4HOqsYJvjTs9sLSj3xZY0SMLAUkZO
         SSOGgEWO5D/7yEffyITA5hxnD4mc1ArkE39S8O5mLdxmMNzgctde8sThYT7Ooe6a6e5n
         QcRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754362411; x=1754967211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gTBIYJDzpO1VP+KxSz7Ly2eNdEPOXZNrT/SgOAmUWdg=;
        b=gcV/84524n/QMd8rtcU69/9ympXNwSUQXKY+OfVJ139cNOQLdpLDvrp4NKyWfDgr76
         6jhPaOv66Coi+OLUYIchnYIylIscSWeXGSCJ0BY3xZFyEMdMitfao+dnIz4GdXuBo9SI
         5cb9debyp9kwdITxqvg88fEjBm26r3uITKML0ZAhokA8/5knlYpk5y/G8vI1HI9hItvu
         4r28g4uL9/b8b4mc3C6Vx0NYFulVYIx4o0Gupqwa5ah/xVoKVi5Hopf/Gx2QGaiDCR1V
         Ar8JREtvDfrs9kRjk2elGnJS3Du0YdBEkxksRoUerdLVT8RFugNPMAsI++KojFktWW2T
         7Jaw==
X-Forwarded-Encrypted: i=1; AJvYcCVuRwnSDTdVICAhKeV7NT48I9gHpU/0FiaJBy2uLBXuFPgNnG1uNYYGOcwLMSzQCJzAobHDPA9hjijfpUPT@vger.kernel.org, AJvYcCXVgikaMknM11AXiZU9gcfJ16/gXz6U/oeypbM+rx8/ov5Or5oG+UY++AsinMF0EsdRWfgThf4hFIJ5@vger.kernel.org
X-Gm-Message-State: AOJu0YwCF51SMkCT7KlQ41eMAkJ42pggUQQ5m8QDHP+jEB/wLUvDijIX
	aSxUzOA3rCg1LUneds/fk0dNZbi7OcSdPUewHq3CKPxSyZthcxjTDvlTQaNOMsD2B5i8YWAwxeN
	SUq8a4GokzOGD93DuY1m72+Iul4IbOPw=
X-Gm-Gg: ASbGnct8DrwEJcqkGWUuJ04lMH4/z93UafwMyqfWaiPDqQltsB5gdMHPe5X9SFO9YWn
	x1+xwyLVd8KwtSfzlxspHH/R6MrklBQs1JdMKSY+4KGEbObtvTncmA+du/yDWxjJXov49vmigkE
	etnGHV+si7MwjmYnDFxN3LBjD1BwklzbKNBU0ry893aXOpGGWr8XDh4rocv3pjP4rzzwRxyVH2o
	VR/c0wDdRPhk7IWRpzScHY5UgMngbyHTOqzZl2z
X-Google-Smtp-Source: AGHT+IEHugcsIIdBbwAElP7Ou4nDpjVC71saUAuTwRXFjb4dSEDbeiXP/6AS/MYxCpBqS1qzATkjO+ZEsPvIvl6kgqw=
X-Received: by 2002:a05:6214:2626:b0:707:159e:d1c9 with SMTP id
 6a1803df08f44-7093637cd44mr155173246d6.51.1754362411168; Mon, 04 Aug 2025
 19:53:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250804134006.3609555-1-wangzhaolong@huaweicloud.com> <20250804134006.3609555-5-wangzhaolong@huaweicloud.com>
In-Reply-To: <20250804134006.3609555-5-wangzhaolong@huaweicloud.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 4 Aug 2025 21:53:19 -0500
X-Gm-Features: Ac12FXzdFQIPDLfcYV2sZ4kQPaMCxZ-H4qfax2f4AXCDAnpHju02B6lnQZAO_q8
Message-ID: <CAH2r5mu8bn_j98zuDoTOPnW3ShnDr+YFOkG7_Y5Frk=4eiixUA@mail.gmail.com>
Subject: Re: [PATCH 4/4] smb: client: fix mid_q_entry memleak leak with
 per-mid locking
To: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Cc: pshilov@microsoft.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	chengzhihao1@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

minor sparse warning when compiling this:

  CHECK   smb2ops.c
smb2ops.c: note: in included file:
cifsglob.h:1362:40: error: marked inline, but without a definition

On Mon, Aug 4, 2025 at 9:00=E2=80=AFAM Wang Zhaolong
<wangzhaolong@huaweicloud.com> wrote:
>
> This is step 4/4 of a patch series to fix mid_q_entry memory leaks
> caused by race conditions in callback execution.
>
> In compound_send_recv(), when wait_for_response() is interrupted by
> signals, the code attempts to cancel pending requests by changing
> their callbacks to cifs_cancelled_callback. However, there's a race
> condition between signal interruption and network response processing
> that causes both mid_q_entry and server buffer leaks:
>
> ```
> User foreground process                    cifsd
> cifs_readdir
>  open_cached_dir
>   cifs_send_recv
>    compound_send_recv
>     smb2_setup_request
>      smb2_mid_entry_alloc
>       smb2_get_mid_entry
>        smb2_mid_entry_alloc
>         mempool_alloc // alloc mid
>         kref_init(&temp->refcount); // refcount =3D 1
>      mid[0]->callback =3D cifs_compound_callback;
>      mid[1]->callback =3D cifs_compound_last_callback;
>      smb_send_rqst
>      rc =3D wait_for_response
>       wait_event_state TASK_KILLABLE
>                                   cifs_demultiplex_thread
>                                     allocate_buffers
>                                       server->bigbuf =3D cifs_buf_get()
>                                     standard_receive3
>                                       ->find_mid()
>                                         smb2_find_mid
>                                           __smb2_find_mid
>                                            kref_get(&mid->refcount) // +1
>                                       cifs_handle_standard
>                                         handle_mid
>                                          /* bigbuf will also leak */
>                                          mid->resp_buf =3D server->bigbuf
>                                          server->bigbuf =3D NULL;
>                                          dequeue_mid
>                                      /* in for loop */
>                                     mids[0]->callback
>                                       cifs_compound_callback
>     /* Signal interrupts wait: rc =3D -ERESTARTSYS */
>     /* if (... || midQ[i]->mid_state =3D=3D MID_RESPONSE_RECEIVED) *?
>     midQ[0]->callback =3D cifs_cancelled_callback;
>     cancelled_mid[i] =3D true;
>                                        /* The change comes too late */
>                                        mid->mid_state =3D MID_RESPONSE_RE=
ADY
>                                     release_mid  // -1
>     /* cancelled_mid[i] =3D=3D true causes mid won't be released
>        in compound_send_recv cleanup */
>     /* cifs_cancelled_callback won't executed to release mid */
> ```
>
> The callback assignment (mid->callback =3D cifs_cancelled_callback) and
> callback execution (mid->callback(mid)) are not atomic, allowing the
> network thread to execute the old callback even after cancellation.
>
> Solution:
> Add per-mid locking to ensure atomic callback execution:
>
> - Add spinlock_t mid_lock to struct mid_q_entry
> - Protect mid_state, callback, and related fields with mid_lock
> - Add mid_execute_callback() wrapper for safe callback execution
> - Use mid_lock in compound_send_recv() cancellation logic
>
> Key changes:
> - Initialize mid_lock in alloc_mid() and smb2_mid_entry_alloc()
> - Replace direct mid->callback() calls with mid_execute_callback()
> - Protect all mid state changes with appropriate locks
> - Update locking documentation
>
> This ensures that either the original callback or the cancellation
> callback executes atomically, preventing reference count leaks when
> requests are interrupted by signals.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D220404
> Fixes: ee258d79159a ("CIFS: Move credit processing to mid callbacks for S=
MB3")
> Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
> ---
>  fs/smb/client/cifs_debug.c    |  4 ++++
>  fs/smb/client/cifsglob.h      |  5 +++++
>  fs/smb/client/connect.c       | 22 ++++++++++++++++++----
>  fs/smb/client/smb1ops.c       |  6 ++++++
>  fs/smb/client/smb2ops.c       | 15 +++++++++------
>  fs/smb/client/smb2transport.c |  1 +
>  fs/smb/client/transport.c     | 29 ++++++++++++++++++-----------
>  7 files changed, 61 insertions(+), 21 deletions(-)
>
> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index 80d6a51b8c11..4708afc9106c 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -60,10 +60,11 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
>                 return;
>
>         cifs_dbg(VFS, "Dump pending requests:\n");
>         spin_lock(&server->mid_queue_lock);
>         list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
> +               spin_lock(&mid_entry->mid_lock);
>                 cifs_dbg(VFS, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %=
llu\n",
>                          mid_entry->mid_state,
>                          le16_to_cpu(mid_entry->command),
>                          mid_entry->pid,
>                          mid_entry->callback_data,
> @@ -80,10 +81,11 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
>                 if (mid_entry->resp_buf) {
>                         cifs_dump_detail(mid_entry->resp_buf, server);
>                         cifs_dump_mem("existing buf: ",
>                                 mid_entry->resp_buf, 62);
>                 }
> +               spin_unlock(&mid_entry->mid_lock);
>         }
>         spin_unlock(&server->mid_queue_lock);
>  #endif /* CONFIG_CIFS_DEBUG2 */
>  }
>
> @@ -672,16 +674,18 @@ static int cifs_debug_data_proc_show(struct seq_fil=
e *m, void *v)
>
>                                 seq_printf(m, "\n\tServer ConnectionId: 0=
x%llx",
>                                            chan_server->conn_id);
>                                 spin_lock(&chan_server->mid_queue_lock);
>                                 list_for_each_entry(mid_entry, &chan_serv=
er->pending_mid_q, qhead) {
> +                                       spin_lock(&mid_entry->mid_lock);
>                                         seq_printf(m, "\n\t\tState: %d co=
m: %d pid: %d cbdata: %p mid %llu",
>                                                    mid_entry->mid_state,
>                                                    le16_to_cpu(mid_entry-=
>command),
>                                                    mid_entry->pid,
>                                                    mid_entry->callback_da=
ta,
>                                                    mid_entry->mid);
> +                                       spin_unlock(&mid_entry->mid_lock)=
;
>                                 }
>                                 spin_unlock(&chan_server->mid_queue_lock)=
;
>                         }
>                         spin_unlock(&ses->chan_lock);
>                         seq_puts(m, "\n--\n");
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 536dff5b4a9c..430163a878d9 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1357,10 +1357,11 @@ struct tcon_link {
>         struct cifs_tcon        *tl_tcon;
>  };
>
>  extern struct tcon_link *cifs_sb_tlink(struct cifs_sb_info *cifs_sb);
>  extern void smb3_free_compound_rqst(int num_rqst, struct smb_rqst *rqst)=
;
> +extern inline void mid_execute_callback(struct mid_q_entry *mid);
>
>  static inline struct cifs_tcon *
>  tlink_tcon(struct tcon_link *tlink)
>  {
>         return tlink->tl_tcon;
> @@ -1730,10 +1731,11 @@ struct mid_q_entry {
>         unsigned int resp_buf_size;
>         int mid_state;  /* wish this were enum but can not pass to wait_e=
vent */
>         int mid_rc;             /* rc for MID_RC */
>         __le16 command;         /* smb command code */
>         unsigned int optype;    /* operation type */
> +       spinlock_t mid_lock;
>         bool wait_cancelled:1;  /* Cancelled while waiting for response *=
/
>         bool deleted_from_q:1;  /* Whether Mid has been dequeued frem pen=
ding_mid_q */
>         bool large_buf:1;       /* if valid response, is pointer to large=
 buf */
>         bool multiRsp:1;        /* multiple trans2 responses for one requ=
est  */
>         bool multiEnd:1;        /* both received */
> @@ -2034,10 +2036,13 @@ require use of the stronger protocol */
>   *                                                             init_cach=
ed_dir
>   * cifsFileInfo->fh_mutex      cifsFileInfo                    cifs_new_=
fileinfo
>   * cifsFileInfo->file_info_lock        cifsFileInfo->count             c=
ifs_new_fileinfo
>   *                             ->invalidHandle                 initiate_=
cifs_search
>   *                             ->oplock_break_cancelled
> + * mid_q_entry->mid_lock       mid_q_entry->mid_state          alloc_mid
> + *                             mid_q_entry->callback           smb2_mid_=
entry_alloc
> + *                             (Ensure that mid->callback is executed at=
omically)
>   ***********************************************************************=
*****/
>
>  #ifdef DECLARE_GLOBALS_HERE
>  #define GLOBAL_EXTERN
>  #else
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 587845a2452d..2d85554b8041 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -288,10 +288,18 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Se=
rver_Info *server,
>                 }
>         }
>         spin_unlock(&cifs_tcp_ses_lock);
>  }
>
> +inline void mid_execute_callback(struct mid_q_entry *mid)
> +{
> +       spin_lock(&mid->mid_lock);
> +       if (mid->callback)
> +               mid->callback(mid);
> +       spin_unlock(&mid->mid_lock);
> +}
> +
>  static void
>  cifs_abort_connection(struct TCP_Server_Info *server)
>  {
>         struct mid_q_entry *mid, *nmid;
>         struct list_head retry_list;
> @@ -322,22 +330,24 @@ cifs_abort_connection(struct TCP_Server_Info *serve=
r)
>         INIT_LIST_HEAD(&retry_list);
>         cifs_dbg(FYI, "%s: moving mids to private list\n", __func__);
>         spin_lock(&server->mid_queue_lock);
>         list_for_each_entry_safe(mid, nmid, &server->pending_mid_q, qhead=
) {
>                 kref_get(&mid->refcount);
> +               spin_lock(&mid->mid_lock);
>                 if (mid->mid_state =3D=3D MID_REQUEST_SUBMITTED)
>                         mid->mid_state =3D MID_RETRY_NEEDED;
> +               spin_unlock(&mid->mid_lock);
>                 list_move(&mid->qhead, &retry_list);
>                 mid->deleted_from_q =3D true;
>         }
>         spin_unlock(&server->mid_queue_lock);
>         cifs_server_unlock(server);
>
>         cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
>         list_for_each_entry_safe(mid, nmid, &retry_list, qhead) {
>                 list_del_init(&mid->qhead);
> -               mid->callback(mid);
> +               mid_execute_callback(mid);
>                 release_mid(mid);
>         }
>
>         if (cifs_rdma_enabled(server)) {
>                 cifs_server_lock(server);
> @@ -917,11 +927,11 @@ is_smb_response(struct TCP_Server_Info *server, uns=
igned char type)
>                          */
>                         list_for_each_entry_safe(mid, nmid, &dispose_list=
, qhead) {
>                                 list_del_init(&mid->qhead);
>                                 mid->mid_rc =3D mid_rc;
>                                 mid->mid_state =3D MID_RC;
> -                               mid->callback(mid);
> +                               mid_execute_callback(mid);
>                                 release_mid(mid);
>                         }
>
>                         /*
>                          * If reconnect failed then wait two seconds. In =
most
> @@ -956,14 +966,16 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed=
)
>  {
>  #ifdef CONFIG_CIFS_STATS2
>         mid->when_received =3D jiffies;
>  #endif
>         spin_lock(&mid->server->mid_queue_lock);
> +       spin_lock(&mid->mid_lock);
>         if (!malformed)
>                 mid->mid_state =3D MID_RESPONSE_RECEIVED;
>         else
>                 mid->mid_state =3D MID_RESPONSE_MALFORMED;
> +       spin_unlock(&mid->mid_lock);
>         /*
>          * Trying to handle/dequeue a mid after the send_recv()
>          * function has finished processing it is a bug.
>          */
>         if (mid->deleted_from_q =3D=3D true) {
> @@ -1104,22 +1116,24 @@ clean_demultiplex_info(struct TCP_Server_Info *se=
rver)
>                 spin_lock(&server->mid_queue_lock);
>                 list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
>                         mid_entry =3D list_entry(tmp, struct mid_q_entry,=
 qhead);
>                         cifs_dbg(FYI, "Clearing mid %llu\n", mid_entry->m=
id);
>                         kref_get(&mid_entry->refcount);
> +                       spin_lock(&mid_entry->mid_lock);
>                         mid_entry->mid_state =3D MID_SHUTDOWN;
> +                       spin_unlock(&mid_entry->mid_lock);
>                         list_move(&mid_entry->qhead, &dispose_list);
>                         mid_entry->deleted_from_q =3D true;
>                 }
>                 spin_unlock(&server->mid_queue_lock);
>
>                 /* now walk dispose list and issue callbacks */
>                 list_for_each_safe(tmp, tmp2, &dispose_list) {
>                         mid_entry =3D list_entry(tmp, struct mid_q_entry,=
 qhead);
>                         cifs_dbg(FYI, "Callback mid %llu\n", mid_entry->m=
id);
>                         list_del_init(&mid_entry->qhead);
> -                       mid_entry->callback(mid_entry);
> +                       mid_execute_callback(mid_entry);
>                         release_mid(mid_entry);
>                 }
>                 /* 1/8th of sec is more than enough time for them to exit=
 */
>                 msleep(125);
>         }
> @@ -1392,11 +1406,11 @@ cifs_demultiplex_thread(void *p)
>                                                                 "Share de=
leted. Reconnect needed");
>                                         }
>                                 }
>
>                                 if (!mids[i]->multiRsp || mids[i]->multiE=
nd)
> -                                       mids[i]->callback(mids[i]);
> +                                       mid_execute_callback(mids[i]);
>
>                                 release_mid(mids[i]);
>                         } else if (server->ops->is_oplock_break &&
>                                    server->ops->is_oplock_break(bufs[i],
>                                                                 server)) =
{
> diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> index 13f600a3d0c4..6a6b09cfcefa 100644
> --- a/fs/smb/client/smb1ops.c
> +++ b/fs/smb/client/smb1ops.c
> @@ -95,17 +95,20 @@ cifs_find_mid(struct TCP_Server_Info *server, char *b=
uffer)
>         struct smb_hdr *buf =3D (struct smb_hdr *)buffer;
>         struct mid_q_entry *mid;
>
>         spin_lock(&server->mid_queue_lock);
>         list_for_each_entry(mid, &server->pending_mid_q, qhead) {
> +               spin_lock(&mid->mid_lock);
>                 if (compare_mid(mid->mid, buf) &&
>                     mid->mid_state =3D=3D MID_REQUEST_SUBMITTED &&
>                     le16_to_cpu(mid->command) =3D=3D buf->Command) {
> +                       spin_unlock(&mid->mid_lock);
>                         kref_get(&mid->refcount);
>                         spin_unlock(&server->mid_queue_lock);
>                         return mid;
>                 }
> +               spin_unlock(&mid->mid_lock);
>         }
>         spin_unlock(&server->mid_queue_lock);
>         return NULL;
>  }
>
> @@ -198,16 +201,19 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
>
>                 num_mids =3D 0;
>                 spin_lock(&server->mid_queue_lock);
>                 list_for_each_entry(mid_entry, &server->pending_mid_q, qh=
ead) {
>                         ++num_mids;
> +                       spin_lock(&mid_entry->mid_lock);
>                         if (mid_entry->mid =3D=3D cur_mid &&
>                             mid_entry->mid_state =3D=3D MID_REQUEST_SUBMI=
TTED) {
> +                               spin_unlock(&mid_entry->mid_lock);
>                                 /* This mid is in use, try a different on=
e */
>                                 collision =3D true;
>                                 break;
>                         }
> +                       spin_unlock(&mid_entry->mid_lock);
>                 }
>                 spin_unlock(&server->mid_queue_lock);
>
>                 /*
>                  * if we have more than 32k mids in the list, then someth=
ing
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 2643d86a5b5f..14c572e04894 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -4803,27 +4803,30 @@ static void smb2_decrypt_offload(struct work_stru=
ct *work)
>  #endif
>                         if (dw->server->ops->is_network_name_deleted)
>                                 dw->server->ops->is_network_name_deleted(=
dw->buf,
>                                                                          =
dw->server);
>
> -                       mid->callback(mid);
> +                       mid_execute_callback(mid);
>                 } else {
>                         spin_lock(&dw->server->srv_lock);
>                         if (dw->server->tcpStatus =3D=3D CifsNeedReconnec=
t) {
> -                               spin_lock(&dw->server->mid_queue_lock);
> -                               mid->mid_state =3D MID_RETRY_NEEDED;
> -                               spin_unlock(&dw->server->mid_queue_lock);
>                                 spin_unlock(&dw->server->srv_lock);
> -                               mid->callback(mid);
> +                               spin_lock(&mid->mid_lock);
> +                               mid->mid_state =3D MID_RETRY_NEEDED;
> +                               if (mid->callback)
> +                                       mid->callback(mid);
> +                               spin_unlock(&mid->mid_lock);
>                         } else {
> +                               spin_unlock(&dw->server->srv_lock);
>                                 spin_lock(&dw->server->mid_queue_lock);
> +                               spin_lock(&mid->mid_lock);
>                                 mid->mid_state =3D MID_REQUEST_SUBMITTED;
> +                               spin_unlock(&mid->mid_lock);
>                                 mid->deleted_from_q =3D false;
>                                 list_add_tail(&mid->qhead,
>                                         &dw->server->pending_mid_q);
>                                 spin_unlock(&dw->server->mid_queue_lock);
> -                               spin_unlock(&dw->server->srv_lock);
>                         }
>                 }
>                 release_mid(mid);
>         }
>
> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.=
c
> index ff9ef7fcd010..bc0e92eb2b64 100644
> --- a/fs/smb/client/smb2transport.c
> +++ b/fs/smb/client/smb2transport.c
> @@ -769,10 +769,11 @@ smb2_mid_entry_alloc(const struct smb2_hdr *shdr,
>         }
>
>         temp =3D mempool_alloc(cifs_mid_poolp, GFP_NOFS);
>         memset(temp, 0, sizeof(struct mid_q_entry));
>         kref_init(&temp->refcount);
> +       spin_lock_init(&temp->mid_lock);
>         temp->mid =3D le64_to_cpu(shdr->MessageId);
>         temp->credits =3D credits > 0 ? credits : 1;
>         temp->pid =3D current->pid;
>         temp->command =3D shdr->Command; /* Always LE */
>         temp->when_alloc =3D jiffies;
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index ca9358c24ceb..8bbcecf2225d 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -52,10 +52,11 @@ alloc_mid(const struct smb_hdr *smb_buffer, struct TC=
P_Server_Info *server)
>         }
>
>         temp =3D mempool_alloc(cifs_mid_poolp, GFP_NOFS);
>         memset(temp, 0, sizeof(struct mid_q_entry));
>         kref_init(&temp->refcount);
> +       spin_lock_init(&temp->mid_lock);
>         temp->mid =3D get_mid(smb_buffer);
>         temp->pid =3D current->pid;
>         temp->command =3D cpu_to_le16(smb_buffer->Command);
>         cifs_dbg(FYI, "For smb_command %d\n", smb_buffer->Command);
>         /* easier to use jiffies */
> @@ -875,17 +876,17 @@ SendReceiveNoRsp(const unsigned int xid, struct cif=
s_ses *ses,
>  static int
>  cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *se=
rver)
>  {
>         int rc =3D 0;
>
> +       spin_lock(&mid->mid_lock);
>         cifs_dbg(FYI, "%s: cmd=3D%d mid=3D%llu state=3D%d\n",
>                  __func__, le16_to_cpu(mid->command), mid->mid, mid->mid_=
state);
>
> -       spin_lock(&server->mid_queue_lock);
>         switch (mid->mid_state) {
>         case MID_RESPONSE_READY:
> -               spin_unlock(&server->mid_queue_lock);
> +               spin_unlock(&mid->mid_lock);
>                 return rc;
>         case MID_RETRY_NEEDED:
>                 rc =3D -EAGAIN;
>                 break;
>         case MID_RESPONSE_MALFORMED:
> @@ -896,21 +897,25 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struc=
t TCP_Server_Info *server)
>                 break;
>         case MID_RC:
>                 rc =3D mid->mid_rc;
>                 break;
>         default:
> +               cifs_server_dbg(VFS, "%s: invalid mid state mid=3D%llu st=
ate=3D%d\n",
> +                        __func__, mid->mid, mid->mid_state);
> +               spin_unlock(&mid->mid_lock);
> +
> +               spin_lock(&server->mid_queue_lock);
>                 if (mid->deleted_from_q =3D=3D false) {
>                         list_del_init(&mid->qhead);
>                         mid->deleted_from_q =3D true;
>                 }
>                 spin_unlock(&server->mid_queue_lock);
> -               cifs_server_dbg(VFS, "%s: invalid mid state mid=3D%llu st=
ate=3D%d\n",
> -                        __func__, mid->mid, mid->mid_state);
> +
>                 rc =3D -EIO;
>                 goto sync_mid_done;
>         }
> -       spin_unlock(&server->mid_queue_lock);
> +       spin_unlock(&mid->mid_lock);
>
>  sync_mid_done:
>         release_mid(mid);
>         return rc;
>  }
> @@ -1212,17 +1217,19 @@ compound_send_recv(const unsigned int xid, struct=
 cifs_ses *ses,
>                 for (; i < num_rqst; i++) {
>                         cifs_server_dbg(FYI, "Cancelling wait for mid %ll=
u cmd: %d\n",
>                                  midQ[i]->mid, le16_to_cpu(midQ[i]->comma=
nd));
>                         send_cancel(server, &rqst[i], midQ[i]);
>                         spin_lock(&server->mid_queue_lock);
> +                       spin_lock(&midQ[i]->mid_lock);
>                         midQ[i]->wait_cancelled =3D true;
>                         if (midQ[i]->mid_state =3D=3D MID_REQUEST_SUBMITT=
ED ||
>                             midQ[i]->mid_state =3D=3D MID_RESPONSE_RECEIV=
ED) {
>                                 midQ[i]->callback =3D cifs_cancelled_call=
back;
>                                 cancelled_mid[i] =3D true;
>                                 credits[i].value =3D 0;
>                         }
> +                       spin_unlock(&midQ[i]->mid_lock);
>                         spin_unlock(&server->mid_queue_lock);
>                 }
>         }
>
>         for (i =3D 0; i < num_rqst; i++) {
> @@ -1421,20 +1428,20 @@ SendReceive(const unsigned int xid, struct cifs_s=
es *ses,
>                 goto out;
>
>         rc =3D wait_for_response(server, midQ);
>         if (rc !=3D 0) {
>                 send_cancel(server, &rqst, midQ);
> -               spin_lock(&server->mid_queue_lock);
> +               spin_lock(&midQ->mid_lock);
>                 if (midQ->mid_state =3D=3D MID_REQUEST_SUBMITTED ||
>                     midQ->mid_state =3D=3D MID_RESPONSE_RECEIVED) {
>                         /* no longer considered to be "in-flight" */
>                         midQ->callback =3D release_mid;
> -                       spin_unlock(&server->mid_queue_lock);
> +                       spin_unlock(&midQ->mid_lock);
>                         add_credits(server, &credits, 0);
>                         return rc;
>                 }
> -               spin_unlock(&server->mid_queue_lock);
> +               spin_unlock(&midQ->mid_lock);
>         }
>
>         rc =3D cifs_sync_mid_result(midQ, server);
>         if (rc !=3D 0) {
>                 add_credits(server, &credits, 0);
> @@ -1603,19 +1610,19 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
>                 }
>
>                 rc =3D wait_for_response(server, midQ);
>                 if (rc) {
>                         send_cancel(server, &rqst, midQ);
> -                       spin_lock(&server->mid_queue_lock);
> +                       spin_lock(&midQ->mid_lock);
>                         if (midQ->mid_state =3D=3D MID_REQUEST_SUBMITTED =
||
>                             midQ->mid_state =3D=3D MID_RESPONSE_RECEIVED)=
 {
>                                 /* no longer considered to be "in-flight"=
 */
>                                 midQ->callback =3D release_mid;
> -                               spin_unlock(&server->mid_queue_lock);
> +                               spin_unlock(&midQ->mid_lock);
>                                 return rc;
>                         }
> -                       spin_unlock(&server->mid_queue_lock);
> +                       spin_unlock(&midQ->mid_lock);
>                 }
>
>                 /* We got the response - restart system call. */
>                 rstart =3D 1;
>                 spin_lock(&server->srv_lock);
> --
> 2.39.2
>
>


--=20
Thanks,

Steve
