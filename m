From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/5] cifs: clean up various nits in unicode routines
Date: Tue, 5 Apr 2011 13:00:21 -0500
Message-ID: <BANLkTimCdEW2NQ2xr-fyhj=brYo9=ec6MA@mail.gmail.com>
References: <1301607405-4379-1-git-send-email-jlayton@redhat.com>
	<1301607405-4379-6-git-send-email-jlayton@redhat.com>
	<BANLkTino1a1Wr55BCynPGK176Zbm5DPcXw@mail.gmail.com>
	<20110405103209.75fb7da5@corrin.poochiereds.net>
	<7828.1302026339@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7828.1302026339-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

+                       charlen =3D cp->char2uni(source + i, srclen - i=
,
+                                               (wchar_t *)&temp);
+                       temp =3D cpu_to_le16(temp);


On Tue, Apr 5, 2011 at 12:58 PM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Tue, 5 Apr 2011 12:23:40 -0500
>> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> > The patch is fine except that I would prefer that it not introduce=
 a
>> > sparse warning
>> > (this would be the only endian warning). See below:
>> >
>> > =A0 CHECK =A0 fs/cifs/cifs_unicode.c
>> > fs/cifs/cifs_unicode.c:309:32: warning: cast from restricted __le1=
6
>> > =A0 CC [M] =A0fs/cifs/cifs_unicode.o
>> >
>>
>> Good point. I'll need to put a new variable on the stack to fix it, =
but
>> that's no big deal. I'll fix and resend.
>
> Which line is it that actually gives the warning? =A0Is it when 0 is =
implicitly
> cast to __le16? =A0If so, can you just cast it directly?
>
> David
>



--=20
Thanks,

Steve
