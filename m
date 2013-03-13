From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: mount.cifs error code docs?
Date: Wed, 13 Mar 2013 10:23:19 -0400
Message-ID: <20130313102319.75bae46d@tlielax.poochiereds.net>
References: <1355872616.69791.YahooMailNeo@web160302.mail.bf1.yahoo.com>
	<20121219090322.3999f995@tlielax.poochiereds.net>
	<1355944553.61735.YahooMailNeo@web160303.mail.bf1.yahoo.com>
	<1355945432.81847.YahooMailNeo@web160302.mail.bf1.yahoo.com>
	<20121220093806.537c2496@corrin.poochiereds.net>
	<20121223091034.5e313ee1@tlielax.poochiereds.net>
	<20121224091421.63d0df23@tlielax.poochiereds.net>
	<1356740676.4446.21.camel@deadeye.wl.decadent.org.uk>
	<20121228220150.72686551@corrin.poochiereds.net>
	<00B45E92-FB38-4E36-A409-58712E7BB8A7@exacq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Matthew M. DeLoera" <mdeloera-CERpylIU+L8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00B45E92-FB38-4E36-A409-58712E7BB8A7-CERpylIU+L8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 13 Mar 2013 10:00:10 -0400
"Matthew M. DeLoera" <mdeloera-CERpylIU+L8AvxtiuMwx3w@public.gmane.org> wrote:

> Hello,
> 
> I've been searching to find a list of return codes from mount.cifs, with no luck. They're not listed in the manpage. I can google individual errors, but I'm hoping for something like a list of all possible errors. Or at least the most common ones.
> 
> Short of looking at code, is there any possibility that someone's documented details on something like causes for error code 5? Or other return values?
> 
> Any suggestions would be most appreciated!
> 
> Best regards,
> - Matthew--

Like most mount helpers, the return codes are typically what the kernel
returns on the mount() syscall. Error code '5' is likely EIO, which is
a very generic error.

Cranking up debugging may give you more info as to what went wrong:

    https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
