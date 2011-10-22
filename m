From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [v3 PATCH 0/6] Implement byte-range lock caching
Date: Sat, 22 Oct 2011 12:56:35 +0400
Message-ID: <CAKywueSC1+=817YCDUjvkwHRvWhTMiXbK=Qn3g-DC2UJSN9=GA@mail.gmail.com>
References: <1318016059-29306-1-git-send-email-piastry@etersoft.ru>
	<20111021141412.54bae877@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111021141412.54bae877-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/21 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Fri, =A07 Oct 2011 23:34:13 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> This patchset is going to simplify brlocking code and add the cachin=
g support for exclusive oplock cases. I splitted it into several indepe=
ndent parts - so, each can be applied separately once it's reviewed.
>>
>> This version of the patchset includes some code style improvements i=
n patch #3.
>>
>> Any comments and testing are welcome!
>>
>> Pavel Shilovsky (6):
>> =A0 CIFS: Simplify byte range locking code
>> =A0 CIFS: Move byte range lock list from fd to inode
>> =A0 CIFS: Implement caching mechanism for mandatory brlocks
>> =A0 CIFS: Implement caching mechanism for posix brlocks
>> =A0 CIFS: Send as many mandatory unlock ranges at once as possible
>> =A0 CIFS: Make cifs_push_locks send as many locks at once as possibl=
e
>>
>> =A0fs/cifs/cifsfs.c =A0 =A0| =A0 =A03 +-
>> =A0fs/cifs/cifsglob.h =A0| =A0 10 +-
>> =A0fs/cifs/cifsproto.h | =A0 =A09 +-
>> =A0fs/cifs/cifssmb.c =A0 | =A0 52 +++-
>> =A0fs/cifs/file.c =A0 =A0 =A0| =A0767 ++++++++++++++++++++++++++++++=
++++++++++-----------
>> =A05 files changed, 661 insertions(+), 180 deletions(-)
>>
>
> I decided to test this out today. With posix extensions enabled, it
> works fine. When I test with posix extensions disabled though,
> connectathon lock test 7 is hanging after step 7.2.
>
> The regression is fortunately in the portion that hasn't been merged
> yet. Pavel, let me know if you need info on how to test that. I don't
> think we can merge the rest of these until that regression is fixed.
>


Thanks for testing this! The regression is caused by patch #3. It's
big enough but it is the one logical change and should be split, I
think. I caught the bug, solved it and now I am giving it more
testing.

--=20
Best regards,
Pavel Shilovsky.
