From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix variable types in cifs_iovec_read/write (try #2)
Date: Thu, 3 Feb 2011 13:59:22 -0600
Message-ID: <AANLkTikm=QwZwXXtquqy=ARrDsG+JW-So8F7b6edgF5x@mail.gmail.com>
References: <1296478988-22307-1-git-send-email-piastry@etersoft.ru>
	<AANLkTingtQ=U9abGN9OBfzRsnqo6ZMctGaiesqAa4MWz@mail.gmail.com>
	<AANLkTinuU3eL9hPdLmr9MYnpK8OCvg8-1vf-Hzt1dUSV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinuU3eL9hPdLmr9MYnpK8OCvg8-1vf-Hzt1dUSV-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Feb 3, 2011 at 1:56 PM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> w=
rote:
> 2011/2/3 Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> On Mon, Jan 31, 2011 at 7:03 AM, Pavel Shilovsky <piastry@etersoft.r=
u> wrote:
>>> Variable 'i' should be unsigned long as it's used in circle with nu=
m_pages,
>>> and bytes_read/total_written should be ssize_t according to return =
value.
>>>
>>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>>> ---
>>> =A0fs/cifs/file.c | =A0 11 ++++++-----
>>> =A01 files changed, 6 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>>> index 74c0a28..e964b1c 100644
>>> --- a/fs/cifs/file.c
>>> +++ b/fs/cifs/file.c
>>> @@ -1662,10 +1662,10 @@ static ssize_t
>>> =A0cifs_iovec_write(struct file *file, const struct iovec *iov,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long nr_segs, loff_t *poff=
set)
>>> =A0{
>>> - =A0 =A0 =A0 size_t total_written =3D 0;
>>> - =A0 =A0 =A0 unsigned int written =3D 0;
>>> - =A0 =A0 =A0 unsigned long num_pages, npages;
>>> - =A0 =A0 =A0 size_t copied, len, cur_len, i;
>>> + =A0 =A0 =A0 unsigned int written;
>>> + =A0 =A0 =A0 unsigned long num_pages, npages, i;
>>> + =A0 =A0 =A0 size_t copied, len, cur_len;
>>> + =A0 =A0 =A0 ssize_t total_written =3D 0;
>>> =A0 =A0 =A0 =A0struct kvec *to_send;
>>> =A0 =A0 =A0 =A0struct page **pages;
>>> =A0 =A0 =A0 =A0struct iov_iter it;
>>> @@ -1821,7 +1821,8 @@ cifs_iovec_read(struct file *file, const stru=
ct iovec *iov,
>>> =A0{
>>> =A0 =A0 =A0 =A0int rc;
>>> =A0 =A0 =A0 =A0int xid;
>>> - =A0 =A0 =A0 unsigned int total_read, bytes_read =3D 0;
>>> + =A0 =A0 =A0 ssize_t total_read;
>>> + =A0 =A0 =A0 unsigned int bytes_read =3D 0;
>>> =A0 =A0 =A0 =A0size_t len, cur_len;
>>> =A0 =A0 =A0 =A0int iov_offset =3D 0;
>>> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb;
>>> --
>>> 1.7.1
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>> Should written be initialized to 0 at the top of the outer do loop i=
n
>> function cifs_iovec_write() in case CIFSSMBWrite2 returns with
>> an error other than EAGAIN without writing anything?
>
> It seems like it assigned to 0 at the start of CIFSSMBWrite2 - so in
> this case there is no need to initialize it.
>
>>
>> Other than the above query, other things look correct.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Best regards,
> Pavel Shilovsky.
>

yes.

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
