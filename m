From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: problem mounting under Xubuntu
Date: Sun, 27 Nov 2011 22:58:07 -0600
Message-ID: <CAH2r5mvsCUDan7SsdVwMpzN=9wvTVYqjqj8z-5FP6PFsdg-Lwg@mail.gmail.com>
References: <4ED3017A.9030502@gmail.com>
	<jav15j$o70$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <jav15j$o70$1@dough.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Although this is a very, very old version of Samba (3.0) in your NAS bo=
x,
I am surprised that it is returning ERROR_STATUS_NOT_SUPPORTED
on GetDFSReferral

Anyone know when that was added to Samba (I thought Samba 3.0
supported it all along).

On Sun, Nov 27, 2011 at 10:03 PM, jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
> sorry about the double posting, had problem setting up.
>
> having scanned through last few posts, I hope I've subscribed to the =
correct
> list.
>
> additional information about s/ware:
>
> cat /etc/debian_version
> wheezy/sid
>
> mount.cifs -V
> mount.cifs version: 5.0
>
> dpkg -l | grep util-linux
> ii =A0util-linux =A0 =A0 =A02.19.1-2ubuntu3 =A0 =A0 =A0Miscellaneous =
system utilities
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
