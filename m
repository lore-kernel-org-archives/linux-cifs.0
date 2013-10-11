From: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 2/2] Allow setting per-file compression via SMB2/3
Date: Fri, 11 Oct 2013 12:57:11 +0200
Message-ID: <5257D987.3090709@samba.org>
References: <CAH2r5mvHo4v4uKQfFc-vPtnYt1E8OvbhspskdfNezMbyYFq5KA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvHo4v4uKQfFc-vPtnYt1E8OvbhspskdfNezMbyYFq5KA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Am 11.10.2013 05:00, schrieb Steve French:
> Allow cifs/smb2/smb3 to return whether or not a file is compressed
> via lsattr, and allow SMB2/SMB3 to set the per-file compression
> flag ("chattr +c filename" on an smb3 mount).
> 
> A followon patch will do this for cifs
> 
> Windows users often set the compressed flag (it can be
> done from the desktop and file manager).  David Disseldorp
> has patches to Samba server to support this (at least on btrfs)
> which are complementary to this.
> 
> As Metze suggested I split out the part of the patch
> which fixed up the length calculation in the
> SMB2_ioctl worker function as it is more general
> and not compression specific enablement (I
> just noticed the problem when doing this patch).

Thanks!

metze
