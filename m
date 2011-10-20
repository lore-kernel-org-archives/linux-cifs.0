From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Assume passwords are encoded according to iocharset
 (try #2)
Date: Thu, 20 Oct 2011 16:13:07 -0500
Message-ID: <CADT32e+koH9V05R=c7bTOLd8GG=FFRWVJ60RuwaCpufnPx8gzg@mail.gmail.com>
References: <1319134919-4300-1-git-send-email-shirishpargaonkar@gmail.com>
	<20111020151300.5fd507ba@tlielax.poochiereds.net>
	<CAH2r5mt4DgW-EHt+2Fh+U67cqbiUFArKRhx5XFm=ETS8cmXmOw@mail.gmail.com>
	<20111020163006.006fea2e@tlielax.poochiereds.net>
	<20111020205113.GA26966@osk.mine.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111020205113.GA26966-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 20, 2011 at 3:51 PM, Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org> wrote:
> On Thursday, October 20, 2011 at 16:06, Jeff Layton wrote:
>
> [..]
>> > > I don't know about this. What happens if I have characters in my
>> > > password that are not part of the current iocharset? I guess I'm
>> > > screwed?
>> > >
>> > > The iocharset (and on smbfs, the remotenls) really only referred to the
>> > > encoding/decoding of filenames. What's the justification for assuming
>> > > that the password ought to be governed by that as well?
>> > >
>> > > If you're mounting with a cred file, is it really correct to assume
>> > > that it's encoded according to the local charset? It seems like if I
>> > > have the password stored in a credential file that it ought to work
>> > > even if I copy it to a host that uses a different iocharset for
>> > > encoding and decoding filenames.
>> > >
>> > > Would it be better to have userspace encode the password instead so
>> > > that you have some flexibility if it's impossible to encode your
>> > > password in the current iocharset?
>> >
>> > that is an interesting point - but if we do pass a new optional type
>> > of password blob down, we will have to make sure to overwrite/clear it
>> > carefully.
>> >
>> >
>>
>> I don't think this requires any kernel changes. Just have the kernel
>> treat the password as opaque like it does today.
>>
>> Again, I'm not saying this for certain. Maybe this patch makes the most
>> sense after all. But, I think we need some justification before we just
>> assume that decoding it according to the iocharset is the right thing
>> to do here.
>
> I like the idea of opaque passwords as well, but the problem is that the
> password needs to be in UCS-2 for smb. The password is passed through
> _my_mbstowcs which converts the 8-bit password to 16-bit UCS-2 simply
> by setting high byte to zero. So that makes op8

I think more than utf8 or ucs2, it is whether a character can even
if converted to unicode i.e. if my current code page does not have
that character, char2uni of that code page is going to return an
error so there is no question of ucs2 or utf8.

>
> Regards,
>
> Oskar
>
