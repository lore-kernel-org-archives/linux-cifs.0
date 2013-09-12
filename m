From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Avoid calling unlock_page() twice in
 cifs_readpage() when using fscache
Date: Thu, 12 Sep 2013 13:05:53 -0500
Message-ID: <CAH2r5mt9i3v-95SnmyN3ebpUS4aYaK+KV_OCbTLztFRfT6gi-A@mail.gmail.com>
References: <1378997931-19954-1-git-send-email-sprabhu@redhat.com>
	<20130912113527.2eb9b5cd@tlielax.poochiereds.net>
	<20130912114209.20319df5@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130912114209.20319df5-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Also would be helpful to have the link to any external bug report (if any)

On Thu, Sep 12, 2013 at 10:42 AM, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org> wrote:
> On Thu, 12 Sep 2013 11:35:27 -0400
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Thu, 12 Sep 2013 15:58:51 +0100
>> Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> > When reading a single page with cifs_readpage(), we make a call to
>> > fscache_read_or_alloc_page() which once done, asynchronously calls
>> > the completion function cifs_readpage_from_fscache_complete(). This
>> > completion function unlocks the page once it has been populated from
>> > cache. The module then attempts to unlock the page a second time in
>> > cifs_readpage() which leads to warning messages.
>> >
>> > In case of a successful call to fscache_read_or_alloc_page() we should skip
>> > the second unlock_page() since this will be called by the
>> > cifs_readpage_from_fscache_complete() once the page has been populated by
>> > fscache.
>> >
>> > With the modifications to cifs_readpage_worker(), we will need to re-grab the
>> > page lock in cifs_write_begin().
>> >
>> > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > ---
>> >  fs/cifs/file.c | 10 +++++++---
>> >  1 file changed, 7 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> > index 69e8431..98e5222 100644
>> > --- a/fs/cifs/file.c
>> > +++ b/fs/cifs/file.c
>> > @@ -3423,6 +3423,7 @@ static int cifs_readpage_worker(struct file *file, struct page *page,
>> >  io_error:
>> >     kunmap(page);
>> >     page_cache_release(page);
>> > +   unlock_page(page);
>> >
>
> Actually...one preexisting bug that you should probably fix while
> you're in there. It's a bad idea to unlock the page *after* you release
> the reference to it. You probably want to move that unlock_page call
> before the page_cache_release.
>
> OTOH...it's not clear to me why we're bumping the refcount on the
> page at all in cifs_readpage_worker. Clearly we must have a reference
> to it already or it won't be ok to just pass in the pointer to it.
> Maybe it'd be better to just make it clear that cifs_readpage_worker
> must be called with the page pinned and get rid of the extra
> refcounting in that function altogether.
>
> Sound reasonable?
>
>> >  read_complete:
>> >     return rc;
>> > @@ -3447,8 +3448,6 @@ static int cifs_readpage(struct file *file, struct page *page)
>> >
>> >     rc = cifs_readpage_worker(file, page, &offset);
>> >
>> > -   unlock_page(page);
>> > -
>> >     free_xid(xid);
>> >     return rc;
>> >  }
>> > @@ -3502,6 +3501,7 @@ static int cifs_write_begin(struct file *file, struct address_space *mapping,
>> >                     loff_t pos, unsigned len, unsigned flags,
>> >                     struct page **pagep, void **fsdata)
>> >  {
>> > +   int oncethru = 0;
>> >     pgoff_t index = pos >> PAGE_CACHE_SHIFT;
>> >     loff_t offset = pos & (PAGE_CACHE_SIZE - 1);
>> >     loff_t page_start = pos & PAGE_MASK;
>> > @@ -3511,6 +3511,7 @@ static int cifs_write_begin(struct file *file, struct address_space *mapping,
>> >
>> >     cifs_dbg(FYI, "write_begin from %lld len %d\n", (long long)pos, len);
>> >
>> > +start:
>> >     page = grab_cache_page_write_begin(mapping, index, flags);
>> >     if (!page) {
>> >             rc = -ENOMEM;
>> > @@ -3552,13 +3553,16 @@ static int cifs_write_begin(struct file *file, struct address_space *mapping,
>> >             }
>> >     }
>> >
>> > -   if ((file->f_flags & O_ACCMODE) != O_WRONLY) {
>> > +   if ((file->f_flags & O_ACCMODE) != O_WRONLY && !oncethru) {
>> >             /*
>> >              * might as well read a page, it is fast enough. If we get
>> >              * an error, we don't need to return it. cifs_write_end will
>> >              * do a sync write instead since PG_uptodate isn't set.
>> >              */
>> >             cifs_readpage_worker(file, page, &page_start);
>> > +           page_cache_release(page);
>> > +           oncethru = 1;
>> > +           goto start;
>> >     } else {
>> >             /* we could try using another file handle if there is one -
>> >                but how would we lock it to prevent close of that handle
>>
>> Looks correct. Nice catch!
>>
>> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>



-- 
Thanks,

Steve
