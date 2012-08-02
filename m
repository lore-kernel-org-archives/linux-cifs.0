From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] cifs: obtain file access during backup intent lookup
Date: Thu, 2 Aug 2012 01:07:45 -0500
Message-ID: <CADT32eJ3fXps3z+rxLXZis5SF202rXxnoyMJ2Kv=hyJ1AGAPzA@mail.gmail.com>
References: <1343256304-4735-1-git-send-email-shirishpargaonkar@gmail.com>
	<20120730070029.518b0b1d@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tugosavi-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120730070029.518b0b1d-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jul 30, 2012 at 6:00 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Wed, 25 Jul 2012 17:45:04 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> path based querries can fail for lack of access, especially during lookup
>> during open.
>> open itself would actually succeed becasue of back up intent bit
>> but querries (either path or file handle based) do not have a means to
>> specifiy backup intent bit.
>> So querry the file info during lookup using
>>  trans2 / findfirst2 / file_id_full_ir_info
>> to obtain file info as well as file_id/inode value.
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Reported-by: Tushar Gosavi <tugosavi-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/cifs/cifssmb.c |   38 +++++++++++++++++------------
>>  fs/cifs/inode.c   |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  2 files changed, 87 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 4ee522b..f059c0a 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -4257,7 +4257,7 @@ CIFSFindFirst(const int xid, struct cifs_tcon *tcon,
>>       int rc = 0;
>>       int bytes_returned = 0;
>>       int name_len;
>> -     __u16 params, byte_count;
>> +     __u16 params, byte_count, ffattrs;
>>
>>       cFYI(1, "In FindFirst for %s", searchName);
>>
>> @@ -4275,27 +4275,35 @@ findFirstRetry:
>>               it got remapped to 0xF03A as if it were part of the
>>               directory name instead of a wildcard */
>>               name_len *= 2;
>> -             pSMB->FileName[name_len] = dirsep;
>> -             pSMB->FileName[name_len+1] = 0;
>> -             pSMB->FileName[name_len+2] = '*';
>> -             pSMB->FileName[name_len+3] = 0;
>> -             name_len += 4; /* now the trailing null */
>> -             pSMB->FileName[name_len] = 0; /* null terminate just in case */
>> -             pSMB->FileName[name_len+1] = 0;
>> -             name_len += 2;
>> +             if (dirsep) {
>
> This seems like a strange use of the "dirsep" parm. So if you are using
> this to do a single lookup, then you pass in 0 for dirsep. I guess
> it'll work, but it's not exactly self-documenting.

How do I otherwise figure out / distinguish that the findfirst  operation
is for a file/leaf and not a directory.

>
>> +                     pSMB->FileName[name_len] = dirsep;
>> +                     pSMB->FileName[name_len+1] = 0;
>> +                     pSMB->FileName[name_len+2] = '*';
>> +                     pSMB->FileName[name_len+3] = 0;
>> +                     name_len += 4; /* now the trailing null */
>> +                     /* null terminate just in case */
>> +                     pSMB->FileName[name_len] = 0;
>> +                     pSMB->FileName[name_len+1] = 0;
>> +                     name_len += 2;
>> +             }
>>       } else {        /* BB add check for overrun of SMB buf BB */
>>               name_len = strnlen(searchName, PATH_MAX);
>>  /* BB fix here and in unicode clause above ie
>>               if (name_len > buffersize-header)
>>                       free buffer exit; BB */
>>               strncpy(pSMB->FileName, searchName, name_len);
>> -             pSMB->FileName[name_len] = dirsep;
>> -             pSMB->FileName[name_len+1] = '*';
>> -             pSMB->FileName[name_len+2] = 0;
>> -             name_len += 3;
>> +             if (dirsep) {
>> +                     pSMB->FileName[name_len] = dirsep;
>> +                     pSMB->FileName[name_len+1] = '*';
>> +                     pSMB->FileName[name_len+2] = 0;
>> +                     name_len += 3;
>> +             }
>>       }
>>
>>       params = 12 + name_len /* includes null */ ;
>> +     ffattrs = ATTR_READONLY | ATTR_HIDDEN | ATTR_SYSTEM;
>> +     if (dirsep)
>> +             ffattrs |= ATTR_DIRECTORY;
>         ^^^
> I don't understand this. You're only setting ATTR_DIRECTORY for a readdir()? Why?

