From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: file truncation on newer linux-cifs versions
Date: Sun, 15 Jan 2012 07:31:35 -0500
Message-ID: <20120115073135.79a52645@corrin.poochiereds.net>
References: <20120113230701.GA3100@gwdu05.gwdg.de>
	<CAOhYWN+dLLKXs6MU3W88oHzyFgi1KV+7oh1qPh61ZEqUA-Jw8w@mail.gmail.com>
	<20120114135057.GA4197@gwdu05.gwdg.de>
	<20120114093322.7e36221d@tlielax.poochiereds.net>
	<20120114153041.GA11000@gwdu05.gwdg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mscholz5-2/1ofaGcC4w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120114153041.GA11000-b2CffKLTPqzm5j4aBFDdOg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 14 Jan 2012 16:30:41 +0100
Mirko Scholz <mscholz5-2/1ofaGcC4w@public.gmane.org> wrote:

> > To a degree...
> > 
> > [...]
> 
> Thanks for the information.  And sorry that you must repeat yourself.
> It is actually the same as
> https://bugzilla.samba.org/show_bug.cgi?id=8559 
> 
> Maybe one should add "Try again using wsize=65536" to
> http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting
> for the time beeing.
> 

(re-cc'ing linux-cifs)

No problem.

Not a bad idea. I'll plan to add a FAQ or known problems section or
something soon.

That said, I'd prefer it if cifs.ko used a default wsize that was more
or less guaranteed to work with any server in the field, and allowed
people to set it higher if they know their server is able to handle it.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
