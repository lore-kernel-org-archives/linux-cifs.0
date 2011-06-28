From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS VFS errors
Date: Mon, 27 Jun 2011 21:23:35 -0500
Message-ID: <BANLkTimLy=UvgybscbJYMZ7H5k0B4yQXFg@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shane McColman <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E6636E53DE0A4D2688B177557D4D19F2-WkVietXGWdS4IGBGpn4MSbjjLBE8jN/0@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I don't think you should need to set max_pending below 9 (I am trying
to determine
if 10 is ok, or whether XP reserves one for async oplock breaks) since =
this is
a per-socket limit.   We had a long discussion about this at MS Friday
but the questions were about whether it was a number of requests
per-pid (per process)
limit on each connection or whether it was across the connection (socke=
t, as I
expect, and as the documentation implies).   In any case, the number of=
 other
connections from other network clients to the machine should not
affect the number
of simultaneous operations on this Linux client's one connection to XP =
(which
looks to be 10 or 9 depending on how you read the documentation).

On Mon, Jun 27, 2011 at 6:34 PM, Shane McColman
<smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org> wrote:
>
> Kernel errors have dropped significantly (only 2 during the day today=
). =A0No
> errors in copying files.
>
> Thanks for all the help. =A0I really do appreciate it.
>
> Shane
>
>>I verified that Windows XP only allows a max of 10 connections as set=
 by
>>Microsoft. =A0This machine already has 5 connections from the 5 piece=
s of
>>equipment here, so I'm left with 5. For this reason I set
>>cifs_max_pending=3D4
>>to stay on the safe side. =A0That was at 9:30 this morning and have n=
ot had
>>an
>>error since. =A0I'll check again on Monday and give you an update.
>
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
