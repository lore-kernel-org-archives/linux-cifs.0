From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 6/7] CIFS: Optimize cifs_user_read() in a short read case
 on reconnects
Date: Fri, 11 Jul 2014 13:47:28 +0400
Message-ID: <CAKywueTc6b21zCf+Df5tF2KfkLVFVca9xdYwMHk9J+X6SEdJEg@mail.gmail.com>
References: <1404984647-8710-1-git-send-email-pshilovsky@samba.org>
	<1404984647-8710-7-git-send-email-pshilovsky@samba.org>
	<CAKywueT4sVFiQ8sgEDEVDEteC2BY7AejWgYoeJhSO71pE=mM2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueT4sVFiQ8sgEDEVDEteC2BY7AejWgYoeJhSO71pE=mM2w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-07-10 13:40 GMT+04:00 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> 2014-07-10 13:30 GMT+04:00 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> by filling the output buffer with a data got from a partially received
>> response and requesting the remaining data from the server.
>>
>> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> ---
>>  fs/cifs/file.c | 23 ++++++++++++++++++++---
>>  1 file changed, 20 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 6896cb5..d7246cb 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -3029,13 +3029,30 @@ again:
>>                         else if (rdata->result == -EAGAIN) {
>>                                 /* resend call if it's a retryable error */
>>                                 struct list_head tmp_list;
>> +                               unsigned int got_bytes = rdata->got_bytes;
>>
>>                                 list_del_init(&rdata->list);
>>                                 INIT_LIST_HEAD(&tmp_list);
>>
>> -                               rc = cifs_send_async_read(rdata->offset,
>> -                                               rdata->bytes, rdata->cfile,
>> -                                               cifs_sb, &tmp_list);
>> +                               /*
>> +                                * Got a part of data and then reconnect has
>> +                                * happened -- discard anything left and return
>> +                                * a short read.
>> +                                */
>                                      ^^^
> Ah, wrong version of the comment is posted. Sorry. The right one:
> +                               /*
> +                                * Got a part of data and then reconnect has
> +                                * happened -- fill the buffer and continue
> +                                * reading.
> +                                */
>
> will repost this after a feedback.
>
>> +                               if (got_bytes && got_bytes < rdata->bytes) {
>> +                                       rc = cifs_readdata_to_iov(rdata, to);
>> +                                       if (rc) {
>> +                                               kref_put(&rdata->refcount,
>> +                                               cifs_uncached_readdata_release);
>> +                                               continue;
>> +                                       }
>> +                               }
>> +
>> +                               rc = cifs_send_async_read(
>> +                                               rdata->offset + got_bytes,
>> +                                               rdata->bytes - got_bytes,
>> +                                               rdata->cfile, cifs_sb,
>> +                                               &tmp_list);
>>
>>                                 list_splice(&tmp_list, &rdata_list);
>>

Also realized that the patch doesn't aware about signed connections
and doesn't take into account that we should update stats in "EAGAIN
&& got_bytes" case. So, this diff should be appended to the patch as
well:

---

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 9f13b62..7d4361f 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1561,6 +1561,12 @@ cifs_readv_callback(struct mid_q_entry *mid)
        case MID_REQUEST_SUBMITTED:
        case MID_RETRY_NEEDED:
                rdata->result = -EAGAIN;
+               if (server->sign && rdata->got_bytes)
+                       /* reset bytes number since we can not check a sign */
+                       rdata->got_bytes = 0;
+               /* FIXME: should this be counted toward the initiating task? */
+               task_io_account_read(rdata->got_bytes);
+               cifs_stats_bytes_read(tcon, rdata->got_bytes);
                break;
        default:
                rdata->result = -EIO;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 17c0c31..768cddb 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1730,6 +1730,12 @@ smb2_readv_callback(struct mid_q_entry *mid)
        case MID_REQUEST_SUBMITTED:
        case MID_RETRY_NEEDED:
                rdata->result = -EAGAIN;
+               if (server->sign && rdata->got_bytes)
+                       /* reset bytes number since we can not check a sign */
+                       rdata->got_bytes = 0;
+               /* FIXME: should this be counted toward the initiating task? */
+               task_io_account_read(rdata->got_bytes);
+               cifs_stats_bytes_read(tcon, rdata->got_bytes);
                break;
        default:
                if (rdata->result != -ENODATA)

---

Thoughts?

-- 
Best regards,
Pavel Shilovsky.
