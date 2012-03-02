From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs oplock windows share
Date: Fri, 2 Mar 2012 11:43:11 -0500
Message-ID: <20120302114311.59022036@tlielax.poochiereds.net>
References: <790056146.218351.1330179815970.JavaMail.www@wwinf8305>
	<20120228064816.68731aca@tlielax.poochiereds.net>
	<1699379793.34636.1330705303637.JavaMail.www@wwinf8310>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1699379793.34636.1330705303637.JavaMail.www@wwinf8310>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 02 Mar 2012 17:21:44 +0100
"sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org> wrote:

> 
> Thanks for your response.
> 
> I am actually migrating users data from a windows 2008 R2 file server to another windows 2008.
> I fear i don't understand why I have to disable oplocks.
> 

I fear that I don't either. I was just speculating.

> Is the cifs protocol compatible with windows 2008 smb ? 

Yes. I often test against win2k8 and don't see this problem.

> Must I specify max protocol =smb2 in samba ? 

You mean in smb.conf? The cifs client doesn't use that at all. That's
for the samba userspace code. cifs.ko does not support smb2 at this
time. 

> The issue this day:
> Linux Cifs mount on Windows 2008 (via pam_mount): work with oplocks disabled.
> Linux cifs mount on Windows 2008 R2 (via pam_mount): don't seems to work even with oplocks disabled
> (Perhaps thereis another problem on the server but I don't think so)
> 

I can't help much with this since you haven't provided any details.

"works" and "doesn't work" doesn't tell me anything about what's really
wrong. If you say "it failed with this error message" or "I got this
error message in the log when I attempted it", then that may tell us
something.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
