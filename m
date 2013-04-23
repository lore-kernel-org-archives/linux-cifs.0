From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: add support for IPv6 addresses in brackets V2
Date: Tue, 23 Apr 2013 09:26:32 -0500
Message-ID: <CAH2r5ms4pcD--VzekvfoOL9WU-hS1KEFB2OZVmkb1z8aekhwGg@mail.gmail.com>
References: <1365963558-20082-1-git-send-email-scott.lovenberg@gmail.com>
	<1366075789-23137-1-git-send-email-scott.lovenberg@gmail.com>
	<CAFB9KM00JWSUSP28LrzJsgQ0po6ZtTpK9enbwv3-N5y2+E5G0A@mail.gmail.com>
	<20130422110907.4e684579@tlielax.poochiereds.net>
	<CAFB9KM2QWUZrF-Bj5gkKqHiybYcFB5gskqGqRRsOQ8aGQC6WBw@mail.gmail.com>
	<20130423100114.2146f72a@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130423100114.2146f72a-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Apr 23, 2013 at 9:01 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, 23 Apr 2013 08:34:14 -0400
> Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Mon, Apr 22, 2013 at 11:09 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>> >> Ping.
>> >> Any comments?
>> >>
>> >
>> > I guess I don't quite understand why we need this patch. For NFS it's
>> > pretty clear that we would since ':' has always served as the delimiter
>> > between the hostname and the pathname.

I am ok with the idea of adding additional support that looks more
like what an NFS user is comfortable with.   Ideally a user should be
able to type very similar mount commands for cifs/smb3 and NFSv3/v4
etc.

Scott,
Can you give a list of an example of these - mounts with each of the
IPv6 formats that work (and what doesn't work) along with the one you
propose?

>> > For CIFS, not so much... IPv6 addresses typically don't have '/' or '\\'
>> > characters in them, so why do we need to wrap them in []?
>> >
>> > Note that this syntax doesn't follow what Windows does either, AFAIK.
>> > There, you need something like this since UNC paths can't contain ':'
>> > characters (and maybe also '%'):
>> >
>> >     http://www.samba.org/~idra/code/nss-ipv6literal/README.html
>> >
>> > ...we have no such restriction under Linux though.
>> >
>>
>> I liked this approach for two reasons.  It handles a convention for
>> IPv6 formatting that is used that we don't support and allows us to
>> (in the future) parse an address from the path instead of having to
>> use --ip=, which I feel is a bit cumbersome. Originally I was going
>> to just put in support for something like "mount.cifs
>> //IPv6Address/share /mnt/path" right away, but I wanted to get this
>> part in first.
>>
>
> Again, I'm confused...this sort of syntax seems to work just fine
> already:
>
>     # mount -t cifs //fecd::1/share /mnt/cifs -o sec=none,multiuser
>
> Also, --ip= is not a valid option in the longopts[] array in
> mount.cifs (maybe you mean -o ip=). I still don't see what benefit we
> receive from allowing someone specify addresses inside of square
> brackets.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>



-- 
Thanks,

Steve
