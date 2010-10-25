From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: CIFS is slooow, gvfs is fast
Date: Mon, 25 Oct 2010 15:44:44 +0530
Message-ID: <4CC55894.5040509@suse.de>
References: <20101022013544.0fdab0e0@werewolf.home>	<4CC16B1E.4060709@suse.de>	<20101023004636.1acdd81c@werewolf.home> <20101024013038.057442c0@werewolf.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon-sh/6fXdz2Rs@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101024013038.057442c0-BIo4oXGMtDgJmsy6czSMtA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/24/2010 05:00 AM, J.A. Magall=C3=B3n wrote:
> On Sat, 23 Oct 2010 00:46:36 +0200, "J.A. Magall=EF=BF=BDn" <jamagall=
on-sh/6fXdz2Rs@public.gmane.org> wrote:
>=20
>>
>> If you mean hardware network path (cabling, router), yes.
>> For file paths, CIFS fs is under /net/htpc/media, and gvfs uses a mo=
unt
>> point on '~/.gvfs/media on htpc'.
>>
>> And here comes the weird part. To rule out the desktop environment f=
actor,
>> I tried a dd in both paths. On /net, I get 16.6 MB/s, and on
>> ~/.gvfs/xxx, I just get 5.5 MB/s. I really don't understand anything=
=2E..
>> things get reversed depending if you use a gui or commandline.
>>
>> Weird, really weird...
>>
>=20
> Well, to sort things out, I did some more tests (this does not mean t=
hings
> get any closer to be clear for me at least...).
>=20
> Can anybody tell me whats going here...??
> It looks just like gui tools behave just in reverse of cli, and that =
a plain
> smbclient is faster that cifs. I'm really confused...
>=20

Could you try mounting from commandline with something like
  `mount -t cifs //server/share /mnt/point -o user=3Duser1`
(commenting out the fstab entry) and try copying the file?


--=20
Suresh Jayaraman
