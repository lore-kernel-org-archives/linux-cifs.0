From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] cifs: Enable Kconfig control of CIFS_DEBUG
Date: Fri, 30 Nov 2012 09:42:23 -0600
Message-ID: <CAH2r5muTL6=uDchOe9QrPLfWw4uCzkyb36nt+AVWTx8ZHroPtQ@mail.gmail.com>
References: <cover.1354217746.git.joe@perches.com>
	<5f5c9196b44908026a27333ef31dd4ebf4314de2.1354217746.git.joe@perches.com>
	<20121130065629.52c489dc@tlielax.poochiereds.net>
	<1354287460.11903.8.camel@joe-AO722>
	<20121130100705.782980df@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121130100705.782980df-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Nov 30, 2012 at 9:07 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 30 Nov 2012 06:57:40 -0800
> Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org> wrote:
>
>> On Fri, 2012-11-30 at 06:56 -0500, Jeff Layton wrote:
>> > On Thu, 29 Nov 2012 11:37:20 -0800
>> > Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org> wrote:
>> >
>> > > Rather than havign a permanently enabled #define, allow
>> > > control over it.
>> > >
>> > > This can reduce the size of the module by ~100KB which
>> > > could be useful for embedded systems.
>> []
>> > > diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
>> > > index 4d12fe4..6867a7f 100644
>> > > --- a/fs/cifs/cifs_debug.h
>> > > +++ b/fs/cifs/cifs_debug.h
>> > > @@ -18,7 +18,10 @@
>> > >   *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
>> > >   *
>> > >  */
>> > > -#define CIFS_DEBUG               /* BB temporary */
>> > > +
>> > > +#ifdef CONFIG_CIFS_DEBUG
>> > > +#define CIFS_DEBUG
>> > > +#endif
>> > >
>> > >  #ifndef _H_CIFS_DEBUG
>> > >  #define _H_CIFS_DEBUG
>> >
>> > Looks fine, but I'd probably prefer to just get rid of CIFS_DEBUG
>> > altogether here and replace it with CONFIG_CIFS_DEBUG.
>>
>> I wasn't sure if there was other code anywhere else that depends
>> on CIFS_DEBUG.  There isn't any in the kernel source tree.  If not,
>> then you are right, it should be just CONFIG_CIFS_DEBUG.
>>
>
> There shouldn't be. None of this stuff is exposed to userspace, AFAIK.
> I think it's ok to just make that CONFIG_CIFS_DEBUG.
>
>> > While you're at it, /proc/fs/cifs/cifsFYI should probably not be
>> > present when CONFIG_CIFS_DEBUG isn't set. Perhaps we should also
>> > disable traceSMB and its related functions too in that case?
>>
>> That could be considered a kernel api change.
>> If people agree to delete it, I'd be OK with it.
>>
>
> If you compile with CONFIG_CIFS_DEBUG turned off, then the cifsFYI file
> will be a knob that's not hooked up to anything. I think it's best not
> to present it at all in that case.
>
> traceSMB is a little harder to make the case for. Theoretically, it'll
> still work after your changes, but I'm not sure it makes sense to leave
> that knob around since it's technically a flag for debugging. You're
> probably fine not to worry about that one. I'll look at that at some
> point in the future.

I think it is fine to leave the traceSMB around with debug config flag
off - it is not strongly related to cERROR and cFYI and is small.


-- 
Thanks,

Steve
