From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] cifs: show features compiled in as part of DebugData
Date: Fri, 30 Jul 2010 09:39:04 -0500
Message-ID: <AANLkTikgA8mXTcX-i3avjuQygrekicntcy3P2NBW5QuB@mail.gmail.com>
References: <1280494556.19538.7.camel@jay-t60p>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280494556.19538.7.camel@jay-t60p>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If someone ever wants a script to parse this - seems like your
(original?) idea of putting this in /proc/fs/cifs/features instead of
/proc/fs/cifs/DebugData (which has various other pieces of debug
information) could be easier.

On Fri, Jul 30, 2010 at 7:55 AM, Suresh Jayaraman <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org> wrote:
> Fixed the nit pointed out by Jeff.
>
> From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> Subject: [PATCH 1/2] cifs: show features compiled in as part of DebugData
>
> This patch adds the features that are compiled in to the CIFS debugging data
> as shown below:



-- 
Thanks,

Steve
