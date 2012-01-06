From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs speed problems
Date: Fri, 6 Jan 2012 13:52:18 -0600
Message-ID: <CAH2r5mtzsHEN2Z6W2VUPxYpViF5HOKofqrJaKaKeW+q3J8UMZQ@mail.gmail.com>
References: <4EFDE456.5040108@inf.ethz.ch>
	<20120102064838.682c2c70@tlielax.poochiereds.net>
	<4F074BB8.90302@inf.ethz.ch>
	<20120106144140.239a83bc@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Benjamin Schindler <bschindler-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120106144140.239a83bc-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jan 6, 2012 at 1:41 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, 6 Jan 2012 20:30:00 +0100
> Benjamin Schindler <bschindler-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org> wrote:
>
>> Hi
>>
>> Ah, I thought its already in 3.1 - I just tried and its much better.=
 I
>> can now do the same transfer in about 9 seconds. nfs is with 7-8 sec=
s
>> still faster, but I think I can live with that
>>
>> Thank you
>> Benjamin
>>
>> On 02.01.2012 12:48, Jeff Layton wrote:
>> > On Fri, 30 Dec 2011 17:18:30 +0100
>> > Benjamin Schindler<bschindler-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org> =A0wrote:
>> >
>> >> When copying from nas to a windows machine, I get a
>> >> healthy 80-100mb/sec.
>> > You may want to try a 3.2-rc kernel. We just added async read supp=
ort in
>> > 3.2 which should increase throughput.
>> >
>>
>
> (re-cc'ing linux-cifs list)
>
> No problem. Unfortunately, we're somewhat hamstrung by the protocol
> when talking to standard cifs servers, so there's not a lot we can
> do to make it go faster.
>
> Depending on the number of concurrent requests that the server will
> allow, you may be able to get the speed up even more.
>
> Once Steve does his promised patch to make the client respect the
> MaxRequests value that the server sends during the protocol
> negotiation, that may increase the concurrency and hence the throughp=
ut.

Thanks for reminding me ... I would like to propose that the patch
- honor the cifs max mpx (usually 50, but 10 for some windows workstati=
ons),
but require maxmpx of at least two (or three).
- treat the minimum of the negotiated maxmpx and the insmod parm
"cifs_max_pending" as the limit on simultaneous requests on any socket
- perhaps raise cifs_max_pending to a more reasonable value (100?) to
benefit those servers which allow more parallelism, and to recognize
that
for smb2 significantly more requests in flight will be common (smb2
does not negotiate a maxmpx, but with its "credit" mechanism on every
request
it would be common to exceed 50 in flight)

Thoughts?


--=20
Thanks,

Steve
