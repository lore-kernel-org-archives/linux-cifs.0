From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Question about howto test notify with a fuse fs.
Date: Thu, 10 May 2012 05:03:59 -0500
Message-ID: <CAH2r5mseZhACM=ji2sbV5peJ=AG=imR0eNrP2cZjLPCySA6XqA@mail.gmail.com>
References: <CANXojcznM1pMJO5pe7TXV1qED89J0+SdSz59yfwWJganZP896g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANXojcznM1pMJO5pe7TXV1qED89J0+SdSz59yfwWJganZP896g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

smbclient is not SMB2 aware yet.

We could probably provide an ioctl for this in the short term based on
Pavel's smb2 tree.  See smb2-dev branch of pavel's git tree for
cifs.ko

http://git.altlinux.org/people/piastry/public/cifs-2.6.git?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev

On Thu, May 10, 2012 at 4:22 AM, Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi,
>
> earlier we spoke about monitoring SMB shares with cifs for file changes.
>
> I've posted a question on samba-technical howto send a
> SMB2_CHANGE_NOTIFY message to the server using smbclient:
>
> https://lists.samba.org/archive/samba-technical/2012-May/083472.html
>
> No reaction so far. I'm interested cause there are fuse fs's like
> fusesmb (using libsmbclient) to
> provide access to SMB shares. For me it's very easy to test notifyfs,
> easier than cifs.
> Do you maybe know howto send a message like that (and receive) using
> libsmbclient?
>
> Stef



-- 
Thanks,

Steve
