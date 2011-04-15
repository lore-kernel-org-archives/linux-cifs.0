From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 6/7] cifs: convert cifs_writepages to use async writes
Date: Fri, 15 Apr 2011 13:03:37 +0400
Message-ID: <BANLkTintNfs=W+UFaC8SCUTt-hN5BXSFRQ@mail.gmail.com>
References: <1302694994-8303-1-git-send-email-jlayton@redhat.com>
	<1302694994-8303-7-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302694994-8303-7-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/13 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Have cifs_writepages issue asynchronous writes instead of waiting on
> each write call to complete before issuing another. This also allows =
us
> to return more quickly from writepages in the WB_SYNC_NONE case. It
> can just send out all of the I/Os and not wait around for the replies=
=2E
>
> In the WB_SYNC_ALL case, have it wait for all of the writes to comple=
te
> after issuing them and return any errors that turn up from it. If tho=
se
> errors turn out to all be retryable (-EAGAIN), then retry the entire
> operation again.
>
> This also changes the page locking semantics a little bit. Instead of
> holding the page lock until the response is received, release it afte=
r
> doing the send. This will reduce contention for the page lock and sho=
uld
> prevent processes that have the file mmap'ed from being blocked
> unnecessarily.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/file.c | =A0292 +++++++++++++++++++++++++++++-------------=
--------------
> =A01 files changed, 152 insertions(+), 140 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index b3d2e3f..7ff138f 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1089,32 +1089,65 @@ static int cifs_partialpagewrite(struct page =
*page, unsigned from, unsigned to)
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> +/*
> + * walk a list of in progress async writes and wait for them to comp=
lete.
> + * Check the result code on each one.
> + *
> + * There's a clear heirarchy: 0 < EAGAIN < other errors
> + *
> + * If we get an EAGAIN return on a WB_SYNC_ALL writeout, then we nee=
d to
> + * go back and do the whole operation again. If we get other errors =
then
> + * the mapping already likely has AS_EIO or AS_ENOSPC set, so we can
> + * give up and just return an error.
> + */
> +static int
> +cifs_wait_for_write_completion(struct address_space *mapping,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
list_head *pending)
> +{
> + =A0 =A0 =A0 int tmprc, rc =3D 0;
> + =A0 =A0 =A0 struct cifs_writedata *wdata;
> +
> + =A0 =A0 =A0 /* wait for writes to complete */
> + =A0 =A0 =A0 for (;;) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* anything left on list? */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&mapping->private_lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (list_empty(pending)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&mapping->p=
rivate_lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* dequeue an entry */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata =3D list_first_entry(pending, str=
uct cifs_writedata,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0pending);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&wdata->pending);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&mapping->private_lock);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* wait for it to complete */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmprc =3D wait_for_completion_killable(=
&wdata->completion);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tmprc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D tmprc;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wdata->result =3D=3D -EAGAIN)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D rc ? rc : wdata-=
>result;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (wdata->result !=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wdata->result;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kref_put(&wdata->refcount, cifs_writeda=
ta_release);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return rc;
> +}
> +
> =A0static int cifs_writepages(struct address_space *mapping,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct writeback_=
control *wbc)
> =A0{
> - =A0 =A0 =A0 unsigned int bytes_to_write;
> - =A0 =A0 =A0 unsigned int bytes_written;
> - =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
> - =A0 =A0 =A0 int done =3D 0;
> - =A0 =A0 =A0 pgoff_t end;
> - =A0 =A0 =A0 pgoff_t index;
> - =A0 =A0 =A0 int range_whole =3D 0;
> - =A0 =A0 =A0 struct kvec *iov;
> - =A0 =A0 =A0 int len;
> - =A0 =A0 =A0 int n_iov =3D 0;
> - =A0 =A0 =A0 pgoff_t next;
> - =A0 =A0 =A0 int nr_pages;
> - =A0 =A0 =A0 __u64 offset =3D 0;
> - =A0 =A0 =A0 struct cifsFileInfo *open_file;
> - =A0 =A0 =A0 struct cifs_tcon *tcon;
> - =A0 =A0 =A0 struct cifsInodeInfo *cifsi =3D CIFS_I(mapping->host);
> + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(mapping->host-=
>i_sb);
> + =A0 =A0 =A0 bool done =3D false, scanned =3D false, range_whole =3D=
 false;
> + =A0 =A0 =A0 pgoff_t end, index;
> + =A0 =A0 =A0 struct cifs_writedata *wdata;
> =A0 =A0 =A0 =A0struct page *page;
> - =A0 =A0 =A0 struct pagevec pvec;
> + =A0 =A0 =A0 struct list_head pending;
> =A0 =A0 =A0 =A0int rc =3D 0;
> - =A0 =A0 =A0 int scanned =3D 0;
> - =A0 =A0 =A0 int xid;
> -
> - =A0 =A0 =A0 cifs_sb =3D CIFS_SB(mapping->host->i_sb);
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * If wsize is smaller that the page cache size, defau=
lt to writing
> @@ -1123,27 +1156,8 @@ static int cifs_writepages(struct address_spac=
e *mapping,
> =A0 =A0 =A0 =A0if (cifs_sb->wsize < PAGE_CACHE_SIZE)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return generic_writepages(mapping, wbc=
);
>
> - =A0 =A0 =A0 iov =3D kmalloc(32 * sizeof(struct kvec), GFP_KERNEL);
> - =A0 =A0 =A0 if (iov =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return generic_writepages(mapping, wbc)=
;
> -
> - =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0* if there's no open file, then this is likely to fa=
il too,
> - =A0 =A0 =A0 =A0* but it'll at least handle the return. Maybe it sho=
uld be
> - =A0 =A0 =A0 =A0* a BUG() instead?
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 open_file =3D find_writable_file(CIFS_I(mapping->host),=
 false);
> - =A0 =A0 =A0 if (!open_file) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(iov);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return generic_writepages(mapping, wbc)=
;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 tcon =3D tlink_tcon(open_file->tlink);
> - =A0 =A0 =A0 cifsFileInfo_put(open_file);
> + =A0 =A0 =A0 INIT_LIST_HEAD(&pending);
>
> - =A0 =A0 =A0 xid =3D GetXid();
> -
> - =A0 =A0 =A0 pagevec_init(&pvec, 0);
> =A0 =A0 =A0 =A0if (wbc->range_cyclic) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0index =3D mapping->writeback_index; /*=
 Start from prev offset */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0end =3D -1;
> @@ -1151,24 +1165,34 @@ static int cifs_writepages(struct address_spa=
ce *mapping,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0index =3D wbc->range_start >> PAGE_CAC=
HE_SHIFT;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0end =3D wbc->range_end >> PAGE_CACHE_S=
HIFT;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (wbc->range_start =3D=3D 0 && wbc->=
range_end =3D=3D LLONG_MAX)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 range_whole =3D 1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 scanned =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 range_whole =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 scanned =3D true;
> =A0 =A0 =A0 =A0}
> =A0retry:
> - =A0 =A0 =A0 while (!done && (index <=3D end) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0(nr_pages =3D pagevec_lookup_tag(&pvec, =
mapping, &index,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PAGECACHE_TAG_DIRTY,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 min(end - index, (pgoff=
_t)PAGEVEC_SIZE - 1) + 1))) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 int first;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int i;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 first =3D -1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 next =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 n_iov =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes_to_write =3D 0;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < nr_pages; i++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page =3D pvec.pages[i];
> + =A0 =A0 =A0 while (!done && index <=3D end) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int i, nr_pages, found_pages;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pgoff_t next =3D 0, tofind;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tofind =3D min((cifs_sb->wsize / PAGE_C=
ACHE_SIZE) - 1,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end - i=
ndex) + 1;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata =3D cifs_writedata_alloc((unsigne=
d int)tofind);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!wdata) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 found_pages =3D find_get_pages_tag(mapp=
ing, &index,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0PAGECACHE_TAG_DIRTY,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0tofind, wdata->pages);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (found_pages =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kref_put(&wdata->refcou=
nt, cifs_writedata_release);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 nr_pages =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < found_pages; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page =3D wdata->pages[i=
];
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * At this point we ho=
ld neither mapping->tree_lock nor
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * lock on the page it=
self: the page may be truncated or
> @@ -1177,7 +1201,7 @@ retry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * mapping
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (first < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (nr_pages =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lock_p=
age(page);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else if (!trylock_page=
(page))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> @@ -1188,7 +1212,7 @@ retry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!wbc->range_cyclic=
 && page->index > end) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 done =3D=
 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 done =3D=
 true;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unlock=
_page(page);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -1215,119 +1239,107 @@ retry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_page_writeback(pag=
e);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (page_offset(page) =
>=3D mapping->host->i_size) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 done =3D=
 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 done =3D=
 true;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unlock=
_page(page);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0end_pa=
ge_writeback(page);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* BB can we get rid =
of this? =A0pages are held by pvec
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_get(page);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->pages[i] =3D pag=
e;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 next =3D page->index + =
1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++nr_pages;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D min(mapping->ho=
st->i_size - page_offset(page),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (lo=
ff_t)PAGE_CACHE_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* reset index to refind any pages skip=
ped */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (nr_pages =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 index =3D wdata->pages[=
0]->index + 1;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* reserve iov[0] for t=
he smb header */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 n_iov++;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[n_iov].iov_base =3D=
 kmap(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[n_iov].iov_len =3D =
len;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes_to_write +=3D len=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* put any pages we aren't going to use=
 */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D nr_pages; i < found_pages; i=
++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(wdat=
a->pages[i]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->pages[i] =3D NUL=
L;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (first < 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 first =3D=
 i;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset =
=3D page_offset(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 next =3D page->index + =
1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (bytes_to_write + PA=
GE_CACHE_SIZE > cifs_sb->wsize)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* nothing to write? */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (nr_pages =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kref_put(&wdata->refcou=
nt, cifs_writedata_release);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (n_iov) {
> -retry_write:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 open_file =3D find_writ=
able_file(CIFS_I(mapping->host),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 false);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!open_file) {
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->nr_pages =3D nr_pages;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->offset =3D page_offset(wdata->pa=
ges[0]);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wdata->cfile !=3D N=
ULL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFil=
eInfo_put(wdata->cfile);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->cfile =3D find_w=
ritable_file(CIFS_I(mapping->host),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 false);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!wdata->cfile) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR=
(1, "No writable handles for inode");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D=
 -EBADF;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
CIFSSMBWrite2(xid, tcon, open_file->netfid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bytes_to_write, offset,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&bytes_written, iov, n_iov,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFil=
eInfo_put(open_file);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Write2 rc=3D%d=
, wrote=3D%u", rc, bytes_written);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* For now, treat a s=
hort write as if nothing got
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* written. A zero le=
ngth write however indicates
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* ENOSPC or EFBIG. W=
e have no way to know which
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* though, so call it=
 ENOSPC for now. EFBIG would
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* get translated to =
AS_EIO anyway.
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* FIXME: make it tak=
e into account the data that did
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =A0 =A0 =A0 =A0get=
 written
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (byt=
es_written =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 rc =3D -ENOSPC;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if=
 (bytes_written < bytes_to_write)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 rc =3D -EAGAIN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wbc->sync_mode =3D=3D=
 WB_SYNC_ALL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lo=
ck(&mapping->private_lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_mo=
ve(&wdata->pending, &pending);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_un=
lock(&mapping->private_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_async_write=
v(wdata);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } while (wbc->sync_mode =3D=3D WB_SYNC_=
ALL && rc =3D=3D -EAGAIN);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* retry on data-integr=
ity flush */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wbc->sync_mode =3D=3D=
 WB_SYNC_ALL && rc =3D=3D -EAGAIN)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto re=
try_write;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < nr_pages; ++i)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unlock_page(wdata->page=
s[i]);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* fix the stats and EO=
=46 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (bytes_written > 0) =
{
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_st=
ats_bytes_written(tcon, bytes_written);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_up=
date_eof(cifsi, offset, bytes_written);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < n_iov=
; i++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page =3D=
 pvec.pages[first + i];
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* on r=
etryable write error, redirty page */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* send failure -- clean up the mess */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc !=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < nr_pa=
ges; ++i) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc=
 =3D=3D -EAGAIN)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 redirty_page_for_writepage(wbc, page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if=
 (rc !=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 SetPageError(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kunmap(=
page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unlock_=
page(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end_pag=
e_writeback(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_ca=
che_release(page);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 redirty_page_for_writepage(wbc,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wdata->pages[i]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 SetPageError(wdata->pages[i]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end_pag=
e_writeback(wdata->pages[i]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_ca=
che_release(wdata->pages[i]);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc !=3D -EAGAIN)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mappin=
g_set_error(mapping, rc);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
0;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((wbc->nr_to_write -=
=3D n_iov) <=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 done =3D=
 1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 index =3D next;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Need to re-find the =
pages we skipped */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 index =3D pvec.pages[0]=
->index + 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kref_put(&wdata->refcou=
nt, cifs_writedata_release);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (wbc->sync_mode =3D=3D WB_SYN=
C_NONE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kref_put(&wdata->refcou=
nt, cifs_writedata_release);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pagevec_release(&pvec);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((wbc->nr_to_write -=3D nr_pages) <=3D=
 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 done =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 index =3D next;
> =A0 =A0 =A0 =A0}
> +
> =A0 =A0 =A0 =A0if (!scanned && !done) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * We hit the last page and there is m=
ore work to be done: wrap
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * back to the start of the file
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 scanned =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 scanned =3D true;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0index =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto retry;
> =A0 =A0 =A0 =A0}
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* for WB_SYNC_ALL, we must wait until the writes com=
plete. If any
> + =A0 =A0 =A0 =A0* return -EAGAIN however, we need to retry the whole=
 thing again.
> + =A0 =A0 =A0 =A0* At that point nr_to_write will be all screwed up, =
but that
> + =A0 =A0 =A0 =A0* shouldn't really matter for WB_SYNC_ALL (right?)
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (wbc->sync_mode =3D=3D WB_SYNC_ALL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_wait_for_write_completion(m=
apping, &pending);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D -EAGAIN) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 index =3D wbc->range_st=
art >> PAGE_CACHE_SHIFT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto retry;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0if (wbc->range_cyclic || (range_whole && wbc->nr_to_wr=
ite > 0))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mapping->writeback_index =3D index;
>
> - =A0 =A0 =A0 FreeXid(xid);
> - =A0 =A0 =A0 kfree(iov);
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> --
> 1.7.4.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

I tested it again and noticed that it is a little faster that the 1st
variant against Windows 7 on LAN (about 0.5%). Anyway, it seems like a
very good change - Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>.

--=20
Best regards,
Pavel Shilovsky.
