From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Assume passwords are encoded according to iocharset
 (try #2)
Date: Sat, 29 Oct 2011 22:10:28 -0500
Message-ID: <CAH2r5msD1Tf7PB6a7d9ptcGScqD=hywrVNsxfzQqhTBaW_9R9Q@mail.gmail.com>
References: <1319134919-4300-1-git-send-email-shirishpargaonkar@gmail.com>
	<20111020151300.5fd507ba@tlielax.poochiereds.net>
	<CAH2r5mt4DgW-EHt+2Fh+U67cqbiUFArKRhx5XFm=ETS8cmXmOw@mail.gmail.com>
	<20111020163006.006fea2e@tlielax.poochiereds.net>
	<20111020205113.GA26966@osk.mine.nu>
	<20111020205554.GA27595@osk.mine.nu>
	<CADT32e+1A_xcCQzd86OX1v6G1vG5QHG0AYjXurS8S1=BMMxreQ@mail.gmail.com>
	<1319161284.3105.1250.camel@pico.li.ssimo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319161284.3105.1250.camel-akOVU7JyYd8WIfilqQrPtNi2O/JbrIOy@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 20, 2011 at 8:41 PM, simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Thu, 2011-10-20 at 16:01 -0500, Shirish Pargaonkar wrote:
>> On Thu, Oct 20, 2011 at 3:55 PM, Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>=
 wrote:
>> > On Thursday, October 20, 2011 at 22:13, Oskar Liljeblad wrote:
>> >> I like the idea of opaque passwords as well, but the problem is t=
hat the
>> >> password needs to be in UCS-2 for smb. The password is passed thr=
ough
>> >> _my_mbstowcs which converts the 8-bit password to 16-bit UCS-2 si=
mply
>> >> by setting high byte to zero. So that makes opaque 8-bit password=
s
>> >> impossible. One alternative would be to assume passwords in UTF-8
>> >> regardless of iocharset.
>> >
>> > On another note, it wouldn't surprise me if Microsoft assumes UTF-=
16 rather
>> > than UCS-2 in their CIFS implementation today...
>> >
>> > Oskar
>> >
>> >
>>
>> codepage to unicode conversion does not come into picture during
>> authentication. =A0codepage to unicode conversion comes into picture
>> once you are sending ntlm response blob over.
>> I do not know if ntlm response on machines with different charsets
>> can have that charset specific characters e.g. whether ntlm
>> response blob on a machine with German character set can
>> have an umlaut as part of ntlm response.
>
> Passwords are UTF-16, I do not think it makes any sense in 2011 to
> support anything else but UTF-8 to be honest.
> If you are using codepages on the filesystem for some legacy reason t=
hat
> should still not change the fact the kernel should get a password in
> UTF-8. If your charset does not allow you to type the correct charcte=
r
> for your password you are screwed anyways it doesn't matter if before=
 or
> after the conversion to URF-16
>
> Simo.

Shirish's subsequent explanation made sense. Also Pavel took a look at
this too.  Merged.


--=20
Thanks,

Steve
