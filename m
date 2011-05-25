From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [PATCH 6/7] cifs: convert cifs_writepages to use async writes
Date: Wed, 25 May 2011 14:47:59 +0400
Message-ID: <BANLkTimN194Qpys-bsKNUb7Lns7M18ZzzQ@mail.gmail.com>
References: <1305836578-26333-1-git-send-email-jlayton@redhat.com>
	<1305836578-26333-7-git-send-email-jlayton@redhat.com>
	<BANLkTik=mmwW1Hssfi4K4mzfhfKZj-9rEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTik=mmwW1Hssfi4K4mzfhfKZj-9rEg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sorry - missed linux-cifs in Cc.


---------- Forwarded message ----------
=46rom: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: 2011/5/25
Subject: Re: [PATCH 6/7] cifs: convert cifs_writepages to use async wri=
tes
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


2011/5/20 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Have cifs_writepages issue asynchronous writes instead of waiting on
> each write call to complete before issuing another. This also allows =
us
> to return more quickly from writepages. It can just send out all of t=
he
> I/Os and not wait around for the replies.
>
> In the WB_SYNC_ALL case, if the write completes with a retryable erro=
r,
> then the completion workqueue job will resend the write.
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
> =A0fs/cifs/file.c | =A0241 +++++++++++++++++++++++-------------------=
--------------
> =A01 files changed, 99 insertions(+), 142 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 0aeaaf7..b81bbd8 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1092,58 +1092,20 @@ static int cifs_partialpagewrite(struct page =
*page, unsigned from, unsigned to)
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
> - =A0 =A0 =A0 struct cifsTconInfo *tcon;
> - =A0 =A0 =A0 struct cifsInodeInfo *cifsi =3D CIFS_I(mapping->host);
> + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(mapping->host-=
>i_sb);
> + =A0 =A0 =A0 bool done =3D false, scanned =3D false, range_whole =3D=
 false;
> + =A0 =A0 =A0 pgoff_t end, index;
> + =A0 =A0 =A0 struct cifs_writedata *wdata;
> =A0 =A0 =A0 =A0struct page *page;
> - =A0 =A0 =A0 struct pagevec pvec;
> =A0 =A0 =A0 =A0int rc =3D 0;
> - =A0 =A0 =A0 int scanned =3D 0;
> - =A0 =A0 =A0 int xid;
> -
> - =A0 =A0 =A0 cifs_sb =3D CIFS_SB(mapping->host->i_sb);
>
> =A0 =A0 =A0 =A0/*
> - =A0 =A0 =A0 =A0* If wsize is smaller that the page cache size, defa=
ult to writing
> + =A0 =A0 =A0 =A0* If wsize is smaller than the page cache size, defa=
ult to writing
> =A0 =A0 =A0 =A0 * one page at a time via cifs_writepage
> =A0 =A0 =A0 =A0 */
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
> -
> - =A0 =A0 =A0 xid =3D GetXid();
> -
> - =A0 =A0 =A0 pagevec_init(&pvec, 0);
> =A0 =A0 =A0 =A0if (wbc->range_cyclic) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0index =3D mapping->writeback_index; /*=
 Start from prev offset */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0end =3D -1;
> @@ -1151,24 +1113,49 @@ static int cifs_writepages(struct address_spa=
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
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct page **pages;
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
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* find_get_pages_tag seems to return=
 a max of 256 on each
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* iteration, so we must call it seve=
ral times in order to
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* fill the array or the wsize is eff=
ectively limited to
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* 256 * PAGE_CACHE_SIZE.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 found_pages =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pages =3D wdata->pages;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nr_pages =3D find_get_p=
ages_tag(mapping, &index,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PAGECACHE_TAG_DIRTY,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tofind, pages);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 found_pages +=3D nr_pag=
es;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tofind -=3D nr_pages;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pages +=3D nr_pages;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } while (nr_pages && tofind && index <=3D=
 end);
> +
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
> @@ -1177,7 +1164,7 @@ retry:
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
> @@ -1188,7 +1175,7 @@ retry:
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
> @@ -1215,119 +1202,89 @@ retry:
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
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(=
1, "No writable handles for inode");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
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
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Write2 rc=3D%d=
, wrote=3D%u", rc, bytes_written);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->sync_mode =3D wbc->sync_mode;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->nr_pages =3D nr_pages;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->offset =3D page_offset(wdata->pa=
ges[0]);
>
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
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(=
1, "No writable handles for inode");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
-EBADF;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
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
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kref_put(&wdata->refcount, cifs_writeda=
ta_release);
>
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
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wbc->nr_to_write -=3D nr_pages;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wbc->nr_to_write <=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 done =3D true;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pagevec_release(&pvec);
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
> 1.7.4.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Looks good. I tested it (writing ~gigabyte file) - It's ~15% faster
that sequential variant.

Reviewed-and-Tested-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--
Best regards,
Pavel Shilovsky.



--=20
Best regards,
Pavel Shilovsky.
