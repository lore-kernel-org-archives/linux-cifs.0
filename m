From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS
Date: Mon, 15 Aug 2011 13:09:01 -0500
Message-ID: <CAH2r5mube6=0h_G=rvyWJs_ispNSmEQ3+zekazd6nKESs6FkvQ@mail.gmail.com>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan>
	<alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net>
	<20110815064734.403b630f@corrin.poochiereds.net>
	<alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
	<alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Piszcz <ap-SDpCatL+S6WaMJb+Lgu22Q@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1108151357200.32349-0qmrozcXWo8bm2hyYBkBBg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

With the more current cifs (ie  patches applied) does it fail on the
mount? or after the mount on the df -h that you mentioned in your
earlier note?

Not immediately obvious to me if the oops has much to do with cifs
code given the call stack, but we may be able to determine a little
more by looking at a wireshark trace of the last network request
and/or response (presumably parsing a cifs QFSInfo response from
Windows 7).

I also run Windows 7 64 server in our test environment, will rebuild
on laster 3.0.1-rc2 and retry but I would be surprised if I can
reproduce this.

On Mon, Aug 15, 2011 at 1:01 PM, Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org=
> wrote:
>
>
> On Mon, 15 Aug 2011, Justin Piszcz wrote:
>
>>
>>
>> On Mon, 15 Aug 2011, Jeff Layton wrote:
>>
>>> On Mon, 15 Aug 2011 11:18:38 +0200 (CEST)
>>> Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org> wrote:
>>>
>>> There was at least one known oops at mount time with 3.0:
>>>
>>> =A0 https://bugzilla.redhat.com/show_bug.cgi?id=3D727927
>>>
>>> ...but I can't tell whether you hit that w/o seeing the oops messas=
ge.
>>>
>>> It should be fixed in mainline and the patches for that and another
>>> mount time problem will be in the next set of stable kernels. You m=
ay
>>> want to pull these two commits into your kernel and try again:
>>>
>>> 80975d21aae2136ccae1ce914a1602dc1d8b0795
>>> f9e8c45002cacad536b338dfa9e910e341a49c31
>>>
>>
>> Thanks,
>>
>> Patches applied to 3.0.1 and will try to mount the CIFS shares later
>> today:
>>
>> # patch -p1 < /home/war/cifs1
>> patching file fs/cifs/cifsfs.c
>> # patch -p1 < /home/war/cifs2
>> patching file fs/cifs/inode.c
>>
>> Justin.
>>
>>
>
> Hello,
>
> It crashed again with the patches, this time I got a picture:
> http://home.comcast.net/~jpiszcz/20110815/26030-kernel-crash-when-cif=
s-mount.jpg
>
> The machine is up no issues until you try and mount a CIFS share, the=
n
> the problem occurs, every time (and with the patches as well).
>
> 3.0.1+80975d21aae2136ccae1ce914a1602dc1d8b0795
> =A0 =A0 +f9e8c45002cacad536b338dfa9e910e341a49c31
>
> Same result.
>
> Justin.
>
>



--=20
Thanks,

Steve
