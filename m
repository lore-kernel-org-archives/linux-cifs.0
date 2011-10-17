From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: mention the required kernel version to make
 cifs.idmap work
Date: Mon, 17 Oct 2011 12:33:45 -0500
Message-ID: <CAH2r5mu3+58ukwMeRQ7yH27Fk2FF2M+_=rri3A=FM8Fyss1wyA@mail.gmail.com>
References: <4E9C19A3.8010009@suse.de>
	<20111017081139.564089db@tlielax.poochiereds.net>
	<CAH2r5msxArv-Hdy6sBVGbNtLcjhwk0EUwGj07H85iOT4KHqiRg@mail.gmail.com>
	<20111017130654.53fd42c4@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sjayaraman-l3A5Bk7waGM@public.gmane.org, linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111017130654.53fd42c4-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Oct 17, 2011 at 12:06 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> On Mon, 17 Oct 2011 11:59:20 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Mon, Oct 17, 2011 at 7:11 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> > On Mon, 17 Oct 2011 17:33:47 +0530
>> > Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>> >
>> >> .. properly in the "NOTES" section.
>> >>
>> >> Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>> >> ---
>> >> =A0cifs.idmap.8.in | =A0 =A03 +++
>> >> =A01 files changed, 3 insertions(+), 0 deletions(-)
>> >>
>> >> diff --git a/cifs.idmap.8.in b/cifs.idmap.8.in
>> >> index f2fa3b2..7adfdc6 100644
>> >> --- a/cifs.idmap.8.in
>> >> +++ b/cifs.idmap.8.in
>> >> @@ -76,6 +76,9 @@ create =A0 =A0 =A0cifs\&.idmap =A0 =A0 * * @sbi=
ndir@/cifs\&.idmap %k
>> >> =A0See
>> >> =A0\fBrequest-key.conf\fR(5)
>> >> =A0for more info on each field\&.
>> >> +.SH "NOTES"
>> >> +.PP
>> >> +For cifs.idmap to work properly you would need a kernel version =
3.0 or above.
>> >> =A0.SH "SEE ALSO"
>> >> =A0.PP
>> >>
>> >
>> > This looks reasonable, but I'm always a bit leery of calling out
>> > specific versions like this. Some distros (e.g. Red Hat's and Nove=
ll's)
>> > will backport features from later kernels, so saying you need a 3.=
0
>> > kernel might be confusing.
>> >
>> > We might want to rephrase this with something like "Support for up=
calls
>> > to cifs.idmap was initially introduced in the 3.0 kernel." It's a
>> > little more weaselly but it isn't false if someone is working with=
 a
>> > kernel that has backported this code.
>> >
>> > Sound reasonable?
>>
>> Yes - also to supplement this data can use the cifs version (display=
ed
>> by modinfo) - presumably with wholesale backport of cifs code the
>> version number could be updated as well.
>>
>
> Except that often, distros pick and choose what new features to
> backport. FWIW, I typically I don't bother bumping the version number
> in the kmod in RHEL since it's more or less meaningless...
if it is a selective backport I agree - I sometimes do whole module
backport (with minor fixups for kabi changes).



--=20
Thanks,

Steve
