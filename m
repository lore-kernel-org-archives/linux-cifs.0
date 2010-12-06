From: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: cifs client timeouts and hard/soft mounts
Date: Mon, 06 Dec 2010 12:54:30 -0600
Message-ID: <4CFD3166.4000800@samba.org>
References: <20101203212811.17594274@tlielax.poochiereds.net>	<E1POnFL-00BKfp-6h@intern.SerNet.DE>	<AANLkTi=MCgZb=we2OEtxJ4DZ==sVmRLd8aQKeMU7vvKt@mail.gmail.com>	<20101205210634.602b076b@corrin.poochiereds.net>	<AANLkTik4Vh5hqWwVngjCC7v1ST1YxAP9LvQbcqKDhWHp@mail.gmail.com>	<E1PPSnw-00DDbs-Va@intern.SerNet.DE>	<AANLkTinPw8M6XaMvMQ_VMxdk7j8PDqdpjzKLgDMxPf1n@mail.gmail.com>	<4CFD16D8.4090207@samba.org> <20101206124255.7ea8a8a9@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org,
	cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101206124255.7ea8a8a9-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton wrote:
> On Mon, 06 Dec 2010 11:01:12 -0600
> "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 
>> Question (for which I do not have an answer):  How much work do you want to
>> do to make their intentionally broken model work?
>>
> 
> Very little...live by the sword, die by the sword :)
> 
> I'm not opposed to trying to work around this sort of brokenness, but
> not at the expense of more conventional configurations.
> 
> If the proxy keeps responding to echoes regardless of what happens on
> the server side of its connection then that sounds really broken to me.
> Does it do nothing to detect whether the server is still around? I don't
> see a way for us to detect such a broken device if not.

There are a lot of companies out there that do WAN acceleration and each of
them do things differently, so there is no good answer to your quite
rational question.  Some of the vendors are very focused on "just like the
real thing" behavior while others are willing to compromise behavior in
favor of acceleration.

The best-known product in this market would be Riverbed.  BlueCoat is
another, I think.

Chris -)-----

-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh-zuGDro9SezXYtjvyW6yDsg@public.gmane.org
