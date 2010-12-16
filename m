From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/13] cifs: don't fail writepages on -EAGAIN errors
Date: Thu, 16 Dec 2010 10:35:12 -0600
Message-ID: <AANLkTi=soXxgZMXoWrbx2_eJtGQR5iHncXtDO_dbWRX7@mail.gmail.com>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
	<1291995877-2276-2-git-send-email-jlayton@redhat.com>
	<4D07383A.6000400@suse.de>
	<20101214071820.2aa4936b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101214071820.2aa4936b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff,
Sounds like this patch series is close to ready.  Are you respinning
[only] patch 1 of 13?  Is this the easiest series of yours to
review/merge (into cifs-2.6.git) first for 2.6.38-pre



On Tue, Dec 14, 2010 at 6:18 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Tue, 14 Dec 2010 14:56:18 +0530
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>
>> On 12/10/2010 09:14 PM, Jeff Layton wrote:
>> > If CIFSSMBWrite2 returns -EAGAIN, then the error should be conside=
red
>> > temporary. CIFS should retry the write instead of setting an error=
 on
>> > the mapping and returning.
>> >
>> > For WB_SYNC_ALL, just retry the write immediately.
>> >
>> > In the WB_SYNC_NONE case, call redirty_page_for_writeback on all o=
f the
>> > pages that didn't get written out and then move on.
>> >
>> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > ---
>> > =A0fs/cifs/file.c | =A0 23 +++++++++++------------
>> > =A01 files changed, 11 insertions(+), 12 deletions(-)
>> >
>> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> > index fe16f6d..8e57370 100644
>> > --- a/fs/cifs/file.c
>> > +++ b/fs/cifs/file.c
>> > @@ -1430,6 +1430,7 @@ retry:
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> > =A0 =A0 =A0 =A0 =A0 =A0 }
>> > =A0 =A0 =A0 =A0 =A0 =A0 if (n_iov) {
>> > +retry_write:
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 open_file =3D find_writabl=
e_file(CIFS_I(mapping->host),
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 false);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!open_file) {
>> > @@ -1445,22 +1446,20 @@ retry:
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_updat=
e_eof(cifsi, offset, bytes_written);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> >
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || bytes_written < by=
tes_to_write) {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "W=
rite2 ret %d, wrote %d",
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 rc, bytes_written);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_=
error(mapping, rc);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* retry on data-integrity f=
lush */
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D -EAGAIN && wbc=
->sync_mode =3D=3D WB_SYNC_ALL)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto retry_w=
rite;
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!rc)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats=
_bytes_written(tcon, bytes_written);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (rc !=3D -EAGAIN)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_=
error(mapping, rc);
>> >
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < n_iov; i=
++) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page =3D p=
vec.pages[first + i];
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Should we=
 also set page error on
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 success rc b=
ut too little data written? */
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB invest=
igate retry logic on temporary
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server crash=
 cases and how recovery works
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 when page ma=
rked as error */
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D=
 -EAGAIN)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 redirty_page_for_writepage(wbc, page);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (rc =
!=3D 0)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 SetPageError(page);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kunmap(pag=
e);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unlock_pag=
e(page);
>>
>> Documentation/filesystems/Locking suggests that rc should be set to =
0
>> after redirtying?
>>
>>
>
> Ahh good catch. I'll fix it.
>
> Thanks,
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Thanks,

Steve
