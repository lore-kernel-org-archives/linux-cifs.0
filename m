From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/4] cifs: remove /proc/fs/cifs/Experimental
Date: Tue, 7 Dec 2010 14:31:25 -0600
Message-ID: <AANLkTimUKtFdX4fYtVHQPp0K3KrAhi8xG=YXHT9199Gj@mail.gmail.com>
References: <1291731835-1120-1-git-send-email-jlayton@redhat.com>
	<1291731835-1120-5-git-send-email-jlayton@redhat.com>
	<20101207111328.6647c36c@tlielax.poochiereds.net>
	<AANLkTi=_5VYCXpd+WfwcKq50=kN3GRaGVgjfkReM9Ye0@mail.gmail.com>
	<20101207141059.0ddc6c7d@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101207141059.0ddc6c7d-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Dec 7, 2010 at 1:10 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, 7 Dec 2010 10:21:11 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> The issue of how to prevent a page from being modified as it is
>> written out (due to signing in our case) has been discussed on lkml =
a
>> few times (e.g. T10 block devices). =A0 We should hold off on changi=
ng
>> this until we have a way of handling the case of: =A0 we calculate t=
he
>> signature, but just before the page in the cache is remodified, we
>> send it with the wrong signature ... obviously if we reissue the wri=
te
>> we are fine (the data is fine) but there may be better ways to lock
>> the page (and some suggestions have been made on lkml for similar
>> sounding problems).
>>
>
> This behavior has been "Experimental" for years. At what point do we
> remove this kludge? Who in their right mind is going to turn on a
> switch called "Experimental" to enable this? As a user, I'd certainly
> be reticent to do so. It's not clear what turning on "Experimental"
> would give me.

20%+ better write performance

> If you think this behavior deserves to be switchable then let's put a
> real usable switch on it. I don't think it ought to be hidden
> as /proc/fs/cifs/Experimental. Perhaps a module parameter for
> this would be more appropriate?

Probably best to work through how to fix the general issue on fsevel
(ie how to write a presumably unstable page from the cache out)



--=20
Thanks,

Steve
