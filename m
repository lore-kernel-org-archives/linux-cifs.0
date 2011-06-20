From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: trivial: cleanup fscache cFYI and cERROR messages
Date: Mon, 20 Jun 2011 11:31:57 -0500
Message-ID: <BANLkTi=8Tuyo5i15Gs=2GirPydcGvz3EuQ@mail.gmail.com>
References: <4DF7804B.8000502@suse.de>
	<20110614120048.7c04567d@corrin.poochiereds.net>
	<4DF87E1D.70802@suse.de>
	<20110615085841.633bb3c3@corrin.poochiereds.net>
	<4DF8AEC5.5030703@suse.de>
	<BANLkTim-T4PKGfsX-XQT5mP1EwLLkDMDwg@mail.gmail.com>
	<4DFEE17D.50000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DFEE17D.50000-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jun 20, 2011 at 12:58 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>=
 wrote:
> On 06/15/2011 08:12 PM, Steve French wrote:
>>
>> The idea of the 1st parameter to cerror was to allow turning off log
>> spam more easily if error turned out to be expected. =A0Gave some
>> flexibility debugging too.
>
> Ok, but still it doesn't allow us to turn off logs in the runtime (ha=
ve
> to be recompiled, right?). OTOH, wouldn't be easier to convert a cERR=
OR
> to cFYI in case if we found if the error is expected or use cifswarn(=
)
> instead?

Presumably could be turned off in a debugger as well.

Originally the idea was that there would be a way to turn off cERROR
(as we do with cFYI) at runtime too - not something that we would need
unless we found log spamming annoying for errors running cifs
mount to a particular buggy server (e.g.) for which we had
not created a workaround yet.

--=20
Thanks,

Steve
