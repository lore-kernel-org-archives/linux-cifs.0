From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 09/16] CIFS: Fix wsize usage in iovec write
Date: Thu, 24 Jul 2014 07:42:48 +0400
Message-ID: <06861DB4-4F18-4F5C-954E-482A4BB892ED@gmail.com>
References: <1405957558-18476-1-git-send-email-pshilovsky@samba.org> <1405957558-18476-10-git-send-email-pshilovsky@samba.org> <CADT32eLMseQ00gkywk9KdvcCEks7P5k1sBWdFOM+RaR3g1Edpw@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLMseQ00gkywk9KdvcCEks7P5k1sBWdFOM+RaR3g1Edpw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



23.07.2014, =D7 10:15, Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 =CE=C1=D0=C9=D3=C1=CC(=C1):

> On Mon, Jul 21, 2014 at 10:45 AM, Pavel Shilovsky <pshilovsky@samba.o=
rg> wrote:
>> If a server change maximum buffer size for write (wsize) requests
>> on reconnect we can fail on repeating with a big size buffer on
>> -EAGAIN error in iovec write. Fix this by checking wsize all the
>> time before repeating request in iovec write.
>>=20
>> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> ---
>> fs/cifs/cifssmb.c |  4 ----
>> fs/cifs/file.c    | 63 ++++++++++++++++++++++++++++++++++-----------=
----------
>> fs/cifs/smb2pdu.c |  4 ----
>> 3 files changed, 39 insertions(+), 32 deletions(-)
>>=20
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index e273ded..784f105 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -196,10 +196,6 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int=
 smb_command)
>>        if (rc)
>>                goto out;
>>=20
>> -       /*
>> -        * FIXME: check if wsize needs updated due to negotiated smb=
 buffer
>> -        *        size shrinking
>> -        */
>>        atomic_inc(&tconInfoReconnectCount);
>>=20
>>        /* tell server Unix caps we support */
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 6660698..c9c4f5a 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -2401,28 +2401,6 @@ cifs_uncached_writev_complete(struct work_str=
uct *work)
>>        kref_put(&wdata->refcount, cifs_uncached_writedata_release);
>> }
>>=20
>> -/* attempt to send write to server, retry on any -EAGAIN errors */
>> -static int
>> -cifs_uncached_retry_writev(struct cifs_writedata *wdata)
>> -{
>> -       int rc;
>> -       struct TCP_Server_Info *server;
>> -
>> -       server =3D tlink_tcon(wdata->cfile->tlink)->ses->server;
>> -
>> -       do {
>> -               if (wdata->cfile->invalidHandle) {
>> -                       rc =3D cifs_reopen_file(wdata->cfile, false)=
;
>> -                       if (rc !=3D 0)
>> -                               continue;
>> -               }
>> -               rc =3D server->ops->async_writev(wdata,
>> -                                              cifs_uncached_writeda=
ta_release);
>> -       } while (rc =3D=3D -EAGAIN);
>> -
>> -       return rc;
>> -}
>> -
>> static int
>> wdata_fill_from_iovec(struct cifs_writedata *wdata, struct iov_iter =
*from,
>>                      size_t *len, unsigned long *num_pages)
>> @@ -2474,13 +2452,19 @@ cifs_write_from_iter(loff_t offset, size_t l=
en, struct iov_iter *from,
>>        size_t cur_len;
>>        unsigned long nr_pages, num_pages, i;
>>        struct cifs_writedata *wdata;
>> +       struct iov_iter saved_from;
>> +       loff_t saved_offset =3D offset;
>>        pid_t pid;
>> +       struct TCP_Server_Info *server;
>>=20
>>        if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
>>                pid =3D open_file->pid;
>>        else
>>                pid =3D current->tgid;
>>=20
>> +       server =3D tlink_tcon(open_file->tlink)->ses->server;
>> +       memcpy(&saved_from, from, sizeof(struct iov_iter));
>> +
>>        do {
>>                nr_pages =3D get_numpages(cifs_sb->wsize, len, &cur_l=
en);
>>                wdata =3D cifs_writedata_alloc(nr_pages,
>> @@ -2520,10 +2504,20 @@ cifs_write_from_iter(loff_t offset, size_t l=
en, struct iov_iter *from,
>>                wdata->bytes =3D cur_len;
>>                wdata->pagesz =3D PAGE_SIZE;
>>                wdata->tailsz =3D cur_len - ((nr_pages - 1) * PAGE_SI=
ZE);
>> -               rc =3D cifs_uncached_retry_writev(wdata);
>> +
>> +               if (!wdata->cfile->invalidHandle ||
>> +                   !cifs_reopen_file(wdata->cfile, false))
>> +                       rc =3D server->ops->async_writev(wdata,
>> +                                       cifs_uncached_writedata_rele=
ase);
>>                if (rc) {
>>                        kref_put(&wdata->refcount,
>>                                 cifs_uncached_writedata_release);
>> +                       if (rc =3D=3D -EAGAIN) {
>> +                               memcpy(from, &saved_from,
>> +                                      sizeof(struct iov_iter));
>> +                               iov_iter_advance(from, offset - save=
d_offset);
>> +                               continue;
>> +                       }
>>                        break;
>>                }
>>=20
>> @@ -2545,6 +2539,7 @@ cifs_iovec_write(struct file *file, struct iov=
_iter *from, loff_t *poffset)
>>        struct cifs_sb_info *cifs_sb;
>>        struct cifs_writedata *wdata, *tmp;
>>        struct list_head wdata_list;
>> +       struct iov_iter saved_from;
>>        int rc;
>>=20
>>        len =3D iov_iter_count(from);
>> @@ -2565,6 +2560,8 @@ cifs_iovec_write(struct file *file, struct iov=
_iter *from, loff_t *poffset)
>>        if (!tcon->ses->server->ops->async_writev)
>>                return -ENOSYS;
>>=20
>> +       memcpy(&saved_from, from, sizeof(struct iov_iter));
>> +
>>        rc =3D cifs_write_from_iter(*poffset, len, from, open_file, c=
ifs_sb,
>>                                  &wdata_list);
>>=20
>> @@ -2596,7 +2593,25 @@ restart_loop:
>>=20
>>                        /* resend call if it's a retryable error */
>>                        if (rc =3D=3D -EAGAIN) {
>> -                               rc =3D cifs_uncached_retry_writev(wd=
ata);
>> +                               struct list_head tmp_list;
>> +                               struct iov_iter tmp_from;
>> +
>> +                               INIT_LIST_HEAD(&tmp_list);
>> +                               list_del_init(&wdata->list);
>> +
>> +                               memcpy(&tmp_from, &saved_from,
>> +                                      sizeof(struct iov_iter));
>> +                               iov_iter_advance(&tmp_from,
>> +                                                wdata->offset - *po=
ffset);
>> +
>> +                               rc =3D cifs_write_from_iter(wdata->o=
ffset,
>> +                                               wdata->bytes, &tmp_f=
rom,
>> +                                               open_file, cifs_sb, =
&tmp_list);
>> +
>> +                               list_splice(&tmp_list, &wdata_list);
>=20
> Do we list_splice unconditionally or do we list splice only if e.g.
> if (!list_empty(&tmp_list)) i.e. could tmp_list be empty if
> cifs_write_from_iter returned with non-zero rc (thus we did not
> add a wdata to the list)?


Yes. The check is done inside the list_splice().

--
Best regards,
Pavel Shilovsky.
