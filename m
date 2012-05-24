From: Sergey Urushkin <urushkin-MKmKHxvQ5r6HXe+LvDLADg@public.gmane.org>
Subject: Re: long cifs timeout when share becomes unavailable
Date: Thu, 24 May 2012 16:44:58 +0400
Message-ID: <3b8a8049f2d724bdd621aa5e624d4047@telros.ru>
References: <4FBDD189.6040402@telros.ru>
 <20120524063131.5bc93ecf@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120524063131.5bc93ecf-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton =D0=BF=D0=B8=D1=81=D0=B0=D0=BB 24.05.2012 14:31:
> On Thu, 24 May 2012 10:13:29 +0400
> Sergey Urushkin <urushkin-MKmKHxvQ5r6HXe+LvDLADg@public.gmane.org> wrote:
>>
>>  And I can not see any timeout options for mount.cifs (except acl=20
>> timeout).
>> So, the actual questions are: 1) is there a way to avoid these hangs
>> (analog of 'intr'?) and 2) how can I reduce this unreachable-host=20
>> timeout
>> (analog of 'timeo'?)? Maybe there are some variables in the sources?
>
> You can try setting the echo_retries kernel module parameter to 1,
> which should cut down the wait time to 60s. In 3.4, we've removed
> that parm and it's now set to 1 always. The timeout between echo
> requests (which is how we detect whether the server is still
> responding) is not currently tunable.

That works like a charm, 60s is much better than 5m, thanks a lot. From=
=20
documentation (for kernels before 3.4) it isn't clear what behavior thi=
s=20
parm changes, maybe docs should be fixed some way?
Could you explain to me why SMB_ECHO_INTERVAL is so big by default? Is=20
there any side effect of changing it to, for example, "30"? Does this=20
change means that every 30 secs (twice more often) client will send=20
special packets to the server (even in the case mounted share isn't use=
d=20
by any application at the moment)?
What's about my first question? Could I make ls-like applications=20
interruptible somehow?

Thanks a lot again!

--=20
Best regards,
Sergey Urushkin
