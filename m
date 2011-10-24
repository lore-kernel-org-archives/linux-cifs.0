From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [v2 PATCH 0/4] Implement byte-range lock caching
Date: Mon, 24 Oct 2011 13:16:38 -0500
Message-ID: <CAH2r5mswq7q1bqf0ZDgBCeJEkpGK+sL3XooLk6wf3AuEDsy=sQ@mail.gmail.com>
References: <1319283212-19024-1-git-send-email-piastry@etersoft.ru>
	<20111024073529.28e787a5@tlielax.poochiereds.net>
	<CAKywueT8Ac-qPfLeXur8fn4ggumSk-LAYt=BbrJGDoGh64T5fg@mail.gmail.com>
	<CAH2r5mtfoqMSS7r_7Fowvo4wWvH8nmP3HmQ=wxGOXuqXMdND9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtfoqMSS7r_7Fowvo4wWvH8nmP3HmQ=wxGOXuqXMdND9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Oct 24, 2011 at 10:02 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> On Mon, Oct 24, 2011 at 7:05 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org=
> wrote:
>> 2011/10/24 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>>> On Sat, 22 Oct 2011 15:33:28 +0400
>>> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>>>
>>>> This is the rest of byte-range lock cache patchset that includes s=
everal fixes in patches #1 and #3.
>>>>
>>>> The patchset is going to simplify brlocking code and add caching s=
upport for exclusive oplock cases. I splitted it into several independe=
nt parts - so, each can be applied separately once it's reviewed.
>>>>
>>>> Any comments and testing are welcome!
>>>>
>>>> Pavel Shilovsky (4):
>>>> =A0 CIFS: Implement caching mechanism for mandatory brlocks
>>>> =A0 CIFS: Implement caching mechanism for posix brlocks
>>>> =A0 CIFS: Send as many mandatory unlock ranges at once as possible
>>>> =A0 CIFS: Make cifs_push_locks send as many locks at once as possi=
ble
>>>>
>>>> =A0fs/cifs/cifsglob.h =A0| =A0 =A02 +
>>>> =A0fs/cifs/cifsproto.h | =A0 =A07 +-
>>>> =A0fs/cifs/cifssmb.c =A0 | =A0 48 +++++-
>>>> =A0fs/cifs/file.c =A0 =A0 =A0| =A0533 ++++++++++++++++++++++++++++=
++++++++++++++++++-----
>>>> =A04 files changed, 538 insertions(+), 52 deletions(-)
>>>>
>>>
>>> This patchset seems to fix the regression in the earlier one. I've =
also
>>> looked over it and don't see any obvious problems. Let's get this
>>> merged early so it can get the full testing cycle for 3.2.
>>>
>>> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>> Thanks for the review!
>>
>> Steve, can you look at these 4 patches, please?
> yes - I am testing them now.

Lock patches merged.  Doing another check of the smb2 code
now and doing some testing, but that is next to merge.


--=20
Thanks,

Steve
