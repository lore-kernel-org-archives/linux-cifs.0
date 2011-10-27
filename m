From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Thu, 27 Oct 2011 17:02:17 -0500
Message-ID: <CAH2r5mu-km=z43=b3VP_541zgV3hDiZyZ_3qKKH6TZ=Fs9Rj_A@mail.gmail.com>
References: <CAH2r5msFde8+dBW1uku_=qv5maXcypoM3cXWCAOK3pbEKv=86w@mail.gmail.com>
	<20111027210722.GA29989@infradead.org>
	<CAH2r5mvCDTE91Mj-HAm_WhSTrzHKi6RNvBL0-+e92POxeqXA9w@mail.gmail.com>
	<20111027211515.GA1380@infradead.org>
	<CAH2r5muqCFmvUm=LtKieWdQdaz0Rm351DKJ1uDPtYpO0q79fRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muqCFmvUm=LtKieWdQdaz0Rm351DKJ1uDPtYpO0q79fRw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I have pushed a branch without the smb2 changes but
with the other cifs fixes to the 3-2-without-smb2 branch
of git://git.samba.org/sfrench/cifs-2.6.git

Note that the primary difference between what Pavel reposted 3 days ago
and earlier version(s) were the fixups for merge conflicts with Jeff's
large async read patch series and various other recent cifs patches

On Thu, Oct 27, 2011 at 4:17 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> On Thu, Oct 27, 2011 at 4:15 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org=
> wrote:
>> I'm not complaining about Pavel - he has generally done outstanding
>> work.
>>
>> But patches posted the first time in that form two days ago (and the
>> first time completely for a long time) are simply not suitable for
>> this merge window. =A0I talked with Jeff about them very briefly at =
Kernel
>> Summit and we will review them, and they will almost certainly need
>> another respin or two.
>
> I don't mind respin - of course they need fixes. =A0I found two addit=
ional
> cleanup fixes today (error messages in the readdir path for example).
> Pavel requested that it be marked "BROKEN" (or DEVELOPER) as it
> is until those and a few others are fixed.
>
> Realistically though, a good chunk of this is very similar to the
> July 26th posting and that is 4 months ago, and he reposted to list
> at least twice more, as well as discussing on linux-fsdevel and linux=
-cifs
>
>
>
> --
> Thanks,
>
> Steve
>



--=20
Thanks,

Steve
