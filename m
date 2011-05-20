From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Simplify invalidate part (try #5)
Date: Fri, 20 May 2011 12:03:21 -0500
Message-ID: <BANLkTinh3ir7Ca78JfjNTFpbP5gsa6zbsg@mail.gmail.com>
References: <1303565417-3653-1-git-send-email-piastry@etersoft.ru>
	<20110519140132.32850e2c@barsoom.rdu.redhat.com>
	<BANLkTinsqwMoFzP+9+qX+W+Gr+LGae0Rdw@mail.gmail.com>
	<20110520073053.6b113a4a@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110520073053.6b113a4a-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged

On Fri, May 20, 2011 at 6:30 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Fri, 20 May 2011 13:00:53 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> 2011/5/19 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > On Sat, 23 Apr 2011 17:30:17 +0400
>> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>> >
>> >> Simplify many places when we call cifs_revalidate/invalidate to m=
ake
>> >> it do what it exactly needs.
>> >>
>> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> >> ---
>> >> =A0fs/cifs/cifsfs.c | =A0 33 +++++++++++-----
>> >> =A0fs/cifs/cifsfs.h | =A0 =A04 +-
>> >> =A0fs/cifs/file.c =A0 | =A0 16 ++++++--
>> >> =A0fs/cifs/inode.c =A0| =A0117 ++++++++++++++++++++++++++++++++++=
-------------------
>> >> =A04 files changed, 113 insertions(+), 57 deletions(-)
>> >>
>> >
>> > This patch is causing a regression in tests5:
>> >
>> > ./test5: read and write
>> > =A0 =A0 =A0 =A0./test5: (/mnt/salusa/rawhide.test) 'bigfile' has s=
ize -2130066000, should be 1048576
>> > basic tests failed
>> >
>> > Pavel, can you track this down?
>> >
>> > Steve, in the meantime I suggest that this patch not be pushed whe=
n
>> > the merge window opens.
>> >
>>
>> I figured it out.
>>
>> Steve, I attach two diffs: 1) diff for this version of the patch and
>> 2) new fixed version of the whole patch - you can use either one tha=
t
>> is more comfortable to you.
>>
>
> Confirmed -- the patch seems to fix the issue. With that, all the
> connectathon tests seem to now pass.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Thanks,

Steve
