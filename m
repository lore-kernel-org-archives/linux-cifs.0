From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: remove support for "complex" usernames from mount.cifs
Date: Thu, 3 Jan 2013 14:04:23 -0600
Message-ID: <CAH2r5mtRD85Te3g=G7Ez80NzGgG+36wHsiRnCzszQu9uee1-kQ@mail.gmail.com>
References: <1357214055-24911-1-git-send-email-jlayton@samba.org>
	<CAFB9KM0-BrPcjV8gTW9BV_Awiw5bHbgYr=42smTJWKxCr=Y-PA@mail.gmail.com>
	<20130103142110.269ea0d1@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130103142110.269ea0d1-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I am not as worried about code cleanliness as I am about losing function,
especially as it is sometimes hard to figure out how many users would be
affected by removing function.  I mildly prefer leaving the nfs syntax
if it makes it easier for nfs users to use smb3, but we could make a stub
mount helper that parses nfs syntax and simply calls mount.cifs if you
prefer that approach - in any case I don't feel strongly about nfs syntax.

On the question of domain name - since Samba uses that form for
username (which allows domain and username and password to be overloaded) --
how do samba utilities deal with the conflict you are trying to fix by removing
support for including domain\user%password?

On Thu, Jan 3, 2013 at 1:21 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Thu, 3 Jan 2013 10:10:38 -0500
> Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Thu, Jan 3, 2013 at 6:54 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>> >
>> > In commit 569cfcb3a, we added a warning of the removal for support for
>> > username= options in the form of DOMAIN/username%password. This patch
>> > removes that support as promised prior to the 5.9 release.
>>
>>
>> That makes the code so much cleaner. :)  Next up for 6.0, removing NFS syntax.
>>
>
> It does. That said, I'm not opposed to dropping this patch if
> someone can outline a compelling use-case for this syntax. I don't see
> how this makes anything easier vs. using discrete mount options, but
> I'm willing to reconsider it if there is such a case.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
