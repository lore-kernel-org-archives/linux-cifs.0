From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Tunable timeout in cifs module.
Date: Tue, 20 Oct 2015 12:21:05 -0500
Message-ID: <CAH2r5muCJ18-94iTR7kDhoxn9C3q62qR+Vk_JyumQHugRmJ3KA@mail.gmail.com>
References: <1445329210.10711.13.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445329210.10711.13.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 20, 2015 at 3:20 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Hello Steve/linux-cifs,
>
> We have received a request to make the timeout in the cifs module
> tunable.
>
> I have gone through the code to understand timeouts in the cifs client.
> http://sprabhu.blogspot.in/2015/08/investigation-into-effects-of-server
> .html
>
> The way to allow user settable timeout values is to make the value of
>  SMB_ECHO_INTERVAL tunable. Do you think this is a good idea?

Seems like a reasonable idea - although we might want to treat this
differently for the case (longer timeouts? or different retry
behavior?) for the case of CA shares (or mounts with persistent handle
or resilient handle mount parms - the patches that I sent out a few
weeks ago). We also need to clean up reconnect behavior (byte range
lock recovery) and make sure for the persistent handle case (and
presumably resilient handles too) that we reopen all files on the
mount on reconnect.



-- 
Thanks,

Steve
