From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/6] mount.cifs: treat uid=,gid=,cruid= options as name
 before assuming they're a number
Date: Tue, 4 Dec 2012 13:32:24 -0500
Message-ID: <CAFB9KM1Z8P2d3PzmmYNo5=ogfM6CBMO5kN5EphUxNt3vuJBY2A@mail.gmail.com>
References: <1354634204-21602-1-git-send-email-jlayton@samba.org>
	<1354634204-21602-2-git-send-email-jlayton@samba.org>
	<CAFB9KM2DAL+x46oW017HmhZX=+p8bxvFn3FX+K5QDpAUnbUHEQ@mail.gmail.com>
	<20121204132746.72daf64e@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121204132746.72daf64e-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Dec 4, 2012 at 1:27 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, 4 Dec 2012 10:45:19 -0500
> Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Tue, Dec 4, 2012 at 10:16 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
>> > Sergio Conrad reported a problem trying to set up an autofs map to=
 do
>> > a krb5 mount. In his environment, many users have usernames that a=
re
>> > comprised entirely of numbers. While that's a bit odd, POSIX appar=
ently
>> > allows for it.
>> >
>> > The current code assumes that when a numeric argument is passed to=
 one
>> > of the above options, that it's a uid or gid. Instead, try to trea=
t the
>> > argument as a user or group name first, and only try to treat it a=
s a
>> > number if that fails.
>> >
>> > Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>>
>> Yuck.  What happens when a number is both a valid user name and uid?
>> IE, I add a user named "0" (uid=3D5001).  Does getpwnam() return roo=
t
>> (uid=3D0) or 0 (uid=3D5001)?
>>
>
> You'd get back uid=3D5001:
>
>        The getpwnam() function returns a pointer to a structure conta=
ining the
>        broken-out  fields  of  the  record in the password database (=
e.g., the
>        local password file /etc/passwd, NIS, and LDAP) that matches t=
he  user=E2=80=90
>        name name.
>
> If you wanted to get back a struct passwd for uid=3D0 then you'd need=
 to
> use getpwuid() there.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

I missed that; thanks for clarifying.

--=20
Peace and Blessings,
-Scott.
