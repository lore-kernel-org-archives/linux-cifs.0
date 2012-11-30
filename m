From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/3] cifs: Make CIFS_DEBUG possible to undefine
Date: Fri, 30 Nov 2012 06:52:09 -0800
Message-ID: <1354287129.11903.3.camel@joe-AO722>
References: <cover.1354217746.git.joe@perches.com>
	 <26f6f4e1a1fb5091784fb1a6919e214994a6dc88.1354217746.git.joe@perches.com>
	 <20121130064919.373547f4@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121130064919.373547f4-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2012-11-30 at 06:49 -0500, Jeff Layton wrote:
> On Thu, 29 Nov 2012 11:37:19 -0800
> Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org> wrote:
> 
> > Make the compilation work again when CIFS_DEBUG is not #define'd.
> > 
> > Add format and argument verification for the various macros when
> > CIFS_DEBUG is not #define'd.
[]
> Would it be better to simply make those the standard
> 
> "do { ; } while(0)" noop macros?
> 
> I'm not sure I see the point in keeping the printk statements in there...

Actually, that's not standard.
Look at printk.h

It prevents developers from adding code that compiles
without warnings in one mode but compiles with warnings
in another.

The idea is to make sure that format and arguments always
match regardless of whether or not you are compiling
debug or non-debug.
