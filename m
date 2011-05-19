From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Simplify invalidate part (try #5)
Date: Fri, 20 May 2011 00:07:09 +0400
Message-ID: <BANLkTikEn3nA9q7OZjHxrJ6ny6aau6y-ow@mail.gmail.com>
References: <1303565417-3653-1-git-send-email-piastry@etersoft.ru>
	<20110519140132.32850e2c@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110519140132.32850e2c-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/5/19 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Sat, 23 Apr 2011 17:30:17 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Simplify many places when we call cifs_revalidate/invalidate to make
>> it do what it exactly needs.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c | =A0 33 +++++++++++-----
>> =A0fs/cifs/cifsfs.h | =A0 =A04 +-
>> =A0fs/cifs/file.c =A0 | =A0 16 ++++++--
>> =A0fs/cifs/inode.c =A0| =A0117 ++++++++++++++++++++++++++++++++++---=
----------------
>> =A04 files changed, 113 insertions(+), 57 deletions(-)
>>
>
> This patch is causing a regression in tests5:
>
> ./test5: read and write
> =A0 =A0 =A0 =A0./test5: (/mnt/salusa/rawhide.test) 'bigfile' has size=
 -2130066000, should be 1048576
> basic tests failed
>
> Pavel, can you track this down?

Yes, thanks! I will look it this tomorrow.

>
> Steve, in the meantime I suggest that this patch not be pushed when
> the merge window opens.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
Pavel Shilovsky.
