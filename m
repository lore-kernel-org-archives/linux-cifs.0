From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 2/8] CIFS: Respect create_options in smb2_open_file
Date: Wed, 10 Jul 2013 20:22:34 +0400
Message-ID: <CAKywueQgSG=At_9KX17SfWN_tjTr0ECc3DPqJakX09W_RWiCFA@mail.gmail.com>
References: <1373450401-4135-1-git-send-email-pshilovsky@samba.org>
	<1373450401-4135-3-git-send-email-pshilovsky@samba.org>
	<CAH2r5mtvpFs8un95EkNWZLptifoExrm1bJ30UbHi-DEb1ENWxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtvpFs8un95EkNWZLptifoExrm1bJ30UbHi-DEb1ENWxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/7/10 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Won't we need the file attributes parm on SMB2 create to pass in on
> the call to create symlink (where we have to pass that it is a reparse
> point)?

It will be used for symlinks but now it does nothing. The further
patches add cifs_open_parms structure that makes it easier to extend
params list for SMB2_open syscall (by adding new field to this
struct).

--
Best regards,
Pavel Shilovsky.
