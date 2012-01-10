From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] cifs: allow multiuser mounts with authtypes besides krb5
Date: Tue, 10 Jan 2012 16:06:16 +0100
Message-ID: <CANXojcwAqs6291TF76Ghzofyms6YKwB1Yh8wYuUbOJ2XeSppqQ@mail.gmail.com>
References: <1325855483-8846-1-git-send-email-jlayton@redhat.com>
	<CADT32eJ2cW1wvQG2NpkEqQ5ZwDAHByUv9p-ZsG+NjVtsxEF8zg@mail.gmail.com>
	<20120106124917.567489ba@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120106124917.567489ba-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/1/6 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:

>> Would users be able to put their username for a particular domain name
>> and server address as well as server name?
>> Was not clear from the description whether it was just the server address
>> or name as well!
>>
>
> You can add keys a particular host or NT domain name. If it's a host
> key, then the userspace tool will add a key for each address that it
> resolves for the hostname. For a domain key, it's treated as a string
> literal and the kernel will use the domain= mount option to construct
> the key description.
>

"You can add keys... "

How?? Userspace tool?

I will test this.

Stef
