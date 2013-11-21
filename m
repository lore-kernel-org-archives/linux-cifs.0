From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] Fix samba bug #8914
Date: Thu, 21 Nov 2013 11:24:45 -0500
Message-ID: <20131121112445.7d0383e2@tlielax.poochiereds.net>
References: <E1VjSnS-004B9V-Fo@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1VjSnS-004B9V-Fo-dqLtpHMqGvUyWpdLl23E4A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 21 Nov 2013 12:51:43 +0100
Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org> wrote:

> Hi, 
> 
> NetApp sends brocken packages in response to trans2_query_path_info with info 
> level smb_file_all_info as reported at: 
> https://bugzilla.samba.org/show_bug.cgi?id=8914
> 
> The attached patch for cifs 2.01 works around the problem by retrying the 
> operation with info levels basic and standard which yield the same 
> information. 
> 
> Thanks
> Gregor
> 

Could you repost these in the standard way?

One patch per email

Also, inlined in the email instead of as attachments, but we can work
with it if you need to send them as attachments. git-send-email is a
good tool for this, btw...


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