Because what I see is, trans2/qpathinfo does not fail on directory, only
does so for a file.  So if dirsep is 0, we are looking for a file and dirsep
is not 0, findfirst is for a directory.

>
>>       pSMB->TotalDataCount = 0;       /* no EAs */
>>       pSMB->MaxParameterCount = cpu_to_le16(10);
>>       pSMB->MaxDataCount = cpu_to_le16(CIFSMaxBufSize & 0xFFFFFF00);
>> @@ -4315,9 +4323,7 @@ findFirstRetry:
>>       pSMB->SetupCount = 1;   /* one byte, no need to make endian neutral */
>>       pSMB->Reserved3 = 0;
>>       pSMB->SubCommand = cpu_to_le16(TRANS2_FIND_FIRST);
>> -     pSMB->SearchAttributes =
>> -         cpu_to_le16(ATTR_READONLY | ATTR_HIDDEN | ATTR_SYSTEM |
>> -                     ATTR_DIRECTORY);
>> +     pSMB->SearchAttributes = cpu_to_le16(ffattrs);
>>       pSMB->SearchCount = cpu_to_le16(CIFSMaxBufSize/sizeof(FILE_UNIX_INFO));
>>       pSMB->SearchFlags = cpu_to_le16(search_flags);
>>       pSMB->InformationLevel = cpu_to_le16(psrch_inf->info_level);
>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> index 8e8bb49..a0ed97d 100644
>> --- a/fs/cifs/inode.c
>> +++ b/fs/cifs/inode.c
>> @@ -600,17 +600,40 @@ cgfi_exit:
>>       return rc;
>>  }
>>
>> +static void
>> +fidinfo2fainfo(SEARCH_ID_FULL_DIR_INFO *fidinfo, FILE_ALL_INFO *fainfo)
>> +{
>> +     memcpy(&fainfo->CreationTime, &fidinfo->CreationTime, sizeof(__le64));
>> +     memcpy(&fainfo->LastAccessTime, &fidinfo->LastAccessTime,
>> +             sizeof(__le64));
>> +     memcpy(&fainfo->LastWriteTime, &fidinfo->LastWriteTime,
>> +             sizeof(__le64));
>> +     memcpy(&fainfo->ChangeTime, &fidinfo->ChangeTime,
>> +             sizeof(__le64));
>> +     memcpy(&fainfo->EndOfFile, &fidinfo->EndOfFile,
>> +             sizeof(__le64));
>> +     memcpy(&fainfo->AllocationSize, &fidinfo->AllocationSize,
>> +             sizeof(__le64));
>> +     memcpy(&fainfo->Attributes, &fidinfo->ExtFileAttributes,
>> +             sizeof(__le32));
>> +
>> +     return;
>> +}
>> +
>
>
> Yuck. So you're going to take the SEARCH_ID_FULL_DIR_INFO and convert
> that to FILE_ALL_INFO, just so it can then be converted to a
> cifs_fattr? Why not shortcut this step, and turn it into a fattr
> directly. I think we already have some routines to do that.

I will look into code to use any existing one, if not write a new similar one
that converts search_id_full_dir_info to fattr.

