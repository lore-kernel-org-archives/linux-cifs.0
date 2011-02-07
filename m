From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] cifs: don't perform SMB echoes on un-negotiated socket
Date: Mon, 7 Feb 2011 11:42:05 -0600
Message-ID: <AANLkTi=zs7KZjTnysqxpnGam+2Mv3FRTCKZcY8fB0uFU@mail.gmail.com>
References: <1297086876-19165-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jg-9fI4heB6ewM@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1297086876-19165-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Feb 7, 2011 at 7:54 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Commit 247ec9b4 makes the SMB echo workqueue job skip doing echoes
> unless the tcpStatus == CifsGood. Problem: tcpStatus == CifsGood is not
> a reliable indicator of whether the socket has had a NEGOTIATE done on
> it. This fixes that by adding a new tcpStatus of CifsNeedNegotiate that
> indicates this. It also cleans up cifs_reconnect_tcon a bit.
>
> This is not the only way to fix this issue. As Steve pointed out to me,
> we could also check to see whether there's a valid SMB session on the
> list as an indicator of whether a NEGOTIATE has been done. I think the
> approach I'm proposing clarifies the code better, but I'm willing to go
> with his approach if that's the general concensus.

Jeff may be right that the code is clearer with this approach (I may try
to code the alternative to check) but ... we really shouldn't be sending
an SMBecho between negprot and sessionsetup anyway (so checking for
sessionsetup may make sense).  If a negprot times out or
sessionsetup times out we don't need to be sending SMBecho
(on the other hand perhaps a really slow krb5 sessionsetup?)
Once a sessionsetup is sent, SMBechos make more sense.

-- 
Thanks,

Steve
