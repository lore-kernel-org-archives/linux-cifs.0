From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: problem mounting under Xubuntu
Date: Mon, 28 Nov 2011 12:16:31 +0100
Message-ID: <CANXojcyMt6u=K-eSrRWGWQSQ2Haw-HhqegCXa3t1sMj826rfPQ@mail.gmail.com>
References: <4ED3017A.9030502@gmail.com>
	<jav15j$o70$1@dough.gmane.org>
	<CAH2r5mvsCUDan7SsdVwMpzN=9wvTVYqjqj8z-5FP6PFsdg-Lwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvsCUDan7SsdVwMpzN=9wvTVYqjqj8z-5FP6PFsdg-Lwg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Maybe add the parameter/option ip=3D....
Some time ago I had a simular error. Adding the ip helped.

Stef

2011/11/28 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Although this is a very, very old version of Samba (3.0) in your NAS =
box,
> I am surprised that it is returning ERROR_STATUS_NOT_SUPPORTED
> on GetDFSReferral
>
> Anyone know when that was added to Samba (I thought Samba 3.0
> supported it all along).
>
> On Sun, Nov 27, 2011 at 10:03 PM, jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
>> sorry about the double posting, had problem setting up.
>>
>> having scanned through last few posts, I hope I've subscribed to the=
 correct
>> list.
>>
>> additional information about s/ware:
>>
>> cat /etc/debian_version
>> wheezy/sid
>>
>> mount.cifs -V
>> mount.cifs version: 5.0
>>
>> dpkg -l | grep util-linux
>> ii =C2=A0util-linux =C2=A0 =C2=A0 =C2=A02.19.1-2ubuntu3 =C2=A0 =C2=A0=
 =C2=A0Miscellaneous system utilities
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
>
> --
> Thanks,
>
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
