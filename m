From: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] CIFS: Fix tcon and file locking
Date: Mon, 17 Oct 2016 12:29:08 +0100
Message-ID: <a5206201-28f7-b941-86aa-a5e8d6b5698c@citrix.com>
References: <1476225247-30177-1-git-send-email-piastryyy@gmail.com>
 <CAH2r5mucfYLVKDX7JWaN1g90+NKneK_GUACzrt3ab8hYOPuF3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mucfYLVKDX7JWaN1g90+NKneK_GUACzrt3ab8hYOPuF3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I tested this patchset, along with the following on top
of 4.4 kernel, in our XenServer stress test (450
Virtual Machine life cycle operations with 2 different
SMB3 targets, Windows and Netapp).

The list of tested patches follows:

cifs-Limit-the-overall-credit-acquired
fix_memory_leaks_in_cifs_do_mount
compare_prepaths_when_comparing_superblocks
move_check_for_prefix_path_to_within_cifs_get_root
display_number_of_credits_available
set_previous_session_id_correctly_on_smb3_reconnect
smb3__guids_should_be_constructed_as_random_but_valid_uuids
fs-cifs__keep_guid_when_assigning_fid_to_fileinfo
fix_regression_which_breaks_dfs_mounting
clarify_locking_of_cifs_file_and_tcon_structures_and_make_more_granular
fs-cifs__reopen_persistent_handles_on_reconnect
expose_module_parameters_in_sysfs
smb3__add_mount_parameter_to_allow_user_to_override_max_credits
cifs__fix_persistent_handles_re-opening_on_reconnect
cifs__reset_read_oplock_to_none_if_we_have_mandatory_locks_after_reopen

Without the recent fixes to tcon_open_file_list loop, the stress test
failed (a temporary fix was to loop through it with the safe loop
alternative).

Overall the stress tests are passing.

Regards,
Germano

On 10/12/2016 04:26 AM, Steve French wrote:
> patch merged in with the patch noted above (and the other two patches
> from Pavel also merged) into cifs-2.6.git for-next
> 
> On Tue, Oct 11, 2016 at 5:34 PM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>>
>> This fix is supposed to be squashed into
>> "Clarify locking of cifs file and tcon structures and make more granular".
>>
>> Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>> ---
>>  fs/cifs/file.c | 21 ++++++++++++---------
>>  1 file changed, 12 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 1e7c625..20801dc 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -318,14 +318,14 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
>>                 oplock = 0;
>>         }
>>
>> +       spin_lock(&tcon->open_file_lock);
>>         if (fid->pending_open->oplock != CIFS_OPLOCK_NO_CHANGE && oplock)
>>                 oplock = fid->pending_open->oplock;
>> -       cifs_del_pending_open(fid->pending_open);
>> +       list_del(&fid->pending_open->olist);
>>
>>         fid->purge_cache = false;
>>         server->ops->set_fid(cfile, fid, oplock);
>>
>> -       spin_lock(&tcon->open_file_lock);
>>         list_add(&cfile->tlist, &tcon->openFileList);
>>
>>         /* if readable file instance put first in list*/
>> @@ -354,7 +354,7 @@ cifsFileInfo_get(struct cifsFileInfo *cifs_file)
>>  /*
>>   * Release a reference on the file private data. This may involve closing
>>   * the filehandle out on the server. Must be called without holding
>> - * cifs_file->file_info_lock.
>> + * tcon->open_file_lock and cifs_file->file_info_lock.
>>   */
>>  void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>>  {
>> @@ -369,11 +369,15 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>>         struct cifs_pending_open open;
>>         bool oplock_break_cancelled;
>>
>> +       spin_lock(&tcon->open_file_lock);
>> +
>>         spin_lock(&cifs_file->file_info_lock);
>>         if (--cifs_file->count > 0) {
>>                 spin_unlock(&cifs_file->file_info_lock);
>> +               spin_unlock(&tcon->open_file_lock);
>>                 return;
>>         }
>> +       spin_unlock(&cifs_file->file_info_lock);
>>
>>         if (server->ops->get_lease_key)
>>                 server->ops->get_lease_key(inode, &fid);
>> @@ -397,7 +401,8 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>>                         set_bit(CIFS_INO_INVALID_MAPPING, &cifsi->flags);
>>                 cifs_set_oplock_level(cifsi, 0);
>>         }
>> -       spin_unlock(&cifs_file->file_info_lock);
>> +
>> +       spin_unlock(&tcon->open_file_lock);
>>
>>         oplock_break_cancelled = cancel_work_sync(&cifs_file->oplock_break);
>>
>> @@ -1765,7 +1770,7 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
>>                         if (!open_file->invalidHandle) {
>>                                 /* found a good file */
>>                                 /* lock it so it will not be closed on us */
>> -                               cifsFileInfo_get_locked(open_file);
>> +                               cifsFileInfo_get(open_file);
>>                                 spin_unlock(&tcon->open_file_lock);
>>                                 return open_file;
>>                         } /* else might as well continue, and look for
>> @@ -1819,7 +1824,7 @@ refind_writable:
>>                 if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
>>                         if (!open_file->invalidHandle) {
>>                                 /* found a good writable file */
>> -                               cifsFileInfo_get_locked(open_file);
>> +                               cifsFileInfo_get(open_file);
>>                                 spin_unlock(&tcon->open_file_lock);
>>                                 return open_file;
>>                         } else {
>> @@ -1836,9 +1841,7 @@ refind_writable:
>>
>>         if (inv_file) {
>>                 any_available = false;
>> -               spin_lock(&inv_file->file_info_lock);
>> -               cifsFileInfo_get_locked(inv_file);
>> -               spin_unlock(&inv_file->file_info_lock);
>> +               cifsFileInfo_get(inv_file);
>>         }
>>
>>         spin_unlock(&tcon->open_file_lock);
>> --
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
