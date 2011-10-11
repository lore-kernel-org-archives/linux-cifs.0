From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Purpose of GLOBAL_EXTERN macro
Date: Tue, 11 Oct 2011 09:17:58 -0500
Message-ID: <CAH2r5mtyamN8MS9ijM2kCBRk4wvop+ba0-TBjH-xfbthaMtsBA@mail.gmail.com>
References: <4E940EF9.7030603@suse.com>
	<20111011070821.6c153d53@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111011070821.6c153d53-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 11, 2011 at 6:08 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, 11 Oct 2011 15:10:09 +0530
> Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
>
>> I bumped into the GLOBAL_EXTERN macro in the cifs code. I'm not sure I
>> understand the purpose of this. Can someone explain why we need this
>> instead of simply using "extern"?
>>
>
> I've never been quite sure what that's all about either. I think the
> idea was to allow you to put global declarations in an include file but
> then have only one .c file actually do them?
>
> Seems like there was a patch to remove it a few years ago, but Steve
> never merged it for some reason...

The idea of having all of the globals in one place was an idea
borrowed from other file systems in the past.  Basically,
having all of the globals in one place made it easier
to identify locking issues and make future locking changes.
We could take all of the global externs and do the equivalent, ie
(put them in cifsfs.c in one big series of defines in the beginning of
the file).
It would make cifsfs.c bigger, and perhaps a little harder to read,
but otherwise would do the same thing.   If it weren't for the spurious sparse
warning, it would be easier.  If others feel strongly about making cifsfs.c
a little longer to avoid the sparse error by removing the macro - I'll take
a patch to remove it, but not sure it matters much the code size would
be the same.

I was fairly certain that a few other file systems in Linux had a global extern
macro or equivalent, but probably  removed it due to sparse throwing warnings.


-- 
Thanks,

Steve
