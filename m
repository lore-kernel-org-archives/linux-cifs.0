From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Assume passwords are encoded according to iocharset
 (try #2)
Date: Fri, 21 Oct 2011 10:10:51 -0500
Message-ID: <CADT32eJsyxGO3UdoFnTpEHNfw7G+V-CB_awbwHdzp_NUY3wjAQ@mail.gmail.com>
References: <1319134919-4300-1-git-send-email-shirishpargaonkar@gmail.com>
	<20111020151300.5fd507ba@tlielax.poochiereds.net>
	<CAH2r5mt4DgW-EHt+2Fh+U67cqbiUFArKRhx5XFm=ETS8cmXmOw@mail.gmail.com>
	<20111020163006.006fea2e@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111020163006.006fea2e-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 20, 2011 at 3:30 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On Thu, 20 Oct 2011 14:29:25 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Thu, Oct 20, 2011 at 2:13 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
>> > On Thu, 20 Oct 2011 13:21:59 -0500
>> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> >
>> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >>
>> >>
>> >> Re-posting a patch originally posted by Oskar Liljeblad after
>> >> rebasing on 3.2.
>> >>
>> >>
>> >> Modify cifs to assume that the supplied password is encoded accor=
ding
>> >> to iocharset. =C2=A0Before this patch passwords would be treated =
as
>> >> raw 8-bit data, which made authentication with Unicode passwords =
impossible
>> >> (at least passwords with characters > 0xFF).
>> >>
>> >> The previous code would as a side effect accept passwords encoded=
 with
>> >> ISO 8859-1, since Unicode < 0x100 basically is ISO 8859-1. =C2=A0=
Software which
>> >> relies on that will no longer support password chars > 0x7F unles=
s it also
>> >> uses iocharset=3Diso8859-1. =C2=A0(mount.cifs does not care about=
 the encoding so
>> >> it will work as expected.)
>> >>
>> >> Signed-off-by: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
>> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> Tested-by: A <nimbus1_03087-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
>> >
>> >
>> > I don't know about this. What happens if I have characters in my
>> > password that are not part of the current iocharset? I guess I'm
>> > screwed?
>> >
>> > The iocharset (and on smbfs, the remotenls) really only referred t=
o the
>> > encoding/decoding of filenames. What's the justification for assum=
ing
>> > that the password ought to be governed by that as well?
>> >
>> > If you're mounting with a cred file, is it really correct to assum=
e
>> > that it's encoded according to the local charset? It seems like if=
 I
>> > have the password stored in a credential file that it ought to wor=
k
>> > even if I copy it to a host that uses a different iocharset for
>> > encoding and decoding filenames.
>> >
>> > Would it be better to have userspace encode the password instead s=
o
>> > that you have some flexibility if it's impossible to encode your
>> > password in the current iocharset?
>>
>> that is an interesting point - but if we do pass a new optional type
>> of password blob down, we will have to make sure to overwrite/clear =
it
>> carefully.
>>
>>
>
> I don't think this requires any kernel changes. Just have the kernel
> treat the password as opaque like it does today.
>
> Again, I'm not saying this for certain. Maybe this patch makes the mo=
st
> sense after all. But, I think we need some justification before we ju=
st
> assume that decoding it according to the iocharset is the right thing
> to do here.
>
> - --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.18 (GNU/Linux)
>

I think this patch is good enough.

I set these two different passwords on the Samba server

al=C3=BEiz=C3=B4
=E9=9A=B6=E4=B9=A6

and both the times, with utf8 as a codepage on the client,
mount succeeded.
It appears that the default utf8 codepage, has large
enough (perhaps all of Unicode's repertoir) to
convert a character to unicode.

mount -t cifs //server/share /mnt/smb_b -o iocharset=3Dutf8,user=3Droot=
%al=C3=BEiz=C3=B4

mount -t cifs //server/share /mnt/smb_b -o iocharset=3Dutf8,user=3Droot=
%=E9=9A=B6=E4=B9=A6

I did not have to specify iocharset.

Regards,

Shirish
