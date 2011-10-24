From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [v2 PATCH 0/4] Implement byte-range lock caching
Date: Mon, 24 Oct 2011 16:05:18 +0400
Message-ID: <CAKywueT8Ac-qPfLeXur8fn4ggumSk-LAYt=BbrJGDoGh64T5fg@mail.gmail.com>
References: <1319283212-19024-1-git-send-email-piastry@etersoft.ru>
	<20111024073529.28e787a5@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111024073529.28e787a5-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/24 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Sat, 22 Oct 2011 15:33:28 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> This is the rest of byte-range lock cache patchset that includes sev=
eral fixes in patches #1 and #3.
>>
>> The patchset is going to simplify brlocking code and add caching sup=
port for exclusive oplock cases. I splitted it into several independent=
 parts - so, each can be applied separately once it's reviewed.
>>
>> Any comments and testing are welcome!
>>
>> Pavel Shilovsky (4):
>> =A0 CIFS: Implement caching mechanism for mandatory brlocks
>> =A0 CIFS: Implement caching mechanism for posix brlocks
>> =A0 CIFS: Send as many mandatory unlock ranges at once as possible
>> =A0 CIFS: Make cifs_push_locks send as many locks at once as possibl=
e
>>
>> =A0fs/cifs/cifsglob.h =A0| =A0 =A02 +
>> =A0fs/cifs/cifsproto.h | =A0 =A07 +-
>> =A0fs/cifs/cifssmb.c =A0 | =A0 48 +++++-
>> =A0fs/cifs/file.c =A0 =A0 =A0| =A0533 ++++++++++++++++++++++++++++++=
++++++++++++++++-----
>> =A04 files changed, 538 insertions(+), 52 deletions(-)
>>
>
> This patchset seems to fix the regression in the earlier one. I've al=
so
> looked over it and don't see any obvious problems. Let's get this
> merged early so it can get the full testing cycle for 3.2.
>
> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks for the review!

Steve, can you look at these 4 patches, please?

--=20
Best regards,
Pavel Shilovsky.
