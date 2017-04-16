From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v2] Call echo service immediately after socket reconnect
Date: Sun, 16 Apr 2017 20:43:16 +0100
Message-ID: <1492371796.7926.2.camel@redhat.com>
References: <1477007544-4656-1-git-send-email-sprabhu@redhat.com>
         <CANwerB1NH=D3NKz_A3pxg+aty9U4P66b5Lo3KAqOBTLKDEAkew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Jonathan Liu <net147-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANwerB1NH=D3NKz_A3pxg+aty9U4P66b5Lo3KAqOBTLKDEAkew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 2017-04-16 at 01:38 +1000, Jonathan Liu wrote:
> Hi Sachin,
> 
> On 21 October 2016 at 10:52, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
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
> > 
> > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> 
> This commit is causing a flood of connections to Samba server as well
> as high server CPU load when the Samba is restarted while CIFS share
> is mounted on the client. This can cause the Samba server to become
> slow or unresponsive resulting in denial of service to other users
> connected to the Samba server.
> 
> Bug report: https://bugzilla.kernel.org/show_bug.cgi?id=194531
> 
> Could you please have a look?
> 
> Thanks.
> 
> Regards,
> Jonathan

Hello Jonathan,

Thanks for bringing this to my attention. I've posted a patch to the
list. I've tested it out with the reproducer. Can you please test it
out  in your setup and let me know if it works for you.

Sachin Prabhu
