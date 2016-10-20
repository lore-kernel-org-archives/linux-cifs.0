From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Call echo service immediately after socket reconnect
Date: Thu, 20 Oct 2016 19:55:50 -0400
Message-ID: <1477007750.4752.3.camel@redhat.com>
References: <1476969267-22325-1-git-send-email-sprabhu@redhat.com>
         <CAKywueQ=L5MunfYLGJ6NqBUq5fLbLuM5A7f93Kym+u7sqdm0OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQ=L5MunfYLGJ6NqBUq5fLbLuM5A7f93Kym+u7sqdm0OQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2016-10-20 at 13:30 -0700, Pavel Shilovsky wrote:
> 2016-10-20 6:14 GMT-07:00 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > 
> > Commit 4fcd1813e640 ("Fix reconnect to not defer smb3 session
> > reconnect
> > long after socket reconnect") changes the behaviour of the SMB2
> > echo
> > service and causes it to renegotiate after a socket reconnect.
> > However
> > under default settings, the echo service could take up to 120
> > seconds to
> > be scheduled.
> > 
> > The patch forces the echo service to be called immediately
> > resulting a
> > negotiate call being made immediately on reconnect.
> 
> Looks like a right thing to do. Comments are inlined below:
> 
> > 
> > ..
> > +       if (server->tcpStatus == CifsNeedNegotiate)
> > +               echo_interval = 0;
> 
> Suppose we are setting echo_interval to 0 above
> 
> > 
> > 
..
> then we are sending an echo message and re-queue the echo work with
> echo_interval==0:
> 
> rc = server->ops->echo ? server->ops->echo(server) : -ENOSYS;
> ....
> queue_delayed_work(cifsiod_wq, &server->echo, echo_interval);
> 
> Shouldn't we queue the echo work with server->echo_interval (not 0)
> here?
> 

Hello Pavel,

Yes, you are right. I had overlooked the second echo_interval in the
function. I've sent a version 2 of the patch.

Sachin Prabhu
