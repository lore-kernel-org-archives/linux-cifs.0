From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Possible CIFS bug - open one file, get another
Date: Sun, 27 May 2012 23:08:50 -0500
Message-ID: <CAH2r5ms+QpPxz1g80Yx_qAGopqfjMVkJc2+s10000LShXv0pog@mail.gmail.com>
References: <loom.20120528T051852-75@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Stromberg <strombrg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20120528T051852-75-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A network trace such as from wireshark or netmon (e.g. attached to a
bug report) would help - as it would let us compare a working and
failing scenario and see if the client is sending the wrong file name
or the server is opening the wrong file in response to a request to
open the correct file.

There is additional information at
http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting

On Sun, May 27, 2012 at 10:22 PM, Dan Stromberg <strombrg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
>
> Hi folks.
>
> I have what may be an in-kernel CIFS filesystem bug.
>
> It seems that if I open a specific file, I get the contents of a diff=
erent file
> back.
>
> This may or may not have security implications.
>
> Oddly, if I read the file with the same code in CPython 2.x, CPython =
3.x or Pypy
> (recent trunk), I see the error. =A0But if I run exactly the same cod=
e on Jython
> 2.5.x, it works fine.
>
> Also, if I reboot, things work OK for a while.
>
> And if I umount+mount, that works too.
>
> I ran across the issue, because I have a backup program I've been wri=
ting for
> fun, and it saves the same timestamp inside a file, and in its filena=
me. =A0When I
> assert that the two are the same within some smallish tolerance, the =
assertion
> sometimes fails, as described above.
>
> Is there a bugtracker somewhere that such an issue should go into?
>
> Has this already been fixed in later kernels?
>
> I'm on Linux Mint 12, kernel 3.0.0-12-generic.
>
> Thanks!
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
