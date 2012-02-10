From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix mkdir/rmdir bug for the non-POSIX case
Date: Fri, 10 Feb 2012 10:11:25 +0400
Message-ID: <CAKywueT1ffP8VqXxe6DBQdGo=JoKu88rtEJpo0w2kLg6EaCUeA@mail.gmail.com>
References: <1328810892-21925-1-git-send-email-piastry@etersoft.ru>
	<CADT32e+BPaJebN=tz27pGh-=sTwvyszBK1F9E7LVKrvFpxb0Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+BPaJebN=tz27pGh-=sTwvyszBK1F9E7LVKrvFpxb0Zw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/10 Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Thu, Feb 9, 2012 at 12:08 PM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org=
> wrote:
>> Currently we do inc_nlink/drop_nlink for a parent directory for ever=
y
>> mkdir and rmdir calls. That's wrong when POSIX extensions are disabl=
ed
>> because in this case a server doesn't do the same things and returns
>> the old value on the next QueryInfo request. As the result, we updat=
e
>> our value with the server one and then decrement it on every rmdir
>> call - go to negative nlink values.
>>
>> Fix this by doing inc_nlink/drop_nlink for parent directory in mkdir
>> and rmdir in POSIX case only. Also add cERROR when nlink value <=3D =
2
>> and we still try to decrement it (possible broken servers).
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/inode.c | =A0 14 ++++++++++----
>> =A01 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> index a5f54b7..9af6ec7 100644
>> --- a/fs/cifs/inode.c
>> +++ b/fs/cifs/inode.c
>> @@ -1355,11 +1355,11 @@ mkdir_retry_old:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0d_drop(direntry);
>> =A0 =A0 =A0 =A0} else {
>> =A0mkdir_get_info:
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 inc_nlink(inode);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pTcon->unix_ext)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pTcon->unix_ext) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inc_nlink(inode);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_get_inode=
_info_unix(&newinode, full_path,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode->i_sb, xid);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_get_inode=
_info(&newinode, full_path, NULL,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_sb, xid, NULL);
>>
>> @@ -1475,7 +1475,13 @@ int cifs_rmdir(struct inode *inode, struct de=
ntry *direntry)
>> =A0 =A0 =A0 =A0cifs_put_tlink(tlink);
>>
>> =A0 =A0 =A0 =A0if (!rc) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 drop_nlink(inode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pTcon->unix_ext) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (inode->i_nlink > 2=
)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 drop_n=
link(inode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR=
(1, "%s: unexpected nlink number(%u)",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0__func__, inode->i_nlink);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&direntry->d_inode->i_lock)=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i_size_write(direntry->d_inode, 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0clear_nlink(direntry->d_inode);
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> Then we need to apply the same logic to set_nlink() calls and
> wherever we access i_nlink field also?

No, only mkdir/rmdir need this. Other places in cifs with i_nlink
access is either read only or inc_nlink/drop_nlink for
non-directories.

--=20
Best regards,
Pavel Shilovsky.
