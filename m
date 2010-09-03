From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [cifs srcaddr-v4] cifs: Allow binding to local IP address.
Date: Thu, 2 Sep 2010 23:02:58 -0500
Message-ID: <AANLkTi=ezVf0b1Cu+HBKRb7Sns5+bDeFwpV649Ub_RAs@mail.gmail.com>
References: <1283367606-14030-1-git-send-email-greearb@candelatech.com>
	<20100901171418.44685b74@tlielax.poochiereds.net>
	<4C7EC614.6020505@candelatech.com>
	<20100901203836.2628ce57@tlielax.poochiereds.net>
	<4C7F3111.80808@candelatech.com>
	<20100902065602.6a62825c@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100902065602.6a62825c-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Sep 2, 2010 at 5:56 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Wed, 01 Sep 2010 22:07:29 -0700
> Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:
>
>> On 09/01/2010 05:38 PM, Jeff Layton wrote:
>>
>> >> No warning, it always returns something since the default case ca=
tches
>> >> all others. =A0If I did put the return at the end, then the compi=
ler wouldn't
>> >> catch a case where I forgot to return from one of the case statem=
ents,
>> >> but it's not overly complex code, so I don't care so much either =
way.
>> >> Plz let me know if you still want it at the end.
>> >>
>> >> I also think the WARN_ON is valid, because it can only be a codin=
g bug
>> >> that hits that state, and I'd like it to be as loud as possible w=
hile
>> >> still allowing the user to continue. =A0There are automated tools=
 that
>> >> catch WARN_ON output and post to kernel bug trackers, for instanc=
e.
>> >>
>> >> If you still want a cERROR, I can do that..but I prefer to not wa=
ste
>> >> the space.
>> >>
>> >
>> > It's definitely a coding bug if that fires, but a WARN_ON will mea=
n
>> > nothing to users. It looks scary and is virtually indistinguishabl=
e
>> > from an oops. We'll get a stack trace, but it's unlikely to tell u=
s
>> > much.
>> >
>> > At that point, you might as well make it a BUG(). At least that wa=
y,
>> > we might get a core dump if it fires.
>>
>> I'd like to wrap this up. =A0Please let me know exactly what you wan=
t there
>> and I'll make it so.
>>
>
> Fair enough. We're splitting hairs at this point. Let's just take thi=
s
> as-is. For v5 of the patch:
>
> Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

I do like this patch as well - although not for rc4 but see no problem
with it in the next merge window - unless there is some other feedback
on IPv6 related syntax that I missed.

--=20
Thanks,

Steve
