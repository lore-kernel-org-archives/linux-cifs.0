From: "Matthew M. DeLoera" <mdeloera-CERpylIU+L8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mount.cifs error code docs?
Date: Thu, 14 Mar 2013 20:44:26 -0400
Message-ID: <4F67DACB-685D-4F93-AF98-B2630EB937A9@exacq.com>
References: <1355872616.69791.YahooMailNeo@web160302.mail.bf1.yahoo.com> <20121219090322.3999f995@tlielax.poochiereds.net> <1355944553.61735.YahooMailNeo@web160303.mail.bf1.yahoo.com> <1355945432.81847.YahooMailNeo@web160302.mail.bf1.yahoo.com> <20121220093806.537c2496@corrin.poochiereds.net> <20121223091034.5e313ee1@tlielax.poochiereds.net> <20121224091421.63d0df23@tlielax.poochiereds.net> <1356740676.4446.21.camel@deadeye.wl.decadent.org.uk> <20121228220150.72686551@corrin.poochiereds.net> <00B45E92-FB38-4E36-A409-58712E7BB8A7@exacq.com> <20130313102319.75bae46d@tlielax.poochiereds.net>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130313102319.75bae46d-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff,

Thanks for the info. I should clarify that it's not that I've got an error. I'm trying to document expected error codes for my project.

Though I am doing some testing to assemble at least some error cases and associated codes. Agreed about error 5 in this case, though was hoping there might be some sort of list out there somewhere about at least some of the various CIFS failures that get rolled together under error 5.

Best regards,
- Matthew


On Mar 13, 2013, at 10:23 AM, Jeff Layton wrote:

> On Wed, 13 Mar 2013 10:00:10 -0400
> "Matthew M. DeLoera" <mdeloera-CERpylIU+L8AvxtiuMwx3w@public.gmane.org> wrote:
> 
>> Hello,
>> 
>> I've been searching to find a list of return codes from mount.cifs, with no luck. They're not listed in the manpage. I can google individual errors, but I'm hoping for something like a list of all possible errors. Or at least the most common ones.
>> 
>> Short of looking at code, is there any possibility that someone's documented details on something like causes for error code 5? Or other return values?
>> 
>> Any suggestions would be most appreciated!
>> 
>> Best regards,
>> - Matthew--
> 
> Like most mount helpers, the return codes are typically what the kernel
> returns on the mount() syscall. Error code '5' is likely EIO, which is
> a very generic error.
> 
> Cranking up debugging may give you more info as to what went wrong:
> 
>    https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting
> 
> -- 
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
