From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Question on IPv6 failover.
Date: Thu, 3 Oct 2013 17:30:55 -0500
Message-ID: <CAH2r5mtirrcvkqQho7QvMDJ8eZWGT5Q2S9w=GLKuGiwM1z29GQ@mail.gmail.com>
References: <524DDBF7.5050709@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <524DDBF7.5050709-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 3, 2013 at 4:04 PM, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:
> One of our users is reporting that the CIFS failover case is not working
> properly.  They have a cluster of CIFS servers that migrate an IPv6 addr
> to the active system.
>
> Evidently, our client-side CIFS connection follows the first migration,
> but fails to go back to the original on a second failover.
>
> It could be any number of things, but I wanted first to see if anyone
> knows how long client-side CIFS will keep attempting to regain contact with
> it's
> server?  Forever?
>
> Thanks,
> Ben

Depends on kernel version and also hard vs. soft (default) mount options.

The "smb echo" approach that cifs moved to a few years ago allows
the cifs kernel client to notice more quickly that the server is down,
and significantly improved failover.

Which kernel version?


-- 
Thanks,

Steve
