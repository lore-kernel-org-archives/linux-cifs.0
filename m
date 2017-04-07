From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [bug report] Handle mismatched open calls
Date: Fri, 7 Apr 2017 08:18:58 -0500
Message-ID: <CAH2r5mt2no=120NO2WVMykptqLGEsSj5sopQMDr6wK8PVfsRFw@mail.gmail.com>
References: <20170406091021.GA28584@mwanda> <1491473227.3042.2.camel@redhat.com>
 <1491503047.8010.2.camel@redhat.com> <20170407082024.GA4420@mwanda>
 <1491567538.8010.6.camel@redhat.com> <CAH2r5muHaA0JJ7E6fLFxO69wvLtuep8pC8_GdSsM_Lj2drYQOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muHaA0JJ7E6fLFxO69wvLtuep8pC8_GdSsM_Lj2drYQOA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

git.samba.org is down at the moment - will repush when it comes back up

On Fri, Apr 7, 2017 at 8:05 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> merged into cifs-2.6.git for-next
>
> On Fri, Apr 7, 2017 at 7:18 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On Fri, 2017-04-07 at 11:20 +0300, Dan Carpenter wrote:
>>> Sure, that takes care of the static checker warning.  But then I had
>>> all sorts of style nits to whinge-bucket about which you didn't ask
>>> for...
>>>
>>
>> Thanks Dan,
>>
>> I have incorporated all the requested changes into version 7 of the
>> patch.
>>
>> Is smatch the only tool you use for static analysis? I am considering
>> adding it to my own dev process.
>>
>> Steve, Can you please use this version instead.
>>
>> Regards,
>> Sachin Prabhu
>>
>>
>>> On Thu, Apr 06, 2017 at 07:24:07PM +0100, Sachin Prabhu wrote:
>>> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>>> > index 9ae695a..131663b 100644
>>> > --- a/fs/cifs/connect.c
>>> > +++ b/fs/cifs/connect.c
>>> > @@ -904,10 +904,19 @@ cifs_demultiplex_thread(void *p)
>>> >
>>> >             server->lstrp = jiffies;
>>> >             if (mid_entry != NULL) {
>>> > +                   if ((mid_entry->mid_flags &
>>> > MID_WAIT_CANCELLED) &&
>>> > +                        mid_entry->mid_state ==
>>> > MID_RESPONSE_RECEIVED &&
>>> > +                                   (server->ops-
>>> > >handle_cancelled_mid))
>>>
>>> Extra parens are not required.  Please align it like this:
>>>
>>>                       if ((mid_entry->mid_flags & MID_WAIT_CANCELLED)
>>> &&
>>>                            mid_entry->mid_state ==
>>> MID_RESPONSE_RECEIVED &&
>>>                            server->ops->handle_cancelled_mid)
>>>
>>>
>>>
>>> > +                           server->ops->handle_cancelled_mid(
>>> > +                                                   mid_entry-
>>> > >resp_buf,
>>> > +                                                   server);
>>> > +
>>> >                     if (!mid_entry->multiRsp || mid_entry-
>>> > >multiEnd)
>>> >                             mid_entry->callback(mid_entry);
>>> > -           } else if (!server->ops->is_oplock_break ||
>>> > -                      !server->ops->is_oplock_break(buf,
>>> > server)) {
>>> > +           } else if (server->ops->is_oplock_break &&
>>> > +                      server->ops->is_oplock_break(buf,
>>> > server)) {
>>> > +                   cifs_dbg(FYI, "Received oplock break\n");
>>> > +           } else {
>>> >                     cifs_dbg(VFS, "No task to wake, unknown
>>> > frame received! NumMids %d\n",
>>> >                              atomic_read(&midCount));
>>> >                     cifs_dump_mem("Received Data is: ", buf,
>>> > diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
>>> > index fd516ea..f50e3ef 100644
>>> > --- a/fs/cifs/smb2misc.c
>>> > +++ b/fs/cifs/smb2misc.c
>>> > @@ -659,3 +659,51 @@ smb2_is_valid_oplock_break(char *buffer,
>>> > struct TCP_Server_Info *server)
>>> >     cifs_dbg(FYI, "Can not process oplock break for non-
>>> > existent connection\n");
>>> >     return false;
>>> >  }
>>> > +
>>> > +void
>>> > +smb2_cancelled_close_fid(struct work_struct *work)
>>> > +{
>>> > +   struct close_cancelled_open *cancelled =
>>> > container_of(work,
>>> > +                                   struct
>>> > close_cancelled_open, work);
>>> > +
>>> > +   cifs_dbg(VFS, "Close unmatched open\n");
>>> > +
>>> > +   SMB2_close(0, cancelled->tcon, cancelled-
>>> > >fid.persistent_fid,
>>> > +                                      cancelled-
>>> > >fid.volatile_fid);
>>>
>>> Don't right align it.  Do it like this:
>>>
>>>       SMB2_close(0, cancelled->tcon, cancelled->fid.persistent_fid,
>>>                  cancelled->fid.volatile_fid);
>>>
>>>
>>>
>>> > +   cifs_put_tcon(cancelled->tcon);
>>> > +   kfree(cancelled);
>>> > +}
>>> > +
>>> > +int
>>> > +smb2_handle_cancelled_mid(char *buffer, struct TCP_Server_Info
>>> > *server)
>>> > +{
>>> > +   struct smb2_sync_hdr *sync_hdr = get_sync_hdr(buffer);
>>> > +   struct smb2_create_rsp *rsp = (struct smb2_create_rsp
>>> > *)buffer;
>>> > +   struct cifs_tcon *tcon;
>>> > +   struct close_cancelled_open *cancelled;
>>> > +
>>> > +   if ((sync_hdr->Command != SMB2_CREATE) ||
>>> > +           (sync_hdr->Status != STATUS_SUCCESS))
>>>
>>> No need for extra parens.  Align it like this:
>>>
>>>       if (sync_hdr->Command != SMB2_CREATE ||
>>>           sync_hdr->Status != STATUS_SUCCESS)
>>>               return 0;
>>>
>>>
>>>
>>> > +           return 0;
>>> > +
>>> > +   cancelled = (struct close_cancelled_open *)
>>> > +                   kzalloc(sizeof(struct
>>> > close_cancelled_open),
>>> > +                           GFP_KERNEL);
>>>
>>> No need to cast kzalloc.  Use sizeof(*cancelled).
>>>
>>>       cancelled = kzalloc(sizeof(*cancelled), GFP_KERNEL);
>>>
>>>
>>> > +   if (!cancelled)
>>> > +           return -ENOMEM;
>>> > +
>>> > +   tcon = smb2_find_smb_tcon(server, sync_hdr->SessionId,
>>> > +                             sync_hdr->TreeId);
>>> > +   if (!tcon) {
>>> > +           kfree(cancelled);
>>> > +           return -ENOENT;
>>> > +   }
>>> > +
>>> > +   cancelled->fid.persistent_fid = rsp->PersistentFileId;
>>> > +   cancelled->fid.volatile_fid = rsp->VolatileFileId;
>>> > +   cancelled->tcon = tcon;
>>> > +   INIT_WORK(&cancelled->work, smb2_cancelled_close_fid);
>>> > +   queue_work(cifsiod_wq, &cancelled->work);
>>> > +
>>> > +   return 0;
>>> > +}
>>>
>>> [ snip ]
>>>
>>> > diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
>>> > index 7c3bb1b..e3c8a9c 100644
>>> > --- a/fs/cifs/smb2transport.c
>>> > +++ b/fs/cifs/smb2transport.c
>>> > @@ -115,23 +115,72 @@ smb3_crypto_shash_allocate(struct
>>> > TCP_Server_Info *server)
>>> >     return 0;
>>> >  }
>>> >
>>> > -struct cifs_ses *
>>> > -smb2_find_smb_ses(struct TCP_Server_Info *server, __u64 ses_id)
>>> > +static struct cifs_ses *
>>> > +_smb2_find_smb_ses(struct TCP_Server_Info *server, __u64 ses_id)
>>>
>>> Could you name this "locked" or something and get rid of the _
>>> underscore prefix?
>>>
>>> >  {
>>> >     struct cifs_ses *ses;
>>> >
>>> > -   spin_lock(&cifs_tcp_ses_lock);
>>> >     list_for_each_entry(ses, &server->smb_ses_list,
>>> > smb_ses_list) {
>>> >             if (ses->Suid != ses_id)
>>> >                     continue;
>>> > -           spin_unlock(&cifs_tcp_ses_lock);
>>> >             return ses;
>>> >     }
>>> > +
>>> > +   return NULL;
>>> > +}
>>> > +
>>> > +struct cifs_ses *
>>> > +smb2_find_smb_ses(struct TCP_Server_Info *server, __u64 ses_id)
>>> > +{
>>> > +   struct cifs_ses *ses;
>>> > +
>>> > +   spin_lock(&cifs_tcp_ses_lock);
>>> > +   ses = _smb2_find_smb_ses(server, ses_id);
>>> >     spin_unlock(&cifs_tcp_ses_lock);
>>> >
>>> > +   return ses;
>>> > +}
>>> > +
>>> > +static struct cifs_tcon *
>>> > +_smb2_find_smb_sess_tcon(struct cifs_ses *ses, __u32  tid)
>>>
>>> Just leave out the _ underscore prefix.  This is a static function so
>>> there aren't that many users and they presumably know the locking
>>> rules.
>>> For smb2_find_smb_ses we have a locked and unlocked version of the
>>> function so it makes sense to put that in the name but here there is
>>> no need I think.
>>>
>>> > +{
>>> > +   struct list_head *tmp;
>>> > +   struct cifs_tcon *tcon;
>>> > +
>>> > +   list_for_each(tmp, &ses->tcon_list) {
>>> > +           tcon = list_entry(tmp, struct cifs_tcon,
>>> > tcon_list);
>>>
>>> list_for_each_entry()?
>>>
>>> > +           if (tcon->tid != tid)
>>> > +                   continue;
>>> > +           ++tcon->tc_count;
>>> > +           return tcon;
>>> > +   }
>>> > +
>>> >     return NULL;
>>> >  }
>>> >
>>> > +/*
>>> > + * Obtain tcon corresponding to the tid in the given
>>> > + * cifs_ses
>>> > + */
>>> > +
>>> > +struct cifs_tcon *
>>> > +smb2_find_smb_tcon(struct TCP_Server_Info *server, __u64 ses_id,
>>> > __u32  tid)
>>> > +{
>>> > +   struct cifs_ses *ses;
>>> > +   struct cifs_tcon *tcon;
>>> > +
>>> > +   spin_lock(&cifs_tcp_ses_lock);
>>> > +   ses = _smb2_find_smb_ses(server, ses_id);
>>> > +   if (!ses) {
>>> > +           spin_unlock(&cifs_tcp_ses_lock);
>>> > +           return NULL;
>>> > +   }
>>> > +   tcon = _smb2_find_smb_sess_tcon(ses, tid);
>>> > +   spin_unlock(&cifs_tcp_ses_lock);
>>> > +
>>> > +   return tcon;
>>> > +}
>>> > +
>>> >  int
>>> >  smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info
>>> > *server)
>>> >  {
>>> > @@ -511,6 +560,7 @@ smb2_mid_entry_alloc(const struct smb2_sync_hdr
>>> > *shdr,
>>> >
>>> >     atomic_inc(&midCount);
>>> >     temp->mid_state = MID_REQUEST_ALLOCATED;
>>> > +   temp->mid_flags = 0;
>>>
>>> No need.  We already memset() this to zero.
>>>
>>> >     return temp;
>>> >  }
>>> >
>>> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>>> > index 526f053..d82a4ae 100644
>>> > --- a/fs/cifs/transport.c
>>> > +++ b/fs/cifs/transport.c
>>> > @@ -752,9 +752,12 @@ cifs_send_recv(const unsigned int xid, struct
>>> > cifs_ses *ses,
>>> >
>>> >     rc = wait_for_response(ses->server, midQ);
>>> >     if (rc != 0) {
>>> > +           cifs_dbg(FYI, "Cancelling wait for mid %lu\n",
>>> > +                           (unsigned long)midQ->mid);
>>>
>>> ->mid is u64.  Just do this:
>>>
>>>               cifs_dbg(FYI, "Cancelling wait for mid %llu\n", midQ-
>>> >mid);
>>>
>>>
>>> >             send_cancel(ses->server, rqst, midQ);
>>> >             spin_lock(&GlobalMid_Lock);
>>> >             if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
>>> > +                   midQ->mid_flags |= MID_WAIT_CANCELLED;
>>> >                     midQ->callback = DeleteMidQEntry;
>>> >                     spin_unlock(&GlobalMid_Lock);
>>> >                     add_credits(ses->server, 1, optype);
>>>
>>> regards,
>>> dan carpenter
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-cifs"
>>> in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
