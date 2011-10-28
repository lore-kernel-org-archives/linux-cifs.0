From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Fri, 28 Oct 2011 10:07:50 -0500
Message-ID: <CAH2r5mvtMv-GiQ5R1Xbdh4zEatLZ12Kf37YL1CTZ9hiOs0L=Ow@mail.gmail.com>
References: <CAH2r5msFde8+dBW1uku_=qv5maXcypoM3cXWCAOK3pbEKv=86w@mail.gmail.com>
	<20111027210722.GA29989@infradead.org>
	<CA+55aFy1BtNSjti8SrEgy-Kc9FWr4gKPx0ytyW=47J+JnaHpHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFy1BtNSjti8SrEgy-Kc9FWr4gKPx0ytyW=47J+JnaHpHQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 28, 2011 at 9:28 AM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Thu, Oct 27, 2011 at 2:07 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org=
> wrote:
>> Clear NAK. =A0The SMB2 support has been posted a couple of days ago,=
 and
>> both Jeff and me as likely reviewers had been travelling during that
>> time, nevermind that a totally new feature really needs more baking =
time
>> than half a week.
>
> Thanks for catching that.
>
> And in general, I *really* want code to have been in linux-next for
> this merge window (although rebasing has made it annoyingly hard to
> check that).

Yes - rebasing these on top of Jeff's large async series among others,
and dealing
with various merge conflicts, was the main reason that the smb2 part
of the series was put in last (4 days ago, and linux-next wasn't
respun since the 23rd).  Most of these aren't new patches (except
obviously for the rebasing),  Pavel has updated them, and they have
been in my tree before.

I will repost the pull request with the branch that takes the smb2
patches out to give more time to others to re-review Pavel's smb2
work.

--=20
Thanks,

Steve
