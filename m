From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix a possible memory corruption during reconnect
Date: Mon, 28 Nov 2016 11:47:54 -0800
Message-ID: <CAKywueS4ckMTOu3PcCiiMcZm=-qmOn+xxfNA55xYwJeDGQiO8Q@mail.gmail.com>
References: <1478740076-60526-1-git-send-email-pshilov@microsoft.com> <1479988233.9782.9.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479988233.9782.9.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2016-11-24 3:50 GMT-08:00 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Wed, 2016-11-09 at 17:07 -0800, Pavel Shilovsky wrote:
>> We can not unlock/lock spinlock in the middle of the reconnect
>> loop since it can corrupt list iterator pointers and a tcon
>> structure can be released if we don't hold an extra reference.
>> Fix it by moving a reconnect process to a separate delayed work
>> and acquiring a reference to every tcon that needs to be reconnected.
>> Also do not send an echo request on newly established connections.
>>
>> CC: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>> Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>> ---
>>  fs/cifs/cifsglob.h  |  3 +++
>>  fs/cifs/cifsproto.h |  3 +++
>>  fs/cifs/connect.c   | 32 ++++++++++++++++++-----
>>  fs/cifs/smb2pdu.c   | 74 ++++++++++++++++++++++++++++++++++++-------
>> ----------
>>  fs/cifs/smb2proto.h |  1 +
>>  5 files changed, 82 insertions(+), 31 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 1f17f6b..6dcefc8 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -632,6 +632,7 @@ struct TCP_Server_Info {
>>       bool    sec_mskerberos;         /* supports
>> legacy MS Kerberos */
>>       bool    large_buf;              /* is current buffer
>> large? */
>>       struct delayed_work     echo; /* echo ping workqueue job
>> */
>> +     struct delayed_work     reconnect; /* reconnect workqueue
>> job */
>>       char    *smallbuf;      /* pointer to current "small"
>> buffer */
>>       char    *bigbuf;        /* pointer to current "big"
>> buffer */
>>       unsigned int total_read; /* total amount of data read in
>> this pass */
>> @@ -648,6 +649,7 @@ struct TCP_Server_Info {
>>       __u8            preauth_hash[512];
>>  #endif /* CONFIG_CIFS_SMB2 */
>>       unsigned long echo_interval;
>> +     struct mutex reconnect_mutex; /* prevent simultaneous
>> reconnects */
>>  };
>>
>>  static inline unsigned int
>> @@ -850,6 +852,7 @@ struct cifs_tcon {
>>       struct list_head tcon_list;
>>       int tc_count;
>>       struct list_head openFileList;
>> +     struct list_head rlist; /* reconnect list */
>>       spinlock_t open_file_lock; /* protects list above */
>>       struct cifs_ses *ses;   /* pointer to session
>> associated with */
>>       char treeName[MAX_TREE_SIZE + 1]; /* UNC name of resource in
>> ASCII */
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index ced0e42..cd8025a 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -206,6 +206,9 @@ extern void cifs_add_pending_open_locked(struct
>> cifs_fid *fid,
>>                                        struct tcon_link *tlink,
>>                                        struct cifs_pending_open
>> *open);
>>  extern void cifs_del_pending_open(struct cifs_pending_open *open);
>> +extern void cifs_put_tcp_session(struct TCP_Server_Info *server,
>> +                              int from_reconnect);
>> +extern void cifs_put_tcon(struct cifs_tcon *tcon);
>>
>>  #if IS_ENABLED(CONFIG_CIFS_DFS_UPCALL)
>>  extern void cifs_dfs_release_automount_timer(void);
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 4547aed..69452f7 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -52,6 +52,9 @@
>>  #include "nterr.h"
>>  #include "rfc1002pdu.h"
>>  #include "fscache.h"
>> +#ifdef CONFIG_CIFS_SMB2
>> +#include "smb2proto.h"
>> +#endif
>>
>>  #define CIFS_PORT 445
>>  #define RFC1001_PORT 139
>> @@ -2100,8 +2103,8 @@ cifs_find_tcp_session(struct smb_vol *vol)
>>       return NULL;
>>  }
>>
>> -static void
>> -cifs_put_tcp_session(struct TCP_Server_Info *server)
>> +void
>> +cifs_put_tcp_session(struct TCP_Server_Info *server, int
>> from_reconnect)
>>  {
>>       struct task_struct *task;
>>
>> @@ -2118,6 +2121,17 @@ cifs_put_tcp_session(struct TCP_Server_Info
>> *server)
>>
>>       cancel_delayed_work_sync(&server->echo);
>>
>> +     if (from_reconnect)
>> +             /*
>> +              * Avoid deadlock here: reconnect work calls
>> +              * cifs_put_tcp_session() at its end. Need to be
>> sure
>> +              * that reconnect work does nothing with server
>> pointer after
>> +              * that step.
>> +              */
>> +             cancel_delayed_work(&server->reconnect);
>> +     else
>> +             cancel_delayed_work_sync(&server->reconnect);
>> +
>
> Hello Pavel,
>
> I don't understand this part. Can you please explain this part.


Hello Sachin,

In smb2_reconnect_server() we grabbed a reference to a server struct
if any sessions/tcons (other references) exist to prevent
cifs_put_tcon() releasing of a server pointer. At the end of the work
functon we need to put the obtained reference but it can be the last
one that will trigger releasing of the server pointer and calling
cifs_put_tcp_session().

In the latter function we are trying to cancel delayed work (which we
currently in), so cancel_delayed_work_sync() will be waiting
forever.That's why "from_reconnect" argument was introduced to call
non-blocking cancel_delayed_work() rather than blocking
cancel_delayed_work_sync().

-- 
Best regards,
Pavel Shilovsky
