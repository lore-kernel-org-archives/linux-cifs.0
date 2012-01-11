From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch] cifs: integer overflow in parse_dacl()
Date: Wed, 11 Jan 2012 12:31:34 -0600
Message-ID: <CAH2r5msciOkxvxTrQrN9mKKCiJvM_anmxU7sag_TGk92LoKEwQ@mail.gmail.com>
References: <20120111074627.GA4519@elgon.mountain>
	<CADT32eLVwQT9V67BX8TkjVHDnQoYS7OqA_-xbnjY57ZXO3EfsA@mail.gmail.com>
	<CAH2r5muDQUL=0HcoFHH3QvP7C2pyy0=S9ESFBcm=qOYg3ESdxQ@mail.gmail.com>
	<20120111132053.467e8cae@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120111132053.467e8cae-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We could calculate max_aces based on a minimum sized ace and maximum
smb frame size (which would be 64K presumably for Windows for
non-Writes, but larger for Samba), but not sure if it is worth the
trouble unless you find a path where we would parse beyond end of
frame,

On Wed, Jan 11, 2012 at 12:20 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> On Wed, 11 Jan 2012 11:24:03 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Wed, Jan 11, 2012 at 9:50 AM, Shirish Pargaonkar
>> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > On Wed, Jan 11, 2012 at 1:46 AM, Dan Carpenter <dan.carpenter@orac=
le.com> wrote:
>> >> On 32 bit systems num_aces * sizeof(struct cifs_ace *) could over=
flow
>> >> leading to a smaller ppace buffer than we expected.
>> >>
>> >> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> >>
>> >> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
>> >> index 72ddf23..c1b2544 100644
>> >> --- a/fs/cifs/cifsacl.c
>> >> +++ b/fs/cifs/cifsacl.c
>> >> @@ -909,6 +909,8 @@ static void parse_dacl(struct cifs_acl *pdacl=
, char *end_of_acl,
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0umode_t group_mask =3D S_IRWXG;
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0umode_t other_mask =3D S_IRWXU | S=
_IRWXG | S_IRWXO;
>> >>
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (num_aces > ULONG_MAX / sizeof(s=
truct cifs_ace *))
>> >
>> > Should an error/warning (like cifs client can't handle these many =
aces or
>> > possible erroneous number of aces sent by server etc.) be logged b=
efore
>> > returning?
>> >
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ppace =3D kmalloc(num_aces * sizeo=
f(struct cifs_ace *),
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GF=
P_KERNEL);
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!ppace) {
>>
>> Perhaps. =A0 Also note that you would overflow maximum smb size if n=
um
>> aces is huge
>> so would you have even gotten this far?
>>
>
> Only if the smb frame is properly formed. It's possible that it's
> corrupt in such a way that the num_aces field is much larger than it
> should be, but the rest of the frame looks OK.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>



--=20
Thanks,

Steve
