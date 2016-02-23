From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Interop Issue: SMB2+ async replies, and the kernel, Samba side
 fix enclosed.
Date: Tue, 23 Feb 2016 08:28:45 -0600
Message-ID: <CADT32e+Roo2WrgLtH2OharfVX77pPsFhgpuFi_1e6rZNhJ6nSQ@mail.gmail.com>
References: <CAAPGDwLnp90t7wiRb_tw-Md0jv-8w0Ye66jNcsRNioganVe2xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Samba Technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	sfrench <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Ira Cooper <ira-mA6sH8tAw6XR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAPGDwLnp90t7wiRb_tw-Md0jv-8w0Ye66jNcsRNioganVe2xg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I think the course of action on cifs client should be realize this is
in interim response
and drop it without percolating up and wait for the real reply.
Looking into that...

Regards,

Shirish

On Tue, Feb 23, 2016 at 6:55 AM, Ira Cooper <ira-mA6sH8tAw6XR7s880joybQ@public.gmane.org> wrote:
> If the server sends an interim response, then the real response, the real
> response, is handled by standard_receive3() in the kernel, instead of the
> proper function, and this causes a disconnect.  If there isn't a
> disconnect, I believe the reply will just be discarded if I understand the
> code correctly.  (That is a big if here ;) )
>
> I've written a patch for Samba to stop sending interim replies on SMB2_READ
> and SMB2_WRITE, when non-compounded to stop the impact of this issue.  We
> may want to add SMB2_CREATE to the list of ops we don't send async replies
> for non-compounded, but I'm not sold either way, I know we CAN go async
> there!  I want some opinions here.
>
> This is not hidden behind a flag because compatibility issues that don't
> impact protocol correctness usually aren't.
>
> Setting req->async_te = talloc_new(NULL); is just ugly, though it works.
> If you have a cleaner approach, I welcome it.
>
> I request you please ASK me before pushing this one, yes, that means you
> jra!
>
> For those interested in reproduction: I'd suggest using a server that's
> rebuilt with a lower timeout set in smb2_read.c, though we've hit it with
> vfs_glusterfs straight up, in our testing.
>
> Thanks,
>
> -Ira / ira@(samba.org|redhat.com|wakeful.net)
