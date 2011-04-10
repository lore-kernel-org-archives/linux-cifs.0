From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 1/2] CIFS: Add launder_page operation
Date: Sun, 10 Apr 2011 10:47:39 +0400
Message-ID: <BANLkTikGB9YbuTDkeX6YYRaEFJZ=ZofJtg@mail.gmail.com>
References: <1302249408-8971-1-git-send-email-piastry@etersoft.ru>
	<20110408151730.28da8041@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110408151730.28da8041-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/8 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
> On Fri, =A08 Apr 2011 11:56:47 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Add this let us drop filemap_write_and_wait from cifs_invalidate_map=
ping
>> and simplify the code to properly process invalidate logic.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/file.c | =A0 41 ++++++++++++++++++++++++++++++++++++++---
>> =A01 files changed, 38 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 9c7f83f..20a95bb 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -1331,7 +1331,8 @@ retry_write:
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> -static int cifs_writepage(struct page *page, struct writeback_contr=
ol *wbc)
>> +static int
>> +cifs_writepage_locked(struct page *page, struct writeback_control *=
wbc)
>> =A0{
>> =A0 =A0 =A0 int rc =3D -EFAULT;
>> =A0 =A0 =A0 int xid;
>> @@ -1354,14 +1355,25 @@ static int cifs_writepage(struct page *page,=
 struct writeback_control *wbc)
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 set_page_writeback(page);
>> =A0 =A0 =A0 rc =3D cifs_partialpagewrite(page, 0, PAGE_CACHE_SIZE);
>> - =A0 =A0 SetPageUptodate(page); /* BB add check for error and Clear=
uptodate? */
>> - =A0 =A0 unlock_page(page);
>> + =A0 =A0 if (rc =3D=3D -EAGAIN)
>> + =A0 =A0 =A0 =A0 =A0 =A0 redirty_page_for_writepage(wbc, page);
> =A0 =A0 =A0 =A0^^^^^^
> Should we be retrying the write here in the WB_SYNC_ALL case?

Yes, you are right - will post the fix next.

>
>> + =A0 =A0 else if (rc !=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 SetPageError(page);
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 SetPageUptodate(page);
>> =A0 =A0 =A0 end_page_writeback(page);
>> =A0 =A0 =A0 page_cache_release(page);
>> =A0 =A0 =A0 FreeXid(xid);
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> +static int cifs_writepage(struct page *page, struct writeback_contr=
ol *wbc)
>> +{
>> + =A0 =A0 int rc =3D cifs_writepage_locked(page, wbc);
>> + =A0 =A0 unlock_page(page);
>> + =A0 =A0 return rc;
>> +}
>> +
>> =A0static int cifs_write_end(struct file *file, struct address_space=
 *mapping,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 loff_t pos, unsigned len=
, unsigned copied,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct page *page, void =
*fsdata)
>> @@ -2344,6 +2356,27 @@ static void cifs_invalidate_page(struct page =
*page, unsigned long offset)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_fscache_invalidate_page(page, &cifs=
i->vfs_inode);
>> =A0}
>>
>> +static int cifs_launder_page(struct page *page)
>> +{
>> + =A0 =A0 int rc =3D 0;
>> + =A0 =A0 loff_t range_start =3D page_offset(page);
>> + =A0 =A0 loff_t range_end =3D range_start + (loff_t)(PAGE_CACHE_SIZ=
E - 1);
>> + =A0 =A0 struct writeback_control wbc =3D {
>> + =A0 =A0 =A0 =A0 =A0 =A0 .sync_mode =3D WB_SYNC_ALL,
>> + =A0 =A0 =A0 =A0 =A0 =A0 .nr_to_write =3D 0,
>> + =A0 =A0 =A0 =A0 =A0 =A0 .range_start =3D range_start,
>> + =A0 =A0 =A0 =A0 =A0 =A0 .range_end =3D range_end,
>> + =A0 =A0 };
>> +
>> + =A0 =A0 cFYI(1, "Launder page: %p", page);
>> +
>> + =A0 =A0 if (clear_page_dirty_for_io(page))
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_writepage_locked(page, &wbc);
>> +
>> + =A0 =A0 cifs_fscache_invalidate_page(page, page->mapping->host);
>> + =A0 =A0 return rc;
>> +}
>> +
>> =A0void cifs_oplock_break(struct work_struct *work)
>> =A0{
>> =A0 =A0 =A0 struct cifsFileInfo *cfile =3D container_of(work, struct=
 cifsFileInfo,
>> @@ -2415,6 +2448,7 @@ const struct address_space_operations cifs_add=
r_ops =3D {
>> =A0 =A0 =A0 .set_page_dirty =3D __set_page_dirty_nobuffers,
>> =A0 =A0 =A0 .releasepage =3D cifs_release_page,
>> =A0 =A0 =A0 .invalidatepage =3D cifs_invalidate_page,
>> + =A0 =A0 .launder_page =3D cifs_launder_page,
>> =A0 =A0 =A0 /* .sync_page =3D cifs_sync_page, */
>> =A0 =A0 =A0 /* .direct_IO =3D */
>> =A0};
>> @@ -2433,6 +2467,7 @@ const struct address_space_operations cifs_add=
r_ops_smallbuf =3D {
>> =A0 =A0 =A0 .set_page_dirty =3D __set_page_dirty_nobuffers,
>> =A0 =A0 =A0 .releasepage =3D cifs_release_page,
>> =A0 =A0 =A0 .invalidatepage =3D cifs_invalidate_page,
>> + =A0 =A0 .launder_page =3D cifs_launder_page,
>> =A0 =A0 =A0 /* .sync_page =3D cifs_sync_page, */
>> =A0 =A0 =A0 /* .direct_IO =3D */
>> =A0};
>
>
> --
> Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
Pavel Shilovsky.
