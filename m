From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS VFS errors
Date: Tue, 28 Jun 2011 23:01:49 -0500
Message-ID: <BANLkTimS=rMNr08dkEHFhwWwRzey2_6krA@mail.gmail.com>
References: <4BEC36376CA24EBFAA83C16B955BD9CC@dynamicsourcemfg.local>
	<20110608164415.5b8cbf4b@tlielax.poochiereds.net>
	<7A5FF1B06368450BAE39549CE3C621CF@dynamicsourcemfg.local>
	<20110622163251.16499f4b@tlielax.poochiereds.net>
	<AC93F84448C9430AB4B791EE591F2F97@dynamicsourcemfg.local>
	<6753F891F47C4E9CBDFB66A63A8E1367@dynamicsourcemfg.local>
	<BANLkTi=T+=yaQ7MH7g+gmqjFgP2HX4iqJg@mail.gmail.com>
	<BCB6EBAD1FD74D7B91FBD8B0FA614384@dynamicsourcemfg.local>
	<20110623133759.2c3f4aab@barsoom.rdu.redhat.com>
	<8A647BDD88F1473AAE69C405E3C65EB1@dynamicsourcemfg.local>
	<20110623143000.62f882ed@tlielax.poochiereds.net>
	<4C4F2F3EB4B94403969BF63208AB0831@dynamicsourcemfg.local>
	<20110623153533.4adafcd6@tlielax.poochiereds.net>
	<9171CA638C0A474598851C87B7C92CC0@dynamicsourcemfg.local>
	<20110623171112.71cc4e98@tlielax.poochiereds.net>
	<20110623171442.22d13bec@tlielax.poochiereds.net>
	<AB1032AA058748FFA44899ED551710C6@dynamicsourcemfg.local>
	<E6636E53DE0A4D2688B177557D4D19F2@dynamicsourcemfg.local>
	<BANLkTimLy=UvgybscbJYMZ7H5k0B4yQXFg@mail.gmail.com>
	<BANLkTimBnp903nNb6xXgJS9Wh7ik38v5Wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shane McColman <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimBnp903nNb6xXgJS9Wh7ik38v5Wg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I checked more carefully and the more likely reason it worked was that
that client system was running a version (an early version) of my patch
The patch restricts the number of simultaneous
operations to what the server reports as maxmpx.  I will run a better
before/after comparison tomorrow.

On Tue, Jun 28, 2011 at 3:38 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> I tried to recreate this to Windows XP today, but instead of mounting=
 to a
> normal WindowsXP desktop, mounting to a VM - a Windows XP Professiona=
l
> test system (service pack 1 level system) running in virtualbox, and
> was not able to
> get it to fail even though number of simultaneous requests exceeded 1=
0.
>
> Before, when mounting to a normal Windows XP desktop, I had been able=
 to
> make it fail faster with wsize=3D8192 and wsize=3D4096 on the cifs mo=
unt,
> but not mounting to this vm.
>
> I am going to try updating the WindowsXP to a newer service pack leve=
l to
> see if that is what changed and also run with tracing off to see if i=
t
> recreates faster.
>
> What service pack level of Windows XP were you running?
>
> On Mon, Jun 27, 2011 at 9:23 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
>> I don't think you should need to set max_pending below 9 (I am tryin=
g
>> to determine
>> if 10 is ok, or whether XP reserves one for async oplock breaks) sin=
ce this is
>> a per-socket limit. =A0 We had a long discussion about this at MS Fr=
iday
>> but the questions were about whether it was a number of requests
>> per-pid (per process)
>> limit on each connection or whether it was across the connection (so=
cket, as I
>> expect, and as the documentation implies). =A0 In any case, the numb=
er of other
>> connections from other network clients to the machine should not
>> affect the number
>> of simultaneous operations on this Linux client's one connection to =
XP (which
>> looks to be 10 or 9 depending on how you read the documentation).
>>
>> On Mon, Jun 27, 2011 at 6:34 PM, Shane McColman
>> <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org> wrote:
>>>
>>> Kernel errors have dropped significantly (only 2 during the day tod=
ay). =A0No
>>> errors in copying files.
>>>
>>> Thanks for all the help. =A0I really do appreciate it.
>>>
>>> Shane
>>>
>>>>I verified that Windows XP only allows a max of 10 connections as s=
et by
>>>>Microsoft. =A0This machine already has 5 connections from the 5 pie=
ces of
>>>>equipment here, so I'm left with 5. For this reason I set
>>>>cifs_max_pending=3D4
>>>>to stay on the safe side. =A0That was at 9:30 this morning and have=
 not had
>>>>an
>>>>error since. =A0I'll check again on Monday and give you an update.
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
>>
>
>
>
> --
> Thanks,
>
> Steve
>



--=20
Thanks,

Steve
