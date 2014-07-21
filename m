From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 03/16] CIFS: Separate page sending from writepages
Date: Mon, 21 Jul 2014 19:53:16 +0400
Message-ID: <CAKywueS295Ou_9tCYD3nhvmvmNnHirUC4Cipdz2=rWO_cs2sAQ@mail.gmail.com>
References: <1403863073-19526-1-git-send-email-pshilovsky@samba.org>
	<1403863073-19526-4-git-send-email-pshilovsky@samba.org>
	<20140709090823.08bbd37b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140709090823.08bbd37b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-07-09 17:08 GMT+04:00 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Fri, 27 Jun 2014 13:57:40 +0400
> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> ---
>>  fs/cifs/file.c | 100 +++++++++++++++++++++++++++++++--------------------------
>>  1 file changed, 54 insertions(+), 46 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 69d1763..306c3df 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -1958,6 +1958,58 @@ wdata_prepare_pages(struct cifs_writedata *wdata, unsigned int found_pages,
>>       return nr_pages;
>>  }
>>
>> +static int
>> +wdata_send_pages(struct cifs_writedata *wdata, unsigned int nr_pages,
>> +              struct address_space *mapping, struct writeback_control *wbc)
>> +{
>> +     int rc = 0;
>> +     struct TCP_Server_Info *server;
>> +     unsigned int i;
>> +
>> +     wdata->sync_mode = wbc->sync_mode;
>> +     wdata->nr_pages = nr_pages;
>> +     wdata->offset = page_offset(wdata->pages[0]);
>> +     wdata->pagesz = PAGE_CACHE_SIZE;
>> +     wdata->tailsz = min(i_size_read(mapping->host) -
>> +                     page_offset(wdata->pages[nr_pages - 1]),
>> +                     (loff_t)PAGE_CACHE_SIZE);
>> +     wdata->bytes = ((nr_pages - 1) * PAGE_CACHE_SIZE) + wdata->tailsz;
>> +
>> +     do {
>> +             if (wdata->cfile != NULL)
>> +                     cifsFileInfo_put(wdata->cfile);
>> +             wdata->cfile = find_writable_file(CIFS_I(mapping->host), false);
>> +             if (!wdata->cfile) {
>> +                     cifs_dbg(VFS, "No writable handles for inode\n");
>> +                     rc = -EBADF;
>> +                     break;
>> +             }
>> +             wdata->pid = wdata->cfile->pid;
>> +             server = tlink_tcon(wdata->cfile->tlink)->ses->server;
>> +             rc = server->ops->async_writev(wdata, cifs_writedata_release);
>> +     } while (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN);
>> +
>> +     for (i = 0; i < nr_pages; ++i)
>> +             unlock_page(wdata->pages[i]);
>> +

I changed this patch in v3 and decided to leave error processing in
the caller (cifs_writepages).

>> +     if (!rc)
>> +             return rc;
>> +
>> +     /* send failure -- clean up the mess */
>> +     for (i = 0; i < nr_pages; ++i) {
>> +             if (rc == -EAGAIN)
>> +                     redirty_page_for_writepage(wbc, wdata->pages[i]);
>> +             else
>> +                     SetPageError(wdata->pages[i]);
>> +             end_page_writeback(wdata->pages[i]);
>> +             page_cache_release(wdata->pages[i]);
>> +     }
>> +     if (rc != -EAGAIN)
>> +             mapping_set_error(mapping, rc);
>> +
>> +     return rc;
>> +}
>> +
>>  static int cifs_writepages(struct address_space *mapping,
>>                          struct writeback_control *wbc)
>>  {
>> @@ -1965,7 +2017,6 @@ static int cifs_writepages(struct address_space *mapping,
>>       bool done = false, scanned = false, range_whole = false;
>>       pgoff_t end, index;
>>       struct cifs_writedata *wdata;
>> -     struct TCP_Server_Info *server;
>>       int rc = 0;
>>
>>       /*
>> @@ -1987,7 +2038,7 @@ static int cifs_writepages(struct address_space *mapping,
>>       }
>>  retry:
>>       while (!done && index <= end) {
>> -             unsigned int i, nr_pages, found_pages;
>> +             unsigned int nr_pages, found_pages;
>>               pgoff_t next = 0, tofind;
>>               struct page **pages;
>>
>> @@ -2032,50 +2083,7 @@ retry:
>>                       continue;
>>               }
>>
>> -             wdata->sync_mode = wbc->sync_mode;
>> -             wdata->nr_pages = nr_pages;
>> -             wdata->offset = page_offset(wdata->pages[0]);
>> -             wdata->pagesz = PAGE_CACHE_SIZE;
>> -             wdata->tailsz =
>> -                     min(i_size_read(mapping->host) -
>> -                         page_offset(wdata->pages[nr_pages - 1]),
>> -                         (loff_t)PAGE_CACHE_SIZE);
>> -             wdata->bytes = ((nr_pages - 1) * PAGE_CACHE_SIZE) +
>> -                                     wdata->tailsz;
>> -
>> -             do {
>> -                     if (wdata->cfile != NULL)
>> -                             cifsFileInfo_put(wdata->cfile);
>> -                     wdata->cfile = find_writable_file(CIFS_I(mapping->host),
>> -                                                       false);
>> -                     if (!wdata->cfile) {
>> -                             cifs_dbg(VFS, "No writable handles for inode\n");
>> -                             rc = -EBADF;
>> -                             break;
>> -                     }
>> -                     wdata->pid = wdata->cfile->pid;
>> -                     server = tlink_tcon(wdata->cfile->tlink)->ses->server;
>> -                     rc = server->ops->async_writev(wdata,
>> -                                                     cifs_writedata_release);
>> -             } while (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN);
>> -
>> -             for (i = 0; i < nr_pages; ++i)
>> -                     unlock_page(wdata->pages[i]);
>> -

the below part should be in cifs_writepages() since it's easier to
understand the code this way: we get pages from the page cache, call
wdata_send_pages() and clean up pages if sending fails.

>> -             /* send failure -- clean up the mess */
>> -             if (rc != 0) {
>> -                     for (i = 0; i < nr_pages; ++i) {
>> -                             if (rc == -EAGAIN)
>> -                                     redirty_page_for_writepage(wbc,
>> -                                                        wdata->pages[i]);
>> -                             else
>> -                                     SetPageError(wdata->pages[i]);
>> -                             end_page_writeback(wdata->pages[i]);
>> -                             page_cache_release(wdata->pages[i]);
>> -                     }
>> -                     if (rc != -EAGAIN)
>> -                             mapping_set_error(mapping, rc);
>> -             }
>> +             rc = wdata_send_pages(wdata, nr_pages, mapping, wbc);
>>               kref_put(&wdata->refcount, cifs_writedata_release);
>>
>>               wbc->nr_to_write -= nr_pages;
>
> Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

Jeff, I removed your reviewed-by tag since the patch is changed. Could
you look at the new smaller version, please?

-- 
Best regards,
Pavel Shilovsky.
