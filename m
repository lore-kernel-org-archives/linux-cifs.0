From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] sync_smb2_mid_result
Date: Wed, 23 Mar 2011 13:38:38 -0500
Message-ID: <AANLkTinaCM8mRK4LQMeXPxAsyyU9VyHADyiDXVeJfA2a@mail.gmail.com>
References: <AANLkTinnLUXF3O=AOYG8PrCG1guAA8vkM18wYKSLegk2@mail.gmail.com>
	<20110323120617.0379e0a1@corrin.poochiereds.net>
	<AANLkTinVcBpT7X7A4XKd8+rz0XJw8ms159UnsK5aH49f@mail.gmail.com>
	<20110323135853.69b42c03@corrin.poochiereds.net>
	<AANLkTikTYEtgQVhFpqop658tWsQ_=wQ3Be5FK27Uuxqk@mail.gmail.com>
	<20110323140633.0927ce82@corrin.poochiereds.net>
	<AANLkTikkbxn527XAP1oT-U6yiE6fF-1Rb=+5KNHgQLOm@mail.gmail.com>
	<20110323143243.17abb03c@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110323143243.17abb03c-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Mar 23, 2011 at 1:32 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Wed, 23 Mar 2011 13:26:19 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Wed, Mar 23, 2011 at 1:06 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:>
>> > Maybe you misunderstand me.
>> >
>> > The struct is *exactly the same* aside from a few small difference=
s. It
>> > doesn't even need to be a union, IMO. That would let you use a lot=
 of
>> > the same code in transport.c for smb2.
>>
>> I don't mind trying to condense it to one structure, but it is not t=
hat simple:
>> - smb2 doesn't need or sequence number, and the two transact2
>> multiresponse booleans
>> - cifs mid will grow by at least 10 bytes by expanding the mid, pid
>> etc. to the required minimum sizes.
>> - cifs mid doesn't need "async_response_received" or (that is an smb=
2
>> only feature and that or equivalent is required). =A0When we add cha=
ined
>> commands (common in smb2) then complex_mid or equivalent as well as
>> the command list, the number of the commands received and the last
>> response time of entries will be useless to cifs.
>>
>
> Is it better to add an entirely new set of functions simply because
> you'll have some unused fields in this structure in either case?

=46or allocating/freeing a mid I don't think it matters - it affects a
small number of functions, and will likely diverge more over time (as
smb2 is evolving with new dialects, while cifs, the protocol, is
static) - but I don't feel strongly about it.  I generally would
prefer changing the minimal amount of cifs code, but if we want to
move to one function for both types of mids, then I would prefer a
union so it is harder to accidently use the cifs specific fields in
smb2 and vice versa.



--=20
Thanks,

Steve
