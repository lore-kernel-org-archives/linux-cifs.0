From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: don't send a mandatory ver= option to the kernel
Date: Thu, 17 May 2012 13:32:59 -0500
Message-ID: <CAH2r5msr+w8soQkXyUYn2NidZCVVy1kgni8t8sG2Eqc4BTF_ZQ@mail.gmail.com>
References: <1336763001-7315-1-git-send-email-jlayton@samba.org>
	<1337273046.2275.1.camel@localhost>
	<CAH2r5muvJ=QUt6MsYQiZpZDWp+GRzviJRnJ6Q7O5eE1zYNOnJg@mail.gmail.com>
	<20120517135437.6af5c851@corrin.poochiereds.net>
	<CAH2r5mviuR0VK-j-G1h9WBzexji92u5KW5x613Xbvb4rAmB-1w@mail.gmail.com>
	<20120517142532.26ef58f9@corrin.poochiereds.net>
	<4FB543D4.4020202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FB543D4.4020202-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, May 17, 2012 at 1:30 PM, Scott Lovenberg
<scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 5/17/2012 2:25 PM, Jeff Layton wrote:
>>
>> On Thu, 17 May 2012 12:58:45 -0500
>> Steve French<smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =A0wrote:
>>
>>> On Thu, May 17, 2012 at 12:54 PM, Jeff Layton<jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> =A0=
wrote:
>>>>
>>>> On Thu, 17 May 2012 12:03:26 -0500
>>>> Steve French<smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =A0wrote:
>>>>
>>>>> On Thu, May 17, 2012 at 11:44 AM, Sachin Prabhu<sprabhu-H+wXaHxf7aJhl2p70BpVqQ@public.gmane.org=
m>
>>>>> =A0wrote:
>>>>>>
>>>>>> On Fri, 2012-05-11 at 15:03 -0400, Jeff Layton wrote:
>>>>>>>
>>>>>>> Traditionally, this ver=3D option was used to specify the "opti=
ons
>>>>>>> version" that we're passing in. It has always been set to '1' t=
hough
>>>>>>> and we have never changed that.
>>>>>>>
>>>>>>> Eventually we want to have a ver=3D (or vers=3D) option that al=
lows users
>>>>>>> to specify the SMB version that they want to use to talk to the
>>>>>>> server.
>>>>>>>
>>>>>>> At that point, this option will just get in the way. Let's go a=
head
>>>>>>> and remove it now in preparation for that day.
>>>>>>>
>>>>>> Do we need 'ver=3D' mount option to specify the SMB version numb=
er?
>>>>>> Isn't
>>>>>> 'vers=3D' sufficient for this?
>>>>>
>>>>> Yes - "vers" is sufficient (although I am fine with adding synony=
ms to
>>>>> make it easier for nfs users - e.g. "smbvers=3D" or if we want to=
 have
>>>>> smb2 specific utility programs (e.g. for a phone or tablet) that =
call
>>>>> do_mount automatically set vers=3D2.1.
>>>
>>> ...
>>>>
>>>> Yes, I don't think we're going to use ver=3D as a synonym for vers=
=3D.
>>>>
>>>> That said, we haven't needed a way for the kernel to recognize the
>>>> userspace "options version" and no other userspace mount helper th=
at
>>>> I'm aware of has such a thing. After all, a userspace mount helper
>>>> isn't even required...someone can mount cifs just fine w/o one as =
long
>>>> as they pass in ip=3D.
>>>>
>>>> Handling an options version is more of a problem with binary mount
>>>> options, where you need to know if you're breaking the ABI. With t=
ext
>>>> based options, it's just not an issue.
>>>>
>>>> So I think going ahead and getting rid of this in the kernel is th=
e
>>>> right thing to do. It's just useless cruft that may get in the way=
 in
>>>> the future.
>>>>
>>>> If the kernel ever needs to determine the mount helper "version" f=
or
>>>> some reason, then it can treat a lack of ver=3D at all identically=
 to how
>>>> it handles a helper that passes in ver=3D1.
>>>
>>> The main case I can think of is debugging - there were a few times
>>> that I have wanted to know the mount.cifs version in looking at dme=
sg
>>> output of mount failures. =A0 On a normal linux distro you can go t=
o the
>>> package manager or simply go to bash and type mount.cifs -V that is=
n't
>>> as practical on a phone or on some Linux tablets.
>>>
>>
>> If that's the case, then what we have now is completely inadequate t=
o
>> that task, since the mount helper has always passed in "ver=3D1". Th=
at
>> doesn't tell you anything about the actual version in use.
>>
> Stupid question, if you just want an entry in dmesg (or whatever logg=
ing),
> why does it need to be thrown over the wall to the kernel? =A0Can't i=
t be
> logged from the mount helper at launch time?
>
> At one point I know that we found a parsing error in the kernel mount=
ing
> code that wasn't in the mount helper code (I can dig it up if anyone =
cares).
> =A0Doesn't going down this road mean matching up the mount helper wit=
h a
> specific range of kernels for full compatibility. =A0Right now it's f=
airly
> loosely coupled and that's a good thing IMHO.

Yes - we could probably do this in mount.cifs - perhaps with
a new debugging or a maximal verbose option but since
we already have debug messages in kernel
for mount that get turned on when debugging is enabled.

Since mount.cifs is optional - I agree that we don't want tight couplin=
g.
The general problem I see is that it is hard to change calls to
mount.cifs for debugging (perhaps on a phone)
but somewhat easier for the kernel.

--=20
Thanks,

Steve
