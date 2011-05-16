From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [v2 0/4] Introduce shared superblock model to cifs
Date: Mon, 16 May 2011 10:00:46 -0500
Message-ID: <BANLkTimLt85CWvJ0wHK0_xRL+OR52FQjdg@mail.gmail.com>
References: <1304589632-1209-1-git-send-email-piastry@etersoft.ru>
	<BANLkTinBXJJvc+Wz4J9qa+ZHT8KtJSF-1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinBXJJvc+Wz4J9qa+ZHT8KtJSF-1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

No objection to these - I will rereview - are they also current in
your git tree?

On Mon, May 16, 2011 at 7:12 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =
wrote:
> 2011/5/5 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
>> This is the second version of the set. It should be applied on top o=
f current for-next branch + 6 DFS related patches from Sean Finney.
>>
>> Pavel Shilovsky (4):
>> =A0CIFS: Simplify connection structure search calls
>> =A0CIFS: Simplify mount code for further shared sb capability
>> =A0CIFS: Migrate from prefixpath logic
>> =A0CIFS: Migrate to shared superblock model
>>
>> =A0fs/cifs/cifs_fs_sb.h | =A0 =A02 -
>> =A0fs/cifs/cifsfs.c =A0 =A0 | =A0205 ++++++++++++++++++++++----
>> =A0fs/cifs/cifsglob.h =A0 | =A0 81 ++++++++++
>> =A0fs/cifs/cifsproto.h =A0| =A0 13 ++-
>> =A0fs/cifs/connect.c =A0 =A0| =A0398 +++++++++++++++++++++++++------=
-------------------
>> =A0fs/cifs/dir.c =A0 =A0 =A0 =A0| =A0 =A07 +-
>> =A0fs/cifs/inode.c =A0 =A0 =A0| =A0 19 +--
>> =A07 files changed, 472 insertions(+), 253 deletions(-)
>>
>>
>
> Since Sean Finney's DFS series is now in master, can you comment on t=
his one?
>
> --
> Best regards,
> Pavel Shilovsky.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
