From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 2.6.36-rc3 NULL pointer dereference crypto_destroy_tfm+0x50/0x70
Date: Mon, 6 Sep 2010 09:28:18 -0500
Message-ID: <AANLkTin-NCqpaeOHw=EVFsNUg5zAJ_29ikLn3uiFLD8r@mail.gmail.com>
References: <AANLkTinM5N-MOO9fZT9+P3YARwWrfGS+ZFdHGHEoybqs@mail.gmail.com>
	<20100905084504.7dae4e13@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andrew Hendry <andrew.hendry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100905084504.7dae4e13-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Sep 5, 2010 at 7:45 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Sun, 5 Sep 2010 18:30:46 +1000
> Andrew Hendry <andrew.hendry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Started hitting this since rc3.
>>
>> System has 6 cifs mounts from the one server, during shutdown they get
>> unmounted and gives this error.
>> If manually unmounting one at a time with a gap inbetween it doesn't
>> seem to happen.
>>

yes - as Jeff indicated, a part of the cifs kernel crypto patches has problems.
Key question is whether it is better to back out the fix until next release
(which also will remove the change which moved cifs to using the kernel
crypto routines) or take Shirish's fixes for the problem you describe.



-- 
Thanks,

Steve
