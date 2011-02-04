From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs: don't always drop malformed replies on the floor
Date: Fri, 4 Feb 2011 09:22:52 -0600
Message-ID: <AANLkTiniSV+ys2nnTjiBtncr3QccppbFVXEHWiiUxpXX@mail.gmail.com>
References: <AANLkTim4p3fT4Sa6aoqqr1sBAFv8a6_7RLYOi2j2fP8s@mail.gmail.com>
	<20110204071659.448565ba@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110204071659.448565ba-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Feb 4, 2011 at 6:16 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 3 Feb 2011 23:01:45 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Looking at this comment in the patch:
>>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* FIXME: why 48 bytes?
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 length =3D checkSMB(smb_buffer, smb_buffer=
->Mid, total_read);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (length !=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_dump_mem("Bad SMB: =
", smb_buffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 total_read < 48 ? total_read : 48);
>>
>>
>> got me thinking, if you prefer a longer length that is fine. =A0 To
>> avoid huge log entries, while still dumping the most useful info, th=
e
>> original length dumped was limited. =A048 bytes was chosen because i=
t
>> printed 3 lines of 16 to log and thus would include the most importa=
nt
>> parts of the SMB (past wct). =A0It is large enough to fit a close
>> request and response, although about 10 bytes to small for getting a=
ll
>> of a SMB ReadX request. =A0 It would probably be fine to make that 6=
4
>> bytes if you prefer. =A0 If we made it smaller (e.g. 32 instead of 4=
8)
>> IIRC we wouldn't get wct.
>
> The length doesn't much matter to me. What does matter is that this
> would do a cifs_dump_mem for 48 bytes even when the client received
> less than 48 bytes. Granted, the buffers are larger than that so I
> don't think there's any danger of a buffer overrun or anything, but t=
he
> stuff at the end could just be garbage or zeroed out.

Yes, agreed.  I liked that change.  It improves
readability of debug info.

--=20
Thanks,

Steve
