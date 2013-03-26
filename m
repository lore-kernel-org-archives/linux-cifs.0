From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Enhancement needed to UNIX extensions to correctly support Linux EA's.
Date: Tue, 26 Mar 2013 16:28:36 -0500
Message-ID: <CAH2r5msU86Q0_PbiqZCf729hDkX9o0e_jYh87d=T8wmQKsYHHg@mail.gmail.com>
References: <20130326212242.GA4391@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130326212242.GA4391@samba2>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Seems like a reasonable request.   What version of kernel do you want
me to give you some test patches for?

On Tue, Mar 26, 2013 at 4:22 PM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> See bug https://bugzilla.samba.org/show_bug.cgi?id=9743
>
> No way to set zero length EA's with CIFS vfs.
>
> I was doing some investigations around bug #9130, where Windows fails to copy a
> file when we return a zero-length EA associated with it.
>
> Looking carefully into this this is a deficiency in the CIFS UNIX protocols. On
> Linux it's possible to set a zero-length EA on a file/directory as a tag of
> some kind, with no associated data.
>
> On Windows this is impossible - trying to set a zero-length EA will just delete
> it, plus the EA names are case insensitive (and always returned uppercase).
>
> We need to add a UNIX_GET_EAS call that can return all POSIX EA's without
> mangling case, and can also return zero-length EA's, also we need a
> UNIX_SET_EAS call that can set a zero length EA, and also has an additional
> 'flags' field that can delete an EA if set.
>
> Please discuss,
>
> Jeremy.



-- 
Thanks,

Steve