>
>>  int cifs_get_inode_info(struct inode **pinode,
>>       const unsigned char *full_path, FILE_ALL_INFO *pfindData,
>>       struct super_block *sb, int xid, const __u16 *pfid)
>>  {
>> -     int rc = 0, tmprc;
>> +     __u16 fid, srchflgs;
>> +     int rc = 0, rc2 = -EINVAL, tmprc;
>>       struct cifs_tcon *pTcon;
>>       struct tcon_link *tlink;
>>       struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
>>       char *buf = NULL;
>>       bool adjustTZ = false;
>>       struct cifs_fattr fattr;
>> +     struct cifs_search_info *psrch_inf = NULL;
>> +     SEARCH_ID_FULL_DIR_INFO *ffdata = NULL;
>>
>>       tlink = cifs_sb_tlink(cifs_sb);
>>       if (IS_ERR(tlink))
>> @@ -640,6 +663,38 @@ int cifs_get_inode_info(struct inode **pinode,
>>                             0 /* not legacy */,
>>                             cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
>>                               CIFS_MOUNT_MAP_SPECIAL_CHR);
>> +
>> +             /*
>> +              * This findfirst call is meant for a lookup operation
>> +              * that would otherwise fail since query path info has no
>> +              * means to indicate backup intent.
>> +              */
>> +             if (rc == -EACCES && *pinode == NULL && backup_cred(cifs_sb)) {
>> +                     psrch_inf = kzalloc(sizeof(struct cifs_search_info),
>> +                                             GFP_KERNEL);
>> +                     if (psrch_inf == NULL) {
>> +                             rc = -ENOMEM;
>> +                             goto cgii_exit;
>> +                     }
>> +                     psrch_inf->endOfSearch = false;
>> +                     psrch_inf->info_level = SMB_FIND_FILE_ID_FULL_DIR_INFO;
>> +
>> +                     srchflgs = CIFS_SEARCH_CLOSE_ALWAYS |
>> +                                     CIFS_SEARCH_CLOSE_AT_END |
>> +                                     CIFS_SEARCH_BACKUP_SEARCH;
>> +
>> +                     rc2 = CIFSFindFirst(xid, pTcon, full_path,
>> +                             cifs_sb->local_nls, &fid, srchflgs, psrch_inf,
>> +                             cifs_sb->mnt_cifs_flags &
>> +                                     CIFS_MOUNT_MAP_SPECIAL_CHR, 0);
>> +                     if (!rc2) {
>> +                             ffdata = (SEARCH_ID_FULL_DIR_INFO *)
>> +                                             psrch_inf->srch_entries_start;
>> +                             fidinfo2fainfo(ffdata, pfindData);
>> +                     }
>> +                     rc = rc2;
>> +             }
>> +
>>               /* BB optimize code so we do not make the above call
>>               when server claims no NT SMB support and the above call
>>               failed at least once - set flag in tcon or mount */
>> @@ -683,7 +738,11 @@ int cifs_get_inode_info(struct inode **pinode,
>>               if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
>>                       int rc1 = 0;
>>
>> -                     rc1 = CIFSGetSrvInodeNumber(xid, pTcon,
>> +                     if (!rc2)
>> +                             fattr.cf_uniqueid =
>> +                                     le64_to_cpu(ffdata->UniqueId);
>
> Won't ffdata only be non-NULL if you fall into the new code block
> above? That looks like it could oops.

rc2 is set as -EINVAL.  If we do not fall into the new code, rc2 is not 0
i.e. !rc2 is false.  If we fall into new code and findfirst call is successful,
rc2 is 0 and !rc2 is true but if findfirst call fails, rc2 is not 0 and
so !rc2 is false.  So I do not think we will oops because ffdata is NULL.

>
>> +                     else
>> +                             rc1 = CIFSGetSrvInodeNumber(xid, pTcon,
>>                                       full_path, &fattr.cf_uniqueid,
>>                                       cifs_sb->local_nls,
>>                                       cifs_sb->mnt_cifs_flags &
>> @@ -741,6 +800,10 @@ int cifs_get_inode_info(struct inode **pinode,
>>       }
>>
>>  cgii_exit:
>> +     if (!rc2) {
>> +             cifs_buf_release(psrch_inf->ntwrk_buf_start);
>> +             kfree(psrch_inf);
>> +     }
>>       kfree(buf);
>>       cifs_put_tlink(tlink);
>>       return rc;
>
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
