From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Problems with CVS on CIFS since kernel 2.6.30
Date: Mon, 02 Aug 2010 22:10:20 +0530
Message-ID: <4C56F4F4.5010903@suse.de>
References: <AANLkTingdjU-KKW3=KboAnR0pNeiE7aEje0nXhM6bYbe@mail.gmail.com>	<4C56DBDD.4070501@suse.de>	<AANLkTin9uwwDaw+nvAiDKnPxPbbBXycVS3rLvhCaoJxQ@mail.gmail.com>	<4C56E564.3020508@suse.de> <AANLkTikqgFHX=9quJmJyQvkX-3ZreLGoF0k5YKCFq+WW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jon Bramley <brammers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikqgFHX=9quJmJyQvkX-3ZreLGoF0k5YKCFq+WW-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/02/2010 09:26 PM, Jon Bramley wrote:
> On 2 August 2010 16:33, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>> If upgrading is not feasible, could you try patching Samba server wi=
th
>> this patch (relatively very less risk):
>> =EF=BF=BD =EF=BF=BDhttp://www.mail-archive.com/samba-cvs-w/Ol4EcudpnDHl7Qnj/AWg@public.gmane.org=
=2Eorg/msg55843.html
>>
>> I think that should help resolving the bug with posix opens against
>> older server.
>>
>>>>> strange thing, is that some of my colleagues run Ubuntu 10.04, wh=
ich
>>>>> uses the 2.6.32 kernel, and they can use the share without proble=
m.
>>>
>>>> What is the server version in this case?
>>>
>>> Exactly the same server that I'm connecting to (3.0.28a).
>>
>> Strange.. Any idea whether the Ubuntu kernel is the released 2.6.32
>> kernel or any -rc version of 2.6.32?
>=20
> Just checked on a colleagues machine, and uname -r reports 2.6.32-24-=
generic
>=20
> Also checked the dmesg on the Ubuntu 10.04 box:
>=20
> The exact same errors that I get appear, which leads me to believe
> that this in itself is not the cause of my issue.
>=20
> Any other ideas to debug further?
>=20

Perhaps, try enabling debugging as mentioned in the url below before yo=
u
do the operation (for both the clients) and post

   http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting

But, I still think the real problem is the server-side one and perhaps
the Ubuntu client has just got lucky in this case..

Thanks,

--=20
Suresh Jayaraman
