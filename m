From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/5] cifs: fix some bounds checking problems
Date: Wed, 27 Apr 2011 10:06:43 -0500
Message-ID: <BANLkTinzFc5DgUuG9ohRQNGk12PDO7J-uQ@mail.gmail.com>
References: <1303819401-14789-1-git-send-email-jlayton@redhat.com>
	<20110427101740.32be5c28@corrin.poochiereds.net>
	<BANLkTiko7K1HJFjAKfRokmFiWk=+rHe0DA@mail.gmail.com>
	<20110427110404.71b80c29@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110427110404.71b80c29-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Apr 27, 2011 at 10:04 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Wed, 27 Apr 2011 09:59:52 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> I will try to get the remaining cleanup patches (such as the bcc
>> little endian patches) remerged over the next few days - that should
>> make this easier to respin
>>
>
> Does this mean that you do not intend to push this set for 2.6.39?

the bcc cleanup or the recent bounds checking series?

It could make sense for your recent bounds checking patches
to go in - but I thought that you wanted to wait on those till 2.6.40.




-- 
Thanks,

Steve
