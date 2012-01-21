From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: eliminate CONFIG_CIFS_WEAK_PW_HASH
Date: Fri, 20 Jan 2012 20:47:14 -0600
Message-ID: <CAH2r5mtxiDbEP2y7op9LOC+azaNeoMdhdqEQbNUiTeAhQNKJKw@mail.gmail.com>
References: <1327091153-22391-1-git-send-email-jlayton@redhat.com>
	<CAH2r5msOk=4rz_XUGi+GitzVGyJrSo9B1iGXdjz0Bnymzt0NyQ@mail.gmail.com>
	<20120120153856.6ded308a@tlielax.poochiereds.net>
	<CAH2r5ms6YbZp+erat9RQw7-vMxem6vLWp72Yaf=Z8d4p=4+BBQ@mail.gmail.com>
	<20120120160105.5e2f7286@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120120160105.5e2f7286-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jan 20, 2012 at 3:01 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Fri, 20 Jan 2012 14:45:48 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> My general thinking on this is as follows:
>>
>> If the kernel is distributed to all the workstations in an organizat=
ion
>> with this Kconfig option disabled, it makes it harder for individual=
 users
>> to make the mistake of enabling lanman (sec=3Dlanman, or the Kconfig
>> option) on a public network and thus send weak password hashes
>> which could be discovered simply. =A0 Most distros make the choice
>> of enabling broader compatibility with old pre-1997 servers but
>> it is a very small set of servers who would require lanman support,
>> and a large number of potential attackers who could benefit if
>> users enable lanman on a public network. =A0I suspect that there
>> are environments where removing code (via Kconfig) is preferred
>> to trusting all owners of all workstations running that organization=
s
>> standard linux to never enable lanman at runtime.
>>
>> But ... the opinion of security specialists on this would be welcome=
=2E
>>
>
> There are myriads of ways for someone to screw themselves if you give
> them root access. This one is pretty low on the list.
>
> Code quality is important for security too, and the writhing mass of
> ifdefs below is impossible to parse by eye and therefore debug. At so=
me
> point we have to weigh what requires a Kconfig option, and what doesn=
't.
>
> Given that this can be administratively prohibited at runtime, I see
> absolutely no need to keep this Kconfig option around. It just adds a
> maintenance burden for no benefit.
>
> While it's well and good to say you want to hear from "security
> specialists", I'm not sure what that means and it sounds awfully open
> ended. Is a lack of objection sufficient for you to take this patch o=
r
> do you need something else?

We can give some time for users to respond or perhaps paraphrase the
general question and put on lkml and see if anyone comments.

I agree that removing the ifdef would simplify the code but would be
helpful to see if there are those who turn on the Kconfig for reasons
similar to what I described

--=20
Thanks,

Steve
