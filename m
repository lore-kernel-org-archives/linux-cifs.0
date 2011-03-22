From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Use invalidate_inode_pages2 instead of
 invalidate_remote_inode (try #4)
Date: Tue, 22 Mar 2011 09:50:43 -0500
Message-ID: <AANLkTin_dHLJLpZxnmbCM=ukg7_xBi7YHg_YRaaYUmkj@mail.gmail.com>
References: <1300229732-4902-1-git-send-email-piastry@etersoft.ru>
	<20110322074233.546d4553@corrin.poochiereds.net>
	<AANLkTinGszmNsqFbf5vVstXfEsf5sh+SUZiFexjgBxjY@mail.gmail.com>
	<20110322080409.23461155@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110322080409.23461155-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Mar 22, 2011 at 7:04 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Tue, 22 Mar 2011 15:01:11 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> 2011/3/22 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > On Wed, 16 Mar 2011 01:55:32 +0300
>> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>> >
>> >> Use invalidate_inode_pages2 that don't leave pages even if shrink=
_page_list()
>> >> has a temp ref on them. It prevents a data coherency problem when
>> >> cifs_invalidate_mapping didn't invalidate pages but the client th=
inks that a data
>> >> from the cache is uptodate according to an oplock level (exclusiv=
e or II).
>> >>
>> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> >> ---
>> >> =A0fs/cifs/inode.c | =A0 10 ++++++++--
>> >> =A01 files changed, 8 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> >> index 41e5651..adb6324 100644
>> >> --- a/fs/cifs/inode.c
>> >> +++ b/fs/cifs/inode.c
>> >> @@ -1691,12 +1691,18 @@ cifs_invalidate_mapping(struct inode *ino=
de)
>> >>
>> >> =A0 =A0 =A0 cifs_i->invalid_mapping =3D false;
>> >>
>> >> - =A0 =A0 /* write back any cached data */
>> >> =A0 =A0 =A0 if (inode->i_mapping && inode->i_mapping->nrpages !=3D=
 0) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 /* write back any cached data */
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_and_wait(inode->=
i_mapping);
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode->i_mapping, r=
c);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D invalidate_inode_pages2(inode->i=
_mapping);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: could no=
t invalidate inode %p", __func__,
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_i->invalid_mapping=
 =3D true;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> =A0 =A0 =A0 }
>> >> - =A0 =A0 invalidate_remote_inode(inode);
>> >> +
>> >> =A0 =A0 =A0 cifs_fscache_reset_inode_cookie(inode);
>> >> =A0}
>> >>
>> >
>> > Hi Pavel,
>> >
>> > I noticed that Steve has merged this patch, but it doesn't seem li=
ke
>> > you ever made the change to have EBUSY percolate up to userspace. =
Are
>> > you still planning to fix that?
>> >
>>
>> Steve NACK'ed this and we came to agreement to mark a mapping as
>> invalid in this case for now and let the client try invalidate it
>> again when it needs. Of course, it can bring problems with a data
>> coherency if you need to use a cache very strictly.
>>
>
> Ahh, I must have missed the discussion around that NAK, and I don't s=
ee
> any record of it in the list archives. Steve, can you clarify why you
> didn't think that approach was acceptible?

Pavel and I discussed the code paths in detail via IRC or chat.  I
would have to go back and look through the code again, but I thought
the issue was that returning
EBUSY (from invalidate_inode_pages2) doesn't make any sense to
revalidate_file (e.g. why would a seek return EBUSY even though we
successfully updated the correct file size?) who can't use the rc, but
by resetting the mapping to invalid_mapping invalidate_inode_pages2
will still get invoked again later (which is all we would do in the
caller if we passed it back).

In practice it probably doesn't make much difference for cifs anyway
(passing the return code back from invalidate_inode_pages2) because we
don't have a "launder_page" operation for cifs and therefore don't
return an error, and for the other case it doesn't seem correct to
fail a seek because of (page_has_private(page))



--=20
Thanks,

Steve
