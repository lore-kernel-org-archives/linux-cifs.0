From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Use invalidate_inode_pages2 instead of
 invalidate_remote_inode (try #2)
Date: Tue, 15 Mar 2011 23:59:48 +0300
Message-ID: <AANLkTim+FEYh9=UfcK+Jmw5pLsi1Z_S7cGDD7WR0eu=5@mail.gmail.com>
References: <1298629310-4618-1-git-send-email-piastry@etersoft.ru>
	<20110315155921.4ea36d30@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110315155921.4ea36d30-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/3/15 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Fri, 25 Feb 2011 13:21:50 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Use invalidate_inode_pages2 that don't leave pages even if shrink_pa=
ge_list()
>> has a temp ref on them. It prevents a data coherency problem on excl=
usive
>> oplocks opens.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/inode.c | =A0 16 +++++++++++-----
>> =A01 files changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> index 589f3e3..0011e95 100644
>> --- a/fs/cifs/inode.c
>> +++ b/fs/cifs/inode.c
>> @@ -1687,12 +1687,18 @@ cifs_invalidate_mapping(struct inode *inode)
>>
>> =A0 =A0 =A0 cifs_i->invalid_mapping =3D false;
>>
>> - =A0 =A0 /* write back any cached data */
>> - =A0 =A0 if (inode->i_mapping && inode->i_mapping->nrpages !=3D 0) =
{
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_and_wait(inode->i_map=
ping);
>> - =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode->i_mapping, rc);
>> + =A0 =A0 if (inode->i_mapping) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* write back any cached data */
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (inode->i_mapping->nrpages !=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_and_w=
ait(inode->i_mapping);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode->i=
_mapping, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D invalidate_inode_pages2(inode->i_ma=
pping);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: could not i=
nvalidate inode %p", __func__,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode);
>> =A0 =A0 =A0 }
>> - =A0 =A0 invalidate_remote_inode(inode);
>> +
>> =A0 =A0 =A0 cifs_fscache_reset_inode_cookie(inode);
>> =A0}
>>
>
> I think using invalidate_inode_pages2 is the right thing to do. I'm n=
ot
> so keen however on simply popping a printk when that fails. The user =
is
> going to see that and say "huh?"
>
> I think we need to consider allowing EBUSY bubble up to userspace
> appropriately. Otherwise we still risk data coherency problems, right=
?
> Perhaps cifs_invalidate_mapping should be changed to an int return an=
d
> the callers could return errors from it?
>

I like this idea. I can recreate the patch if nobody objects.

--=20
Best regards,
Pavel Shilovsky.
