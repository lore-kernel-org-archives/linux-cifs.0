From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v2 0/6] Prepare byte-range locking code for future SMB2 usage
Date: Wed, 28 Mar 2012 20:48:19 +0400
Message-ID: <CAKywueRbrBLnEieD+D10nBwK6X5WY1tPNNRXU0fSH4L8i3pC4A@mail.gmail.com>
References: <1331911072-1078-1-git-send-email-piastry@etersoft.ru>
	<20120326144847.42719249@corrin.poochiereds.net>
	<CAKywueQaV9a8Db7G+TmqCXTPWxMVgse_bJeEOj0y3yyzjggYzA@mail.gmail.com>
	<CAKywueTbYWtTNB39uqNK+=u1iOfH9CqUDoqMZYcYFpVOmEX_dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTbYWtTNB39uqNK+=u1iOfH9CqUDoqMZYcYFpVOmEX_dw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

27 =CD=C1=D2=D4=C1 2012=9A=C7. 22:00 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Pavel Shilovsky
<piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> 27 =CD=C1=D2=D4=C1 2012=9A=C7. 15:00 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=
=D8 Pavel Shilovsky
> <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
>> 26 =CD=C1=D2=D4=C1 2012=9A=C7. 22:48 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=
=D8 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
>>> On Fri, 16 Mar 2012 18:17:46 +0300
>>> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>>>
>>>> This is one of the preparation step that makes the byte-range lock=
ing code more
>>>> protocol independent.
>>>>
>>>
>>> Ok, I sat down to review this set today, but found it very difficul=
t to
>>> do so. Most of these patches have little to no explanation or
>>> justification at all. Terseness is not a virtue when it come to pat=
ch
>>> descriptions:
>>>
>>>> Pavel Shilovsky (6):
>>>> =9A CIFS: Move locks to file structure
>>> ^^^
>>> That's all that patch says. No explanation of *why* you're moving t=
hose
>>> to the file structure -- whatever that is. Do you mean cifsFileInfo=
 here?
>>>
>>>> =9A CIFS: Fix VFS locks usage
>>>
>>> This one says:
>>>
>>> Surround VFS posix_lock_file_wait calls with CIFS lock_mutex
>>> where it needs.
>>>
>>> ...so you're saying that the existing code is broken? Or is it only=
 a
>>> problem for SMB2 support? Does a fix need to go to stable?
>>>
>>>> =9A CIFS: Convert lock type to 32 bit variable
>>>> =9A CIFS: Separate protocol specific lock type handling
>>>> =9A CIFS: Separate protocol specific part from getlk
>>>> =9A CIFS: Separate protocol specific part from setlk
>>>>
>>>> =9Afs/cifs/cifsfs.c =9A | =9A =9A1 -
>>>> =9Afs/cifs/cifsglob.h | =9A =9A5 +-
>>>> =9Afs/cifs/file.c =9A =9A | =9A250 +++++++++++++++++++++++++++++++=
++++++---------------
>>>> =9A3 files changed, 182 insertions(+), 74 deletions(-)
>>>>
>>>
>>> Given that it's not clear to me what the goal of this patchset is, =
not
>>> to mention the lack of any description on these patches, I can't
>>> reasonably review this.
>>>
>>
>> Sorry - forgot to add proper descriptions for these two patches - wi=
ll
>> repost asap.
>>
>> --
>> Best regards,
>> Pavel Shilovsky.
>
> rebased cifs-patches branch
> (http://git.altlinux.org/people/piastry/public/?p=3Dcifs-2.6.git;a=3D=
shortlog;h=3Drefs/heads/cifs-patches)
> and smb2-3.4 branch
> (http://git.altlinux.org/people/piastry/public/?p=3Dcifs-2.6.git;a=3D=
shortlog;h=3Drefs/heads/smb2-3.4)
> on top of the current Steve's master for an easier review.

updated branches according to he new version of VFS lock usage fix.

--=20
Best regards,
Pavel Shilovsky.
