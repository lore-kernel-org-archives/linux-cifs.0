From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS endless console spammage in 2.6.38.7
Date: Tue, 31 May 2011 15:54:36 -0500
Message-ID: <BANLkTimNgW-Ff_50HeuFqmS7PXXjuLmYVw@mail.gmail.com>
References: <4DE5385C.1030808@candelatech.com>
	<BANLkTik+Z32vDVjB3_Rt7iPrqpJPJYnpwA@mail.gmail.com>
	<4DE54561.1090906@candelatech.com>
	<20110531164408.178eeebf@tlielax.poochiereds.net>
	<BANLkTinyb=tekDwPLqxuSqyQfrgc8MykCw@mail.gmail.com>
	<4DE55537.5040705@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DE55537.5040705-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

we will have more info when run with he quick and dirty modified loggin=
g

On Tue, May 31, 2011 at 3:53 PM, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> w=
rote:
> On 05/31/2011 01:51 PM, Steve French wrote:
>>
>> On Tue, May 31, 2011 at 3:44 PM, Jeff Layton<jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =A0=
wrote:
>
>>> Fixing it looks to be anything but trivial. I'm not even quite sure=
 how
>>> to approach it at this point. Suggestions welcome.
>>
>> I thought the kernel was more recent than that - how recent is the k=
ernel
>> here?
>>
>> I think something related to cifs_sendv returning ENOTSOCK immediate=
ly
>> when not reconnected could be related.
>
> My kernel is 2.6.38.7, quite recent. =A0We're using the bind-to-local=
-IP
> features too, but not sure that matters.
>
> Ben
>
> --
> Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
> Candela Technologies Inc =A0http://www.candelatech.com
>
>



--=20
Thanks,

Steve
