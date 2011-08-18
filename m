From: Kong Li <likong@gmail.com>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
Date: Thu, 18 Aug 2011 10:36:01 -0700
Message-ID: <CADQjK6UVLvJShjnNvMND1pcVm0gO4--2hncWKcGyXziOg+4pkA@mail.gmail.com>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan>
	<alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net>
	<20110815064734.403b630f@corrin.poochiereds.net>
	<alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
	<alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
	<alpine.DEB.2.02.1108171515050.5877@p34.internal.lan>
	<3300.1313637592@jrobl>
	<alpine.DEB.2.02.1108180632000.10458@p34.internal.lan>
	<alpine.DEB.2.02.1108180807070.7903@p34.internal.lan>
	<alpine.DEB.2.02.1108180821440.7903@p34.internal.lan>
	<20110818091140.385a9455@barsoom.rdu.redhat.com>
	<alpine.DEB.2.02.1108180914180.7903@p34.internal.lan>
	<20110818130408.71c55b96@barsoom.rdu.redhat.com>
	<alpine.DEB.2.02.1108181314310.7903@p34.internal.lan>
	<CAH2r5mvNkUWh0rYTbTEWmUPiRsxUbmrGNpTOaebiG0CCKRfA1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>,
	Jeff Layton <jlayton@samba.org>,
	"J. R. Okajima" <hooanon05@yahoo.co.jp>,
	Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mvNkUWh0rYTbTEWmUPiRsxUbmrGNpTOaebiG0CCKRfA1g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

http://support.microsoft.com/kb/307257

On Thu, Aug 18, 2011 at 10:25 AM, Steve French <smfrench@gmail.com> wro=
te:
> On Thu, Aug 18, 2011 at 12:16 PM, Justin Piszcz <jpiszcz@lucidpixels.=
com> wrote:
>>
>>
>> On Thu, 18 Aug 2011, Jeff Layton wrote:
>>
>>> On Thu, 18 Aug 2011 09:15:36 -0400 (EDT)
>>> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>>
>>>>
>>>>
>>>> On Thu, 18 Aug 2011, Jeff Layton wrote:
>>>>
>>>>> On Thu, 18 Aug 2011 08:22:44 -0400 (EDT)
>>>>> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>>>>
>>>>>> Justin.
>>>>>>
>>>>>
>>>>> To be clear -- incoming in this case is reads or writes?
>>>>
>>>> Reading from the CIFS share (Windows 7).
>>>>
>>>>>
>>>>> Up until 3.0 cifs.ko didn't parallelize writes from a single thre=
ad. In
>>>>> 3.0 I added a patchset to increase the allowable wsize and to all=
ow the
>>>>> kernel to issue writes in parallel.
>>>>
>>>> Ahh, good to know, have not tried writes yet.
>>>>
>>>>>
>>>>> Reads still suffer from the same problem however. I'm working on =
a
>>>>> patchset that should do the same thing for them, but it requires =
a
>>>>> fairly substantial overhaul of the receive codepaths.
>>>>
>>>> Ok, that explains it then, thanks.
>>
>>
>> Hi,
>>
>> Watching the rsync, it ran for a while, then:
>>
>> rsync: send_files failed to open "/cifs/w1/r1/data/hs12/f4_0.JPG": C=
annot
>> allocate memory (12)
>> rsync: send_files failed to open "/cifs/w1/r1/data/hs12/f4_1.JPG": C=
annot
>> allocate memory (12)
>> rsync: send_files failed to open "/cifs/w1/r1/data/hs12/f4_2.JPG": C=
annot
>> allocate memory (12)
>> rsync: send_files failed to open "/cifs/w1/r1/data/hs12/f4_0.JPG": C=
annot
>> allocate memory (12)
>
> When we were testing async write to Windows 7 Pavel mentioned to me
> another WIndows 7 bug - which may be what you are hitting.
>
> Under stress of simultaneous operations, Windows 7 server will someti=
mes start
> responding with STATUS_INSUFF_SERVER_RESOURCES error code
> (mapped to posix error ENOMEM by the Linux cifs kernel client)
> He solved it by setting MaxWorkItems to 4096 in the Windows 7 registr=
y.
>
> If anyone knows whether Microsoft has fixed this or has a bug #, let =
us know
> because it is easier to hit with Linux kernel 3.0 and later (to
> Windows 7 server).
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
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
